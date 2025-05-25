ARG PYTHON_VERSION=3.9

FROM python:${PYTHON_VERSION}-alpine

ARG PORT=5000
ENV PORT=${PORT}

WORKDIR /app

COPY app/ /app

RUN pip install --no-cache-dir -r requirements.txt

VOLUME /app/data

EXPOSE ${PORT}

CMD ["python", "app.py"]

