#!/bin/bash

curl -sk https://localhost | grep -q "siema"

if [ $? -eq 0 ]; then
    echo "test passed"
    exit 0
else
    echo "test failed"
    exit 1
fi
