#!/bin/bash
set -euo pipefail

flutter --version
GIT_VERSION=$(git describe)
MARKETING_VERSION=$(./next-version.sh)
BUILD_NUMBER=${BUILD_NUMBER:-0}

flutter pub get
flutter test
flutter build macos \
  --release \
  --build-name="$MARKETING_VERSION" \
  --build-number="$BUILD_NUMBER" \
  --dart-define=BUILD="$BUILD_NUMBER" \
  --dart-define=GITVERSION="$GIT_VERSION" \
  --dart-define=MARKETINGVERSION="$MARKETING_VERSION"

pushd build/macos/Build/Products/Release
zip -r "Flaska-macos-$MARKETING_VERSION.zip" Flaska.app
