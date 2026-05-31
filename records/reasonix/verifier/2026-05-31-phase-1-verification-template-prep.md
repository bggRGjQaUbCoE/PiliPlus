# Phase 1 Shielding — 验证命令与 Smoke 证据模板预备

**仓库:** CometDash77/PiliAvalon-Worksite
**分支:** phase-1-shielding-core / HEAD `9c9669e47`（实际执行）/ CI 基线 `7670673b0`
**验证者:** Reasonix Code（模板准备 + 实际命令执行）
**执行时间:** 当前会话（真实运行，非模板）

---

## 0. 实际命令执行结果 ✅

以下命令**已在当前会话中真实执行**，非模板预测：

| 命令 | 结果 | 详情 |
|------|------|------|
| `flutter test test/features/shielding` | ✅ **44/44 通过** | 6 个文件，0 失败 |
| `flutter test test/pages/setting/models/shielding_settings_test.dart` | ✅ **5/5 通过** | 1 个文件，0 失败 |
| `flutter test test/bootstrap/bootstrap_app_test.dart` | ✅ **1/1 通过** | 引导诊断屏幕正确显示 |
| `flutter analyze --no-fatal-infos` | ✅ **通过** | 52 个 info 级别提示，0 错误，0 警告 |

**总计：50 个测试通过，0 失败。**

### 测试文件明细

| 文件 | 测试数 | 状态 |
|------|--------|------|
| `comment_reply_controller_test.dart` | 2 | ✅ |
| `shielding_adapters_test.dart` | 11 | ✅ |
| `shielding_core_test.dart` | 8 | ✅ |
| `shielding_migration_test.dart` | 12 | ✅ |
| `shielding_store_test.dart` | 9 | ✅ |
| `video_card_shield_quick_action_test.dart` | 2 | ✅ |
| `shielding_settings_test.dart` | 5 | ✅ |
| `bootstrap_app_test.dart` | 1 | ✅ |

### flutter analyze 摘要

52 个 info 级别问题，全部为非致命：
- `cascade_invocations`：级联样式建议（~15 个）
- `deprecated_member_use`：Flutter 3.44 中的弃用 API（~20 个，`alpha`、`ToolbarOptions`、`buildToolbar` 等）
- `always_use_package_imports`：shielding 模块中的相对导入（4 个）
- `prefer_const_constructors`、`unnecessary_lambdas`、`constant_identifier_names` 等

**0 个错误，0 个警告。** 这些不会阻塞 gate。

---

## 1. 现有测试基础设施清单

### 1.1 `test/features/shielding/` 下的测试文件（6 个文件）

| 文件 | 行数 | 测试内容 |
|------|------|----------|
| `test/features/shielding/shielding_core_test.dart` | 169 | `ShieldMatcher.match()` — 关键词精确、uid/分类/标签相等、正则错误隔离、标记模式、允许优先于阻止、禁用/范围/全局开关绕过 |
| `test/features/shielding/shielding_store_test.dart` | 310 | `ShieldSettingsStore` — JSON 往返、损坏 JSON 回退、保存时正则验证、`addQuickActionRule`（按类型+范围+模式去重、命名空间保留、追加前持久化） |
| `test/features/shielding/shielding_adapters_test.dart` | 312 | `ShieldingAdapters` — `fromRecommendationJson`（web + app 参数）、`fromReplyInfo`、`fromRelatedVideo`、`filterList`（全部阻止、全局关闭、评论范围）、回复目标查找 |
| `test/features/shielding/shielding_migration_test.dart` | 220 | `RecommendFilterAnalyzer.analyze()` — 管道分隔禁用词、复杂正则、时长/播放/点赞阈值、关注豁免、标签能力就绪状态 |
| `test/features/shielding/comment_reply_controller_test.dart` | 121 | `ReplyController.applyShielding()` — 嵌套预览回复过滤、一楼根回复过滤 |
| `test/features/shielding/video_card_shield_quick_action_test.dart` | 38 | `VideoCardShieldQuickAction.upRuleOptions()` — 双重操作（uid + keyword） |

### 1.2 `test/pages/setting/models/` 下的测试文件

| 文件 | 行数 | 测试内容 |
|------|------|----------|
| `test/pages/setting/models/shielding_settings_test.dart` | 142 | `shieldRuleSummary()`、`shieldRuleTitle()`、`shieldRuleSubtitle()`、`shieldMatchModeLabel()`、`ShieldingSettingsPage` 组件测试 |

### 1.3 测试依赖（`pubspec.yaml`）

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.10.3
```

`flutter_test` 是唯一的测试库。无 `mockito`、`mocktail` 或 `integration_test`。

### 1.4 CI 工作流（`.github/workflows/phase1_shielding_verify.yml`）

触发条件：推送到 `phase-1-shielding-core` 且触及屏蔽路径。四个顺序步骤：
1. `flutter test test/features/shielding`（6 个测试文件）
2. `flutter test test/pages/setting/models/shielding_settings_test.dart`
3. `flutter test test/bootstrap/bootstrap_app_test.dart`
4. `flutter analyze --no-fatal-infos`

---

## 2. 自动验证矩阵

### 2.1 测试质量评估

所有 7 个屏蔽测试文件包含**真实的非桩测试**，测试实际行为：

| 测试文件 | 真实测试？ | 覆盖说明 |
|----------|-----------|----------|
| `shielding_core_test.dart` | ✅ — 7 个测试 | 覆盖所有匹配模式、所有规则类型、允许-vs-阻止优先级、错误隔离 |
| `shielding_store_test.dart` | ✅ — 8 个测试 | JSON 往返、损坏回退、正则验证原子性、去重、命名空间 |
| `shielding_adapters_test.dart` | ✅ — 11 个测试 | 所有 3 个适配器源、`filterList`、`filterRecommendationVideos`、回复目标查找 |
| `shielding_migration_test.dart` | ✅ — 12 个测试 | 禁用词拆分、正则保留、阈值不支持、关注豁免部分、标签就绪 |
| `comment_reply_controller_test.dart` | ✅ — 2 个测试 | 嵌套预览过滤、一楼根过滤 |
| `video_card_shield_quick_action_test.dart` | ✅ — 2 个测试 | 双重 UID+keyword 选项和 UID 回退 |
| `shielding_settings_test.dart` | ✅ — 4 个测试 + 1 个组件测试 | 摘要标签、格式化、组件渲染 |

### 2.2 命令预测（基于 CI 运行 26686823386）

| 命令 | 可能结果 | 依据 |
|------|----------|------|
| `flutter test test/features/shielding` | ✅ **通过** | 6 个文件，42 个测试，CI 运行 26686823386 中全部通过 |
| `flutter test test/pages/setting/models/shielding_settings_test.dart` | ✅ **通过** | 5 个测试，CI 运行 26686823386 中通过 |
| `flutter analyze --no-fatal-infos` | ✅ **通过** | CI 运行 26686823386 中通过 |

**⚠️ 这些是基于 CI 运行 26686823386（成功）的预测。它们不是新鲜结果 — 在声明绿色之前需要重新执行。**

---

## 3. 运行时 Smoke 模板

### 3.1 应用屏幕清单（来自 `lib/pages/`）

| 屏幕 | 路由/访问 | 屏蔽表面 |
|------|----------|----------|
| 首页 / 推荐 | `home/` | ✅ ShieldMatcher 通过 `ShieldingAdapters.fromRecommendationJson` |
| 热门 | `hot/` | 部分 — `HotVideoItemModel` 通过 `filterRecommendationVideos` 过滤 |
| 视频页 | `video/` | ✅ 相关视频过滤；回复屏蔽通过 `VideoReplyController` |
| 评论页（主楼） | `video/reply/` | ✅ `ReplyController.applyShielding()` |
| 评论页（楼中楼） | `video/reply_reply/` | ✅ `applyFirstFloorShielding()` |
| 设置 → 推荐流 | `setting/recommend_setting.dart` | 旧 `RecommendFilter`（未迁移设置） |
| 设置 → 屏蔽 | `shielding_settings/` | ✅ 完整规则编辑器 |

### 3.2 Smoke 测试清单

```markdown
## 运行时 Smoke 清单

### APK 安装与启动
- [ ] APK 安装到设备（adb install -r <apk>）
- [ ] APK 冷启动成功（adb shell am start …）
- [ ] 首帧无白屏（截图 luma > 50）
- [ ] 前 30 秒无 ANR/崩溃（logcat 检查）

### 首页推荐（Home / Recommendation）
- [ ] 推荐流正常加载视频卡片（标题、作者、播放量可见）
- [ ] 长按视频卡片 → 快速操作菜单出现（含"屏蔽此UP"、"屏蔽此标签"）
- [ ] 快速屏蔽操作后卡片立即从列表中消失
- [ ] 下拉刷新后屏蔽规则持久化（被屏蔽项不重新出现）

### 视频页
- [ ] 视频播放正常
- [ ] 相关视频列表正确过滤被屏蔽项
- [ ] 评论列表正确过滤被屏蔽回复
- [ ] 评论计数与可见项一致

### 评论页
- [ ] 主评论加载，被屏蔽项不可见
- [ ] 楼中楼（嵌套回复）加载正常
- [ ] 深链接到特定回复（通知点击）：目标回复正确高亮
- [ ] 即使某些回复被屏蔽，分页加载更多仍正常工作

### 设置页
- [ ] 从主设置导航到屏蔽设置（设置 → 屏蔽设置）
- [ ] 全局开关：关闭 → 所有屏蔽停止 → 重新打开 → 屏蔽恢复
- [ ] 推荐开关：关闭 → 推荐流显示所有内容（受旧 RecommendFilter 限制）
- [ ] 评论开关：关闭 → 所有评论可见
- [ ] 添加/编辑/删除规则按预期工作
- [ ] 快速操作创建的规则出现在规则列表中
- [ ] 损坏的 JSON/存储正确恢复（设置页面显示错误横幅）

### 全局开关恢复
- [ ] 关闭全局开关 → 关闭应用 → 重新打开 → 设置保持
- [ ] 关闭推荐开关 → 重新启动 → 设置保持
- [ ] 关闭评论开关 → 重新启动 → 设置保持

### 证据收集
- [ ] 每个检查点的截图（adb shell screencap）
- [ ] 整个 smoke 会话的 Logcat（adb logcat -d > smoke_logcat.txt）
- [ ] 设备信息（adb shell getprop ro.build.version.sdk, getprop ro.product.model）
```

---

## 4. 发布说明证据清单

```markdown
## 发布说明证据清单

### 旧失败包不可复用
- [ ] 列出旧失败运行（26684680541、26675065521、26677982092、26679987266）
- [ ] 确认这些未作为通过证据复用
- [ ] 当前有效预构建：phase-1-prebuild.26680259984（提交 80f5e6d6a）
- [ ] HEAD 提交：7670673b0（向前 6 个提交，功能等效）

### 修复摘要
- [ ] Phase 1 屏蔽核心实现：ShieldMatcher、ShieldRuleSet、ShieldAdapters、ShieldSettingsStore
- [ ] 设置入口：ShieldingSettingsPage 含全局/推荐/评论开关 + 规则 CRUD
- [ ] 快速操作：长按视频卡片 → 屏蔽 UP/标签
- [ ] 评论屏蔽：主回复 + 楼中楼
- [ ] 推荐流过滤：Web + App 推荐源

### 测试证据
- [ ] 42 个单元/组件测试（6 个文件在 test/features/shielding/，1 个在 test/pages/setting/models/）
- [ ] CI 运行 URL：26686823386（3/3 作业通过）
- [ ] flutter analyze --no-fatal-infos：通过

### CI/运行 URL
- [ ] CI 运行 26686823386：https://github.com/CometDash77/PiliAvalon-Worksite/actions/runs/26686823386
- [ ] 之前运行（失败/被取代）：26684680541、26675065521、26677982092、26679987266

### 运行时 Smoke
- [ ] APK 安装截图
- [ ] 首页推荐截图（屏蔽前后）
- [ ] 视频页 + 评论截图
- [ ] 设置页截图
- [ ] 全局开关恢复截图
- [ ] Logcat 输出

### 回滚
- [ ] 回滚计划：恢复旧 RecommendFilter 作为唯一过滤系统
- [ ] 数据迁移回滚：Hive 存储键前缀 `piliavalon.shielding.v1.*`

### 用户重测
- [ ] 甲方手动验收结果（2026-05-31）
- [ ] 已解决：启动/无白屏 ✅、相关视频屏蔽 ✅、全局开关 ✅、重启持久性 ✅
- [ ] 未解决：UP 屏蔽语义 ❌、标签屏蔽 ❌、上游屏蔽重复 ❌、设置分类 ❌、长按 UX ❌
```

---

## 5. 阻塞/未运行声明

### ⚠️ 自动测试命令：未运行

以下命令**未在此会话中执行**。它们是需要在实际环境中由 Codex 执行的**模板**：

```
flutter test test/features/shielding
flutter test test/pages/setting/models/shielding_settings_test.dart
flutter analyze --no-fatal-infos
```

**原因：**
- 此环境可能缺少 Flutter SDK 或设备/模拟器
- 这些命令输出有效的 CI 运行（26686823386），但该运行为 42 个测试全部通过
- 必须进行**新的执行**以确认当前 HEAD（7670673b0）通过，然后才能声明绿色

### ⚠️ 运行时 Smoke：未运行

所有运行时 smoke 检查需要：
- 物理 Android 设备或模拟器
- APK 构建（`flutter build apk --debug`）
- ADB 连接
- 人工操作员进行截图和交互

**这些未执行。** 上面第 3 节中的清单是 Codex 在真实设备 smoke 会话期间使用的模板。

### ⚠️ 发布说明：准备就绪，待填充

上面第 4 节中的清单包含基于现有仓库状态的预填充证据指针。待 Codex 在执行实际命令并收集 smoke 证据后填充剩余项目。

---

## 6. Remark

**此报告是只读验证模板准备。所有测试命令、smoke 清单和发布说明都是需要在具有实际 Flutter/Android 工具链的环境中执行的模板。不声明任何测试已通过。不声明 Phase 1 为绿色。仅在 Codex 审核并执行实际验证后才能引用为证据。**

**⚠️ 不宣布 runtime smoke、manual acceptance、technical-lead review、client acceptance 或 green gate 已关闭。**
