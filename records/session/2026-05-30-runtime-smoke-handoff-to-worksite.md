# Runtime Smoke Handoff To Worksite

- role: runtime-smoke-handoff
- session id: 2026-05-30-runtime-smoke-handoff-to-worksite
- date: 2026-05-30
- repo root: /home/mo/Documents/piliavalon
- branch: phase-1-shielding-core
- writable repo: CometDash77/PiliAvalon-Worksite
- status: handoff / runtime-smoke workflow partially implemented / not green

## User Context

The user reported that the Phase 1 prebuild installed but launched to a white screen. Therefore Phase 1 is not green, and normal recommendation-feed/comment-area manual acceptance must stay paused.

The user then asked whether GitHub Actions could perform the first Android runtime smoke gate because the local environment is too limited for Flutter/adb/emulator testing. The previous agent interpreted `continue` as authorization to work in the worksite repository and added a GitHub Actions-based Android runtime smoke workflow.

## What Was Done

The previous agent switched from the design-institute repo to the worksite repo:

```text
/home/mo/Documents/piliavalon
```

The branch was:

```text
phase-1-shielding-core
```

The following commits were made and pushed to `origin/phase-1-shielding-core`:

```text
a3d186318 ci: add android runtime smoke gate
931c70791 ci: fix runtime smoke artifact lookup
8d7ab1139 ci: download raw apk artifact for runtime smoke
28e6c8145 ci: use posix shell in emulator smoke script
```

These commits added and iterated on:

```text
.github/workflows/android_runtime_smoke.yml
records/session/2026-05-30-android-runtime-smoke-github-actions-plan.md
```

The workflow goal is to:

- download the x86_64 APK from prior Build run `26628409138`;
- boot an Android emulator on GitHub-hosted Ubuntu;
- install the APK;
- launch package `com.example.piliplus`;
- wait for first-screen behavior;
- capture logcat, window state, screenshot, install output, launch output, pid, and metadata;
- upload `android-runtime-smoke-evidence`.

## GitHub Actions Runs Observed

Workflow:

```text
Android Runtime Smoke
```

Observed runs:

```text
26672323068 failure
26672365508 failure
26672439801 failure
26672522697 failure
```

Failure history:

1. `26672323068`
   - failed at artifact download;
   - root cause: workflow looked for artifact name `Android_x86_64`;
   - actual artifacts are named as APK filenames, e.g. `PiliAvalon_android_2.0.7-cf9ed10f0+5006_x86_64.apk`.

2. `26672365508`
   - artifact was found by pattern;
   - failed because `actions/download-artifact@v6` tried to extract the artifact;
   - root cause: prior Build workflow uploaded artifacts with `archive: false`, so GitHub returns a raw APK blob.

3. `26672439801`
   - raw APK download worked;
   - KVM setup worked;
   - emulator booted;
   - failed because `reactivecircus/android-emulator-runner@v2` ran script with `/usr/bin/sh`, where `set -o pipefail` is illegal.

4. `26672522697`
   - artifact download worked;
   - KVM setup worked;
   - emulator booted;
   - failed because the emulator runner executes each `script` line as separate `/usr/bin/sh -c`;
   - variable assignment `APK=...` did not persist to the following `test -n "$APK"` line.

## Current Uncommitted Work

After run `26672522697`, the previous agent began a fix but stopped when the user questioned whether this was worksite work.

Current worksite status includes tracked modifications and one new script:

```text
M .github/workflows/android_runtime_smoke.yml
M records/session/2026-05-30-android-runtime-smoke-github-actions-plan.md
?? .github/scripts/
?? records/session/2026-05-30-phase-1-runtime-white-screen-governance-sync.md
?? .codex/
```

Important notes:

- `.github/scripts/android_runtime_smoke.sh` exists locally but is not committed or pushed.
- `.github/workflows/android_runtime_smoke.yml` locally now calls that script.
- `records/session/2026-05-30-android-runtime-smoke-github-actions-plan.md` locally includes the fourth failure finding.
- `records/session/2026-05-30-phase-1-runtime-white-screen-governance-sync.md` was already present as an untracked worksite record during inspection; do not delete it.
- `.codex/` is untracked local state; do not include unless explicitly needed.

## Current Local Fix Intent

The uncommitted local fix is to avoid multi-line variable loss inside `reactivecircus/android-emulator-runner@v2`.

New local script:

```text
.github/scripts/android_runtime_smoke.sh
```

Intended behavior:

- find the downloaded APK inside `runtime-smoke/apk`;
- always create `runtime-smoke/evidence`;
- write metadata;
- install APK;
- launch `com.example.piliplus`;
- sleep 25 seconds;
- capture logcat, window state, screenshot, pid;
- write `status=<code>`;
- exit nonzero for missing APK, install failure, launch failure, or missing process;
- still preserve evidence files where possible.

The workflow change is:

```yaml
script: .github/scripts/android_runtime_smoke.sh
```

and the prior `List downloaded APK` step now runs:

```bash
chmod +x .github/scripts/android_runtime_smoke.sh
```

## What Still Needs To Be Done

Next worksite session should choose one of these paths.

Recommended path:

1. Review the uncommitted files:
   - `.github/workflows/android_runtime_smoke.yml`
   - `.github/scripts/android_runtime_smoke.sh`
   - `records/session/2026-05-30-android-runtime-smoke-github-actions-plan.md`

2. If acceptable, stage only these files:

```bash
git add .github/workflows/android_runtime_smoke.yml \
  .github/scripts/android_runtime_smoke.sh \
  records/session/2026-05-30-android-runtime-smoke-github-actions-plan.md \
  records/session/2026-05-30-runtime-smoke-handoff-to-worksite.md
```

3. Commit:

```bash
git commit -m "ci: run runtime smoke commands from script"
```

4. Push:

```bash
git push origin phase-1-shielding-core
```

5. Watch the next run:

```bash
gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Android Runtime Smoke" --branch phase-1-shielding-core --limit 5
gh run watch -R CometDash77/PiliAvalon-Worksite <run-id>
```

6. If the run succeeds or uploads evidence, inspect/download `android-runtime-smoke-evidence`.

7. Runtime smoke is not accepted merely because the workflow exits 0. The screenshot, logcat, window state, and pid evidence must be reviewed.

## Acceptance Rules

Phase 1 remains yellow until all of the following are true:

1. GitHub Actions runtime smoke installs the x86_64 APK.
2. It launches `com.example.piliplus`.
3. Evidence artifact exists.
4. Screenshot/window/logcat evidence shows a usable first screen, not white screen, crash, or hang.
5. Only after that may the user resume recommendation-feed and comment-area manual acceptance.

If the next run fails, record the exact failed command and evidence in a new session record. Do not ask the user to continue manual acceptance while runtime smoke is failed or blocked.

## Design-Institute Context

The design-institute repo also has uncommitted governance audit work on branch:

```text
governance/phase-1-runtime-white-screen-audit
```

It records the rule that build-only and packaging-only evidence do not equal runtime acceptance, and that Android install/launch smoke is a pre-user gate.

That design repo work should not be mixed into the worksite commit. Keep repository boundaries separate.

## Commands Already Verified

The previous agent verified:

```bash
git remote -v
```

showed `origin` as:

```text
git@github.com:CometDash77/PiliAvalon-Worksite.git
```

and upstream push remotes were disabled.

The previous agent also verified the actual artifact list for Build run `26628409138` includes:

```text
PiliAvalon_android_2.0.7-cf9ed10f0+5006_x86_64.apk
PiliAvalon_android_2.0.7-cf9ed10f0+5006_armeabi-v7a.apk
PiliAvalon_android_2.0.7-cf9ed10f0+5006_arm64-v8a.apk
```

Use the x86_64 artifact for emulator smoke.
