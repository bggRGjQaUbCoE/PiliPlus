#!/usr/bin/env python3
"""Check the reviewed desktop libmpv client subset against an explicit package.

Run on the target Linux/Windows x86_64 host after selecting the package:
  python tool/native/check_api.py --platform linux --media-kit ../media-kit \
      --output /absolute/native-api-report.json

The shared consumer authenticates every package file before native code loads.
Native calls run in a child process so a DLL crash still produces a CI report.
This checks existing client calls, symbol availability and create/destroy only;
it does not certify every generated FFI declaration, options, properties,
rendering, playback, or physical devices.

Updating REVIEWED_PROFILE requires reviewing regenerated binding signatures and
structures, the adapter's actual calls, and mpv's client-api-changes.rst. The
binding hash is a review boundary, not proof of complete ABI compatibility.
"""
from __future__ import annotations

import argparse
from contextlib import ExitStack
import ctypes
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import subprocess
import sys
import tempfile


REVIEWED_PROFILE = {
    "name": "media-kit-compat-libmpv-2",
    "runtime_major": 2,
    # The current generated file predates libmpv 2.0. Its used client subset was
    # reviewed; do NOT require this obsolete constant to equal the runtime API.
    "bindings_declared_api": 65645,  # 1.109
    "bindings_lf_sha256": "9c0103980f38576423a76566c3613b05a9b8aac37ade9fdc3e3bc9e3ec3ef612",
}
REMOVED_BINDINGS = {"mpv_detach_destroy", "mpv_get_sub_api", "mpv_suspend", "mpv_resume"}
OPTIONAL_BATCH = "mpv_mediakit_get_property_strings"
PROBE_SYMBOLS = {"mpv_client_api_version", "mpv_create", "mpv_terminate_destroy"}
BINDINGS_PATH = "media_kit/lib/generated/libmpv/bindings.dart"


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def lf_text(path: Path) -> str:
    # read_text uses universal newlines; keep the normalization explicit since
    # Windows checkout may use core.autocrlf without changing reviewed source.
    return path.read_text(encoding="utf-8").replace("\r\n", "\n")


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    temporary.replace(path)


def version(value: int) -> dict:
    return {"value": value, "major": value >> 16, "minor": value & 0xFFFF}


def check_versions(header: int, runtime: int) -> None:
    if runtime >> 16 != REVIEWED_PROFILE["runtime_major"]:
        raise ValueError("Runtime API major is outside the reviewed profile; review bindings and adapter")
    if header >> 16 != runtime >> 16 or runtime < header:
        raise ValueError("Require the same header/runtime API major and runtime API >= header API")


def dart_tokens(text: str):
    """Yield identifiers/punctuation with lines, ignoring comments and strings.

    Preserve ${...} Dart string interpolation code, including nested braces.
    Member references also cover tear-offs, not just calls followed by '('.
    """
    index, line = 0, 1

    def code(interpolation=False):
        nonlocal index, line
        braces = 0
        while index < len(text):
            if interpolation and text[index] == "}" and braces == 0:
                index += 1
                return
            if text.startswith("//", index):
                end = text.find("\n", index)
                index = len(text) if end < 0 else end
            elif text.startswith("/*", index):
                index += 2
                depth = 1
                while index < len(text) and depth:
                    if text.startswith("/*", index):
                        depth += 1
                        index += 2
                    elif text.startswith("*/", index):
                        depth -= 1
                        index += 2
                    else:
                        line += text[index] == "\n"
                        index += 1
                if depth:
                    raise ValueError("Unterminated Dart block comment")
            elif text[index] in "\"'" or (text[index] == "r" and text[index + 1:index + 2] in {"\"", "'"}):
                raw = text[index] == "r"
                index += int(raw)
                quote = text[index]
                delimiter = quote * (3 if text.startswith(quote * 3, index) else 1)
                index += len(delimiter)
                yield "<string>", line
                while index < len(text) and not text.startswith(delimiter, index):
                    if not raw and text[index] == "\\":
                        line += text[index:index + 2].count("\n")
                        index += 2
                    elif not raw and text.startswith("${", index):
                        index += 2
                        yield from code(True)
                        yield "<string>", line
                    else:
                        line += text[index] == "\n"
                        index += 1
                if index >= len(text):
                    raise ValueError("Unterminated Dart string")
                index += len(delimiter)
            elif text[index].isspace():
                line += text[index] == "\n"
                index += 1
            else:
                token = re.match(r"[A-Za-z_$][A-Za-z0-9_$]*", text[index:])
                if token:
                    yield token.group(), line
                    index += len(token.group())
                else:
                    char = text[index]
                    braces += (char == "{") - (char == "}")
                    yield char, line
                    index += 1
        if interpolation:
            raise ValueError("Unterminated Dart string interpolation")

    yield from code()


def source_audit(media_kit: Path) -> dict:
    bindings = lf_text(media_kit / BINDINGS_PATH)
    declared = re.findall(r"\bconst int MPV_CLIENT_API_VERSION\s*=\s*(\d+)\s*;", bindings)
    if len(declared) != 1:
        raise ValueError("Review changed Dart binding API declaration")
    # These literal names belong to ffigen's DynamicLibrary lookup calls. The
    # generated file is hash-gated below, rather than accepted as arbitrary code.
    available = set(re.findall(r"['\"](mpv_[a-z0-9_]+)['\"]", bindings))
    references, scanned = [], []
    for directory in ("media_kit/lib", "media_kit_video/lib"):
        for path in sorted((media_kit / directory).rglob("*.dart")):
            relative = path.relative_to(media_kit).as_posix()
            if "generated" in path.relative_to(media_kit).parts or path.name.endswith((".g.dart", ".freezed.dart")):
                continue
            content = lf_text(path)
            if "AUTO GENERATED FILE" in content[:1000] or "GENERATED CODE - DO NOT MODIFY" in content[:1000]:
                continue
            fingerprint = digest(content.encode())
            scanned.append({"path": relative, "lf_sha256": fingerprint})
            found, previous = {}, None
            for token, line in dart_tokens(content):
                if previous == "." and token in available:
                    found.setdefault(token, []).append(line)
                previous = token
            if found:
                references.append({"path": relative, "lf_sha256": fingerprint, "references": found})
    used = sorted({name for source in references for name in source["references"]})
    if not scanned or not used:
        raise ValueError("No non-generated SDK public libmpv references found; review extraction")
    return {
        "bindings": {"path": BINDINGS_PATH, "lf_sha256": digest(bindings.encode()),
                     "declared_api": version(int(declared[0])), "lookup_symbols": sorted(available)},
        "method": "Dart member references outside comments/literal strings, including interpolation and tear-offs; intersect reviewed generated lookup names",
        "scanned_files": scanned, "reference_sources": references,
        "required_symbols": used, "unused_generated_symbols": sorted(available - set(used)),
        "reviewed_removed_symbols_referenced": sorted(REMOVED_BINDINGS & set(used)),
    }


def verify_source_profile(audit: dict) -> None:
    bindings = audit["bindings"]
    if (bindings["lf_sha256"] != REVIEWED_PROFILE["bindings_lf_sha256"]
            or bindings["declared_api"]["value"] != REVIEWED_PROFILE["bindings_declared_api"]):
        raise ValueError("Generated bindings changed; explicitly review and update REVIEWED_PROFILE")
    if audit["reviewed_removed_symbols_referenced"]:
        raise ValueError("The adapter references removed libmpv bindings; an adapter review is required")


def native_worker(request: dict, output: Path) -> int:
    result = {"stage": "load", "load": False, "api_compatible": False,
              "required_symbols_present": False, "created": False, "destroyed": False,
              "playback": False, "device": False}
    write_json(output, result)
    try:
        with ExitStack() as directories:
            if sys.platform == "win32":
                for directory in request["dll_directories"]:
                    directories.enter_context(os.add_dll_directory(directory))
                library = ctypes.CDLL(request["runtime"])
            else:
                library = ctypes.CDLL(request["runtime"], mode=os.RTLD_NOW | os.RTLD_LOCAL)
            result.update(load=True, stage="client-api-version")
            write_json(output, result)
            api = library.mpv_client_api_version
            api.argtypes, api.restype = [], ctypes.c_ulong
            actual = api()
            result["runtime_api"] = version(actual)
            check_versions(request["header_api"], actual)
            result.update(api_compatible=True, stage="public-symbols")
            result["missing_symbols"] = [name for name in request["required_symbols"] if not hasattr(library, name)]
            result["optional_symbols"] = {OPTIONAL_BATCH: hasattr(library, OPTIONAL_BATCH)}
            write_json(output, result)
            if result["missing_symbols"]:
                raise ValueError("Missing required public libmpv symbols: " + ", ".join(result["missing_symbols"]))
            result.update(required_symbols_present=True, stage="mpv-create")
            write_json(output, result)
            create = library.mpv_create
            create.argtypes, create.restype = [], ctypes.c_void_p
            destroy = library.mpv_terminate_destroy
            destroy.argtypes, destroy.restype = [ctypes.c_void_p], None
            handle = create()
            if not handle:
                raise ValueError("mpv_create returned NULL")
            result.update(created=True, stage="mpv-terminate-destroy")
            try:
                write_json(output, result)
            finally:
                destroy(handle)
            result.update(destroyed=True, stage="complete")
        write_json(output, result)
        return 0
    except Exception as error:
        result["error"] = str(error)
        write_json(output, result)
        return 1


def check(args, report: dict) -> None:
    native_system = "windows" if sys.platform == "win32" else "linux" if sys.platform.startswith("linux") else None
    machine = platform.machine().lower()
    if args.platform != native_system or machine not in {"amd64", "x86_64"} or ctypes.sizeof(ctypes.c_void_p) != 8:
        raise ValueError("This reviewed profile only loads native Linux/Windows x86_64 packages on their matching 64-bit host")
    media_kit = args.media_kit.resolve(strict=True)
    report["stage"] = "package-verification"
    command = [sys.executable, str(media_kit / "tool/native_package/package.py"), "consume",
               "--platform", args.platform, "--architecture", "x86_64"]
    consumed = subprocess.run(command, capture_output=True, text=True, timeout=120)
    if consumed.returncode:
        raise ValueError("Shared package consumer rejected input: " + (consumed.stderr or consumed.stdout).strip())
    package = json.loads(consumed.stdout)
    report["package"] = package
    report["stage"] = "source-review"
    report["source_audit"] = source_audit(media_kit)
    verify_source_profile(report["source_audit"])
    header = Path(package["layout"]["include"]) / "mpv/client.h"
    declaration = re.findall(r"^\s*#\s*define\s+MPV_CLIENT_API_VERSION\s+MPV_MAKE_VERSION\(\s*(\d+)\s*,\s*(\d+)\s*\)", lf_text(header), re.M)
    if len(declaration) != 1:
        raise ValueError("Review changed client.h API version macro before loading native code")
    major, minor = map(int, declaration[0])
    if not (0 <= major < 65536 and 0 <= minor < 65536):
        raise ValueError("Invalid client.h API version fields")
    report["header"] = {"path": str(header), "sha256": digest(header.read_bytes()), "api": version((major << 16) | minor)}
    report["stage"] = "native-process"
    request = {"runtime": package["layout"]["runtime"], "header_api": report["header"]["api"]["value"],
               "required_symbols": sorted(PROBE_SYMBOLS | set(report["source_audit"]["required_symbols"])),
               "dll_directories": sorted({str(Path(path).parent) for path in [package["layout"]["runtime"], *package["layout"].get("bundle", [])]})}
    report["probe_required_symbols"] = request["required_symbols"]
    with tempfile.TemporaryDirectory(prefix="piliplus-native-api-") as temporary:
        request_file, result_file = Path(temporary) / "request.json", Path(temporary) / "result.json"
        write_json(request_file, request)
        try:
            native = subprocess.run([sys.executable, str(Path(__file__).resolve()), "--_worker", str(request_file), str(result_file)],
                                    capture_output=True, text=True, errors="replace", timeout=30)
            report["native_process"] = {"returncode": native.returncode, "returncode_hex": f"0x{native.returncode & 0xFFFFFFFF:08x}",
                                        "stdout": native.stdout, "stderr": native.stderr}
        except subprocess.TimeoutExpired:
            report["native_process"] = {"timeout_seconds": 30}
            if result_file.is_file():
                report["native_probe"] = json.loads(result_file.read_text())
            raise ValueError("Native load/create/destroy probe timed out")
        if result_file.is_file():
            report["native_probe"] = json.loads(result_file.read_text())
        if native.returncode or report.get("native_probe", {}).get("stage") != "complete":
            raise ValueError("Native probe failed; inspect native_process and its last completed stage")
    report.update(status="passed", stage="complete")


def main() -> int:
    if sys.argv[1:2] == ["--_worker"]:
        return native_worker(json.loads(Path(sys.argv[2]).read_text()), Path(sys.argv[3]))
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", choices=("linux", "windows"), required=True)
    parser.add_argument("--media-kit", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    # A report must never modify the authenticated payload, including failures.
    package_root = os.environ.get("MEDIA_KIT_NATIVE_PACKAGE_ROOT")
    if package_root:
        root = Path(package_root).resolve()
        if output == root or root in output.parents:
            parser.error("--output must be outside the authenticated native package")
    report = {"schema": 1, "kind": "piliplus-native-api-check", "platform": args.platform,
              "host": {"system": sys.platform, "machine": platform.machine(), "python": platform.python_version()},
              "reviewed_profile": REVIEWED_PROFILE, "status": "failed", "stage": "host-validation",
              "scope": "Current reviewed Dart client subset, native load, API version, and create/destroy; not the complete generated FFI ABI or options/properties/rendering semantics",
              "playback": False, "device": False}
    try:
        check(args, report)
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        report["error"] = str(error)
    write_json(output, report)
    print(json.dumps({"status": report["status"], "report": str(output), "stage": report["stage"]}))
    return 0 if report["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
