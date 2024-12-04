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

from langchain_openai import OpenAIEmbeddings
from langchain_community.retrievers import WikipediaRetriever
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.vectorstores import FAISS

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

def make_chain(temperature):
    prompt = ChatPromptTemplate.from_messages([
        ("system", "당신은 {cuisine} 전문 요리사입니다. 현재 호텔에서 근무하고 있으며 경력은 25년입니다. \
        언제나 고객을 위해 정성껏 요리를 만들고 고객분들에게 세심하게 설명해주는 것을 좋아합니다."),
        ("human", "{question}"),
        ("assistant", "{result}")
        ])

    llm = ChatOpenAI(temperature=temperature, # 모델의 응답에서 무작위성과 창의성을 조절 
                                              # -> 작을수록 정확한 응답 / 높을수록 창의적인 응답
                 openai_api_key=openai_api_key
                 )
    
    chain = prompt|llm

    return chain

def generate_RAG_response(question, cuisine):

    retriever = WikipediaRetriever(top_k_results=1, lang="ko")
    docs = retriever.get_relevant_documents(cuisine)
    splitter = RecursiveCharacterTextSplitter.from_tiktoken_encoder(
        chunk_size=300,
        separators=['\n\n','\n']
    )
    split_documents = splitter.create_documents([docs[0].page_content])
    vector_store = FAISS.from_documents(embedding=OpenAIEmbeddings(), documents=split_documents)
    result = vector_store.similarity_search(question)
    logger.info(f"RAG 결과 : {result}")
    return result



def generate_response(question, cuisine, temperature, result):
    logger.info(f"Generating response for question: {question}")
    logger.info(f"Cuisine: {cuisine}")
    logger.info(f"Temperature: {temperature}")

    chain = make_chain(temperature)
    response = chain.invoke({"cuisine": cuisine, "question": question, "result": result}).content

    return response

class ChatRequest(BaseModel):
    question: str
    cuisine: str
    temperature: float
    RAG: bool

@app.get("/")
async def read_root():
    logger.info("Root URL was requested")
    return "테스트 테스트 테스트"

@app.post("/chat")
async def chat(request: ChatRequest):
    logger.info(f"Received question: {request.question}")
    logger.info(f"Received cuisine: {request.cuisine}")
    logger.info(f"RAG: {request.RAG}")
    result = ""

    try:
        if request.RAG:
            result = generate_RAG_response(request.question, request.cuisine)
        
        response = generate_response(request.question, request.cuisine, request.temperature, result)
        logger.info(f"Generated response: {response}")
        response_data = {"response": response}
        return JSONResponse(content=response_data)
    except ValueError as ve:
        logger.error(f"ValueError occurred: {ve}")
        raise HTTPException(status_code=400, detail=str(ve))
    except Exception as e:
        logger.error(f"Error occurred: {e}")
        raise HTTPException(status_code=500, detail="서버에서 오류가 발생했습니다.")


# Run the server
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")