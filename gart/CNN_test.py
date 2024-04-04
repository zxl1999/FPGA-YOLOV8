import cv2
import numpy as np
from tensorflow.keras.models import load_model

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.callbacks import ModelCheckpoint


# 加载模型
model = load_model('model_checkpoint.h5')

def load_data(file_list):
    data = []
    labels = []
    with open(file_list, 'r') as f:
        for line in f:
            file_path, label = line.strip().split()
            img = cv2.imread(file_path)
            img = cv2.resize(img, (64, 64))  # 调整图像大小
            data.append(img)
            labels.append(int(label))
    return np.array(data), np.array(labels)

X_test, y_test = load_data('test_list.txt')

# 数据预处理
X_test = X_test.astype('float32') / 255
y_test = to_categorical(y_test)

# 预测测试集
y_pred = model.predict(X_test)
y_pred_classes = np.argmax(y_pred, axis=1)
y_true = np.argmax(y_test, axis=1)

# 打印分类报告
from sklearn.metrics import classification_report
print(classification_report(y_true, y_pred_classes))
