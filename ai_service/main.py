import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

app = FastAPI(title="MAG AI Service")

groq_key = os.getenv("GROQ_API_KEY")
if not groq_key:
    raise RuntimeError("GROQ_API_KEY not found. Add it in ai_service/.env")

# Groq uses an OpenAI-compatible endpoint
groq_client = OpenAI(
    api_key=groq_key,
    base_url="https://api.groq.com/openai/v1"
)

# OpenAI is only still used for embeddings (optional)
openai_key = os.getenv("OPENAI_API_KEY")
openai_client = OpenAI(api_key=openai_key) if openai_key else None

EMBEDDING_MODEL = "text-embedding-3-small"
CHAT_MODEL = "openai/gpt-oss-20b"

class EmbedRequest(BaseModel):
    text: str

@app.get("/")
def root():
    return {"status": "MAG AI service running"}

@app.post("/embed")
def embed(req: EmbedRequest):
    text = (req.text or "").strip()
    if not text:
        raise HTTPException(status_code=400, detail="text is required")
    if not openai_client:
        raise HTTPException(status_code=503, detail="Embeddings unavailable: no OPENAI_API_KEY")

    try:
        resp = openai_client.embeddings.create(model=EMBEDDING_MODEL, input=text)
        embedding = resp.data[0].embedding
        return {"model": EMBEDDING_MODEL, "dim": len(embedding), "embedding": embedding}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Embedding failed: {str(e)}")

@app.post("/chat")
def chat(req: EmbedRequest):
    text = (req.text or "").strip()
    if not text:
        raise HTTPException(status_code=400, detail="text is required")

    try:
        resp = groq_client.chat.completions.create(
            model=CHAT_MODEL,
            messages=[{"role": "user", "content": text}]
        )
        return {"response": resp.choices[0].message.content}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Chat failed: {str(e)}")