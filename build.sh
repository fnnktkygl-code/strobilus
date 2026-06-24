#!/bin/bash
set -e

# Disable root warning
export FLUTTER_ALLOW_ROOT=true

# Limite la mémoire de la VM Dart pour éviter l'erreur "Out of Memory" (exit code -9) sur Vercel
export DART_VM_OPTIONS="--old_gen_heap_size=512"

# Clone or pull Flutter
if [ -d "flutter" ]; then
  echo "Flutter directory exists. Pulling latest changes..."
  cd flutter
  git pull
  cd ..
else
  echo "Cloning Flutter..."
  git clone --depth 1 https://github.com/flutter/flutter.git -b stable
fi

export PATH="$PATH:$(pwd)/flutter/bin"

# Flutter config
flutter config --no-analytics
flutter config --enable-web

# Get dependencies
flutter pub get

# Add --no-tree-shake-icons to avoid memory spikes during font tree-shaking
flutter build web --release --no-wasm-dry-run --no-tree-shake-icons
