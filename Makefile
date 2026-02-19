# Any args passed to the make script, use with $(call args, default_value)
# args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

# Build options do web version, debug and release
# Run option does debug version of OS binary, and runs it. This is just for development purposes

GOOS ?= linux
BUILDARCH ?= $(shell uname -m)
VERSION := $(shell git describe --always --long --dirty)
API ?= $(cat .env | grep APP_API | cut -d '=' -f2)
API ?= http://api-host:7071

ifeq ($(BUILDARCH),aarch64)
	BUILDARCH=arm64
endif
ifeq ($(BUILDARCH),x86_64)
	BUILDARCH=amd64
endif

help:
	@echo "Available targets:"
	@echo "  dep       - Install dependencies"
	@echo "  build     - Build debug version"
	@echo "  debug     - Alias for build"
	@echo "  release   - Build release version"
	@echo "  run       - Run linux binary"
	@echo "  clean     - Clean up the build directory"
	@echo "  rebuild   - Rebuild the application"
	@echo "  help      - Show this help message"

dep:
	flutter doctor
	flutter clean
	dart run build_runner build --delete-conflicting-outputs
	flutter pub get

build: clean
	dart run build_runner build --delete-conflicting-outputs
	flutter build web --no-wasm-dry-run --debug -t lib/main.dart --base-href / --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API) --dart-define=BRAND="Debug News"

debug: build

release: clean
	dart --disable-analytics
	dart run build_runner build --delete-conflicting-outputs
	flutter build web --wasm --release -t lib/main.dart --base-href / --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API) --dart-define=BRAND="Tech-Heavy News"

chrome: clean
	flutter run -d chrome --web-port 7070 --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API) --dart-define=BRAND="Debug News"

web: chrome

linux: clean
	flutter build linux --debug --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API) --dart-define=BRAND="Debug News"
	./build/linux/x64/debug/bundle/homefe

clean:
	dart pub cache clean
	flutter pub run build_runner clean
	flutter clean

rebuild: clean build
