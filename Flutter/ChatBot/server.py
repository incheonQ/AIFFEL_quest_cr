import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import logging
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from dotenv import load_dotenv
import os
from pydantic import BaseModel
from fastapi.responses import JSONResponse

load_dotenv() 
openai_api_key = os.getenv("OPENAI_API_KEY")

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

# Prompt
prompt2 = ChatPromptTemplate.from_messages([
("system", "당신은 {cuisine} 요리사입니다. 현재 호텔에서 근무하고 있으며 경력은 25년입니다. \
언제나 고객을 위해 정성껏 요리를 만들고 고객분들에게 세심하게 설명해주는 것을 좋아합니다."),
("human", "{question}")
])

# LLM
llm = ChatOpenAI(temperature=0.1, # 모델의 응답에서 무작위성과 창의성을 조절 
                                  # -> 작을수록 정확한 응답 / 높을수록 창의적인 응답
                 openai_api_key=openai_api_key
                 )

# Chain
chain2 = prompt2|llm

def generate_response(question, cuisine):
    logger.info(f"Generating response for question: {question}")
    logger.info(f"Cuisine: {cuisine}")

    response = chain2.invoke({"cuisine": cuisine, "question": question}).content
    return response

class ChatRequest(BaseModel):
    question: str
    cuisine: str

@app.get("/")
async def read_root():
    logger.info("Root URL was requested")
    return "테스트 테스트 테스트"

@app.post("/chat")
async def chat(request: ChatRequest):
    logger.info(f"Received question: {request.question}")
    logger.info(f"Received cuisine: {request.cuisine}")
    try:
        response = generate_response(request.question, request.cuisine)
        logger.info(f"Generated response: {response}")
        response_data = {"response": response}
        return JSONResponse(content=response_data)
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise


# Run the server
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")