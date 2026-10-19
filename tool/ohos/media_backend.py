#!/usr/bin/env python3
"""Bind a committed media-kit checkout to the existing OHOS build export.

Only the exported application and SDK copy are written. No runtime feature
switch, stale-binary fallback, global Pub cache patch or source-guard bypass.
"""
from __future__ import annotations

import hashlib
import importlib.util
import io
import json
import os
from pathlib import Path
import re
import subprocess
import tarfile
from urllib.parse import unquote, urljoin, urlparse

import build_profile

RECEIPT = 'ohos/media-backend.json'
SNAPSHOT = '.ohos-media-sdk'


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def blob(data: bytes) -> str:
    return hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()


def recipe(workspace: Path) -> dict:
    return json.loads(build_profile.safe_path(workspace, 'tool/ohos/media_backend.json').read_text())


def run(root: Path, *args: str, data: bytes | None = None) -> bytes:
    result = subprocess.run(['git', '-C', str(root), *args], input=data, capture_output=True, timeout=180)
    if result.returncode:
        raise RuntimeError(f'media-kit Git {args[0]} failed: {result.stderr.decode(errors="replace")}')
    return result.stdout


def native_inputs() -> dict:
    values = {key: os.environ.get(key, '') for key in (
        'MEDIA_KIT_OHOS_LIBMPV_ARCHIVE', 'MEDIA_KIT_OHOS_LIBMPV_SHA256',
        'PILIPLUS_OHOS_LIBMPV_LIBRARY')}
    if not all(values.values()):
        raise RuntimeError('Current native archive, SHA256 and built libmpv.so inputs are all required')
    digest = values['MEDIA_KIT_OHOS_LIBMPV_SHA256']
    if not re.fullmatch(r'[0-9a-f]{64}', digest):
        raise RuntimeError('Invalid native archive SHA256')
    archive = Path(values['MEDIA_KIT_OHOS_LIBMPV_ARCHIVE'])
    library = Path(values['PILIPLUS_OHOS_LIBMPV_LIBRARY'])
    for path in (archive, library):
        if not path.is_absolute() or not path.is_file() or any(p.is_symlink() for p in (path, *path.parents)):
            raise RuntimeError(f'Native input must be an absolute regular file without symlinks: {path}')
    if sha256(archive.read_bytes()) != digest:
        raise RuntimeError('Native archive digest mismatch; historical download fallback is forbidden')
    data = library.read_bytes()
    if len(data) < 64 or data[:6] != b'\x7fELF\x02\x01' or int.from_bytes(data[16:18], 'little') != 3 or int.from_bytes(data[18:20], 'little') != 183:
        raise RuntimeError('Native libmpv must be an AArch64 ELF shared library')
    return {'archive': str(archive), 'archive_sha256': digest,
            'library': str(library), 'library_sha256': sha256(data)}


def apply_direction_b(workspace: Path, sdk: Path, config: dict) -> dict:
    patch_path = build_profile.safe_path(sdk, config['patch'])
    patch = patch_path.read_bytes()
    manifest = json.loads(build_profile.safe_path(sdk, config['manifest']).read_text())
    if sha256(patch) != config['patch_sha256'] or manifest['patchSha256'] != config['patch_sha256']:
        raise RuntimeError('Direction B patch changed; review it against the OHOS application before updating the recipe')
    expected = manifest['files']
    paths = re.findall(r'^\+\+\+ b/(.+)$', patch.decode(), re.M)
    if len(paths) != 7 or set(paths) != set(expected):
        raise RuntimeError('Direction B seven-file patch scope changed')
    for name, identity in expected.items():
        if blob(build_profile.safe_path(workspace, name).read_bytes()) != identity['before']:
            raise RuntimeError(f'Direction B preimage drift: {name}')
    # Input is exact text from the exported SDK, not a differently filtered
    # checkout and never --reject/--3way. Check all paths before any writes.
    run(workspace, 'apply', '--check', '-', data=patch)
    run(workspace, 'apply', '-', data=patch)
    for name, identity in expected.items():
        if blob(build_profile.safe_path(workspace, name).read_bytes()) != identity['after']:
            raise RuntimeError(f'Direction B postimage mismatch: {name}')
    return {'patch_sha256': sha256(patch), 'files': expected,
            'order': 'direction-B before existing OHOS platform/language patches'}


def prepare_application(workspace: Path) -> dict:
    build_profile.validate_workspace(workspace)
    config = recipe(workspace)
    supplied = os.environ.get('PILIPLUS_MEDIA_KIT_ROOT', '')
    if not supplied:
        raise RuntimeError('PILIPLUS_MEDIA_KIT_ROOT must point to the current committed media-kit checkout')
    root = Path(supplied).absolute()
    if any(p.is_symlink() for p in (root, *root.parents)):
        raise RuntimeError('Media SDK checkout may not traverse symlinks')
    root = root.resolve()
    if root == workspace or root in workspace.parents or workspace in root.parents:
        raise RuntimeError('The media SDK checkout must be outside the application export')
    if Path(run(root, 'rev-parse', '--show-toplevel').decode().strip()).resolve() != root:
        raise RuntimeError('PILIPLUS_MEDIA_KIT_ROOT is not a Git repository root')
    if run(root, 'remote', 'get-url', 'origin').decode().strip().removesuffix('.git') != config['repository'].removesuffix('.git'):
        raise RuntimeError('Media SDK repository is not the approved Goodwu/media-kit')
    if run(root, 'status', '--porcelain', '--untracked-files=normal').strip():
        raise RuntimeError('Media SDK checkout is dirty; commit changes before building')
    commit = run(root, 'rev-parse', 'HEAD').decode().strip()
    tree = run(root, 'rev-parse', 'HEAD^{tree}').decode().strip()
    native = native_inputs()
    destination = workspace / SNAPSHOT
    if destination.exists() or destination.is_symlink():
        raise RuntimeError('Media SDK snapshot already exists; prepare a fresh export')
    archive = run(root, 'archive', '--format=tar', 'HEAD')
    with tarfile.open(fileobj=io.BytesIO(archive)) as stream:
        stream.extractall(destination, filter='data')
    entries = {}
    for row in run(root, 'ls-tree', '-rz', 'HEAD').split(b'\0'):
        if not row:
            continue
        meta, path = row.split(b'\t', 1)
        mode, kind, identity = meta.decode().split()
        relative = path.decode()
        if kind != 'blob' or mode not in ('100644', '100755'):
            raise RuntimeError(f'Unsupported SDK source entry: {relative}')
        if blob(build_profile.safe_path(destination, relative).read_bytes()) != identity:
            raise RuntimeError(f'SDK export changed: {relative}')
        entries[relative] = identity
    direction_b = apply_direction_b(workspace, destination, config)
    report = {'schema': 1, 'backend': 'media-kit-direction-b', 'repository': config['repository'],
              'branch': config['branch'], 'commit': commit, 'tree': tree,
              'archive_sha256': sha256(archive), 'source_blobs': entries,
              'recipe_sha256': sha256((workspace / 'tool/ohos/media_backend.json').read_bytes()),
              'direction_b': direction_b, 'native': native, 'packages': {},
              'device_verified': False, 'hdr_verified': False}
    (workspace / RECEIPT).write_text(json.dumps(report, indent=2) + '\n')
    return report


def configure_dependencies(workspace: Path) -> dict:
    report = json.loads(build_profile.safe_path(workspace, RECEIPT).read_text())
    root = workspace / SNAPSHOT
    specs = [root / 'media_kit/pubspec.yaml', root / 'media_kit_video/pubspec.yaml', *root.glob('libs/**/pubspec.yaml')]
    packages = {}
    for spec in specs:
        names = re.findall(r'^name:\s*([a-zA-Z_][a-zA-Z_0-9]*)\s*$', spec.read_text(), re.M)
        if len(names) != 1 or not names[0].startswith('media_kit') or names[0] in packages:
            raise RuntimeError(f'Unexpected or duplicate media-kit package: {spec}')
        packages[names[0]] = spec.parent.relative_to(workspace).as_posix()
    if not set(recipe(workspace)['required_packages']).issubset(packages):
        raise RuntimeError('Media SDK package closure is incomplete')
    target = build_profile.safe_path(workspace, 'pubspec_overrides.yaml')
    contents = json.loads(target.read_text())
    overrides = contents['dependency_overrides']
    previous = {name: value for name, value in overrides.items() if name.startswith('media_kit')}
    for name in previous:
        del overrides[name]
    overrides.update({name: {'path': path} for name, path in packages.items()})
    target.write_text(json.dumps(contents, indent=2) + '\n')
    application_blobs = {path.relative_to(workspace).as_posix(): blob(path.read_bytes())
                         for path in (workspace / 'lib').rglob('*.dart')}
    report.update(packages=packages, replaced_media_overrides=previous,
                  application_blobs=application_blobs)
    (workspace / RECEIPT).write_text(json.dumps(report, indent=2) + '\n')
    return report


def verify(workspace: Path, *, resolved: bool = True) -> dict:
    build_profile.validate_workspace(workspace)
    report = json.loads(build_profile.safe_path(workspace, RECEIPT).read_text())
    if report['recipe_sha256'] != sha256((workspace / 'tool/ohos/media_backend.json').read_bytes()):
        raise RuntimeError('Media recipe changed after export')
    for name, identity in report['source_blobs'].items():
        if blob(build_profile.safe_path(workspace / SNAPSHOT, name).read_bytes()) != identity:
            raise RuntimeError(f'Media SDK source changed after export: {name}')
    for name, identity in report['application_blobs'].items():
        if blob(build_profile.safe_path(workspace, name).read_bytes()) != identity:
            raise RuntimeError(f'Prepared application source changed: {name}')
    if native_inputs() != report['native']:
        raise RuntimeError('Native inputs changed after preparation')
    for name in ('lib/main.dart', 'lib/pages/audio/controller.dart', *report['direction_b']['files']):
        text = build_profile.safe_path(workspace, name).read_text()
        if 'backend is deferred' in text or '当前 OHOS 开发构建暂未接入播放后端' in text or 'OHOS backend deferred' in text:
            raise RuntimeError(f'Media-deferred guard remains in {name}')
    if 'MediaKit.ensureInitialized();' not in (workspace / 'lib/main.dart').read_text():
        raise RuntimeError('The actual application entrypoint does not initialize media-kit')
    checked = []
    if resolved:
        path = build_profile.safe_path(workspace, '.dart_tool/package_config.json')
        packages = {item['name']: item for item in json.loads(path.read_text())['packages']}
        for name in recipe(workspace)['required_packages']:
            if name not in packages:
                raise RuntimeError(f'Resolved media package is missing: {name}')
        for name, item in packages.items():
            if not name.startswith('media_kit'):
                continue
            if name not in report['packages']:
                raise RuntimeError(f'Unapproved media package entered the graph: {name}')
            uri = urlparse(urljoin(path.as_uri(), item['rootUri']))
            if uri.scheme != 'file' or Path(unquote(uri.path)).resolve() != (workspace / report['packages'][name]).resolve():
                raise RuntimeError(f'Media package resolves to a stale or external source: {name}')
            checked.append(name)
    return {key: report[key] for key in ('repository', 'branch', 'commit', 'tree', 'recipe_sha256', 'direction_b', 'native')} | {
        'resolved_packages_checked': checked, 'source_files_verified': len(report['source_blobs']),
        'device_verified': False, 'hdr_verified': False}


def verify_hap(workspace: Path, hap: Path) -> dict:
    verify(workspace)
    script = build_profile.safe_path(workspace / SNAPSHOT, 'tool/ohos/verify_hap_native.py')
    spec = importlib.util.spec_from_file_location('current_media_hap_identity', script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    result = module.verify(hap, Path(native_inputs()['library']))
    # Caller has just compiled/inspected the real app's lib/main.dart HAP.
    result.update(scope='PiliPlus-feature-ohos-application-native-identity', applicationPiliPlusBuilt=True)
    return result
