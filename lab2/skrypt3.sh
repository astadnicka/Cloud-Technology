#!/bin/bash

info() {
  echo -e "\n\033[1;32m[$1]\033[0m $2"
}

NODE_VERSION="16"
CONTAINER_NAME="nodejs16-express-mongo"
MONGO_CONTAINER_NAME="mongodb-container"
PORT=8080
MONGO_PORT=27017
JS_FILE="mongo.js"
DB_NAME="testdb"

info "CHECK" "Sprawdzanie, czy plik $JS_FILE istnieje..."
if [ ! -f "$JS_FILE" ]; then
  echo "Błąd: Plik $JS_FILE nie został znaleziony w bieżącym katalogu!" >&2
  exit 1
fi

info "CONTAINER" "Uruchamianie kontenera MongoDB..."
docker run -d --name $MONGO_CONTAINER_NAME -p $MONGO_PORT:27017 mongo:latest

if [ $? -ne 0 ]; then
  echo "Błąd: Nie udało się uruchomić kontenera MongoDB!" >&2
  exit 1
fi

info "CONTAINER" "Uruchamianie kontenera z Node.js w wersji $NODE_VERSION..."
CONTAINER_ID=$(docker run -d -p $PORT:$PORT --name $CONTAINER_NAME --link $MONGO_CONTAINER_NAME:mongo -it node:$NODE_VERSION tail -f /dev/null)

if [ $? -ne 0 ]; then
  echo "Błąd: Nie udało się uruchomić kontenera Node.js!" >&2
  exit 1
fi

info "STRUKTURA" "Tworzenie katalogu /app w kontenerze Node.js"
docker exec "$CONTAINER_ID" mkdir -p /app

info "COPY" "Kopiowanie plików do kontenera Node.js..."
docker cp package.json "$CONTAINER_ID":/app/
docker cp "$JS_FILE" "$CONTAINER_ID":/app/

info "ZALEŻNOŚCI" "Instalacja zależności Node.js wewnątrz kontenera"
docker exec -w /app "$CONTAINER_ID" npm install

info "START" "Uruchamianie serwera Express.js w kontenerze..."
docker exec -d -w /app "$CONTAINER_ID" node /app/mongo.js

if [ $? -eq 0 ]; then
  info "SUCCESS" "Serwer został uruchomiony w kontenerze!"
  echo "Możesz otworzyć przeglądarkę i przejść pod adres: http://localhost:$PORT"
else
  echo "Błąd: Nie udało się uruchomić serwera w kontenerze!" >&2
  exit 1
fi

info "SPRZĄTANIE" "Aby zatrzymać i usunąć kontenery, wykonaj:"
echo "docker stop $CONTAINER_ID $MONGO_CONTAINER_NAME"
echo "docker rm $CONTAINER_ID $MONGO_CONTAINER_NAME"

