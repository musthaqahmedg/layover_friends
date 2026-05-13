import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

app = FastAPI(title="MAG AI Service")

api_key = os.getenv("OPENAI_API_KEY")
if not api_key:
    raise RuntimeError("OPENAI_API_KEY not found. Add it in ai_service/.env")

client = OpenAI(api_key=api_key)

# Modern embeddings model (fast + strong)
EMBEDDING_MODEL = "text-embedding-3-small"

class EmbedRequest(BaseModel):
    text: str

@app.get("/")
def root():
    return {"status": "MAG AI service running 🚀"}

@app.post("/embed")
def embed(req: EmbedRequest):
    text = (req.text or "").strip()
    if not text:
        raise HTTPException(status_code=400, detail="text is required")

    try:
        resp = client.embeddings.create(
            model=EMBEDDING_MODEL,
            input=text
        )
        embedding = resp.data[0].embedding
        return {"model": EMBEDDING_MODEL, "dim": len(embedding), "embedding": embedding}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Embedding failed: {str(e)}")
