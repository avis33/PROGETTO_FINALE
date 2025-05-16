from fastapi import FastAPI, Request, Form
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
        print(res)
    except requests.RequestException as e:
        res = None
        print("Errore nella chiamata dell'api", e)
    return templates.TemplateResponse("index.html", {"request":request, "ok": res})


@app.get("/")   
def index(request:Request): 
    return templates.TemplateResponse("index.html", {"request": request})

@app.get("/schema_summary")
def getSchema(request:Request):
    try:
        response = requests.get(f"{BASE_URL}/schema_summary") 
        response.raise_for_status()
        schema = response.json()
        print(schema)
    except requests.RequestException as e:
        schema = None
        print("Errore nella chiamata dell'api", e)
    return templates.TemplateResponse("schema_summary.html", {"request":request, "schema": schema})

@app.get("/search")
def search(request: Request, question: str):
    try:
        # Chiami l’API del backend
        response = requests.get(f"{BASE_URL}/search/{question}") 
        response.raise_for_status()
        results = response.json()
    except requests.RequestException as e:
        print(e)
        return templates.TemplateResponse("index.html", {
            "request": request,
            "errorQuery": f"Invalid string: {question}"
        })
    return templates.TemplateResponse("search_result.html", {
        "request": request,
        "results": results,
        "query":question
    })

@app.post("/add")
def add(data_line: str = Form(...), request: Request = None):
    try:
        response = requests.post(f"{BASE_URL}/add", json={"data_line": data_line})  
        response.raise_for_status()
        output = response.json()
        return templates.TemplateResponse("index.html", {"request": request, "output": output})
    except requests.HTTPError:
        try:
            error_detail = response.json().get("detail", "Errore nella risposta dell'API.")
        except ValueError:
            error_detail = "Errore nel parsing della risposta dell'API."
        return templates.TemplateResponse("index.html", {"request": request, "output": error_detail})
    except requests.RequestException:
        return templates.TemplateResponse("index.html", {"request": request, "output": "Errore nella chiamata dell'API."})