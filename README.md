# Home FE

Home FE is news feed application, and is mean to use together with Home BE, wich provides the backend data for this client app.

This app is written in Dart. It can be used both as mobile application, desktop application (Windows, Mac, Linux) and web application.

# TODO

## Next week
## Front
- Theme is buggy, fix it, or is it buggy?

## Back
- Start doing translations


### HTTPS
    - buy https://techeavy.news from godaddy
    - enable secure_persistent_storage
    - enable https in nginx
    - enable WASM
    - enable https in dio???
    - enable https in firewall
    - Docker???

### Rest of TODOs
- Locale bloc?
- Add language selection + use preference saved to cookie
- Localize timeago.format
- Deploy identifiable version of Gemma to Ollama
- Add LLM with version, to translated table entry in Backend. Show in frontend
- Rename rssBloc to generic
- Analytics and to what acount? create account?

# Flutter notes
```
dart run build_runner build --delete-conflicting-outputs
flutter pub get
```

### OAuth2 grant types, not in use currently

1. Resource Owner Password Credentials Grant: This grant type allows users to provide their username and password directly to the client, which then exchanges them for an access token.

2. Refresh Token Grant: Once the client has obtained an initial access token, it can use a refresh token to request a new access token without requiring the user to re-authenticate.

### HTTPS & WASM

HTTPS is required to run WASM in VPS NGINX
Domain name is required for HTTPS
Default port 443 nginx config

```
sudo apt install certbot python3-certbot-nginx
```

# Docker notes

```
sudo docker network create home-network

grep flutter_bootstrap web/index.html
sudo docker build --no-cache -f Dockerfile -t news-frontend .
sudo docker run --name front-host --network home-network -p 80:7070 --restart always -d news-frontend

sudo docker network connect home-network front-host
```

### Docker transfer prebuilt container
```
sudo docker ps
sudo docker commit ID news-frontend:rel13
sudo docker save -o news-frontend-rel13.tar news-frontend:rel13
sudo gzip news-frontend-rel13.tar
sudo chown jay news-frontend-rel13.tar.gz
scp news-frontend-rel13.tar.gz jay@IP:
sudo docker load -i news-frontend-rel13.tar.gz
sudo docker run -d --name news-frontend --network home-network -p 80:7070 news-frontend:rel13
```
