FROM debian:stable-slim AS builder
RUN apt-get update && apt-get install -y curl xz-utils ca-certificates --no-install-recommends && \
	curl -Lf https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.6-stable.tar.xz | tar -xJ -C / && \
	rm -rf /var/lib/apt/lists/*
ENV PATH="/flutter/bin:${PATH}"
WORKDIR /homefe_build
COPY . .
RUN flutter clean
RUN flutter pub get
RUN dart --disable-analytics
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release -t lib/main.dart --base-href /web/
FROM nginx:stable-alpine
COPY --from=builder /homefe_build/build/web /app/web
EXPOSE 7070
