import sys
import socket
import numpy as np
import cv2
from PyQt5.QtWidgets import QHBoxLayout,QApplication, QWidget, QPushButton, QVBoxLayout, QLabel, QFileDialog, QMessageBox
from PyQt5.QtGui import QImage, QPixmap
from PyQt5.QtCore import QTimer, Qt, QThread, pyqtSignal
from PyQt5 import QtCore, QtGui
from ultralytics import YOLO

# 设置IP地址和端口号
udp_ip = "192.168.3.3"  # 你要监听的IP地址
udp_port = 32768  # 你要监听的端口号

# 图片参数
image_width = 640
image_height = 480
udp_packet_size = 1280
total_packets = 240

# 创建UDP套接字
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((udp_ip, udp_port))

print(f"Listening for UDP packets on {udp_ip}:{udp_port}")

# 创建用于存储图片数据的缓冲区
image_buffer = np.zeros((total_packets, udp_packet_size), dtype=np.uint8)

class ImageReceiver(QThread):
    image_data_ready = pyqtSignal(np.ndarray)

    def run(self):
        global image_buffer
        global total_packets
        global image_width
        global image_height

        packet_number = 0
        flag = 0

        while True:
            # 接收UDP包
            data, addr = sock.recvfrom(udp_packet_size)

            # 解析UDP包的序号
            packet_number += 1

            # 存储数据到缓冲区的相应位置
            image_buffer[packet_number] = np.frombuffer(data, dtype=np.uint8)
            
            # 先识别与本地计算机协商图片开始传输的UDP包
            if image_buffer[packet_number][0] == 0 and flag == 0:
                packet_number -= 1
                flag = 1
                continue
            # 排除未与计算机约定开始传输就传输图片的UDP包
            if flag == 0:
                packet_number -= 1
                continue
            # 排除丢包
            if image_buffer[packet_number][0] == 0 and flag == 1:
                # mod
                if packet_number != 1:
                    image_buffer = np.zeros((total_packets, udp_packet_size), dtype=np.uint8)

                    packet_number = 0
                    continue
                packet_number -= 1
                continue
            
            # 如果已经接收到所有UDP包，则拼接图片
            if packet_number == total_packets - 1:
                flag = 0
                complete_image = np.concatenate(image_buffer, axis=0).reshape((image_height, image_width))
                rgb_image = cv2.cvtColor(complete_image, cv2.COLOR_BayerBG2BGR)


                # 对帧运行 YOLOv8 推理
                results = model(rgb_image, conf=0.7)
                
                # 在帧上可视化结果
                annotated_frame = results[0].plot()
                

                self.image_data_ready.emit(annotated_frame)

                # 重置缓冲区
                image_buffer = np.zeros((total_packets, udp_packet_size), dtype=np.uint8)
                packet_number = 0

class MyWindow(QWidget):
    def __init__(self):
        super().__init__()
        
        self.initUI()

    def initUI(self):
        self.setWindowTitle('PyQt Example')
        self.setGeometry(100, 100, 800, 480)

        layout = QVBoxLayout()

        # 添加一个按钮用于开始接收数据
        self.startButton = QPushButton('Start', self)
        self.startButton.clicked.connect(self.startButtonClicked)
        layout.addWidget(self.startButton)

        self.saveButton = QPushButton('Save Image', self)
        self.saveButton.clicked.connect(self.saveImage)
        layout.addWidget(self.saveButton)

        # 用于显示实时更新的图像
        hbox = QHBoxLayout()
        self.imageLabel = QLabel(self)
        self.imageLabel.setFixedSize(640, 480)
        self.imageLabel.setAlignment(Qt.AlignCenter)  # 水平居中
        hbox.addWidget(self.imageLabel)
        layout.addLayout(hbox)

        self.setLayout(layout)

    def startButtonClicked(self):
        self.image_receiver = ImageReceiver()
        self.image_receiver.image_data_ready.connect(self.updateImage)
        self.image_receiver.start()

    def updateImage(self, image):
        q_image = QImage(image.data, image.shape[1], image.shape[0], image.strides[0], QImage.Format_RGB888)
        pixmap = QPixmap.fromImage(q_image)
        self.imageLabel.setPixmap(pixmap)

    def saveImage(self):
        if not hasattr(self, 'image_receiver') or not self.image_receiver.isRunning():
            QMessageBox.warning(self, "Warning", "未获取到视频流，请先点击 Start 按钮开始接收视频流。")
            return

        options = QFileDialog.Options()
        fileName, _ = QFileDialog.getSaveFileName(self, "Save Image", "", "JPG Files (*.jpg)", options=options)
        if fileName:
            self.imageLabel.pixmap().toImage().save(fileName)

    def closeEvent(self, event):
        global sock
        sock.close()
        event.accept()

if __name__ == '__main__':
    # 载入 YOLOv8 模型
    model = YOLO('mydata/runs/detect/train5/weights/best.pt')

    app = QApplication(sys.argv)
    window = MyWindow()
    window.show()
    sys.exit(app.exec_())
