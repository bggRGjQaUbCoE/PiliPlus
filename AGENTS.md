# Worksite Agent Instructions

Audience classification: agent-facing.

## Repository Boundary

This repository is the active worksite repository for `CometDash77/PiliAvalon-Worksite`. Active rules, hooks, Reasonix boundaries, Codex reviews, handoffs, and reusable worksite records must live in this repository.

Do not activate worksite governance in the design-institute repository unless the user explicitly asks for design-institute changes. Design-institute records may inform policy intent, but they are not the active worksite rule surface.

## Language Policy

Internal worksite records must use professional English. This includes Reasonix artifacts, Codex review records, hook messages, handoffs, implementation notes, audit records, verification notes, release-prep notes, reusable prompt packages, and other agent-facing records.

User-facing decision reports remain Chinese unless the user requests another language. Dual-use records may include a Chinese user-facing summary, but the technical body and agent instructions must be English.

Every report, handoff, and prompt package must declare one of these audience classes near the top:

- `agent-facing`: internal worksite and automation material. Use English.
- `user-facing`: reports intended for the user/client. Use Chinese.
- `dual-use`: include a Chinese decision summary and English technical body.

Raw user feedback must remain in the original language when preserved as source material. Label it clearly as raw user feedback and do not rewrite it as an agent conclusion.

Do not translate historical `.reasonix/log-*`, truncated tool outputs, screenshots, build artifacts, command outputs, or other raw evidence captures.

## Hook Policy

Keep `.codex/hooks/guard_ci_monitor.py` active for `PreToolUse` shell-command checks. Do not weaken the CI monitor guard.

Hook reminders must be in English. Language-policy hooks are advisory reminders; they must not replace evidence checks, CI monitor blocks, or Codex review gates.

Configure language-policy reminders for supported Codex events:

- `SessionStart`: remind agents to use English for internal records and Chinese for user-facing decision reports.
- `UserPromptSubmit`: remind agents to classify report, handoff, and prompt package audience.
- `Stop`: remind agents to verify final report language against the declared audience class.

## Reasonix Authority Boundary

Reasonix output is candidate evidence only until it is persisted under `records/reasonix/...` and reviewed by Codex. Unpersisted chat text is not citable evidence.

Reasonix cannot claim green, cannot push, cannot merge, cannot release, cannot close acceptance, and cannot replace user/client acceptance. Reasonix also cannot close runtime smoke, manual acceptance, technical-lead review, or client acceptance gates.

Reasonix cannot modify governance policy, CI/workflow definitions, release state, merge state, or design-institute policy files unless the user explicitly changes the governance model and Codex records the new rule.

Reasonix dispatch prompts must include:

- `role_id`
- `target_repo`: `CometDash77/PiliAvalon-Worksite`
- `target_branch_or_run`
- `allowed_commands`
- `forbidden_actions`
- `expected_artifact_path`
- `max_iterations`, `max_time_minutes`, and `usd_cap`
- `review_owner`: `Codex`

Reasonix prompts must start with the required response-instruction setup phrase when response instructions are needed:

```text
First confirm that response instructions / 响应指令 are enabled for this task.
```

Use the bilingual term `响应指令` only where it is needed for Reasonix response-instruction setup.

## Evidence Rules

Codex must cite persisted `records/reasonix/...` artifacts only after a matching Codex review artifact exists or after Codex writes a fresh review in the current session.

Automation green, CI green, runtime smoke green, technical-lead acceptance, and user/client acceptance are separate gates. Passing one gate does not close another.

When preserving or promoting Reasonix work, retain paths, commands, branch names, run IDs, release tags, URLs, artifact paths, code fences, and evidence status exactly unless the source is demonstrably wrong and the correction is recorded.
