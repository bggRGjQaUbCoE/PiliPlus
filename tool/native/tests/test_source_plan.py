import copy
import importlib.util
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("source_plan", ROOT / "source_plan.py")
plan = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(plan)


class SourcePlanContracts(unittest.TestCase):
    def setUp(self):
        self.lock = json.loads(plan.RELEASE_LOCK.read_text())

    def fake_head(self, repository, branch):
        return {
            "Goodwu/media-kit": "1" * 40,
            "Goodwu/libmpv-android-video-build-dv-experiment": "2" * 40,
            "Goodwu/mpv": "3" * 40,
            "Goodwu/FFmpeg": "4" * 40,
            "Goodwu/libplacebo": "5" * 40,
            "Goodwu/libmpv-ohos-build": "6" * 40,
        }[repository]

    def test_android_dev_resolves_all_current_heads(self):
        release_original = copy.deepcopy(self.lock)
        effective, manifest, encoded = plan.snapshot(
            self.lock, ["android"], "auto", "dev", "a" * 40,
            branches=plan.branch_map(), head=self.fake_head)
        self.assertEqual(self.lock, release_original)
        self.assertEqual(manifest["media_kit"]["commit"], "1" * 40)
        self.assertEqual(manifest["sources"]["Goodwu/libplacebo"],
                         {"branch": "optimize/dovi-linear-decode", "commit": "5" * 40})
        android = effective["platforms"]["android"]["source"]
        self.assertEqual(android["producer"]["commit"], "2" * 40)
        self.assertEqual(android["sources"]["mpv"]["commit"], "3" * 40)
        self.assertEqual(android["sources"]["ffmpeg"]["commit"], "4" * 40)
        self.assertEqual(android["sources"]["libplacebo"]["commit"], "5" * 40)
        self.assertEqual(android["sources"]["media-kit-android-helper"]["commit"],
                         release_original["platforms"]["android"]["source"]["sources"]
                         ["media-kit-android-helper"]["commit"])
        self.assertEqual(json.loads(encoded), effective)

    def test_dev_only_resolves_repos_used_by_selected_platform(self):
        calls = []
        def head(repository, branch):
            calls.append(repository)
            return "a" * 40
        plan.snapshot(self.lock, ["android", "linux", "ohos"], "auto",
                      "dev", "f" * 40, branches=plan.branch_map(), head=head)
        self.assertEqual(set(calls), {"Goodwu/media-kit",
            "Goodwu/libmpv-android-video-build-dv-experiment",
            "Goodwu/mpv", "Goodwu/FFmpeg", "Goodwu/libplacebo",
            "Goodwu/libmpv-ohos-build"})
        self.assertEqual(len(calls), len(set(calls)))

    def test_tag_requires_media_kit_anchor_no_network(self):
        def forbidden(*args):
            raise AssertionError("Tag used remote HEAD")
        with self.assertRaisesRegex(ValueError, "media_kit.commit"):
            plan.snapshot(self.lock, ["android"], "auto", "tag", "a" * 40,
                          head=forbidden)

    def test_release_uses_old_anchors_exactly(self):
        pinned = copy.deepcopy(self.lock)
        pinned["media_kit"]["commit"] = "f" * 40
        def forbidden(*args):
            raise AssertionError("Tag used remote HEAD")
        effective, manifest, encoded = plan.snapshot(
            pinned, ["android"], "auto", "tag", "a" * 40, head=forbidden)
        self.assertEqual(pinned, effective)
        self.assertEqual(json.loads(encoded), pinned)
        self.assertEqual(manifest["sources"], {})
        self.assertEqual(manifest["media_kit"]["commit"], "f" * 40)

    def test_explicit_upstream_cannot_fallback_for_android(self):
        with self.assertRaisesRegex(ValueError, "Unavailable native mode"):
            plan.snapshot(self.lock, ["android"], "upstream", "dev", "a" * 40,
                          branches=plan.branch_map(), head=self.fake_head)

    def test_malformed_development_ref_rejected(self):
        bad = plan.branch_map()
        bad["Goodwu/libplacebo"] = "refs/heads/main"
        with self.assertRaisesRegex(ValueError, "Invalid development branch mapping"):
            # Branch policy itself is read and verified, never taken from a user
            # workflow input. The actual policy is fixed by branch_map().
            invalid = copy.deepcopy(bad)
            invalid["Goodwu/libplacebo"] = "../../main"
            import tempfile
            with tempfile.TemporaryDirectory() as d:
                path = Path(d) / "map.json"
                path.write_text(json.dumps({"schema": 1, "branches": invalid}))
                plan.branch_map(path)


if __name__ == "__main__":
    unittest.main()
