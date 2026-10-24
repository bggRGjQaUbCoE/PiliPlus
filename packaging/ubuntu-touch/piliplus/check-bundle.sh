#!/bin/bash
# Checks a prebuilt arm64 bundle against the OnePlus 6T's Focal libraries.
set -euo pipefail

bundle=${1:-"$(cd "$(dirname "$0")" && pwd)/bundle"}

python3 - "$bundle" <<'PY'
import re
import subprocess
import sys
from pathlib import Path

root = Path(sys.argv[1])
app = root / "piliplus"
engine = root / "lib" / "libflutter_linux_gtk.so"
icu = root / "data" / "icudtl.dat"
maliit = root / "lib" / "im-maliit.so"
for path in (app, engine, icu, maliit):
    if not path.is_file():
        raise SystemExit(f"missing {path}")

max_glibc = (2, 31)
max_glibcxx = (3, 4, 28)
max_cxxabi = (1, 3, 12)
banned = ("libwebkit", "libmpv", "libayatana", "libappindicator", "libjvm")

paths = [app]
paths.extend(sorted(p for p in (root / "lib").glob("*.so") if not p.is_symlink()))
paths.extend(sorted(p for p in (root / "lib").glob("*.so.*") if not p.is_symlink()))

def version_tuples(text, prefix):
    found = []
    for match in re.findall(re.escape(prefix) + r"[0-9.]+", text):
        parts = tuple(int(piece) for piece in match[len(prefix):].split(".") if piece)
        found.append((match, parts))
    return found

def needed(dynamic):
    names = []
    for line in dynamic.splitlines():
        if "NEEDED" in line:
            names.append(line.split("[", 1)[1].split("]", 1)[0])
    return names

for path in paths:
    header = subprocess.check_output(["readelf", "-h", str(path)], text=True)
    dynamic = subprocess.check_output(["readelf", "-d", str(path)], text=True)
    versions = subprocess.check_output(["readelf", "-V", str(path)], text=True)
    libs = needed(dynamic)
    print(f"== {path.name}")
    print("NEEDED:", ", ".join(libs))
    if "AArch64" not in header:
        raise SystemExit(f"{path} is not an AArch64 ELF")
    if "/home/" in dynamic or "x86_64" in dynamic:
        raise SystemExit(f"{path} has a host library path")
    if path.name == "piliplus" and "$ORIGIN/lib" not in dynamic:
        raise SystemExit("piliplus RUNPATH is not $ORIGIN/lib")
    for name in libs:
        if any(name.startswith(prefix) for prefix in banned):
            raise SystemExit(f"{path.name} needs {name}")
    for label, value in version_tuples(versions, "GLIBC_"):
        if value > max_glibc:
            raise SystemExit(f"{path} needs {label}, newer than glibc 2.31")
    for label, value in version_tuples(versions, "GLIBCXX_"):
        if value > max_glibcxx:
            raise SystemExit(f"{path} needs {label}, newer than GLIBCXX_3.4.28")
    for label, value in version_tuples(versions, "CXXABI_"):
        if value > max_cxxabi:
            raise SystemExit(f"{path} needs {label}, newer than CXXABI_1.3.12")

print("bundle matches Focal glibc 2.31 and does not need WebKit, libmpv, or ayatana")
PY
