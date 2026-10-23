#!/usr/bin/env python3
"""Apply the reviewed OHOS compatibility profile to an exported build copy.

The source checkout and its upstream lock remain untouched. Every mutation of an
original file is listed in the generated manifest, including package resolution.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path, PurePosixPath
import sys


class ProfileError(RuntimeError):
    pass


SDK_BUILDINFO_MIGRATION = {
    "source": "ohos/entry/src/main/resources/base/profile/buildinfo.json5",
    "destination": "ohos/entry/src/main/resources/rawfile/buildinfo.json5",
    "sdk": {
        "repository": "https://gitcode.com/CPF-Flutter/flutter_flutter.git",
        "commit": "3ffe70c6280cc6ddf613bffa59dd70611f238f7e",
        "path": "packages/flutter_tools/lib/src/ohos/ohos_builder.dart",
        "sha256": "a2d28944fbb558e63492697cee8bc3dce53a2ba8147a3c5333885e2668e7613d",
    },
}


def safe_path(workspace: Path, relative: str, *, allow_missing: bool = False) -> Path:
    parts = PurePosixPath(relative)
    if parts.is_absolute() or not parts.parts or ".." in parts.parts or "\\" in relative:
        raise ProfileError(f"Unsafe build-copy path: {relative}")
    target = workspace
    for part in parts.parts:
        target /= part
        if target.is_symlink():
            raise ProfileError(f"Build profile does not follow symlinks: {relative}")
    if not target.is_file() and not (
            allow_missing and not target.exists() and target.parent.is_dir()):
        raise ProfileError(f"Expected a regular build-copy file: {relative}")
    if workspace not in target.resolve().parents:
        raise ProfileError(f"Build-copy path escapes its workspace: {relative}")
    return target


def load_helper(name: str):
    spec = importlib.util.spec_from_file_location(name, Path(__file__).with_name(f"{name}.py"))
    if spec is None or spec.loader is None:
        raise ProfileError(f"Missing OHOS helper: {name}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def validate_workspace(workspace: Path) -> dict:
    if (workspace / ".git").exists():
        raise ProfileError("Only an exported build copy may be adapted; Git checkouts are refused")
    manifest_path = safe_path(workspace, "ohos/source-manifest.json")
    inventory_path = safe_path(workspace, "ohos/upstream-files.json")
    manifest = json.loads(manifest_path.read_text())
    if manifest.get("original_file_changes"):
        raise ProfileError("The exported source does not preserve the original upstream files")
    policy = load_helper("source_policy").from_export(workspace, manifest)
    inventory_sha256 = manifest.get("source_inventory_sha256")
    if (policy is not None or inventory_sha256 is not None) and (
            inventory_sha256 != hashlib.sha256(inventory_path.read_bytes()).hexdigest()):
        raise ProfileError("Exported source inventory changed after preparation")
    return manifest


def apply_replacements(workspace: Path, replacements: dict[str, list[tuple[str, str]]]) -> list[dict]:
    """Preflight every unique anchor before writing any file in this patch set."""
    pending = []
    for relative, edits in replacements.items():
        path = safe_path(workspace, relative)
        original = path.read_text(encoding="utf-8")
        changed = original
        for before, after in edits:
            if changed.count(before) != 1:
                raise ProfileError(f"OHOS patch anchor changed in {relative}; review the upstream merge")
            changed = changed.replace(before, after, 1)
        pending.append((path, changed, {
            "path": relative,
            "before_sha256": hashlib.sha256(original.encode()).hexdigest(),
            "after_sha256": hashlib.sha256(changed.encode()).hexdigest(),
            "replacements": len(edits),
        }))
    for path, changed, _ in pending:
        path.write_text(changed, encoding="utf-8")
    return [report for _, _, report in pending]


def environment_profile(workspace: Path) -> list[dict]:
    return apply_replacements(workspace, {"pubspec.yaml": [
        ('  sdk: ">=3.13.0"\n  flutter: 3.47.7\n',
         '  sdk: ">=3.12.0 <4.0.0"\n  flutter: ">=3.44.0 <3.45.0"\n'),
    ]})


def platform_integration(workspace: Path) -> list[dict]:
    return apply_replacements(workspace, {
        "lib/main.dart": [
            ("    } on PlatformException {\n      if (kDebugMode) {\n        debugPrint('dynamic_color: Failed to obtain core palette.');\n      }\n    }",
             "    } on PlatformException {\n      if (kDebugMode) {\n        debugPrint('dynamic_color: Failed to obtain core palette.');\n      }\n    } on MissingPluginException {\n      if (!Platform.isOhos) rethrow;\n      // OHOS has no Android wallpaper palette; continue to the existing fallback.\n    }"),
            ("    } on PlatformException {\n      if (kDebugMode) {\n        debugPrint('dynamic_color: Failed to obtain accent color.');\n      }\n    }",
             "    } on PlatformException {\n      if (kDebugMode) {\n        debugPrint('dynamic_color: Failed to obtain accent color.');\n      }\n    } on MissingPluginException {\n      if (!Platform.isOhos) rethrow;\n      // Keep the upstream seed scheme when this system has no dynamic-color plugin.\n    }"),
        ],
        "lib/pages/main/view.dart": [
            ("  static void _onBack() {\n    if (Platform.isAndroid) {\n      AndroidHelper.back();\n    }\n  }",
             "  static void _onBack() {\n    if (Platform.isAndroid) {\n      AndroidHelper.back();\n    } else if (Platform.isOhos) {\n      const MethodChannel('piliplus/ohos').invokeMethod<void>('moveToBackground');\n    }\n  }"),
        ],
    })


def generated_changes(workspace: Path, *, after_verified_hap: bool = False) -> list[dict]:
    baseline = json.loads(safe_path(workspace, "ohos/upstream-files.json").read_text())
    changes = []
    for relative, info in baseline.items():
        migrated = after_verified_hap and relative == SDK_BUILDINFO_MIGRATION["source"]
        path = safe_path(workspace, relative, allow_missing=migrated)
        if migrated and not path.exists():
            # The pinned SDK's copyFlutterBuildInfoFile copies this one resource
            # to rawfile and removes its former path. Only accept that exact
            # move after HAP/native verification; other deletions remain errors.
            sdk = SDK_BUILDINFO_MIGRATION["sdk"]
            sdk_manifest = json.loads(safe_path(workspace, "tool/ohos/sdk_compat/manifest.json").read_text())
            if any(sdk_manifest.get(key) != sdk[key] for key in ("repository", "commit")):
                raise ProfileError("Review the buildinfo migration for the changed OHOS SDK")
            destination = SDK_BUILDINFO_MIGRATION["destination"]
            body = safe_path(workspace, destination).read_bytes()
            moved_blob = hashlib.sha1(b"blob " + str(len(body)).encode() + b"\0" + body).hexdigest()
            if moved_blob != info["blob"]:
                raise ProfileError("SDK buildinfo migration changed the original resource contents")
            changes.append({"path": relative, "upstream_blob": info["blob"], "generated_blob": None,
                            "operation": "move", "destination": destination,
                            "destination_blob": moved_blob, "sdk": dict(sdk)})
            continue
        body = path.read_bytes()
        blob = hashlib.sha1(b"blob " + str(len(body)).encode() + b"\0" + body).hexdigest()
        if blob != info["blob"]:
            changes.append({"path": relative, "upstream_blob": info["blob"], "generated_blob": blob})
    return changes


def update_manifest(workspace: Path, *, after_verified_hap: bool = False, **values) -> dict:
    manifest = validate_workspace(workspace)
    manifest.update(values)
    manifest["generated_original_file_changes"] = generated_changes(workspace, after_verified_hap=after_verified_hap)
    path = safe_path(workspace, "ohos/source-manifest.json")
    path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return manifest


def configure(workspace: Path) -> dict:
    workspace = workspace.resolve()
    manifest = validate_workspace(workspace)
    if manifest.get("stage") != "source-preparation-only":
        raise ProfileError("Use a fresh export; partially or previously configured copies are not replayed")
    if generated_changes(workspace):
        raise ProfileError("The build copy was edited after export; use a fresh export")
    try:
        update_manifest(workspace, stage="configuring-ohos-build-copy")
        environment = environment_profile(workspace)
        media = load_helper("media_backend").prepare_application(workspace)
        application = load_helper("app_compat").prepare_application(workspace, normalize_package_name=False)
        platform = platform_integration(workspace)
        dependencies = load_helper("dependencies").prepare(workspace)
        media = load_helper("media_backend").configure_dependencies(workspace)
        result = update_manifest(
            workspace,
            stage="ohos-build-copy-prepared",
            application_entrypoint="lib/main.dart",
            package_name_preserved=True,
            sdk_profile="CPF-Flutter/flutter_flutter:oh-3.44.9-dev",
            environment_transformations=environment,
            application_source_transformations=application,
            platform_transformations=platform,
            media_backend=media["backend"],
            media_transformations=media,
            dependencies=dependencies,
            dependency_overrides_applied=True,
            dependency_resolution_verified=False,
            hap_built=False,
        )
        return {"output": str(workspace), **result}
    except Exception as exc:
        update_manifest(workspace, stage="configuration-failed", failure=str(exc), hap_built=False)
        raise


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, required=True)
    parser.add_argument("--refresh-manifest", action="store_true", help="record post-resolution file changes")
    args = parser.parse_args()
    try:
        result = update_manifest(args.workspace.resolve()) if args.refresh_manifest else configure(args.workspace)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    except (ProfileError, OSError, ValueError, RuntimeError) as exc:
        print(f"OHOS: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
