import asyncio
from datetime import datetime

from celery import Celery
from fastapi import WebSocket

app = Celery('tasks', broker="redis://localhost:6379/0")


class ConnectionManager:
    def __init__(self):
        self.active_connections: list[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str):
        print("broadcast...")
        for connection in self.active_connections:
            print(f"will send text: {message}")
            await connection.send_text(message)
            print(f"did send text: {message}")


manager = ConnectionManager()


# @app.task
# def check():
#     print("I am checking your stuff")
#
#
# app.conf.beat_schedule = {
#     "run-me-every-ten-seconds": {
#         "task": "tasks.check",
#         "schedule": 10.0
#     }
# }


@app.task
async def get_current_time():
    print(f"current time: {datetime.now()}")
    print(f"manager: {manager}")
    await manager.broadcast(f"{datetime.now()}")


app.conf.beat_schedule = {
    "get_current_time": {
        "task": "tasks.get_current_time",
        "schedule": 1.0
    }
}

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(get_current_time())
    loop.close()
