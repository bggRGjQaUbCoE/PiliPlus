#!/usr/bin/env bash
set -u
set -o pipefail

mkdir -p runtime-smoke/evidence

status=0
apk="$(find runtime-smoke/apk -type f -name "*.apk" | head -n 1 || true)"
screenshot="runtime-smoke/evidence/screenshot.png"
ui_dump_device="/sdcard/window_dump.xml"
ui_dump="runtime-smoke/evidence/uiautomator.xml"
filtered_logcat="runtime-smoke/evidence/logcat-crash-error.txt"
app_crash_logcat="runtime-smoke/evidence/app-crash-error.txt"
blankness_report="runtime-smoke/evidence/screenshot-blankness.txt"

record_status() {
  echo "status=${status}" | tee -a runtime-smoke/evidence/status.txt
  case "$status" in
    0) echo "result=pass" ;;
    10) echo "result=fail reason=no_apk_found" ;;
    20) echo "result=fail reason=adb_install_failed" ;;
    30) echo "result=fail reason=launcher_start_failed" ;;
    40) echo "result=fail reason=process_not_running" ;;
    50) echo "result=fail reason=uiautomator_dump_failed" ;;
    60) echo "result=fail reason=crash_or_anr_in_logcat" ;;
    70) echo "result=fail reason=uiautomator_xml_missing" ;;
    80) echo "result=fail reason=screenshot_blank_or_invalid" ;;
    90) echo "result=fail reason=startup_failure_ui_visible" ;;
    100) echo "result=fail reason=app_not_foreground" ;;
    110) echo "result=fail reason=uiautomator_xml_missing_app_package" ;;
    *) echo "result=fail reason=unknown_status" ;;
  esac | tee -a runtime-smoke/evidence/status.txt
}

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
  status=10
  record_status
  exit "$status"
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
grep -Ei "FATAL EXCEPTION|AndroidRuntime|CRASH|ANR|Watchdog|(^|[[:space:]])[EF]/|(^|[[:space:]])[EF][[:space:]]+[[:alnum:]_.-]+[[:space:]]*:" runtime-smoke/evidence/logcat.txt > "$filtered_logcat" || true
python3 - runtime-smoke/evidence/logcat.txt "$app_crash_logcat" "$PACKAGE_NAME" <<'PY' || true
import re
import sys

logcat_path, app_crash_path, package_name = sys.argv[1:4]
lines = []

try:
    with open(logcat_path, "r", encoding="utf-8", errors="replace") as handle:
        lines = handle.readlines()
except OSError as exc:
    with open(app_crash_path, "w", encoding="utf-8") as handle:
        handle.write(f"logcat_read_error={exc}\n")
    sys.exit(0)

crash_blocks = []
line_count = len(lines)

for index, line in enumerate(lines):
    if f"ANR in {package_name}" in line:
        crash_blocks.append(lines[index:index + 40])
    elif f"Process {package_name} has died" in line:
        crash_blocks.append(lines[index:index + 20])
    elif "Force finishing activity" in line and package_name in line:
        crash_blocks.append(lines[index:index + 20])
    elif "FATAL EXCEPTION" in line:
        block = lines[index:min(line_count, index + 80)]
        if any(re.search(rf"\bProcess:\s*{re.escape(package_name)}\b", entry) for entry in block):
            crash_blocks.append(block)

with open(app_crash_path, "w", encoding="utf-8") as handle:
    for block_index, block in enumerate(crash_blocks, 1):
        handle.write(f"--- app-crash-block-{block_index} ---\n")
        handle.writelines(block)
PY
adb shell dumpsys window > runtime-smoke/evidence/window.txt || true
if adb shell uiautomator dump "$ui_dump_device" > runtime-smoke/evidence/uiautomator-dump.txt 2>&1; then
  adb pull "$ui_dump_device" "$ui_dump" > runtime-smoke/evidence/uiautomator-pull.txt 2>&1 || true
else
  status=50
fi
adb exec-out screencap -p > "$screenshot" || true

if [ "$status" -eq 0 ]; then
  if [ -s "$app_crash_logcat" ]; then
    status=60
  fi
fi

if [ "$status" -eq 0 ]; then
  if [ ! -s "$ui_dump" ]; then
    status=70
  elif grep -Fq "Startup failed" "$ui_dump"; then
    status=90
  elif ! grep -Fq "package=\"${PACKAGE_NAME}\"" "$ui_dump"; then
    status=110
  fi
fi

if [ "$status" -eq 0 ]; then
  if ! grep -Eq "mCurrentFocus=.*${PACKAGE_NAME}|currentFocus=.*${PACKAGE_NAME}" runtime-smoke/evidence/window.txt; then
    status=100
  fi
fi

if [ "$status" -eq 0 ]; then
  if ! python3 - "$screenshot" "$blankness_report" <<'PY'; then
import struct
import sys
import zlib

png_path, report_path = sys.argv[1], sys.argv[2]


def fail(message, code=1, details=None):
    with open(report_path, "w", encoding="utf-8") as handle:
        handle.write(f"blankness_status=fail\nreason={message}\n")
        if details:
            for key, value in details.items():
                handle.write(f"{key}={value}\n")
    sys.exit(code)


def read_png_rgba(path):
    with open(path, "rb") as handle:
        data = handle.read()
    if not data.startswith(b"\x89PNG\r\n\x1a\n"):
        fail("screenshot is not a png")

    pos = 8
    width = height = color_type = bit_depth = None
    compressed = bytearray()

    while pos + 8 <= len(data):
        length = struct.unpack(">I", data[pos:pos + 4])[0]
        chunk_type = data[pos + 4:pos + 8]
        chunk_data = data[pos + 8:pos + 8 + length]
        pos += 12 + length

        if chunk_type == b"IHDR":
            width, height, bit_depth, color_type = struct.unpack(">IIBB", chunk_data[:10])
        elif chunk_type == b"IDAT":
            compressed.extend(chunk_data)
        elif chunk_type == b"IEND":
            break

    if not width or not height or not compressed:
        fail("screenshot png is missing image data")
    if bit_depth != 8 or color_type not in (2, 6):
        fail("unsupported png format", details={"bit_depth": bit_depth, "color_type": color_type})

    channels = 4 if color_type == 6 else 3
    row_len = width * channels
    try:
        raw = zlib.decompress(bytes(compressed))
    except zlib.error as exc:
        fail("screenshot png could not be decompressed", details={"zlib_error": exc})

    rows = []
    src = 0
    prev = bytearray(row_len)
    for _ in range(height):
        if src + 1 + row_len > len(raw):
            fail("screenshot png has truncated pixel data")
        filter_type = raw[src]
        src += 1
        row = bytearray(raw[src:src + row_len])
        src += row_len

        for i in range(row_len):
            left = row[i - channels] if i >= channels else 0
            up = prev[i]
            up_left = prev[i - channels] if i >= channels else 0
            if filter_type == 1:
                row[i] = (row[i] + left) & 0xff
            elif filter_type == 2:
                row[i] = (row[i] + up) & 0xff
            elif filter_type == 3:
                row[i] = (row[i] + ((left + up) // 2)) & 0xff
            elif filter_type == 4:
                p = left + up - up_left
                pa = abs(p - left)
                pb = abs(p - up)
                pc = abs(p - up_left)
                predictor = left if pa <= pb and pa <= pc else up if pb <= pc else up_left
                row[i] = (row[i] + predictor) & 0xff
            elif filter_type != 0:
                fail("screenshot png uses an unknown filter", details={"filter_type": filter_type})
        rows.append(row)
        prev = row

    return width, height, channels, rows


width, height, channels, rows = read_png_rgba(png_path)
sample_step = max(1, min(width, height) // 120)
samples = 0
bright_samples = 0
near_white_samples = 0
dark_samples = 0
sum_luma = 0.0
sum_sq_luma = 0.0

for y in range(0, height, sample_step):
    row = rows[y]
    for x in range(0, width, sample_step):
        idx = x * channels
        red, green, blue = row[idx], row[idx + 1], row[idx + 2]
        luma = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        samples += 1
        sum_luma += luma
        sum_sq_luma += luma * luma
        if luma >= 245:
            bright_samples += 1
        if red >= 245 and green >= 245 and blue >= 245:
            near_white_samples += 1
        if luma <= 30:
            dark_samples += 1

mean_luma = sum_luma / samples
variance = max(0.0, (sum_sq_luma / samples) - (mean_luma * mean_luma))
stddev_luma = variance ** 0.5
bright_ratio = bright_samples / samples
near_white_ratio = near_white_samples / samples
dark_ratio = dark_samples / samples

details = {
    "width": width,
    "height": height,
    "samples": samples,
    "mean_luma": f"{mean_luma:.2f}",
    "stddev_luma": f"{stddev_luma:.2f}",
    "bright_ratio": f"{bright_ratio:.4f}",
    "near_white_ratio": f"{near_white_ratio:.4f}",
    "dark_ratio": f"{dark_ratio:.4f}",
}

with open(report_path, "w", encoding="utf-8") as handle:
    handle.write("blankness_status=pass\n")
    for key, value in details.items():
        handle.write(f"{key}={value}\n")

if mean_luma >= 245 and stddev_luma <= 3 and near_white_ratio >= 0.98:
    fail("screenshot is blank white", details=details)
if stddev_luma <= 1 and (bright_ratio >= 0.98 or dark_ratio >= 0.98):
    fail("screenshot is visually blank", details=details)
PY
    status=80
  fi
fi

if [ "$status" -eq 0 ]; then
  if ! adb shell pidof "$PACKAGE_NAME" | tee runtime-smoke/evidence/pidof.txt; then
    status=40
  fi
fi

record_status
exit "$status"
