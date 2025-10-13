#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

find_flutter_root() {
    if [[ -n "${FLUTTER_ROOT:-}" ]]; then
        echo "$FLUTTER_ROOT"
    elif [[ -L "$PROJECT_ROOT/.fvm/flutter_sdk" ]]; then
        realpath "$PROJECT_ROOT/.fvm/flutter_sdk"
    else
        echo "Error: cannot locate Flutter SDK" >&2
        exit 1
    fi
}

flutter_root=$(find_flutter_root)

state_file="$PROJECT_ROOT/.dart_tool/.patch_state.json"

if [[ ! -f "$state_file" ]]; then
    echo "Warning: no patch state found, nothing to restore" >&2
    exit 0
fi

state_status=$(jq -r '.status // "clean"' "$state_file")
if [[ "$state_status" != "patched" ]]; then
    echo "Warning: patch state is '$state_status', nothing to restore" >&2
    exit 0
fi

saved_head=$(jq -r '.flutter_head // ""' "$state_file")

cd "$flutter_root"
if git reset --hard "$saved_head" 2>/dev/null; then
    echo "Flutter SDK restored to ${saved_head:0:12}"
else
    echo "Warning: failed to reset to $saved_head, resetting to HEAD" >&2
    git reset --hard HEAD
fi

saved_engine=$(jq -r '.engine_version // ""' "$state_file")
if [[ -n "$saved_engine" ]]; then
    echo "$saved_engine" > "$flutter_root/bin/internal/engine.version"
    echo "engine.version restored"
fi

patch_dir="$PROJECT_ROOT/lib/scripts"

while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    cd "$PROJECT_ROOT"
    if git apply -R "$patch_dir/$file" 2>/dev/null; then
        echo "$file reverted"
    fi
done < <(jq -r '.project_patches[] // empty' "$state_file")

rm -f "$state_file" "$PROJECT_ROOT/pili_release.json"
echo "pili_release.json removed"
