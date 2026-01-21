FROM python:3.12.3-slim-bookworm

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app app

CMD ["python", "-m", "sanic", "app.main.app", "--host=0.0.0.0", "--port=8000", "--workers=1"]
