#!/usr/bin/env bash
set -euo pipefail
source_dir=$1
output_dir=$2
prefix="$source_dir/capture-prefix"
mkdir -p "$prefix"
cd "$source_dir"
if ! echo '056cc3674e69d0e44ae85d8ee6ade11364fc584c2406e5f5d9cfb771e77f5ead  ffmpeg.tar.gz' | sha256sum --check --status 2>/dev/null; then
  curl --fail --location --retry 5 --retry-all-errors --connect-timeout 20 --max-time 180 \
    https://codeload.github.com/FFmpeg/FFmpeg/tar.gz/e3a61e91030696348b56361bdf80ea358aef4a19 -o ffmpeg.tar.gz
fi
echo '056cc3674e69d0e44ae85d8ee6ade11364fc584c2406e5f5d9cfb771e77f5ead  ffmpeg.tar.gz' | sha256sum -c -
mkdir -p ffmpeg-7.0.2
tar xf ffmpeg.tar.gz --strip-components=1 -C ffmpeg-7.0.2
echo '7.0.2' > ffmpeg-7.0.2/VERSION
pushd ffmpeg-7.0.2
./configure --prefix="$prefix" --enable-shared --disable-static --enable-libwebp --enable-libdav1d --enable-gnutls --disable-doc
make -j"$(nproc)"
make install
popd
export PKG_CONFIG_PATH="$prefix/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
meson setup capture-build --prefix="$prefix" --libdir=lib -Dlibmpv=true -Dcplayer=true -Dgpl=false
meson compile -C capture-build
meson install -C capture-build
mkdir -p "$output_dir/lib" "$output_dir/bin"
cp -a "$prefix"/lib/*.so* "$output_dir/lib/"
cp "$prefix/bin/mpv" "$output_dir/bin/"
# Bundle non-glibc transitive dependencies as well. Preserve SONAMEs.
for library in "$prefix/bin/mpv" "$prefix"/lib/*.so; do
  ldd "$library" | awk '/=> \/.*\// { print $3 }' | while read -r dependency; do
    case "$(basename "$dependency")" in
      libc.so.*|libm.so.*|libpthread.so.*|libdl.so.*|librt.so.*|ld-linux*) ;;
      *) cp -Ln "$dependency" "$output_dir/lib/" ;;
    esac
  done
done
# A Flutter executable's RUNPATH does not apply to dependencies of dlopen'd
# libmpv. Each bundled media library must find its siblings after relocation.
find "$output_dir/lib" -type f -name '*.so*' -exec patchelf --set-rpath '$ORIGIN' {} \;
test -s "$output_dir/lib/libmpv.so.2"
if ldd "$output_dir/lib/libmpv.so.2" | grep 'not found'; then
  exit 1
fi
