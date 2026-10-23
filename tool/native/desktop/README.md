# Desktop native source producers

`build.py` produces source-matched libmpv runtime libraries and public developer
headers for Linux x86_64 and Windows x86_64. It implements the optional `source`
mode of the all-platform workflow. The workflow's audited prebuilt baseline is
a separate mode; this producer never substitutes a prebuilt libmpv after a
source failure.

## Invocation

Both source producers run on an **Ubuntu 24.04 x86_64 host**. Windows compilation
cross-compiles its Clang/MinGW toolchain and target dependencies. Allow ample
disk space and build time for LLVM; this is substantially heavier than the
default upstream package mode.

```sh
bash tool/native/desktop/setup.sh linux    # or windows
export PATH="${RUNNER_TEMP:-/tmp}/piliplus-desktop-tools/bin:$PATH"
python3 tool/native/desktop/build.py \
  --platform linux --lock /absolute/source-request.json \
  --output /absolute/empty-output-directory --jobs 4
```

`setup.sh` adds its tool environment to `GITHUB_PATH` in Actions. Its versions
are CMake 3.31.6 and Meson 1.9.1. Distribution package versions, tool executable
hashes and the actual host OS are recorded in the package. This identifies a
build; it does not claim that mutable Ubuntu mirrors or a runner image make
the package bit-for-bit reproducible on another date.

The orchestration layer extracts `platforms.<platform>.source` from
`tool/native/inputs.lock.json` into the request. Its shape is:

```json
{
  "producer": {"repository": "Goodwu/mpv", "commit": "<full SHA>"},
  "sources_lock": "tool/native/desktop/desktop-sources.lock.json",
  "sources": {
    "ffmpeg": {"repository": "https://github.com/Goodwu/FFmpeg.git", "commit": "<full SHA>"},
    "libplacebo": {"repository": "https://github.com/Goodwu/libplacebo.git", "commit": "<full SHA>"},
    "mpv": {"repository": "https://github.com/Goodwu/mpv.git", "commit": "<full SHA>"}
  },
  "required_capabilities": ["libmpv", "opengl"]
}
```

For Windows, `producer` is the locked Predidit recipe and `sources` is omitted:
its complete dependency vector is in the separate desktop lock. Relative lock
paths are resolved from the PiliPlus checkout. The producer and any Linux
source vector must agree with that lock before a download starts. Use
`--check-lock` to validate this contract without downloading or compiling.

Successful output:

* `root/`: package payload, same-source public headers, full non-system runtime
  import closure, license notices, build configuration and provenance evidence.
* `spec.json`: shared schema metadata **outside** the payload.
* `work/`: retained source checkouts, build products and logs for diagnosis;
  these are not a package payload and should not be uploaded as one.

The caller seals the result with the shared media-kit packer:

```sh
python3 /absolute/media-kit/tool/native_package/package.py create \
  --root /absolute/empty-output-directory/root \
  --spec /absolute/empty-output-directory/spec.json
```

Only `root/` and its generated manifest are passed to the application build.
The package states `compiled=true`, `runtime=false`, `device=false`: a compile
and link check cannot certify playback, a Windows process lifetime or GPU
interoperability. Such tests are separate acceptance gates.

## Linux profile

The lock pins Goodwu FFmpeg, libplacebo and mpv (including the corrected DOVI
feature macros). It builds each component from source as a shared library,
with local `pkg-config` taking precedence. Meson is not allowed to download
fallback dependencies. HTTPS uses the explicitly selected GnuTLS dependency.

The profile requires the embedded OpenGL/EGL client API, X11, VAAPI, ALSA and
PulseAudio. This is the API used by the media-kit Flutter renderer. The
standalone mpv Wayland video output is disabled because this mpv revision
requires Wayland 1.23/protocols 1.38 while Ubuntu 24.04 has older development
packages. This does not disable Flutter's supplied OpenGL rendering context.
Vulkan, its shader compiler SDK, the standalone CLI, and Rust libdovi are not
included in this profile. Native Dolby Vision shader reshaping remains enabled
in libplacebo; only capabilities detected in the compiled mpv configuration
are added to the manifest.

Every `DT_NEEDED` dependency is traversed recursively. Non-system libraries
are copied under `root/lib`, with `$ORIGIN` RPATH applied to **each** library.
glibc, graphics driver interfaces and audio service/plugin interfaces are
explicit host requirements, listed in `evidence/runtime-closure.json`; vendor
drivers and host plugin modules are not copied. Unknown/unresolved imports,
cross-architecture libraries, basename conflicts or missing distro license
provenance stop packaging. The result targets the glibc baseline of the build
host; it is not an older-distribution compatibility build.

`include/mpv` comes from the actual mpv installation. A relocatable `mpv.pc`
and the `libmpv.so` linker alias are included. This is a public libmpv developer
interface, not a claim that all distribution development headers or the
private FFmpeg/libplacebo SDKs have been bundled. A real C consumer is linked
against the packaged libraries with unresolved shared-library symbols
disallowed.

## Windows profile and immutable dependency freeze

The audited recipe is
`Predidit/libmpv-win32-video-cmake@fdf75129fc694b5ca555ce73cffc43bb6943ae13`.
It retains `mpv-0001-dxd11-render-api.patch`, including `render_dxgi.h`,
`MPV_RENDER_API_TYPE_DXGI` and `MPV_RENDER_PARAM_DXGI_INIT_PARAMS`.
This Windows profile intentionally follows that compatible DXGI source stack;
it does not assert Android-specific Goodwu extensions.

Pinning this recipe alone would leave many transitive Git inputs floating.
The committed desktop lock therefore contains the **actual configured target
closure**: 69 build targets, 58 full Git commit IDs, three downloaded and
checksum-verified source archives, and the Windows.winmd repository commit,
URL and SHA256. The producer reconfigures and checks the closure before
building. It verifies the source HEADs again afterward.

The local adaptation performs these bounded changes to a fresh recipe:

* Use CMake 3.31.6's installed ExternalProject module plus the recipe's patch;
  no helper is downloaded from an unverified URL at configure time.
* Replace every used Git ref with its frozen commit, strengthen archive
  SHA256 checks, and use checksum-verified Windows.winmd.
* Remove release/packaging targets and post-build branch reset/cleanup hooks.
  No `ninja update`, Rust bootstrap or release publishing step runs.
* Build `llvm`, then `llvm-clang`, then `mpv`, using baseline x86-64 rather
  than x86-64-v3. Preserve generated configuration and linker evidence.

The actual built DLL, MinGW import library and patched source headers are
packaged together. The DXGI header, compiled D3D11 feature and DXGI object in
the build graph are required. A real cross-compiled C consumer uses both the
DXGI types and the packaged import library. PE normal and delay imports are
walked recursively; unknown non-system DLLs must be found in the fresh target
prefix, or packaging fails. Windows 10/11 system and API-set DLLs remain host
requirements. GPU-specific DLLs loaded dynamically still require device
acceptance tests; the static import closure does not claim to discover every
possible runtime `LoadLibrary` path.

### Updating the Windows lock

Freezing new refs is an explicit maintenance operation, never a fallback in
the normal build. Use a clean clone of the audited recipe and a fresh work
directory:

```sh
python3 tool/native/desktop/windows_recipe.py freeze \
  --recipe /absolute/clean-recipe \
  --work /absolute/freeze-work \
  --output /absolute/windows-lock-candidate.json
```

The command configures the recipe without compiling it, resolves refs,
downloads the three source archives and Windows.winmd, and validates their
checksums. Review its output, test the source build, then replace the
`windows` object in `desktop-sources.lock.json`. Changing the recipe itself
also requires reviewing and updating the intentionally bounded adapter.

## Local verification

```sh
python3 tool/native/desktop/contract_tests.py
```

The tests build real small ELF and PE fixtures to verify recursive imports,
missing dependency rejection, architecture checks and relocation. They also
exercise lock disagreement and Windows ref replacement. They do not pretend
to replace a complete LLVM/FFmpeg product build or device playback tests.
