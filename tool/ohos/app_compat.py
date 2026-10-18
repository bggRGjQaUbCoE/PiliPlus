#!/usr/bin/env python3
"""Apply reviewed Flutter OHOS 3.44 app patches to an exported source copy.

This module never edits the development checkout, pubspec or package cache.
It reports real application file changes; an isolated copy is not zero-diff.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import sys
import tempfile


PATCH_ROOT = Path(__file__).resolve().with_name("app_patches")
PATCHES = (
    (
        "target-platform-344.patch",
        "Complete OHOS widget branches and mobile input handling, including official OHOS IME composition guards.",
    ),
    (
        "mobile-platform-344.patch",
        "Recognize OHOS as mobile and preserve the image viewer's system-bar behavior without Android JNI.",
    ),
    (
        "gallery-save-344.patch",
        "Use OHOS per-save native authorization and honor the actual gallery save or cancellation result.",
    ),
    (
        "webview-download-344.patch",
        "Connect the existing download confirmation to the OHOS WebView's supported download-start callback.",
    ),
    (
        "dart312-language.patch",
        "Use Dart 3.12-compatible enum syntax and preserve Future.pause delays with Future<void>.delayed.",
    ),
)
_HUNK = re.compile(r"^@@ -\d+(?:,(\d+))? \+\d+(?:,(\d+))? @@(?:.*)\n?$")
_EXPECTED_PATHS = {
    "lib/common/widgets/flutter/vertical_slider.dart",
    "lib/common/widgets/flutter/text_field/editable.dart",
    "lib/common/widgets/flutter/text_field/text_field.dart",
    "lib/common/widgets/flutter/text_field/text_selection.dart",
    "lib/common/widgets/flutter/text_field/editable_text.dart",
    "lib/common/widgets/flutter/text_field/cupertino/text_field.dart",
    "lib/common/widgets/image_viewer/gallery_viewer.dart",
    "lib/utils/platform_utils.dart",
    "lib/utils/image_utils.dart",
    "lib/pages/webview/view.dart",
    "lib/pages/blacklist/view.dart",
    "lib/pages/common/publish/common_publish_page.dart",
    "lib/pages/episode_panel/view.dart",
    "lib/pages/live_room/superchat/superchat_card.dart",
    "lib/utils/reply_utils.dart",
    "lib/utils/request_utils.dart",
}


class CompatibilityError(RuntimeError):
    pass


def _sha256(body: bytes) -> str:
    return hashlib.sha256(body).hexdigest()


def _source_path(root: Path, relative: str) -> Path:
    parts = PurePosixPath(relative)
    if parts.is_absolute() or ".." in parts.parts or not parts.parts:
        raise CompatibilityError(f"Unsafe app source path: {relative}")
    target = root
    for part in parts.parts:
        target /= part
        if target.is_symlink():
            raise CompatibilityError(f"App compatibility does not follow symlinks: {relative}")
    if not target.is_file():
        raise CompatibilityError(f"Missing app source file: {relative}")
    return target


def _read_patch(path: Path) -> dict[str, list[tuple[str, str]]]:
    """Read our text-only unified diffs as exact, unique old/new anchors.

    Hunk line numbers document provenance, not a license to apply with fuzz or
    pick one of several matching contexts after an upstream merge.
    """
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    patches: dict[str, list[tuple[str, str]]] = {}
    relative = None
    index = 0
    while index < len(lines):
        line = lines[index]
        if line.startswith("--- a/"):
            relative = line[len("--- a/"):].rstrip("\n")
            index += 1
            if index >= len(lines) or lines[index] != f"+++ b/{relative}\n":
                raise CompatibilityError(f"Patch must modify one existing path: {path.name}")
            if relative not in _EXPECTED_PATHS or relative in patches:
                raise CompatibilityError(f"Unexpected or repeated patch path: {relative}")
            patches[relative] = []
            index += 1
            continue
        header = _HUNK.fullmatch(line)
        if relative is None or header is None:
            raise CompatibilityError(f"Unsupported unified diff at {path.name}:{index + 1}")
        old_count = int(header.group(1) or "1")
        new_count = int(header.group(2) or "1")
        old_lines, new_lines = [], []
        index += 1
        while index < len(lines) and not lines[index].startswith(("@@ ", "--- a/")):
            content = lines[index]
            if content.startswith(" "):
                old_lines.append(content[1:])
                new_lines.append(content[1:])
            elif content.startswith("-"):
                old_lines.append(content[1:])
            elif content.startswith("+"):
                new_lines.append(content[1:])
            else:
                raise CompatibilityError(f"Unsupported patch line at {path.name}:{index + 1}")
            index += 1
        old, new = "".join(old_lines), "".join(new_lines)
        if len(old_lines) != old_count or len(new_lines) != new_count or not old or old == new:
            raise CompatibilityError(f"Invalid patch hunk in {path.name}: {relative}")
        patches[relative].append((old, new))
    if not patches or any(not hunks for hunks in patches.values()):
        raise CompatibilityError(f"Empty patch: {path.name}")
    return patches


def _apply_hunks(text: str, hunks: list[tuple[str, str]], label: str) -> tuple[str, str]:
    states = []
    for number, (old, new) in enumerate(hunks, 1):
        counts = text.count(old), text.count(new)
        if counts == (1, 0):
            states.append("pending")
        elif counts == (0, 1):
            states.append("present")
        else:
            raise CompatibilityError(
                f"App patch context drift: {label}, hunk {number}; "
                f"expected one old or one new anchor, found old={counts[0]}, new={counts[1]}"
            )
    if len(set(states)) != 1:
        raise CompatibilityError(f"Partially applied app patch requires review: {label}")
    if states[0] == "present":
        return text, "already_applied"
    for old, new in hunks:
        # Earlier hunks cannot silently consume a later hunk's context.
        if text.count(old) != 1:
            raise CompatibilityError(f"Overlapping app patch contexts: {label}")
        text = text.replace(old, new, 1)
    return text, "applied"


def _validate_copy(workspace: Path) -> tuple[Path, dict]:
    root = workspace.resolve()
    if (root / ".git").exists():
        raise CompatibilityError("Application compatibility is restricted to an exported copy without .git")
    manifest_path = _source_path(root, "ohos/source-manifest.json")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict) or not re.fullmatch(r"[0-9a-f]{40}", str(manifest.get("source_commit", ""))):
        raise CompatibilityError("The exported copy has no valid source_commit provenance")
    _source_path(root, "pubspec.yaml")
    return root, manifest


def prepare_application(workspace: Path, *, normalize_package_name: bool = False) -> dict:
    """Preflight every patch, then update only the isolated copy's Dart files.

    The caller owns pubspec edits. Package URI normalization is opt-in and
    requires the manifest name to already be ``piliplus``. Official Dart 3.12.2
    accepted ``PiliPlus`` in the checked pub-get fixture, so it is off by default.
    """
    root, manifest = _validate_copy(workspace)
    pubspec = (root / "pubspec.yaml").read_text(encoding="utf-8")
    names = re.findall(r"^name:\s*([^#\n]+)", pubspec, re.M)
    expected_name = "piliplus" if normalize_package_name else "PiliPlus"
    if len(names) != 1 or names[0].strip().strip("\"'") != expected_name:
        raise CompatibilityError(f"Expected package name {expected_name!r}; pubspec is owned by the caller")

    before: dict[str, bytes] = {}
    planned: dict[str, bytes] = {}
    file_patches: dict[str, list[str]] = {}
    patch_reports = []
    selected_paths = set()
    for filename, reason in PATCHES:
        patch_path = PATCH_ROOT / filename
        patch = _read_patch(patch_path)
        statuses = {}
        for relative, hunks in patch.items():
            target = _source_path(root, relative)
            before.setdefault(relative, target.read_bytes())
            text = planned.get(relative, before[relative]).decode("utf-8")
            transformed, status = _apply_hunks(text, hunks, f"{filename}: {relative}")
            planned[relative] = transformed.encode("utf-8")
            file_patches.setdefault(relative, []).append(filename)
            statuses[relative] = status
            selected_paths.add(relative)
        patch_reports.append({
            "patch": filename,
            "sha256": _sha256(patch_path.read_bytes()),
            "reason": reason,
            "files": statuses,
        })
    if selected_paths != _EXPECTED_PATHS:
        raise CompatibilityError("The reviewed application patch path set changed")

    uri_counts = {}
    if normalize_package_name:
        for directory in (root / "lib", root / "test"):
            if not directory.is_dir():
                continue
            for candidate in sorted(directory.rglob("*.dart")):
                relative = candidate.relative_to(root).as_posix()
                target = _source_path(root, relative)
                source = planned.get(relative, target.read_bytes())
                occurrences = source.count(b"package:PiliPlus/")
                if occurrences:
                    before.setdefault(relative, target.read_bytes())
                    planned[relative] = source.replace(b"package:PiliPlus/", b"package:piliplus/")
                    uri_counts[relative] = occurrences

    changes = [
        {
            "path": relative,
            "sha256_before": _sha256(before[relative]),
            "sha256_after": _sha256(content),
            "patches": file_patches.get(relative, []),
            "package_uri_replacements": uri_counts.get(relative, 0),
        }
        for relative, content in sorted(planned.items())
        if content != before[relative]
    ]
    # Prepare all replacement files before touching any source file. Drift,
    # invalid package names and missing inputs therefore leave the copy intact.
    temporary = {}
    replaced = []
    try:
        for change in changes:
            relative = change["path"]
            target = _source_path(root, relative)
            if target.read_bytes() != before[relative]:
                raise CompatibilityError(f"App source changed during preparation: {relative}")
            descriptor, name = tempfile.mkstemp(prefix=".ohos-app-compat-", dir=target.parent)
            temporary[relative] = Path(name)
            with os.fdopen(descriptor, "wb") as stream:
                stream.write(planned[relative])
            os.chmod(name, stat.S_IMODE(target.stat().st_mode))
        for relative, temporary_path in temporary.items():
            target = _source_path(root, relative)
            if target.read_bytes() != before[relative]:
                raise CompatibilityError(f"App source changed during preparation: {relative}")
            os.replace(temporary_path, target)
            replaced.append(relative)
    except BaseException:
        for relative in reversed(replaced):
            (root / relative).write_bytes(before[relative])
        raise
    finally:
        for path in temporary.values():
            path.unlink(missing_ok=True)

    return {
        "schema": 1,
        "stage": "flutter344-application-compatibility",
        "source_commit": manifest["source_commit"],
        "package_name": expected_name,
        "package_uri_normalization_enabled": normalize_package_name,
        "package_uri_replacements": sum(uri_counts.values()),
        "package_uri_files_changed": len(uri_counts),
        "application_files_changed": len(changes),
        "changed_files": changes,
        "patches": patch_reports,
        "theme_algorithm_replaced": False,
        "media_backend_replaced": False,
        "hap_build_verified": False,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, required=True, help="exported source copy without .git")
    parser.add_argument("--normalize-package-name", action="store_true")
    args = parser.parse_args(argv)
    try:
        report = prepare_application(args.workspace, normalize_package_name=args.normalize_package_name)
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0
    except (CompatibilityError, OSError, ValueError) as exc:
        print(f"OHOS app compatibility: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
