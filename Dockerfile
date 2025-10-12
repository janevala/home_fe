# FROM cirrusci/flutter:latest AS builder
# FROM ghcr.io/cirruslabs/flutter:stable AS builder
FROM ghcr.io/cirruslabs/flutter:3.37.0-0.1.pre@sha256:b41daff806047ebaa6629004a94c790f68a0780534d6c0c80becce07c7a15c70 AS builder
RUN sudo apt-get update && sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev

RUN useradd flutterbuilder
RUN mkdir /home/flutterbuilder
RUN chown flutterbuilder:flutterbuilder /home/flutterbuilder
RUN chmod a+rwx /sdks/flutter/ -R

WORKDIR /homefe_build
COPY . .

USER flutterbuilder
RUN flutter doctor
RUN flutter pub get
RUN dart --disable-analytics
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release -t lib/main.dart --base-href /web/

FROM nginx:stable-alpine
COPY --from=builder /homefe_build/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /homefe_build/build/web /app/web

EXPOSE 7070
