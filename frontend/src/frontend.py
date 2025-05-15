from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
import requests
import os

app = FastAPI()
templates = Jinja2Templates(directory="templates")
BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8000")  

@app.get("/")   
def index(request:Request): 
    try:
        response = requests.get(f"{BASE_URL}/") 
        response.raise_for_status()
        res = response.json()
    except requests.RequestException as e:
        res = None
        print("Errore nella chiamata dell'api", e)
    return templates.TemplateResponse("index.html", {"request":request, "ok": res})

