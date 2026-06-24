#!/bin/bash
if cd flutter; then
  git pull
  cd ..
else
  git clone https://github.com/flutter/flutter.git -b stable
fi
./flutter/bin/flutter config --no-analytics
./flutter/bin/flutter pub get
./flutter/bin/flutter build web --release --no-wasm-dry-run --web-renderer canvaskit
