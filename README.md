# Home FE

Home FE is news feed application, and is mean to use together with Home BE, wich provides the backend data for this client app.

This app is written in Dart. It can be used both as mobile application, desktop application (Windows, Mac, Linux) and web application.

# TODO

## Front
### HTTPS
    - buy https://techeavy.news from godaddy
    - enable secure_persistent_storage
    - enable https in nginx
    - enable WASM
    - enable https in dio???
    - enable https in firewall
    - Docker???

### Rest of TODOs
- Theme bloc
- Locale bloc?
- Add language selection + use preference saved to cookie
- Localize timeago.format
- Re-do SVGs, add 3 new ones, add flags: English, Finnish, German, Thai, Brazil, Spain
- Add Error text theme, and put it into use in error scenarios
- User levels: admin, normal
- RssEvent vs RssArchiveEvent?
- Rename rssBloc to generic
- Width and height detection
- Add wide screen layout, and keep current one for narrow
- Add dark mode and light mode
- Analytics and to what acount? create account?
- Deploy identifiable version of Gemma to Ollama
- Add LLM with version, to translated table entry in Backend. Show in frontend

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

sudo docker build --no-cache -f Dockerfile -t news-frontend .
sudo docker run --name front-host --network home-network -p 80:7070 --restart always -d news-frontend

sudo docker network connect home-network front-host
```

### Docker transfer prebuilt container
```
sudo docker ps
sudo docker commit ID news-frontend:rel8
sudo docker save -o news-frontend-rel8.tar news-frontend:rel8
sudo gzip news-frontend-rel8.tar
sudo chown jay news-frontend-rel8.tar.gz
scp news-frontend-rel8.tar.gz jay@IP:
sudo docker load -i news-frontend-rel8.tar.gz
sudo docker run -d --name news-frontend --network home-network -p 80:7070 news-frontend:rel8
```
