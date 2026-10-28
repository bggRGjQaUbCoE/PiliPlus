# Archived six-platform CI branches (2026-10-28)

The long-lived `goodwu-dev-rebased` App branch contains the complete CI work
from both native-package branches by a three-parent merge commit
`71b1a7d0513aedbd841da42e48eab0a6d4be0fbb`.

| Former branch | Original full HEAD | Proposed lightweight tag |
| --- | --- | --- |
| `ci/native-packages-20261023` | `7cffbb8ef8f5f3d9b4633463c0eae73781755e90` | `archive/ci-native-packages-20261023` |
| `ci/native-packages-update-20261027` | `746236424ebf1e26b78dad9d50e70d9c5247117a` | `archive/ci-native-packages-update-20261027` |

The original PR #1 was automatically recognized as merged at `71b1a7d0` by GitHub.
The checked source tree retains the latest approved native input versions, six-platform
build scripts and tests, and every existing App/HDR/diagnostic path. The OHOS source
policy was reviewed and rebased to the current App tree; it still rejects unapproved
changes. The source-build workflow now runs only on `goodwu-dev-rebased`.

The temporary archiver is a **one-shot**, fail-closed workflow. It checks the exact
branch SHAs, ancestry, merged PR, default branch and lack of open PR references;
creates and verifies both exact lightweight tags **before** deleting any branch.
After successful execution, remove the temporary write-authorized workflow. Until
then, tags/deletions are not assumed successful. Keep `main`, `dev`, `dom` untouched.

Build success of an older commit does not certify the new integration's six-platform
CI or devices. Latest run: https://github.com/Goodwu/PiliPlus/actions/runs/40709275185 .
