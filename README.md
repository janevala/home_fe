# Home FE

Tech Heavy News Frontend.

# Get Started, dev evironment files needed. Copy from templates:
.env
.vscode/launch.json
pipeline.sh


# TODO
## Front Bugs
- Search is broken because localization

## Back

- Join translation queries in both search and archive requests
```rows, err := db.Query(
    `SELECT fi.link, fi.published, fi.source, fi.thumbnail, fi.uuid,
            ft.published_parsed, ft.language, ft.title, ft.description, ft.llm
     FROM feed_translations ft
     JOIN feed_items fi ON fi.id = ft.item_id
     WHERE ft.language = $2
       AND (ft.title ILIKE '%' || $1 || '%'
            OR ft.description ILIKE '%' || $1 || '%')
     ORDER BY ft.published_parsed DESC
     LIMIT 50`, searchQuery, lang)```

- Ping is ollama alive
- Ping what translations are available

## HTTPS
    - buy https://techeavy.news from godaddy
    - enable secure_persistent_storage
    - enable https in nginx
    - enable WASM
    - enable https in dio???
    - enable https in firewall
    - Docker???

## Nice to have TODOs
- Server stats as in backend page, or similar. Data already in front
- Analytics and to what acount? create account?

# Flutter notes
```
dart run build_runner build --delete-conflicting-outputs
flutter pub get
```

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

### OAuth2 grant types, not in use currently

1. Resource Owner Password Credentials Grant: This grant type allows users to provide their username and password directly to the client, which then exchanges them for an access token.

2. Refresh Token Grant: Once the client has obtained an initial access token, it can use a refresh token to request a new access token without requiring the user to re-authenticate.

### Docker transfer prebuilt container
```
sudo docker commit front-host news-frontend:rel18
sudo docker save -o news-frontend-rel18.tar news-frontend:rel18
sudo gzip news-frontend-rel18.tar
sudo chown jay news-frontend-rel18.tar.gz
scp news-frontend-rel18.tar.gz <user>@<your.remote.host>:
sudo docker load -i news-frontend-rel18.tar.gz
sudo docker run -d --name news-frontend --network home-network -p 80:7070 news-frontend:rel18
```
