# Home FE

Home FE is news feed application, and is mean to use together with Home BE, wich provides the backend data for this client app.

This app is written in Dart. It can be used both as mobile application, desktop application (Windows, Mac, Linux) and web application.

# TODO

## Front
- Build types: relaese, debug
- User levels: admin, normal
- RssEvent vs RssArchiveEvent?
- Rename rssBloc to generic
- Width and height detection
- Add wide screen layout, and keep current one for narrow
- Add dark mode and light mode

# Flutter notes
```
dart run build_runner build --delete-conflicting-outputs
flutter pub get
```

# Docker notes
```
sudo docker network create home-network

sudo docker build --no-cache -f Dockerfile -t news-frontend .
sudo docker run --name front-host --network home-network -p 7070:7070 --restart always -d news-frontend

sudo docker network connect home-network front-host
```

### OAuth2 grant types, not in use currently

1. Resource Owner Password Credentials Grant: This grant type allows users to provide their username and password directly to the client, which then exchanges them for an access token.

2. Refresh Token Grant: Once the client has obtained an initial access token, it can use a refresh token to request a new access token without requiring the user to re-authenticate.

### HTTPS & WASM

HTTPS is required to run WASM in VPS NGINX
Domain name is required for HTTPS

```
sudo apt install certbot python3-certbot-nginx
```
