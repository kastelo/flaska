#!/bin/bash
set -euo pipefail

MARKETINGVERSION=$(grep version: pubspec.yaml | tr -d version: | tr -d ' ')

flutter pub get
flutter run \
  --dart-define=BUILD="${1:-0}" \
  --dart-define=GITVERSION="$(git describe)" \
  --dart-define=MARKETINGVERSION="${MARKETINGVERSION}"
