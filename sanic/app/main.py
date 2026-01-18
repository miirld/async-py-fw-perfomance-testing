import asyncio
import random

import uvloop
from sanic import Sanic
from sanic.response import json

asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

app = Sanic("sanic-benchmark")

@app.get("/get-cpu")
async def get_cpu(request):
    return json({"status": "ok"})

@app.get("/get-io")
async def get_io(request):
    await asyncio.sleep(random.uniform(0.02, 0.05))
    return json({"status": "ok"})
