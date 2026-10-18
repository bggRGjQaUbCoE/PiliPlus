# 官方 Flutter OHOS SDK 的准备与复验

本目录固定用户指定的官方 `oh-3.44.9-dev`，在独立 SDK 中保留 PiliPlus
`lib/scripts/patch.ps1` 默认顺序的全部 22 个 Flutter 源码补丁。
`manifest.json` 是版本、补丁顺序和内容校验的共同配置；脚本不修改应用仓库原文件。

## 固定来源

| 项目 | 固定值 |
| --- | --- |
| 官方仓库 | <https://gitcode.com/CPF-Flutter/flutter_flutter.git> |
| 分支 | `oh-3.44.9-dev` |
| SDK 提交 | `3ffe70c6280cc6ddf613bffa59dd70611f238f7e` |
| 官方版本标签 | `3.44.9+ohos-0.0.1-canary1` |
| 标签提交 | `39285df71a97ffe0c23241dcc459d997a9d8b7c6` |
| OHOS engine 提交 | `24497d6833225b0445953e1dd05dc6538c16a8dd` |
| 主机 Flutter engine 提交 | `5a2a6a42cce67f965cf540fcecf616faca624aa1` |
| 实际 Dart | `3.12.2` |

2026-10-17（UTC）在 Linux x86_64 上实测，`flutter --version --machine`
报告 `3.44.9+ohos-0.0.1-canary1`，直接运行下载的 Dart 二进制也报告 `3.12.2`。
`git describe --match '*.*.*' --long --tags HEAD` 的结果为
`3.44.9+ohos-0.0.1-canary1-180-g3ffe70c62`。这些值来自官方真实标签及其历史。

## 准备

需要 Python 3.10 或更新版本、Git，以及访问官方 Git 仓库、Flutter 产物服务器和
pub 包服务器的网络。使用独立 SDK 和独立 `PUB_CACHE`，两者均放在应用仓库外。

在 PiliPlus 仓库根目录执行：

```bash
python3 tool/ohos/prepare_sdk.py \
  --flutter-root /tmp/piliplus-ohos-flutter344-build \
  --pub-cache /tmp/piliplus-ohos344-pub-cache
```

目标目录不存在时，脚本从固定官方提交创建 SDK。目录已存在时，脚本核对仓库来源、
HEAD、官方标签及其祖先关系、engine pin 和本地源码状态。已有手动修改、部分补丁、
暂存修改、非忽略的未跟踪文件都会要求人工检查；脚本不会重置或覆盖这些修改。

首次准备会下载实际 Dart 和 Flutter 工具依赖。若 SDK 以前在缺少官方标签历史时
启动过，Flutter 可能缓存了 `0.0.0-unknown`；脚本获取真实标签及其历史后，只移除
SDK 内自动生成的 `bin/cache/flutter.version.json`，由原版 Flutter 版本算法重新生成。
脚本先完成一次普通版本查询，以免首次下载输出混入随后的 `--machine` JSON。
固定提交使用 detached HEAD；官方 Flutter 的 `repositoryUrl` 只读取分支的
`@{upstream}`，此时可能如实显示 `unknown source`。脚本仍独立核对 Git 的
`origin` 必须是上述官方 URL、HEAD 必须是固定提交，并检查实际 Flutter / Dart / engine
版本；不会为补齐这个显示字段创建虚构的标签、分支或版本缓存。

补丁应用前，脚本校验原 `patch.ps1`、22 个原补丁和 3 个兼容补丁的 SHA-256。
全部补丁先在临时 Git index 中顺序应用，核对全部 35 个输出文件的哈希，再将整体
diff 一次应用到 SDK 工作目录。SDK 自身的 Git index 保持原状。重复运行会识别已
准备的完整结果，并重新验证实际版本。

成功后生成：

```text
<flutter-root>/bin/cache/piliplus-ohos-sdk.json
```

其中记录固定来源、配置文件哈希、22 个补丁、35 个源码文件前后哈希、实际 Flutter / Dart
版本、SDK 和包缓存路径。后续所有应用构建命令都应使用相同 SDK 和 `PUB_CACHE`。

## 三个兼容补丁的范围

另外 19 个补丁直接读取 PiliPlus 的原文件。下面三个文件完整替代各自原补丁在此固定
SDK 上的应用；原补丁本身仍通过哈希检查，方便同步上游时发现变化。

| 补丁 | 官方 3.44 与主线补丁的差异 | 保留的原行为 |
| --- | --- | --- |
| `text_selection.ohos.patch` | OHOS 在被注释的平台 switch 中增加了一个 case | 保留主线在各平台使用触摸文字选择手势的修复，并覆盖 OHOS case |
| `selectable_region.ohos.patch` | OHOS 的平台 case、3.44 选择偏移表达式、3.44 的选择手柄 leader layer 代码不同 | 保留主线选择框合并、选择范围钳制、WidgetSpan 原文、段落选择及公开接口；保留仍被 3.44 使用的 leader layer 代码 |
| `scrollable_gesture.ohos.patch` | 3.44 PageView 使用显式 `show` 导入，导入块空行不同 | 加入所需的 `ValueGetter` 和横向手势类型，保留全部构造器及 TabBarView → PageView → Scrollable 的手势工厂传递 |

兼容结果不需要参考项目的全 SDK `TargetPlatform` 正则替换或额外指针过滤机制。
`WidgetSpan.rawText`、`SelectableRegionState` 的公开选择接口等均来自当前 PiliPlus
原补丁。官方 3.44 已有 `PageView.scrollCacheExtent`。

## 复验

```bash
python3 tool/ohos/prepare_sdk.py \
  --flutter-root /tmp/piliplus-ohos-flutter344-build \
  --pub-cache /tmp/piliplus-ohos344-pub-cache \
  --check
```

`--check` 核对准备记录与当前配置、SDK 来源、源码哈希和实际版本，不拉取 Git 历史或
重新应用补丁。Flutter 自身仍可能更新其自动生成的缓存。SDK 或上游补丁更新后，应先
人工审阅变化，再更新 manifest 和对应兼容补丁；不能只更改版本号或更新哈希来略过冲突。

本目录的 `validation/` 提供独立 Flutter 控件验证。先复制到仓库外，再运行：

```bash
cp -R tool/ohos/sdk_compat/validation /tmp/piliplus-ohos344-sdk-validation
cd /tmp/piliplus-ohos344-sdk-validation
CI=true FLUTTER_SUPPRESS_ANALYTICS=true \
  PUB_CACHE=/tmp/piliplus-ohos344-pub-cache \
  /tmp/piliplus-ohos-flutter344-build/bin/flutter test --reporter expanded
```

测试检查 WidgetSpan 原文映射、OHOS 下 PageView 和 TabBarView 手势工厂的实际滑动，
以及富文本的全选结果。它同时编译补丁后的 Flutter 核心控件库。

2026-10-17（UTC）的 Linux x86_64 实测结果：上述 4 项测试全部通过；重复准备和
`--check` 均通过。另在一次性 SDK 工作树中将最后一个补丁替换为无效内容，脚本在
临时 index 阶段拒绝，SDK 工作目录和真实 index 均保持干净。

SDK 准备记录仅证明指定主机工具链可以启动且源码补丁符合审阅结果。应用完整编译、
OHOS 原生依赖链接、HAP 打包和真机行为应在应用构建流程中分别验证。
