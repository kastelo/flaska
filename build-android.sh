#!/bin/bash
set -euo pipefail

echo "$ANDROID_KEY_JKS" | base64 -d > android/app/key.jks
echo "$ANDROID_KEY_PROPERTIES" > android/key.properties

flutter --version
GIT_VERSION=$(git describe)
MARKETING_VERSION=$(./next-version.sh)
BUILD_NUMBER=${BUILD_NUMBER:-0}

flutter pub get
flutter build appbundle \
  --release \
  --build-name="$MARKETING_VERSION" \
  --build-number="$BUILD_NUMBER" \
  --dart-define=BUILD="$BUILD_NUMBER" \
  --dart-define=GITVERSION="$GIT_VERSION" \
  --dart-define=MARKETINGVERSION="$MARKETING_VERSION"
