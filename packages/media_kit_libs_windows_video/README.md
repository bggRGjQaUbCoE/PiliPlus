# Windows native libraries

This is a local copy of `media_kit_libs_windows_video` 1.0.10 from
My-Responsitories/media-kit commit `73771ec38176be2d984a3049c28177bce23b54a0`.
The original x64 build is retained in `windows/x64.cmake`.

The ARM64 build uses the same mpv release (20260607), the original ANGLE
headers, and ARM64 ANGLE DLLs distributed with Electron 37.7.0. Downloads
are pinned by SHA-256. MSVC import libraries are generated from the DLL
exports during configuration. Electron's license and Chromium third-party
notices are included in the application bundle.

The ANGLE binaries provide the D3D11 rendering path used by media_kit_video.
Playback and hardware acceleration must also be tested on an ARM64 device.
