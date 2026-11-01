#!/usr/bin/env python3
"""Build the capture-capable media libraries without changing upstream repos."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import urllib.request

ROOT = Path(__file__).resolve().parent
FILTERS = 'trim,setpts,crop,fps,scale,format,setsar,transpose,hflip,vflip,palettegen,paletteuse,movie'
FLAGS = ['--enable-libwebp', '--enable-zlib', '--enable-encoder=gif,png,libwebp,libwebp_anim',
         '--enable-muxer=gif,webp,image2', '--enable-decoder=png',
         '--enable-demuxer=image2,image2pipe', '--enable-filter=' + FILTERS,
         '--enable-protocol=file']


def run(*args, cwd=None, env=None):
    try:
        subprocess.run(args, cwd=cwd, env=env, check=True)
    except subprocess.CalledProcessError:
        if cwd:
            for log in sorted(Path(cwd).glob('build/**/*-err.log')):
                if log.stat().st_size:
                    print(f'\n--- {log.relative_to(cwd)} ---', flush=True)
                    print('\n'.join(log.read_text(errors='replace').splitlines()[-80:]), flush=True)
        raise


def checkout(platform):
    spec = json.loads((ROOT / 'sources.json').read_text())[platform]
    target = ROOT / 'build' / platform
    if not (target / '.git').exists():
        target.mkdir(parents=True, exist_ok=True)
        run('git', 'init', str(target))
        run('git', 'remote', 'add', 'origin', spec['url'], cwd=target)
    ref = spec.get('commit', spec.get('ref'))
    run('git', 'fetch', '--depth=1', 'origin', ref, cwd=target)
    run('git', 'checkout', '--force', 'FETCH_HEAD', cwd=target)
    return target


def patch(platform, source):
    if platform == 'android':
        path = source / 'buildscripts/flavors/default.sh'
        text = path.read_text().replace('--enable-network', ' \\\n\t'.join(FLAGS) + ' \\\n\t--enable-network')
        path.write_text(text)
    elif platform == 'windows':
        path = source / 'packages/ffmpeg.cmake'
        path.write_text(path.read_text().replace('--enable-network', '\n        '.join(FLAGS) + '\n        --enable-network'))
        # Upstream's dated GCC snapshot has expired from the mirror. Use a
        # retained release with the digest published in GCC's sha512.sum.
        path = source / 'toolchain/gcc/gcc.cmake'
        text = re.sub(r'(?m)^    URL .*$',
                      '    URL https://gcc.gnu.org/pub/gcc/releases/gcc-14.3.0/gcc-14.3.0.tar.xz',
                      path.read_text())
        text = re.sub(r'URL_HASH SHA512=\S+',
                      'URL_HASH SHA512=cb4e3259640721bbd275c723fe4df53d12f9b1673afb3db274c22c6aa457865dccf2d6ea20b4fd4c591f6152e6d4b87516c402015900f06ce9d43af66d3b7a93',
                      text)
        path.write_text(text)
        metadata = source / 'Windows.winmd'
        if not metadata.exists():
            urllib.request.urlretrieve(
                'https://raw.githubusercontent.com/microsoft/windows-rs/'
                'ff933fe45cbfdf4a638256181aae26a60932e84e/crates/libs/default/Windows.winmd',
                metadata)
        expected = json.loads((ROOT / 'archives.json').read_text())['Windows.winmd']
        if hashlib.sha256(metadata.read_bytes()).hexdigest() != expected:
            raise RuntimeError('Windows metadata checksum mismatch')
        path = source / 'toolchain/cppwinrt.cmake'
        text = path.read_text().replace(
            'wget -O <BINARY_DIR>/Windows.winmd  https://github.com/microsoft/windows-rs/raw/master/crates/libs/bindgen/default/Windows.winmd',
            f'cmake -E copy "{metadata}" <BINARY_DIR>/Windows.winmd')
        path.write_text(text)
    elif platform in ('ios', 'macos'):
        path = source / 'scripts/ffmpeg/meson.build'
        path.write_text(path.read_text().replace("p = mod.add_project('configure',", "options += [\n" + ''.join("    '" + flag + "',\n" for flag in FLAGS) + "]\n\np = mod.add_project('configure',"))
        # Reuse the upstream cross-toolchain/packaging machinery for libwebp.
        makefile = source / 'Makefile'
        text = makefile.read_text()
        start = text.index('# libvorbis_<')
        end = text.index('# libvpx_<', start)
        rule = text[start:end].replace('libvorbis', 'libwebp')
        rule = rule.replace(' \\\n\t${INTERMEDIATE_DIR}/libogg_$$(word 1,$$(subst -, ,$$*))-$$(word 2,$$(subst -, ,$$*))', '')
        text += '\n' + rule
        for marker in ['${INTERMEDIATE_DIR}/ffmpeg_%: \\\n', '${INTERMEDIATE_DIR}/libs-arch_%: \\\n']:
            text = text.replace(marker, marker + '\t${INTERMEDIATE_DIR}/libwebp_$$(word 1,$$(subst -, ,$$*))-$$(word 2,$$(subst -, ,$$*)) \\\n')
        makefile.write_text(text)
        recipe = source / 'scripts/libwebp'
        recipe.mkdir(exist_ok=True)
        # The release archive ships configure; no autoreconf or host tools leak
        # into a cross build. Pass the same SDK flags as the other dependencies.
        (recipe / 'meson.build').write_text("""project('libwebp', 'c')
mod = import('unstable-external_project')
c = meson.get_compiler('c')
p = mod.add_project('configure', configure_options: [
  '--prefix=@PREFIX@', '--enable-shared', '--disable-static',
  '--enable-libwebpmux', '--disable-libwebpdemux', '--disable-sdl',
  '--disable-png', '--disable-jpeg', '--disable-tiff', '--disable-gif',
], cross_configure_options: [
  '--host=' + (host_machine.cpu_family() == 'aarch64' ? 'aarch64-apple-darwin' : 'x86_64-apple-darwin'),
  'CC=' + ' '.join(c.cmd_array()),
  'CFLAGS=' + ' '.join(get_option('c_args')),
  'LDFLAGS=' + ' '.join(get_option('c_link_args')),
], verbose: true)
""")
        (recipe / 'build.sh').write_text('''#!/bin/sh
set -eu
cd "${SRC_DIR}"
cp "${PROJECT_DIR}/scripts/libwebp/meson.build" .
meson setup build --cross-file "${PROJECT_DIR}/cross-files/${OS}-${ARCH}.ini" --prefix="${OUTPUT_DIR}"
meson compile -C build
meson install -C build
''')
        # The hash is verified by the existing downloads.lock machinery.
        archive = ROOT / 'build/libwebp-1.5.0.tar.gz'
        if not archive.exists():
            urllib.request.urlretrieve('https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.5.0.tar.gz', archive)
        checksum = hashlib.sha256(archive.read_bytes()).hexdigest()
        expected = json.loads((ROOT / 'archives.json').read_text())['libwebp-1.5.0.tar.gz']
        if checksum != expected:
            raise RuntimeError('libwebp archive checksum mismatch')
        with (source / 'downloads.lock').open('a') as f:
            f.write('\nlibwebp:\n  version: 1.5.0\n  url: https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.5.0.tar.gz\n  sha256: ' + checksum + '\n')


def build(platform, source, output):
    if platform == 'android':
        sdk = source / 'buildscripts/sdk/android-sdk-linux'
        sdk.parent.mkdir(exist_ok=True)
        if not sdk.exists(): sdk.symlink_to(os.environ['ANDROID_HOME'])
        run('bash', 'bundle_default.sh', cwd=source / 'buildscripts')
        for path in (source / 'output').glob('*.jar'): shutil.copy2(path, output)
    elif platform in ('ios', 'macos'):
        target = f'build/output/libmpv-xcframeworks_capture_{platform}-universal-video-default.tar.gz'
        run('gmake', 'VERSION=capture', target, cwd=source)
        frameworks = output / 'Frameworks'
        frameworks.mkdir(exist_ok=True)
        run('tar', '-xf', str(source / target), '--strip-components', '1', '-C', str(frameworks))
    elif platform == 'windows':
        # Run in the upstream Arch Linux cross-compiler container.
        run('cmake', '-DTARGET_ARCH=x86_64-w64-mingw32', '-G', 'Ninja', '-B', 'build', '-S', '.', cwd=source)
        run('ninja', '-C', 'build', 'gcc', cwd=source)
        run('ninja', '-C', 'build', 'mpv', cwd=source)
        prefix = source / 'build/install/x86_64-w64-mingw32'
        for path in (prefix / 'bin').glob('*.dll'): shutil.copy2(path, output)
        # The upstream recipe packages libmpv rather than installing it into
        # the toolchain prefix, and adds the build date/commit to its directory.
        packages = list((source / 'build').glob('mpv-dev-*/libmpv-2.dll'))
        if len(packages) != 1:
            raise RuntimeError('Expected one packaged Windows libmpv DLL')
        shutil.copy2(packages[0], output / 'libmpv-2.dll')
        shutil.copytree(packages[0].parent / 'include', output / 'include', dirs_exist_ok=True)
    else:
        run('bash', str(ROOT / 'linux.sh'), str(source), str(output))
        from linux_sdk import stage
        stage(source, output)
    if not any(output.iterdir()): raise RuntimeError('Native build produced no artifacts')
    with (output / 'SHA256SUMS').open('w') as manifest:
        for path in sorted(output.rglob('*')):
            if path.is_file() and path.name != 'SHA256SUMS':
                manifest.write(hashlib.sha256(path.read_bytes()).hexdigest() + '  ' + str(path.relative_to(output)) + '\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('platform', choices=['android', 'ios', 'macos', 'windows', 'linux'])
    args = parser.parse_args()
    src = checkout(args.platform)
    patch(args.platform, src)
    dest = ROOT / 'artifacts' / args.platform
    if dest.exists(): shutil.rmtree(dest)
    dest.mkdir(parents=True)
    build(args.platform, src, dest)
