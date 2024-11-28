# main.py
import uvicorn
from fastapi import FastAPI, HTTPException, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from PIL import Image
import numpy as np
import logging
import io
import torch
from torchvision import transforms
from transformers import AutoModelForImageSegmentation
import cv2
import os
from tensorflow.keras.preprocessing import image


# Create the FastAPI application
app = FastAPI()

# CORS configuration
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# Load model
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

    torch.set_float32_matmul_precision(['high', 'highest'][0])
    model.to(device)
    model.eval()

    return device, model

device, model = load_model()

# Transform
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


async def prediction_model(img):
    # Usage

    input_images = transform_image(img).unsqueeze(0).to(device)

    # Prediction
    with torch.no_grad():
        preds = model(input_images)[-1].sigmoid().cpu()
    pred = preds[0].squeeze()
    pred_pil = transforms.ToPILImage()(pred)
    mask = pred_pil.resize(img.size)

    # Blur
    img_blurred = cv2.blur(img, (13, 13))

    # Mask
    np_mask = np.array(mask)
    img_mask_color = cv2.cvtColor(np_mask, cv2.COLOR_GRAY2BGR)

    # Concat
    # img_bg_mask = cv2.bitwise_not(img_mask_color)
    # img_bg_blur = cv2.bitwise_and(img_blurred, img_bg_mask)
    img_concat = np.where(img_mask_color > 0, img, img_blurred)

    return img_concat

@app.get("/")
async def read_root():
    logger.info("Root URL was requested")
    return "테스트 테스트 테스트"

@app.post("/upload/")
async def upload_image(file: UploadFile = File(...)):
    try:
        # 이미지 파일을 메모리에 저장
        img_byte_arr = io.BytesIO()
        img_byte_arr.write(await file.read())  # 파일 내용을 메모리 버퍼에 저장
        img_byte_arr.seek(0)  # 버퍼의 시작으로 이동

        # StreamingResponse를 사용하여 메모리에서 직접 반환
        return StreamingResponse(img_byte_arr, media_type='image/png')
    except Exception as e:
        logger.error(f"Error processing image: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")

@app.post("/pred/")
async def pred(file: UploadFile = File(...)):
    try:
        image_data = await file.read()
        img = Image.open(io.BytesIO(image_data))  # 이미지 열기
    
        predicted_img = await prediction_model(img)

        return StreamingResponse(io.BytesIO(predicted_img), media_type='image/png')
    
    except Exception as e:
        logger.error("Prediction failed: %s", e)  # 오류 로깅
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")




# Run the server
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")