# Development image: full Python base, single stage, runs as root (kept for comparison with Dockerfile.prod)
FROM python:3.12

ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Install dependencies first so code changes reuse the cached layer
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Train the model during the build, then copy the API code
COPY train.py .
RUN python train.py

COPY . .

EXPOSE 8000
CMD ["fastapi", "run", "main.py", "--host", "0.0.0.0", "--port", "8000"]
