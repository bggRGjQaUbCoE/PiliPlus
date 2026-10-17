"""Regression checks for source preservation and honest toolchain rejection."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest


SPEC = importlib.util.spec_from_file_location("ohos_tool", Path(__file__).with_name("ohos.py"))
ohos = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(ohos)


class SourceTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.parent = Path(self.temp.name)
        self.root = self.parent / "checkout with spaces"
        self.root.mkdir()
        self.git("init", "--initial-branch=main")
        self.git("config", "user.name", "OHOS source test")
        self.git("config", "user.email", "ohos-test@example.invalid")
        self.write("pubspec.yaml", 'name: PiliPlus\nversion: 2.1.6+17\nenvironment:\n  sdk: ">=3.13.0"\n  flutter: 3.47.7\n')
        self.write("lib/main.dart", "void main() { /* upstream application */ }\n")
        self.write("pubspec.lock", "upstream-locked-dependencies\n")
        self.write("assets/icon.bin", b"\x00\xff\x01original-icon\x00")
        self.commit("upstream baseline")
        self.base = self.git("rev-parse", "HEAD").strip()
        self.git("update-ref", "refs/remotes/origin/main", self.base)
        self.git("switch", "-c", "feature/ohos")
        self.write("ohos/AppScope/app.json5", json.dumps({"app": {
            "bundleName": "com.example.piliplus", "versionCode": 1, "versionName": "2.1.6",
        }}))
        self.write("ohos/README.md", "OHOS scaffold; not a verified build.\n")
        self.commit("add scaffold")

    def tearDown(self):
        self.temp.cleanup()

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args], stderr=subprocess.PIPE).decode()

    def write(self, path, content):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content if isinstance(content, bytes) else content.encode())

    def commit(self, message):
        self.git("add", ".")
        self.git("commit", "-m", message)

    def test_new_platform_files_preserve_originals(self):
        report = ohos.check_source(self.root, None)
        self.assertEqual(report["status"], "pass")
        self.assertEqual(report["original_files"], 4)
        self.assertEqual(report["added_files"], ["ohos/AppScope/app.json5", "ohos/README.md"])

    def test_uncommitted_original_change_is_rejected(self):
        self.write("lib/main.dart", "void main() {}\n")
        report = ohos.check_source(self.root, None)
        self.assertEqual(report["original_file_changes"], ["lib/main.dart"])
        with self.assertRaises(ohos.CheckError):
            ohos.require_originals_unchanged(report)

    def test_committed_dependency_replacement_is_rejected(self):
        self.write("pubspec.lock", "unreviewed-platform-fork\n")
        self.commit("replace dependencies")
        report = ohos.check_source(self.root, None)
        self.assertEqual(report["original_file_changes"], ["pubspec.lock"])
        with self.assertRaises(ohos.CheckError):
            ohos.prepare(self.root, self.parent / "bad export", None, "HEAD")
        self.assertFalse((self.parent / "bad export").exists())

    def test_staged_original_change_is_rejected_after_working_file_restored(self):
        original = (self.root / "lib/main.dart").read_bytes()
        self.write("lib/main.dart", "void main() { /* staged replacement */ }\n")
        self.git("add", "lib/main.dart")
        self.write("lib/main.dart", original)
        self.assertEqual(ohos.check_source(self.root, None)["original_file_changes"], ["lib/main.dart"])

    def test_original_deletion_is_rejected(self):
        self.git("rm", "lib/main.dart")
        self.assertEqual(ohos.check_source(self.root, None)["original_file_changes"], ["lib/main.dart"])

    def test_fetched_unmerged_main_uses_incorporated_base(self):
        branch = self.git("rev-parse", "HEAD").strip()
        self.git("checkout", "main")
        self.write("lib/main.dart", "void main() { /* next upstream */ }\n")
        self.commit("upstream advances")
        latest = self.git("rev-parse", "HEAD").strip()
        self.git("update-ref", "refs/remotes/origin/main", latest)
        self.git("checkout", "feature/ohos")
        report = ohos.check_source(self.root, None)
        self.assertEqual(report["base_commit"], self.base)
        self.assertEqual(report["source_commit"], branch)
        self.assertEqual(report["status"], "pass")

    def test_prepare_exports_exact_committed_source_without_local_files(self):
        self.write("signing-secret.p12", "local signing material, not tracked")
        self.write(".dart_tool/package_config.json", "local cache")
        self.write("ohos/README.md", "uncommitted note, excluded from selected revision")
        out = self.parent / "prepared copy"
        report = ohos.prepare(self.root, out, None, "HEAD")
        self.assertFalse((out / ".git").exists())
        self.assertFalse((out / "signing-secret.p12").exists())
        self.assertFalse((out / ".dart_tool").exists())
        for original in ("pubspec.yaml", "pubspec.lock", "lib/main.dart", "assets/icon.bin"):
            self.assertEqual((out / original).read_bytes(), (self.root / original).read_bytes())
        profile = json.loads((out / "ohos/AppScope/app.json5").read_text())
        self.assertEqual(profile["app"]["versionCode"], 17)
        self.assertEqual(profile["app"]["versionName"], "2.1.6")
        self.assertEqual(report["application_source_transformations"], [])
        self.assertFalse(report["dependency_overrides_applied"])
        self.assertFalse(report["hap_built"])

    def test_output_cannot_be_inside_checkout_or_replace_existing_directory(self):
        for out in (self.root, self.root / "build-copy"):
            with self.assertRaises(ohos.CheckError):
                ohos.prepare(self.root, out, None, "HEAD")
        out = self.parent / "existing"
        out.mkdir()
        (out / "keep").write_text("keep")
        with self.assertRaises(ohos.CheckError):
            ohos.prepare(self.root, out, None, "HEAD")
        self.assertEqual((out / "keep").read_text(), "keep")

    def test_source_symlink_is_not_followed_into_export(self):
        (self.root / "ohos/link").symlink_to(self.parent / "private-key")
        self.commit("symlink")
        out = self.parent / "symlink export"
        with self.assertRaises(ohos.CheckError):
            ohos.prepare(self.root, out, None, "HEAD")
        self.assertFalse(out.exists())


class ToolchainTests(unittest.TestCase):
    required = {"flutter": "3.47.7", "sdk": ">=3.13.0"}

    def test_matching_version_is_accepted_by_version_check_only(self):
        self.assertEqual(ohos.sdk_matches(self.required, {
            "frameworkVersion": "3.47.7", "dartSdkVersion": "3.13.0",
        }), [])

    def test_new_framework_name_does_not_hide_old_dart(self):
        errors = ohos.sdk_matches(self.required, {
            "frameworkVersion": "3.47.7", "dartSdkVersion": "3.12.2",
        })
        self.assertEqual(len(errors), 1)
        self.assertIn("Dart must satisfy upstream", errors[0])

    def test_unknown_or_prerelease_version_is_not_stamped_as_compatible(self):
        for framework, dart in (("0.0.0-unknown", "3.13.0"), ("3.47.7", "3.13.0-107.0.dev")):
            self.assertTrue(ohos.sdk_matches(self.required, {
                "frameworkVersion": framework, "dartSdkVersion": dart,
            }))

    def test_changed_constraint_requires_review(self):
        self.assertTrue(ohos.sdk_matches({"flutter": "3.47.7", "sdk": "^3.13.0"}, {
            "frameworkVersion": "3.47.7", "dartSdkVersion": "3.13.0",
        }))


if __name__ == "__main__":
    unittest.main()
