#!/usr/bin/env bash
# Ubuntu 24.04 x86_64 host tools. Does not build, upload, or publish anything.
set -euo pipefail
case "${1:-}" in linux|windows) target="$1";; *) echo 'Usage: setup.sh linux|windows' >&2; exit 2;; esac
if [[ $(id -u) == 0 ]]; then elevate=(); else elevate=(sudo); fi
common=(build-essential git ca-certificates curl wget patch pkgconf ninja-build
  autoconf automake autoconf-archive autopoint libtool libtool-bin gettext
  nasm yasm bison flex gperf texinfo help2man xz-utils bzip2 unzip
  python3 python3-venv python3-pip python3-docutils)
if [[ "$target" == linux ]]; then
  packages=(patchelf libgnutls28-dev libass-dev libdav1d-dev libdrm-dev
    libva-dev libegl1-mesa-dev libgl1-mesa-dev libgbm-dev libdisplay-info-dev
    libx11-dev libxext-dev libxinerama-dev libxrandr-dev libxpresent-dev
    libxss-dev libxv-dev libxi-dev libasound2-dev libpulse-dev liblcms2-dev
    libxxhash-dev libarchive-dev libuchardet-dev zlib1g-dev libbz2-dev liblzma-dev)
else
  packages=(clang lld libc++-dev libc++abi-dev libclang-rt-dev libssl-dev
    zlib1g-dev libzstd-dev libxml2-dev rst2pdf)
fi
"${elevate[@]}" apt-get update
"${elevate[@]}" apt-get install -y --no-install-recommends "${common[@]}" "${packages[@]}"
desktop_tools="${RUNNER_TEMP:-/tmp}/piliplus-desktop-tools"
python3 -m venv "$desktop_tools"
"$desktop_tools/bin/python" -m pip install 'cmake==3.31.6' 'meson==1.9.1' 'Jinja2==3.1.6' 'MarkupSafe==3.0.2'
if [[ -n "${GITHUB_PATH:-}" ]]; then
  printf '%s\n' "$desktop_tools/bin" >> "$GITHUB_PATH"
fi
printf 'Tools installed. For the current shell: export PATH="%s/bin:$PATH"\n' "$desktop_tools"
