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

    def tearDown(self):
        self.temp.cleanup()

    def apply(self):
        return media.apply_direction_b(self.workspace, self.sdk, self.config)

    def test_exact_seven_file_patch(self):
        report = self.apply()
        self.assertEqual(len(report['files']), 7)
        for name, identity in self.files.items():
            self.assertEqual(media.blob((self.workspace / name).read_bytes()), identity['after'])

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


if __name__ == '__main__': unittest.main()
