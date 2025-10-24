FROM ghcr.io/cirruslabs/flutter:3.37.0-0.1.pre@sha256:b41daff806047ebaa6629004a94c790f68a0780534d6c0c80becce07c7a15c70 AS builder

WORKDIR /homefe_build
COPY . .

RUN flutter doctor
RUN flutter clean
RUN flutter pub get
RUN dart --disable-analytics
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --wasm --release -t lib/main.dart --base-href /

FROM nginx:stable-alpine
COPY --from=builder /homefe_build/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /homefe_build/build/web /app/web

EXPOSE 7070
