from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
import requests
import os

app = FastAPI()
templates = Jinja2Templates(directory="templates")
BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8000")  

@app.get("/")   
def index(request:Request): 
    return templates.TemplateResponse("index.html", {"request": request})
