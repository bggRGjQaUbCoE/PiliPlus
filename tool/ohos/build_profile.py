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


def safe_path(workspace: Path, relative: str) -> Path:
    parts = PurePosixPath(relative)
    if parts.is_absolute() or not parts.parts or ".." in parts.parts or "\\" in relative:
        raise ProfileError(f"Unsafe build-copy path: {relative}")
    target = workspace
    for part in parts.parts:
        target /= part
        if target.is_symlink():
            raise ProfileError(f"Build profile does not follow symlinks: {relative}")
    if not target.is_file():
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
    safe_path(workspace, "ohos/upstream-files.json")
    manifest = json.loads(manifest_path.read_text())
    if manifest.get("original_file_changes"):
        raise ProfileError("The exported source does not preserve the original upstream files")
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


def defer_media(workspace: Path) -> list[dict]:
    """Allow application startup while the user-selected media port is pending.

    Keep the existing media-kit Dart API graph. Playback takes the application's
    existing error path, and live photos remain viewable as still images with an
    explicit notice. No player, success response, or native decoder is faked.
    """
    message = "当前 OHOS 开发构建暂未接入播放后端"
    return apply_replacements(workspace, {
        "lib/main.dart": [
            ("  MediaKit.ensureInitialized();\n", "  // OHOS media-kit is deferred until its supported branch is supplied.\n  if (!Platform.isOhos) MediaKit.ensureInitialized();\n"),
            ("      'MPV Api Version':\n          '${NativePlayer.apiVersion >> 16}.${NativePlayer.apiVersion & 0xFFFF}',",
             "      'MPV Api Version': Platform.isOhos\n          ? 'OHOS backend deferred'\n          : '${NativePlayer.apiVersion >> 16}.${NativePlayer.apiVersion & 0xFFFF}',"),
        ],
        "lib/plugin/pl_player/controller.dart": [
            ("  Future<Player> _initPlayer() async {\n    assert(_videoPlayerController == null);",
             "  Future<Player> _initPlayer() async {\n    if (Platform.isOhos) {\n      SmartDialog.showToast('" + message + "');\n      throw UnsupportedError('OHOS media-kit backend is deferred');\n    }\n    assert(_videoPlayerController == null);"),
            ("  Future<void> play({bool repeat = false, bool hideControls = true}) async {\n    if (_playerCount == 0) return;",
             "  Future<void> play({bool repeat = false, bool hideControls = true}) async {\n    if (Platform.isOhos) {\n      SmartDialog.showToast('" + message + "');\n      return;\n    }\n    if (_playerCount == 0) return;"),
        ],
        "lib/common/widgets/image_viewer/gallery_viewer.dart": [
            ("import 'package:get/get.dart';", "import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';\nimport 'package:get/get.dart';"),
            ("  Future<void> _initPlayer() async {\n    assert(_player == null);",
             "  Future<void> _initPlayer() async {\n    if (Platform.isOhos) {\n      SmartDialog.showToast('" + message + "');\n      return;\n    }\n    assert(_player == null);"),
            ("    final Widget child;\n    switch (item.sourceType) {\n      case SourceType.fileImage:",
             "    final Widget child;\n    // Keep the original image viewer for the still component of a live photo.\n    final sourceType = Platform.isOhos && item.sourceType == SourceType.livePhoto\n        ? SourceType.networkImage\n        : item.sourceType;\n    switch (sourceType) {\n      case SourceType.fileImage:"),
        ],
        "lib/pages/audio/controller.dart": [
            ("  }) async {\n    await _initPlayerIfNeeded();\n    final extras = audioFilterExtras(volume);",
             "  }) async {\n    if (Platform.isOhos) {\n      SmartDialog.showToast('" + message + "');\n      return;\n    }\n    await _initPlayerIfNeeded();\n    final extras = audioFilterExtras(volume);"),
        ],
        "lib/pages/live_room/view.dart": [
            ("  late final GlobalKey playerKey = GlobalKey();\n\n  @override\n  void initState() {",
             "  late final GlobalKey playerKey = GlobalKey();\n\n  Worker? _ohosChatLoadWorker;\n  bool _ohosChatRouteActive = true;\n  bool _ohosChatStartedForRoute = false;\n\n  void _startOhosChatIfReady() {\n    if (Platform.isOhos &&\n        mounted &&\n        _ohosChatRouteActive &&\n        !_ohosChatStartedForRoute &&\n        !_liveRoomController.isClosed &&\n        _liveRoomController.isLoaded.value) {\n      _ohosChatStartedForRoute = true;\n      _liveRoomController.startLiveMsg();\n    }\n  }\n\n  @override\n  void initState() {"),
            ("    PlPlayerController.setPlayCallBack(plPlayerController.play);\n    if (plPlayerController.removeSafeArea) {",
             "    PlPlayerController.setPlayCallBack(plPlayerController.play);\n    if (Platform.isOhos) {\n      _ohosChatLoadWorker = ever<bool>(\n        _liveRoomController.isLoaded,\n        (_) => _startOhosChatIfReady(),\n      );\n      _startOhosChatIfReady();\n    }\n    if (plPlayerController.removeSafeArea) {"),
            ("  @override\n  Future<void> didPopNext() async {\n    addObserverMobile(this);",
             "  @override\n  void didPop() {\n    _ohosChatRouteActive = false;\n    super.didPop();\n  }\n\n  @override\n  Future<void> didPopNext() async {\n    _ohosChatRouteActive = true;\n    addObserverMobile(this);"),
            ("    _liveRoomController.startLiveTimer();\n    if (plPlayerController.playerStatus.isPlaying &&",
             "    _liveRoomController.startLiveTimer();\n    _startOhosChatIfReady();\n    if (plPlayerController.playerStatus.isPlaying &&"),
            ("  void didPushNext() {\n    removeObserverMobile(this);",
             "  void didPushNext() {\n    _ohosChatRouteActive = false;\n    _ohosChatStartedForRoute = false;\n    removeObserverMobile(this);"),
            ("  void dispose() {\n    removeObserverMobile(this);",
             "  void dispose() {\n    _ohosChatRouteActive = false;\n    _ohosChatLoadWorker?.dispose();\n    _ohosChatLoadWorker = null;\n    removeObserverMobile(this);"),
            ("        if (_liveRoomController.isLoaded.value && plPlayerController.isLive) {\n          final roomInfoH5 = _liveRoomController.roomInfoH5.value;",
             "        if (_liveRoomController.isLoaded.value && plPlayerController.isLive) {\n          if (Platform.isOhos) {\n            // Keep room details and chat available without constructing a null player.\n            return const Center(\n              child: Text('" + message + "', style: TextStyle(color: baseWhite)),\n            );\n          }\n          final roomInfoH5 = _liveRoomController.roomInfoH5.value;"),
        ],
        "lib/plugin/pl_player/view/view.dart": [
            ("  Future<void> _screenshotWebp() async {\n    final videoInfo = videoDetailController.data;",
             "  Future<void> _screenshotWebp() async {\n    if (Platform.isOhos) {\n      SmartDialog.showToast('" + message + "');\n      return;\n    }\n    final videoInfo = videoDetailController.data;"),
        ],
    })


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


def generated_changes(workspace: Path) -> list[dict]:
    baseline = json.loads(safe_path(workspace, "ohos/upstream-files.json").read_text())
    changes = []
    for relative, info in baseline.items():
        path = safe_path(workspace, relative)
        body = path.read_bytes()
        blob = hashlib.sha1(b"blob " + str(len(body)).encode() + b"\0" + body).hexdigest()
        if blob != info["blob"]:
            changes.append({"path": relative, "upstream_blob": info["blob"], "generated_blob": blob})
    return changes


def update_manifest(workspace: Path, **values) -> dict:
    manifest = validate_workspace(workspace)
    manifest.update(values)
    manifest["generated_original_file_changes"] = generated_changes(workspace)
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
        application = load_helper("app_compat").prepare_application(workspace, normalize_package_name=False)
        platform = platform_integration(workspace)
        media = defer_media(workspace)
        dependencies = load_helper("dependencies").prepare(workspace)
        result = update_manifest(
            workspace,
            stage="ohos-build-copy-prepared",
            application_entrypoint="lib/main.dart",
            package_name_preserved=True,
            sdk_profile="CPF-Flutter/flutter_flutter:oh-3.44.9-dev",
            environment_transformations=environment,
            application_source_transformations=application,
            platform_transformations=platform,
            media_backend="deferred-by-request",
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
