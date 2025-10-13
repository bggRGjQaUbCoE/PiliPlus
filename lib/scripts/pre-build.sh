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
    local applied_project_patches=()
    while IFS= read -r id; do
        [[ -z "$id" ]] && continue
        local file issue_link
        file=$(jq -r ".patches.\"$id\".file" "$config")
        issue_link=$(jq -r ".patches.\"$id\".issue_link // empty" "$config")
        cd "$PROJECT_ROOT"
        if git apply "$patch_dir/$file" 2>/dev/null; then
            echo "$file applied to project${issue_link:+ ($issue_link)}"
            applied_project_patches+=("$file")
        fi
    done < <(jq -r "((.platform.common.project_patches + .platform.\"$platform\".project_patches) // [])[]" "$config")

    cd "$flutter_root"

    local flutter_head
    flutter_head=$(git rev-parse HEAD)

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
    done < <(jq -r "((.platform.common.picks + .platform.\"$platform\".picks) // [])[]" "$config")

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
    done < <(jq -r "((.platform.common.reverts + .platform.\"$platform\".reverts) // [])[]" "$config")

    # common + platform-specific patches
    while IFS= read -r id; do
        [[ -z "$id" ]] && continue
        local file issue_link
        file=$(jq -r ".patches.\"$id\".file" "$config")
        issue_link=$(jq -r ".patches.\"$id\".issue_link // empty" "$config")
        if git apply "$patch_dir/$file" 2>/dev/null; then
            echo "$file applied to Flutter SDK${issue_link:+ ($issue_link)}"
        fi
    done < <(jq -r "((.platform.common.patches + .platform.\"$platform\".patches) // [])[]" "$config")

    # Flutter engine version
    local saved_engine_version=""
    local engine_version
    engine_version=$(jq -r ".platform.\"$platform\".engine_version.key // empty" "$config")

    if [[ -n "$engine_version" ]]; then
        local engine_ver_path="$flutter_root/bin/internal/engine.version"
        [[ -f "$engine_ver_path" ]] && saved_engine_version=$(cat "$engine_ver_path")
        echo "$engine_version" > "$engine_ver_path"
        rm -rf "$flutter_root/bin/cache"
        flutter --version 2>/dev/null || true
    fi

    local project_patches_json="[]"
    if [[ ${#applied_project_patches[@]} -gt 0 ]]; then
        project_patches_json=$(printf '%s\n' "${applied_project_patches[@]}" | jq -R . | jq -sc .)
    fi

    jq -n \
        --arg status "patched" \
        --arg platform "$platform" \
        --arg patches_hash "$(sha256sum "$config" | cut -d' ' -f1)" \
        --arg flutter_head "$flutter_head" \
        --arg engine_version "$saved_engine_version" \
        --argjson snapshot_time "$(date +%s)" \
        --argjson project_patches "$project_patches_json" \
        '{status: $status, platform: $platform, patches_hash: $patches_hash, flutter_head: $flutter_head, engine_version: $engine_version, snapshot_time: $snapshot_time, project_patches: $project_patches}' \
        > "$state_file"
}

gen_build_info() {
    local platform=""
    local ci=false
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --ci) ci=true; shift ;;
            --platform) platform="$2"; shift 2 ;;
            *) echo "Unknown option: $1" >&2; exit 1 ;;
        esac
    done

    local version_name=""
    local version_code=""
    local commit_hash=""
    local build_time=""

    version_code=$(git rev-list --count HEAD | tr -d '[:space:]')
    commit_hash=$(git rev-parse HEAD | tr -d '[:space:]')

    if grep -qE '^[[:space:]]*version:[[:space:]]*([0-9.]+)' pubspec.yaml; then
        version_name=$(grep -E '^[[:space:]]*version:[[:space:]]*([0-9.]+)' pubspec.yaml | head -n1 | sed -E 's/^[[:space:]]*version:[[:space:]]*([0-9.]+).*/\1/')
        if [[ "$platform" == "android" ]]; then
            version_name="${version_name}-${commit_hash:0:9}"
        fi

        if $ci; then
            awk -v verName="$version_name" -v verCode="$version_code" '
                /^[[:space:]]*version:[[:space:]]*[0-9.]+/ {
                    print "version: " verName "+" verCode
                    next
                }
                { print }
            ' pubspec.yaml > pubspec.yaml.tmp && mv pubspec.yaml.tmp pubspec.yaml
        fi
    else
        echo "Prebuild Error: version not found" >&2
        exit 1
    fi

    build_time=$(date +%s)
    jq -n \
        --arg name "$version_name" \
        --arg code "$version_code" \
        --arg hash "$commit_hash" \
        --arg time "$build_time" \
        '{ "pili.name": $name, "pili.code": $code, "pili.hash": $hash, "pili.time": ($time|tonumber) }' \
        > pili_release.json

    if [[ -n "${GITHUB_ENV:-}" ]]; then
        echo "version=${version_name}+${version_code}" >> "$GITHUB_ENV"
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
