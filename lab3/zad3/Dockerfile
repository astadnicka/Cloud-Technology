FROM nginx:latest

RUN apt-get update && apt-get install -y openssl

RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/key.pem -out /etc/nginx/ssl/cert.pem -subj "/CN=localhost"

COPY nginx/nginx.conf /etc/nginx/nginx.conf
