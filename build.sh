#!/bin/bash
if cd flutter; then
  git pull
  cd ..
else
  git clone https://github.com/flutter/flutter.git -b stable
fi
./flutter/bin/flutter config --no-analytics
./flutter/bin/flutter pub get
# Limite la mémoire de la VM Dart pour éviter l'erreur "Out of Memory" (exit code -9) sur Vercel
export DART_VM_OPTIONS="--old_gen_heap_size=800"

./flutter/bin/flutter build web --release --no-wasm-dry-run
