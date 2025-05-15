from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def index():
    print("Running server")
    return "I'm running the server"