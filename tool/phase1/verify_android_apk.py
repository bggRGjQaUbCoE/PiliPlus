import argparse
import zipfile
from pathlib import Path

parser = argparse.ArgumentParser(description='Reject APKs missing Flutter Android plugin registration.')
parser.add_argument('apk', type=Path)
args = parser.parse_args()
with zipfile.ZipFile(args.apk) as apk:
    if apk.testzip() is not None:
        raise SystemExit('APK_REGISTRANT FAIL invalid ZIP CRC')
    marker = b'Lio/flutter/plugins/GeneratedPluginRegistrant;'
    present = any(marker in apk.read(name) for name in apk.namelist()
                  if name.startswith('classes') and name.endswith('.dex'))
    if not present:
        print('APK_REGISTRANT FAIL missing io.flutter.plugins.GeneratedPluginRegistrant')
        raise SystemExit(1)
print('APK_REGISTRANT PASS io.flutter.plugins.GeneratedPluginRegistrant present')
