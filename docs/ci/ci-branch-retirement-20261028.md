# PiliPlus six-platform CI development branch consolidation — 2026-10-28

**Final state: successful.** Keep `goodwu-dev-rebased` as the active development
and application build branch; `main`, `dev` and `dom` were not modified.
The complete source histories from both former CI branches are parents of the
reviewed merge commit `71b1a7d0513aedbd841da42e48eab0a6d4be0fbb`.
GitHub compare reports `behind_by=0` for both old heads.

| Deleted CI branch | Original full SHA | Verified lightweight archival tag |
| --- | --- | --- |
| `ci/native-packages-20261023` | `7cffbb8ef8f5f3d9b4633463c0eae73781755e90` | `archive/ci-native-packages-20261023` |
| `ci/native-packages-update-20261027` | `746236424ebf1e26b78dad9d50e70d9c5247117a` | `archive/ci-native-packages-update-20261027` |

GitHub recognized the former draft PR #1 as merged by `71b1a7d0`;
its discussion remains intact. These tags are source snapshots, **not**
application releases or device-validation claims.

## CI retained on goodwu-dev-rebased

- `.github/workflows/source-build.yml`: push trigger only
  `goodwu-dev-rebased` (plus existing manual invocation). Resolves the
  full `Goodwu/media-kit@dev` commit once at plan time and freezes it
  across Android, Windows, Linux, iOS, macOS, OHOS build jobs.
- `.github/workflows/build-platform.yml`: verifies identical media-kit SHA,
  authenticated native package identity, immutable dependency/toolchain
  inputs, and per-platform final artifacts.
- `tool/native/`: native source/transport build, desktop ABI/API checks,
  Android native package receipt, App provenance, Python unit tests.
- OHOS approved source policy now bases its strict, per-file SHA review on
  the actual previous App development tree `30fa1f46ab086e2c5a22d88e6bb9eacbe87b854f`.
  App/HDR/diagnostic code was not replaced by old CI sources. Future
  unapproved App mutations still fail closed.

The native source lock retains the 2026-10-27 approved source vector:
mpv `4c6e1796`, FFmpeg `d4bb7939`, libplacebo `c9fd8798`.
Existing locally compiled and cross-platform CI inputs remain separate.
`pubspec_overrides.yaml` still maps media-kit Dart packages to the local
sibling `../media-kit` checkout; that directory should follow the `dev`
branch for local builds.

## Evidence and cleanup

The pre-integration CI runs reached 12/13 successful jobs (the
former OHOS App policy baseline was obsolete). After integrating
into the main development line, plan/contract tests passed and
full platform validation was triggered; subsequent rapid maintenance
pushes may cancel earlier runs. **Do not count cancelled/pending jobs
as platform validation.** Track fresh CI status in GitHub Actions.

The first archival attempt verified both exact tags and deleted the first
CI branch, but GitHub's immediately following GET returned a stale ref;
the second script version failed YAML parsing due to indentation.
The final idempotent revision completed successfully:
https://github.com/Goodwu/PiliPlus/actions/runs/40710249084 .

After success, the one-time write-authorized archival workflow was deleted
from the active development tree. Its script and execution history remain
available in the Git history. No upstream/main/sync branch was changed.
