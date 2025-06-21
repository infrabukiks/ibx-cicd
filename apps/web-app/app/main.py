# apps/web-app/app/main.py

from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import os

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def home():
    color = os.getenv("BG_COLOR", "white")
    html = f"""
    <html>
        <body style='background-color:{color};'>
            <h1 style='color:black;text-align:center;margin-top:200px;'>
                CI/CD Demo - Background Color: {color}
            </h1>
        </body>
    </html>
    """
    return html
