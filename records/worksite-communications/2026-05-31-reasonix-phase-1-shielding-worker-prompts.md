# reasonix phase 1 shielding worker prompts

Audience classification: agent-facing.

## Normalization Note

This file was normalized under the 2026-06-01 worksite language policy. The active agent-facing record is English. The pre-normalization source is preserved at records/backups/2026-06-01-language-policy-worksite/records/worksite-communications/2026-05-31-reasonix-phase-1-shielding-worker-prompts.md.

## Record Classification

- Repository boundary: CometDash77/PiliAvalon-Worksite
- Worksite path: records/worksite-communications/2026-05-31-reasonix-phase-1-shielding-worker-prompts.md
- Artifact category: worksite communication
- Evidence status: Candidate evidence only. It cannot claim green, cannot close acceptance, and requires Codex review before citation.
- Review owner: Codex

## Summary

Worker 4 governance, verification, and release-evidence communication for Phase 1 shielding. Automation evidence is separate from manual acceptance, technical-lead review, and client acceptance.

## Preserved Evidence Anchors

- - CI run: `26686823386` — **Phase 1 CI** — ✅ success
- gh workflow run ci.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core
- gh workflow run phase1_shielding_verify.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core
- runtime-smoke/evidence/
- gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Phase 1 CI" --branch phase-1-shielding-core --limit 3 --json databaseId,conclusion,headSha
- gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core \
- gh workflow run android_runtime_smoke.yml -R CometDash77/PiliAvalon-Worksite \
- gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Phase 1 CI" --branch phase-1-shielding-core --limit 3 --json databaseId,displayTitle,conclusion,headSha,url
- gh release view phase-1-prebuild.26680259984 -R CometDash77/PiliAvalon-Worksite --json tagName,isPrerelease,url
- gh run view <RUN_ID> -R CometDash77/PiliAvalon-Worksite --log
- gh run view <SMOKE_RUN_ID> -R CometDash77/PiliAvalon-Worksite --artifact

## Reasonix Boundary

Reasonix output is candidate evidence only until it is persisted under records/reasonix/... and reviewed by Codex. Reasonix cannot claim green, cannot push, cannot merge, cannot release, cannot close acceptance, and cannot replace user/client acceptance. Reasonix cannot close runtime smoke, manual acceptance, technical-lead review, or client acceptance gates.

## Citation Rule

Future worksite sessions may cite this record only with its evidence status. If the record is a Reasonix candidate artifact, cite a matching Codex review artifact or write a fresh Codex review before relying on its conclusions.



