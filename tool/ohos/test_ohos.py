"""Regression checks for source preservation and explicit SDK profiles."""

from __future__ import annotations

import importlib.util
import contextlib
import hashlib
import io
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
        defines = json.loads((out / "ohos/build-defines.json").read_text())
        self.assertEqual(defines["pili.name"], "2.1.6")
        self.assertEqual(defines["pili.code"], 17)
        self.assertEqual(defines["pili.hash"], report["source_commit"])
        self.assertLess(defines["pili.time"], 10**11)  # Original BuildConfig uses Unix seconds.
        self.assertEqual(report["application_source_transformations"], [])
        self.assertFalse(report["dependency_overrides_applied"])
        self.assertFalse(report["hap_built"])

    def test_prepare_build_uses_rules_from_selected_commit(self):
        self.write("tool/ohos/build_profile.py", "def configure(workspace):\n    return {'rule': 'selected-commit'}\n")
        self.commit("committed adaptation rules")
        revision = self.git("rev-parse", "HEAD").strip()
        self.write("tool/ohos/build_profile.py", "def configure(workspace):\n    raise RuntimeError('uncommitted rules must not run')\n")
        out = self.parent / "selected revision build"
        captured = io.StringIO()
        with contextlib.redirect_stdout(captured):
            code = ohos.main(["--workspace", str(self.root), "prepare-build", "--output", str(out),
                              "--revision", revision])
        self.assertEqual(code, 0)
        self.assertEqual(json.loads(captured.getvalue())["rule"], "selected-commit")

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

    def test_ohos_environment_is_only_applied_to_an_export(self):
        profile = ohos.helper("build_profile")
        with self.assertRaises(profile.ProfileError):
            profile.configure(self.root)
        out = self.parent / "ohos compatible copy"
        ohos.prepare(self.root, out, None, "HEAD")
        profile.environment_profile(out)
        self.assertEqual(ohos.read_pubspec(self.root)["sdk"], ">=3.13.0")
        self.assertEqual(ohos.read_pubspec(out)["sdk"], ">=3.12.0 <4.0.0")
        self.assertEqual(ohos.read_pubspec(out)["name"], "PiliPlus")
        self.assertEqual([change["path"] for change in profile.generated_changes(out)], ["pubspec.yaml"])
        self.assertEqual((out / "pubspec.lock").read_bytes(), (self.root / "pubspec.lock").read_bytes())

    def test_upstream_patch_drift_fails_before_other_files_are_written(self):
        profile = ohos.helper("build_profile")
        out = self.parent / "drifting source copy"
        ohos.prepare(self.root, out, None, "HEAD")
        before = (out / "pubspec.yaml").read_bytes()
        with self.assertRaises(profile.ProfileError):
            profile.apply_replacements(out, {
                "pubspec.yaml": [("name: PiliPlus", "name: unrelated")],
                "lib/main.dart": [("missing upstream anchor", "new code")],
            })
        self.assertEqual((out / "pubspec.yaml").read_bytes(), before)

    def test_build_copy_parent_symlink_never_reaches_external_file(self):
        profile = ohos.helper("build_profile")
        out = self.parent / "symlink parent copy"
        ohos.prepare(self.root, out, None, "HEAD")
        external = self.parent / "external code"
        (out / "lib").rename(external)
        (out / "lib").symlink_to(external, target_is_directory=True)
        before = (external / "main.dart").read_bytes()
        with self.assertRaises(profile.ProfileError):
            profile.generated_changes(out)
        with self.assertRaises(profile.ProfileError):
            profile.apply_replacements(out, {"lib/main.dart": [("upstream application", "changed")]})
        self.assertEqual((external / "main.dart").read_bytes(), before)


class SdkBuildInfoMigrationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.workspace = Path(self.temp.name).resolve()
        self.profile = ohos.helper("build_profile")
        self.migration = self.profile.SDK_BUILDINFO_MIGRATION
        self.body = b'{"string":[{"name":"enable_impeller","value":"true"}]}\n'
        self.blob = hashlib.sha1(b"blob " + str(len(self.body)).encode() + b"\0" + self.body).hexdigest()
        self.source = self.write(self.migration["source"], self.body)
        self.destination = self.workspace / self.migration["destination"]
        self.destination.parent.mkdir(parents=True)
        self.write("lib/main.dart", b"void main() {}\n")
        self.write("ohos/upstream-files.json", json.dumps({
            self.migration["source"]: {"blob": self.blob},
            "lib/main.dart": {"blob": hashlib.sha1(b"blob 15\0void main() {}\n").hexdigest()},
        }).encode())
        self.write("tool/ohos/sdk_compat/manifest.json", json.dumps({
            key: self.migration["sdk"][key] for key in ("repository", "commit")
        }).encode())

    def write(self, relative, body):
        path = self.workspace / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(body)
        return path

    def move(self):
        self.source.rename(self.destination)

    def test_exact_sdk_move_is_recorded_only_after_verified_hap(self):
        self.move()
        with self.assertRaisesRegex(self.profile.ProfileError, "Expected a regular"):
            self.profile.generated_changes(self.workspace)
        changes = self.profile.generated_changes(self.workspace, after_verified_hap=True)
        self.assertEqual(len(changes), 1)
        self.assertEqual(changes[0]["path"], self.migration["source"])
        self.assertEqual(changes[0]["operation"], "move")
        self.assertIsNone(changes[0]["generated_blob"])
        self.assertEqual(changes[0]["destination"], self.migration["destination"])
        self.assertEqual(changes[0]["destination_blob"], self.blob)
        self.assertEqual(changes[0]["sdk"], self.migration["sdk"])

    def test_move_requires_unchanged_contents(self):
        self.move()
        self.destination.write_bytes(self.body.replace(b"true", b"false"))
        with self.assertRaisesRegex(self.profile.ProfileError, "changed the original"):
            self.profile.generated_changes(self.workspace, after_verified_hap=True)

    def test_other_missing_originals_still_fail_after_verified_hap(self):
        self.move()
        (self.workspace / "lib/main.dart").unlink()
        with self.assertRaisesRegex(self.profile.ProfileError, "Expected a regular.*lib/main.dart"):
            self.profile.generated_changes(self.workspace, after_verified_hap=True)

    def test_missing_destination_is_not_a_completed_move(self):
        self.source.unlink()
        with self.assertRaisesRegex(self.profile.ProfileError, "Expected a regular.*rawfile"):
            self.profile.generated_changes(self.workspace, after_verified_hap=True)

    def test_destination_symlink_is_rejected(self):
        self.source.unlink()
        target = self.write("same-bytes.json", self.body)
        self.destination.symlink_to(target)
        with self.assertRaisesRegex(self.profile.ProfileError, "does not follow symlinks"):
            self.profile.generated_changes(self.workspace, after_verified_hap=True)

    def test_source_symlink_is_not_treated_as_sdk_deletion(self):
        self.move()
        self.source.symlink_to(self.workspace / "missing.json")
        with self.assertRaisesRegex(self.profile.ProfileError, "does not follow symlinks"):
            self.profile.generated_changes(self.workspace, after_verified_hap=True)

    def test_sdk_change_requires_migration_review(self):
        self.move()
        manifest = self.workspace / "tool/ohos/sdk_compat/manifest.json"
        metadata = json.loads(manifest.read_text())
        metadata["commit"] = "0" * 40
        manifest.write_text(json.dumps(metadata))
        with self.assertRaisesRegex(self.profile.ProfileError, "changed OHOS SDK"):
            self.profile.generated_changes(self.workspace, after_verified_hap=True)


class ApprovedIntegrationTests(unittest.TestCase):
    def setUp(self):
        self.fixture = SourceTests()
        self.fixture.setUp()
        self.addCleanup(self.fixture.tearDown)
        self.root, self.parent = self.fixture.root, self.fixture.parent
        self.git, self.write, self.commit = self.fixture.git, self.fixture.write, self.fixture.commit
        self.write("lib/main.dart", "void main() { MediaKit.ensureInitialized(); /* integrated */ }\n")
        self.write("pubspec_overrides.yaml", "dependency_overrides:\n  media_kit:\n    path: ../media-kit/media_kit\n")
        self.commit("approved application integration")
        self.approved_base = self.git("rev-parse", "HEAD").strip()
        self.rules = ohos.helper("source_policy")
        self.policy = {
            "schema": 1, "mode": self.rules.MODE,
            "baseline_commit": self.approved_base,
            "baseline_tree": self.git("rev-parse", "HEAD^{tree}").strip(),
            "mutable_paths": ["tool/ohos/", "tool/native/", ".github/workflows/", "docs/"],
            "integration": {"name": "committed-player", "files": {
                "lib/main.dart": self.rules.sha256((self.root / "lib/main.dart").read_bytes())}},
            "dependencies": {
                "lock_sha256": self.rules.sha256((self.root / "pubspec.lock").read_bytes()),
                "overrides_sha256": self.rules.sha256((self.root / "pubspec_overrides.yaml").read_bytes()),
                "recipe_sha256": self.rules.sha256(Path(__file__).with_name("dependencies.json").read_bytes()),
                "compatibility_decisions": [{"package": "fixture", "reason": "explicit OHOS dependency conversion"}],
            },
        }
        self.save_policy()

    def save_policy(self):
        self.write(self.rules.DEFAULT_MANIFEST, json.dumps(self.policy, indent=2) + "\n")
        self.policy_sha = self.rules.sha256((self.root / self.rules.DEFAULT_MANIFEST).read_bytes())
        self.commit("pin integration source policy")

    def check(self, **kwargs):
        return ohos.check_source(self.root, None, source_policy=self.rules.MODE,
                                 policy_sha256=self.policy_sha, **kwargs)

    def export(self, name="approved export"):
        out = self.parent / name
        return out, ohos.prepare(self.root, out, None, "HEAD", source_policy=self.rules.MODE,
                                 policy_sha256=self.policy_sha)

    def test_existing_integration_needs_explicit_mode_and_policy_hash(self):
        self.assertEqual(ohos.check_source(self.root, None)["status"], "fail")
        self.assertEqual(self.check()["status"], "pass")
        with self.assertRaisesRegex(RuntimeError, "explicit source-policy SHA256"):
            ohos.check_source(self.root, None, source_policy=self.rules.MODE)
        with self.assertRaisesRegex(RuntimeError, "SHA256 mismatch"):
            ohos.check_source(self.root, None, source_policy=self.rules.MODE, policy_sha256="0" * 64)

    def test_only_committed_build_metadata_changes_are_permitted(self):
        self.write("tool/native/lock.json", "{}\n")
        self.write("docs/ci.md", "documented native pipeline\n")
        self.commit("build orchestration")
        report = self.check()
        self.assertEqual(report["status"], "pass")
        self.assertIn("tool/native/lock.json", report["approved_build_metadata_changes"])
        self.write("lib/unreviewed.dart", "// additional runtime source\n")
        self.commit("unreviewed application addition")
        report = self.check()
        self.assertEqual(report["status"], "fail")
        self.assertEqual(report["unapproved_additions"], ["lib/unreviewed.dart"])
        with self.assertRaisesRegex(ohos.CheckError, "Approved application source"):
            self.export()

    def test_reviewed_documentation_and_exact_dependency_config(self):
        # The active branch has approved archived Markdown and a specific
        # media-kit branch rename. Other dependencies and app source stay pinned.
        self.policy["mutable_paths"].extend(["CLAUDE.md", "archives/conversations/"])
        self.write("CLAUDE.md", "# docs\\n")
        self.write("archives/conversations/ci-notes.md", "# notes\\n")
        self.write("pubspec.yaml", "name: PiliPlus\\nversion: 2.1.6+17\\n# reviewed SDK ref\\n")
        self.policy["reviewed_config_hashes"] = {
            "pubspec.yaml": self.rules.sha256((self.root / "pubspec.yaml").read_bytes()),
        }
        self.save_policy()
        report = self.check()
        self.assertEqual(report["status"], "pass")
        self.assertEqual(report["reviewed_config_changes"], ["pubspec.yaml"])
        self.assertIn("CLAUDE.md", report["approved_build_metadata_changes"])
        self.assertIn("archives/conversations/ci-notes.md",
                      report["approved_build_metadata_changes"])
        self.write("pubspec.yaml", "name: PiliPlus\\n# unreviewed edit\\n")
        self.commit("unreviewed pubspec")
        self.assertEqual(self.check()["original_file_changes"], ["pubspec.yaml"])
        self.assertEqual(self.check()["status"], "fail")

    def test_archived_executable_not_permitted_by_markdown_whitelist(self):
        self.policy["mutable_paths"].append("archives/conversations/")
        self.save_policy()
        self.write("archives/conversations/unreviewed.py", "print('not documentation')\\n")
        self.commit("add archived executable")
        report = self.check()
        self.assertEqual(report["status"], "fail")
        self.assertIn("archives/conversations/unreviewed.py", report["unapproved_additions"])

    def test_rejects_source_or_unpinned_config_approval(self):
        self.policy["reviewed_config_hashes"] = {"lib/main.dart": "a" * 64}
        self.save_policy()
        with self.assertRaisesRegex(RuntimeError, "Reviewed configuration"):
            self.check()
        self.policy["reviewed_config_hashes"] = {"pubspec.yaml": "not-a-sha256"}
        self.save_policy()
        with self.assertRaisesRegex(RuntimeError, "Reviewed configuration"):
            self.check()

    def test_changed_application_commit_is_not_accepted_by_the_old_approval(self):
        self.write("lib/main.dart", "void main() { /* changed after approval */ }\n")
        self.commit("application change needs review")
        report = self.check()
        self.assertEqual(report["original_file_changes"], ["lib/main.dart"])
        self.assertEqual(report["status"], "fail")

    def test_worktree_and_hidden_staged_changes_still_fail(self):
        original = (self.root / "lib/main.dart").read_bytes()
        self.write("lib/main.dart", "// staged source drift\n")
        self.git("add", "lib/main.dart")
        self.write("lib/main.dart", original)
        report = self.check()
        self.assertEqual(report["worktree_changes"], ["lib/main.dart"])
        with self.assertRaises(ohos.CheckError):
            self.export()
        self.assertFalse((self.parent / "approved export").exists())

    def test_uncommitted_policy_replacement_cannot_select_another_approval(self):
        self.write(self.rules.DEFAULT_MANIFEST, "{}\n")
        report = self.check()
        self.assertEqual(report["status"], "fail")
        self.assertEqual(report["worktree_changes"], [self.rules.DEFAULT_MANIFEST])

    def test_policy_cannot_allow_runtime_paths_or_claim_a_different_baseline_hash(self):
        self.policy["mutable_paths"].append("lib/")
        self.save_policy()
        with self.assertRaisesRegex(RuntimeError, "build-tool/documentation"):
            self.check()
        self.policy["mutable_paths"].remove("lib/")
        self.policy["integration"]["files"]["lib/main.dart"] = "0" * 64
        self.save_policy()
        with self.assertRaisesRegex(ohos.CheckError, "file hash differs"):
            self.check()

    def test_export_preserves_current_source_and_binds_its_inventory(self):
        self.write("local-signing.p12", "untracked secret, never exported")
        out, report = self.export()
        self.assertEqual((out / "lib/main.dart").read_bytes(), (self.root / "lib/main.dart").read_bytes())
        self.assertFalse((out / "local-signing.p12").exists())
        self.assertEqual(report["snapshot_baseline_commit"], self.git("rev-parse", "HEAD").strip())
        self.assertEqual(report["source_policy"]["manifest_sha256"], self.policy_sha)
        profile = ohos.helper("build_profile")
        self.assertEqual(profile.generated_changes(out), [])
        self.assertEqual(profile.validate_workspace(out)["status"], "pass")
        ledger = out / "ohos/upstream-files.json"
        ledger.write_text("{}\n")
        with self.assertRaisesRegex(profile.ProfileError, "inventory changed"):
            profile.validate_workspace(out)

    def test_approved_dependency_lock_and_overrides_are_bound_and_preserved(self):
        out, _ = self.export()
        dependencies = ohos.helper("dependencies")
        manifest = json.loads(dependencies.MANIFEST.read_text())
        inputs = dependencies.dependency_inputs(out, manifest)
        self.assertEqual(inputs["mode"], self.rules.MODE)
        original = (out / "pubspec_overrides.yaml").read_bytes()
        dependencies.write_overrides(out, {"media_kit": {"path": ".ohos-media-sdk/media_kit"}}, inputs)
        self.assertEqual((out / "ohos/source-pubspec-overrides.yaml").read_bytes(), original)
        self.assertEqual((self.root / "pubspec_overrides.yaml").read_bytes(), original)
        self.assertIn(".ohos-media-sdk/media_kit", (out / "pubspec_overrides.yaml").read_text())

    def test_dependency_lock_or_override_drift_is_rejected(self):
        dependencies = ohos.helper("dependencies")
        manifest = json.loads(dependencies.MANIFEST.read_text())
        for filename in ("pubspec.lock", "pubspec_overrides.yaml"):
            with self.subTest(filename=filename):
                out, _ = self.export(filename + " export")
                (out / filename).write_text("changed after source preparation\n")
                with self.assertRaises(RuntimeError):
                    dependencies.dependency_inputs(out, manifest)

    def test_legacy_dependency_policy_does_not_implicitly_replace_overrides(self):
        out, _ = self.export()
        source = json.loads((out / "ohos/source-manifest.json").read_text())
        source["source_policy"] = {"mode": "addition-only"}
        (out / "ohos/source-manifest.json").write_text(json.dumps(source))
        dependencies = ohos.helper("dependencies")
        with self.assertRaisesRegex(RuntimeError, "without an approved source policy"):
            dependencies.dependency_inputs(out, {"baseline_lock_sha256": self.policy["dependencies"]["lock_sha256"]})


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

    def test_official_ohos_profile_accepts_real_version_and_rejects_wrong_origin(self):
        profile = {
            "repository": "https://gitcode.com/CPF-Flutter/flutter_flutter.git",
            "branch": "oh-3.44.9-dev", "commit": "a" * 40,
            "flutter_version": "3.44.9", "dart_version": "3.12.2",
        }
        actual = {"frameworkVersion": "3.44.9+ohos-0.0.1-canary1", "dartSdkVersion": "3.12.2"}
        self.assertEqual(ohos.ohos_sdk_matches(profile, actual, "a" * 40, profile["repository"]), [])
        self.assertTrue(ohos.ohos_sdk_matches(profile, actual, "a" * 40, "https://example.invalid/flutter.git"))
        self.assertTrue(ohos.ohos_sdk_matches(profile, actual, "b" * 40, profile["repository"]))
        self.assertTrue(ohos.ohos_sdk_matches(profile, {
            "frameworkVersion": "3.47.7", "dartSdkVersion": "3.12.2",
        }, "a" * 40, profile["repository"]))


if __name__ == "__main__":
    unittest.main()
