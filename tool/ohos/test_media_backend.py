"""Unit tests for the real media integration gates; no network/device claims."""
from __future__ import annotations
import difflib
import hashlib
import json
import os
from pathlib import Path
import struct
import sys
import tempfile
import unittest
from unittest.mock import patch
import zipfile

sys.path.insert(0, str(Path(__file__).parent))
import media_backend as media


class MediaGates(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.workspace = self.root / 'app'
        self.sdk = self.root / 'sdk'
        self.workspace.mkdir(); self.sdk.mkdir()
        self.files = {}
        chunks = []
        for index in range(7):
            name = f'lib/integration_{index}.dart'
            old, new = f'// before {index}\n', f'// after {index}\n'
            target = self.workspace / name
            target.parent.mkdir(exist_ok=True)
            target.write_text(old)
            self.files[name] = {'before': media.blob(old.encode()), 'after': media.blob(new.encode())}
            chunks.extend(difflib.unified_diff(old.splitlines(True), new.splitlines(True), fromfile='a/'+name, tofile='b/'+name))
        body = ''.join(chunks).encode()
        (self.sdk / 'patch.diff').write_bytes(body)
        (self.sdk / 'manifest.json').write_text(json.dumps({'patchSha256': media.sha256(body), 'files': self.files}))
        self.config = {'patch':'patch.diff', 'manifest':'manifest.json', 'patch_sha256':media.sha256(body)}
        library = bytearray(64)
        library[:6] = b'\x7fELF\x02\x01'; struct.pack_into('<HH', library, 16, 3, 183)
        self.library = self.root / 'libmpv.so'; self.library.write_bytes(library)
        self.archive = self.root / 'libmpv.zip'
        with zipfile.ZipFile(self.archive, 'w') as z: z.writestr('libmpv.so', library)
        self.env = {'MEDIA_KIT_OHOS_LIBMPV_ARCHIVE': str(self.archive),
                    'MEDIA_KIT_OHOS_LIBMPV_SHA256': media.sha256(self.archive.read_bytes()),
                    'PILIPLUS_OHOS_LIBMPV_LIBRARY': str(self.library)}
        self.manifest = self.root / 'manifest.json'
        self.manifest.write_text(json.dumps({
            'platform': 'ohos-arm64',
            'artifacts': [{'file':self.library.name, 'sha256':media.sha256(self.library.read_bytes())},
                          {'file':self.archive.name, 'sha256':media.sha256(self.archive.read_bytes())}],
            'media_features': {'libmpv_sha256':media.sha256(self.library.read_bytes()),
                'required_features': {name:True for name in
                    ('CONFIG_LIBWEBP_ENCODER', 'CONFIG_LIBWEBP_ANIM_ENCODER', 'CONFIG_WEBP_MUXER')}}}))

    def tearDown(self):
        self.temp.cleanup()

    def apply(self):
        return media.apply_direction_b(self.workspace, self.sdk, self.config)

    def test_exact_seven_file_patch(self):
        report = self.apply()
        self.assertEqual(len(report['files']), 7)
        for name, identity in self.files.items():
            self.assertEqual(media.blob((self.workspace / name).read_bytes()), identity['after'])

    def approved_application(self):
        rules = media.build_profile.load_helper('source_policy')
        main = self.workspace / 'lib/main.dart'
        main.write_text('void main() { MediaKit.ensureInitialized(); }\n')
        policy = {
            'schema': 1, 'mode': rules.MODE, 'baseline_commit': 'a' * 40, 'baseline_tree': 'b' * 40,
            'mutable_paths': ['tool/ohos/'],
            'integration': {'name': 'existing managed playback', 'files': {
                'lib/main.dart': media.sha256(main.read_bytes()),
                **{name: media.sha256((self.workspace / name).read_bytes()) for name in self.files}}},
            'dependencies': {key: 'c' * 64 for key in ('lock_sha256', 'overrides_sha256', 'recipe_sha256')},
        }
        policy_file = self.workspace / rules.DEFAULT_MANIFEST
        policy_file.parent.mkdir(parents=True)
        policy_file.write_text(json.dumps(policy))
        digest = media.sha256(policy_file.read_bytes())
        receipt = {'schema': 1, 'status': 'pass', 'source_commit': 'd' * 40, 'base_commit': 'a' * 40,
                   'original_file_changes': [], 'unapproved_additions': [], 'worktree_changes': [],
                   'source_policy': {'mode': rules.MODE, 'manifest': rules.DEFAULT_MANIFEST,
                                     'manifest_sha256': digest, 'baseline_tree': 'b' * 40}}
        (self.workspace / 'ohos').mkdir()
        (self.workspace / 'ohos/source-manifest.json').write_text(json.dumps(receipt))
        self.config['existing_integration'] = {'source_policy': rules.DEFAULT_MANIFEST,
                                                'source_policy_sha256': digest}
        return policy

    def test_approved_existing_integration_never_reapplies_direction_b(self):
        policy = self.approved_application()
        before = {name: (self.workspace / name).read_bytes() for name in policy['integration']['files']}
        (self.sdk / 'patch.diff').unlink()
        with patch.object(media, 'apply_direction_b', side_effect=AssertionError('old patch must not run')):
            report = media.application_integration(self.workspace, self.sdk, self.config)
        self.assertEqual(report['mode'], 'existing-integration')
        self.assertFalse(report['patch_applied'])
        self.assertEqual(report['files'], policy['integration']['files'])
        self.assertEqual(before, {name: (self.workspace / name).read_bytes() for name in before})

    def test_existing_integration_file_drift_has_no_legacy_fallback(self):
        self.approved_application()
        (self.workspace / 'lib/main.dart').write_text('// changed after approval\n')
        with patch.object(media, 'apply_direction_b', side_effect=AssertionError('no fallback')):
            with self.assertRaisesRegex(RuntimeError, 'integration source drift'):
                media.application_integration(self.workspace, self.sdk, self.config)

    def test_existing_integration_requires_matching_media_recipe_hash(self):
        self.approved_application()
        self.config['existing_integration']['source_policy_sha256'] = '0' * 64
        with self.assertRaisesRegex(RuntimeError, 'does not approve'):
            media.application_integration(self.workspace, self.sdk, self.config)

    def test_checked_in_integration_policy_matches_current_application_sources(self):
        root = Path(__file__).resolve().parents[2]
        rules = media.build_profile.load_helper('source_policy')
        config = json.loads((root / 'tool/ohos/media_backend.json').read_text())
        approval = config['existing_integration']
        policy = rules.document((root / approval['source_policy']).read_bytes(), approval['source_policy_sha256'])
        rules.verify_integration(root, policy)
        self.assertEqual(policy['reviewed_config_hashes']['pubspec.yaml'],
                         media.sha256((root / 'pubspec.yaml').read_bytes()))
        self.assertEqual(policy['dependencies']['lock_sha256'], media.sha256((root / 'pubspec.lock').read_bytes()))
        self.assertEqual(policy['dependencies']['overrides_sha256'], media.sha256((root / 'pubspec_overrides.yaml').read_bytes()))
        self.assertEqual(policy['dependencies']['recipe_sha256'], media.sha256((root / 'tool/ohos/dependencies.json').read_bytes()))

    def test_preimage_drift_rejected_before_any_other_write(self):
        name = list(self.files)[-1]
        (self.workspace / name).write_text('new upstream\n')
        with self.assertRaisesRegex(RuntimeError, 'preimage drift'): self.apply()
        first = next(iter(self.files))
        self.assertEqual(media.blob((self.workspace / first).read_bytes()), self.files[first]['before'])

    def test_patch_tamper_rejected(self):
        with (self.sdk / 'patch.diff').open('a') as f: f.write('tamper\n')
        with self.assertRaisesRegex(RuntimeError, 'patch changed'): self.apply()

    def test_manifest_tamper_rejected(self):
        path = self.sdk / 'manifest.json'; m = json.loads(path.read_text())
        m['patchSha256'] = '0'*64; path.write_text(json.dumps(m))
        with self.assertRaisesRegex(RuntimeError, 'patch changed'): self.apply()

    def test_extra_file_not_in_patch_is_rejected(self):
        path = self.sdk / 'manifest.json'; m = json.loads(path.read_text())
        m['files']['lib/extra.dart'] = {'before':'0'*40, 'after':'1'*40}
        path.write_text(json.dumps(m))
        with self.assertRaisesRegex(RuntimeError, 'scope changed'): self.apply()

    def test_reapplying_patch_is_rejected(self):
        self.apply()
        with self.assertRaisesRegex(RuntimeError, 'preimage drift'): self.apply()

    def test_app_symlink_rejected(self):
        name = next(iter(self.files)); target = self.workspace / name
        target.unlink(); target.symlink_to(self.library)
        with self.assertRaises(RuntimeError): self.apply()

    def test_native_inputs_are_bound(self):
        with patch.dict(os.environ, self.env, clear=True):
            result = media.native_inputs()
        self.assertEqual(result['library_sha256'], media.sha256(self.library.read_bytes()))

    def test_missing_native_input_rejected(self):
        for name in self.env:
            with self.subTest(name=name), patch.dict(os.environ, {k:v for k,v in self.env.items() if k!=name}, clear=True):
                with self.assertRaisesRegex(RuntimeError, 'all required'): media.native_inputs()

    def test_wrong_archive_digest_rejected(self):
        with patch.dict(os.environ, self.env | {'MEDIA_KIT_OHOS_LIBMPV_SHA256':'0'*64}, clear=True):
            with self.assertRaisesRegex(RuntimeError, 'digest mismatch'): media.native_inputs()

    def test_non_arm64_input_rejected(self):
        self.library.write_bytes(b'not an ELF')
        with patch.dict(os.environ, self.env, clear=True):
            with self.assertRaisesRegex(RuntimeError, 'AArch64'): media.native_inputs()

    def test_native_symlink_rejected(self):
        link = self.root / 'linked.so'; link.symlink_to(self.library)
        with patch.dict(os.environ, self.env | {'PILIPLUS_OHOS_LIBMPV_LIBRARY':str(link)}, clear=True):
            with self.assertRaisesRegex(RuntimeError, 'without symlinks'): media.native_inputs()

    def test_invalid_native_digest_rejected(self):
        with patch.dict(os.environ, self.env | {'MEDIA_KIT_OHOS_LIBMPV_SHA256':'not-a-digest'}, clear=True):
            with self.assertRaisesRegex(RuntimeError, 'Invalid native'): media.native_inputs()

    def test_no_deferred_backend_in_production_build_profile(self):
        root = Path(__file__).parent
        self.assertNotIn('defer_media(', (root/'build_profile.py').read_text())
        self.assertIn('media_backend.verify_hap', (root/'build.py').read_text())
        self.assertNotIn('built-unsigned-media-deferred', (root/'build.py').read_text())


    def test_tracked_relative_sdk_link_hashes_literal_target(self):
        (self.sdk/'shared').mkdir(); (self.sdk/'shared/source.swift').write_text('shared implementation')
        (self.sdk/'platform').mkdir(); (self.sdk/'platform/link.swift').symlink_to('../shared/source.swift')
        self.assertEqual(media.source_blob(self.sdk, 'platform/link.swift', '120000'), media.blob(b'../shared/source.swift'))

    def test_sdk_link_escapes_rejected(self):
        (self.sdk/'link.swift').symlink_to('../libmpv.so')
        with self.assertRaisesRegex(RuntimeError, 'escapes'): media.source_blob(self.sdk, 'link.swift', '120000')

    def test_absolute_sdk_link_rejected(self):
        (self.sdk/'link.swift').symlink_to(self.library)
        with self.assertRaisesRegex(RuntimeError, 'Absolute'): media.source_blob(self.sdk, 'link.swift', '120000')

    def test_dangling_sdk_link_rejected(self):
        (self.sdk/'link.swift').symlink_to('missing.swift')
        with self.assertRaisesRegex(RuntimeError, 'Dangling'): media.source_blob(self.sdk, 'link.swift', '120000')

    def test_replaced_sdk_link_rejected(self):
        (self.sdk/'link.swift').write_text('not a symlink')
        with self.assertRaisesRegex(RuntimeError, 'replaced'): media.source_blob(self.sdk, 'link.swift', '120000')

    def test_sdk_link_parent_rejected(self):
        (self.sdk/'shared').mkdir(); (self.sdk/'shared/link.swift').symlink_to('../manifest.json')
        (self.sdk/'linked').symlink_to('shared')
        with self.assertRaisesRegex(RuntimeError, 'linked parent'): media.source_blob(self.sdk, 'linked/link.swift', '120000')

    def test_native_manifest_required(self):
        self.manifest.unlink()
        with patch.dict(os.environ, self.env, clear=True):
            with self.assertRaisesRegex(RuntimeError, 'must accompany'): media.native_inputs()

    def test_native_without_compiled_webp_rejected(self):
        data=json.loads(self.manifest.read_text()); data.pop('media_features'); self.manifest.write_text(json.dumps(data))
        with patch.dict(os.environ, self.env, clear=True):
            with self.assertRaisesRegex(RuntimeError, 'WebP'): media.native_inputs()

    def test_native_manifest_bound_to_exact_bytes(self):
        data=json.loads(self.manifest.read_text()); data['media_features']['libmpv_sha256']='0'*64
        self.manifest.write_text(json.dumps(data))
        with patch.dict(os.environ, self.env, clear=True):
            with self.assertRaisesRegex(RuntimeError, 'does not identify'): media.native_inputs()


if __name__ == '__main__': unittest.main()
