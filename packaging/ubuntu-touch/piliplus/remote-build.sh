#!/bin/bash
# Copies the tree to the Mac and builds the arm64 release bundle in the
# Ubuntu 20.04 container. Click packaging stays on the x64 machine.
set -euo pipefail

root=$(cd "$(dirname "$0")/../../.." && pwd)
host=alpha@10.0.0.118
remote=piliplus-ut/app
docker=/Applications/Docker.app/Contents/Resources/bin/docker

ssh "$host" "mkdir -p \$HOME/$remote; nohup caffeinate -dimsu -t 14400 >/dev/null 2>&1 </dev/null &"
rsync -a --delete \
  --exclude .git/ \
  --exclude .cursor/ \
  --exclude build/ \
  --exclude .dart_tool/ \
  --exclude '**/ephemeral/' \
  --exclude packaging/ubuntu-touch/piliplus/bundle/ \
  --exclude packaging/ubuntu-touch/piliplus/build/ \
  --exclude packaging/ubuntu-touch/piliplus/dist/ \
  -e ssh \
  "$root/" "$host:$remote/"

ssh "$host" "set -euo pipefail
  export PATH=\"/Applications/Docker.app/Contents/Resources/bin:\$PATH\"
  cd \$HOME/$remote/packaging/ubuntu-touch/piliplus
  DOCKER_BUILDKIT=0 $docker build --pull=false -t piliplus-flutter-focal:20.04 .
  $docker run --platform linux/arm64 --rm \
    -e PILI_UBUNTU_TOUCH=1 \
    -v \$HOME/$remote:/src \
    -v piliplus-flutter-sdk:/opt/flutter \
    -v piliplus-flutter-pub:/opt/pub-cache \
    -w /src \
    piliplus-flutter-focal:20.04 \
    bash /src/packaging/ubuntu-touch/piliplus/build-arm64.sh"

dest="$root/packaging/ubuntu-touch/piliplus"
mkdir -p "$dest/dist"
rsync -a --delete -e ssh "$host:$remote/packaging/ubuntu-touch/piliplus/dist/" "$dest/dist/"
rm -rf "$dest/bundle"
mkdir -p "$dest/bundle"
cp -a "$dest/dist/bundle/." "$dest/bundle/"
"$dest/check-bundle.sh" "$dest/bundle"
