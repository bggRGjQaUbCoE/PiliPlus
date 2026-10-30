#!/bin/bash
# Runs inside the Ubuntu 20.04 arm64 container. Do not run this on macOS
# or on a newer Linux distribution.
set -euo pipefail

machine=$(uname -m)
if [[ "$machine" != "aarch64" ]]; then
  echo "expected aarch64, got $machine" >&2
  exit 1
fi

if [[ ! -x /opt/flutter/bin/flutter ]]; then
  find /opt/flutter -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  git clone --depth 1 --branch 3.47.7 https://github.com/flutter/flutter.git /opt/flutter
fi

git config --global --add safe.directory /opt/flutter
git config --global --add safe.directory /src

export PATH="/opt/flutter/bin:${PATH}"
export PUB_CACHE=/opt/pub-cache
export FLUTTER_SUPPRESS_ANALYTICS=true
export PILI_UBUNTU_TOUCH=1

flutter config --no-analytics --enable-linux-desktop
flutter --version
engine=$(tr -d '[:space:]' < /opt/flutter/bin/internal/engine.version)
echo "engine=$engine"

cd /src
flutter pub get

# Same set as `lib/scripts/patch.ps1 Linux`. The app subclasses types that
# stay private until these patches run. Desktop CI applies them before
# `flutter build`; a plain `flutter build linux` does not.
git -C /opt/flutter reset --hard HEAD
flutter_patches=(
  lib/scripts/modal_barrier.patch
  lib/scripts/text_selection.patch
  lib/scripts/mouse_cursor.patch
  lib/scripts/image_anim.patch
  lib/scripts/layout_builder.patch
  lib/scripts/navigation_drawer.patch
  lib/scripts/popup_menu.patch
  lib/scripts/fab.patch
  lib/scripts/null_safety_for_selectable_region.patch
  lib/scripts/selectable_region.patch
  lib/scripts/editable_text.patch
  lib/scripts/text_field.patch
  lib/scripts/scroll_position.patch
  lib/scripts/scrollable.patch
  lib/scripts/scrollable_gesture.patch
  lib/scripts/draggable_scrollable_sheet.patch
  lib/scripts/scaffold.patch
  lib/scripts/text.patch
  lib/scripts/text_painter.patch
  lib/scripts/sliver.patch
  lib/scripts/refresh_indicator.patch
  lib/scripts/double_tap_gesture.patch
)
for patch in "${flutter_patches[@]}"; do
  git -C /opt/flutter apply "/src/$patch"
  echo "applied $patch"
done

rm -rf /opt/pub-cache/hosted/pub.dev/material_ui-*
flutter pub get
material_dir=$(echo /opt/pub-cache/hosted/pub.dev/material_ui-*)
echo "material_ui dir: $material_dir"
material_patches=(
  lib/scripts/material/modal_barrier_material.patch
  lib/scripts/material/navigation_drawer.patch
  lib/scripts/material/popup_menu.patch
  lib/scripts/material/fab.patch
  lib/scripts/material/text_field.patch
  lib/scripts/material/scaffold.patch
  lib/scripts/material/refresh_indicator.patch
  lib/scripts/material/tabs.patch
)
for patch in "${material_patches[@]}"; do
  # The patch files are checked in with LF. git apply reads the working tree
  # of the package, which is not itself a git checkout.
  git -C "$material_dir" apply "/src/$patch"
  echo "applied $patch"
done

# Focal's glib 2.64 types g_steal_pointer as void*. app_links_linux 1.0.4
# assigns that straight into g_autoptr(GPtrArray), which C++ rejects.
# Ubuntu 24.04's glib, used by desktop CI, accepts it. Only this build
# rewrites the pub-cache copy.
app_links=/opt/pub-cache/hosted/pub.dev/app_links_linux-1.0.4/linux/app_links_plugin_linux.cc
python3 - "$app_links" <<'PY'
import pathlib, sys
path = pathlib.Path(sys.argv[1])
text = path.read_text()
old = "g_autoptr(GPtrArray) links = g_steal_pointer(&self->pending_links);"
new = "g_autoptr(GPtrArray) links = static_cast<GPtrArray*>(g_steal_pointer(&self->pending_links));"
if old not in text and new not in text:
    raise SystemExit(f"app_links glib line not found in {path}")
path.write_text(text.replace(old, new, 1))
print("patched app_links_linux for glib 2.64")
PY

rm -rf /src/build/linux
flutter build linux --release --dart-define=PILI_UBUNTU_TOUCH=true

bundle=$(find build/linux -type f -path '*/release/bundle/piliplus' -print -quit)
if [[ -z "$bundle" ]]; then
  echo "release bundle executable was not produced" >&2
  exit 1
fi
bundle_dir=$(dirname "$bundle")

# GTK on this image has im-wayland.so, and Mir does not offer a text-input
# global for it. Ship Maliit's GTK module inside the bundle instead of
# installing it into the rootfs.
gcc -shared -fPIC -O2 -Wall \
  $(pkg-config --cflags gtk+-3.0) \
  -o "$bundle_dir/lib/im-maliit.so" \
  /src/third_party/im-maliit/im-maliit.c \
  $(pkg-config --libs gtk+-3.0 gio-2.0) \
  -Wl,--no-undefined

out=/src/packaging/ubuntu-touch/piliplus/dist
rm -rf "$out"
mkdir -p "$out"
cp -a "$bundle_dir" "$out/bundle"
{
  echo "engine=$engine"
  echo "machine=$machine"
  echo "define=PILI_UBUNTU_TOUCH"
  readelf -d "$bundle"
  echo "---- versions ----"
  readelf -V "$bundle"
} > "$out/build-info.txt"

bash /src/packaging/ubuntu-touch/piliplus/check-bundle.sh "$out/bundle"
echo "copied bundle to $out/bundle"
