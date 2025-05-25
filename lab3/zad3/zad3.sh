#!/bin/bash

echo "running the containers.."
docker-compose up --build -d

echo "waiting for start"
sleep 5

echo "checking the containers"
docker ps
