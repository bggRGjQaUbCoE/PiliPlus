---
name: Debian ARM64 build
overview: Build PiliPlus natively on the Scarlet (Debian 13, ARM64) over SSH, using the published Flutter 3.47.5 ARM64 engine and the same Linux release steps as CI. No engine port and no changes to this repo.
todos:
  - id: prep-device
    content: SSH to linux@10.0.0.115, add 4 GiB swap, install Debian build packages and PowerShell arm64
    status: completed
  - id: flutter-sdk
    content: Install Flutter 3.47.5 from the git tag and precache the linux-arm64 engine
    status: completed
  - id: sync-and-build
    content: rsync the repo, run build.ps1 and patch.ps1 Linux, then flutter build linux --release with 2-way Ninja
    status: in_progress
  - id: launch
    content: Start the bundle on the Scarlet display and restore any git config the patch script changed
    status: pending
isProject: false
---

# Build PiliPlus on Debian 13 ARM64

Build on `linux@10.0.0.115` (Google Scarlet, Debian 13, RK3399, 3.8 GiB RAM). The local checkout at `main` matches `origin` (`https://github.com/alpha-liu-01/PiliPlus.git`); only untracked [feasibility.md](feasibility.md) stays off the tablet. Nothing in this repo is edited.

The device is glibc, so this is the existing Linux release build from [.github/workflows/linux_x64.yml](.github/workflows/linux_x64.yml), run on ARM64. Flutter 3.47.5’s `linux-arm64` engine and the Dart 3.13.4 ARM64 SDK are already published. The result is `build/linux/arm64/release/bundle/piliplus`. It runs on this Debian system only, not on the postmarketOS trogdor.

## Memory

Xfce is already using about 800 MiB, and swap is only 512 MiB. Before any compile, add a 4 GiB swap file on the 55 GiB disk and export `CMAKE_BUILD_PARALLEL_LEVEL=2` so Ninja does not take all six cores. The Dart snapshot step is still one large process; the swap file is what keeps that from killing the build.

## Toolchain on the tablet

Install the Linux CI libraries under Debian’s package names: `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`, `libayatana-appindicator3-dev`, `libwebkit2gtk-4.1-dev`, `libmpv-dev`, `libasound2-dev`, plus `git`, `curl`, `unzip`, `xz-utils`, `zip`. Confirm each name with `apt-cache` first (`libasound-dev` is the trixie replacement if `libasound2-dev` is gone).

PowerShell is not in Debian. [lib/scripts/patch.ps1](lib/scripts/patch.ps1) and [lib/scripts/build.ps1](lib/scripts/build.ps1) are what CI runs, so install the upstream PowerShell arm64 tarball rather than rewriting them.

Flutter SDK: a depth-1 checkout of tag `3.47.5` in `~/src/flutter`. Do not use the x64 SDK zip. First `flutter` run downloads the ARM64 Dart SDK and the `linux-arm64` GTK engine. Enable Linux desktop only.

## App build

Copy this repo, including `.git`, to `~/src/PiliPlus` with `rsync` (full history so `git rev-list --count` matches CI). Exclude `feasibility.md`, `build/`, and `.dart_tool/`.

The scripts assume GitHub Actions variables:

- `FLUTTER_ROOT` = the Flutter checkout. `patch.ps1` runs `git reset --hard` there and applies the shared framework patches. For Linux it does not add the Android or iOS patches. That checkout must stay a dedicated SDK tree.
- `GITHUB_WORKSPACE` = `~/src/PiliPlus`.
- `GITHUB_ENV` = a temp file. [lib/scripts/build.ps1](lib/scripts/build.ps1) writes `pili_release.json`, then appends to `GITHUB_ENV` and exits 1 if that variable is unset. The JSON is required by [lib/build_config.dart](lib/build_config.dart).
- `patch.ps1` also sets a global git identity (`ci` / `example@example.com`). Save the existing `git config --global` values and restore them when the build finishes.

Order, matching the workflow:

1. `pwsh lib/scripts/build.ps1`
2. `pwsh lib/scripts/patch.ps1 Linux` (patches the Flutter tree, `flutter pub get`, then patches `material_ui` in `~/.pub-cache`)
3. `flutter build linux --release --dart-define-from-file=pili_release.json --no-pub`

Expect the compile to take one to two hours after downloads.

## Run it

From the tablet’s Xfce session, or over SSH with `DISPLAY=:0`, start `build/linux/arm64/release/bundle/piliplus`. If the window is black, that is the Mali/Panfrost GL path, not a failed compile; software GL is the fallback to try. A successful launch is a window on the 1536x2048 display, not a packaged `.deb`.
