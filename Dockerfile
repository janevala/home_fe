FROM ghcr.io/cirruslabs/flutter:3.38.6 AS builder
RUN apt update
RUN apt install -y make

WORKDIR /homefe
COPY . .

RUN make debug

FROM nginx:stable-alpine
COPY --from=builder /homefe/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /homefe/build/web /app/web

EXPOSE 7070
