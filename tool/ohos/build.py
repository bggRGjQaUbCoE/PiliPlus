#!/usr/bin/env python3
"""Resolve, analyze and build the full PiliPlus entrypoint in an OHOS export."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time
import zipfile

import build_profile


def digest(path: Path) -> str:
    with path.open("rb") as source:
        return hashlib.file_digest(source, "sha256").hexdigest()


def inspect_hap(path: Path, expected_app: dict) -> dict:
    """Check the produced package, without claiming signing or device acceptance."""
    libraries = []
    with zipfile.ZipFile(path) as archive:
        if archive.testzip() is not None:
            raise RuntimeError("HAP archive CRC verification failed")
        module = json.loads(archive.read("module.json"))
        actual_app = module["app"]
        for field in ("bundleName", "versionName", "versionCode"):
            if actual_app.get(field) != expected_app.get(field):
                raise RuntimeError(f"HAP app.{field} does not match the prepared source")
        for member in ("libs/arm64-v8a/libapp.so", "libs/arm64-v8a/libflutter.so"):
            contents = archive.read(member)
            if contents[:6] != b"\x7fELF\x02\x01" or int.from_bytes(contents[18:20], "little") != 183:
                raise RuntimeError(f"Expected an AArch64 ELF library: {member}")
            libraries.append({"member": member, "bytes": len(contents),
                              "sha256": hashlib.sha256(contents).hexdigest()})
        other_abis = [name for name in archive.namelist()
                      if name.startswith("libs/") and name.endswith(".so")
                      and not name.startswith("libs/arm64-v8a/")]
        if other_abis:
            raise RuntimeError(f"Unexpected native ABI members: {other_abis}")
    return {"path": str(path), "sha256": digest(path), "bytes": path.stat().st_size,
            "application": {key: actual_app[key] for key in ("bundleName", "versionName", "versionCode")},
            "libraries": libraries, "signed": False, "device_verified": False}


def build(workspace: Path, flutter_root: Path, pub_cache: Path) -> dict:
    workspace, flutter_root, pub_cache = workspace.resolve(), flutter_root.resolve(), pub_cache.resolve()
    source = build_profile.validate_workspace(workspace)
    if Path(__file__).resolve() != build_profile.safe_path(workspace, "tool/ohos/build.py"):
        raise RuntimeError("Run tool/ohos/build.py from the exported workspace so its committed rules are used")
    if source.get("stage") != "ohos-build-copy-prepared":
        raise RuntimeError("Run prepare-build on a fresh committed source export first")
    if pub_cache == workspace or workspace in pub_cache.parents or pub_cache in workspace.parents:
        raise RuntimeError("Use a dedicated Pub cache outside the application build copy")
    flutter = flutter_root / "bin/flutter"
    if not flutter.is_file():
        raise RuntimeError(f"Flutter executable is missing: {flutter}")
    expected_app = json.loads(build_profile.safe_path(workspace, "ohos/AppScope/app.json5").read_text())["app"]
    build_profile.safe_path(workspace, "ohos/build-defines.json")
    log_root = workspace / "ohos/build-logs"
    if log_root.is_symlink():
        raise RuntimeError("Build log directory must not be a symlink")
    log_root.mkdir(exist_ok=True)
    receipt_path = workspace / "ohos/build-result.json"
    if receipt_path.is_symlink():
        raise RuntimeError("Build receipt must not be a symlink")
    environment = {**os.environ, "PUB_CACHE": str(pub_cache), "CI": "true"}
    receipt = {
        "schema": 1, "source_commit": source["source_commit"],
        "base_commit": source["base_commit"], "application_entrypoint": "lib/main.dart",
        "media_backend": "deferred-by-request", "started_at_unix": int(time.time()),
        "dependency_resolution_verified": False, "analysis_passed": False,
        "parser_compatibility_verified": False,
        "ui_compatibility_verified": False,
        "hap_built": False, "device_functionality_verified": False, "commands": [],
        "status": "running",
    }

    def save() -> None:
        receipt_path.write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    def execute(label: str, command: list[str]) -> None:
        log = log_root / f"{label}.log"
        if log.is_symlink():
            raise RuntimeError(f"Build log must not be a symlink: {log}")
        print(f"OHOS: {label}; log: {log}", flush=True)
        with log.open("w", encoding="utf-8") as output:
            result = subprocess.run(command, cwd=workspace, env=environment, stdout=output,
                                    stderr=subprocess.STDOUT, check=False)
        receipt["commands"].append({"stage": label, "argv": command,
                                    "exit_code": result.returncode, "log": str(log), "log_sha256": digest(log)})
        save()
        if result.returncode:
            # Display the useful tail while retaining the complete diagnostics.
            lines = log.read_text(encoding="utf-8", errors="replace").splitlines()
            print("\n".join(lines[-80:]), file=sys.stderr)
            raise RuntimeError(f"{label} failed with exit code {result.returncode}; see {log}")

    save()
    try:
        build_profile.update_manifest(workspace, dependency_resolution_verified=False,
                                      analysis_passed=False, hap_built=False)
        scripts = workspace / "tool/ohos"
        execute("sdk-check", [sys.executable, str(scripts / "prepare_sdk.py"),
                "--flutter-root", str(flutter_root), "--pub-cache", str(pub_cache),
                "--workspace", str(workspace), "--check"])
        execute("pub-get", [str(flutter), "pub", "get"])
        dependencies = build_profile.load_helper("dependencies").patch(workspace, pub_cache)
        receipt["dependency_resolution_verified"] = True
        receipt["dependencies"] = dependencies
        receipt["pubspec_lock_sha256"] = digest(workspace / "pubspec.lock")
        build_profile.update_manifest(workspace, dependency_resolution_verified=True, dependencies=dependencies,
                                      hap_built=False)
        probe = build_profile.safe_path(workspace, "tool/ohos/package_patches/validation/petitparser_312.dart")
        execute("parser-compatibility", [str(flutter_root / "bin/cache/dart-sdk/bin/dart"),
                f"--packages={workspace / '.dart_tool/package_config.json'}", str(probe)])
        receipt["parser_compatibility_verified"] = True
        ui_probe = build_profile.safe_path(workspace, "tool/ohos/package_patches/validation/ui_packages_test.dart")
        execute("ui-compatibility", [str(flutter), "test", "--no-pub", "--reporter", "expanded", str(ui_probe)])
        receipt["ui_compatibility_verified"] = True
        execute("analyze", [str(flutter), "analyze", "lib", "--no-pub", "--no-fatal-infos", "--no-fatal-warnings"])
        receipt["analysis_passed"] = True
        build_profile.update_manifest(workspace, analysis_passed=True)
        execute("hap", [str(flutter), "build", "hap", "--release", "--no-codesign", "--no-pub",
                "--target", "lib/main.dart", "--dart-define-from-file=ohos/build-defines.json"])
        artifact = workspace / "build/ohos/hap/entry-default-unsigned.hap"
        receipt["artifact"] = inspect_hap(artifact, expected_app)
        receipt["hap_built"] = True
        receipt["status"] = "built-unsigned-media-deferred"
        build_profile.update_manifest(workspace, analysis_passed=True, hap_built=True,
                                      artifact=receipt["artifact"], device_functionality_verified=False)
    except Exception as exc:
        receipt["status"] = "failed"
        receipt["failure"] = str(exc)
        raise
    finally:
        receipt["finished_at_unix"] = int(time.time())
        save()
    return receipt


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, required=True)
    parser.add_argument("--flutter-root", type=Path, required=True)
    parser.add_argument("--pub-cache", type=Path, required=True)
    args = parser.parse_args()
    try:
        result = build(args.workspace, args.flutter_root, args.pub_cache)
        print(json.dumps({key: result[key] for key in ("status", "source_commit", "artifact")},
                         ensure_ascii=False, indent=2))
        return 0
    except (OSError, ValueError, RuntimeError, KeyError, zipfile.BadZipFile) as exc:
        print(f"OHOS: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
