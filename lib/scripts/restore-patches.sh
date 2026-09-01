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

# A patched pub package in cache is no longer pristine; delete the cached copies
# so the next apply re-downloads clean ones via pub get. Package names are read
# dynamically from the state file (pub_packages), not hardcoded.
restore_pub_packages() {
    local platform="$1"
    local pub_cache
    if [[ "$platform" == "windows" ]]; then
        pub_cache="${LOCALAPPDATA:-$HOME/AppData/Local}/Pub/Cache"
    else
        pub_cache="${PUB_CACHE:-$HOME/.pub-cache}"
    fi
    local hosted="$pub_cache/hosted"
    local dir name
    while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        dir=$(find "$hosted" -maxdepth 3 -type d -name "$name-*" 2>/dev/null | tail -n1 || true)
        if [[ -n "$dir" ]]; then
            rm -rf "$dir"
            echo "Removed cached $name: $dir"
            restored_any_pub=1
        fi
    done < <(jq -r '.pub_packages? // [] | .[]' "$state_file" 2>/dev/null) || true
}

platform=$(jq -r '.platform // ""' "$state_file")

restored_any_pub=0
if [[ -n "$platform" ]]; then
    restore_pub_packages "$platform"
fi

# Deleting the patched pub packages above left their cache dirs (and the
# package_config entries pointing at them) dangling, so re-resolve dependencies
# to pull down pristine copies again. This keeps the project analysable/launchable
# right after restore instead of surfacing ~27K resolution errors.
if [[ "$restored_any_pub" == "1" ]]; then
    if ( cd "$PROJECT_ROOT" && flutter pub get >/dev/null 2>&1 ); then
        echo "Restored pristine pub packages via flutter pub get"
    else
        echo "Warning: flutter pub get failed after restoring patches" >&2
    fi
fi

rm -f "$state_file" "$PROJECT_ROOT/pili_release.json"
echo "pili_release.json removed"
