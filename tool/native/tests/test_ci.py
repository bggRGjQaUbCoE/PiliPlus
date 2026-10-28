import copy
import importlib.util
import io
import json
from pathlib import Path
import tarfile
import tempfile
import unittest
from unittest.mock import patch
import zipfile

MODULE = Path(__file__).resolve().parents[1] / "ci.py"
SPEC = importlib.util.spec_from_file_location("native_ci", MODULE)
ci = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(ci)


class TransportContracts(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self):
        self.temp.cleanup()

    def tar(self, entries):
        path = self.root / "package.tar.gz"
        with tarfile.open(path, "w:gz") as archive:
            for name, data, target in entries:
                member = tarfile.TarInfo(name)
                if target is not None:
                    member.type = tarfile.SYMTYPE
                    member.linkname = target
                    archive.addfile(member)
                else:
                    member.size = len(data)
                    archive.addfile(member, io.BytesIO(data))
        return path

    def test_tar_preserves_internal_library_links(self):
        archive = self.tar([("lib/libmpv.so.2.5.0", b"ELF", None), ("lib/libmpv.so.2", b"", "libmpv.so.2.5.0")])
        ci.extract(archive, self.root / "out")
        self.assertTrue((self.root / "out/lib/libmpv.so.2").is_symlink())
        self.assertEqual((self.root / "out/lib/libmpv.so.2").read_bytes(), b"ELF")

    def test_archive_path_escape_rejected(self):
        archive = self.tar([("../outside", b"bad", None)])
        with self.assertRaises(ValueError):
            ci.extract(archive, self.root / "out")
        self.assertFalse((self.root / "outside").exists())

    def test_absolute_link_rejected(self):
        archive = self.tar([("header", b"", "/etc/passwd")])
        with self.assertRaises(ValueError):
            ci.extract(archive, self.root / "out")

    def test_relative_link_escape_rejected(self):
        archive = self.tar([("link", b"", "../../outside")])
        with self.assertRaises(ValueError):
            ci.extract(archive, self.root / "out")

    def test_link_parent_cannot_redirect_file_extraction(self):
        archive = self.tar([("include", b"", "../outside"), ("include/client.h", b"header", None)])
        with self.assertRaises((ValueError, FileExistsError)):
            ci.extract(archive, self.root / "out")
        self.assertFalse((self.root / "outside/client.h").exists())

    def test_duplicate_tar_members_rejected(self):
        archive = self.tar([("header", b"one", None), ("header", b"two", None)])
        with self.assertRaises(ValueError):
            ci.extract(archive, self.root / "out")

    def test_zip_case_collision_rejected(self):
        archive = self.root / "package.zip"
        with zipfile.ZipFile(archive, "w") as output:
            output.writestr("Include/client.h", "one")
            output.writestr("include/CLIENT.h", "two")
        with self.assertRaises(ValueError):
            ci.extract(archive, self.root / "out")

    def test_existing_destination_is_never_overwritten(self):
        archive = self.tar([("header", b"new", None)])
        output = self.root / "out"
        output.mkdir()
        (output / "header").write_bytes(b"old")
        with self.assertRaises(ValueError):
            ci.extract(archive, output)
        self.assertEqual((output / "header").read_bytes(), b"old")

    def test_dangling_link_rejected(self):
        archive = self.tar([("libmpv.so", b"", "missing")])
        with self.assertRaises(ValueError):
            ci.extract(archive, self.root / "out")


class InputContracts(unittest.TestCase):
    def setUp(self):
        self.lock = ci.load_lock()

    def test_six_platforms_and_immutable_sdk(self):
        self.assertEqual(set(self.lock["platforms"]), set(ci.PLATFORMS))
        self.assertEqual(self.lock["media_kit"],
                         {"repository": "Goodwu/media-kit", "branch": "dev"})

    def test_plan_freezes_the_resolved_dev_sha(self):
        from types import SimpleNamespace
        args = SimpleNamespace(
            lock=ci.LOCK, packages=ci.PACKAGES, platforms='["android"]',
            mode="source", media_kit_commit="dev")
        with self.assertRaisesRegex(ValueError, "resolved 40-character"):
            ci.plan(args)
        args.media_kit_commit = "a" * 40
        with patch.object(ci, "emit") as published:
            ci.plan(args)
        self.assertEqual(published.call_args.args[0]["media_kit_ref"], "a" * 40)

    def test_sdk_lock_must_name_goodwu_dev(self):
        with tempfile.TemporaryDirectory() as folder:
            source = Path(folder) / "lock.json"
            invalid = copy.deepcopy(self.lock)
            invalid["media_kit"]["branch"] = "main"
            source.write_text(json.dumps(invalid))
            with self.assertRaisesRegex(ValueError, "Goodwu/media-kit dev"):
                ci.load_lock(source)

    def test_adapter_identity_is_stable_across_windows_line_endings(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "adapter.py"
            path.write_bytes(b"def build():\n    return 42\n")
            expected = ci.adapter_digest(path)
            path.write_bytes(b"def build():\r\n    return 42\r\n")
            self.assertEqual(expected, ci.adapter_digest(path))
            path.write_bytes(b"def build():\r\n    return 43\r\n")
            self.assertNotEqual(expected, ci.adapter_digest(path))

    def test_application_revision_does_not_invalidate_native_input(self):
        first = ci.input_digest(self.lock, "android", "source")
        other = copy.deepcopy(self.lock)
        other["application_commit"] = "b" * 40
        other["media_kit"]["branch"] = "another-dev-ref"
        self.assertEqual(first, ci.input_digest(other, "android", "source"))

    def test_native_revision_invalidates_package(self):
        first = ci.input_digest(self.lock, "android", "source")
        other = copy.deepcopy(self.lock)
        other["platforms"]["android"]["source"]["sources"]["mpv"]["commit"] = "b" * 40
        self.assertNotEqual(first, ci.input_digest(other, "android", "source"))

    def test_custom_android_cannot_fall_back_to_upstream(self):
        with self.assertRaises(ValueError):
            ci.select(self.lock, "android", "upstream")

    def test_explicit_package_absent_is_failure(self):
        with self.assertRaises(ValueError):
            ci.select(self.lock, "linux", "package", {})

    def test_stale_package_is_failure_even_in_auto_mode(self):
        entry = {"mode": "upstream", "inputs_sha256": "0" * 64}
        with self.assertRaises(ValueError):
            ci.select(self.lock, "linux", "auto", {"linux": entry})

    def test_package_requires_all_three_digests(self):
        entry = {"mode": "upstream", "inputs_sha256": ci.input_digest(self.lock, "linux", "upstream"),
                 "archive_sha256": "1" * 64, "manifest_sha256": "2" * 64, "identity_sha256": "3" * 64}
        mode, original, _ = ci.select(self.lock, "linux", "auto", {"linux": entry})
        self.assertEqual((mode, original), ("package", "upstream"))
        entry["identity_sha256"] = "latest"
        with self.assertRaises(ValueError):
            ci.select(self.lock, "linux", "auto", {"linux": entry})

    def test_claiming_source_for_upstream_package_fails(self):
        key = ci.input_digest(self.lock, "android", "source")
        manifest = {"identity": {"origin": "upstream-binary", "options": {"ci_inputs_sha256": key}},
            "architectures": self.lock["platforms"]["android"]["architectures"],
            "capabilities": self.lock["platforms"]["android"]["source"]["required_capabilities"],
            "validation": {"compiled": False}}
        with self.assertRaises(ValueError):
            ci.verify_policy(self.lock, "android", "source", manifest, key)

    def test_missing_compiled_capability_fails(self):
        key = ci.input_digest(self.lock, "android", "source")
        manifest = {"identity": {"options": {"ci_inputs_sha256": key}},
            "architectures": self.lock["platforms"]["android"]["architectures"], "capabilities": []}
        with self.assertRaises(ValueError):
            ci.verify_policy(self.lock, "android", "source", manifest, key)


if __name__ == "__main__":
    unittest.main()
