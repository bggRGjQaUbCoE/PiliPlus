#!/usr/bin/env python3
"""Locked native production, transport and application provenance for CI.

Only this adapter downloads packages. media-kit verifies the complete payload
again at each native consumer. Explicit inputs never fall back to a release.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import stat
import subprocess
import sys
import tarfile
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parents[2]
LOCK = ROOT / "tool/native/inputs.lock.json"
PACKAGES = ROOT / "tool/native/packages.lock.json"
PLATFORMS = ("android", "windows", "linux", "ios", "macos", "ohos")
SHA = re.compile(r"^[0-9a-f]{40}$")
DIGEST = re.compile(r"^[0-9a-f]{64}$")


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode()


def digest(path):
    with Path(path).open("rb") as source:
        return hashlib.file_digest(source, "sha256").hexdigest()


def adapter_digest(path):
    # Git for Windows may check out text as CRLF. Identical source must keep
    # the same native-input identity when producer and consumer use different OSes.
    return hashlib.sha256(Path(path).read_bytes().replace(b"\r\n", b"\n")).hexdigest()


def write_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def run(*args, cwd=None, capture=False, env=None):
    print("+ " + " ".join(map(str, args)), file=sys.stderr, flush=True)
    return subprocess.run(list(map(str, args)), cwd=cwd, env=env, check=True,
                          text=True, stdout=subprocess.PIPE if capture else None).stdout


def load_lock(path=LOCK):
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    if data.get("schema") != 1 or set(data["platforms"]) != set(PLATFORMS):
        raise ValueError("The source lock must cover all six supported platforms")
    if data["media_kit"] != {"repository": "Goodwu/media-kit", "branch": "dev"}:
        raise ValueError("media-kit SDK source must be Goodwu/media-kit dev")
    for platform, item in data["platforms"].items():
        if item["default_mode"] not in ("source", "upstream"):
            raise ValueError("Invalid default mode: " + platform)
        producer = item["source"]["producer"]
        if not SHA.fullmatch(producer["commit"]):
            raise ValueError("Producer is not immutable: " + platform)
        for archive in item.get("upstream", {}).get("archives", []):
            if not DIGEST.fullmatch(archive["sha256"]) or not archive["url"].startswith("https://"):
                raise ValueError("Upstream archives require HTTPS and SHA256")
    return data


def select(lock, platform, mode, packages=None):
    item = lock["platforms"][platform]
    packages = packages or {}
    if mode == "auto":
        mode = "package" if platform in packages else item["default_mode"]
    if mode == "package":
        package = packages.get(platform)
        if not package:
            raise ValueError("No reviewed package is locked for " + platform)
        # A package must declare which source/upstream inputs it replaces.
        base_mode = package["mode"]
        if base_mode not in ("source", "upstream"):
            raise ValueError("A package must bind source or upstream inputs")
        expected = input_digest(lock, platform, base_mode)
        if package["inputs_sha256"] != expected:
            raise ValueError("Locked package is stale for " + platform)
        for name in ("archive_sha256", "manifest_sha256", "identity_sha256"):
            if not DIGEST.fullmatch(package[name]):
                raise ValueError("Missing package digest: " + name)
        return mode, base_mode, expected
    if mode not in ("source", "upstream") or mode not in item:
        raise ValueError("No " + mode + " profile for " + platform)
    return mode, mode, input_digest(lock, platform, mode)


def input_digest(lock, platform, mode):
    # Application/Dart commits intentionally do not invalidate native builds.
    # Producer commits, native inputs and the packaging adapter do.
    adapter_files = [Path(__file__)]
    if platform in ("windows", "linux") and mode == "source":
        adapter_files += sorted(p for p in (ROOT / "tool/native/desktop").glob("*")
                                if p.suffix in (".py", ".json", ".sh"))
    adapter = {p.relative_to(ROOT).as_posix(): adapter_digest(p) for p in adapter_files}
    item = lock["platforms"][platform]
    return hashlib.sha256(canonical({"schema": 1, "platform": platform,
        "architectures": item["architectures"], "mode": mode,
        "inputs": item[mode], "adapter": adapter})).hexdigest()


def packages(path=PACKAGES):
    data = json.loads(Path(path).read_text())
    if data.get("schema") != 1:
        raise ValueError("Unsupported package lock")
    return data["packages"]


def emit(values, target="GITHUB_OUTPUT"):
    for key, value in values.items():
        text = str(value)
        if "\n" in text or "\r" in text:
            raise ValueError("Multiline workflow output is forbidden")
        if os.environ.get(target):
            with open(os.environ[target], "a", encoding="utf-8") as output:
                output.write(f"{key}={text}\n")
    print(json.dumps(values, sort_keys=True))


def plan(args):
    lock = load_lock(args.lock)
    if not SHA.fullmatch(args.media_kit_commit):
        raise ValueError("plan requires the resolved 40-character media-kit dev SHA")
    selected = json.loads(args.platforms)
    if not isinstance(selected, list) or not selected or len(set(selected)) != len(selected) or any(p not in PLATFORMS for p in selected):
        raise ValueError("platforms must be a nonempty unique JSON array of supported names")
    result = []
    package_lock = packages(args.packages)
    for name in selected:
        mode, base_mode, identity = select(lock, name, args.mode, package_lock)
        item = lock["platforms"][name]
        cache_identity = identity + ("-" + package_lock[name]["archive_sha256"] if mode == "package" else "")
        result.append({"platform": name, "mode": mode, "base_mode": base_mode,
            "inputs_sha256": identity, "native_runner": "macos-15" if name in ("ios", "macos") and mode == "source" else "ubuntu-24.04",
            "app_runner": item["runner"], "cache_key": "native-v1-" + name + "-" + mode + "-" + cache_identity})
    emit({"matrix": json.dumps({"include": result}, separators=(",", ":")),
          "media_kit_ref": args.media_kit_commit, "flutter_version": lock["flutter"]["version"]})


def safe_name(value):
    value = value.removeprefix("./")
    path = PurePosixPath(value)
    if not value or path.is_absolute() or ".." in path.parts or "\\" in value or ":" in value or "\x00" in value:
        raise ValueError("Unsafe archive path: " + value)
    return path.as_posix()


def extract(archive, destination):
    """Extract authenticated tar/zip payloads without traversing link parents."""
    archive, destination = Path(archive), Path(destination)
    if destination.exists():
        raise ValueError("Extraction destination must be fresh")
    destination.mkdir(parents=True)
    links, seen = [], set()
    if zipfile.is_zipfile(archive):
        with zipfile.ZipFile(archive) as source:
            for entry in source.infolist():
                if entry.filename in (".", "./"):
                    continue
                name = safe_name(entry.filename)
                if name.casefold() in seen:
                    raise ValueError("Duplicate archive member: " + name)
                seen.add(name.casefold())
                out = destination / name
                mode = entry.external_attr >> 16
                if stat.S_ISLNK(mode):
                    links.append((out, source.read(entry).decode("utf-8")))
                elif entry.is_dir():
                    out.mkdir(parents=True, exist_ok=True)
                else:
                    out.parent.mkdir(parents=True, exist_ok=True)
                    with source.open(entry) as src, out.open("xb") as dst:
                        shutil.copyfileobj(src, dst)
                    if mode & 0o111:
                        out.chmod(0o755)
    elif tarfile.is_tarfile(archive):
        with tarfile.open(archive) as source:
            for entry in source:
                if entry.name in (".", "./"):
                    continue
                name = safe_name(entry.name)
                if name.casefold() in seen:
                    raise ValueError("Duplicate archive member: " + name)
                seen.add(name.casefold())
                out = destination / name
                if entry.issym():
                    links.append((out, entry.linkname))
                elif entry.isdir():
                    out.mkdir(parents=True, exist_ok=True)
                elif entry.isfile():
                    out.parent.mkdir(parents=True, exist_ok=True)
                    with source.extractfile(entry) as src, out.open("xb") as dst:
                        shutil.copyfileobj(src, dst)
                    out.chmod(0o755 if entry.mode & 0o111 else 0o644)
                else:
                    raise ValueError("Archive contains a device or hard link: " + name)
    else:
        # Only pinned upstream Windows SDKs use 7z. Arbitrary reusable packages
        # must use tar/zip, whose extraction is implemented above.
        listing = run("7z", "l", "-slt", archive, capture=True).split("----------\n", 1)
        if len(listing) != 2:
            raise ValueError("Cannot inspect 7z archive")
        for entry in listing[1].split("\n\n"):
            fields = dict(line.split(" = ", 1) for line in entry.splitlines() if " = " in line)
            if "Path" in fields:
                safe_name(fields["Path"])
                if "Symbolic Link" in fields or "Hard Link" in fields:
                    raise ValueError("7z SDK must not contain links")
        run("7z", "x", "-y", "-o" + str(destination), archive)
    for out, target in links:
        if PurePosixPath(target).is_absolute() or "\\" in target or ":" in target:
            raise ValueError("Unsafe archive link")
        if not (out.parent / target).resolve().is_relative_to(destination.resolve()):
            raise ValueError("Archive link escapes package")
        # Real files were extracted first. A link must not replace a directory
        # or become the parent of another member.
        out.parent.mkdir(parents=True, exist_ok=True)
        out.symlink_to(target)
    for out, _ in links:
        if not out.resolve().is_relative_to(destination.resolve()) or not out.exists():
            raise ValueError("Dangling or escaping archive link")


def download(url, expected, target):
    if not url.startswith("https://") or not DIGEST.fullmatch(expected):
        raise ValueError("Downloads require HTTPS and an exact SHA256")
    target = Path(target)
    target.parent.mkdir(parents=True, exist_ok=True)
    request = urllib.request.Request(url, headers={"User-Agent": "PiliPlus-native-CI/1"})
    with urllib.request.urlopen(request, timeout=120) as source, target.open("wb") as output:
        if not source.url.startswith("https://"):
            raise ValueError("Insecure download redirect")
        shutil.copyfileobj(source, output)
    if digest(target) != expected:
        target.unlink()
        raise ValueError("Downloaded archive SHA256 mismatch")


def unique(paths, label):
    paths = list(paths)
    if len(paths) != 1:
        raise ValueError(f"Expected exactly one {label}, found {len(paths)}")
    return paths[0]


def upstream(lock, platform, work):
    config = lock["platforms"][platform]["upstream"]
    roots = {}
    for entry in config["archives"]:
        path = work / (entry["role"] + Path(entry["url"]).name)
        download(entry["url"], entry["sha256"], path)
        target = work / entry["role"]
        extract(path, target)
        roots[entry["role"]] = target
    output = work / "package"
    output.mkdir()
    include = output / "include/mpv"
    include.mkdir(parents=True)
    if platform == "windows":
        sdk = roots["sdk"]
        headers = unique(sdk.rglob("mpv/client.h"), "Windows SDK client.h").parent
        for header in headers.glob("*.h"):
            shutil.copy2(header, include / header.name)
        library = unique(sdk.rglob("libmpv.dll.a"), "Windows import library")
        shutil.copy2(library, output / library.name)
        dlls = sorted(sdk.rglob("*.dll"))
        for dll in dlls:
            if (output / dll.name).exists():
                raise ValueError("Ambiguous DLL basename")
            shutil.copy2(dll, output / dll.name)
        layout = {"include": "include", "import_library": library.name,
                  "runtime": "libmpv-2.dll", "bundle": [p.name for p in dlls]}
    elif platform == "linux":
        headers = unique(roots["headers"].rglob("client.h"), "Linux SDK client.h").parent
        for header in headers.glob("*.h"):
            shutil.copy2(header, include / header.name)
        native = unique(roots["runtime"].rglob("libmpv.so.2"), "Linux libmpv")
        (output / "lib").mkdir()
        # Preserve accompanying media libraries. System graphics/audio/font
        # dependencies remain target-distribution requirements (see evidence).
        bundle = []
        for library in sorted(native.parent.glob("*.so*")):
            target = output / "lib" / library.name
            shutil.copy2(library, target, follow_symlinks=False)
            bundle.append(target.relative_to(output).as_posix())
        layout = {"include": "include", "runtime": "lib/libmpv.so.2", "bundle": bundle}
        library_bytes = (output / layout["runtime"]).read_bytes()
        if library_bytes[:7] != b"\x7fELF\x02\x01\x01" or int.from_bytes(library_bytes[18:20], "little") != 62:
            raise ValueError("Upstream Linux runtime is not x86_64 ELF")
        dynamic = run("readelf", "--dynamic", output / layout["runtime"], capture=True)
        needed = sorted(set(re.findall(r"\(NEEDED\).*Shared library: \[([^]]+)\]", dynamic)))
        write_json(output / "runtime-dependencies.json", {"platform": "linux-x86_64", "needed": needed,
            "scope": "ELF-inspection-only", "runtime_executed": False})
    else:
        frameworks = sorted(roots["frameworks"].rglob("*.xcframework"))
        if not frameworks:
            raise ValueError("The pinned Apple archive contains no XCFrameworks")
        (output / "Frameworks").mkdir()
        for framework in frameworks:
            shutil.copytree(framework, output / "Frameworks" / framework.name, symlinks=True)
        headers = unique(roots["headers"].rglob("libmpv/client.h"), "Apple matching mpv header").parent
        for header in headers.glob("*.h"):
            shutil.copy2(header, include / header.name)
        layout = {"include": "include", "frameworks": ["Frameworks/" + p.name for p in frameworks]}
    spec = {"schema": 1, "kind": "media-kit-native-package", "platform": platform,
        "architectures": lock["platforms"][platform]["architectures"], "profile": config["profile"],
        "identity": {"origin": "upstream-binary", "sources": config.get("sources", {}),
            "recipe": config["recipe"], "archives": config["archives"],
            "toolchain": {"status": "not-rebuilt-in-this-run"}, "options": {}, "patches": {}},
        "layout": layout, "capabilities": config["capabilities"],
        "validation": {"compiled": False, "runtime": False, "device": False}}
    return output, spec


def checkout(config, destination):
    if not SHA.fullmatch(config["commit"]):
        raise ValueError("Source checkout requires a full commit")
    repository = config["repository"]
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository):
        raise ValueError("Expected a GitHub owner/repository")
    run("git", "init", destination)
    run("git", "remote", "add", "origin", "https://github.com/" + repository + ".git", cwd=destination)
    run("git", "fetch", "--depth=1", "origin", config["commit"], cwd=destination)
    run("git", "checkout", "--detach", "FETCH_HEAD", cwd=destination)
    if run("git", "rev-parse", "HEAD", cwd=destination, capture=True).strip() != config["commit"]:
        raise ValueError("Producer checkout mismatch")


def source(lock, platform, work):
    config = lock["platforms"][platform]["source"]
    if platform in ("windows", "linux"):
        request = work / "desktop-inputs.json"
        write_json(request, config)
        run(sys.executable, ROOT / "tool/native/desktop/build.py", "--platform", platform,
            "--lock", request, "--output", work / "desktop")
        return work / "desktop/root", json.loads((work / "desktop/spec.json").read_text())
    producer = work / "producer"
    checkout(config["producer"], producer)
    spec = work / "spec.json"
    output = work / "package"
    if platform == "android":
        write_json(work / "android-sources.json", config["sources"])
        sdk = producer / "buildscripts/sdk"
        sdk.mkdir()
        (sdk / "android-sdk-linux").symlink_to(Path(os.environ["ANDROID_HOME"]))
        run("bash", "buildscripts/bundle_default.sh", "--source-lock", work / "android-sources.json", cwd=producer)
        stage = producer / "buildscripts/routing-native-package"
        run(sys.executable, "buildscripts/scripts/package_native_bundle.py", "--build-root", "buildscripts",
            "--output", stage, "--android-api", str(config["toolchain"]["android_api"]), cwd=producer)
        return stage / "root", json.loads((stage / "spec.json").read_text())
    if platform == "ohos":
        run("bash", "bundle.sh", cwd=producer)
        run(sys.executable, "scripts/package_native.py", "--output", output, "--spec", spec, cwd=producer)
    else:
        xcode = config["toolchain"]["xcode_path"]
        env = dict(os.environ, XCODE_PATH=xcode, DEVELOPER_DIR=xcode + "/Contents/Developer")
        run("nix", "develop", "--no-update-lock-file", "-c", "make", "XCODE_PATH=" + xcode,
            "TARGET=mk-out-xcframeworks-" + platform + "-universal-video-default", cwd=producer, env=env)
        run(sys.executable, "scripts/package_native.py", "--platform", platform,
            "--frameworks", "result", "--output", output, "--spec", spec, cwd=producer, env=env)
    return output, json.loads(spec.read_text())


def verify_policy(lock, platform, mode, manifest, expected_inputs):
    item = lock["platforms"][platform]
    identity = manifest["identity"]
    if identity.get("options", {}).get("ci_inputs_sha256") != expected_inputs:
        raise ValueError("Native package was built for different locked inputs")
    if set(manifest["architectures"]) != set(item["architectures"]):
        raise ValueError("Native package architecture coverage differs from the lock")
    required = item[mode].get("required_capabilities", item[mode].get("capabilities", []))
    if not set(required).issubset(manifest["capabilities"]):
        raise ValueError("Native package omits required compiled capabilities")
    if mode == "source":
        if identity["origin"] != "source" or not manifest["validation"]["compiled"]:
            raise ValueError("Source profile requires actual compiled source evidence")
        if identity["recipe"]["commit"] != item["source"]["producer"]["commit"]:
            raise ValueError("Native recipe differs from the source lock")
        for name, entry in item["source"].get("sources", {}).items():
            if identity["sources"].get(name, {}).get("commit") != entry["commit"]:
                raise ValueError("Native source differs from the lock: " + name)
    elif identity["origin"] != "upstream-binary" or identity.get("archives") != item["upstream"]["archives"]:
        raise ValueError("Native archive provenance differs from the upstream lock")


def verifier(sdk):
    path = Path(sdk).resolve() / "tool/native_package/package.py"
    if not path.is_file():
        raise ValueError("The locked media-kit native verifier is missing")
    return path


def verify_payload(sdk, root, receipt, platform):
    run(sys.executable, verifier(sdk), "verify", "--root", root,
        "--manifest-sha256", receipt["manifest_sha256"], "--platform", platform,
        "--expected-identity", receipt["identity_sha256"])
    return json.loads((Path(root) / "manifest.json").read_text())


def build_native(args):
    lock = load_lock(args.lock)
    mode, base_mode, key = select(lock, args.platform, args.mode, packages(args.packages))
    work, transport = Path(args.work).resolve(), Path(args.transport).resolve()
    if work.exists() or transport.exists():
        raise ValueError("Build and transport destinations must be fresh")
    work.mkdir(parents=True)
    transport.mkdir(parents=True)
    if mode == "package":
        entry = packages(args.packages)[args.platform]
        archive = transport / "native-package.tar.gz"
        download(entry["url"], entry["archive_sha256"], archive)
        if not tarfile.is_tarfile(archive) and not zipfile.is_zipfile(archive):
            raise ValueError("Reusable packages must use tar or zip")
        payload = work / "package"
        extract(archive, payload)
        receipt = {key: entry[key] for key in ("archive_sha256", "manifest_sha256", "identity_sha256", "inputs_sha256")}
        manifest = verify_payload(args.media_kit, payload, receipt, args.platform)
        verify_policy(lock, args.platform, base_mode, manifest, key)
    else:
        payload, spec = source(lock, args.platform, work) if mode == "source" else upstream(lock, args.platform, work)
        spec["identity"]["options"]["ci_inputs_sha256"] = key
        write_json(work / "final-spec.json", spec)
        receipt = json.loads(run(sys.executable, verifier(args.media_kit), "create", "--root", payload,
            "--spec", work / "final-spec.json", capture=True))
        manifest = verify_payload(args.media_kit, payload, receipt, args.platform)
        verify_policy(lock, args.platform, base_mode, manifest, key)
        archive = transport / "native-package.tar.gz"
        with tarfile.open(archive, "w:gz", dereference=False) as output:
            for entry in sorted(payload.iterdir()):
                output.add(entry, arcname=entry.name, recursive=True)
        receipt["archive_sha256"] = digest(archive)
        receipt["inputs_sha256"] = key
    receipt.update({"schema": 1, "platform": args.platform, "mode": base_mode})
    receipt.pop("root", None)
    receipt.pop("manifest", None)
    write_json(transport / "native-package-receipt.json", receipt)
    print(json.dumps(receipt, sort_keys=True))


def consume(args):
    lock = load_lock(args.lock)
    package_lock = packages(args.packages)
    mode, base_mode, key = select(lock, args.platform, args.mode, package_lock)
    transport = Path(args.transport).resolve()
    receipt = json.loads((transport / "native-package-receipt.json").read_text())
    archive = transport / "native-package.tar.gz"
    if receipt["inputs_sha256"] != key or receipt["mode"] != base_mode or digest(archive) != receipt["archive_sha256"]:
        raise ValueError("Native artifact does not match the requested locked inputs")
    if mode == "package" and any(receipt[name] != package_lock[args.platform][name]
                                 for name in ("archive_sha256", "manifest_sha256", "identity_sha256")):
        raise ValueError("Artifact differs from the explicitly selected reusable package")
    root = Path(args.output).resolve()
    extract(archive, root)
    manifest = verify_payload(args.media_kit, root, receipt, args.platform)
    verify_policy(lock, args.platform, base_mode, manifest, key)
    values = {"MEDIA_KIT_NATIVE_PACKAGE_ROOT": str(root),
        "MEDIA_KIT_NATIVE_PACKAGE_MANIFEST_SHA256": receipt["manifest_sha256"],
        "MEDIA_KIT_NATIVE_PACKAGE_PYTHON": sys.executable}
    if args.platform == "ohos":
        layout = manifest["layout"]
        values.update({"MEDIA_KIT_OHOS_LIBMPV_ARCHIVE": str(root / layout["archive"]),
            "MEDIA_KIT_OHOS_LIBMPV_SHA256": manifest["files"][layout["archive"]],
            "PILIPLUS_OHOS_LIBMPV_LIBRARY": str(root / layout["runtime"])})
    emit(values, "GITHUB_ENV")
    write_json(root.parent / "consumed-native.json", receipt)


def provenance(args):
    lock = load_lock(args.lock)
    sdk = Path(args.media_kit).resolve()
    actual_sdk = run("git", "rev-parse", "HEAD", cwd=sdk, capture=True).strip()
    if not SHA.fullmatch(args.media_kit_commit) or actual_sdk != args.media_kit_commit:
        raise ValueError("Application media-kit HEAD differs from the captured dev SHA")
    native = json.loads(Path(args.receipt).read_text())
    artifacts = Path(args.artifacts).resolve()
    modifications = run("git", "diff", "--binary", "HEAD", cwd=ROOT, capture=True)
    if modifications:
        (artifacts / "application-build.patch").write_text(modifications, encoding="utf-8")
    files = {p.relative_to(artifacts).as_posix(): digest(p) for p in sorted(artifacts.rglob("*")) if p.is_file()}
    if not files:
        raise ValueError("No application artifacts were produced")
    result = {"schema": 1, "platform": args.platform,
        "application": {"repository": os.environ.get("GITHUB_REPOSITORY", "Goodwu/PiliPlus"),
            "commit": run("git", "rev-parse", "HEAD", cwd=ROOT, capture=True).strip()},
        "media_kit": {"repository": lock["media_kit"]["repository"],
                      "branch": lock["media_kit"]["branch"], "commit": actual_sdk},
        "native": native, "application_files": files,
        "run": {"id": os.environ.get("GITHUB_RUN_ID"), "attempt": os.environ.get("GITHUB_RUN_ATTEMPT")},
        "validation": {"application_compiled": True, "runtime": False, "device": False}}
    write_json(args.output, result)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lock", default=str(LOCK))
    parser.add_argument("--packages", default=str(PACKAGES))
    commands = parser.add_subparsers(dest="command", required=True)
    p = commands.add_parser("plan")
    p.add_argument("--media-kit-commit", required=True,
                   help="Full dev HEAD captured once by the source-vector job")
    p.add_argument("--platforms", default=json.dumps(list(PLATFORMS)))
    p.add_argument("--mode", choices=("auto", "source", "upstream", "package"), default="auto")
    p.set_defaults(func=plan)
    for name, func in (("build-native", build_native), ("consume", consume)):
        p = commands.add_parser(name)
        p.add_argument("--platform", choices=PLATFORMS, required=True)
        p.add_argument("--mode", choices=("auto", "source", "upstream", "package"), default="auto")
        p.add_argument("--media-kit", required=True)
        p.add_argument("--transport", required=True)
        p.add_argument("--work" if name == "build-native" else "--output", required=True)
        p.set_defaults(func=func)
    p = commands.add_parser("provenance")
    p.add_argument("--media-kit-commit", required=True,
                   help="Same resolved dev SHA passed to every native/App checkout")
    for name in ("platform", "media-kit", "receipt", "artifacts", "output"):
        p.add_argument("--" + name, required=True)
    p.set_defaults(func=provenance)
    args = parser.parse_args()
    try:
        args.func(args)
    except (ValueError, KeyError, OSError, subprocess.CalledProcessError) as error:
        parser.exit(1, "native CI: " + str(error) + "\n")


if __name__ == "__main__":
    main()
