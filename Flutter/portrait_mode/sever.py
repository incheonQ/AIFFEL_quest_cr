# main.py
import uvicorn
from fastapi import FastAPI, HTTPException, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from PIL import Image
import numpy as np
import logging
import io

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


# Run the server
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")