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

API := $(shell cat .env | grep APP_API | cut -d '=' -f2)
ifeq ($(API),)
	API=http://api-host:7071
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
	flutter pub get

debug:
	flutter pub get
	dart --enable-analytics
	dart run build_runner build --delete-conflicting-outputs
	flutter build web --debug -t lib/main.dart --base-href / --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API)

build: debug

release:
	flutter pub get
	dart --disable-analytics
	dart run build_runner build --delete-conflicting-outputs
	flutter build web --release -t lib/main.dart --base-href / --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API)

chrome: clean
	flutter run -d chrome --web-port 7070 --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API)

web: chrome

linux: clean
	flutter pub get
	dart --enable-analytics
	dart run build_runner build --delete-conflicting-outputs
	flutter build linux --debug --dart-define=APP_VERSION=$(VERSION) --dart-define=APP_API=$(API)
	./build/linux/x64/debug/bundle/homefe

clean:
	yes | dart pub cache clean
	dart run build_runner clean 2>/dev/null || true
	flutter clean

rebuild: clean build
