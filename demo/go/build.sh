#!/usr/bin/env bash
set -e
PLATFORM="$1"
mkdir -p build
case "$PLATFORM" in
  windows)
    GOOS=windows GOARCH=amd64 go build -buildmode=c-shared -o build/hello.dll
    ;;
  linux)
    GOOS=linux GOARCH=amd64 go build -buildmode=c-shared -o build/libhello.so
    ;;
  macos)
    GOOS=darwin GOARCH=amd64 go build -buildmode=c-shared -o build/libhello.dylib
    ;;
  android)
    GOOS=android GOARCH=arm64 go build -buildmode=c-shared -o build/libhello.so
    ;;
  ios)
    GOOS=ios GOARCH=arm64 go build -buildmode=c-archive -o build/libhello.a
    ;;
  *)
    echo "Unknown platform: $PLATFORM" >&2
    exit 1
    ;;
esac
