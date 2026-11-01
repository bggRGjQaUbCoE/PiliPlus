"""Prepare a relocatable Flutter bundle without replacing GTK's core runtime."""
from pathlib import Path
import argparse
import subprocess


def prepare(bundle: Path, patchelf: str):
    # These libraries belong to the host GTK/C++ runtime. Shipping older copies
    # can hide symbols required by the system WebKit, Pango and GLib libraries.
    for pattern in ('libglib-2.0.so*', 'libfontconfig.so*', 'libpcre2-8.so*',
                    'libstdc++.so*', 'libgcc_s.so*', 'libasound.so*'):
        for library in (bundle / 'lib').glob(pattern):
            library.unlink()
    subprocess.run([patchelf, '--set-rpath', '$ORIGIN/lib:$ORIGIN',
                    str(bundle / 'piliplus')], check=True)
    for library in (bundle / 'lib').rglob('*.so*'):
        if library.is_file() and not library.is_symlink() and library.name != 'libapp.so':
            # Flutter installs plugin files directly, so CMake does not replace
            # their build RPATH with INSTALL_RPATH during bundle installation.
            subprocess.run([patchelf, '--set-rpath', '$ORIGIN', str(library)], check=True)
    result = subprocess.run(['ldd', '-r', str(bundle / 'piliplus')],
                            capture_output=True, text=True)
    diagnostics = result.stdout + result.stderr
    errors = [line for line in diagnostics.splitlines()
              if any(term in line for term in ('not found', 'undefined symbol',
                                               'no version information'))]
    if result.returncode or errors:
        raise RuntimeError('Linux runtime verification failed:\n' + diagnostics)
    print('Linux bundle dependencies and symbol relocations verified')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('bundle', type=Path)
    parser.add_argument('--patchelf', default='patchelf')
    args = parser.parse_args()
    prepare(args.bundle.resolve(), args.patchelf)
