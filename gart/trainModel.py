# 设置使用0号GPU卡（如无GPU，执行此代码后会使用CPU训练模型）
import os
import paddlex as pdx
from paddlex.cls import transforms
os.environ['CUDA_VISIBLE_DEVICES'] = ''


def train():

    train_transforms = transforms.Compose([
        transforms.RandomCrop(crop_size=224),
        transforms.RandomHorizontalFlip(),
        transforms.Normalize()
    ])
    eval_transforms = transforms.Compose([
        transforms.ResizeByShort(short_size=256),
        transforms.CenterCrop(crop_size=224),
        transforms.Normalize()
    ])

    train_dataset = pdx.datasets.ImageNet(
        data_dir='Main',
        file_list='Main/train_list.txt',
        label_list='Main/labels.txt',
        transforms=train_transforms,
        shuffle=True)
    eval_dataset = pdx.datasets.ImageNet(data_dir='Main',
                                         file_list='Main/val_list.txt',
                                         label_list='Main/labels.txt',
                                         shuffle=True,
                                         transforms=eval_transforms)

    num_classes = len(train_dataset.labels)
    model = pdx.cls.MobileNetV3_small_ssld(num_classes=num_classes)

    model.train(num_epochs=20,
                train_dataset=train_dataset,
                train_batch_size=32,
                eval_dataset=eval_dataset,
                lr_decay_epochs=[4, 6, 8, 12, 16, 20],
                save_dir='mobilenetv3_small_ssld',
                use_vdl=True)
train()