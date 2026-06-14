#!/usr/bin/env bash
set -euo pipefail

ARG="${1:-}"

version_name=""
version_code=$(git rev-list --count HEAD | tr -d ' ')
commit_hash=$(git rev-parse HEAD | tr -d ' ')
build_time=$(date +%s)

tmp_file="$(mktemp)"

# 逐行处理 pubspec.yaml
while IFS= read -r line; do
  if [[ $line =~ ^[[:space:]]*version:[[:space:]]*([0-9.]+) ]]; then
    version_name="${BASH_REMATCH[1]}"

    if [[ "$ARG" == "android" ]]; then
      version_name="${version_name}-${commit_hash:0:9}"
    fi

    echo "version: ${version_name}+${version_code}" >> "$tmp_file"
  else
    echo "$line" >> "$tmp_file"
  fi
done < pubspec.yaml

# 如果没找到 version 字段
if [[ -z "$version_name" ]]; then
  echo "Prebuild Error: version not found" >&2
  exit 1
fi

# 覆盖写回 pubspec.yaml
mv "$tmp_file" pubspec.yaml

# 生成 pili_release.json
cat > pili_release.json <<EOF
{
  "pili.name": "${version_name}",
  "pili.code": ${version_code},
  "pili.hash": "${commit_hash}",
  "pili.time": ${build_time}
}
EOF

# 写入 GitHub Actions 环境变量（如果存在）
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "version=${version_name}+${version_code}" >> "$GITHUB_ENV"
fi
