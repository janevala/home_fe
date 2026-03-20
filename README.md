# Home FE

Tech Heavy News Frontend.

# Get Started, dev evironment files needed. Copy from templates:
.env
.vscode/launch.json
pipeline.sh

# TODO

## Nice to have
- Ping what translations are available
- Server stats as in backend page, or similar. Data already in front
- Thai locale buddha year
- Analytics and to what acount? create account?

# Command line notes

## Flutter
```
dart run build_runner build --delete-conflicting-outputs
flutter pub get
```

## Docker
```
sudo docker network create home-network
sudo docker context create production-context --docker "host=ssh://<user>@<your.remote.host>"

sudo docker build --no-cache -f Dockerfile -t news-frontend .
sudo docker run --name front-host --network home-network -p 7070:7070 --restart always -d news-frontend

sudo docker network connect home-network front-host
```
