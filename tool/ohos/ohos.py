#!/usr/bin/env python3
"""Inspect and export the OHOS development branch without rewriting upstream.

Only the Python standard library and Git are needed.  This is source preparation,
not a substitute for dependency resolution, an HAP build, or device acceptance.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import time


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


def approved_source(root: Path, revision: str, base_ref: str | None, *, worktree: bool,
                    policy_manifest: str, policy_sha256: str | None) -> dict:
    rules = helper("source_policy")
    name = rules.relative(policy_manifest)
    if not name.startswith("tool/ohos/"):
        raise CheckError("Approved source policy must be committed under tool/ohos")
    # Read the selected commit, never an uncommitted replacement approval file.
    policy = rules.document(git(root, "show", f"{revision}:{name}"), policy_sha256)
    base = commit(root, policy["baseline_commit"])
    if base_ref is not None and commit(root, base_ref) != base:
        raise CheckError("--base-ref differs from the explicitly approved integration baseline")
    git(root, "merge-base", "--is-ancestor", base, revision)
    actual_tree = git(root, "rev-parse", f"{base}^{{tree}}").decode().strip()
    if actual_tree != policy["baseline_tree"]:
        raise CheckError("Approved integration baseline tree does not match its lock")
    before, after = tree(root, base), tree(root, revision)
    for path, expected in policy["integration"]["files"].items():
        entry = before.get(path)
        if entry is None or entry[:2] != ("100644", "blob"):
            raise CheckError(f"Approved integration file is not a regular baseline source: {path}")
        if rules.sha256(git(root, "cat-file", "blob", entry[2])) != expected:
            raise CheckError(f"Approved integration file hash differs from baseline: {path}")
    result = compare_trees(root, base, revision)
    changed = set(result["original_file_changes"]) | set(result["added_files"])
    result["approved_build_metadata_changes"] = sorted(
        path for path in changed if rules.permits_build_metadata(policy, path))
    # Validate hash-approved configuration from its committed Git blob, not a
    # mutable workspace file. Keep other App source changes disallowed.
    reviewed = []
    for path in result["original_file_changes"]:
        if path not in policy.get("reviewed_config_hashes", {}):
            continue
        previous, current = before.get(path), after.get(path)
        if (previous is not None and current is not None
                and previous[:2] == ("100644", "blob")
                and current[:2] == ("100644", "blob")
                and rules.permits_reviewed_config(
                    policy, path, git(root, "cat-file", "blob", current[2]))):
            reviewed.append(path)
    result["reviewed_config_changes"] = sorted(reviewed)
    result["original_file_changes"] = [
        path for path in result["original_file_changes"]
        if path not in reviewed and not rules.permits_build_metadata(policy, path)]
    result["unapproved_additions"] = [path for path in result["added_files"]
                                      if not rules.permits_build_metadata(policy, path)]
    result["worktree_changes"] = []
    if worktree:
        if commit(root, "HEAD") != revision:
            raise CheckError("Check out the selected approved revision before checking its worktree")
        changes = git(root, "diff", "--name-only", "--no-renames", "-z", revision, "--").split(b"\0")
        changes += git(root, "diff", "--cached", "--name-only", "--no-renames", "-z", revision, "--").split(b"\0")
        result["worktree_changes"] = sorted({path.decode() for path in changes if path})
    result["source_policy"] = {
        "mode": rules.MODE, "manifest": name, "manifest_sha256": policy_sha256,
        "baseline_tree": actual_tree, "integration": policy["integration"]["name"],
    }
    result["status"] = "fail" if any(result[key] for key in (
        "original_file_changes", "unapproved_additions", "worktree_changes")) else "pass"
    return result


def check_source(root: Path, base_ref: str | None, revision_ref: str = "HEAD", *, worktree: bool = True,
                 source_policy: str = "addition-only", policy_manifest: str = "tool/ohos/approved_integration.json",
                 policy_sha256: str | None = None) -> dict:
    revision = commit(root, revision_ref)
    if source_policy == "approved-integration":
        return approved_source(root, revision, base_ref, worktree=worktree,
                               policy_manifest=policy_manifest, policy_sha256=policy_sha256)
    if source_policy != "addition-only" or policy_sha256 is not None:
        raise CheckError("A source-policy hash is accepted only with --source-policy approved-integration")
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
    result["source_policy"] = {"mode": "addition-only"}
    return result


def require_originals_unchanged(report: dict) -> None:
    if report.get("source_policy", {}).get("mode") == "approved-integration":
        if report["status"] != "pass":
            paths = set(report["original_file_changes"]) | set(report["unapproved_additions"]) | set(report["worktree_changes"])
            raise CheckError("Approved application source or worktree changed; review and pin a new baseline:\n  "
                             + "\n  ".join(sorted(paths)))
        return
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
    profile = json.loads((Path(__file__).parent / "sdk_compat/manifest.json").read_text())
    result = {
        "required_by_upstream": required,
        "ohos_sdk_profile": {key: profile[key] for key in (
            "repository", "branch", "commit", "flutter_version", "dart_version",
        )},
        "flutter_executable": executable,
        "media_backend": "validated-separately-during-prepare-build",
        "device_functionality_verified": False,
    }
    if not executable:
        errors.append("Flutter executable not found. Supply --flutter /path/to/flutter-ohos/bin/flutter.")
    else:
        try:
            raw = run([executable, "--version", "--machine"], root, timeout=60)
            actual = json.loads(raw)
            if not isinstance(actual, dict):
                raise CheckError("flutter --version --machine did not return an object")
            result["actual_sdk"] = actual
            sdk_root = Path(executable).resolve().parents[1]
            revision = commit(sdk_root, "HEAD")
            repository = git(sdk_root, "remote", "get-url", "origin").decode().strip()
            result["sdk_commit"] = revision
            errors.extend(ohos_sdk_matches(profile, actual, revision, repository))
            if not errors:
                run([executable, "build", "hap", "--help"], root, timeout=60)
                result["hap_command_available"] = True
        except (CheckError, ValueError) as exc:
            errors.append(str(exc))
    # A passing SDK check does not assert native plugin or device compatibility.
    result["status"] = "blocked" if errors else "pass"
    result["blockers"] = errors
    result["reference"] = "docs/ohos/compatibility-audit.md"
    return result


def ohos_sdk_matches(profile: dict, actual: dict, revision: str, repository: str) -> list[str]:
    errors = []
    if repository.removesuffix(".git").rstrip("/") != profile["repository"].removesuffix(".git").rstrip("/"):
        errors.append("Only the specified CPF-Flutter/flutter_flutter repository is accepted for OHOS")
    if revision != profile["commit"]:
        errors.append(f"OHOS SDK must use the reviewed {profile['branch']} commit {profile['commit']}; got {revision}")
    try:
        framework = version_tuple(str(actual.get("frameworkVersion", "")))
        if framework != version_tuple(profile["flutter_version"]):
            errors.append(f"OHOS Flutter must be {profile['flutter_version']}; got {actual.get('frameworkVersion')}")
        dart = str(actual.get("dartSdkVersion", "")).split(" ")[0]
        if version_tuple(dart) != version_tuple(profile["dart_version"]):
            errors.append(f"OHOS Dart must be {profile['dart_version']}; got {dart}")
    except CheckError as exc:
        errors.append(str(exc))
    return errors


def helper(name: str, directory: Path | None = None):
    directory = directory or Path(__file__).parent
    spec = importlib.util.spec_from_file_location(name, directory / f"{name}.py")
    if spec is None or spec.loader is None:
        raise CheckError(f"Missing OHOS helper: {name}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


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


def prepare(root: Path, output: Path, base_ref: str | None, revision_ref: str, *,
            source_policy: str = "addition-only", policy_manifest: str = "tool/ohos/approved_integration.json",
            policy_sha256: str | None = None) -> dict:
    root, output = root.resolve(), output.resolve()
    if output == root or root in output.parents:
        raise CheckError("The output must be outside the source checkout")
    if output.exists():
        raise CheckError(f"The output already exists: {output}")
    approved = source_policy == "approved-integration"
    report = check_source(root, base_ref, revision_ref, worktree=approved, source_policy=source_policy,
                          policy_manifest=policy_manifest, policy_sha256=policy_sha256)
    require_originals_unchanged(report)
    selected = tree(root, report["source_commit"])
    if "ohos/AppScope/app.json5" not in selected:
        raise CheckError("The selected commit does not contain the OHOS scaffold; commit the new files first")
    output.parent.mkdir(parents=True, exist_ok=True)
    # Build in a temporary sibling and publish only after verification.
    stage = Path(tempfile.mkdtemp(prefix=f".{output.name}-", dir=output.parent))
    try:
        export_archive(root, report["source_commit"], stage)
        # An approved integration exports its selected commit exactly, including
        # later committed build-tool updates. Its application tree was already
        # checked against the separately pinned approval baseline above.
        original = selected if approved else tree(root, report["base_commit"])
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
        original_profile = profile_path.read_bytes()
        profile = json.loads(profile_path.read_text(encoding="utf-8"))
        profile["app"]["versionName"] = version.group(1)
        profile["app"]["versionCode"] = int(version.group(2) or "1")
        profile_path.write_text(json.dumps(profile, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        preparation_changes = []
        profile_bytes = profile_path.read_bytes()
        if profile_bytes != original_profile:
            preparation_changes.append({
                "path": "ohos/AppScope/app.json5", "reason": "synchronize source version metadata",
                "before_sha256": hashlib.sha256(original_profile).hexdigest(),
                "after_sha256": hashlib.sha256(profile_bytes).hexdigest(),
            })
        inventory = {path: {"mode": value[0], "blob": value[2]} for path, value in original.items()}
        if approved:
            inventory["ohos/AppScope/app.json5"]["blob"] = hashlib.sha1(
                b"blob " + str(len(profile_bytes)).encode() + b"\0" + profile_bytes).hexdigest()
        inventory_bytes = (json.dumps(inventory, indent=2) + "\n").encode()
        build_defines = {
            "pili.name": version.group(1),
            "pili.code": int(version.group(2) or "1"),
            "pili.hash": report["source_commit"],
            "pili.time": int(time.time()),
        }
        (stage / "ohos/build-defines.json").write_text(
            json.dumps(build_defines, indent=2) + "\n", encoding="utf-8",
        )
        manifest = {
            "schema": 1,
            **report,
            "stage": "source-preparation-only",
            "application_entrypoint": "lib/main.dart",
            "application_source_transformations": [],
            "source_preparation_transformations": preparation_changes,
            "source_inventory_sha256": hashlib.sha256(inventory_bytes).hexdigest(),
            "snapshot_baseline_commit": report["source_commit"] if approved else report["base_commit"],
            "dependency_overrides_applied": False,
            "native_version": spec["version"],
            "build_defines": "ohos/build-defines.json",
            "hap_built": False,
        }
        (stage / "ohos/source-manifest.json").write_text(
            json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8",
        )
        (stage / "ohos/upstream-files.json").write_bytes(inventory_bytes)
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
    check = sub.add_parser("check-source", help="check additions-only or an explicitly approved integration baseline")
    check.add_argument("--base-ref", help="an incorporated upstream commit; default is merge-base with origin/main")
    diagnostic = sub.add_parser("doctor", help="check the pinned official OHOS 3.44 SDK identity and HAP command")
    diagnostic.add_argument("--flutter", help="path to the OHOS Flutter executable")
    export = sub.add_parser("prepare", help="export a committed source snapshot without rewriting the app")
    export.add_argument("--output", type=Path, required=True)
    export.add_argument("--revision", default="HEAD")
    export.add_argument("--base-ref")
    build = sub.add_parser("prepare-build", help="export and adapt an isolated OHOS build copy")
    build.add_argument("--output", type=Path, required=True)
    build.add_argument("--revision", default="HEAD")
    build.add_argument("--base-ref")
    for command in (check, export, build):
        command.add_argument("--source-policy", choices=("addition-only", "approved-integration"), default="addition-only")
        command.add_argument("--source-policy-manifest", default="tool/ohos/approved_integration.json")
        command.add_argument("--source-policy-sha256", help="expected digest from the application/native dependency lock")
    args = parser.parse_args(argv)
    root = args.workspace.resolve()
    policy = {} if args.command == "doctor" else {
        "source_policy": args.source_policy, "policy_manifest": args.source_policy_manifest,
        "policy_sha256": args.source_policy_sha256,
    }
    try:
        if args.command == "check-source":
            report = check_source(root, args.base_ref, **policy)
            code = 0 if report["status"] == "pass" else 1
        elif args.command == "doctor":
            report = doctor(root, args.flutter)
            code = 0 if report["status"] == "pass" else 2
        elif args.command == "prepare":
            report = prepare(root, args.output, args.base_ref, args.revision, **policy)
            code = 0
        else:
            prepare(root, args.output, args.base_ref, args.revision, **policy)
            # A selected revision must use its own committed adaptation rules,
            # including when this command is invoked from a newer checkout.
            report = helper("build_profile", args.output.resolve() / "tool/ohos").configure(args.output)
            code = 0
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return code
    except (CheckError, OSError, ValueError, RuntimeError) as exc:
        print(f"OHOS: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
