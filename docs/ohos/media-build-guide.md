# OHOS 完整应用构建：当前 media-kit 接入

本目录用于 `Goodwu/PiliPlus:feature/ohos`。复用既有官方 CPF Flutter、OHOS 宿主及依赖适配；当前媒体后端已经接入构建副本，不再使用播放暂缓入口。PiliPlusX 只作参考。

开发 checkout 保留原 `lib/`、`pubspec.yaml`、`pubspec.lock`、`.fvmrc` 和原平台工程。所有真实应用改动发生在工具生成的隔离副本中，前后像和源摘要记录在 `ohos/source-manifest.json` 及 `ohos/media-backend.json`。源码保护并不等于无需维护这些兼容补丁。

## 所需环境

Python 3.12+、Git、Java 17、HarmonyOS command line tools 26.0.0.621 及其 OHPM/Hvigor、原生构建工具。原生仓库还需要 Meson 1.6.1、Ninja、CMake、pkg-config、gperf 等；完整依赖安装可对照 `.github/workflows/ohos-build.yml`。

```sh
export PILIPLUS_OHOS_COMMAND_LINE_TOOLS=/absolute/path/to/command-line-tools
export HOS_SDK_HOME="$PILIPLUS_OHOS_COMMAND_LINE_TOOLS/sdk"
export OHOS_NDK_HOME="$HOS_SDK_HOME/default/openharmony"
export PATH="$PILIPLUS_OHOS_COMMAND_LINE_TOOLS/bin:$PILIPLUS_OHOS_COMMAND_LINE_TOOLS/tool/node/bin:$PATH"
export PUB_CACHE=/absolute/path/to/dedicated-ohos-pub-cache
```

SDK、Pub 缓存、原生源码和构建副本使用独立目录，不修改其他项目的共享 SDK/缓存。只使用当前已提交的源码进行构建。

## 1. 准备当前媒体 SDK 和原生源码产物

准备干净的 `Goodwu/media-kit:compat/piliplus-zero-change-20261018` checkout。准备当前 `Goodwu/libmpv-ohos-build:main`，按其配方运行 `bundle.sh`；它在编译前检查维护源码与 source-lock，一致后才构建，不复用旧 libmpv 二进制。源锁漂移必须复核，不能关闭检查。

```sh
# 在已配置 OHOS NDK 和原生工具链的 native-build checkout 中执行。
./bundle.sh
(cd libmpv/arm64-build && sha256sum -c SHA256SUMS)
```

然后为应用设置四项必需输入：

```sh
export PILIPLUS_MEDIA_KIT_ROOT=/absolute/path/to/clean-current-media-kit
export MEDIA_KIT_OHOS_LIBMPV_ARCHIVE=/absolute/path/to/native-build/libmpv/arm64-build/libmpv_aarch64.zip
export MEDIA_KIT_OHOS_LIBMPV_SHA256=$(sha256sum "$MEDIA_KIT_OHOS_LIBMPV_ARCHIVE" | cut -d' ' -f1)
export PILIPLUS_OHOS_LIBMPV_LIBRARY=/absolute/path/to/native-build/libmpv/arm64-build/libmpv.so
```

**必须保留 `libmpv.so` 同目录的 `manifest.json`**。它必须标识同一 ZIP/SO，并包含真实编译的 WebP 两种编码器及封装器能力。旧包、缺项、摘要不符、越界路径均拒绝，不回退历史下载。这里是构建来源输入，不是实验性运行开关。

## 2. 准备应用所用的官方 CPF SDK

```sh
python3 tool/ohos/prepare_sdk.py \
  --flutter-root /absolute/path/to/dedicated-flutter-ohos \
  --pub-cache "$PUB_CACHE"
python3 tool/ohos/ohos.py doctor \
  --flutter /absolute/path/to/dedicated-flutter-ohos/bin/flutter
```

保留原官方 `CPF-Flutter/flutter_flutter:oh-3.44.9-dev` 精确审查配方、engine 身份与应用 SDK 补丁。doctor 只检查工具链，不是媒体、HAP 或设备认证。现有旧审计字段应结合本轮媒体和构建回执理解，不能覆盖其实际状态。

## 3. 导出、适配并构建真正的应用入口

```sh
python3 tool/ohos/ohos.py check-source
python3 -B -m unittest discover -s tool/ohos -p 'test_*.py' -v
python3 tool/ohos/ohos.py prepare-build --output /absolute/new/PiliPlus-ohos-build
python3 /absolute/new/PiliPlus-ohos-build/tool/ohos/build.py \
  --workspace /absolute/new/PiliPlus-ohos-build \
  --flutter-root /absolute/path/to/dedicated-flutter-ohos \
  --pub-cache "$PUB_CACHE"
```

输出目录必须不存在且位于 checkout 之外。prepare-build 导出提交、核对原主线文件、导出当前媒体 SDK，先按七文件原像/后像应用方向 B，再叠加已有 OHOS/Dart 兼容补丁和真实插件。SDK 内部共享 Swift 源文件链接按 Git 链接原文校验，必须指向导出目录内已有文件。

完整 build.py 检查 SDK，执行 Pub 和已准备依赖的路径/源码验证，运行 parser/UI 测试，分析全 `lib/`，构建 `lib/main.dart` 的 ARM64 Release 未签名 HAP，并确认应用版本、ARM64 ELF 和实际包内媒体库与本轮产物一致。准备后的 app Dart/SDK 源码在前后均复核。失败保留完整日志并返回非零。

产物通常在副本 `build/ohos/hap/entry-default-unsigned.hap`。证据在 `ohos/build-result.json`、`ohos/build-logs/`、`ohos/source-manifest.json`、`ohos/media-backend.json`、依赖报告及原生 manifest/SBOM。只有全部相关门禁成功，才写 `built-unsigned-media-integrated-device-unverified`。

## 验收与更新

没有签名私钥混入源码或构建输入。未签名 HAP 需要正式签名后进行设备安装、播放、切源、后台、字幕、画中画、截图、动态 WebP 和 HDR 验证；编译与主机测试不代表这些项目通过。旧 `docs/ohos/validation.json` 是媒体暂缓阶段的历史结果。

`.github/workflows/ohos-build.yml` 在相关代码更新时构建，也接受 SDK 仓库通过 workflow_call 传入确切待测 SDK SHA。后续同步上游后重新检查源码和补丁漂移；不要把 OHOS 生成的 Pub 锁提交回主线路径，也不要把旧二进制或旧成功结果当成当前代码验证。
