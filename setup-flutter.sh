#!/bin/bash

version=2.5.2-stable
sdk=~/sdk/flutter-"$version"

if [[ ! -d "$sdk" ]] ; then
    rm -f flutter.zip
    curl -L -o flutter.zip "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${version}.zip"

    mkdir -p "$sdk"
    unzip flutter.zip -d "$sdk"
fi

export PATH="$sdk/flutter/bin:$PATH"
echo "export PATH=\"$sdk/flutter/bin:\$PATH\""
export FLUTTER_ROOT="$sdk/flutter"
echo "export FLUTTER_ROOT=\"$sdk/flutter\""

