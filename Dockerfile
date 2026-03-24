FROM ghcr.io/cirruslabs/flutter:3.41.5 AS builder
RUN apt update
RUN apt install -y make bash

WORKDIR /homefe
COPY . .

RUN ./build.sh 

FROM nginx:stable-alpine
COPY --from=builder /homefe/nginx/nginx.https_wasm.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /homefe/build/web /app/web

EXPOSE 7070
