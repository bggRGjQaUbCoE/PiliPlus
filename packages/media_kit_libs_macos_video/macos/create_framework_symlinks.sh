#!/bin/sh

# `create_framework_symlinks.sh` is duplicated across:
# - `media_kit_libs_ios_audio`
# - `media_kit_libs_ios_video`
# - `media_kit_libs_macos_audio`
# - `media_kit_libs_macos_video`

set -e
set -u

SRC_DIR="$1"
SYMLINKS_DIR="$2"

# Computes the relative path between two given paths
#
# Example:
# ```
# relpath Frameworks/Mpv.xcframework/ios-arm64 Frameworks/.symlinks/mpv
# ../../Mpv.xcframework/ios-arm64
# ```
#
# Source: https://stackoverflow.com/a/14914070
relpath() {
    [ $# -ge 1 ] && [ $# -le 2 ] || return 1
    current="${2:+"$1"}"
    target="${2:-"$1"}"
    [ "$target" != . ] || target=/
    target="/${target##/}"
    [ "$current" != . ] || current=/
    current="${current:="/"}"
    current="/${current##/}"
    appendix="${target##/}"
    relative=''
    while appendix="${target#"$current"/}"
        [ "$current" != '/' ] && [ "$appendix" = "$target" ]; do
        if [ "$current" = "$appendix" ]; then
            relative="${relative:-.}"
            echo "${relative#/}"
            return 0
        fi
        current="${current%/*}"
        relative="$relative${relative:+/}.."
    done
    relative="$relative${relative:+${appendix:+/}}${appendix#/}"
    echo "$relative"
}

# Create symbolic links from a given source directory to a destination directory
# for a specific framework
#
# Example:
# ```
# create_framework_symlinks Frameworks/Mpv.xcframework Frameworks/.symlinks/mpv
# Frameworks/.symlinks/mpv/ios -> ../../Mpv.xcframework/ios-arm64
# Frameworks/.symlinks/mpv/ios-simulator -> ../../Mpv.xcframework/ios-arm64_x86_64-simulator
# ```
create_framework_symlinks() {
    SRC_DIR="$1"
    SYMLINKS_DIR="$2"

    find "${SRC_DIR}" -mindepth 1 -maxdepth 1 -type d | while read SRC; do
        SLUG="$(basename "${SRC}")"
        NAME="$(echo "${SLUG}" | cut -d '-' -f 1,3)"

        SRC_RELATIVE="$(relpath "${SYMLINKS_DIR}" "${SRC}")"

        ln -s "${SRC_RELATIVE}" "${SYMLINKS_DIR}/${NAME}"
    done
}

create_framework_symlinks "${SRC_DIR}" "${SYMLINKS_DIR}"
