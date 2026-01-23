import asyncio
import random
from fastapi import FastAPI

app = FastAPI()

@app.get("/get-baseline")
async def get_baseline():
    return {"status": "ok"}

@app.get("/get-io")
async def get_io():
    await asyncio.sleep(random.uniform(0.02, 0.05))
    return {"status": "ok"}
