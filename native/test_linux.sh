#!/usr/bin/env bash
set -euo pipefail

export PKG_CONFIG_PATH="$PWD/native/artifacts/linux/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
event_source=$(python3 - <<'PY'
import json
from pathlib import Path
from urllib.parse import urljoin, urlparse, unquote
config = Path('.dart_tool/package_config.json').resolve()
packages = json.loads(config.read_text())['packages']
package = next(p for p in packages if p['name'] == 'media_kit_native_event_loop')
print(unquote(urlparse(urljoin(config.as_uri(), package['rootUri'])).path) + '/linux')
PY
)
cmake -S "$event_source" -B native/build/test-event-loop \
  -DMEDIA_KIT_LIBS_AVAILABLE=ON -DCMAKE_BUILD_TYPE=Release
cmake --build native/build/test-event-loop --parallel 2
export LD_LIBRARY_PATH="$PWD/native/build/test-event-loop/shared:${LD_LIBRARY_PATH:-}"
flutter test --no-pub test/player/animated_capture_test.dart \
  test/player/capture_aspect_ratio_test.dart \
  test/player/capture_time_controls_test.dart \
  test/player/animation_export_integration_test.dart
