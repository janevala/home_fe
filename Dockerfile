FROM debian:latest AS builder
RUN apt update && apt install -y curl xz-utils
RUN curl -Lf https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz --output flutter.tar.xz
RUN tar xvfJ flutter.tar.xz -C /
ENV PATH="/flutter/bin:${PATH}"
WORKDIR /homefe_build
COPY . .
RUN flutter pub get
RUN flutter build web --release -t lib/main.dart --base-href /web/
FROM bitnami/nginx:latest
COPY --from=builder /homefe_build/build/web /app/web
EXPOSE 8080
