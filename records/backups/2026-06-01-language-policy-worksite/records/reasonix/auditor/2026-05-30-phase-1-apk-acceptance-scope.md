# Phase 1 APK Acceptance Scope — Reasonix Audit Record

**Audit date:** 2026-05-30T15:38:50Z (23:38:50 HKT)
**Auditor:** Reasonix Code (read-only audit agent)
**Repo:** `CometDash77/PiliAvalon-Worksite`
**Branch:** `phase-1-shielding-core`
**HEAD:** `7670673b0c80c667136c03019381281049f640f9`
**Previous Release tag:** `phase-1-prebuild.26680259984` → commit `80f5e6d6a`
**Latest CI run:** 26686823386 → HEAD `7670673b0` ✅

---

## 1. Release APK vs Latest CI Artifact

| Dimension | Release APK | CI Artifact `Android_x86_64` |
|---|---|---|
| **Tag / Release** | `phase-1-prebuild.26680259984` | No tag (CI-only artifact) |
| **Commit** | `80f5e6d6a` | `7670673b0` (HEAD, +6 commits ahead) |
| **Build type** | `--release` (signed Release build) | `--release --android-project-arg dev=1` (dev build) |
| **APK filename** | `PiliAvalon_android_2.0.7-80f5e6d6a+5032_*.apk` | `PiliAvalon_android_ci_7670673b0c80_x86_64.apk` |
| **ABIs available** | arm64-v8a ✅ / armeabi-v7a ✅ / x86_64 ✅ | x86_64 only ❌ |
| **applicationId** | `com.example.piliplus` (release) | `com.example.piliplus.dev` (dev suffix) |
| **Suitable for real phone** | ✅ Yes (arm64-v8a) | ❌ No (x86_64 emulator only) |
| **Cover-install compatible** | ✅ Same `applicationId` as release installs | ⚠️ `.dev` suffix → different app, side-by-side |
| **Download count** | arm64-v8a: 2 / others: 0 | N/A |

## 2. Six Commits Between Release and HEAD

| # | SHA | Author | Message | Type |
|---|---|---|---|---|
| 1 | `41b5a821` | CometDash77 | `records: publish phase 1 shielding repair prebuild` | Record-keeping |
| 2 | `a6e97e6e` | CometDash Worksite | `ci: add phase 1 authoritative workflow` | CI workflow |
| 3 | `62071ea9` | CometDash Worksite | `docs: record phase 1 ci failure evidence` | Documentation |
| 4 | `b6bb438f` | CometDash Worksite | `Fix dev release Android resource packaging` | **Build fix** |
| 5 | `30011208` | CometDash Worksite | `ci: resolve runtime smoke launcher activity` | CI/runtime smoke |
| 6 | `7670673b` | CometDash Worksite | `records: persist runtime smoke launcher review` | Record-keeping |

**Impact assessment:**
- Commits 1, 3, 6 are records/docs only → **no APK content change**
- Commit 2 adds the CI workflow (`.github/workflows/ci.yml`) → **not in APK**
- Commit 4 fixes Android resource packaging for dev builds only → **affects dev APK, not release APK**
- Commit 5 is CI/runtime smoke only → **not in APK**

**Conclusion:** The 6 commits between Release `80f5e6d6a` and HEAD `7670673b0` do **not** change shielding feature logic, launcher behavior, or any user-facing functionality. The Release APK `phase-1-prebuild.26680259984` is functionally representative of current HEAD.

## 3. Recommendation for User Acceptance

> **用户现在应该测 `phase-1-prebuild.26680259984` 的 Release APK（arm64-v8a 对应真机）。**

理由：
1. Release APK 是正式签名的 Release build，可以覆盖安装在用户正在使用的 App 上
2. Release APK 到 HEAD 之间的 6 个 commits 均为 CI/记录/文档性质，不影响 shielding 功能
3. HEAD `7670673b0` **没有** Release APK artifact（CI 只产出了 x86_64 dev build）
4. CI artifact `Android_x86_64` **不适合真机**（x86_64 ABI, `.dev` applicationId）

**如果必须基于最新 HEAD 验收，则需要新的 prebuild。**

## 4. Eight Subagent Conclusions

### Subagent A — APK 口径
Release APK 不是最新 HEAD build（commit `80f5e6d6a` vs HEAD `7670673b0`），但 6 个 commits 差异不影响 shielding 功能。HEAD 没有正式 Release APK。

### Subagent B — 验收清单
8 项手动验收 checklist 已输出（覆盖安装、推荐流屏蔽、评论屏蔽、屏蔽设置页、规则持久化等）。用户可直接照做。

### Subagent C — 差异影响
6 commits 中只有 `Fix dev release Android resource packaging` 影响 APK 构建（dev 构建），其余均为 CI/文档。Release APK 验收结果可代表当前 Phase 1 shielding 功能。

### Subagent D — 签名/覆盖安装
Release APK 使用 `com.example.piliplus` applicationId，正式 Release 签名，覆盖安装应该成功。CI artifact 使用 `com.example.piliplus.dev`，与 Release APK 不同签名路径，不能互相覆盖。真机必须用 arm64-v8a ABI。

### Subagent E — Technical-lead Review Packet
最短审查包（10 行内）：已完成 = CI pass + runtime smoke pass + artifact 证据；未完成 = manual acceptance + design institute review + 甲方验收 + package-runtime-contract 豁免待确认。

### Subagent F — package-runtime-contract 豁免草案
已输出豁免文档草案：Phase 1 scope 不包含 rename，PiliPlus/com.example.piliplus 标识均保持 yellow/debt，建议单独 phase 做 rename。

### Subagent G — 证据归档完整性
缺失 3 个高优先级记录：HEAD CI 状态记录、HEAD runtime smoke 记录、新 prebuild 决策记录。10 个旧记录已被 HEAD 后的证据取代。

### Subagent H — 用户行动建议
**现在测**（用 Release APK `phase-1-prebuild.26680259984` arm64-v8a）。不测的话等新 prebuild 再去测。测完回复验收结果截图 + 问题清单。

## 5. Overall Recommendation

```
现在测 ✅ → 用 phase-1-prebuild.26680259984 Release APK (arm64-v8a)
等新 prebuild ⏳ → 如果坚持要基于 HEAD 7670673b0 验收
测 CI artifact ❌ → 不适合真机 (x86_64 + .dev suffix)
```

**首选：现在测 Release APK `phase-1-prebuild.26680259984`（arm64-v8a）。**
**如果必须验收最新 HEAD，则需要先发布新 prebuild —— 但本次不发布，等用户授权。**

### Codex Review Note

Codex reviewed two Reasonix reports with isolated subagents:

- Report 1 recommended waiting for a new prebuild only for process consistency:
  APK, build, verify, and smoke would then all come from the same latest HEAD
  cycle.
- Report 2 recommended testing the current release APK now because the six
  commits between `80f5e6d6a` and `7670673b0` do not change shielding feature
  logic, and the current HEAD CI artifact is not suitable for a real phone.

Codex conclusion:

- For Phase 1 shielding feature manual acceptance, use
  `phase-1-prebuild.26680259984` arm64-v8a Release APK now.
- Record the limitation: this validates shielding behavior for the release APK
  at `80f5e6d6a`, which is functionally representative of current HEAD for
  shielding because the six later commits are CI/docs/records/dev-smoke only.
- Do not claim this is a latest-HEAD release APK. Latest HEAD `7670673b0` has no
  formal release APK.
- If the acceptance policy requires the exact latest HEAD as the APK under
  test, a new prebuild must be authorized first.

## 6. Still-Open Gates

| Gate | Status | Reason |
|---|---|---|
| **CI run 26686823386** | ✅ GREEN | 三阶段全部 pass，独立复核确认 |
| **Runtime smoke evidence** | ✅ GREEN | 16 项检查全部 pass（非白屏、无 ANR、UI 渲染完整） |
| **Manual acceptance** | 🟡 YELLOW | 需要用户在真机上执行 checklist 验收 |
| **Technical-lead review** | 🟡 YELLOW | 需要设计院确认, 特别是 package-runtime-contract 豁免 |
| **甲方验收** | 🟡 YELLOW | 需要用户/甲方签字 |
| **package-runtime-contract 未改名** | 🟡 YELLOW | 不阻塞 Phase 1 shielding 验收，但需显式豁免或后续计划 |

## 7. package-runtime-contract Status

当前状态：**未改名。** `pubspec.yaml name: PiliPlus`、`namespace/applicationId: com.example.piliplus`、`MainActivity.kt package: com.example.piliplus`、`MethodChannel("PiliPlus")`、通知频道 `com.example.piliplus.audio`、Dart imports `package:PiliPlus/` 均保持原值。

**建议：保持 yellow/debt，不阻塞 Phase 1 验收。** 后续 rename 应作为单独 phase。

豁免草案已写入本审计过程，如需正式提交到 records/，请用户/Codex 授权。

## 8. Declaration

**本次审计是只读操作。** 没有：
- ❌ `git add` / `git commit` / `git push`
- ❌ `git merge`
- ❌ 触发 GitHub Actions workflow
- ❌ 发布 GitHub Release
- ❌ 修改任何代码文件
- ❌ 向设计院治理仓库写任何内容

**本次唯一写入的文件是 `records/reasonix/auditor/2026-05-30-phase-1-apk-acceptance-scope.md`**（本文件），属于审计过程的证据归档。
