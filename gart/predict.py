import numpy as np
import paddlex as pdx
from PIL import Image
from paddlex.cls import transforms

def test():
    '''
    predict_transforms = transforms.Compose([
        transforms.RandomCrop(crop_size=224),
        transforms.RandomHorizontalFlip(),
        transforms.Normalize()
    ])
    
    img_path = 'mushrooms_train/Russula/728_GKNcKK0yCIc.jpg'

    img = Image.open(img_path)
    img = img.convert("RGB")

    img_cv = np.array(img)

    model = pdx.load_model('output/mobilenetv3_small_ssld/best_model')
    result = model.predict(img_cv)'''
    img_path = 'user/0002_FVNX1Bdwf4s.jpg'
    model = pdx.load_model('enable_mush')
    result = model.predict(img_path)
    print(result)
    return result
a=test()