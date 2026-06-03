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

apply_patches() {
    local platform=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --platform) platform="$2"; shift 2 ;;
            *) echo "Unknown option: $1" >&2; exit 1 ;;
        esac
    done
    if [[ -z "$platform" ]]; then
        echo "Error: --platform is required" >&2
        exit 1
    fi

    local flutter_root
    flutter_root=$(find_flutter_root)

    local config="$PROJECT_ROOT/lib/scripts/patches.json"
    local state_file="$PROJECT_ROOT/.dart_tool/.patch_state.json"
    local patch_dir="$PROJECT_ROOT/lib/scripts"

    mkdir -p "$PROJECT_ROOT/.dart_tool"

    if [[ -f "$state_file" ]]; then
        local prev_status prev_platform prev_hash
        prev_status=$(jq -r '.status // "clean"' "$state_file")
        prev_platform=$(jq -r '.platform // ""' "$state_file")
        prev_hash=$(jq -r '.patches_hash // ""' "$state_file")
        if [[ "$prev_status" == "patched" ]]; then
            local current_hash
            current_hash=$(sha256sum "$config" | cut -d' ' -f1)
            if [[ "$prev_platform" == "$platform" && "$prev_hash" == "$current_hash" ]]; then
                echo "Patches already applied and up-to-date, skipping"
                return 0
            fi
            echo "Error: patches already applied with different config (run restore-patches first)" >&2
            exit 1
        fi
    fi

    # project-level patches (applied before entering Flutter SDK)
    while IFS= read -r id; do
        [[ -z "$id" ]] && continue
        local file issue_link
        file=$(jq -r ".patches.\"$id\".file" "$config")
        issue_link=$(jq -r ".patches.\"$id\".issue_link // empty" "$config")
        cd "$PROJECT_ROOT"
        if git apply "$patch_dir/$file" 2>/dev/null; then
            echo "$file applied to project${issue_link:+ ($issue_link)}"
        fi
    done < <(jq -r "(.platforms.\"$platform\".project_patches // [])[]" "$config")

    cd "$flutter_root"

    local flutter_head
    flutter_head=$(git rev-parse HEAD)

    local saved_engine_version=""
    local engine_key
    engine_key=$(jq -r ".platforms.\"$platform\".engine_override // empty" "$config")
    if [[ -n "$engine_key" ]]; then
        local engine_ver_path="$flutter_root/bin/internal/engine.version"
        if [[ -f "$engine_ver_path" ]]; then
            saved_engine_version=$(cat "$engine_ver_path")
        fi
    fi

    git config user.name "ci" 2>/dev/null || true
    git config user.email "example@example.com" 2>/dev/null || true
    git reset --hard HEAD

    # picks (cherry-pick commits)
    while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        local hash issue_link
        hash=$(jq -r ".commits.\"$name\".hash" "$config")
        issue_link=$(jq -r ".commits.\"$name\".issue_link // empty" "$config")
        if git stash 2>/dev/null; then
            if git cherry-pick "$hash" --no-edit 2>/dev/null; then
                git reset --soft HEAD~1
                echo "cherry-pick ${hash:0:9} ($name) applied to Flutter SDK${issue_link:+ ($issue_link)}"
            fi
            git stash pop 2>/dev/null || true
        fi
    done < <(jq -r "(.platforms.\"$platform\".picks // [])[]" "$config")

    # reverts
    while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        local hash issue_link
        hash=$(jq -r ".commits.\"$name\".hash" "$config")
        issue_link=$(jq -r ".commits.\"$name\".issue_link // empty" "$config")
        if git stash 2>/dev/null; then
            if git revert "$hash" --no-edit 2>/dev/null; then
                git reset --soft HEAD~1
                echo "revert ${hash:0:9} ($name) applied to Flutter SDK${issue_link:+ ($issue_link)}"
            fi
            git stash pop 2>/dev/null || true
        fi
    done < <(jq -r "(.platforms.\"$platform\".reverts // [])[]" "$config")

    # common patches + platform-specific patches
    while IFS= read -r id; do
        [[ -z "$id" ]] && continue
        local file issue_link
        file=$(jq -r ".patches.\"$id\".file" "$config")
        issue_link=$(jq -r ".patches.\"$id\".issue_link // empty" "$config")
        if git apply "$patch_dir/$file" 2>/dev/null; then
            echo "$file applied to Flutter SDK${issue_link:+ ($issue_link)}"
        fi
    done < <(jq -r '.common_patches[]' "$config"; jq -r "(.platforms.\"$platform\".patches // [])[]" "$config")

    # Flutter engine version
    local engine_key
    engine_key=$(jq -r ".platforms.\"$platform\".engine_override // empty" "$config")
    if [[ -n "$engine_key" ]]; then
        local engine_version
        engine_version=$(jq -r ".engine_overrides.\"$engine_key\".version" "$config")
        echo "$engine_version" > "$flutter_root/bin/internal/engine.version"
        rm -rf "$flutter_root/bin/cache"
        flutter --version 2>/dev/null || true
    fi

    jq -n \
        --arg status "patched" \
        --arg platform "$platform" \
        --arg patches_hash "$(sha256sum "$config" | cut -d' ' -f1)" \
        --arg flutter_head "$flutter_head" \
        --arg engine_version "$saved_engine_version" \
        --argjson snapshot_time "$(date +%s)" \
        '{status: $status, platform: $platform, patches_hash: $patches_hash, flutter_head: $flutter_head, engine_version: $engine_version, snapshot_time: $snapshot_time}' \
        > "$state_file"
}

resolve_last_tag() {
    local tag

    tag=$(git describe --tags --abbrev=0 --match '[0-9]*' 2>/dev/null || true)
    [[ -n "$tag" ]] && { echo "$tag"; return 0; }

    echo "Warning: No local tags found, fetching from remote..."
    git fetch --tags 2>/dev/null || true
    tag=$(git describe --tags --abbrev=0 --match '[0-9]*' 2>/dev/null || true)
    [[ -n "$tag" ]] && { echo "$tag"; return 0; }

    echo "Warning: Still no tags found, attempting unshallow fetch..."
    git fetch --unshallow 2>/dev/null || true
    tag=$(git describe --tags --abbrev=0 --match '[0-9]*' 2>/dev/null || true)
    [[ -n "$tag" ]] && { echo "$tag"; return 0; }

    return 1
}

gen_build_info() {
    local platform=""
    local ci=false
    local tag=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --ci) ci=true; shift ;;
            --platform) platform="$2"; shift 2 ;;
            --tag) tag="$2"; shift 2 ;;
            *) echo "Unknown option: $1" >&2; exit 1 ;;
        esac
    done

    local base_version=""
    local patch_number=0
    local version_name=""
    local version_code=""
    local commit_hash=""
    local build_time=""
    local source_timestamp=""

    version_code=$(git rev-list --count HEAD | tr -d '[:space:]')
    commit_hash=$(git rev-parse HEAD | tr -d '[:space:]')

    if [[ -n "$tag" ]]; then
        base_version="$tag"
        version_name="$tag"
    else
        if last_tag=$(resolve_last_tag); then
            base_version="$last_tag"
            patch_number=$(git rev-list --count "${last_tag}..HEAD" 2>/dev/null || echo 0)
            version_name="${base_version}.r${patch_number}.g${commit_hash:0:7}"
        elif grep -qE '^[[:space:]]*version:[[:space:]]*([0-9.]+)' pubspec.yaml; then
            echo "Warning: No valid tags found for versioning, fallback to pubspec version."
            base_version=$(grep -E '^[[:space:]]*version:[[:space:]]*([0-9.]+)' pubspec.yaml | head -n1 | sed -E 's/^[[:space:]]*version:[[:space:]]*([0-9.]+).*/\1/')
            version_name="${base_version}-${commit_hash:0:9}"
        else
            echo "Prebuild Error: version not found" >&2
            exit 1
        fi
    fi

    if $ci && [[ "$platform" =~ ^(android|ios|macos)$ ]]; then
        awk -v verName="$version_name" -v verCode="$version_code" '
            /^[[:space:]]*version:[[:space:]]*[0-9.]+/ {
                print "version: " verName "+" verCode
                next
            }
            { print }
        ' pubspec.yaml > pubspec.yaml.tmp && mv pubspec.yaml.tmp pubspec.yaml
    fi

    if $ci; then
        source_timestamp=${SOURCE_DATE_EPOCH:-$(git log -1 --format=%ct)}
    else
        build_time=$(date +%s)
    fi
    jq -n \
        --arg name "$version_name" \
        --arg code "$version_code" \
        --arg hash "$commit_hash" \
        --arg time "${source_timestamp:-$build_time}" \
        --argjson is_ci "$ci" \
        '{ "pili.name": $name, "pili.code": $code, "pili.hash": $hash, "pili.time": ($time|tonumber), "pili.is_ci": $is_ci }' \
        > pili_release.json

    if [[ -n "${GITHUB_ENV:-}" ]]; then
        {
            echo "version_name=${version_name}"
            echo "version_code=${version_code}"
            echo "base_version=${base_version}"
            echo "patch_number=${patch_number}"
        } >> "$GITHUB_ENV"
    fi
}

main() {
    local subcommand="${1:-}"
    shift 2>/dev/null || true

    local fn="${subcommand//-/_}"
    case "$subcommand" in
        apply-patches|gen-build-info)
            "$fn" "$@"
            ;;
        *)
            echo "Usage: $0 {apply-patches|gen-build-info} [options]" >&2
            exit 1
            ;;
    esac
}

main "$@"
