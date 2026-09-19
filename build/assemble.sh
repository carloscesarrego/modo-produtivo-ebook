#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OUT="ebook-ia-pratica.pdf"
TMP="$(mktemp)"

n=$(ls build/chunks/*.hex 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" -lt 24 ]; then
  echo "Need 24 hex chunks, have $n — skipping assemble" >&2
  exit 0
fi

cat $(ls build/chunks/*.hex | sort) | xxd -r -p > "$TMP"
head -c 5 "$TMP" | grep -q '%PDF-' || { echo "Invalid PDF magic" >&2; exit 1; }
SIZE=$(wc -c < "$TMP" | tr -d ' ')
if [ "$SIZE" -lt 90000 ]; then
  echo "PDF too small ($SIZE) — refusing to commit" >&2
  exit 1
fi
mv "$TMP" "$OUT"
echo "Wrote $OUT ($SIZE bytes)"
