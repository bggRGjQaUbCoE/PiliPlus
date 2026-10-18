# OHOS 工具链验证

验证日期：2026-10-17 UTC。执行环境：Linux x86_64，独立 Flutter checkout、
Pub 缓存和构建副本。本轮按照用户最新要求，**只使用官方
`CPF-Flutter/flutter_flutter:oh-3.44.9-dev`**。上游应用的 `.fvmrc`、SDK 声明
及原平台构建保持原样，3.44 兼容性只在 OHOS 副本内实现。

## 固定来源与实际执行结果

| 项目 | 本轮固定或实际读到的值 |
| --- | --- |
| 官方仓库 | `https://gitcode.com/CPF-Flutter/flutter_flutter.git` |
| 分支 | `oh-3.44.9-dev` |
| 固定提交 | `3ffe70c6280cc6ddf613bffa59dd70611f238f7e` |
| 官方版本 tag | `3.44.9+ohos-0.0.1-canary1` |
| tag 指向 | `39285df71a97ffe0c23241dcc459d997a9d8b7c6` |
| Flutter 实际版本 | `3.44.9+ohos-0.0.1-canary1` |
| Dart 实际版本 | `3.12.2` |
| 主机 engine | `5a2a6a42cce67f965cf540fcecf616faca624aa1` |
| OHOS engine | `24497d6833225b0445953e1dd05dc6538c16a8dd` |
| HarmonyOS command line tools | `26.0.0.621` |
| 随 command line tools 提供的 SDK | `26.0.0.32`，API 26 Beta2 |
| Java | OpenJDK 17 |
| 本轮编译目标 | OHOS arm64，release，unsigned |

来源：[官方指定分支](https://gitcode.com/CPF-Flutter/flutter_flutter/tree/oh-3.44.9-dev)、
[SDK 固定配置](../../tool/ohos/sdk_compat/manifest.json)、
[PiliPlusX 的原生工具配置](https://github.com/Goodwu/PiliPlusX/blob/997244ba9dfe8177f600c3a85b89d7cf7f112608/.github/workflows/ohos.yml)、
[固定的 setup-ohos 脚本](https://github.com/ErBWs/setup-ohos/blob/5c8e74d05fc9888a387b6154ba06d0cd9ede3da1/setup.sh)、
[原生 SDK 发布归档](https://github.com/ErBWs/ohos-sdk/releases/tag/26.0.0.621)。
原生 SDK 两个 Linux 归档分片均按该发布的 SHA-256 核对后解压。

## 官方 SDK 准备方式

`tool/ohos/prepare_sdk.py` 从官方仓库获取固定提交、真实 tag 及其祖先历史，
由 Flutter 自身计算版本，随后下载和实际执行 Dart/Flutter 工具。不制造 Git
标签、不把旧 Dart 标为新版本、不使用其他维护者的 3.47 工作仓。

上游仍要求 Flutter 3.47.7 / Dart >=3.13.0。用户指定 3.44 后，生成副本改为
Flutter >=3.44.0 <3.45.0 / Dart >=3.12.0 <4.0.0；这个声明调整只有配合实际
源码兼容补丁、Pub 解析和编译才有意义。原包名 `PiliPlus` 已通过该 SDK 的
Pub 实测，无需批量小写化导入。

## 上游 Flutter 补丁

保留原 `lib/scripts/patch.ps1` 的默认 22 项补丁语义：19 项原样使用，3 项针对
3.44/OHOS 的上下文精确回移。涉及的 35 个 SDK 文件固定应用前、应用后摘要。
脚本通过临时 Git index 预检整条补丁链，然后才改变独立 SDK；原上游补丁文件
全部只读。详情及回移原因见 [SDK 补丁说明](../../tool/ohos/sdk_compat/README.md)。

已实际验证：

- 准备后的 Flutter 核心库可编译。
- 4 项 Flutter 控件测试通过：WidgetSpan 原文/偏移映射、OHOS PageView 翻页、
  TabBarView 手势传递与切页、OHOS 富文本全选保留 WidgetSpan 原文。
- 重复准备和 `--check` 复验通过。
- 在隔离工作树中故意破坏最后一个补丁，前面的补丁不会落到实际 SDK 或 Git index。
- `ohos.py doctor` 检查固定仓库、提交、实际 Flutter/Dart 版本及 HAP 命令，通过。

## 原生宿主构建验证

本轮使用本分支的 OHOS 工程、`PiliPlusPlatformPlugin` 和最小 Flutter 入口
单独编译宿主。首次 ArkTS 编译发现 SDK 的 `getPlugins()` 返回可空类型，
已在 `EntryAbility` 明确检查注册表，再注册本地插件。

修复后 `flutter build hap --release --no-codesign --no-pub` 成功，产物约
19.4 MB，包含 arm64 的 `libapp.so` 和 `libflutter.so`。这证明原生工程、
后台化通道及 HarmonyOS 构建工具组合能够完成编译。

**宿主夹具使用最小入口，不能作为完整 PiliPlus 已构建、已启动的证据。**
完整应用的当前解析、编译和设备验证状态记录在 [适配首页](README.md)。

## 复验

```sh
python3 tool/ohos/prepare_sdk.py \
  --flutter-root /path/to/dedicated-flutter-ohos \
  --pub-cache /path/to/dedicated-ohos-pub-cache
python3 tool/ohos/prepare_sdk.py \
  --flutter-root /path/to/dedicated-flutter-ohos \
  --pub-cache /path/to/dedicated-ohos-pub-cache --check
python3 tool/ohos/ohos.py doctor \
  --flutter /path/to/dedicated-flutter-ohos/bin/flutter
```

SDK 验证夹具在 `tool/ohos/sdk_compat/validation`，需使用同一 SDK 解析其独立
依赖后运行 `flutter test`。不要在开发源目录运行会改写原锁文件的 OHOS Pub。
