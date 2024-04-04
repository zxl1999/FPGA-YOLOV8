import os
import random

# 设置mushrooms_train文件夹的路径
mushrooms_train_path = "Main"

# 获取mushrooms_train文件夹下所有子文件夹的名称
subfolders = [f for f in os.listdir(mushrooms_train_path) if os.path.isdir(os.path.join(mushrooms_train_path, f))]

with open(os.path.join(mushrooms_train_path, "labels.txt"), "w") as labels_file:
    labels_file.write("\n".join(subfolders))


# 定义训练集、验证集和测试集比例
train_ratio = 0.6
val_ratio = 0.2
test_ratio = 0.2

# 定义用于保存所有图像文件名的列表
train_list = []
val_list = []
test_list = []

# 遍历每个子文件夹，划分图像文件名到训练集、验证集和测试集
count=0
for subfolder in subfolders:
    subfolder_path = os.path.join(mushrooms_train_path, subfolder)
    image_files = [f for f in os.listdir(subfolder_path) if f.endswith(".JPG")]
    random.shuffle(image_files)

    train_count = int(train_ratio * len(image_files))
    val_count = int(val_ratio * len(image_files))
    test_count = len(image_files) - train_count - val_count

    train_list.extend(['./'+subfolder+'/'+x+' '+str(count) for x in image_files[:train_count]])
    val_list.extend(['./'+subfolder+'/'+x+' '+str(count) for x in image_files[train_count:train_count + val_count]])
    test_list.extend(['./'+subfolder+'/'+x+' '+str(count) for x in image_files[train_count + val_count:]])
    count+=1

# 将图像文件名保存到对应的txt文件中
with open(os.path.join(mushrooms_train_path, "train_list.txt"), "w") as train_file:
    train_file.write("\n".join(train_list))

with open(os.path.join(mushrooms_train_path, "val_list.txt"), "w") as val_file:
    val_file.write("\n".join(val_list))

with open(os.path.join(mushrooms_train_path, "test_list.txt"), "w") as test_file:
    test_file.write("\n".join(test_list))
