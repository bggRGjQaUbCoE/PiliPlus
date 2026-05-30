#!/usr/bin/env bash
set -u
set -o pipefail

mkdir -p runtime-smoke/evidence

status=0
apk="$(find runtime-smoke/apk -type f -name "*.apk" | head -n 1 || true)"

{
  echo "artifact_run_id=${ARTIFACT_RUN_ID:-}"
  echo "apk=${apk}"
  echo "package_name=${PACKAGE_NAME:-}"
  echo "github_sha=${GITHUB_SHA:-}"
  echo "github_ref=${GITHUB_REF:-}"
  adb shell getprop ro.build.version.release || true
  adb shell getprop ro.product.model || true
} | tee runtime-smoke/evidence/runtime-smoke-metadata.txt

if [ -z "$apk" ]; then
  echo "No APK found under runtime-smoke/apk" | tee runtime-smoke/evidence/status.txt
  exit 10
fi

adb logcat -c || true

if ! adb install -r "$apk" | tee runtime-smoke/evidence/adb-install.txt; then
  status=20
fi

if [ "$status" -eq 0 ]; then
  if ! adb shell monkey -p "$PACKAGE_NAME" -c android.intent.category.LAUNCHER 1 | tee runtime-smoke/evidence/adb-launch.txt; then
    status=30
  fi
fi

sleep 25

adb logcat -d > runtime-smoke/evidence/logcat.txt || true
adb shell dumpsys window > runtime-smoke/evidence/window.txt || true
adb exec-out screencap -p > runtime-smoke/evidence/screenshot.png || true

if [ "$status" -eq 0 ]; then
  if ! adb shell pidof "$PACKAGE_NAME" | tee runtime-smoke/evidence/pidof.txt; then
    status=40
  fi
fi

echo "status=${status}" | tee -a runtime-smoke/evidence/status.txt
exit "$status"
