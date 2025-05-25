ARG PYTHON_VERSION=3.9

FROM python:${PYTHON_VERSION}-slim

WORKDIR /myapp

COPY app/ .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]

