#!/usr/bin/env python3
"""Prepare an isolated, pinned official Flutter OHOS SDK for PiliPlus.

The development checkout and its original SDK patches are read-only inputs.
Only the explicitly selected SDK and package cache are written. A temporary
Git index validates the entire patch series before changing SDK source files.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import signal
import subprocess
import sys
import tempfile


COMPAT_ROOT = Path(__file__).resolve().with_name("sdk_compat")
MANIFEST_PATH = COMPAT_ROOT / "manifest.json"
RECEIPT_PATH = Path("bin/cache/piliplus-ohos-sdk.json")


class PreparationError(RuntimeError):
    pass


def sha256(body: bytes) -> str:
    return hashlib.sha256(body).hexdigest()


def run(args: list[str], *, cwd: Path | None = None,
        env: dict[str, str] | None = None, body: bytes | None = None,
        timeout: int = 180) -> bytes:
    process = subprocess.Popen(
        args, cwd=cwd, env=env, stdin=subprocess.PIPE if body is not None else subprocess.DEVNULL,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, start_new_session=os.name != "nt",
    )
    try:
        stdout, stderr = process.communicate(body, timeout=timeout)
    except subprocess.TimeoutExpired:
        if os.name == "nt":
            process.kill()
        else:
            os.killpg(process.pid, signal.SIGKILL)
        process.communicate()
        raise PreparationError(f"Command timed out after {timeout}s: {' '.join(args)}") from None
    if process.returncode:
        diagnostic = (stderr + b"\n" + stdout).decode("utf-8", errors="replace").strip()
        raise PreparationError(f"Command failed ({process.returncode}): {' '.join(args)}\n{diagnostic[-10000:]}")
    return stdout + (stderr if not stdout else b"")


def git(sdk: Path, *args: str, env: dict[str, str] | None = None,
        body: bytes | None = None, timeout: int = 180) -> bytes:
    return run(["git", "-C", str(sdk), *args], env=env, body=body, timeout=timeout)


def source_path(root: Path, relative: str) -> Path:
    parts = PurePosixPath(relative)
    if parts.is_absolute() or not parts.parts or ".." in parts.parts:
        raise PreparationError(f"Invalid manifest path: {relative}")
    target = root
    for part in parts.parts:
        target /= part
        if target.is_symlink():
            raise PreparationError(f"Refusing symlink in SDK preparation input: {target}")
    if not target.is_file():
        raise PreparationError(f"Missing preparation input: {target}")
    return target


def check_hash(path: Path, expected: str) -> None:
    if sha256(path.read_bytes()) != expected:
        raise PreparationError(f"Source changed and requires a compatibility review: {path}")


def patch_inputs(workspace: Path, manifest: dict) -> list[Path]:
    driver = source_path(workspace, manifest["upstream_patch_driver"])
    check_hash(driver, manifest["upstream_patch_driver_sha256"])
    patches = []
    for entry in manifest["patches"]:
        original = source_path(workspace, entry["upstream"])
        check_hash(original, entry["upstream_sha256"])
        if "adapted" in entry:
            adapted = source_path(COMPAT_ROOT, entry["adapted"])
            check_hash(adapted, entry["adapted_sha256"])
            patches.append(adapted)
        else:
            patches.append(original)
    return patches


def fetch_history(sdk: Path, manifest: dict) -> None:
    # Both the version tag and its ancestry come from the selected official
    # repository. Never manufacture tags or a flutter.version.json value.
    tag = manifest["official_tag"]
    git(sdk, "fetch", "--no-tags", "--depth", "500", "origin", manifest["commit"],
        f"refs/tags/{tag}:refs/tags/{tag}", timeout=1200)


def create_sdk(sdk: Path, manifest: dict) -> None:
    sdk.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=f".{sdk.name}-clone-", dir=sdk.parent) as directory:
        staged = Path(directory) / "sdk"
        run(["git", "init", "--quiet", str(staged)])
        git(staged, "config", "core.autocrlf", "false")
        git(staged, "remote", "add", "origin", manifest["repository"])
        fetch_history(staged, manifest)
        git(staged, "checkout", "--detach", manifest["commit"])
        if sdk.exists():
            raise PreparationError(f"SDK destination appeared during checkout; refusing to replace it: {sdk}")
        staged.rename(sdk)


def validate_sdk(sdk: Path, manifest: dict, *, allow_fetch: bool) -> None:
    if Path(git(sdk, "rev-parse", "--show-toplevel").decode().strip()).resolve() != sdk:
        raise PreparationError("--flutter-root must name the SDK repository root")
    if git(sdk, "remote", "get-url", "origin").decode().strip().rstrip("/") != manifest["repository"]:
        raise PreparationError(f"SDK origin must be {manifest['repository']}")
    if git(sdk, "rev-parse", "HEAD").decode().strip() != manifest["commit"]:
        raise PreparationError(f"SDK HEAD must be the reviewed official commit {manifest['commit']}")
    engine = source_path(sdk, "bin/internal/engine.ohos.version").read_text().strip()
    if engine != manifest["ohos_engine_revision"]:
        raise PreparationError("OHOS engine pin changed")
    if source_path(sdk, "bin/internal/engine.version").read_text().strip() != manifest["host_engine_revision"]:
        raise PreparationError("Host engine pin changed")
    tag_ref = f"refs/tags/{manifest['official_tag']}^{{commit}}"
    try:
        tag_commit = git(sdk, "rev-parse", "--verify", tag_ref).decode().strip()
    except PreparationError:
        if not allow_fetch:
            raise
        fetch_history(sdk, manifest)
        tag_commit = git(sdk, "rev-parse", "--verify", tag_ref).decode().strip()
    if tag_commit != manifest["official_tag_commit"]:
        raise PreparationError("The official version tag does not match its reviewed commit")
    try:
        git(sdk, "merge-base", "--is-ancestor", tag_commit, manifest["commit"])
    except PreparationError:
        if not allow_fetch:
            raise
        fetch_history(sdk, manifest)
        git(sdk, "merge-base", "--is-ancestor", tag_commit, manifest["commit"])


def validate_source_state(sdk: Path, manifest: dict) -> str:
    if git(sdk, "diff", "--cached", "--name-only"):
        raise PreparationError("SDK contains staged changes; use a separate clean SDK checkout")
    if git(sdk, "ls-files", "--others", "--exclude-standard"):
        raise PreparationError("SDK contains untracked source files; use a separate clean SDK checkout")
    changed = set(filter(None, git(sdk, "diff", "--name-only", "-z").decode().split("\0")))
    if changed and changed != set(manifest["files"]):
        raise PreparationError("SDK changes do not match the reviewed patch series; no files were overwritten")
    state = "after" if changed else "before"
    for relative, hashes in manifest["files"].items():
        check_hash(source_path(sdk, relative), hashes[f"{state}_sha256"])
    return state


def apply_series(sdk: Path, manifest: dict, patches: list[Path]) -> None:
    with tempfile.TemporaryDirectory(prefix="piliplus-sdk-index-") as directory:
        env = dict(os.environ, GIT_INDEX_FILE=str(Path(directory) / "index"))
        git(sdk, "read-tree", manifest["commit"], env=env)
        for index, patch in enumerate(patches, 1):
            git(sdk, "apply", "--cached", "--check", str(patch), env=env)
            git(sdk, "apply", "--cached", str(patch), env=env)
            print(f"SDK patch {index}/{len(patches)}: {patch.name}", flush=True)
        changed = set(filter(None, git(sdk, "diff", "--cached", "--name-only", "-z", env=env).decode().split("\0")))
        if changed != set(manifest["files"]):
            raise PreparationError("Patch output paths differ from the compatibility manifest")
        for relative, hashes in manifest["files"].items():
            if sha256(git(sdk, "show", f":{relative}", env=env)) != hashes["after_sha256"]:
                raise PreparationError(f"Patch output differs from the reviewed result: {relative}")
        combined = git(sdk, "diff", "--cached", "--binary", "--full-index", manifest["commit"], env=env)
        # git apply checks all files before writing; the real index is untouched.
        git(sdk, "apply", "--check", "-", body=combined)
        git(sdk, "apply", "-", body=combined)
    if validate_source_state(sdk, manifest) != "after":
        raise PreparationError("SDK patches were not applied")


def versions(sdk: Path, pub_cache: Path, manifest: dict, *, refresh: bool = False) -> dict:
    env = dict(os.environ, CI="true", FLUTTER_SUPPRESS_ANALYTICS="true", PUB_CACHE=str(pub_cache))
    if refresh:
        # A SDK bootstrapped before its genuine tag was fetched can cache
        # 0.0.0-unknown. Let Flutter regenerate this one derived file from Git.
        (sdk / "bin/cache/flutter.version.json").unlink(missing_ok=True)
    flutter = sdk / "bin" / ("flutter.bat" if os.name == "nt" else "flutter")
    # On a completely fresh checkout the launcher emits bootstrap/download
    # progress before the requested output, even with --machine. Finish that
    # first invocation before reading the structured version response.
    run([str(flutter), "--version"], cwd=sdk, env=env, timeout=1200)
    output = run([str(flutter), "--version", "--machine"], cwd=sdk, env=env, timeout=1200)
    try:
        actual = json.loads(output)
    except ValueError:
        raise PreparationError(f"Flutter did not return version JSON:\n{output.decode(errors='replace')[-3000:]}") from None
    if (actual.get("frameworkVersion", "").split("+", 1)[0] != manifest["flutter_version"]
            or actual.get("frameworkRevision") != manifest["commit"]
            or actual.get("engineRevision") != manifest["host_engine_revision"]
            # Flutter derives this field from @{upstream}, which does not
            # exist on our detached, pinned checkout. validate_sdk separately
            # verifies the real Git origin and HEAD before reaching this point.
            or actual.get("repositoryUrl", "").rstrip("/") not in (
                manifest["repository"], "unknown source",
            )
            or actual.get("dartSdkVersion", "").split(" ", 1)[0] != manifest["dart_version"]):
        raise PreparationError(f"Actual SDK versions do not match the official pin: {json.dumps(actual)}")
    if source_path(sdk, "bin/cache/engine.ohos.stamp").read_text().strip() != manifest["ohos_engine_revision"]:
        raise PreparationError("Actual OHOS engine stamp does not match the official pin")
    dart = sdk / "bin/cache/dart-sdk/bin" / ("dart.exe" if os.name == "nt" else "dart")
    direct = run([str(dart), "--version"], cwd=sdk, env=env).decode().strip()
    if not re.search(rf"\bDart SDK version: {re.escape(manifest['dart_version'])}(?:\s|$)", direct):
        raise PreparationError(f"Actual Dart executable does not match the SDK pin: {direct}")
    return {"flutter": actual, "dart_executable": direct}


def prepare(sdk: Path, pub_cache: Path, workspace: Path, *, check: bool = False) -> dict:
    manifest_bytes = MANIFEST_PATH.read_bytes()
    manifest = json.loads(manifest_bytes)
    manifest_hash = sha256(manifest_bytes)
    if manifest.get("schema") != 1:
        raise PreparationError("Unsupported SDK compatibility manifest")
    if sdk == workspace or workspace in sdk.parents or sdk in workspace.parents:
        raise PreparationError("Use an isolated Flutter SDK outside the app checkout")
    if pub_cache == workspace or workspace in pub_cache.parents or pub_cache in workspace.parents:
        raise PreparationError("Use an isolated package cache outside the app checkout")
    if pub_cache == sdk or sdk in pub_cache.parents or pub_cache in sdk.parents:
        raise PreparationError("Use distinct, non-nested SDK and package cache directories")
    patches = patch_inputs(workspace, manifest)
    if not sdk.exists():
        if check:
            raise PreparationError(f"SDK does not exist: {sdk}")
        print(f"Checking out official {manifest['branch']} at {manifest['commit']}", flush=True)
        create_sdk(sdk, manifest)
    validate_sdk(sdk, manifest, allow_fetch=not check)
    state = validate_source_state(sdk, manifest)
    receipt_path = sdk / RECEIPT_PATH
    if check:
        if state != "after" or not receipt_path.is_file():
            raise PreparationError("SDK has not completed prepare_sdk.py")
        receipt = json.loads(receipt_path.read_text())
        if receipt.get("manifest_sha256") != manifest_hash:
            raise PreparationError("SDK preparation receipt is stale; review the manifest and prepare again")
    elif state == "before":
        apply_series(sdk, manifest, patches)
    pub_cache.mkdir(parents=True, exist_ok=True)
    actual = versions(sdk, pub_cache, manifest, refresh=not check)
    # Runtime bootstrap is allowed to populate caches, never tracked SDK source.
    if validate_source_state(sdk, manifest) != "after":
        raise PreparationError("SDK source changed during bootstrap")
    receipt = {
        "schema": 1, "prepared_at_utc": datetime.now(timezone.utc).isoformat(),
        "manifest_sha256": manifest_hash, "repository": manifest["repository"],
        "branch": manifest["branch"], "commit": manifest["commit"],
        "flutter_root": str(sdk), "pub_cache": str(pub_cache),
        "host_engine_revision": manifest["host_engine_revision"],
        "ohos_engine_revision": manifest["ohos_engine_revision"],
        "patches": manifest["patches"], "files": manifest["files"],
        "actual_versions": actual,
        "validation_scope": "Official host SDK boots; reviewed PiliPlus SDK patches match. HAP/device validation is separate.",
    }
    if not check:
        receipt_path.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=receipt_path.parent,
                                         prefix="piliplus-ohos-sdk-", suffix=".json", delete=False) as output:
            output.write(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n")
            temporary_receipt = Path(output.name)
        temporary_receipt.replace(receipt_path)
    print(f"SDK {'verified' if check else 'prepared'}: {sdk}\n"
          f"Flutter {actual['flutter']['frameworkVersion']}; Dart {manifest['dart_version']}\n"
          f"PUB_CACHE={pub_cache}\nReceipt: {receipt_path}", flush=True)
    return receipt


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--flutter-root", "--sdk-root", type=Path, required=True,
                        help="Dedicated official Flutter OHOS checkout; created when absent")
    parser.add_argument("--pub-cache", type=Path, required=True, help="Dedicated pub cache outside the app and SDK")
    parser.add_argument("--workspace", type=Path, default=Path(__file__).resolve().parents[2],
                        help="PiliPlus checkout containing the unchanged original SDK patches")
    parser.add_argument("--check", action="store_true", help="Verify an already prepared SDK; do not apply patches or fetch Git history")
    args = parser.parse_args()
    try:
        prepare(args.flutter_root.expanduser().resolve(), args.pub_cache.expanduser().resolve(),
                args.workspace.expanduser().resolve(), check=args.check)
    except (PreparationError, OSError, ValueError, KeyError) as error:
        print(f"SDK preparation failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
