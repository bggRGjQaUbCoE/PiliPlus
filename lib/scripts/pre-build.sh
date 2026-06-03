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

find_pub_cache() {
    local platform="$1"
    if [[ "$platform" == "windows" ]]; then
        echo "${LOCALAPPDATA:-$HOME/AppData/Local}/Pub/Cache"
    else
        echo "${PUB_CACHE:-$HOME/.pub-cache}"
    fi
}

# Normalize CRLF -> LF so `git apply` works on files that came from a Windows checkout.
normalize_patch() {
    local file="$1"
    if command -v dos2unix >/dev/null 2>&1; then
        dos2unix -q "$file" 2>/dev/null || true
    else
        sed -i 's/\r$//' "$file" 2>/dev/null || true
    fi
}

# Deterministic hash covering patches.json + all patch file contents.
# Any .patch content change invalidates the cache automatically.
compute_patches_hash() {
    ( git hash-object "$config"
      find "$patch_dir" -name '*.patch' -type f | sort | xargs -r git hash-object
    ) | sort -k1 | sha256sum | cut -d' ' -f1
}

# Resolve pub hosted source subdir from PUB_HOSTED_URL (mirror source) or default
# to the plain pub.dev host.
pubcache_hosted_dir() {
    local pub_cache="$1"
    local host
    if [[ -n "${PUB_HOSTED_URL:-}" ]]; then
        host=$(printf '%s' "$PUB_HOSTED_URL" | sed -E 's|^[a-z]+://||; s|[/:].*||')
        [[ -n "$host" ]] || host='pub.dev'
    else
        host='pub.dev'
    fi
    echo "$pub_cache/hosted/${host}"
}

# Find a pub package dir under the resolved pub cached hosted source.
find_pub_dir() {
    local hosted="$1" pkg="$2"
    find "$hosted" -maxdepth 1 -type d -name "$pkg-*" 2>/dev/null | tail -n1 || true
}

# Apply pub-package patches dynamically. Each patch's target pub package is taken
# from the `package` field in patches.json (e.g. "material_ui", "cupertino_ui"),
# so arbitrary UI/engine pub packages are handled without hardcoding names.
# Every affected package is re-downloaded clean via `flutter pub get` before
# patching, guaranteeing a pristine checkout (conflict-free reapply).
apply_pub_patches() {
    local platform="$1"
    local config="$2"
    local patch_dir="$3"
    local project_root="$4"

    # Collect every patch key for this platform (SDK, pub-package and project
    # patches alike), then keep only those whose `target` is "pub". This is
    # fully dynamic: every value under `platform` is an array of patch keys, so
    # we gather them with `[]` without naming any group, meaning adding a new
    # group to patches.json needs no script change.
    local lines
    lines=$(jq -r --arg plat "$platform" '
        . as $cfg |
        reduce ([ ($cfg.platform.common | to_entries[].value[]),
                  ($cfg.platform[$plat] | to_entries[].value[]) ] | .[]) as $x
          ([]; if index($x) then . else . + [$x] end)[] as $key |
        select($cfg.patches[$key].target == "pub") |
        $key + "\t" + $cfg.patches[$key].package
    ' "$config" 2>/dev/null) || lines=''
    [[ -n "$lines" ]] || return 0

    local pub_cache hosted
    pub_cache=$(find_pub_cache "$platform")
    hosted=$(pubcache_hosted_dir "$pub_cache")

    # Group file lists by package, preserving first-seen order.
    local -A files_by_pkg=()
    local -a pkg_order=()
    local key pkg
    while IFS=$'\t' read -r key pkg; do
        [[ -n "$key" && -n "$pkg" ]] || continue
        if [[ -z "${files_by_pkg[$pkg]+x}" ]]; then
            pkg_order+=("$pkg")
            files_by_pkg[$pkg]=''
        fi
        local f
        f=$(jq -r ".patches.\"$key\".file" "$config")
        files_by_pkg[$pkg]+=" $f"
    done <<< "$lines"

    local p dir f full
    local -a applied=()
    for p in "${pkg_order[@]}"; do
        # Re-download a pristine copy of the package before patching.
        dir=$(find_pub_dir "$hosted" "$p")
        if [[ -n "$dir" ]]; then
            rm -rf "$dir"
            echo "Removed cached $p: $dir" >&2
        fi
        ( cd "$project_root" && flutter pub get >/dev/null 2>&1 ) || true
        dir=$(find_pub_dir "$hosted" "$p")
        if [[ -z "$dir" ]]; then
            echo "Error: $p package not found in pub cache" >&2
            return 1
        fi

        for f in ${files_by_pkg[$p]}; do
            full="$patch_dir/$f"
            [[ -f "$full" ]] && normalize_patch "$full"
            if ( cd "$dir" && git apply "$full" ); then
                echo "$f applied to $p" >&2
            else
                echo "Error: failed to apply $f to $p" >&2
                return 1
            fi
        done
        applied+=("$p")
    done
    # Distinct packages patched, one per line (consumed by caller for state).
    printf '%s\n' "${applied[@]}"
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
            current_hash=$(compute_patches_hash)
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
        else
            echo "Error: failed to apply $file to project${issue_link:+ ($issue_link)}" >&2
            return 1
        fi
    done < <(jq -r --arg plat "$platform" '
        . as $cfg |
        reduce ([ ($cfg.platform.common | to_entries[].value[]),
                  ($cfg.platform[$plat] | to_entries[].value[]) ] | .[]) as $x
          ([]; if index($x) then . else . + [$x] end)[] |
        select($cfg.patches[.].target == "project") |
        .
    ' "$config")

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
                git stash pop 2>/dev/null || true
            else
                echo "Error: cherry-pick ${hash:0:9} ($name) failed" >&2
                git reset --hard HEAD 2>/dev/null || true
                git stash pop 2>/dev/null || true
                return 1
            fi
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
                git stash pop 2>/dev/null || true
            else
                echo "Error: revert ${hash:0:9} ($name) failed" >&2
                git reset --hard HEAD 2>/dev/null || true
                git stash pop 2>/dev/null || true
                return 1
            fi
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
        else
            echo "Error: failed to apply $file to Flutter SDK${issue_link:+ ($issue_link)}" >&2
            return 1
        fi
    done < <(jq -r --arg plat "$platform" '
        . as $cfg |
        reduce ([ ($cfg.platform.common | to_entries[].value[]),
                  ($cfg.platform[$plat] | to_entries[].value[]) ] | .[]) as $x
          ([]; if index($x) then . else . + [$x] end)[] |
        select($cfg.patches[.].target == "sdk") |
        .
    ' "$config")

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

    # pub-package patches（动态：按 file 的 package 字段推导，见 apply_pub_patches）
    local applied_pub_packages
    applied_pub_packages=$(apply_pub_patches "$platform" "$config" "$patch_dir" "$PROJECT_ROOT") || return 1

    local pub_packages_json="[]"
    if [[ -n "$applied_pub_packages" ]]; then
        pub_packages_json=$(printf '%s\n' "$applied_pub_packages" | jq -R . | jq -sc .)
    fi

    local project_patches_json="[]"
    if [[ ${#applied_project_patches[@]} -gt 0 ]]; then
        project_patches_json=$(printf '%s\n' "${applied_project_patches[@]}" | jq -R . | jq -sc .)
    fi

    jq -n \
        --arg status "patched" \
        --arg platform "$platform" \
        --arg patches_hash "$(compute_patches_hash)" \
        --arg flutter_head "$flutter_head" \
        --arg engine_version "$saved_engine_version" \
        --argjson snapshot_time "$(date +%s)" \
        --argjson project_patches "$project_patches_json" \
        --argjson pub_packages "$pub_packages_json" \
        '{status: $status, platform: $platform, patches_hash: $patches_hash, flutter_head: $flutter_head, engine_version: $engine_version, snapshot_time: $snapshot_time, project_patches: $project_patches, pub_packages: $pub_packages}' \
        > "$state_file"
}

resolve_last_tag() {
    local tag

    if [[ -f "$PWD/.git/shallow" ]]; then
        echo "Warning: shallow clone detected, skipping tag-based versioning" >&2
        return 1
    fi

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

    local version_name=""
    local base_version=""
    local version_code=""
    local commit_hash=""
    local build_time=""

    version_code=$(git rev-list --count HEAD | tr -d '[:space:]')
    commit_hash=$(git rev-parse HEAD | tr -d '[:space:]')

    if [[ -n "$tag" ]]; then
        version_name="$tag"
        base_version="$tag"
    elif last_tag=$(resolve_last_tag); then
        base_version="$last_tag"
        version_name="$last_tag"
    elif grep -qE '^[[:space:]]*version:[[:space:]]*([0-9.]+)' pubspec.yaml; then
        version_name=$(grep -E '^[[:space:]]*version:[[:space:]]*([0-9.]+)' pubspec.yaml | head -n1 | sed -E 's/^[[:space:]]*version:[[:space:]]*([0-9.]+).*/\1/')
        base_version="$version_name"
        if [[ "$platform" == "android" ]]; then
            version_name="${version_name}-${commit_hash:0:9}"
        fi
    else
        echo "Prebuild Error: version not found" >&2
        exit 1
    fi

    if $ci && [[ "$platform" =~ ^(android|ios|macos)$ ]]; then
        local pubspec_ver
        IFS=. read -ra parts <<< "$base_version"
        pubspec_ver="${parts[0]}.${parts[1]}.${parts[2]}"
        [[ -n "${parts[3]:-}" ]] && pubspec_ver="${pubspec_ver}-${parts[3]}"
        awk -v verName="$pubspec_ver" -v verCode="$version_code" '
            /^[[:space:]]*version:[[:space:]]*[0-9.]+/ {
                print "version: " verName "+" verCode
                next
            }
            { print }
        ' pubspec.yaml > pubspec.yaml.tmp && mv pubspec.yaml.tmp pubspec.yaml
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
        {
            echo "version=${version_name}+${version_code}"
            echo "version_name=${version_name}"
            echo "version_code=${version_code}"
            echo "base_version=${base_version}"
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
