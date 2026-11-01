"""Stage headers and relocatable pkg-config metadata for the pinned libmpv."""
from pathlib import Path
import re
import shutil


def stage(source: Path, output: Path):
    headers = output / 'include/mpv'
    headers.mkdir(parents=True, exist_ok=True)
    for name in ('client.h', 'render.h', 'render_gl.h', 'stream_cb.h'):
        shutil.copy2(source / 'libmpv' / name, headers / name)
    client = (headers / 'client.h').read_text()
    major, minor = re.search(
        r'#define MPV_CLIENT_API_VERSION MPV_MAKE_VERSION\((\d+),\s*(\d+)\)', client
    ).groups()
    metadata = output / 'lib/pkgconfig'
    metadata.mkdir(parents=True, exist_ok=True)
    (metadata / 'mpv.pc').write_text(
        'prefix=${pcfiledir}/../..\n'
        'libdir=${prefix}/lib\n'
        'includedir=${prefix}/include\n\n'
        'Name: mpv\nDescription: Bundled capture-capable libmpv\n'
        f'Version: {major}.{minor}.0\n'
        'Libs: -L${libdir} -Wl,-rpath-link,${libdir} -lmpv\n'
        'Cflags: -I${includedir}\n'
    )
