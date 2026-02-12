# Any args passed to the make script, use with $(call args, default_value)
# args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

# Build options do web version, debug and release
# Run option does debug version of OS binary, and runs it. This is just for development purposes

# TODO: do windows vs linux run option later

GOOS=linux
BUILDARCH ?= $(shell uname -m)

ifeq ($(BUILDARCH),aarch64)
	BUILDARCH=arm64
endif
ifeq ($(BUILDARCH),x86_64)
	BUILDARCH=amd64
endif

dep:
	flutter doctor
	flutter clean
	flutter pub get

build: clean
	dart run build_runner build --delete-conflicting-outputs
	flutter build web --no-wasm-dry-run --debug -t lib/main.dart --base-href /

debug: build

release: clean
	dart --disable-analytics
	run build_runner build --delete-conflicting-outputs
	flutter build web --wasm --release -t lib/main.dart --base-href /

run: clean
	flutter build linux --debug
	./build/linux/x64/debug/bundle/homefe

clean:
	flutter clean

rebuild: clean build

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
