# OHOS Flutter 工具链核查

核查日期：**2026-10-17（UTC）**。执行环境：Linux x86_64，独立临时 SDK 检出和独立 `PUB_CACHE`。本记录对应应用基线 `849c56b035ac8acf1b4fd677c2c94debe161da8e`，该基线要求 Flutter **3.47.7**、Dart **>=3.13.0**。

## 结论

当前核查到的官方已发布版本及开发分支均未提供满足应用要求的现成 OHOS 工具链。维护者的个人工作仓已有基于 Flutter 3.47.7 的分支，但该分支默认下载的 OHOS Dart SDK 实际为 **3.12.2**，连 `flutter_tools` 自身的依赖解析也未通过。因此，不能把该分支认定为可直接构建本应用的 SDK。

当前适配分支可以继续整理新增的 OHOS 工程、平台依赖与隔离构建入口；完整应用编译和运行验收仍受下述工具链条件约束。应用的 Dart/Flutter 约束和已有组件实现应保持原样。

## 1. 官方仓库与版本证据

官方仓库已迁移至 [CPF-Flutter/flutter_flutter](https://gitcode.com/CPF-Flutter/flutter_flutter)。核查旧地址 `openharmony-sig/flutter_flutter` 与新地址的 Git refs 时，相关提交一致；后续配置应采用新地址。

使用公开 Git 接口取得的相关 refs 如下：

| 来源 | ref | 提交 | 核查含义 |
| --- | --- | --- | --- |
| 官方仓库 | `oh-3.41.9-release` / `3.41.9+ohos-1.0.2` | `62357a93d653bf844f730bb1f4b7cc9e2139d14e` | 当前 README 列出的最新稳定系列 |
| 官方仓库 | `oh-3.44.9-dev` | `3ffe70c6280cc6ddf613bffa59dd70611f238f7e` | 核查时最高的官方 Flutter 开发版本 |
| 官方仓库 | `3.44.9+ohos-0.0.1-canary1` | `39285df71a97ffe0c23241dcc459d997a9d8b7c6` | 3.44 系列的 canary 标签 |

官方全部 heads/tags 中未发现 3.47 ref。官方 README 的版本规划将 Flutter OH 3.47 排在 **2026 年 12 月**，并明确说明时间为预估；该计划不能代替已发布工具链。

复核命令：

```bash
git ls-remote --heads --tags https://gitcode.com/CPF-Flutter/flutter_flutter.git
```

官方 3.44 分支源码的 README 将其基线标记为 Flutter 3.44.9。PiliPlusX 参考分支固定的 `aa76d9bbeee7806a87dbd202d2550dfd11550b82` 也属于 Flutter 3.44.9 / Dart 3.12.2 路线。其降低应用 SDK 约束、调整依赖和回移组件 API 的做法未作为本次适配的工具链解决方案。

## 2. 个人 3.47.7 工作分支的实际验证

发现的候选为 [zhong_ning/flutter_flutter_344t347](https://gitcode.com/zhong_ning/flutter_flutter_344t347)，属于维护者个人工作仓，未作为官方稳定 SDK 发布。

| 项目 | 核查值 |
| --- | --- |
| 分支 | `oh-3.47.7-dev` |
| 检出提交 | `08a1121fbe49c37db3dbdc2611a73195ab8204de` |
| 提交时间 | `2026-10-16T20:05:19+08:00` |
| README 声明的 Flutter 基线 | 3.47.7 |
| Flutter 上游基线提交 | `abaf9c523780a608bd46686fd5e53740a07077f8`，与官方 `3.47.7` tag 对应 |
| `bin/internal/engine.version` | `deb287481e3ce9468f3434937ced4240a70539ca` |
| `bin/internal/engine.ohos.version` | `10a8d012d86cd7ee13e0acc859fea796c8a01764` |
| 下载得到的 Dart SDK 版本 | **3.12.2 stable** |
| 下载得到的 Dart SDK revision | `e7da8dddd3b32b81a1d83cebbb9109ea3f01fca5` |

### 下载可用性

按该分支 `update_dart_sdk.sh` 和缓存下载代码配置的路径，以以下地址为前缀核查产物：

```text
https://flutter-ohos.obs.cn-south-1.myhuaweicloud.com/flutter_infra_release/flutter/10a8d012d86cd7ee13e0acc859fea796c8a01764/
```

以下文件的 HTTP HEAD 均返回 200，服务端报告的修改日期均为 2026-09-03：

- `dart-sdk-linux-x64.zip`
- `sky_engine.zip`
- `flutter_patched_sdk.zip`
- `flutter_patched_sdk_product.zip`
- `ohos-arm64/artifacts.zip`
- `ohos-arm64-release/artifacts.zip`
- `ohos-arm64-release/linux-x64.zip`

这些结果只证明配置指向的文件可以下载。其中仅 Linux Dart SDK 被实际下载和执行；其余文件未进行本地解包或二进制兼容性验证。

### 实际执行结果

在独立临时目录中检出该提交，并使用独立 `PUB_CACHE` 执行：

```bash
CI=true FLUTTER_SUPPRESS_ANALYTICS=true \
  PUB_CACHE=/path/to/isolated-pub-cache \
  /path/to/isolated-flutter-ohos/bin/flutter --version --machine

/path/to/isolated-flutter-ohos/bin/cache/dart-sdk/bin/dart --version
```

直接执行已下载 Dart 二进制得到：

```text
Dart SDK version: 3.12.2 (stable) (Tue Aug 11 09:49:18 2026 +0800) on "linux_x64"
```

`flutter --version --machine` 在构建 Flutter 工具时停止于依赖求解，核心错误为：

```text
The current Dart SDK version is 3.12.2.

Because flutter_tools depends on dwds >=27.1.2 which requires SDK version
>=3.13.0-107.0.dev <4.0.0, version solving failed.
```

该提交的 `packages/flutter_tools/pubspec.yaml` 固定 `dwds: 27.1.2`。在明确复现错误后停止了脚本自身的重复尝试，没有调整依赖、替换 Dart 二进制或修改缓存里的版本字段。

据此，本次没有取得成功执行的 Flutter CLI 版本 JSON，没有执行应用的 `pub get`、HAP 构建或设备运行。可下载的旧产物不能证明候选工具链与 Flutter 3.47.7/Dart 3.13 兼容。

## 3. PiliPlus 原有 Flutter SDK 补丁

主线 `lib/scripts/patch.ps1` 的默认分支包含 **22 个 Flutter SDK 补丁**。应用依赖这些补丁公开的接口及既有行为，采用同一个 Flutter 版本仍需核查全部补丁。

在候选 `08a1121fbe49c37db3dbdc2611a73195ab8204de` 的另一个临时 worktree 中，读取原脚本的默认补丁数组，按原顺序逐个运行 `git apply --check`，检查成功后应用该补丁。为收集诊断，检查失败后继续检查后面的补丁；没有执行原 PowerShell 脚本中的全局 Git 配置、重置或公共缓存操作。

结果为 **19 个可应用、3 个发生上下文冲突**：

| 原有补丁 | 首个报告冲突的位置 | 已核查的原因 |
| --- | --- | --- |
| `text_selection.patch` | `packages/flutter/lib/src/widgets/text_selection.dart`，补丁原始 hunk 起点 3693 | OHOS SDK 在 `defaultTargetPlatform` 分支中新增了 `TargetPlatform.ohos`，原补丁要求的上下文不再连续 |
| `selectable_region.patch` | `packages/flutter/lib/src/widgets/selectable_region.dart`，补丁原始 hunk 起点 604 | `_getEffectiveConsecutiveTapCount` 的平台分支包含额外的 `TargetPlatform.ohos`，原补丁要替换的代码块与 SDK 不一致 |
| `scrollable_gesture.patch` | `packages/flutter/lib/src/widgets/page_view.dart`，补丁原始 hunk 起点 11 | OHOS 候选源码在 `rendering.dart` 与 `basic.dart` 两个 import 之间缺少原补丁上下文中的空行 |

这里的 19 个成功只表示相应文本补丁能够应用。完整原流程会在第 2 个补丁失败处停止；本次诊断没有证明完整补丁集可编译，也没有对冲突补丁完成所有 hunk 的最终合并。

后续应通过**新增的 OHOS SDK 补丁或受校验的适配步骤**对齐这些上下文，并保持 PiliPlus 原补丁的功能语义。每个适配步骤应校验预期源码或摘要，源码漂移时明确失败，再按完整原顺序应用并编译验证。

`patch.ps1` 后续还会处理 `material_ui` 的 **8 个默认补丁**。本次因 Flutter CLI 不能启动，尚未执行应用依赖解析及这些包级补丁的验证；它们不包含在上面的 22 个统计中。

## 4. 工具链验收条件

继续推进完整应用编译前，应满足以下条件并记录证据：

1. **固定可复现的 SDK 来源与提交。** 明确官方发布或审核过的工作分支来源，同时保存对应的 Flutter、Dart 和 OHOS engine revision。
2. **真实版本满足主线。** `flutter --version --machine` 能成功执行并报告与主线一致的 Flutter 3.47.7 版本；直接执行宿主 Dart 二进制，确认其满足 `>=3.13.0`。不通过改缓存、造标签或放宽应用约束来代替兼容性。
3. **宿主与目标产物配套。** 宿主 Dart、前端编译器、`sky_engine`、patched SDK、`gen_snapshot` 与目标 OHOS engine 应来自可验证的同一套构建关系，Dart 3.13 运行时和快照格式兼容。用一个较新的宿主 Dart 启动工具，不能单独证明旧 OHOS 目标 engine 可运行生成结果。
4. **CLI 与平台构建链可用。** OHOS 平台被工具识别，`flutter build hap --help` 可用，平台 SDK/Hvigor 环境检查通过。
5. **保留完整应用的 SDK 行为。** 22 个 Flutter SDK 补丁及所需包级补丁完成显式适配、顺序应用与编译验证；不跳过失败补丁，不使用精简入口代替 `lib/main.dart`。
6. **再验证实际依赖和运行。** 在隔离目录中解析完整依赖、构建 HAP，并开展基础启动及现有功能的设备验证。工具链通过验收仍不能代替插件兼容性和设备验收。

当前状态：**工具链未通过验收，未构建 HAP。** 本记录作为后续选择 SDK 和复查阻塞的依据。
