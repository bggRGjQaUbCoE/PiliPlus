#!/usr/bin/env python3
"""Check native artifacts before platform packaging."""
import hashlib
from pathlib import Path
import sys
root = Path(__file__).resolve().parent / 'artifacts' / sys.argv[1]
manifest = root / 'SHA256SUMS'
if not manifest.exists(): raise SystemExit(f'Missing {manifest}; run native/build.py first')
for entry in manifest.read_text().splitlines():
    digest, name = entry.split('  ', 1)
    path = (root / name).resolve()
    if not path.is_relative_to(root.resolve()): raise SystemExit('Invalid artifact path')
    if hashlib.sha256(path.read_bytes()).hexdigest() != digest:
        raise SystemExit(f'Checksum mismatch: {path}')
print(f'Verified {sys.argv[1]} native artifacts')
