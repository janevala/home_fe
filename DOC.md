# System Architecture

## Overview

A Flutter (Dart) frontend application communicating with a Golang backend, both running in Docker containers connected via a shared Docker network. The backend serves as the API layer connecting to a PostgreSQL database for persistent storage.

---

## 1. Application Layers

### Frontend (home_fe)
- **Language**: Dart/Flutter
- **Port**: 7070
- **Container Name**: `front-host`
- **Reverse Proxy**: Nginx (HTTPS via Caddy config)
- **Architecture**: Mobile/Desktop/Web hybrid app
- **Key Features**: 
  - RSS feed aggregation and display
  - Multi-platform support (iOS, Android, Desktop)
  - Localization support (English, Thai locales)
  - Image caching with thumbnail generation

### Backend (home_be)
- **Language**: Go (Golang)
- **Port**: 7071
- **Container Name**: `api-host`
- **HTTP Server**: Net/http stdlib or third-party framework
- **Database**: PostgreSQL (`postgres://postgres:<user>@<postgres.host>:<pass>/homebedb?sslmode=disable`)
- **Security**: 
  - All endpoints require `code=123` query parameter for authentication
  - CORS enabled globally

### Data Layer
- **Database**: PostgreSQL container on `home-network`
- **Port**: 5432
- **Container Name**: `postgres-host`
- **Connection String**: `postgres://postgres:<user>@<postgres.host>:<pass>/homebedb?sslmode=disable`
- **Usage**: Backend stores and retrieves news content, user preferences, configuration

---

## 2. Architecture Diagram

```
┌───────────────────────────────────────────────────────────────────────────┐
│                               EXTERNAL NETWORK                            │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │                         Caddy Server (HTTPS)                      │   │
│   │                        (nginx reverse proxy)                      │   │
│   │   ┌───────────────────────────────────────────────────────────┐   │   │
│   │   │                   PORT 443/80 (HTTPS/HTTP)                │   │   │
│   │   └───────────────────────────────────────────────────────────┘   │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                   │                                       │
│                                   ▼                                       │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │                     DOCKER NETWORK: home-network                  │   │
│   │   ┌──────────────────────────┐      ┌──────────────────────────┐  │   │
│   │   │     Backend Container    │◄────►│    Frontend Container    │  │   │
│   │   │        (api-host)        │      │       (front-host)       │  │   │
│   │   │                          │      │                          │  │   │
│   │   │     PORT 7071 (HTTPS)    │      │      PORT 7070 (HTTPS)   │  │   │
│   │   │     Golang + API         │◄────►│      Flutter Web App     │  │   │
│   │   │     (home_be_backend)    │      │      (news-frontend)     │  │   │
│   │   │                          │      │                          │  │   │
│   │   │  ┌────────────────────┐  │      │  ┌────────────────────┐  │  │   │
│   │   │  │ API Endpoints      │──┼──────┼─►│ Flutter Web Routes │  │  │   │
│   │   │  │ Go Handlers        │  │      │  │ (go_router)        │  │  │   │
│   │   │  │ JSON Responses     │◄─┼──────┼──│ Flutter Bloc State │  │  │   │
│   │   │  └────────────────────┘  │      │  └────────────────────┘  │  │   │
│   │   └──────────────────────────┘      └──────────────────────────┘  │   │
│   │                 │                                                 │   │
│   │                 ▼                                                 │   │
│   │   ┌──────────────────────────┐                                    │   │
│   │   │   PostgreSQL Container   │                                    │   │
│   │   │      (postgres-host)     │                                    │   │
│   │   │       PORT 5432          │                                    │   │
│   │   │    Database: homebedb    │                                    │   │
│   │   └──────────────────────────┘                                    │   │
│   └───────────────────────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────────────────┘

Data Flow:
1. User → HTTPS (Caddy/Nginx) → Frontend
2. Frontend → HTTP API (localhost or internal network) → Backend
3. Backend → PostgreSQL Database → Response to Frontend
```

---

## 3. Communication Patterns

### Frontend ↔ Backend API

**Request Format**:
```dart
// Flutter frontend makes requests like:
Dio().get(
  'http://api-host:7071/feed', 
  queryParameters: { 'code': '123' }
);
```

**Backend Response Format**:
```json
{
  "status": 200,
  "data": {
    "feed": [
      {
        "title": "News Title",
        "link": "https://example.com",
        "published": "2024-01-15T10:30:00Z"
      }
    ]
  }
}
```

**Authentication**: All requests require `code=123` query parameter (static/hardcoded auth)

### Docker Container Communication

- **Network**: `home-network` (user-defined bridge network)
- **Service Discovery**: Containers communicate via container names (`api-host`, `front-host`)
- **No DNS needed** within the same network - direct hostname resolution

---

## 4. Frontend Stack & Dependencies

### Core Flutter Packages
```yaml
dio:                          # HTTP client for API calls
flutter_bloc:                 # State management (Bloc pattern)
go_router:                    # Navigation/Router
cached_network_image:         # Image caching
rss_dart:                     # RSS feed parsing
html:                         # HTML rendering for feed content
timeago:                      # Relative time formatting ("2h ago")
flutter_svg:                  # SVG image support
share_plus:                   # Native share integration
```

### Assets Structure
```
assets/
├── app-logo.svg              # Primary logo
├── app-logo-light.svg        # Light background variant
└── thumbnails/               # Feed thumbnail cache
    ├── random.svg            # Default/fallback thumbnail
    ├── phoronix.svg
    ├── slashdot.svg
    ├── techcrunch.svg
    └── ... (other feed logos)

assets/flags/
├── flag-en.svg              # English locale
├── flag-th.svg              # Thai locale
├── flag-fi.svg              # Finnish locale
├── flag-de.svg              # German locale
└── flag-jp.svg              # Japanese locale
```

---

## 5. Backend Stack & Dependencies

### Go Module Dependencies (from Makefile)
```bash
github.com/mmcdole/gofeed      # RSS feed parsing
github.com/google/uuid         # UUID generation
github.com/lib/pq              # PostgreSQL driver
github.com/rifaideen/talkative # Custom utility/library
github.com/joho/godotenv       # Environment variable loader
github.com/tailscale/hujson    # JSON parsing with pretty-print support
```

### Makefile Targets
- `make dep`     → Install vendor dependencies
- `make vet`     → Run go vet linter
- `make build`   → Build binary for current platform
- `make debug`   → Debug build (with dev index.html)
- `make release` → Production build (with release index.html)
- `make run`     → Run local development server
- `make clean`   → Clean build artifacts

### Build Modes

**Debug Mode**:
```bash
make debug
# Uses: index.debug.html
# GOARCH detection for platform-specific builds
```

**Release Mode**:
```bash
make release
# Uses: index.release.html
# Production optimizations
```

---

## 6. Docker Configuration

### Frontend Dockerfile (Multi-stage)
```dockerfile
# Stage 1: Build Flutter app
FROM ghcr.io/cirruslabs/flutter:3.38.6 AS builder
WORKDIR /homefe
COPY . .
RUN ./build.sh

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine
COPY --from=builder /homefe/nginx/nginx.https_wasm.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /homefe/build/web /app/web
EXPOSE 7070
```

### Backend Dockerfile
```dockerfile
FROM golang:1.24
RUN apt update && apt install -y make
ENV PATH="/usr/bin:${PATH}"
WORKDIR /homebe
COPY . .
RUN rm -f go.mod && rm -f go.sum && ./build.sh
EXPOSE 7071
CMD ["./home_be_backend"]
```

### Deployment Commands

**Setup Network**:
```bash
sudo docker network create home-network
```

**Build & Run Frontend**:
```bash
sudo docker build --no-cache -f Dockerfile -t news-frontend .
sudo docker run \
  --name front-host \
  --network home-network \
  -p 7070:7070 \
  --restart always \
  -d news-frontend

sudo docker network connect home-network front-host
```

**Build & Run Backend**:
```bash
sudo docker build --no-cache -f Dockerfile -t news-backend .
sudo docker run \
  --name api-host \
  --network home-network \
  -p 7071:7071 \
  --restart always \
  -d news-backend

sudo docker network connect home-network api-host
```

---

## 7. Environment Configuration

### Frontend (.env.example)
```bash
ENV=release                   # Build environment
REL=release1                  # Release variant
APP_API=http://api-host:7071  # Backend API endpoint
```

### Backend (.env.example)
```bash
ENV=debug                     # Build environment (debug/release)
DATABASE_URL=postgres://postgres:<user>@<postgres.host>:<pass>/homebedb?sslmode=disable
```

---

## 8. Development Workflow

### Frontend Development Steps
```bash
# Install dependencies
dart run build_runner build --delete-conflicting-outputs
flutter pub get

# Hot reload development
flutter run -d chrome

# Docker deployment
./build.sh
sudo docker build ...
```

### Backend Development Steps
```bash
# Setup Go environment
sudo apt install -y golang make
go mod init github.com/janevala/home_be

# Install dependencies (from Makefile)
make dep

# Lint code
make vet

# Run local development
make run

# Build for deployment
make release
```

---

## 9. Security Considerations

### Authentication
- **Backend**: All endpoints require `code=123` query parameter
- **Frontend**: No client-side authentication (relies on backend)
- **Database**: SSL disabled in connection string (`sslmode=disable`)

### CORS Configuration
- Backend enables CORS for all origins (development mode)
- Should be restricted in production

### Network Security
- Uses HTTPS via Caddy reverse proxy
- Docker network isolation between containers
- Database on separate host requires external access control

---

## 10. Future Enhancements

### Frontend TODOs
- [ ] Detect available translations/ping for i18n support
- [ ] Add backend server stats to frontend monitoring page
- [ ] Implement Thai locale with Buddhist Era calendar
- [ ] Configure analytics tracking and account management
- [ ] Optimize image loading strategies

### Backend Improvements
- [ ] Document all API endpoints with OpenAPI/Swagger
- [ ] Add rate limiting for public endpoints
- [ ] Implement proper authentication (JWT/OAuth2)
- [ ] Add structured logging
- [ ] Create health check endpoint

---

## 11. Quick Reference

### Port Summary

### Network Communication

### Environment Variables Cheat Sheet

---

## 12. Contact & Resources

### Repository Links
- **Frontend**:      https://github.com/janevala/home_fe
- **Backend**:       https://github.com/janevala/home_be
- **Data pipeline**: https://github.com/janevala/home_be_crawler

### Build Outputs
- Frontend: `build/web/`
- Backend: Compiled binary `home_be_backend`
