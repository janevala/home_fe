#!/bin/bash -x

# Pre-requisites:
# 1. This is run on development server that has access to Ollama server, or in Ollama server itself

if [ ! -f ".env" ]; then
    echo "Error: .env file not found"
    exit 1
fi

sudo docker build --no-cache -f Dockerfile -t news-frontend .
sudo docker run --name front-host --network home-network -p 80:7070 --restart always -d news-frontend


sudo docker commit front-host news-frontend:rel18
sudo docker save -o news-frontend-rel18.tar news-frontend:rel18
sudo gzip news-frontend-rel18.tar
sudo chown jay news-frontend-rel18.tar.gz
scp news-frontend-rel18.tar.gz jay@IP:
sudo docker load -i news-frontend-rel18.tar.gz
sudo docker run -d --name news-frontend --network home-network -p 80:7070 news-frontend:rel18
