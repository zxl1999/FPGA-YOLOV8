import cv2
import numpy as np
from sklearn.metrics import classification_report

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.callbacks import ModelCheckpoint
# 添加颜色空间转换函数
def rgb_to_ycbcr(img):
    return cv2.cvtColor(img, cv2.COLOR_RGB2YCrCb)

# 提取肤色部分
def extract_skin(img):
    lower_skin = np.array([0, 133, 77], dtype="uint8")
    upper_skin = np.array([255, 173, 127], dtype="uint8")
    mask = cv2.inRange(img, lower_skin, upper_skin)
    skin = cv2.bitwise_and(img, img, mask=mask)
    return skin

# 应用形态学运算
def morphological_operation(img):
    kernel = np.ones((5, 5), np.uint8)
    opening = cv2.morphologyEx(img, cv2.MORPH_OPEN, kernel)
    return opening

# 加载图像
def load_data(file_list):
    data = []
    labels = []
    with open(file_list, 'r') as f:
        for line in f:
            file_path, label = line.strip().split()
            img = cv2.imread(file_path)
            img = cv2.resize(img, (64, 64))  # 调整图像大小

            # RGB 转换为 YCbCr 颜色空间
            ycbcr_img = rgb_to_ycbcr(img)

            # 提取肤色部分
            skin_img = extract_skin(ycbcr_img)

            # 应用形态学运算
            result_img = morphological_operation(skin_img)

            data.append(result_img)
            labels.append(int(label))
    return np.array(data), np.array(labels)

# 加载数据
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
checkpoint_path = "model_xingtai_checkpoint.h5"
checkpoint = ModelCheckpoint(checkpoint_path, monitor='val_accuracy', verbose=1, save_best_only=True, mode='max')

# 训练模型
history = model.fit(X_train, y_train, epochs=10, batch_size=32, validation_data=(X_val, y_val), callbacks=[checkpoint])

# 评估模型
test_loss, test_accuracy = model.evaluate(X_test, y_test)
print(f'Test Accuracy: {test_accuracy}')

# 预测测试集
y_pred = model.predict(X_test)
y_pred_classes = np.argmax(y_pred, axis=1)
y_true = np.argmax(y_test, axis=1)

# 打印分类报告
print(classification_report(y_true, y_pred_classes))
