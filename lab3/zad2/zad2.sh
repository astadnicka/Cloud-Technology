#!/bin/bash


CONTAINER_NAME="custom_nginx"
IMAGE_NAME="nginx_custom"
PORT=${1:-8080}  
HTML_CONTENT="<h1>Witaj na niestandardowym serwerze Nginx!</h1>"

mkdir -p ./nginx_custom/html ./nginx_custom/conf

echo "$HTML_CONTENT" > ./nginx_custom/html/index.html

cat <<EOF > ./nginx_custom/conf/nginx.conf
events { }

http {
    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
}
EOF

cat <<EOF > ./nginx_custom/Dockerfile
FROM nginx:latest
COPY html/index.html /usr/share/nginx/html/index.html
COPY conf/nginx.conf /etc/nginx/nginx.conf
EOF

cd nginx_custom
docker build -t $IMAGE_NAME .
cd ..

docker run -d --name $CONTAINER_NAME -p $PORT:80 $IMAGE_NAME

echo "Serwer Nginx działa na http://localhost:$PORT"

function test_nginx {
    echo "🔍 Testowanie serwera..."
    sleep 2  
    RESPONSE=$(curl -s http://localhost:$PORT)
    if [[ "$RESPONSE" == *"$HTML_CONTENT"* ]]; then
        echo "✅ Test zakończony pomyślnie! Strona działa."
    else
        echo " Test nie powiódł się. Otrzymana odpowiedź: $RESPONSE"
        exit 1
    fi
}

test_nginx  

