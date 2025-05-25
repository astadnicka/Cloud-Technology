#!/bin/bash


CONTAINER_NAME="nginx_container"
IMAGE_NAME="custom_nginx"
PORT=8080
HTML_CONTENT="<h1>Witaj w serwerze Nginx!</h1>"

mkdir -p ./nginx_html
echo "$HTML_CONTENT" > ./nginx_html/index.html

echo "FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html" > ./nginx_html/Dockerfile

cd nginx_html
docker build -t $IMAGE_NAME .
cd ..

docker run -d --name $CONTAINER_NAME -p $PORT:80 $IMAGE_NAME

echo "Serwer Nginx jest dostępny pod adresem http://localhost:$PORT"

function test_nginx {
    echo "Testowanie dostępności serwera..."
    sleep 2
    RESPONSE=$(curl -s http://localhost:$PORT)
    if [[ "$RESPONSE" == *"$HTML_CONTENT"* ]]; then
        echo "Test zakończony pomyślnie! Serwer działa poprawnie."
    else
        echo "Test nie powiódł się. Otrzymana odpowiedź: $RESPONSE"
        exit 1
    fi
}

test_nginx

