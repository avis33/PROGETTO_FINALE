from fastapi import FastAPI, HTTPException
import requests
import mariadb
from typing import List
from backend.models.models import SchemaSummaryItem, SearchItem, AddRequest, AddResponse
from backend.db.queries import  get_schema_summary, inserisci_riga
import os
OLLAMA_BASE_URL = os.getenv("OLLAMA_HOST", "http://ollama:11434")
OLLAMA_URL = f"{OLLAMA_BASE_URL}/api/chat"  
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

@app.get("/schema_summary", response_model=List[SchemaSummaryItem])
def schema_summary():
    # Chiama la funzione get_schema_summary dal modulo db
    results = get_schema_summary()
    # Ritorniamo i risultati nella forma richiesta
    return [
        {"table_name": row[0], "table_column": row[1]}
        for row in results
    ]

@app.post("/search", response_model=List[SearchItem])
def search(question: str):
    try:
        print()
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))

@app.post("/add", response_model=AddResponse)
def add(data: AddRequest):
    data_line = data.data_line 
    fields = [f.strip() for f in data_line.split(',')] 
    try:
        print(fields)
        if len(fields) < 5 or len(fields)>7: # Il numero di elementi della lista deve essere tra 5 e 7 per essere un input valido
            raise HTTPException(
                status_code=422,  # Lanciamo lo status code 422 come richiesto
                detail="La stringa deve contenere da 5 a 7 campi separati da virgola." # E lanciamo un messaggio di errore personalizzato
            )
        
        # Estrai i campi obbligatori
        titolo = fields[0]
        regista = fields[1]
        eta_autore = fields[2]
        anno = fields[3]
        genere = fields[4]
        piattaforma_1 = ""
        piattaforma_2 = ""

        if len(fields) > 5:
            piattaforma_1 = fields[5]
        if len(fields) > 6:
            piattaforma_2 = fields[6]

        # Validazione numeri
        if not eta_autore.isdigit() or not anno.isdigit():
            raise HTTPException(
                status_code=422, # Lanciamo lo status code 422 come richiesto
                detail="Età Autore e Anno devono essere numeri interi." # E lanciamo un messaggio di errore personalizzato
            )
        
        # Validazione campi vuoti
        required_fields = [titolo, regista, eta_autore, anno, genere]
        for field in required_fields:
            if not field:
                raise HTTPException(
                status_code=422, # Lanciamo lo status code 422 come richiesto
                detail="I campi non possono essere vuoti." # E lanciamo un messaggio di errore personalizzato
            )
        inserted = inserisci_riga(titolo, regista, eta_autore, anno, genere, piattaforma_1, piattaforma_2) # Chiamiamo la funzione del modulo db
        if(inserted == False): 
            raise HTTPException(status_code=422, detail="Impossibile inserire la nuova riga") # Se la funzione inserisci_riga ha dato esito negativo lanciamo status code 422
        # Se tutto ok
        return {
            "status": "ok"
        }
    except HTTPException:
        # Rilancia le eccezioni HTTP che abbiamo già gestito
        raise
    except mariadb.Error as e:
        # Gestione specifica per errori del database
        print(f"Errore database: {e}")
        raise HTTPException(
            status_code=500,
            detail="Errore durante l'accesso al database"
        )
