# Design Institute Escalation — Worksite Governance Failure

Date: 2026-05-31
Escalation owner: Codex
Escalation target: Design Institute
Worksite repo: `CometDash77/PiliAvalon-Worksite`
Branch context: `phase-1-shielding-core`
Current release candidate under test: `phase-1-prebuild.26714387748`

## Status

This is a governance escalation, not a worksite implementation task.

The worksite produced a signed release candidate and Codex-reviewed CI/signing evidence, but the user's real-device acceptance feedback shows that the worksite process still failed to preserve and execute against the actual unresolved acceptance issues.

Do not treat CI success, release artifact presence, or signing evidence as Phase 1 acceptance.

## User Feedback To Preserve

The following user feedback is primary evidence and must not be collapsed into a generic "manual retest failed" summary:

```text
#3 UP 主关键词交互/长按加规则，回到了2668025995之前的逻辑，这个甚至不如26707279023的逻辑，什么都没有改变， #7 旧规则迁移/兼容是否可用无法测试，因为删除覆盖了，#8 设置页分类和入口是否清楚这个清楚了，屏蔽整条评论文本依然存在，这个设置没有任何意义，#10不知道怎么测试，我意识到我们制度有问题，所以说，必须要改善工地制度了，把问题返回去，工地的aiagent必须要遵守一个类似于设计院的kanban制度，把所有问题一五一十的记录下来并且为治理最高准则，不然的话肯定会忘记，把这个问题全部record下来，很重要
```

Follow-up correction from the user:

```text
不，这是治理制度问题，交给设计院
```

## Acceptance Findings From User

| Item | User finding | Current status |
|---|---|---|
| #3 UP 主关键词交互 / 长按加规则 | Regressed to logic before `2668025995`; worse than `26707279023`; user observes no meaningful change. | Failed; must not be marked fixed. |
| #7 旧规则迁移 / 兼容 | Cannot be tested because deletion/reinstall/cover path destroyed the old-rule baseline. | Unverifiable in current acceptance run; process failure. |
| #8 设置页分类和入口 | Category and entry are clear. | Partially accepted for IA clarity only. |
| #8/#9 comment shielding semantics | "屏蔽整条评论文本" still exists; user states this setting has no meaningful value. | Still unresolved product semantics issue. |
| #10 signing / cover-install | User does not know how to test it; prior unsigned or differently signed APKs make the intended cover-install test impossible until a signed baseline exists. | Gate definition/process failure; should be deferred with explicit baseline rules. |

## Governance Failure

The failure is not only an implementation miss. It is a governance-system defect:

- Worksite agents over-weighted CI/build/signing success and under-weighted the unresolved acceptance issue list.
- User acceptance feedback was not converted into a durable, controlling issue board with statuses and acceptance criteria.
- Agents could proceed from summaries, run logs, or release evidence without first reconciling every open user issue.
- Deferred or unverifiable gates, especially #7 and #10, were not clearly separated from passed gates.
- Regressions against earlier APK behavior were not tracked as first-class blockers.

## Design Institute Decision Needed

The Design Institute should define a mandatory worksite governance rule equivalent to a kanban board:

1. Every user-reported issue must be recorded as a durable card with ID, exact user wording, owner, status, affected build/run, expected behavior, observed behavior, evidence, and acceptance criteria.
2. This issue board must be the highest-priority input for all worksite AI agents before coding, CI monitoring, release preparation, or acceptance reporting.
3. An agent may not claim a fix, close a gate, or hand off acceptance until each relevant open card has an explicit status: `open`, `fixed-awaiting-user-test`, `blocked`, `deferred-with-rationale`, or `accepted-by-user`.
4. CI success, release build success, signing evidence, and Reasonix monitor reports are supporting evidence only; they cannot override an open user acceptance card.
5. Deferred gates must name the future prerequisite. For #10, the current signed APK `phase-1-prebuild.26714387748` can become the first signed baseline; true same-signature cover-install can only be tested against a later signed APK unless an older same-key APK exists.
6. Regressions against prior APK behavior must be tracked explicitly, including comparisons to `2668025995`, `26707279023`, and any later candidate.
7. Before any new prebuild is requested for user testing, the worksite must output a checklist mapping each open card to the exact behavior the user should verify.

## Immediate Worksite State

The current signed build evidence for `26714387748` is useful but insufficient:

- Release build and signing evidence are Codex-reviewed.
- Manual acceptance is not green.
- #3 is failed by user report.
- #7 is not testable due to lost old-rule baseline.
- #8 IA clarity is accepted, but comment shielding semantics remain unresolved.
- #10 cover-install requires a signed baseline and cannot be retroactively proven from prior unsigned/differently signed APKs.

## Required Design Institute Output

The Design Institute should return a governance ruling that answers:

- What is the required issue-board format?
- Where is the authoritative board stored?
- What fields are mandatory?
- What statuses are allowed?
- What must every worksite agent read before acting?
- What evidence is required to move a card to accepted?
- How should unavailable tests, such as #7 and #10 in this run, be recorded without falsely closing them?
