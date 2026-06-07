# Task-034/035 Final Codex Review

Date: 2026-06-07
Review owner: Codex
Repository: CometDash77/PiliAvalon-Worksite

## Commit

- Commit: `aecfe372537e586d692d5e462f9ee02457801035`
- Branch: `production`
- Commit message: `Task-034/035 fix UP shielding and tag cache sizing`

## Implemented Scope

- Added UP/user regex shielding regression coverage for `xx说电影` with regex pattern `电影`.
- Broadened recommendation author extraction only through known/tested paths:
  - `owner.name`
  - `args.up_name`
  - `args.uname`
  - `owner_name`
  - parsed `item.owner.name`
- Replaced the fixed recommendation detail-tag cache cap of 200 entries with an in-memory estimated byte budget.
- Added `tagEnrichCacheMaxMb`, default `10`, clamped to `1..50`.
- Added cache estimated byte tracking, clear reset accounting, and oldest-entry eviction by estimated byte budget.
- Updated labels:
  - `标签获取并发数`
  - `标签获取超时`
  - `标签缓存上限`
  - `标签缓存状态`
- Updated runtime smoke label checks for the new labels.

## Local Non-acceptance Checks

These were hygiene checks only. Per user instruction, acceptance verification uses GitHub Actions, not local Flutter tests/builds.

- `dart format` on touched Dart files.
- `git diff --check`: exit 0.
- `bash -n .github/scripts/android_runtime_smoke.sh`: exit 0.
- Static search found no production references to `_tagCacheMaxEntries`, old debug labels, or `/ 200 条`.

## GitHub CI / Runtime Smoke

- Run ID: `27089059575`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/27089059575
- Head SHA: `aecfe372537e586d692d5e462f9ee02457801035`
- Conclusion: `success`
- Jobs:
  - Focused Flutter verification: `success`
  - Build Android x86_64 artifact: `success`
  - Android emulator runtime smoke: `success`
- Runtime evidence artifact: `android-runtime-smoke-evidence`, artifact ID `7463048904`
- Runtime evidence:
  - `status=0`
  - `result=pass`
  - `scenario_outcome=pass`
  - Found labels: `标签获取并发数,标签获取超时,标签缓存上限,标签缓存状态`

## Android Prerelease

- Run ID: `27089383689`
- URL: https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/27089383689
- Head SHA: `aecfe372537e586d692d5e462f9ee02457801035`
- Conclusion: `success`
- Release tag: `v2.0.9-task-034-035-candidate`
- Release URL: https://github.com/CometDash77/PiliAvalon-Worksite/releases/tag/v2.0.9-task-034-035-candidate
- Release state:
  - draft: `false`
  - prerelease: `true`
  - target commitish: `aecfe372537e586d692d5e462f9ee02457801035`
- APK assets:
  - `PiliAvalon_android_2.0.8-aecfe3725+5113_arm64-v8a.apk`
  - `PiliAvalon_android_2.0.8-aecfe3725+5113_armeabi-v7a.apk`
  - `PiliAvalon_android_2.0.8-aecfe3725+5113_x86_64.apk`
- Signing fingerprint evidence is present in the release body and matches across all three APKs:
  - `0DB8F8B964EC8778AA69CA12BC017276826062193F66A8DF9F0A14C64AF47051`

## Reasonix Review

- Reasonix was used for worker/monitor/verifier labor with English prompts.
- Early local diff/monitor Reasonix runs hit local path or tool-time limitations and were not used as citable evidence.
- Final Reasonix verifier artifact:
  - `records/reasonix/verifier/2026-06-07-task034-task035-final-verifier.md`
- Codex independently checked the GitHub run and release evidence above before citing it.

## Risks / Notes

- The release tag is `v2.0.9-task-034-035-candidate`, while APK filenames embed version `2.0.8-aecfe3725+5113`. This follows the current build script output but is worth noting as a version/tag naming mismatch.
- This review does not claim Task-021 completion or manual/client acceptance closure.
- Task-031 Stage B remains treated as basically accepted per prior user instruction; Task-034/035 are follow-up fixes.
