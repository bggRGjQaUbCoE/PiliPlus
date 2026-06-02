# Phase 1 Shielding — Worker 4: 治理/验证/发布证据 — 候选分析

日期: 2026-05-31
角色: Worker 4 — 治理/验证/发布证据
仓库: `CometDash77/PiliAvalon-Worksite`
分支: `phase-1-shielding-core`
当前 HEAD: `ce5f6915d`

> ⚠️ 本文件是候选分析，按 worker 边界"只产候选分析，不得标 green"。  
> 所有 gate 状态标记均为分析性评估，不构成 Phase 1 验收结论。

---

## 1. 当前 Gate 全景

| Gate | 状态 | 证据 |
|---|---|---|
| Flutter focused 验证 | ✅ pass (基线) | CI run `26686823386` @ `7670673b0` |
| Android x86_64 构建 | ✅ pass (基线) | CI run `26686823386` |
| Android runtime smoke | ✅ pass (基线) | CI run `26686823386`; 16/16 证据文件完整 |
| 启动/无白屏 | ✅ 用户确认 pass | 用户反馈 #2 |
| 甲方手动验收 | ❌ **not green** | 用户反馈 2026-05-31; 5 个未关闭项 |
| 技术负责人评审 | 🟡 pending | 未进行 |
| 封面安装(same-signature) | 🟡 pending | 用户反馈 #1: "同样的包我装过了" |
| 上游合并/去重 | 🟡 待定 | 用户反馈 #7 |
| 设置分类页 | 🟡 待定 | 用户反馈 #8 |
| 基线预发布 | `phase-1-prebuild.26680259984` | 最新有效手动验收基线 |

### CI 基线详情

- CI run: `26686823386` — **Phase 1 CI** — ✅ success
- HEAD 当时: `7670673b0` (records: persist runtime smoke launcher review)
- 3/3 jobs: verify → build → runtime smoke 全部成功
- Runtime smoke 证据: 16/16 文件完整 (`status.txt`, `adb-install.txt`, `adb-launch.txt`, `window.txt`, `screenshot.png`, `screenshot-blankness.txt` 等)
- 截图亮度: `mean_luma=160.72` (非白屏)
- 当前 HEAD `ce5f6915d` 仅变更 records，未触发新 CI

---

## 2. 甲方反馈与 Worker 分工映射

甲方 5 个未关闭项 → 四个 worker：

| # | 甲方问题 | Worker | 预期产出 | 验收标准 |
|---|---|---|---|---|
| 3 | UP 主关键词语义不对 | **W1** matcher/quickAction 语义 | `keyword + exact` 在 user 分类下按 user 字段匹配 | UP 关键词只匹配用户名/UID，不混入 content 分类 |
| 6 | 推荐流标签屏蔽不生效 | **W2** 推荐 adapter/tag/旧过滤 | 推荐 adapter 读取视频标签并应用 tag 规则 | 标签屏蔽在推荐流卡片级生效 |
| 7 | 上游旧屏蔽和新系统重复 | **W2** 推荐 adapter/tag/旧过滤 | 旧屏蔽合并或静默 | 无重复屏蔽效果 |
| 4 | 长按卡片无封面预览 | **W3** 长按 UI/设置分类 | 长按卡片显示封面+可交互屏蔽选项 | PiliPlus 上游风格 |
| 8 | 设置页需分类 | **W3** 长按 UI/设置分类 | 设置页面按分类组织 | 用户可分类浏览/管理规则 |
| — | CI/构建/发布 | **W4** 治理/验证/发布证据 | 全 CI 证据链 + 预发布包 | 见下文 |

---

## 3. Worker 4 验证计划

### 3.1 触发条件

Worker 4 的验证只有在 W1/W2/W3 的代码变更提交到 `phase-1-shielding-core` 后方可执行。

### 3.2 验证工作流（GitHub Actions）

每次 W1/W2/W3 变更推送后：

1. **Phase 1 CI**（`ci.yml`）自动触发（push → `phase-1-shielding-core`）
   - Job 1: `Focused Flutter verification` — 屏蔽测试 + 设置模型测试 + 启动测试 + analyzer
   - Job 2: `Build Android x86_64 artifact` — dev APK（带 android-project-arg dev=1）
   - Job 3: `Android emulator runtime smoke` — 安装 + 启动 + 前台 + 截图 + 证据上传

2. 如果自动触发失败或需手动重跑：

```bash
# 手动触发全 CI
gh workflow run ci.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core

# 仅触发验证（不构建/不 smoke）
gh workflow run phase1_shielding_verify.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core
```

### 3.3 验证通过标准

| 检查项 | 命令/方法 | 通过条件 |
|---|---|---|
| Flutter 屏蔽测试 | `flutter test test/features/shielding` | 全部 pass |
| 设置模型测试 | `flutter test test/pages/setting/models/shielding_settings_test.dart` | 全部 pass |
| 启动测试 | `flutter test test/bootstrap/bootstrap_app_test.dart` | 全部 pass |
| Analyzer | `flutter analyze --no-fatal-infos` | 无 error / warning |
| APK 构建 | CI job `Build Android x86_64 artifact` | artifact 上传成功 |
| APK 安装 | emulator `adb install` | Success |
| 应用启动 | emulator `am start` | 组件存在、启动成功 |
| 前台 UI | `dumpsys window` | mCurrentFocus = 目标 Activity |
| 进程存活 | `pidof` | PID 存在 |
| 无崩溃 | logcat 检查 | 无 app crash/ANR |
| 非白屏 | 截图亮度检查 | mean_luma > 20（非全黑/全白） |

### 3.4 证据采集清单

每个 CI run 需收集以下证据文件（由 `android_runtime_smoke.sh` + 自动上传完成）：

```
runtime-smoke/evidence/
├── status.txt                    # 总体 pass/fail
├── adb-install.txt               # adb install 输出
├── adb-launch.txt                # am start 输出
├── launcher-component.txt        # launcher 解析的组件
├── launcher-resolution.txt       # launcher 分辨率策略
├── window.txt                    # dumpsys window
├── uiautomator.xml               # UI 树 dump
├── uiautomator-dump.txt          # uiautomator dump 日志
├── uiautomator-pull.txt          # uiautomator pull 日志
├── screenshot.png                # 截图
├── screenshot-blankness.txt      # 截图亮度分析
├── pidof.txt                     # 进程 PID
├── app-crash-error.txt           # app crash 检查
├── logcat.txt                    # logcat
├── logcat-crash-error.txt        # logcat crash/ANR 提取
└── runtime-smoke-metadata.txt    # 元数据
```

**16/16 文件完整 = runtime smoke 证据通过。**

---

## 4. 发布计划

### 4.1 Prebuild 发布流程

```bash
# Step 1: 验证 CI 通过后，获取 build run ID
gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Phase 1 CI" --branch phase-1-shielding-core --limit 3 --json databaseId,conclusion,headSha

# Step 2: 用 build.yml 签名并发布正式 prebuild（含 GH Release 上传）
# tag 模板: phase-1-prebuild.{run_id}
gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core \
  -f build_android=true -f build_ios=false -f build_mac=false \
  -f build_win_x64=false -f build_linux_x64=false \
  -f tag=phase-1-prebuild.{run_id}

# Step 3: 用 android_runtime_smoke.yml 验证正式构建
gh workflow run android_runtime_smoke.yml -R CometDash77/PiliAvalon-Worksite \
  --ref phase-1-shielding-core \
  -f artifact_run_id=<BUILD_RUN_ID> -f package_name=com.example.piliplus
```

> ⚠️ `build.yml` 依赖签名密钥（`SIGN_KEYSTORE_BASE64` secrets），仅在 `workflow_dispatch` 时签名。  
> 如果密钥不可用或 CI 仅用 dev APK，则跳过 Release 步骤，仅发布 artifact。

### 4.2 Prebuild 发布要求

| 要求 | 说明 |
|---|---|
| Release 类型 | `prerelease: true`，`make_latest: false` |
| Tag 格式 | `phase-1-prebuild.{BUILD_RUN_ID}` |
| Tag target | 验证通过的 commit SHA |
| Release 名称 | `"Phase 1 Prebuild - Manual Acceptance"` |
| 资产 | Android arm64-v8a + armeabi-v7a + x86_64 APK |
| 基线更新 | 成功后更新最新有效基线引用 |

---

## 5. 治理约束

### 5.1 CI Monitor 政策

依据 `.codex/hooks/guard_ci_monitor.py` 和 `worksite-ci-monitor-policy.md`：

- ❌ 禁止：`gh run watch`、长轮询、`tail -f`、`sleep` + `gh run list` 循环
- ✅ 允许：`gh run list --json`、`gh run view <id> --json`、一次性 artifact 检查
- 🟡 如果需要持续监控 CI：设置 `WORKSITE_AGENT_ROLE=monitor-agent`

### 5.2 不得标 green 的 gate

以下 gate 在甲方明确确认前始终为 🟡/🔴：

1. **甲方手动验收** — 等待甲方确认 W1/W2/W3 修复后的行为
2. **技术负责人评审** — 设计院/技术负责人未过审
3. **封面安装(same-signature)** — 仅用户反馈 #1 提及，未正式测试
4. **上游旧屏蔽合并完成确认** — 用户反馈 #7
5. **设置分类页可用性确认** — 用户反馈 #8

### 5.3 Rollback 路径

如果任何 gate 失败：

1. **不标记** Phase 1 green/stable/latest/accepted
2. **不重用** 失败 prebuild 作为验收证据
3. **保留** 失败 prebuild 作为 GitHub pre-release 证据记录
4. **还原或取代** `phase-1-shielding-core` 上的修复 commit 范围
5. **新 prebuild** 需要全新的 focused 测试、analyzer、Android 构建、runtime smoke 和 release notes

---

## 6. Release Notes 草稿

```markdown
# Phase 1 Shielding — 第二轮修复 Prebuild Release Notes

## Purpose

Validation-only prebuild for Phase 1 shielding second-round repair.
包含 W1 (matcher/quickAction 语义修正)、W2 (推荐 adapter/tag/旧过滤合并)、
W3 (长按 UI/设置分类)。仅用于自动化验证、runtime smoke 和甲方手动验收。

不是 stable、latest 或正式 Phase 1 验收发布。

## Release Type

prebuild / pre-release

## Branch / Commit / Tag

- Repository: CometDash77/PiliAvalon-Worksite
- Branch: phase-1-shielding-core
- Commit: <REPAIR_COMMIT_SHA>
- Tag: <phase-1-prebuild.NEW_RUN_ID>
- Release URL: <GITHUB_RELEASE_URL>

## 变更范围

- W1: user 分类下 keyword + exact 改为按 user 字段匹配（非 content 泛匹配）
- W2: 推荐流 adapter 读取视频标签并应用 tag 屏蔽规则；旧上游屏蔽合并入新系统
- W3: 长按卡片显示封面+推荐屏蔽对话框；设置页面按分类组织

## Automation Evidence

- Focused verify run: <URL> / <PASS_FAIL>
- Android build run: <URL> / <PASS_FAIL>
- Android runtime smoke run: <URL> / <PASS_FAIL>
- Runtime smoke 证据: 16/16 文件 <完整/不完整>
- Screenshot blankness: <mean_luma>

## Manual Acceptance

状态: pending

需甲方验收项：
1. UP 主关键词只在 user 分类下匹配用户名/UID
2. 推荐流标签屏蔽生效
3. 无新旧系统重复屏蔽
4. 长按卡片有封面预览
5. 设置页面有分类

## Rollback Plan

如果任何自动化、runtime-smoke 或手动验收 gate 失败：
- 不标记 Phase 1 green
- 保留失败 prebuild 为 pre-release 证据
- 还原或取代修复 commit 范围

## Not Covered / Still Yellow

- 甲方手动验收: pending
- 技术负责人评审: pending
- 正式 latest 发布: not covered
```

---

## 7. Yellow/Red 项目清单

| 项目 | 状态 | 说明 |
|---|---|---|
| W1 代码变更 | 🟡 pending | 需 W1 提交 |
| W2 代码变更 | 🟡 pending | 需 W2 提交 |
| W3 代码变更 | 🟡 pending | 需 W3 提交 |
| focused 验证 | 🟡 pending | 需 W1+W2+W3 提交后触发 |
| Android 构建 | 🟡 pending | 需 focused 验证通过 |
| runtime smoke | 🟡 pending | 需构建通过 |
| prebuild 发布 | 🟡 pending | 需 smoke 通过 |
| 甲方手动验收 | 🔴 not green | 等待修复后重新测试 |
| 技术负责人评审 | 🟡 pending | 等待设计院 |
| 基线 prebuild | ✅ 存在 | `phase-1-prebuild.26680259984` |
| CI 基线 | ✅ 存在 | run `26686823386` |
| 设计院评审记录 | ✅ 存在 | launcher 修复已过审 |

---

## 8. 关键命令速查

```bash
# 查看当前 CI 状态
gh run list -R CometDash77/PiliAvalon-Worksite --workflow "Phase 1 CI" --branch phase-1-shielding-core --limit 3 --json databaseId,displayTitle,conclusion,headSha,url

# 手动触发全 CI
gh workflow run ci.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core

# 仅触发 focused 验证
gh workflow run phase1_shielding_verify.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core

# 签名构建 + 发布
gh workflow run build.yml -R CometDash77/PiliAvalon-Worksite --ref phase-1-shielding-core \
  -f build_android=true -f build_ios=false -f build_mac=false \
  -f build_win_x64=false -f build_linux_x64=false \
  -f tag=phase-1-prebuild.{run_id}

# 单独 runtime smoke（引用构建 artifact）
gh workflow run android_runtime_smoke.yml -R CometDash77/PiliAvalon-Worksite \
  --ref phase-1-shielding-core \
  -f artifact_run_id=<BUILD_RUN_ID> -f package_name=com.example.piliplus

# 查看 GH Release
gh release view phase-1-prebuild.26680259984 -R CometDash77/PiliAvalon-Worksite --json tagName,isPrerelease,url

# 查看 CI run 日志
gh run view <RUN_ID> -R CometDash77/PiliAvalon-Worksite --log

# 查看特定 evidence
gh run view <SMOKE_RUN_ID> -R CometDash77/PiliAvalon-Worksite --artifact
```

---

## 9. 设计院通知要点（需人工审查后发送）

> 以下文本是为设计院准备的 status update，仅在 W1/W2/W3 提交后需要设计院介入时使用。

```text
Phase 1 Shielding 第二轮修复状态：

甲方于 2026-05-31 提交手动验收反馈，确认启动、无白屏、相关视频屏蔽通过；
发现 5 个未关闭项：(1) UP 主关键词语义不匹配预期；(2) 推荐流标签屏蔽不生效；
(3) 新旧屏蔽系统重复；(4) 长按卡片 UX 不够美观；(5) 设置页缺少分类。

已分配四个 Reasonix worker：
- W1 修复 matcher/quickAction 语义
- W2 修复推荐流 tag 读取和旧系统合并
- W3 实现长按卡片封面 UI 和设置分类
- W4 治理/验证/发布证据（本文件）

CI 基线已验证通过（run 26686823386），等待 W1/W2/W3 代码变更后触发新一轮全 CI。
新 prebuild 发布后请求甲方重新验收。

当前基线 prebuild: phase-1-prebuild.26680259984
```

---

**本文件由 Worker 4（治理/验证/发布证据）产出。  
所有 gate 状态为候选分析，不构成 Phase 1 验收结论。  
文件路径:** `records/worksite-communications/2026-05-31-reasonix-phase-1-shielding-worker-prompts.md`
