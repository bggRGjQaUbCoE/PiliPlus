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
launcher_component_file="runtime-smoke/evidence/launcher-component.txt"
launcher_resolution_file="runtime-smoke/evidence/launcher-resolution.txt"
max_system_dialog_retries=2
max_scenario_swipes=6

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
    120) echo "result=fail reason=launcher_activity_not_found" ;;
    130) echo "result=fail reason=runtime_scenario_failed" ;;
    *) echo "result=fail reason=unknown_status" ;;
  esac | tee -a runtime-smoke/evidence/status.txt
}

start_launcher_component() {
  local attempt="$1"
  echo "launch_attempt=${attempt}" >> runtime-smoke/evidence/adb-launch.txt
  adb shell am start -W -n "$launcher_component" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER | tee -a runtime-smoke/evidence/adb-launch.txt
}

capture_runtime_evidence() {
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
    return 50
  fi
  adb exec-out screencap -p > "$screenshot" || true
}

app_package_is_visible() {
  [ -s "$ui_dump" ] && grep -Fq "package=\"${PACKAGE_NAME}\"" "$ui_dump"
}

app_has_current_focus() {
  grep -Eq "mCurrentFocus=.*${PACKAGE_NAME}|currentFocus=.*${PACKAGE_NAME}" runtime-smoke/evidence/window.txt
}

has_retryable_system_anr_dialog() {
  if [ -s "$app_crash_logcat" ]; then
    return 1
  fi
  if [ ! -s "$ui_dump" ]; then
    return 1
  fi
  if grep -Fq "$PACKAGE_NAME" "$ui_dump" && grep -Eq "ANR in ${PACKAGE_NAME}|Application Error: ${PACKAGE_NAME}" runtime-smoke/evidence/window.txt; then
    return 1
  fi
  if ! grep -Eiq "isn'?t responding|is not responding|Application Not Responding|ANR" "$ui_dump" runtime-smoke/evidence/window.txt; then
    return 1
  fi
  grep -Eiq "com\.google\.android\.apps\.nexuslauncher|com\.android\.launcher|com\.android\.systemui|Pixel Launcher|Launcher|System UI" "$ui_dump" runtime-smoke/evidence/window.txt
}

dismiss_system_anr_dialog() {
  local retry="$1"
  local preferred_button="android:id/aerr_wait"
  if [ "$retry" -gt 1 ]; then
    preferred_button="android:id/aerr_close"
  fi

  if [ -s "$ui_dump" ]; then
    tap_coords="$(python3 - "$ui_dump" "$preferred_button" <<'PY' || true
import re
import sys
import xml.etree.ElementTree as ET

path, preferred_button = sys.argv[1:3]
try:
    root = ET.parse(path).getroot()
except ET.ParseError:
    sys.exit(0)

for node in root.iter("node"):
    resource_id = node.attrib.get("resource-id", "")
    if resource_id != preferred_button:
        continue
    match = re.fullmatch(r"\[(\d+),(\d+)\]\[(\d+),(\d+)\]", node.attrib.get("bounds", ""))
    if not match:
        continue
    left, top, right, bottom = map(int, match.groups())
    print(f"{(left + right) // 2} {(top + bottom) // 2}")
    break
PY
)"
    if [ -n "${tap_coords:-}" ]; then
      echo "dismiss_system_anr_dialog_button=${preferred_button}" >> runtime-smoke/evidence/adb-launch.txt
      adb shell input tap $tap_coords >> runtime-smoke/evidence/adb-launch.txt 2>&1 || true
      sleep 2
      return
    fi
  fi
  echo "dismiss_system_anr_dialog_button=KEYCODE_BACK" >> runtime-smoke/evidence/adb-launch.txt
  adb shell input keyevent KEYCODE_BACK >> runtime-smoke/evidence/adb-launch.txt 2>&1 || true
  sleep 2
}

retry_after_system_dialog_if_needed() {
  local retries=0

  while [ "$retries" -lt "$max_system_dialog_retries" ]; do
    if app_package_is_visible && app_has_current_focus; then
      return 0
    fi
    if ! has_retryable_system_anr_dialog; then
      return 0
    fi

    retries=$((retries + 1))
    echo "retryable_system_anr_dialog_attempt=${retries}" >> runtime-smoke/evidence/adb-launch.txt
    dismiss_system_anr_dialog "$retries"
    if ! start_launcher_component "retry-${retries}"; then
      status=30
      return 0
    fi
    sleep 25
    if ! capture_runtime_evidence; then
      status=50
      return 0
    fi
  done
}

# --- scenario UI helpers ---------------------------------------------------
dump_ui_to() {
  local dest="$1"
  local device_path="/sdcard/scenario_dump.xml"
  if adb shell uiautomator dump "$device_path" > /dev/null 2>&1; then
    adb pull "$device_path" "$dest" > /dev/null 2>&1 || return 1
    return 0
  fi
  return 1
}

swipe_vertical() {
  local direction="${1:-up}"
  local count="${2:-1}"
  local i
  for i in $(seq 1 "$count"); do
    if [ "$direction" = "up" ]; then
      adb shell input swipe 540 1600 540 600 300 || true
    else
      adb shell input swipe 540 600 540 1600 300 || true
    fi
    sleep 2
  done
}

find_nodes_by_text() {
  local dump_file="$1"
  local out_file="$2"
  shift 2
  python3 - "$dump_file" "$out_file" "$@" <<'PY'
import re
import sys
import xml.etree.ElementTree as ET

dump_path, out_path = sys.argv[1], sys.argv[2]
patterns = sys.argv[3:]
pattern_priority = {pat: idx for idx, pat in enumerate(patterns)}

try:
    root = ET.parse(dump_path).getroot()
except ET.ParseError:
    with open(out_path, "w") as f:
        f.write("# parse_error\n")
    sys.exit(0)

def sanitize(s):
    """Replace CR/LF so records stay on one line; use pilcrow (U+00B6) as placeholder."""
    return s.replace("\r", "\u00b6").replace("\n", "\u00b6")

BOUNDS_RE = re.compile(r"^\[(\d+),(\d+)\]\[(\d+),(\d+)\]$")

results = []
for node in root.iter("node"):
    text = node.attrib.get("text", "")
    content_desc = node.attrib.get("content-desc", "")
    clickable = node.attrib.get("clickable", "false")
    combined = f"{text} {content_desc}"
    for pat in patterns:
        if pat in combined:
            priority = pattern_priority.get(pat, len(patterns))
            bounds_str = node.attrib.get("bounds", "")
            m = BOUNDS_RE.match(bounds_str) if bounds_str else None
            if m:
                left, top, right, bottom = map(int, m.groups())
                cx = (left + right) // 2
                cy = (top + bottom) // 2
                w = right - left
                h = bottom - top
                area = w * h
                # sort key: (pattern_priority, clickable_priority, area)
                click_prio = 0 if clickable == "true" else 1
                results.append((
                    priority, click_prio, area,
                    f"text={sanitize(text)} content_desc={sanitize(content_desc)} "
                    f"matched={sanitize(pat)} priority={priority} bounds={bounds_str} "
                    f"w={w} h={h} area={area} clickable={clickable} cx={cx} cy={cy}"
                ))
            else:
                results.append((
                    priority, 1, sys.maxsize,
                    f"text={sanitize(text)} content_desc={sanitize(content_desc)} "
                    f"matched={sanitize(pat)} priority={priority} bounds=none clickable={clickable} cx=0 cy=0"
                ))

# Sort: higher-priority navigation text first, then clickable nodes, then smallest area.
results.sort(key=lambda x: (x[0], x[1], x[2]))

with open(out_path, "w") as f:
    for _, _, _, line in results:
        f.write(line + "\n")
    if not results:
        f.write("# no_match\n")
PY
}

tap_first_match() {
  local matches_file="$1"
  local nav_log="${2:-}"
  if [ ! -s "$matches_file" ]; then
    return 1
  fi
  local cx cy
  while IFS= read -r line; do
    # skip comment lines
    [[ "$line" =~ ^# ]] && continue
    cx="$(echo "$line" | sed -n 's/.*cx=\([0-9]\+\).*/\1/p')"
    cy="$(echo "$line" | sed -n 's/.*cy=\([0-9]\+\).*/\1/p')"
    # skip malformed lines: require both cx and cy present, and cx != 0
    if [ -n "${cx:-}" ] && [ -n "${cy:-}" ] && [ "$cx" != "0" ]; then
      if [ -n "$nav_log" ]; then
        echo "tap_match=$line" >> "$nav_log"
        echo "tap_coords=${cx},${cy}" >> "$nav_log"
      fi
      adb shell input tap "$cx" "$cy"
      return 0
    fi
  done < "$matches_file"
  return 1
}

check_ui_for_labels() {
  local dump_file="$1"
  local out_file="$2"
  python3 - "$dump_file" "$out_file" <<'PY'
import sys
import xml.etree.ElementTree as ET

dump_path, out_path = sys.argv[1], sys.argv[2]
targets = [
    "标签获取并发数（调试）",
    "标签获取超时（调试）",
    "标签缓存（调试）",
]

try:
    root = ET.parse(dump_path).getroot()
except ET.ParseError:
    with open(out_path, "w") as f:
        f.write("label_check=error\nreason=xml_parse_error\n")
    sys.exit(1)

found = []
for node in root.iter("node"):
    text = node.attrib.get("text", "")
    content_desc = node.attrib.get("content-desc", "")
    combined = f"{text} {content_desc}"
    for t in targets:
        if t in combined:
            found.append(t)

with open(out_path, "w") as f:
    if found:
        f.write(f"label_check=pass\nfound_labels={','.join(found)}\n")
    else:
        f.write("label_check=fail\nreason=no_target_labels_found\n")
PY
  grep -q "label_check=pass" "$out_file"
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
  adb shell cmd activity close-system-dialogs >> runtime-smoke/evidence/adb-launch.txt 2>&1 || true
  adb shell am force-stop "$PACKAGE_NAME" >> runtime-smoke/evidence/adb-launch.txt 2>&1 || true
  if ! launcher_component="$(python3 .github/scripts/android_runtime_smoke_launch.py --package-name "$PACKAGE_NAME" --resolved-output-file "$launcher_resolution_file" 2>> runtime-smoke/evidence/adb-launch.txt)"; then
    status=120
  elif [ -z "$launcher_component" ]; then
    echo "launcher resolution failed: empty component" >> runtime-smoke/evidence/adb-launch.txt
    status=120
  else
    echo "$launcher_component" | tee "$launcher_component_file"
  fi
fi

if [ "$status" -eq 0 ]; then
  if ! start_launcher_component "initial"; then
    status=30
  fi
fi

sleep 25

if [ "$status" -eq 0 ]; then
  if ! capture_runtime_evidence; then
    status=50
  fi
fi

if [ "$status" -eq 0 ]; then
  retry_after_system_dialog_if_needed
fi

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
  elif ! app_package_is_visible; then
    status=110
  fi
fi

if [ "$status" -eq 0 ]; then
  if ! app_has_current_focus; then
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

# --- scenario-specific evidence collection -------------------------------
scenario="${RUNTIME_SMOKE_SCENARIO:-}"
scenario_evidence_dir="runtime-smoke/evidence/scenario"
mkdir -p "$scenario_evidence_dir"

if [ -n "$scenario" ] && [ "$status" -eq 0 ]; then
  echo "scenario=${scenario}" | tee "$scenario_evidence_dir/scenario-metadata.txt"
  echo "package_name=${PACKAGE_NAME:-}" | tee -a "$scenario_evidence_dir/scenario-metadata.txt"
  echo "github_sha=${GITHUB_SHA:-}" | tee -a "$scenario_evidence_dir/scenario-metadata.txt"

  case "$scenario" in
    recommend-detail-tag-shielding)
      echo "Running recommend-detail-tag-shielding scenario — attempting in-app navigation..."

      # Save post-launch evidence for inspection
      cp "$ui_dump" "$scenario_evidence_dir/post-launch-ui.xml" 2>/dev/null || true
      cp "$screenshot" "$scenario_evidence_dir/post-launch-screenshot.png" 2>/dev/null || true

      scenario_success=0
      scenario_nav_attempt=0

      # Step 1: Check if debug labels are already visible post-launch
      if check_ui_for_labels "$ui_dump" "$scenario_evidence_dir/label-check-0.txt"; then
        scenario_success=1
        echo "labels_found=on_launch" >> "$scenario_evidence_dir/navigation-log.txt"
      fi

      # Step 2: If not already visible, attempt navigation via taps and swipes
      if [ "$scenario_success" -eq 0 ]; then
        nav_targets="推荐流设置 设置 我的 推荐流"

        while [ "$scenario_nav_attempt" -lt "$max_scenario_swipes" ]; do
          scenario_nav_attempt=$((scenario_nav_attempt + 1))
          echo "--- scenario navigation attempt ${scenario_nav_attempt} ---" >> "$scenario_evidence_dir/navigation-log.txt"

          current_ui="$scenario_evidence_dir/ui-attempt-${scenario_nav_attempt}.xml"
          if ! dump_ui_to "$current_ui"; then
            echo "ui_dump_failed=true" >> "$scenario_evidence_dir/navigation-log.txt"
            continue
          fi

          # Check if this UI dump reveals the debug labels
          if check_ui_for_labels "$current_ui" "$scenario_evidence_dir/label-check-${scenario_nav_attempt}.txt"; then
            scenario_success=1
            echo "labels_found_at_attempt=${scenario_nav_attempt}" >> "$scenario_evidence_dir/navigation-log.txt"
            break
          fi

          # Search for clickable navigation targets in current UI
          find_nodes_by_text "$current_ui" "$scenario_evidence_dir/matches-${scenario_nav_attempt}.txt" $nav_targets

          if grep -qv '^#' "$scenario_evidence_dir/matches-${scenario_nav_attempt}.txt" 2>/dev/null; then
            if tap_first_match "$scenario_evidence_dir/matches-${scenario_nav_attempt}.txt" "$scenario_evidence_dir/navigation-log.txt"; then
              echo "tapped_navigation_target=true" >> "$scenario_evidence_dir/navigation-log.txt"
              sleep 3
              continue
            fi
            echo "tap_failed=true" >> "$scenario_evidence_dir/navigation-log.txt"
          else
            echo "no_clickable_target=true" >> "$scenario_evidence_dir/navigation-log.txt"
          fi

          # No navigable target found or tap failed — swipe to reveal more UI
          echo "action=swipe_up" >> "$scenario_evidence_dir/navigation-log.txt"
          swipe_vertical "up" 1
          sleep 2
        done
      fi

      # Write final outcome
      if [ "$scenario_success" -eq 1 ]; then
        echo "scenario_outcome=pass" > "$scenario_evidence_dir/scenario-outcome.txt"
        echo "navigation_attempts=${scenario_nav_attempt}" >> "$scenario_evidence_dir/scenario-outcome.txt"
      else
        echo "scenario_outcome=fail" > "$scenario_evidence_dir/scenario-outcome.txt"
        echo "navigation_attempts=${scenario_nav_attempt}" >> "$scenario_evidence_dir/scenario-outcome.txt"
        echo "reason=debug_labels_not_reachable_via_ui_navigation" >> "$scenario_evidence_dir/scenario-outcome.txt"
        status=130
      fi

      echo "--- recommend-detail-tag-shielding scenario outcome ---"
      cat "$scenario_evidence_dir/scenario-outcome.txt" 2>/dev/null || true
      echo "--- scenario navigation log ---"
      cat "$scenario_evidence_dir/navigation-log.txt" 2>/dev/null || true
      echo "--- scenario match summary ---"
      for match_file in "$scenario_evidence_dir"/matches-*.txt; do
        [ -e "$match_file" ] || continue
        echo "### $(basename "$match_file")"
        head -n 5 "$match_file" || true
      done
      ;;
    *)
      echo "Unknown scenario: $scenario" | tee "$scenario_evidence_dir/scenario-error.txt"
      ;;
  esac
fi

record_status
exit "$status"
