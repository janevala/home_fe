FROM bitnami/debian-base-buildpack:latest AS builder
RUN curl -Lf https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.3-stable.tar.xz | tar -xJ -C /
ENV PATH="/flutter/bin:${PATH}"
WORKDIR /homefe_build
COPY . .
RUN flutter clean
RUN flutter pub get
RUN dart --disable-analytics
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release -t lib/main.dart --base-href /web/
FROM bitnami/nginx:latest
COPY --from=builder /homefe_build/build/web /app/web
EXPOSE 8092
