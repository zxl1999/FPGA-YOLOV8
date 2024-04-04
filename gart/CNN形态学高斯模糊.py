import os
import cv2
import numpy as np
from sklearn.metrics import classification_report

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.callbacks import ModelCheckpoint

def load_data(file_list):
    data = []
    labels = []
    with open(file_list, 'r') as f:
        for line in f:
            file_path, label = line.strip().split()
            img = cv2.imread(file_path, cv2.IMREAD_COLOR)  # 读取为RGB图像
            
            # 添加高斯模糊
            img_blur = cv2.GaussianBlur(img, (5, 5), 0)
            
            # 提取边缘
            edges = cv2.Canny(img_blur, 100, 200)
            
            # 添加中值滤波去噪
            img_denoised = cv2.medianBlur(edges, 5)
            
            img_resized = cv2.resize(img_denoised, (64, 64))  # 调整图像大小
            
            # 转换为RGB格式
            img_rgb = cv2.cvtColor(img_resized, cv2.COLOR_GRAY2RGB)
            
            data.append(img_rgb)
            labels.append(int(label))
    return np.array(data), np.array(labels)





X_train, y_train = load_data('train_list.txt')
X_val, y_val = load_data('val_list.txt')
X_test, y_test = load_data('test_list.txt')

# 数据预处理
X_train = X_train.astype('float32') / 255
X_val = X_val.astype('float32') / 255
X_test = X_test.astype('float32') / 255

y_train = to_categorical(y_train)
y_val = to_categorical(y_val)
y_test = to_categorical(y_test)

# 构建CNN模型
model = Sequential([
    Conv2D(32, (3, 3), activation='relu', input_shape=(64, 64, 3)),
    MaxPooling2D((2, 2)),
    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D((2, 2)),
    Conv2D(128, (3, 3), activation='relu'),
    MaxPooling2D((2, 2)),
    Flatten(),
    Dense(128, activation='relu'),
    Dense(10, activation='softmax')
])

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# 定义模型保存回调
checkpoint_path = "model_checkpoint.h5"
checkpoint = ModelCheckpoint(checkpoint_path, monitor='val_accuracy', verbose=1, save_best_only=True, mode='max')

# 训练模型
history = model.fit(X_train, y_train, epochs=100, batch_size=32, validation_data=(X_val, y_val), callbacks=[checkpoint])

# 评估模型
test_loss, test_accuracy = model.evaluate(X_test, y_test)
print(f'Test Accuracy: {test_accuracy}')

# 预测测试集
y_pred = model.predict(X_test)
y_pred_classes = np.argmax(y_pred, axis=1)
y_true = np.argmax(y_test, axis=1)

# 打印分类报告
print(classification_report(y_true, y_pred_classes))
