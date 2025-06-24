#!/usr/bin/env bash
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
source "$DIR/common.sh"
setup_flutter
flutter --version
flutter doctor
flutter pub get
flutter build linux --release -v
