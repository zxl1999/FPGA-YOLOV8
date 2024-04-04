import socket
import numpy as np
import cv2

from ultralytics import YOLO
 
# 载入 YOLOv8 模型
model = YOLO('mydata/runs/detect/train5/weights/best.pt')



# 设置IP地址和端口号
udp_ip = "192.168.3.3"  # 你要监听的IP地址
udp_port = 32768       # 你要监听的端口号

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

# 创建窗口用于实时显示图片
cv2.namedWindow('YOLOv8', cv2.WINDOW_NORMAL)

packet_number = 0

flag=0

while True:
    # 接收UDP包
    data, addr = sock.recvfrom(udp_packet_size)

    # 解析UDP包的序号
    packet_number += 1

    # 存储数据到缓冲区的相应位置
    image_buffer[packet_number] = np.frombuffer(data, dtype=np.uint8)
    
    #先识别与本地计算机协商图片开始传输的UDP包
    if image_buffer[packet_number][0]==0 and flag==0:
        packet_number -= 1
        flag=1
        continue
    #排除未与计算机约定开始传输就传输图片的UDP包
    if flag==0:
        packet_number -= 1
        continue
    #排除丢包
    if image_buffer[packet_number][0]==0 and flag==1:
        #mod
        if packet_number!=1:
            image_buffer = np.zeros((total_packets, udp_packet_size), dtype=np.uint8)

            packet_number = 0
            continue                                           
        packet_number -= 1
        continue
    
    # 如果已经接收到所有UDP包，则拼接图片
    if packet_number == total_packets - 1:
        flag=0
        complete_image = np.concatenate(image_buffer, axis=0).reshape((image_height, image_width))
        rgb_image = cv2.cvtColor(complete_image, cv2.COLOR_BayerBG2RGB)
        
        # 对帧运行 YOLOv8 推理
        results = model(rgb_image)
        
        # 在帧上可视化结果
        annotated_frame = results[0].plot()
        
        # 显示带有标注的帧
        cv2.imshow("YOLOv8", annotated_frame)
        
        # 显示实时更新的图片
        #.imshow('Real-Time Image', rgb_image)
        cv2.waitKey(1)  # 暂停1毫秒，允许图像窗口处理事件

        # 重置缓冲区
        image_buffer = np.zeros((total_packets, udp_packet_size), dtype=np.uint8)
        packet_number = 0


# 关闭UDP套接字（在适当的时候）
sock.close()
cv2.destroyAllWindows()
