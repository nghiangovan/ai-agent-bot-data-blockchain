#!/bin/bash

# Check if a model name was provided
if [ -z "$1" ]; then
    echo "Usage: . ./download_model.sh <model-name>"
    echo "Available models examples:"
    echo "  - llama2"
    echo "  - codellama"
    echo "  - mistral"
    echo "  - gemma"
    echo "  - neural-chat"
    exit 1
fi

MODEL_NAME=$1

echo "Starting to download model: $MODEL_NAME"

# Check if Docker is running and Ollama container exists
if ! docker ps | grep -q ollama; then
    echo "Error: Ollama container is not running"
    echo "Please start the container with: docker compose up -d"
    exit 1
fi

# Pull the model using Docker exec
echo "Pulling $MODEL_NAME model... This might take several minutes."
docker exec -it ollama ollama pull $MODEL_NAME

# Verify the model was downloaded
echo "Verifying model installation..."
docker exec -it ollama ollama list | grep $MODEL_NAME

if [ $? -eq 0 ]; then
    echo "✅ Model $MODEL_NAME has been successfully downloaded!"
    echo "You can test it with:"
    echo "docker exec -it ollama ollama run $MODEL_NAME \"Your prompt here\""
else
    echo "❌ There was an error downloading the model"
    exit 1
fi