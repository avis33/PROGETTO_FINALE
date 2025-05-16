from fastapi import FastAPI, HTTPException
import requests
import os
OLLAMA_BASE_URL = os.getenv("OLLAMA_HOST", "http://ollama:11434")
OLLAMA_URL = f"{OLLAMA_BASE_URL}/api/chat"  # Nota: /api/chat è l'endpoint corretto
MODEL_NAME = "gemma3:1b-it-qat"

app = FastAPI()

@app.get("/")
def index():
    print("Running server")
    try:
        print(f"Connecting to Ollama at: {OLLAMA_URL}")
        request_body = {
            "model": MODEL_NAME,
            "messages": [
                {"role": "user", "content": "CIAO"}
            ],
            "stream": False
        }
        res = requests.post(OLLAMA_URL, json=request_body, timeout=30)
        res.raise_for_status()
        data = res.json()
        print(data)
        return {"answer": data["message"]["content"].strip()}
    except requests.exceptions.RequestException as e:
        print(e)
        raise HTTPException(
            status_code=500,
            detail=f"Error communicating with Ollama at {OLLAMA_URL}: {str(e)}"
        )
    
    