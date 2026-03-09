#!/bin/bash -x

# Pre-requisites:
# 1. This is run on development server that has access to Ollama server, or in Ollama server itself

if [ ! -f ".env" ]; then
    echo "Error: .env file not found"
    exit 1
fi

REL=$(cat .env | grep REL | cut -d '=' -f2)

# Build
time sudo docker build --no-cache -f Dockerfile -t news-frontend .
sudo docker run --name front-host --network home-network -p 80:7070 --restart always -d news-frontend

# Commit and save
sudo docker commit front-host news-frontend:$REL
sudo docker save -o news-frontend-$REL.tar news-frontend:$REL
sudo gzip news-frontend-$REL.tar
sudo chown jay news-frontend-$REL.tar.gz
scp news-frontend-$REL.tar.gz <user>@<your.remote.host>:

# Load and run on production
docker context use production-context
docker load -i news-frontend-$REL.tar.gz
docker run -d --name news-frontend --network home-network -p 80:7070 news-frontend:$REL
docker context use default
