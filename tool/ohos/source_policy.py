"""Validate the explicitly pinned, already integrated application baseline.

The old additions-only contract remains available. This policy accepts one
reviewed application tree plus subsequent build-tool/documentation changes; it
does not turn off application source or working-tree drift checks.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path, PurePosixPath
import re


DEFAULT_MANIFEST = "tool/ohos/approved_integration.json"
MODE = "approved-integration"
SHA256 = re.compile(r"[0-9a-f]{64}\Z")
GIT_SHA = re.compile(r"[0-9a-f]{40}\Z")
# A policy cannot make application/native source directories mutable. Each
# accepted prefix is separately recorded in the committed approval document.
BUILD_METADATA_PATHS = {
    "tool/ohos/", "tool/native/", ".github/workflows/", "docs/",
    "README.md", "README.en.md", "TASKS.md",
}


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def relative(value: object) -> str:
    if (not isinstance(value, str) or not value or "\\" in value or ":" in value
            or value.startswith("/") or any(ord(c) < 32 for c in value)
            or any(part in {"", ".", ".."} for part in value.split("/"))
            or str(PurePosixPath(value)) != value):
        raise RuntimeError(f"Unsafe source-policy path: {value!r}")
    return value


def safe_file(workspace: Path, name: str) -> Path:
    path = workspace
    for part in relative(name).split("/"):
        path /= part
        if path.is_symlink():
            raise RuntimeError(f"Source policy does not follow symbolic links: {name}")
    if not path.is_file() or workspace.resolve() not in path.resolve().parents:
        raise RuntimeError(f"Source policy requires a regular exported file: {name}")
    return path


def document(raw: bytes, expected_sha256: str | None) -> dict:
    if not isinstance(expected_sha256, str) or not SHA256.fullmatch(expected_sha256):
        raise RuntimeError("approved-integration requires an explicit source-policy SHA256")
    if sha256(raw) != expected_sha256:
        raise RuntimeError("Approved source-policy SHA256 mismatch")
    if len(raw) > 1024 * 1024:
        raise RuntimeError("Approved source policy is unexpectedly large")

    def unique(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise RuntimeError(f"Duplicate source-policy key: {key}")
            result[key] = value
        return result

    policy = json.loads(raw, object_pairs_hook=unique)
    if (not isinstance(policy, dict) or type(policy.get("schema")) is not int
            or policy.get("schema") != 1 or policy.get("mode") != MODE):
        raise RuntimeError("Unsupported approved integration source policy")
    for key in ("baseline_commit", "baseline_tree"):
        if not GIT_SHA.fullmatch(str(policy.get(key, ""))):
            raise RuntimeError(f"Source policy requires a complete {key}")
    mutable = policy.get("mutable_paths")
    if (not isinstance(mutable, list) or not mutable or any(not isinstance(path, str) for path in mutable)
            or len(set(mutable)) != len(mutable)
            or not set(mutable) <= BUILD_METADATA_PATHS):
        raise RuntimeError("Approved policy can allow only explicit build-tool/documentation paths")
    integration = policy.get("integration", {})
    if not isinstance(integration, dict) or not isinstance(integration.get("name"), str) or not integration["name"]:
        raise RuntimeError("Approved application integration must be named")
    files = integration.get("files")
    if not isinstance(files, dict) or not files or "lib/main.dart" not in files:
        raise RuntimeError("Approved integration requires application file hashes including lib/main.dart")
    for name, digest in files.items():
        if not relative(name).startswith("lib/") or not name.endswith(".dart") or not SHA256.fullmatch(str(digest)):
            raise RuntimeError(f"Invalid approved integration file identity: {name}")
    dependencies = policy.get("dependencies", {})
    if not isinstance(dependencies, dict):
        raise RuntimeError("Approved dependency policy must be an object")
    for key in ("lock_sha256", "overrides_sha256", "recipe_sha256"):
        if not SHA256.fullmatch(str(dependencies.get(key, ""))):
            raise RuntimeError(f"Approved dependency policy requires {key}")
    return policy


def permits_build_metadata(policy: dict, name: str) -> bool:
    return any(name.startswith(path) if path.endswith("/") else name == path
               for path in policy["mutable_paths"])


def from_export(workspace: Path, manifest: dict | None = None) -> dict | None:
    if manifest is None:
        manifest = json.loads(safe_file(workspace, "ohos/source-manifest.json").read_text())
    receipt = manifest.get("source_policy", {"mode": "addition-only"})
    if not isinstance(receipt, dict):
        raise RuntimeError("Malformed exported source-policy receipt")
    if receipt.get("mode") == "addition-only":
        return None
    if receipt.get("mode") != MODE:
        raise RuntimeError("Unknown exported source-policy mode")
    name = relative(receipt.get("manifest"))
    if not name.startswith("tool/ohos/"):
        raise RuntimeError("Approved source policy must be committed under tool/ohos")
    policy = document(safe_file(workspace, name).read_bytes(), receipt.get("manifest_sha256"))
    if (manifest.get("status") != "pass" or manifest.get("original_file_changes")
            or manifest.get("unapproved_additions") or manifest.get("worktree_changes")
            or manifest.get("base_commit") != policy["baseline_commit"]
            or receipt.get("baseline_tree") != policy["baseline_tree"]
            or not GIT_SHA.fullmatch(str(manifest.get("source_commit", "")))):
        raise RuntimeError("Export does not match its approved source-policy receipt")
    return policy


def verify_integration(workspace: Path, policy: dict) -> dict[str, str]:
    files = policy["integration"]["files"]
    for name, expected in files.items():
        if sha256(safe_file(workspace, name).read_bytes()) != expected:
            raise RuntimeError(f"Approved application integration source drift: {name}")
    return dict(files)
