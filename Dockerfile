FROM ghcr.io/cirruslabs/flutter:stable AS builder

RUN useradd flutterbuilder
RUN mkdir /home/flutterbuilder
RUN chown flutterbuilder:flutterbuilder /home/flutterbuilder
RUN chmod a+rwx /sdks/flutter/ -R

WORKDIR /homefe_build
COPY . .

USER flutterbuilder
# RUN flutter clean
RUN flutter pub get
RUN dart --disable-analytics
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release -t lib/main.dart --base-href /web/

FROM nginx:stable-alpine
COPY --from=builder /homefe_build/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /homefe_build/build/web /app/web

EXPOSE 7070
