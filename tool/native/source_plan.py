#!/usr/bin/env python3
"""Resolve development HEADs once per CI run; never modify release anchors."""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[2]
RELEASE_LOCK = ROOT / "tool/native/inputs.lock.json"
PACKAGE_LOCK = ROOT / "tool/native/packages.lock.json"
BRANCHES = ROOT / "tool/native/dev-branches.json"
SHA = re.compile(r"^[0-9a-f]{40}$")
REPOSITORY = re.compile(r"^Goodwu/[A-Za-z0-9_.-]+$")
BRANCH = re.compile(r"^[A-Za-z0-9._/-]+$")


def identity(repository):
    return repository.removeprefix("https://github.com/").removesuffix(".git")


def branch_map(path=BRANCHES):
    data = json.loads(Path(path).read_text())
    branches = data.get("branches")
    if data.get("schema") != 1 or not isinstance(branches, dict):
        raise ValueError("Invalid development branch map")
    for repository, branch in branches.items():
        if (not REPOSITORY.fullmatch(repository) or not isinstance(branch, str)
                or not BRANCH.fullmatch(branch) or ".." in branch
                or branch.startswith("/") or branch.endswith("/")):
            raise ValueError("Invalid development branch mapping")
    if (branches.get("Goodwu/media-kit") != "feature/dv"
            or branches.get("Goodwu/libplacebo") != "optimize/dovi-linear-decode"):
        raise ValueError("Development mapping changed without review")
    return branches


def remote_head(repository, branch):
    ref = "refs/heads/" + branch
    output = subprocess.check_output([
        "git", "ls-remote", "--exit-code",
        "https://github.com/" + repository + ".git", ref
    ], text=True).strip().splitlines()
    if len(output) != 1:
        raise ValueError("Missing or ambiguous branch HEAD: " + repository)
    fields = output[0].split()
    if len(fields) != 2 or not SHA.fullmatch(fields[0]) or fields[1] != ref:
        raise ValueError("Unrecognized ref response: " + repository)
    return fields[0]


def required_repositories(lock, platforms, mode, packages):
    result = set()
    for platform in platforms:
        item = lock["platforms"][platform]
        choice = mode
        if choice == "auto":
            # Development of an owned source profile must not silently use a
            # reviewed old binary package if one becomes available later.
            choice = item["default_mode"] if item["default_mode"] == "source" else (
                "package" if platform in packages else item["default_mode"])
        if choice == "package":
            if platform not in packages:
                raise ValueError("No reviewed package for " + platform)
            if packages[platform]["mode"] == "source":
                raise ValueError("Development native source builds cannot use pinned packages")
            choice = packages[platform]["mode"]
        if choice not in item:
            raise ValueError("Unavailable native mode " + choice + " for " + platform)
        if choice != "source":
            continue
        source = item["source"]
        for entry in [source["producer"], *source.get("sources", {}).values()]:
            repo = identity(entry["repository"])
            if repo.startswith("Goodwu/"):
                result.add(repo)
    return result


def snapshot(lock, platforms, native_mode, source_mode, application_commit,
             packages=None, branches=None, head=remote_head):
    if source_mode not in ("dev", "tag") or not SHA.fullmatch(application_commit):
        raise ValueError("Invalid CI source mode or application commit")
    if not platforms or len(platforms) != len(set(platforms)) or any(
            platform not in lock["platforms"] for platform in platforms):
        raise ValueError("Invalid platform list")
    packages = packages or {}
    effective = copy.deepcopy(lock)
    sources = {}
    if source_mode == "dev":
        branches = branches if branches is not None else branch_map()
        required = required_repositories(lock, platforms, native_mode, packages)
        if not required.issubset(branches):
            raise ValueError("Missing branches: " + ", ".join(sorted(required - branches.keys())))
        names = sorted(required | {"Goodwu/media-kit"})
        heads = {repo: head(repo, branches[repo]) for repo in names}
        if any(not SHA.fullmatch(commit) for commit in heads.values()):
            raise ValueError("Invalid resolved development SHA")
        media_commit = heads["Goodwu/media-kit"]
        sources = {repo: {"branch": branches[repo], "commit": heads[repo]}
                   for repo in sorted(required)}
        for platform in platforms:
            source = effective["platforms"][platform]["source"]
            for entry in [source["producer"], *source.get("sources", {}).values()]:
                repo = identity(entry["repository"])
                if repo in sources:
                    entry["commit"] = sources[repo]["commit"]
                    if "branch" in entry:
                        entry["branch"] = sources[repo]["branch"]
    else:
        media_commit = lock["media_kit"].get("commit")
        if not isinstance(media_commit, str) or not SHA.fullmatch(media_commit):
            raise ValueError("Tag release requires pinned media_kit.commit; no HEAD fallback")
    effective_serialized = json.dumps(effective, sort_keys=True, separators=(",", ":"))
    manifest = {
        "schema": 1, "source_mode": source_mode,
        "application": {"repository": "Goodwu/PiliPlus", "commit": application_commit},
        "media_kit": {"repository": "Goodwu/media-kit",
                      "branch": lock["media_kit"]["branch"], "commit": media_commit},
        "platforms": platforms, "native_mode": native_mode, "sources": sources,
        "effective_lock_sha256": hashlib.sha256(effective_serialized.encode()).hexdigest(),
    }
    return effective, manifest, effective_serialized


def emit(values):
    for key, value in values.items():
        if "\n" in value or "\r" in value:
            raise ValueError("Invalid multiline Actions output")
        if os.environ.get("GITHUB_OUTPUT"):
            with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as stream:
                stream.write(key + "=" + value + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-mode", choices=("dev", "tag"), required=True)
    parser.add_argument("--app-commit", required=True)
    parser.add_argument("--platforms", required=True)
    parser.add_argument("--native-mode", choices=("auto", "source", "upstream", "package"),
                        default="auto")
    parser.add_argument("--effective-output", type=Path, required=True)
    parser.add_argument("--manifest-output", type=Path, required=True)
    args = parser.parse_args()
    if args.source_mode == "dev" and os.environ.get("GITHUB_REF") != "refs/heads/feature/dv":
        parser.error("Development build must run from PiliPlus feature/dv")
    if args.source_mode == "tag" and not os.environ.get("GITHUB_REF", "").startswith("refs/tags/"):
        parser.error("Release builds require a tag ref")
    lock = json.loads(RELEASE_LOCK.read_text())
    packages = json.loads(PACKAGE_LOCK.read_text())["packages"]
    effective, manifest, serialized = snapshot(
        lock, json.loads(args.platforms), args.native_mode, args.source_mode,
        args.app_commit, packages=packages)
    args.effective_output.write_text(json.dumps(effective, indent=2) + "\n")
    args.manifest_output.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    emit({"effective_lock_json": serialized,
          "source_manifest": json.dumps(manifest, sort_keys=True, separators=(",", ":")),
          "media_kit_ref": manifest["media_kit"]["commit"]})
    print(json.dumps({"mode": args.source_mode, "media_kit": manifest["media_kit"],
                      "sources": manifest["sources"], "platforms": manifest["platforms"]},
                     sort_keys=True))


if __name__ == "__main__":
    main()
