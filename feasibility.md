A Windows ARM64 GitHub Actions build is possible. A 32-bit Windows build is not, so the Bay Trail tablets should be skipped. A postmarketOS build is a local Linux ARM64 app, not an Android APK, and it should be built on the trogdor itself.

Windows ARM64
Yes. Flutter 3.47, the version pinned in pubspec.yaml, lists Windows 10 and 11 on ARM64 as a supported target, and the engine files for this exact release are published (windows-arm64 and windows-arm64-release for engine af7e796e). Public repositories can run that job on the free windows-11-arm runner (4 vCPU, 16 GB). Private repositories do not get that runner for free.

The existing win_x64.yml job cannot be pointed at that runner as-is. On an ARM64 host, flutter build windows targets ARM64 and writes build/windows/arm64/runner/Release. The video plugin always downloads and links the x64 library mpv-dev-x86_64-20260607-git-43b14a4.7z, so the link fails with an architecture mismatch. The same mpv release already contains mpv-dev-aarch64-20260607-git-43b14a4.7z; the CMake file has to select it. The ANGLE DLLs bundled next to it (ANGLE.7z) are also x64, and video rendering needs an ARM64 copy of those as well.

WebView2 is in better shape. flutter_inappwebview_windows installs it from NuGet, and that package includes ARM64 binaries. The default build uses Direct3D textures rather than the AVX2 fallback, so login and captcha pages can compile.

windows-11-arm is switching to Visual Studio 2026 between September 21 and September 30, 2026. If a job breaks on the old image during that rollout, windows-11-vs2026-arm is the explicit label.

Windows x86 (Windows 10 1607 32-bit)
Skip it. Flutter 3.47 only ships Windows engines for x64 and ARM64. There is no 32-bit Windows embedder and no 32-bit gen_snapshot, and the project has no plan to add one. A 32-bit Windows install cannot run the x64 or ARM64 executable.

The mpv release used by this fork does include mpv-dev-i686-20260607-git-43b14a4.7z, so the player library is not the blocker. The Flutter engine is. Bay Trail tablets that can only boot 32-bit Windows cannot run this app.

postmarketOS on the trogdor
Build it on the device, inside an Ubuntu or Debian ARM64 container. That is a native compile. The trogdor is a Snapdragon 7c Chromebook board (google-trogdor), so the container matches the CPU and does not go through QEMU. After the SDK and packages are cached, a release build of this app should be on the order of a slow laptop build, roughly under an hour, not an overnight job. A 4 GB model may swap. Compiling the Flutter engine from source is the path that takes many hours; this build does not need that.

What you get is a Linux desktop bundle, the same kind of GTK app as the existing x64 workflow (gtk3, libmpv, webkit2gtk-4.1). Flutter will only produce it when the host is ARM64. The linux-arm64 engine for 3.47.5 is already published, so the device downloads it. There is no official flutter_linux_arm64_3.47.5 SDK tarball; the usual setup is a checkout of the 3.47.5 tag, which then downloads the ARM64 Dart SDK and engine.

An Alpine apk is a poor fit for that binary. postmarketOS is musl. The official Flutter Linux engine is glibc and links GTK, GLib, and Wayland. Alpine’s own Flutter package is musl, but edge/testing is still 3.38.4, and this tree requires 3.47.5. gcompat is too thin for this stack. The practical local package is the bundle running in that container, or in distrobox with the host Wayland socket. A wrapper apk can install a launcher for that, and it stays on this device.

An Android APK is a different file. CI already builds arm64-v8a Android APKs. postmarketOS will not install those with apk add. They only run if Waydroid is set up, which is separate from a native build.