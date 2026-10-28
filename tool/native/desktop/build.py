#!/usr/bin/env python3
"""Build Linux or Windows libmpv packages from reviewed, immutable source inputs.

Output: OUTPUT/root (payload) and OUTPUT/spec.json (outside the payload).
The shared media-kit tool/native_package/package.py creates the final manifest.
No release, upload, branch resolution, or GitHub workflow dispatch occurs here.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import struct
import subprocess
import sys

import windows_recipe

APP_ROOT = Path(__file__).resolve().parents[3]
SHA_RE = re.compile(r"[0-9a-f]{40}")

# These are host interfaces: glibc, graphics driver loaders and audio service
# clients. Their driver/plugin modules must remain those installed by the OS.
# Every other direct and transitive DT_NEEDED entry must be in the package.
LINUX_HOST_LIBS = {
    "ld-linux-x86-64.so.2", "libc.so.6", "libm.so.6", "libdl.so.2",
    "libpthread.so.0", "librt.so.1", "libutil.so.1", "libresolv.so.2",
    "libEGL.so.1", "libGL.so.1", "libGLX.so.0", "libGLdispatch.so.0",
    "libOpenGL.so.0", "libGLESv2.so.2", "libdrm.so.2", "libgbm.so.1",
    "libva.so.2", "libva-drm.so.2", "libva-x11.so.2", "libvdpau.so.1",
    "libvulkan.so.1", "libcuda.so.1", "libnvidia-encode.so.1",
    "libasound.so.2", "libpulse.so.0", "libpulse-simple.so.0",
    "libpipewire-0.3.so.0",
}
WINDOWS_HOST_LIBS = {
    "advapi32.dll", "avrt.dll", "bcrypt.dll", "bcryptprimitives.dll",
    "cabinet.dll", "cfgmgr32.dll", "comctl32.dll", "comdlg32.dll",
    "crypt32.dll", "cryptbase.dll", "cryptsp.dll", "d3d9.dll", "d3d11.dll",
    "d3d12.dll", "d3dcompiler_47.dll", "dcomp.dll", "dnsapi.dll", "dsound.dll",
    "dwmapi.dll", "dwrite.dll", "dxgi.dll", "dxva2.dll", "gdi32.dll",
    "imm32.dll", "iphlpapi.dll", "kernel32.dll", "kernelbase.dll",
    "mf.dll", "mfplat.dll", "mfreadwrite.dll", "mfuuid.dll", "mmdevapi.dll",
    "mpr.dll", "msvcrt.dll", "ncrypt.dll", "normaliz.dll", "ntdll.dll",
    "ole32.dll", "oleaut32.dll", "opengl32.dll", "powrprof.dll",
    "propsys.dll", "psapi.dll", "rpcrt4.dll", "secur32.dll", "setupapi.dll",
    "shell32.dll", "shlwapi.dll", "shcore.dll", "ucrtbase.dll", "user32.dll",
    "userenv.dll", "usp10.dll", "uxtheme.dll", "version.dll", "winhttp.dll",
    "wininet.dll", "winmm.dll", "winnsi.dll", "winspool.drv", "wintrust.dll",
    "ws2_32.dll", "wtsapi32.dll",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def run(args, *, cwd=None, env=None, capture=False):
    argv = [str(arg) for arg in args]
    print("+ " + " ".join(argv), file=sys.stderr, flush=True)
    value = subprocess.run(argv, cwd=cwd, env=env, check=True, text=True,
                           stdout=subprocess.PIPE if capture else None)
    return value.stdout.strip() if capture else ""


def source(value: dict, label: str) -> dict:
    if not isinstance(value, dict) or not SHA_RE.fullmatch(value.get("commit", "")):
        raise ValueError(f"{label} requires a full lowercase Git commit SHA")
    repository = value.get("repository", "")
    if not repository.startswith("https://") or any(c.isspace() for c in repository):
        raise ValueError(f"{label} requires a public HTTPS Git repository URL")
    return {"repository": repository, "commit": value["commit"]}


def normalize_repo(value: str) -> str:
    return value.removeprefix("https://github.com/").removesuffix(".git").lower()


def load_inputs(request_path: Path, target: str):
    request = json.loads(request_path.read_text())
    lock_path = Path(request["sources_lock"])
    if not lock_path.is_absolute():
        lock_path = APP_ROOT / lock_path
    lock_path = lock_path.resolve()
    lock = json.loads(lock_path.read_text())
    if lock.get("schema") != 1 or target not in lock:
        raise ValueError("Unsupported or incomplete desktop source lock")
    entry = lock[target]
    producer = request["producer"]
    expected = entry["recipe"]
    if (producer.get("commit") != expected["commit"] or
            normalize_repo(producer.get("repository", "")) != normalize_repo(expected["repository"])):
        raise ValueError("Global producer identity disagrees with desktop recipe lock")
    if target == "linux":
        for name, value in entry["sources"].items():
            actual = source(request["sources"][name], name)
            if actual != source(value, name):
                raise ValueError(f"Global and desktop source locks disagree: {name}")
    return request, entry, lock_path


def checkout(value: dict, destination: Path):
    value = source(value, str(destination))
    destination.mkdir(parents=True)
    run(["git", "init", "--quiet", destination])
    run(["git", "remote", "add", "origin", value["repository"]], cwd=destination)
    run(["git", "fetch", "--depth=1", "origin", value["commit"]], cwd=destination)
    run(["git", "checkout", "--detach", "FETCH_HEAD"], cwd=destination)
    if run(["git", "rev-parse", "HEAD"], cwd=destination, capture=True) != value["commit"]:
        raise ValueError(f"Checkout identity mismatch: {destination}")
    run(["git", "submodule", "update", "--init", "--recursive", "--depth=1"], cwd=destination)


def assert_x64(path: Path, target: str):
    with path.open("rb") as stream:
        header = stream.read(64)
        if target == "linux":
            if header[:6] != b"\x7fELF\x02\x01" or struct.unpack_from("<H", header, 18)[0] != 62:
                raise ValueError(f"Not an x86_64 ELF library: {path}")
        else:
            if header[:2] != b"MZ":
                raise ValueError(f"Not a PE image: {path}")
            stream.seek(struct.unpack_from("<I", header, 60)[0])
            pe = stream.read(6)
            if pe[:4] != b"PE\0\0" or struct.unpack_from("<H", pe, 4)[0] != 0x8664:
                raise ValueError(f"Not an x86_64 PE image: {path}")


def elf_needed(path: Path):
    output = run(["readelf", "--dynamic", "--wide", path], capture=True)
    return re.findall(r"\(NEEDED\).*?\[([^\]]+)\]", output)


def host_index() -> dict[str, Path]:
    index = {}
    for line in run(["ldconfig", "-p"], capture=True).splitlines():
        match = re.match(r"\s*(\S+)\s+\(.*x86-64.*\)\s+=>\s+(\S+)", line)
        if match:
            index[match.group(1)] = Path(match.group(2))
    return index


def linux_bundle(main: Path, prefix: Path, destination: Path):
    index = host_index()
    for path in (prefix / "lib").glob("*.so*"):
        index[path.name] = path
    pending = [("libmpv.so.2", main)]
    shipped, external, edges = {}, set(), {}
    while pending:
        name, path = pending.pop()
        if name in shipped:
            if sha256(path.resolve()) != shipped[name]["input_sha256"]:
                raise ValueError(f"Ambiguous ELF basename: {name}")
            continue
        assert_x64(path, "linux")
        needed = elf_needed(path)
        edges[name] = needed
        shipped[name] = {"path": str(path.resolve()), "input_sha256": sha256(path.resolve())}
        shutil.copy2(path.resolve(), destination / name)
        for dependency in needed:
            if dependency in LINUX_HOST_LIBS:
                if dependency not in index:
                    raise ValueError(f"Required host library not installed: {dependency}")
                external.add(dependency)
                continue
            candidate = index.get(dependency)
            if candidate is None:
                local = path.resolve().parent / dependency
                if local.is_file():
                    candidate = local
            if candidate is None:
                raise ValueError(f"Unresolved runtime dependency: {name} -> {dependency}")
            pending.append((dependency, candidate))
    for name in shipped:
        run(["patchelf", "--set-rpath", "$ORIGIN", destination / name])
        # Re-read the packaged copy; adding RPATH must not change the ABI edge set.
        if elf_needed(destination / name) != edges[name]:
            raise ValueError(f"Runtime dependency set changed while packaging {name}")
    return {"libraries": shipped, "host_libraries": sorted(external), "edges": edges}


def pe_needed(path: Path):
    """Read PE32+ normal AND delay import descriptors without executing a DLL."""
    data = path.read_bytes()
    assert_x64(path, "windows")
    pe = struct.unpack_from("<I", data, 60)[0]
    section_count, optional_size = struct.unpack_from("<H", data, pe + 6)[0], struct.unpack_from("<H", data, pe + 20)[0]
    optional = pe + 24
    if struct.unpack_from("<H", data, optional)[0] != 0x20B or optional_size < 112:
        raise ValueError(f"Invalid PE32+ optional header: {path}")
    image_base = struct.unpack_from("<Q", data, optional + 24)[0]
    header_size = struct.unpack_from("<I", data, optional + 60)[0]
    directory_count = struct.unpack_from("<I", data, optional + 108)[0]
    sections = []
    for i in range(section_count):
        start = optional + optional_size + 40 * i
        virtual_size, virtual, raw_size, raw = struct.unpack_from("<IIII", data, start + 8)
        sections.append((virtual, virtual_size, raw, raw_size))

    def offset(rva, size=1):
        if rva < header_size and rva + size <= min(header_size, len(data)):
            return rva
        for virtual, virtual_size, raw, raw_size in sections:
            delta = rva - virtual
            if 0 <= delta < max(virtual_size, raw_size):
                if delta + size <= raw_size and raw + delta + size <= len(data):
                    return raw + delta
                break
        raise ValueError(f"Unbacked PE import address in {path}: {rva:#x}")

    def name_at(rva):
        start = offset(rva)
        value = bytearray()
        for i in range(512):
            byte = data[offset(rva + i)]
            if byte == 0:
                name = value.decode("ascii")
                if not re.fullmatch(r"[A-Za-z0-9_.+-]+\.(?:dll|drv)", name, re.I):
                    raise ValueError(f"Invalid PE import filename in {path}")
                return name
            value.append(byte)
        raise ValueError(f"Unterminated PE import filename in {path}")

    names = set()
    for index, size in ((1, 20), (13, 32)):
        if directory_count <= index:
            continue
        directory = optional + 112 + index * 8
        if directory + 8 > optional + optional_size:
            raise ValueError(f"Truncated PE data directory in {path}")
        rva, length = struct.unpack_from("<II", data, directory)
        if not rva and not length:
            continue
        terminated = False
        for i in range(length // size):
            words = struct.unpack_from("<" + "I" * (size // 4), data, offset(rva + size * i, size))
            if not any(words):
                terminated = True
                break
            name_rva = words[3] if index == 1 else words[1]
            if index == 13 and not words[0] & 1:
                name_rva -= image_base
            names.add(name_at(name_rva))
        if not terminated:
            raise ValueError(f"Unterminated PE import descriptor table in {path}")
    return sorted(names, key=str.lower)


def windows_bundle(main: Path, search_roots: list[Path], destination: Path):
    index = {}
    for root in search_roots:
        for path in root.rglob("*"):
            if path.is_file() and path.suffix.lower() in (".dll", ".drv"):
                key = path.name.lower()
                if key in index and sha256(path) != sha256(index[key]):
                    raise ValueError(f"Ambiguous Windows runtime basename: {path.name}")
                index[key] = path
    pending = [("libmpv-2.dll", main)]
    shipped, external, edges = {}, set(), {}
    while pending:
        name, path = pending.pop()
        key = name.lower()
        if key in shipped:
            continue
        assert_x64(path, "windows")
        needed = pe_needed(path)
        edges[key] = needed
        shipped[key] = {"path": str(path.resolve()), "input_sha256": sha256(path)}
        shutil.copy2(path, destination / key)
        for dependency in needed:
            dep = dependency.lower()
            if dep in WINDOWS_HOST_LIBS or dep.startswith(("api-ms-win-", "ext-ms-win-")):
                external.add(dep)
                continue
            if dep not in index:
                raise ValueError(f"Unresolved PE import: {name} -> {dependency}")
            pending.append((dep, index[dep]))
    return {"libraries": shipped, "host_libraries": sorted(external), "edges": edges}


def macro(path: Path, name: str) -> bool:
    return bool(re.search(rf"(?m)^#define\s+{re.escape(name)}\s+1\s*$", path.read_text()))


def copy_licenses(sources: dict[str, Path], destination: Path):
    destination.mkdir(parents=True, exist_ok=True)
    notice_index = {}
    for name, source_path in sources.items():
        files = [p for p in source_path.iterdir() if p.is_file() and
                 re.match(r"^(?:COPYING|LICEN[CS]E|Copyright|NOTICE)(?:[.\-_].*)?$", p.name, re.I)]
        if not files:
            # Some upstream repositories keep their project in one directory
            # (e.g. expat/); generated model archives may provide no notice file.
            files = [p for p in source_path.glob("*/*") if p.is_file() and
                     re.match(r"^(?:COPYING|LICEN[CS]E|Copyright|NOTICE)(?:[.\-_].*)?$", p.name, re.I)]
        notice_index[name] = [str(p.relative_to(source_path)) for p in sorted(files)]
        for path in files:
            target = destination / name / path.relative_to(source_path)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, target)
    (destination / "SOURCE_NOTICE_INDEX.json").write_text(json.dumps(notice_index, indent=2, sort_keys=True) + "\n")


def host_identity() -> dict:
    tools = {}
    for name in ("cc", "c++", "clang", "meson", "ninja", "pkg-config", "cmake", "patchelf"):
        executable = shutil.which(name)
        if executable:
            tools[name] = {"path": executable, "sha256": sha256(Path(executable).resolve()),
                           "version": run([name, "--version"], capture=True).splitlines()[0]}
    return {"system": platform.platform(), "machine": platform.machine(), "tools": tools,
            "os_release": Path("/etc/os-release").read_text()}


def common_identity(entry: dict, lock_path: Path) -> dict:
    return {"origin": "source", "recipe": dict(entry["recipe"]),
            "source_lock_sha256": sha256(lock_path),
            "adapter_files": {p.name: sha256(p) for p in Path(__file__).parent.glob("*.py")},
            "toolchain": host_identity()}


def linux(entry: dict, work: Path, root: Path):
    prefix = work / "prefix"
    sources = {}
    for name, value in entry["sources"].items():
        destination = work / "sources" / name
        checkout(value, destination)
        sources[name] = destination
    environment = dict(os.environ)
    environment.update(PKG_CONFIG_PATH=str(prefix / "lib/pkgconfig"),
                       LD_LIBRARY_PATH=str(prefix / "lib"))
    jobs = str(entry["jobs"])
    ffbuild = work / "ffmpeg-build"
    ffbuild.mkdir()
    ffargs = [str(sources["ffmpeg"] / "configure"), f"--prefix={prefix}",
              "--libdir=" + str(prefix / "lib"), *entry["ffmpeg_options"]]
    run(ffargs, cwd=ffbuild, env=environment)
    run(["make", "-j", jobs], cwd=ffbuild, env=environment)
    run(["make", "install"], cwd=ffbuild, env=environment)
    plbuild = work / "libplacebo-build"
    plargs = ["meson", "setup", plbuild, sources["libplacebo"],
              f"--prefix={prefix}", "--libdir=lib", "--wrap-mode=nodownload",
              *entry["libplacebo_options"]]
    run(plargs, env=environment)
    run(["ninja", "-C", plbuild, "-j", jobs], env=environment)
    run(["ninja", "-C", plbuild, "install"], env=environment)
    mpvbuild = work / "mpv-build"
    mpvargs = ["meson", "setup", mpvbuild, sources["mpv"],
               f"--prefix={prefix}", "--libdir=lib", "--wrap-mode=nodownload",
               *entry["mpv_options"]]
    run(mpvargs, env=environment)
    run(["ninja", "-C", mpvbuild, "-j", jobs], env=environment)
    run(["ninja", "-C", mpvbuild, "install"], env=environment)
    for required in ("HAVE_GL", "HAVE_EGL", "HAVE_PULSE", "HAVE_ALSA", "HAVE_VAAPI"):
        if not macro(mpvbuild / "config.h", required):
            raise ValueError(f"Linux required capability was compiled out: {required}")
    (root / "lib").mkdir()
    closure = linux_bundle(prefix / "lib/libmpv.so.2", prefix, root / "lib")
    shutil.copytree(prefix / "include/mpv", root / "include/mpv")
    (root / "lib/libmpv.so").symlink_to("libmpv.so.2")
    version = run(["pkg-config", "--modversion", "mpv"], env=environment, capture=True)
    (root / "lib/pkgconfig").mkdir()
    (root / "lib/pkgconfig/mpv.pc").write_text(
        "prefix=${pcfiledir}/../..\nlibdir=${prefix}/lib\nincludedir=${prefix}/include\n"
        f"Name: mpv\nDescription: Source-matched libmpv client SDK\nVersion: {version}\n"
        "Libs: -L${libdir} -lmpv\nCflags: -I${includedir}\n")
    probe = root / "evidence/link-probe.c"
    probe.write_text('#include <mpv/client.h>\n#include <mpv/render_gl.h>\n'
                     'int main(void) { mpv_handle *p = mpv_create(); '
                     'mpv_terminate_destroy(p); return mpv_client_api_version() == 0; }\n')
    run(["cc", probe, f"-I{root / 'include'}", f"-L{root / 'lib'}", "-lmpv",
         "-Wl,--no-allow-shlib-undefined", f"-Wl,-rpath-link,{root / 'lib'}",
         "-o", root / "evidence/link-probe"], env=environment)
    shutil.copy2(mpvbuild / "config.h", root / "evidence/mpv-config.h")
    shutil.copy2(ffbuild / "config.h", root / "evidence/ffmpeg-config.h")
    copy_licenses(sources, root / "licenses")
    # Bundled distro libraries retain their installed copyright/license texts.
    packages = set()
    for value in closure["libraries"].values():
        path = Path(value["path"])
        if not path.is_relative_to(prefix):
            query = subprocess.run(["dpkg-query", "-S", str(path)], text=True,
                                   stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
            if query.returncode:
                # usr-merged dpkg databases may record the /lib alias.
                alternate = str(path).replace("/usr/lib/", "/lib/", 1)
                query = subprocess.run(["dpkg-query", "-S", alternate], text=True,
                                       stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
            if query.returncode:
                raise ValueError(f"No package/license provenance for bundled library {path}")
            packages.add(query.stdout.split(": ", 1)[0])
    for package in packages:
        name = package.split(":", 1)[0]
        copyright_path = Path("/usr/share/doc") / name / "copyright"
        if not copyright_path.is_file():
            raise ValueError(f"Missing distro copyright notice for {package}")
        shutil.copy2(copyright_path, root / "licenses" / f"{name}.copyright")
    versions = run(["dpkg-query", "-W", "-f=${Package}\t${Version}\t${Architecture}\n"], capture=True)
    (root / "evidence/host-packages.tsv").write_text(versions + "\n")
    capabilities = ["libmpv", "opengl", "egl", "vaapi", "alsa", "pulseaudio"]
    for name, define in (("mpv.pl-dovi-linear-disable", "HAVE_PL_DOVI_LINEAR_DISABLE"),
                         ("mpv.lavf-initial-dovi-hvcc", "HAVE_LAVF_INITIAL_DOVI_HVCC")):
        if macro(mpvbuild / "config.h", define):
            capabilities.append(name)
    return ({"include": "include", "runtime": "lib/libmpv.so.2",
             "bundle": ["lib/" + name for name in sorted(closure["libraries"])]},
            capabilities, closure,
            {"sources": {k: source(v, k) for k, v in entry["sources"].items()},
             "options": {name: entry[name] for name in
                         ("ffmpeg_options", "libplacebo_options", "mpv_options")}})


def windows(entry: dict, work: Path, root: Path):
    recipe = work / "recipe"
    checkout(entry["recipe"], recipe)
    windows_recipe.prepare(recipe, work, entry["git"])
    windows_recipe.download(entry["windows_winmd"]["url"], work / "Windows.winmd",
                            entry["windows_winmd"]["sha256"])
    # Strengthen the recipe's archive hashes (including its SHA1-only lzo input).
    for name, value in entry["archives"].items():
        path = recipe / "packages" / f"{name}.cmake"
        text = path.read_text()
        if value["url"] not in text or value["recipe_hash"] not in text:
            raise ValueError(f"Source archive no longer matches recipe: {name}")
        path.write_text(text.replace(value["recipe_hash"], "SHA256=" + value["sha256"]))
    entries = windows_recipe.configure(recipe, work, jobs=entry["jobs"])
    if sorted(entries) != entry["closure"] or entry["targets"] != windows_recipe.ROOT_TARGETS:
        raise ValueError("Windows build graph differs from the reviewed source lock")
    actual_git = {k for k, v in entries.items() if v["repository"]}
    actual_archives = {k for k, v in entries.items() if v["url"]}
    if actual_git != set(entry["git"]) or actual_archives != set(entry["archives"]):
        raise ValueError("Windows source dependency set differs from the lock")
    for name in actual_git:
        expected = entry["git"][name]
        if entries[name]["ref"] != expected["commit"] or entries[name]["repository"] != expected["repository"]:
            raise ValueError(f"Windows source was not pinned: {name}")
    # Build the compiler before the target CRT and packages; upstream's package
    # targets do not themselves depend on the host LLVM bootstrap target.
    for target in entry["targets"]:
        run(["ninja", "-C", work / "build", "-j", str(entry["jobs"]), target])
    for name in actual_git:
        actual = run(["git", "rev-parse", "HEAD"], cwd=entries[name]["source_dir"], capture=True)
        if actual != entry["git"][name]["commit"]:
            raise ValueError(f"Windows dependency moved during compilation: {name}")
    packages = list((work / "build").glob("mpv-dev-x86_64-*-git-*"))
    if len(packages) != 1:
        raise ValueError("Expected exactly one freshly built Windows mpv developer package")
    package = packages[0]
    config = work / "build/packages/mpv-prefix/src/mpv-build/config.h"
    if not macro(config, "HAVE_D3D11"):
        raise ValueError("Windows DXGI implementation was compiled out")
    ninja = config.parent / "build.ninja"
    if "libmpv_d3d11.c" not in ninja.read_text():
        raise ValueError("Patched Windows libmpv DXGI object is missing from the build")
    header = package / "include/mpv/render.h"
    if "MPV_RENDER_API_TYPE_DXGI" not in header.read_text():
        raise ValueError("Windows public headers lack the required DXGI extension")
    (root / "bin").mkdir()
    closure = windows_bundle(package / "libmpv-2.dll",
                             [package, work / "prefix/bin"], root / "bin")
    shutil.copytree(package / "include", root / "include")
    (root / "lib").mkdir()
    shutil.copy2(package / "libmpv.dll.a", root / "lib/libmpv.dll.a")
    probe = root / "evidence/link-probe.c"
    probe.write_text('#include <mpv/client.h>\n#include <mpv/render_dxgi.h>\n'
                     'int main(void) { mpv_dxgi_init_params p = {0}; '
                     'mpv_render_param r = {MPV_RENDER_PARAM_DXGI_INIT_PARAMS, &p}; '
                     '(void)r; return mpv_client_api_version() == 0; }\n')
    run([work / "toolchain/bin/x86_64-w64-mingw32-clang", probe,
         f"-I{root / 'include'}", root / "lib/libmpv.dll.a",
         "-o", root / "evidence/link-probe.exe"])
    shutil.copy2(config, root / "evidence/mpv-config.h")
    diff = run(["git", "diff", "--binary"], cwd=recipe, capture=True)
    (root / "evidence/recipe-adapter.patch").write_text(diff + "\n")
    copy_licenses({name: Path(entries[name]["source_dir"]) for name in actual_git | actual_archives}, root / "licenses")
    patches = {str(p.relative_to(recipe)): sha256(p) for p in (recipe / "packages").glob("*.patch")}
    return ({"include": "include", "runtime": "bin/libmpv-2.dll",
             "import_library": "lib/libmpv.dll.a",
             "bundle": ["bin/" + name for name in sorted(closure["libraries"])]},
            ["libmpv", "dxgi"], closure,
            {"sources": {k: source(v, k) for k, v in entry["git"].items()},
             "archives": entry["archives"], "windows_winmd": entry["windows_winmd"],
             "patches": patches, "recipe_adapter_sha256": sha256(root / "evidence/recipe-adapter.patch"),
             "options": {"architecture": "x86-64", "compiler": "clang", "targets": entry["targets"]}})


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", choices=["linux", "windows"], required=True)
    parser.add_argument("--lock", type=Path, required=True, help="Global source request JSON")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--jobs", type=int, default=min(os.cpu_count() or 2, 4))
    parser.add_argument("--check-lock", action="store_true", help="Validate inputs without downloading or building")
    args = parser.parse_args(argv)
    request, entry, lock_path = load_inputs(args.lock, args.platform)
    if args.check_lock:
        print(json.dumps({"platform": args.platform, "source_lock_sha256": sha256(lock_path),
                          "recipe": entry["recipe"]}, sort_keys=True))
        return
    if sys.platform != "linux" or platform.machine() not in ("x86_64", "AMD64"):
        raise ValueError("Both desktop source profiles run on an x86_64 Linux build host")
    if args.jobs < 1:
        raise ValueError("--jobs must be positive")
    output = args.output.resolve()
    if output.exists() and any(output.iterdir()):
        raise ValueError("Output must be absent or empty: source builds never reuse partial prefixes")
    output.mkdir(parents=True, exist_ok=True)
    work, root = output / "work", output / "root"
    work.mkdir()
    root.mkdir()
    (root / "evidence").mkdir()
    entry = dict(entry, jobs=args.jobs)
    identity = common_identity(entry, lock_path)
    layout, capabilities, closure, build_identity = (linux if args.platform == "linux" else windows)(entry, work, root)
    identity.update(build_identity)
    required = set(request.get("required_capabilities", []))
    if not required.issubset(capabilities):
        raise ValueError(f"Missing compiled capabilities: {sorted(required - set(capabilities))}")
    (root / "evidence/runtime-closure.json").write_text(json.dumps(closure, indent=2, sort_keys=True) + "\n")
    shutil.copy2(lock_path, root / "evidence/desktop-sources.lock.json")
    spec = {"schema": 1, "kind": "media-kit-native-package", "platform": args.platform,
            "architectures": ["x86_64"], "profile": f"piliplus-{args.platform}-source-v1",
            "identity": identity, "layout": layout, "capabilities": capabilities,
            "validation": {"compiled": True, "runtime": False, "device": False}}
    (output / "spec.json").write_text(json.dumps(spec, indent=2, sort_keys=True) + "\n")
    print(json.dumps({"root": str(root), "spec": str(output / "spec.json")}, sort_keys=True))


if __name__ == "__main__":
    try:
        main()
    except (KeyError, ValueError, RuntimeError, subprocess.CalledProcessError) as error:
        sys.exit(f"desktop source build: {error}")
