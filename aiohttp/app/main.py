import asyncio
import random
from aiohttp import web

async def get_cpu(request):
    return web.json_response({"status": "ok"})

async def get_io(request):
    await asyncio.sleep(random.uniform(0.02, 0.05))
    return web.json_response({"status": "ok"})

def create_app():
    app = web.Application()
    app.add_routes([
        web.get('/get-cpu', get_cpu),
        web.get('/get-io', get_io),
    ])
    return app

app = create_app()