from PIL import Image
import torch
from torchvision import transforms
from transformers import AutoModelForImageSegmentation
import cv2
import numpy as np
import os

def load_model():
# 모델 파일 경로
    model_path = 'model.pt'

    # 장치 설정: GPU가 사용 가능하면 CUDA, 그렇지 않으면 CPU
    device = 'cuda' if torch.cuda.is_available() else 'cpu'

    # 모델 로드
    if os.path.exists(model_path):
        model = torch.load(model_path)  # 로컬에서 모델 로드
    else:
        model = AutoModelForImageSegmentation.from_pretrained('briaai/RMBG-2.0', trust_remote_code=True)
        torch.save(model, model_path)  # 모델을 로컬에 저장

    torch.set_float32_matmul_precision(['high', 'highest'][0])
    model.to(device)
    model.eval()

    return device, model

def transform_image(image):
    # Convert RGBA to RGB if image has alpha channel
    if image.mode == 'RGBA':
        image = image.convert('RGB')

    image_size = (1024, 1024)
    transform = transforms.Compose([
        transforms.Resize(image_size),
        transforms.ToTensor(),
        transforms.Normalize(
            mean=[0.485, 0.456, 0.406],
            std=[0.229, 0.224, 0.225]
        )
    ])
    return transform(image)

def potrait_mode(input_image_path):

    device, model = load_model()

    # Usage
    image = Image.open(input_image_path)
    print(image.size)
    input_images = transform_image(image).unsqueeze(0).to(device)

    # Prediction
    with torch.no_grad():
        preds = model(input_images)[-1].sigmoid().cpu()
    pred = preds[0].squeeze()
    pred_pil = transforms.ToPILImage()(pred)
    mask = pred_pil.resize(image.size)

    # Blur
    img_orig = cv2.imread(input_image_path)
    img_blurred = cv2.blur(img_orig, (13, 13))

    # Mask
    np_mask = np.array(mask)
    img_mask_color = cv2.cvtColor(np_mask, cv2.COLOR_GRAY2BGR)

    # Concat
    # img_bg_mask = cv2.bitwise_not(img_mask_color)
    # img_bg_blur = cv2.bitwise_and(img_blurred, img_bg_mask)
    img_concat = np.where(img_mask_color > 0, img_orig, img_blurred)

    return img_concat