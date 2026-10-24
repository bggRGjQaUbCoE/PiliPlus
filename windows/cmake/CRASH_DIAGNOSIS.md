# Windows ARM64 crash investigation

The 2026-10-01 04:46:43 dump (`piliplus.exe.20624.dmp`) identifies a
`std::out_of_range` exception in a media_kit video texture callback. The exception
message is `invalid unordered_map<K, T> key`. It escapes through
`flutter::ExternalTextureD3d::PopulateTexture` into a noexcept engine boundary,
which calls `terminate` and `abort` (reported as 0xc0000409).

During `VideoOutput::Resize`, a callback registered for an old texture uses the
mutable `texture_id_`. Flutter can request a frame after the ID changes and
before its descriptor is inserted. Both GPU and software callbacks used
`unordered_map::at`, which throws in that interval. They could also return a
replacement texture's descriptor to an old callback.

The local CMake patch captures each callback's descriptor, checks map membership
under the existing mutex, and returns null during registration gaps or when
the current descriptor belongs to another texture. It does not change the
dependency cache. Texture ID updates also use the callback mutex, so an ID and
its descriptor are published together. Release plugin builds now retain PDB symbols in the plugin
build directory for future dump analysis.

Regression tests compile the actual callback bodies extracted from the patched
source against a small native fixture. They cover initial registration gaps,
resize registration gaps, old callbacks after replacement, valid replacement
frames, and callbacks after unregistration. Scaling checks separately retain
coverage for the portrait-video black-screen fix.

Earlier dumps (including `piliplus.exe.5212.dmp`, 04:35:07) report an access
violation at `libmpv-2.dll + 0x316344`. This is a separate unresolved signature;
the texture-callback fix has not been shown to fix it. The available libmpv
archive does not include its PDB, so exact source attribution is unavailable.
Windows already saves dumps in `%LOCALAPPDATA%\CrashDumps`; no registry change
is necessary. Inspect any new dump before assuming it has the same cause.

The 23:05:28 crash (`piliplus.exe.14728.dmp`) repeats the libmpv signature while
the installed plugin hash matches the texture-callback repair. It happened
during normal playback. Disassembly shows an invalid buffer reference being
copied; the underlying cause cannot be determined without the old library's
symbols. This confirms that the mpv signature needs a separate investigation.

An optional replacement runtime is now available: upstream ARM64 mpv build
20261001 (3186d369f9, API 2.5). Its archive is pinned to the upstream SHA256.
Native smoke tests decode AVC, HEVC and AV1 through the software render API,
verify nonblack colored output, and reach EOF. Each two-second sample renders
61 frames. The Vulkan loader dependency and its license are included. These
tests verify compatibility, not resolution of the intermittent crash.

Prepare it with `tool/prepare_windows_arm64_mpv.ps1`, then configure the ARM64
build with `-DPILIPLUS_ARM64_MPV_BUNDLE=<repo>/.build-tools/mpv-20261001`.
The override is opt-in and validates runtime checksums before packaging.
The original packages are retained; test packages have `mpv_update` in their
filenames. Configure with an empty override to restore the original runtime.

## Checks

From the repository root after CMake configuration:

```powershell
cmake "-DVIDEO_OUTPUT=build/windows/arm64/media_kit_video_output.cc" -P windows/cmake/test_video_scaling.cmake
cmake "-DVIDEO_OUTPUT=build/windows/arm64/media_kit_video_output.cc" "-DTEST_SOURCE=build/windows/arm64/texture_callback_test.cpp" -P windows/cmake/test_video_texture_callbacks.cmake
clang++ -std=c++17 build/windows/arm64/texture_callback_test.cpp -o build/windows/arm64/texture_callback_test.exe
& build/windows/arm64/texture_callback_test.exe
```
