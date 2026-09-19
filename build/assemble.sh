#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TMP=$(mktemp)
if compgen -G "build/ascii/*.part" > /dev/null; then
  cat $(ls build/ascii/*.part | sort) > "$TMP"
elif compgen -G "build/chunks/*.hex" > /dev/null; then
  n=$(ls build/chunks/*.hex | wc -l | tr -d ' ')
  if [ "$n" -lt 24 ]; then
    echo "Need 24 hex chunks, have $n" >&2
    exit 1
  fi
  cat $(ls build/chunks/*.hex | sort) | xxd -r -p > "$TMP"
else
  echo "No PDF sources" >&2
  exit 1
fi
head -c 5 "$TMP" | grep -q '%PDF-' || { echo "Invalid PDF magic" >&2; exit 1; }
SIZE=$(wc -c < "$TMP" | tr -d ' ')
if [ "$SIZE" -lt 90000 ]; then
  echo "PDF too small ($SIZE)" >&2
  exit 1
fi
mv "$TMP" ebook-ia-pratica.pdf
echo "Wrote ebook-ia-pratica.pdf ($SIZE bytes)"
