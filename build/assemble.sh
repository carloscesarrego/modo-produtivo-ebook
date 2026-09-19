#!/usr/bin/env bash
set -euo pipefail
mkdir -p build/out
cat build/chunks/*.hex | xxd -r -p > ebook-ia-pratica.pdf
ls -la ebook-ia-pratica.pdf
file ebook-ia-pratica.pdf
