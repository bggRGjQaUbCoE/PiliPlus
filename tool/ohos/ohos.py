#!/usr/bin/env python3
"""Inspect and export the OHOS development branch without rewriting upstream.

Only the Python standard library and Git are needed.  This is source preparation,
not a substitute for dependency resolution, an HAP build, or device acceptance.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile


DEFAULT_ROOT = Path(__file__).resolve().parents[2]
INITIAL_BASE = "849c56b035ac8acf1b4fd677c2c94debe161da8e"


class CheckError(RuntimeError):
    pass


def run(command: list[str], cwd: Path, *, timeout: int = 30) -> bytes:
    try:
        result = subprocess.run(
            command, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            check=False, timeout=timeout,
        )
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise CheckError(f"Could not run {command[0]}: {exc}") from exc
    if result.returncode:
        detail = result.stderr.decode("utf-8", errors="replace").strip()
        if not detail:
            detail = result.stdout.decode("utf-8", errors="replace").strip()
        raise CheckError(f"{' '.join(command)} failed: {detail}")
    return result.stdout


def git(root: Path, *args: str) -> bytes:
    return run(["git", "-C", str(root), *args], root)


def commit(root: Path, ref: str) -> str:
    return git(root, "rev-parse", "--verify", "--end-of-options", f"{ref}^{{commit}}").decode().strip()


def select_base(root: Path, revision: str, base_ref: str | None) -> str:
    if base_ref is not None:
        base = commit(root, base_ref)
        git(root, "merge-base", "--is-ancestor", base, revision)
        return base
    try:
        upstream = commit(root, "origin/main")
    except CheckError:
        upstream = commit(root, INITIAL_BASE)
    # A freshly fetched main may be ahead. Compare with the upstream commit
    # actually incorporated into this branch, not with unmerged upstream work.
    return git(root, "merge-base", revision, upstream).decode().strip()


def tree(root: Path, revision: str) -> dict[str, tuple[str, str, str]]:
    entries = {}
    for record in git(root, "ls-tree", "-rz", revision).split(b"\0"):
        if not record:
            continue
        metadata, raw_path = record.split(b"\t", 1)
        mode, kind, sha = metadata.decode().split()
        path = raw_path.decode("utf-8")
        entries[path] = (mode, kind, sha)
    return entries


def compare_trees(root: Path, base: str, revision: str) -> dict:
    before, after = tree(root, base), tree(root, revision)
    changes = [path for path, value in before.items() if after.get(path) != value]
    additions = sorted(set(after) - set(before))
    return {
        "base_commit": base,
        "source_commit": revision,
        "original_files": len(before),
        "original_file_changes": sorted(changes),
        "added_files": additions,
    }


def check_source(root: Path, base_ref: str | None, revision_ref: str = "HEAD", *, worktree: bool = True) -> dict:
    revision = commit(root, revision_ref)
    base = select_base(root, revision, base_ref)
    result = compare_trees(root, base, revision)
    if worktree:
        # Compare the actual working files as well as the committed snapshot.
        # --no-renames reports old paths even if an original file was renamed.
        changed = git(root, "diff", "--name-only", "--no-renames", "-z", base, "--").split(b"\0")
        # A restored working file can hide a different staged version. Inspect
        # the index separately so the next commit cannot bypass this check.
        changed += git(root, "diff", "--cached", "--name-only", "--no-renames", "-z", base, "--").split(b"\0")
        original = tree(root, base)
        result["original_file_changes"] = sorted(
            set(result["original_file_changes"]) |
            {path.decode() for path in changed if path and path.decode() in original}
        )
    result["status"] = "pass" if not result["original_file_changes"] else "fail"
    return result


def require_originals_unchanged(report: dict) -> None:
    if report["original_file_changes"]:
        raise CheckError(
            "Original upstream files changed; this scaffold currently permits additions only:\n  "
            + "\n  ".join(report["original_file_changes"])
            + "\nReview each required adaptation before extending this contract."
        )


def read_pubspec(root: Path) -> dict[str, str]:
    text = (root / "pubspec.yaml").read_text(encoding="utf-8")
    environment = re.search(r"^environment:\s*\n((?:[ \t]+.*\n|\s*\n)*)", text, re.M)
    if not environment:
        raise CheckError("pubspec.yaml has no readable environment section")
    values = {}
    for key in ("sdk", "flutter"):
        match = re.search(rf"^  {key}:\s*([^#\n]+)", environment.group(1), re.M)
        if not match:
            raise CheckError(f"pubspec.yaml has no environment.{key}")
        values[key] = match.group(1).strip().strip("\"'")
    name = re.search(r"^name:\s*([^#\n]+)", text, re.M)
    version = re.search(r"^version:\s*([^#\n]+)", text, re.M)
    if not name or not version:
        raise CheckError("pubspec.yaml must contain name and version")
    values["name"] = name.group(1).strip().strip("\"'")
    values["version"] = version.group(1).strip().strip("\"'")
    return values


def version_tuple(value: str) -> tuple[int, int, int]:
    match = re.fullmatch(r"(\d+)\.(\d+)\.(\d+)(?:\+[A-Za-z0-9.-]+)?", value)
    if not match:
        raise CheckError(f"Expected a stable semantic version, got {value!r}")
    return tuple(map(int, match.group(1, 2, 3)))


def sdk_matches(required: dict[str, str], actual: dict) -> list[str]:
    errors = []
    try:
        expected_flutter = version_tuple(required["flutter"])
        actual_flutter = version_tuple(str(actual.get("frameworkVersion", "")))
        if actual_flutter != expected_flutter:
            errors.append(f"Flutter must match upstream {required['flutter']}; got {actual.get('frameworkVersion')}")
        dart_constraint = re.fullmatch(r">=\s*(\d+\.\d+\.\d+)(?:\s+<\s*(\d+\.\d+\.\d+))?", required["sdk"])
        if not dart_constraint:
            raise CheckError("Dart constraint syntax changed; review the OHOS preflight parser")
        actual_dart = version_tuple(str(actual.get("dartSdkVersion", "")).split(" ")[0])
        minimum = version_tuple(dart_constraint.group(1))
        maximum = version_tuple(dart_constraint.group(2)) if dart_constraint.group(2) else None
        if actual_dart < minimum or (maximum and actual_dart >= maximum):
            errors.append(f"Dart must satisfy upstream {required['sdk']}; got {actual.get('dartSdkVersion')}")
    except CheckError as exc:
        errors.append(str(exc))
    return errors


def doctor(root: Path, flutter: str | None) -> dict:
    required = read_pubspec(root)
    errors = []
    executable = shutil.which(flutter or "flutter")
    result = {"required_by_upstream": required, "flutter_executable": executable}
    if not executable:
        errors.append("Flutter executable not found. Supply --flutter /path/to/flutter-ohos/bin/flutter.")
    else:
        try:
            raw = run([executable, "--version", "--machine"], root, timeout=60)
            actual = json.loads(raw)
            if not isinstance(actual, dict):
                raise CheckError("flutter --version --machine did not return an object")
            result["actual_sdk"] = actual
            errors.extend(sdk_matches(required, actual))
            if not errors:
                run([executable, "build", "hap", "--help"], root, timeout=60)
                result["hap_command_available"] = True
        except (CheckError, ValueError) as exc:
            errors.append(str(exc))
    # Version/CLI checks alone cannot establish plugin API compatibility.
    # Keep the current known blockers explicit until supported by build evidence.
    errors.append("The current locked media-kit graph has no OHOS playback backend; its OHOS port is pending.")
    errors.append("cnativeapi 0.5.2 native-assets build hook has no OHOS target; dependency isolation/port is pending.")
    result["status"] = "blocked" if errors else "pass"
    result["blockers"] = errors
    result["reference"] = "docs/ohos/compatibility-audit.md"
    return result


def export_archive(root: Path, revision: str, output: Path) -> None:
    # Git exports committed files only, so local credentials, caches, generated
    # plugin registrants, and untracked files cannot enter the source snapshot.
    with tempfile.TemporaryFile() as archive_file:
        proc = subprocess.run(
            ["git", "-C", str(root), "archive", "--format=tar", revision],
            stdout=archive_file, stderr=subprocess.PIPE, check=False,
        )
        if proc.returncode:
            raise CheckError(proc.stderr.decode(errors="replace"))
        archive_file.seek(0)
        with tarfile.open(fileobj=archive_file, mode="r:") as archive:
            for member in archive.getmembers():
                path = PurePosixPath(member.name)
                if path.is_absolute() or ".." in path.parts or not (member.isdir() or member.isfile()):
                    raise CheckError(f"Unsupported archive entry: {member.name}")
            archive.extractall(output, filter="data")


def prepare(root: Path, output: Path, base_ref: str | None, revision_ref: str) -> dict:
    root, output = root.resolve(), output.resolve()
    if output == root or root in output.parents:
        raise CheckError("The output must be outside the source checkout")
    if output.exists():
        raise CheckError(f"The output already exists: {output}")
    report = check_source(root, base_ref, revision_ref, worktree=False)
    require_originals_unchanged(report)
    selected = tree(root, report["source_commit"])
    if "ohos/AppScope/app.json5" not in selected:
        raise CheckError("The selected commit does not contain the OHOS scaffold; commit the new files first")
    output.parent.mkdir(parents=True, exist_ok=True)
    # Build in a temporary sibling and publish only after verification.
    stage = Path(tempfile.mkdtemp(prefix=f".{output.name}-", dir=output.parent))
    try:
        export_archive(root, report["source_commit"], stage)
        original = tree(root, report["base_commit"])
        for path, (mode, kind, sha) in original.items():
            if kind != "blob" or mode not in ("100644", "100755"):
                raise CheckError(f"Unsupported original Git entry: {path} ({mode}, {kind})")
            body = (stage / path).read_bytes()
            blob_sha = hashlib.sha1(b"blob " + str(len(body)).encode() + b"\0" + body).hexdigest()
            if blob_sha != sha:
                raise CheckError(f"Snapshot changed an original file: {path}")
        spec = read_pubspec(stage)
        version = re.fullmatch(r"(\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?)(?:\+(\d+))?", spec["version"])
        if not version:
            raise CheckError(f"Review OHOS version mapping for {spec['version']!r}")
        profile_path = stage / "ohos/AppScope/app.json5"
        profile = json.loads(profile_path.read_text(encoding="utf-8"))
        profile["app"]["versionName"] = version.group(1)
        profile["app"]["versionCode"] = int(version.group(2) or "1")
        profile_path.write_text(json.dumps(profile, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        manifest = {
            "schema": 1,
            **report,
            "stage": "source-preparation-only",
            "application_entrypoint": "lib/main.dart",
            "application_source_transformations": [],
            "dependency_overrides_applied": False,
            "native_version": spec["version"],
            "hap_built": False,
        }
        (stage / "ohos/source-manifest.json").write_text(
            json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8",
        )
        # rename is atomic on the same filesystem; never replace existing output.
        if output.exists():
            raise CheckError(f"The output appeared while exporting: {output}")
        stage.rename(output)
        return {**manifest, "output": str(output)}
    finally:
        if stage.exists():
            shutil.rmtree(stage)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, default=DEFAULT_ROOT)
    sub = parser.add_subparsers(dest="command", required=True)
    check = sub.add_parser("check-source", help="reject changes to existing upstream files")
    check.add_argument("--base-ref", help="an incorporated upstream commit; default is merge-base with origin/main")
    diagnostic = sub.add_parser("doctor", help="check exact upstream SDK requirements and report known blockers")
    diagnostic.add_argument("--flutter", help="path to the OHOS Flutter executable")
    export = sub.add_parser("prepare", help="export a committed source snapshot without rewriting the app")
    export.add_argument("--output", type=Path, required=True)
    export.add_argument("--revision", default="HEAD")
    export.add_argument("--base-ref")
    args = parser.parse_args(argv)
    root = args.workspace.resolve()
    try:
        if args.command == "check-source":
            report = check_source(root, args.base_ref)
            code = 0 if report["status"] == "pass" else 1
        elif args.command == "doctor":
            report = doctor(root, args.flutter)
            code = 0 if report["status"] == "pass" else 2
        else:
            report = prepare(root, args.output, args.base_ref, args.revision)
            code = 0
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return code
    except (CheckError, OSError, ValueError) as exc:
        print(f"OHOS: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
