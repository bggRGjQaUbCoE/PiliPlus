"""Check exact upstream patches, copy isolation, drift rejection and reporting."""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest import mock


TOOL = Path(__file__).with_name("app_compat.py")
SPEC = importlib.util.spec_from_file_location("piliplus_app_compat", TOOL)
app = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(app)
REPO = TOOL.resolve().parents[2]
BASE = "849c56b035ac8acf1b4fd677c2c94debe161da8e"
UNCHANGED = {
    "lib/main.dart",
    "lib/utils/font_utils.dart",
    "lib/utils/extension/theme_ext.dart",
    "lib/utils/theme_utils.dart",
    "lib/plugin/pl_player/controller.dart",
    "lib/services/service_locator.dart",
    "pubspec.yaml",
    "pubspec.lock",
}


class ApplicationCompatibilityTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="piliplus-app-compat-test-")
        self.workspace = Path(self.temp.name) / "exported copy"
        self.workspace.mkdir()
        for relative in app._EXPECTED_PATHS | UNCHANGED:
            target = self.workspace / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(REPO / relative, target)
        self.write("ohos/source-manifest.json", json.dumps({"source_commit": BASE}))
        self.original = self.snapshot()

    def tearDown(self):
        self.temp.cleanup()

    def write(self, relative, body):
        path = self.workspace / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(body.encode() if isinstance(body, str) else body)

    def snapshot(self):
        return {
            path.relative_to(self.workspace).as_posix(): path.read_bytes()
            for path in self.workspace.rglob("*")
            if path.is_file()
        }

    def test_real_main_copy_gets_only_reviewed_platform_changes(self):
        report = app.prepare_application(self.workspace)
        self.assertEqual(report["application_files_changed"], 16)
        self.assertEqual({entry["path"] for entry in report["changed_files"]}, app._EXPECTED_PATHS)
        after = self.snapshot()
        for relative in UNCHANGED:
            self.assertEqual(after[relative], self.original[relative], relative)
        for entry in report["changed_files"]:
            relative = entry["path"]
            self.assertEqual(entry["sha256_before"], hashlib.sha256(self.original[relative]).hexdigest())
            self.assertEqual(entry["sha256_after"], hashlib.sha256(after[relative]).hexdigest())
        widgets = "\n".join(
            body.decode() for relative, body in after.items()
            if relative.startswith("lib/common/widgets/flutter/")
        )
        self.assertEqual(widgets.count("case TargetPlatform.ohos:"), 41)
        self.assertEqual(widgets.count("|| TargetPlatform.ohos => false,"), 2)
        self.assertNotIn("debugDefaultTargetPlatformOverride", widgets)
        platforms = after["lib/utils/platform_utils.dart"].decode()
        self.assertIn("Platform.operatingSystem == 'ohos'", platforms)
        self.assertIn("Platform.isAndroid || Platform.isIOS || isOHOS", platforms)
        self.assertEqual(report["package_name"], "PiliPlus")
        self.assertEqual(report["package_uri_replacements"], 0)
        self.assertFalse(report["theme_algorithm_replaced"])
        self.assertFalse(report["media_backend_replaced"])
        self.assertFalse(report["hap_build_verified"])

    def test_mobile_paths_use_real_platform_operations_and_save_results(self):
        app.prepare_application(self.workspace)
        images = (self.workspace / "lib/utils/image_utils.dart").read_text()
        # A per-save system dialog replaces only OHOS's full-library preflight.
        self.assertEqual(images.count("!PlatformUtils.isOHOS &&"), 2)
        self.assertIn("await SaverGallery.saveFile(", images)
        self.assertIn("await SaverGallery.saveFiles(saveList, skipIfExists: false)", images)
        self.assertIn("if (PlatformUtils.isOHOS && !saved.isSuccess)", images)
        self.assertIn("? await Permission.storage.request()", images)
        self.assertIn(": await Permission.photos.request()", images)
        editable = (self.workspace / "lib/common/widgets/flutter/text_field/editable_text.dart").read_text()
        self.assertIn("_formatAndSetValue(_value.copyWith(composing: TextRange.empty), null)", editable)
        self.assertIn("defaultTargetPlatform != TargetPlatform.ohos", editable)
        self.assertIn("TargetPlatform.android,\n        TargetPlatform.ohos,", editable)
        selection = (self.workspace / "lib/common/widgets/flutter/text_field/text_selection.dart").read_text()
        self.assertEqual(selection.count("value.composing.isNormalized"), 5)
        gallery = (self.workspace / "lib/common/widgets/image_viewer/gallery_viewer.dart").read_text()
        self.assertIn("Platform.isIOS || PlatformUtils.isOHOS", gallery)
        webview = (self.workspace / "lib/pages/webview/view.dart").read_text()
        self.assertIn("onDownloadStartRequest:\n                    Platform.isAndroid || Platform.isOhos", webview)

    def test_second_application_is_idempotent_and_reports_no_new_changes(self):
        app.prepare_application(self.workspace)
        before = self.snapshot()
        report = app.prepare_application(self.workspace)
        self.assertEqual(report["application_files_changed"], 0)
        self.assertEqual(report["changed_files"], [])
        self.assertEqual(before, self.snapshot())
        for patch in report["patches"]:
            self.assertEqual(set(patch["files"].values()), {"already_applied"})

    def test_dart312_compatibility_preserves_all_existing_wait_durations(self):
        app.prepare_application(self.workspace)
        waits = {
            "lib/pages/common/publish/common_publish_page.dart": ["milliseconds: 100"],
            "lib/pages/episode_panel/view.dart": ["milliseconds: 225"],
            "lib/utils/reply_utils.dart": ["seconds: 8"],
            "lib/utils/request_utils.dart": ["milliseconds: 450", "seconds: 5"],
        }
        for relative, durations in waits.items():
            source = (self.workspace / relative).read_text()
            self.assertNotIn("Future.pause", source)
            for duration in durations:
                self.assertIn(f"await Future<void>.delayed(const Duration({duration}));", source)
                # The wait durations are upstream behavior, including anti-fraud
                # requests; compatibility must never shorten or remove them.
                self.assertIn(f"await Future.pause(const Duration({duration}));".encode(), self.original[relative])
        screenshot = (self.workspace / "lib/pages/live_room/superchat/superchat_card.dart").read_text()
        self.assertIn("future: () => Future<void>.delayed(Duration.zero)", screenshot)
        self.assertNotIn("Future.pause", screenshot)
        blacklist = (self.workspace / "lib/pages/blacklist/view.dart").read_text()
        self.assertIn("const _BlockType(this.label);", blacklist)
        self.assertIn("local('本地'),\n  online('在线'),", blacklist)

    def test_unrelated_upstream_insertions_do_not_depend_on_line_numbers(self):
        relative = "lib/common/widgets/flutter/vertical_slider.dart"
        prefix = b"// Independent upstream notice outside every patch context.\n"
        self.write(relative, prefix + self.original[relative])
        report = app.prepare_application(self.workspace)
        self.assertEqual(report["application_files_changed"], 16)
        self.assertTrue((self.workspace / relative).read_bytes().startswith(prefix))

    def test_later_patch_drift_rejects_without_partially_editing_widgets(self):
        relative = "lib/utils/image_utils.dart"
        changed = self.original[relative].replace(
            b"await SaverGallery.saveFiles(saveList, skipIfExists: false);",
            b"await SaverGallery.saveFiles(saveList, skipIfExists: true);",
        )
        self.assertNotEqual(changed, self.original[relative])
        self.write(relative, changed)
        before = self.snapshot()
        with self.assertRaisesRegex(app.CompatibilityError, "context drift"):
            app.prepare_application(self.workspace)
        self.assertEqual(before, self.snapshot())

    def test_repeated_context_does_not_silently_select_an_occurrence(self):
        relative = "lib/common/widgets/flutter/vertical_slider.dart"
        hunks = app._read_patch(app.PATCH_ROOT / "target-platform-344.patch")[relative]
        self.write(relative, self.original[relative] + hunks[0][0].encode())
        before = self.snapshot()
        with self.assertRaisesRegex(app.CompatibilityError, "found old=2"):
            app.prepare_application(self.workspace)
        self.assertEqual(before, self.snapshot())

    def test_partially_applied_file_requires_review_without_more_writes(self):
        relative = "lib/common/widgets/flutter/vertical_slider.dart"
        old, new = app._read_patch(app.PATCH_ROOT / "target-platform-344.patch")[relative][0]
        self.write(relative, self.original[relative].decode().replace(old, new, 1))
        before = self.snapshot()
        with self.assertRaisesRegex(app.CompatibilityError, "Partially applied"):
            app.prepare_application(self.workspace)
        self.assertEqual(before, self.snapshot())

    def test_copy_marker_and_checkout_guards_fail_before_application_changes(self):
        for git_kind in ("directory", "file"):
            git = self.workspace / ".git"
            if git_kind == "directory":
                git.mkdir()
            else:
                git.write_text("gitdir: /example/worktree")
            with self.assertRaisesRegex(app.CompatibilityError, "exported copy"):
                app.prepare_application(self.workspace)
            if git_kind == "directory":
                git.rmdir()
            else:
                git.unlink()
        self.assertEqual(self.original, self.snapshot())
        self.write("ohos/source-manifest.json", json.dumps({"source_commit": "unknown"}))
        with self.assertRaisesRegex(app.CompatibilityError, "provenance"):
            app.prepare_application(self.workspace)

    def test_source_symlink_is_rejected_without_touching_its_target(self):
        relative = "lib/utils/platform_utils.dart"
        outside = Path(self.temp.name) / "outside.dart"
        outside.write_bytes(self.original[relative])
        (self.workspace / relative).unlink()
        (self.workspace / relative).symlink_to(outside)
        with self.assertRaisesRegex(app.CompatibilityError, "symlinks"):
            app.prepare_application(self.workspace)
        self.assertEqual(outside.read_bytes(), self.original[relative])
        for name in app._EXPECTED_PATHS - {relative}:
            self.assertEqual((self.workspace / name).read_bytes(), self.original[name])

    def test_manifest_rename_is_never_implicit(self):
        self.write("pubspec.yaml", self.original["pubspec.yaml"].replace(b"name: PiliPlus", b"name: piliplus", 1))
        before = self.snapshot()
        with self.assertRaisesRegex(app.CompatibilityError, "Expected package name 'PiliPlus'"):
            app.prepare_application(self.workspace)
        self.assertEqual(before, self.snapshot())

    def test_explicit_uri_normalization_reports_extra_files_and_keeps_brand_text(self):
        self.write("pubspec.yaml", self.original["pubspec.yaml"].replace(b"name: PiliPlus", b"name: piliplus", 1))
        self.write("test/uri_example.dart", "import 'package:PiliPlus/main.dart';\nconst brand = 'PiliPlus';\n")
        pubspec_before = (self.workspace / "pubspec.yaml").read_bytes()
        report = app.prepare_application(self.workspace, normalize_package_name=True)
        after = self.snapshot()
        self.assertEqual((self.workspace / "pubspec.yaml").read_bytes(), pubspec_before)
        self.assertIn(b"package:piliplus/main.dart", after["test/uri_example.dart"])
        self.assertIn(b"const brand = 'PiliPlus'", after["test/uri_example.dart"])
        self.assertGreater(report["application_files_changed"], 16)
        self.assertGreater(report["package_uri_files_changed"], 0)
        self.assertEqual(report["package_uri_replacements"], sum(entry["package_uri_replacements"] for entry in report["changed_files"]))
        second = app.prepare_application(self.workspace, normalize_package_name=True)
        self.assertEqual(second["application_files_changed"], 0)

    def test_write_failure_rolls_back_replaced_files_and_removes_temp_files(self):
        real_replace = app.os.replace
        replacements = 0

        def fail_after_one(source, target):
            nonlocal replacements
            replacements += 1
            if replacements == 2:
                raise OSError("simulated filesystem error")
            return real_replace(source, target)

        with mock.patch.object(app.os, "replace", side_effect=fail_after_one):
            with self.assertRaisesRegex(OSError, "simulated filesystem"):
                app.prepare_application(self.workspace)
        self.assertEqual(self.snapshot(), self.original)


if __name__ == "__main__":
    unittest.main()
