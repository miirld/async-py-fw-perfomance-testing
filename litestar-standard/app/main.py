import asyncio
import random
from litestar import Litestar, get

@get("/get-baseline")
async def get_baseline() -> dict:
    return {"status": "ok"}

@get("/get-io")
async def get_io() -> dict:
    await asyncio.sleep(random.uniform(0.02, 0.05)) 
    return {"status": "ok"}

app = Litestar(route_handlers=[get_baseline, get_io])