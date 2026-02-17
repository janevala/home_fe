# Any args passed to the make script, use with $(call args, default_value)
# args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

# Build options do web version, debug and release
# Run option does debug version of OS binary, and runs it. This is just for development purposes

GOOS ?= linux
BUILDARCH ?= $(shell uname -m)
VERSION := $(shell git describe --always --long --dirty)

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
	flutter build web --no-wasm-dry-run --debug -t lib/main.dart --base-href / --dart-define=APP_VERSION=$(VERSION) --dart-define=BRAND="Debug News"

debug: build

release: clean
	dart --disable-analytics
	dart run build_runner build --delete-conflicting-outputs
	flutter build web --wasm --release -t lib/main.dart --base-href / --dart-define=APP_VERSION=$(VERSION) --dart-define=BRAND="Tech-Heavy News"

chrome: clean
	flutter run -d chrome --web-port 7070 --dart-define=APP_VERSION=$(VERSION) --dart-define=BRAND="Debug News"

web: chrome

linux: clean
# 	flutter run -d linux --debug --dart-define=APP_VERSION=$(VERSION) --enable-software-rendering
	flutter build linux --debug --dart-define=APP_VERSION=$(VERSION) --dart-define=BRAND="Debug News"
	./build/linux/x64/debug/bundle/homefe

clean:
	flutter clean

rebuild: clean build
