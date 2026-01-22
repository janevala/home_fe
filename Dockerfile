FROM ghcr.io/cirruslabs/flutter:3.38.6 AS builder

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
