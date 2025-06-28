# СБорка 
FROM python:3.12-slim AS builder
WORKDIR /app
COPY pyproject.toml .
RUN pip install --upgrade pip
RUN pip install flask flit
COPY . .

# Запуск
FROM python:3.12-slim
COPY --from=builder /usr/local /usr/local
COPY --from=builder /app /app

EXPOSE 8000

ENV FLASK_APP=flaskr
ENV FLASK_ENV=production
ENV PYTHONPATH=/app
CMD ["flask", "run", "--host=0.0.0.0", "--port=8000"]
