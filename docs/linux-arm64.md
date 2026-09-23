# Building PiliPlus for Linux ARM64

CI only publishes Linux **x64** (see [`.github/workflows/linux_x64.yml`](../.github/workflows/linux_x64.yml)). Flutter does not cross-compile Linux from an x64 host, so ARM64 has to be built on an aarch64 **glibc** machine (Debian or Ubuntu). The output is a GTK desktop bundle, the same kind of app as the x64 job.

This does **not** produce an Alpine / postmarketOS package. Those are musl; the official Flutter Linux engine is glibc.

Pinned SDK: Flutter **3.47.5** / Dart **3.13.4** (`pubspec.yaml`). There is no `flutter_linux_arm64_3.47.5` tarball. Check out the git tag; the first `flutter` run downloads the ARM64 Dart SDK and `linux-arm64` GTK engine.

## Host

- CPU: aarch64 (native). QEMU user-mode on x64 is possible but much slower.
- OS: Debian 13 (trixie) or Ubuntu 22.04/24.04. Confirmed on Debian 13 / RK3399 (Google Scarlet).
- RAM: 4 GiB is enough if you add swap. On a 4 GiB device, add a 4 GiB swap file and keep Ninja at two jobs (`CMAKE_BUILD_PARALLEL_LEVEL=2`). On Btrfs, create the swap file with `btrfs filesystem mkswapfile`, not `fallocate`.
- Display: X11 or Wayland. A black window on Mali/Panfrost is a GL issue; try `LIBGL_ALWAYS_SOFTWARE=1`.

## Packages

```bash
sudo apt-get update
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev libayatana-appindicator3-dev \
  libwebkit2gtk-4.1-dev libmpv-dev libasound2-dev \
  git curl unzip xz-utils zip
```

On Debian 13 the ALSA headers package is `libasound2-dev`.

`lib/scripts/build.ps1` and `lib/scripts/patch.ps1` are what CI runs. Install PowerShell if `pwsh` is missing (no Debian package):

```bash
# example: 7.5.x linux-arm64 tarball from PowerShell/PowerShell releases
mkdir -p "$HOME/opt/powershell" "$HOME/bin"
tar -xzf powershell-*-linux-arm64.tar.gz -C "$HOME/opt/powershell"
ln -sfn "$HOME/opt/powershell/pwsh" "$HOME/bin/pwsh"
```

## Flutter SDK

```bash
git clone --depth 1 --branch 3.47.5 https://github.com/flutter/flutter.git "$HOME/src/flutter"
export PATH="$HOME/src/flutter/bin:$HOME/bin:$PATH"
flutter config --no-analytics --enable-linux-desktop
flutter precache --linux
flutter doctor
```

`flutter doctor` should report a Linux toolchain and a `linux-arm64` device. Android/Chrome can stay missing.

`patch.ps1` runs `git reset --hard` in `$FLUTTER_ROOT` and applies the shared framework patches. Use a dedicated checkout, not a Flutter SDK you also use for other apps.

## Build

The scripts expect GitHub Actions variables. `build.ps1` writes `pili_release.json` (used by `lib/build_config.dart`) and then appends to `$GITHUB_ENV`; that file must exist. Keep the repo `.git` history so `git rev-list --count` matches CI.

`patch.ps1` also sets a global git identity (`ci` / `example@example.com`). Save and restore yours.

```bash
export PATH="$HOME/src/flutter/bin:$HOME/bin:$PATH"
export FLUTTER_ROOT="$HOME/src/flutter"
export GITHUB_WORKSPACE="$PWD"          # this repo
export GITHUB_ENV="/tmp/pili_github.env"
export CMAKE_BUILD_PARALLEL_LEVEL=2     # raise on machines with more RAM
: > "$GITHUB_ENV"

# optional: save git config --global user.name / user.email

pwsh -File lib/scripts/build.ps1
pwsh -File lib/scripts/patch.ps1 Linux
flutter build linux --release --dart-define-from-file=pili_release.json --no-pub
```

Binary: `build/linux/arm64/release/bundle/piliplus`.

Run it from that directory (RPATH is `$ORIGIN/lib`), on a graphical session or with `DISPLAY=:0` / a Wayland socket.

## Debian package

Same layout as the x64 job: files under `/opt/PiliPlus`, desktop file, `postinst` symlink to `/usr/bin/piliplus`. Change `Architecture` to `arm64`. This binary also links WebKitGTK and ALSA; add those Depends so a clean Debian 13 install can start.

```bash
VERSION="$(python3 -c 'import json; d=json.load(open("pili_release.json")); print(f"{d[\"pili.name\"]}+{d[\"pili.code\"]}")')"
PKG="PiliPlus_linux_${VERSION}_arm64"

mkdir -p "$PKG/opt/PiliPlus" \
         "$PKG/usr/share/applications" \
         "$PKG/usr/share/icons/hicolor/512x512/apps"
cp -a build/linux/arm64/release/bundle/. "$PKG/opt/PiliPlus/"
cp -a assets/linux/DEBIAN "$PKG/"
cp assets/linux/com.example.piliplus.desktop "$PKG/usr/share/applications/"
cp assets/images/logo/logo.png "$PKG/usr/share/icons/hicolor/512x512/apps/piliplus.png"

sed -i \
  -e "s/^Version: version_need_change$/Version: ${VERSION}/" \
  -e "s/^Architecture: amd64$/Architecture: arm64/" \
  "$PKG/DEBIAN/control"

# Installed-Size: apparent bytes minus DEBIAN/, rounded up to KiB
# (same formula as linux_x64.yml)

dpkg-deb --build --root-owner-group "$PKG"
```

Suggested `Depends` on Debian 13:

```
libgtk-3-0t64, libmpv2, libwebkit2gtk-4.1-0, libasound2t64,
gir1.2-ayatanaappindicator3-0.1, libayatana-appindicator3-1
```

Install with `sudo apt install ./PiliPlus_linux_*_arm64.deb`.

## Chinese text

Installing `fonts-noto-cjk` is not enough on ARM64.

The official 3.47.5 `libflutter_linux_gtk.so` for linux-arm64 is built **without** `--enable-fontconfig` ([flutter#139293](https://github.com/flutter/flutter/issues/139293), fixed on master in [PR #180235](https://github.com/flutter/flutter/pull/180235) after the 3.47 cutoff). Skia never asks Fontconfig for system faces. Debian’s Noto CJK files are `.ttc` collections, so picking “Noto Sans CJK SC” in the app still draws **blank** Han glyphs (not □). Qt apps on the same machine work because they use Fontconfig.

Workaround that does not rebuild the engine: in PiliPlus **Settings → font**, load a **single-face** `.otf` / `.ttf` as a custom font (Dart `FontLoader`, no Fontconfig). Example: [Noto Sans SC Regular](https://github.com/notofonts/noto-cjk/tree/main/Sans/OTF/SimplifiedChinese) (`NotoSansSC-Regular.otf`). Do not use the Debian `.ttc`.

The real engine fix is a later Flutter that ships the ARM64 *desktop* GTK artifact, or a self-built `libflutter_linux_gtk.so` with `--enable-fontconfig` for the same engine hash.

`LANG=en_CA.UTF-8` without `locale-gen en_CA.UTF-8` produces GTK locale warnings. Generate the locale or switch to `en_US.UTF-8`. That does not restore CJK by itself.
