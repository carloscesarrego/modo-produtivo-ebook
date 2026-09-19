#!/usr/bin/env bash
set -euo pipefail
# Assemble PDF from hex chunks (xxd -r -p)
cat build/chunks/*.hex | xxd -r -p > ebook-ia-pratica.pdf
ls -la ebook-ia-pratica.pdf
file ebook-ia-pratica.pdf
python3 -c "d=open('ebook-ia-pratica.pdf','rb').read(5); assert d==b'%PDF-', d"
