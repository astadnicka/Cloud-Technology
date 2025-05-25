#!/bin/bash

info() {
  echo -e "\n\033[1;32m[$1]\033[0m $2"
}

NODE_VERSION="12"
CONTAINER_NAME="nodejs12-http-server"
PORT=8080
JS_FILE="server.js"

info "CHECK" "Sprawdzanie, czy plik $JS_FILE istnieje..."
if [ ! -f "$JS_FILE" ]; then
  echo "Błąd: Plik $JS_FILE nie został znaleziony w bieżącym katalogu!" >&2
  exit 1
fi

info "CONTAINER" "Uruchamianie kontenera z Node.js w wersji $NODE_VERSION w tle..."
CONTAINER_ID=$(docker run -d -p $PORT:$PORT --name $CONTAINER_NAME -it node:$NODE_VERSION tail -f /dev/null)

if [ $? -ne 0 ]; then
  echo "Błąd: Nie udało się uruchomić kontenera!" >&2
  exit 1
fi

info "STRUKTURA" "Tworzenie katalogu /app w kontenerze"
docker exec "$CONTAINER_ID" mkdir -p /app

info "COPY" "Kopiowanie plików do kontenera..."
docker cp package.json "$CONTAINER_ID":/app/
docker cp "$JS_FILE" "$CONTAINER_ID":/app/

info "ZALEŻNOŚCI" "Instalacja zależności Node.js wewnątrz kontenera"
docker exec -w /app "$CONTAINER_ID" npm install

info "START" "Uruchamianie serwera HTTP w kontenerze..."
docker exec -d -w /app "$CONTAINER_ID" node /app/$JS_FILE

if [ $? -eq 0 ]; then
  info "SUCCESS" "Serwer został uruchomiony w kontenerze!"
  echo "Możesz otworzyć przeglądarkę i przejść pod adres: http://localhost:$PORT"
else
  echo "Błąd: Nie udało się uruchomić serwera w kontenerze!" >&2
  exit 1
fi

info "SPRZĄTANIE" "Aby zatrzymać i usunąć kontener, wykonaj:"
echo "docker stop $CONTAINER_ID"
echo "docker rm $CONTAINER_ID"


