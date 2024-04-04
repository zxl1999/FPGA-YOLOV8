import socket
import numpy as np
import cv2

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

# 创建窗口用于实时显示图片
#cv2.namedWindow('Real-Time Image', cv2.WINDOW_NORMAL)

packet_number = 0

flag=0

aa=[]

while True:
    #print(1)
    # 接收UDP包
    #break
    data, addr = sock.recvfrom(udp_packet_size)
    
    a=np.frombuffer(data, dtype=np.uint8)
    
    aa.append(a)
    
    if packet_number == total_packets - 1:
        break


# 关闭UDP套接字（在适当的时候）
sock.close()

