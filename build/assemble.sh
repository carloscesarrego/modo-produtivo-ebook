#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OUT="ebook-ia-pratica.pdf"
TMP="$(mktemp)"

if compgen -G "build/ascii/*.part" > /dev/null; then
  cat $(ls build/ascii/*.part | sort) > "$TMP"
elif compgen -G "build/chunks/*.hex" > /dev/null; then
  cat $(ls build/chunks/*.hex | sort) | xxd -r -p > "$TMP"
else
  echo "No PDF sources found" >&2
  exit 1
fi

head -c 5 "$TMP" | grep -q '%PDF-' || { echo "Invalid PDF magic" >&2; exit 1; }
mv "$TMP" "$OUT"
echo "Wrote $OUT ($(wc -c < "$OUT") bytes)"
