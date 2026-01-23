import asyncio
import os
import random

import uvloop
import tornado.ioloop
import tornado.web

asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", "8000"))


class GetBaselineHandler(tornado.web.RequestHandler):
    async def get(self):
        self.write({"status": "ok"})


class GetIOHandler(tornado.web.RequestHandler):
    async def get(self):
        await asyncio.sleep(random.uniform(0.02, 0.05))
        self.write({"status": "ok"})


def make_app() -> tornado.web.Application:
    return tornado.web.Application(
        [
            (r"/get-baseline", GetBaselineHandler),
            (r"/get-io", GetIOHandler),
        ]
    )


if __name__ == "__main__":
    app = make_app()
    server = tornado.httpserver.HTTPServer(app)
    server.bind(PORT, address=HOST)
    server.start(1)
    tornado.ioloop.IOLoop.current().start()
