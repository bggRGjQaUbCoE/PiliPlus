# GitHub Repository Scope Guard

- role: session-safety-guard
- session id: 2026-05-29-gh-repository-scope-guard
- date: 2026-05-29
- repo root: `/home/mo/Documents/piliavalon`
- intended writable GitHub repo: `CometDash77/PiliAvalon-Worksite`
- upstream/reference repo: `bggRGjQaUbCoE/PiliPlus`

## Hard Rule

All GitHub CLI commands that can read run state, dispatch workflows, create pull
requests, mutate branches, or otherwise act on a GitHub repository must pass the
repository explicitly:

```text
-R CometDash77/PiliAvalon-Worksite
```

Do not rely on `gh` default repository inference in this checkout.

## Allowed Target

Writable operations are allowed only against:

```text
CometDash77/PiliAvalon-Worksite
```

Examples:

```text
gh workflow run phase1_shielding_verify.yml --ref phase-1-shielding-core -R CometDash77/PiliAvalon-Worksite
gh run list --workflow phase1_shielding_verify.yml --branch phase-1-shielding-core -R CometDash77/PiliAvalon-Worksite
gh run view <run-id> -R CometDash77/PiliAvalon-Worksite
```

## Upstream Boundary

The upstream/reference repository:

```text
bggRGjQaUbCoE/PiliPlus
```

may be used only for read-only source/reference inspection when explicitly
needed. Do not trigger workflows, push branches, create pull requests, open
issues, change releases, or perform any other write/action operation there.

## Incident Note

During Phase 1 shielding verification, an initial unscoped command:

```text
gh workflow run phase1_shielding_verify.yml --ref phase-1-shielding-core
```

resolved through `gh` to the upstream/default repository context and returned:

```text
HTTP 404: Not Found (https://api.github.com/repos/bggRGjQaUbCoE/PiliPlus/actions/workflows/phase1_shielding_verify.yml)
```

No upstream workflow was found or triggered, and no upstream code was changed.
The correct follow-up command was explicitly scoped:

```text
gh workflow run phase1_shielding_verify.yml --ref phase-1-shielding-core -R CometDash77/PiliAvalon-Worksite
```

## Operator Checklist

- Before any `gh` command, check whether it includes `-R CometDash77/PiliAvalon-Worksite`.
- If it does not, add the explicit `-R` before running it.
- Treat unscoped `gh` commands in this repo as unsafe unless the command is
  purely local help/version output such as `gh --version`.

## Retarget Verification Evidence

Repository identity retarget package `2026-05-29-repository-identity-retarget`
used only explicit worksite-targeted GitHub CLI commands.

```text
gh workflow list -R CometDash77/PiliAvalon-Worksite
Build                         active  283233051
Build for iOS                 active  283233052
Build for Linux x64           active  283233053
Build for Mac                 active  283233054
Phase 1 Shielding Verify      active  285364337
Build for Windows x64         active  283233055
```

```text
gh run list -R CometDash77/PiliAvalon-Worksite
completed success Relax Phase 1 analyze info gating Phase 1 Shielding Verify phase-1-shielding-core push 26625915472 3m15s 2026-05-29T08:06:54Z
```

No repo-level `gh` command in this retarget package targeted upstream or relied
on default repository inference.
