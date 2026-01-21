FROM python:3.12.3-slim-bookworm

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app app

ENV HOST=0.0.0.0
ENV PORT=8000

CMD ["python", "-m", "app.main"]
