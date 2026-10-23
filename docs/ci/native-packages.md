# 全平台源码与原生开发包构建

入口是 `.github/workflows/source-build.yml`，名称 **Locked source and native package builds**。
它检出当前应用提交和 `tool/native/inputs.lock.json` 固定的 media-kit 提交，先生产或验证原生包，再构建应用。两个 checkout 必须并列为 `app/` 和 `media-kit/`，与已经提交的 `pubspec_overrides.yaml` 对应。

## 平台与默认输入

| 平台 | App 产物 | `auto` 默认原生输入 | `source` 输入 |
| --- | --- | --- | --- |
| Android | arm64-v8a、armeabi-v7a、x86_64 APK | Goodwu 定制 mpv / FFmpeg / libplacebo 四 ABI 源码包 | 相同锁定源码，保留完整开发 SDK |
| Windows | x86_64 portable ZIP | Predidit 20260811 DXGI 开发包 | 锁定的 Predidit MinGW/Clang recipe 与完整依赖向量 |
| Linux | x86_64 bundle tar.gz | Predidit 20260810 runtime + matching headers | 锁定的 Goodwu mpv / FFmpeg / libplacebo |
| iOS | iPhone/iPad ARM64 未签名 IPA | 0.6.8 XCFramework + mpv 0.36.0 同源 headers | Goodwu Darwin recipe 的 default profile |
| macOS | ARM64/x86_64 `.app` ZIP | 0.6.8 XCFramework + 同源 headers | 相同 Darwin recipe 的 macOS target |
| OHOS | ARM64 未签名 HAP | 锁定的 OHOS source recipe，包含 WebP 编码能力 | 相同锁定源码 |

Android 原生 SDK 同时保留 x86 ABI，Flutter 应用输出沿用项目支持的三个 ABI。该定制 native profile 的部署目标为 Android API 26，构建副本的 APK minSdk 取 Flutter 要求与 26 的较大值，App 插件使用同一锁定 NDK；这些生成修改写入应用构建 patch 证据。Android 未配置正式签名证书时使用项目已有的 debug signing fallback；这些构建产物不自动发布到 Release。iOS/HAP 需要在相应分发流程中签名；macOS 不在这里申请 notarization。

平台和应用架构范围沿用当前项目的发布目标；media-kit 本身支持额外 native 架构并不代表 PiliPlus 已发布该架构。iOS native 开发包另含 ARM64/x86_64 模拟器切片，IPA 使用真机 ARM64。

Apple 的 default profile 如实使用其现有 mpv 0.36.0 / FFmpeg 6.0 依赖。它不声称包含定制 `opengl-next` 或 shared-core 私有 ABI。要切换该候选，应新增独立 profile、完整 portable native bundle 和功能验收，不能只替换一个 dylib。

Linux bundle 仍要求兼容的 GTK、WebKit、图形、字体和音频系统库。manifest 中 `runtime-dependencies.json` 记录 libmpv 的实际系统 SONAME，App job 使用 `ldd` 拒绝未解析依赖。这里不把 Ubuntu bundle 描述为任意发行版上的静态可执行文件。

## 选择构建模式

workflow 的 `platforms` 参数是 JSON 数组，例如：

```json
["android","windows","linux","ios","macos","ohos"]
```

`native_mode` 有四种取值：

- `auto`：若 `packages.lock.json` 已指定该平台的完整包则严格使用它，否则选择上表中的默认 profile。
- `source`：选中的所有平台都从各自锁定的 source profile 重新生产，允许命中同一输入身份的已验证缓存。Windows 首次构建还会生产 LLVM/MinGW 工具链，耗时和空间明显高于使用已有开发包。
- `upstream`：只允许选择已登记 upstream profile 的 Windows、Linux、iOS、macOS。Android/OHOS 的定制能力不能退回普通上游包，因此对它们显式选择此模式会失败。
- `package`：只消费 `packages.lock.json` 中已审核的完整包；缺记录、任何摘要不匹配或 source inputs 已变化都会失败。

缓存没有前缀恢复或“最近一次成功”的模糊回退。key 包含原生源码、recipe、配置、平台和打包适配器；显式 package 还包含其 archive hash。应用或 Dart SDK 代码变化不单独导致 native 重建。缓存恢复后仍重新执行完整 manifest、文件、身份和能力校验。

调试分支 `ci/native-packages-*` 对本工作流、`tool/native/` 或 `tool/ohos/` 的 push 会触发默认六平台构建。工作流合入常用分支后可在 Actions 中按需选择平台和模式。原有发布工作流保持独立，本入口只上传 artifacts。

## 输入和产物如何关联

`inputs.lock.json` 固定 media-kit、各 native producer 及主要源码提交。Android 四组件向量传给 builder 的 `--source-lock`；OHOS 使用 producer 自带的全量 `source-lock.json`；Darwin 由 producer commit、`packages.lock.nix` 和 `flake.lock` 固定；Windows 额外冻结完整 CMake 依赖闭包，避免只锁 recipe 却继续拉取 `master`。

统一 native artifact 包含：

```text
native-package.tar.gz
native-package-receipt.json
```

tar 内为 `manifest.json` 以及同源 headers、runtime、依赖库、必要开发文件和证据。Apple/macOS 框架链接、Linux SONAME 链接和 Android SDK 链接保留在 tar 内，上传 artifact 时不会被平台 ZIP 处理丢失。

receipt 记录 archive、manifest、identity 与 CI inputs 四种摘要。`identity` 记录实际 source/recipe/toolchain/options/patches；上游二进制模式记录下载 URL 和固定摘要，不虚构未知源码提交。manifest 对每个普通文件和安全的内部相对链接建账。消费端拒绝额外文件、篡改、路径越界、错平台、缺架构、缺头文件和布局冲突。

最终应用 artifact 中 `build-provenance.json` 关联：

1. 当前应用提交和构建过程中生成的 `application-build.patch`。
2. 实际检出的 media-kit 提交。
3. 完整 native receipt。
4. App 文件 SHA256、workflow run ID / attempt。

不同平台可使用不同兼容 profile；它们不会因为都叫 libmpv 就被当作可互换。

## 固定一个已生产的包

先成功运行 native job，保存其 tar 和 receipt 到长期可读取的 HTTPS artifact 地址。将 receipt 的真实值填入 `tool/native/packages.lock.json`：

```json
{
  "schema": 1,
  "packages": {
    "android": {
      "mode": "source",
      "url": "https://YOUR_ARTIFACT_HOST/native-package.tar.gz",
      "inputs_sha256": "COPY_FROM_RECEIPT",
      "archive_sha256": "COPY_FROM_RECEIPT",
      "manifest_sha256": "COPY_FROM_RECEIPT",
      "identity_sha256": "COPY_FROM_RECEIPT"
    }
  }
}
```

这是填写格式，示例值不能通过校验。长期地址不是当前用户权限下任意 artifact 的替代凭证；当前实现支持公开或 runner 可直接访问的 HTTPS 下载。不要把访问令牌放进仓库 URL。没有长期包时同一 repository 的 Actions cache 已可复用成功产物。

Android producer 同时输出可移动的四 ABI development SDK；它已通过移位后的 pkg-config + 静态链接 consumer 验证。当前完整包入口用于 Flutter 应用编译，fresh source 路径仍完整构建依赖。仅用该 SDK 重编 mpv 的增量 producer 应独立记录 parent SDK identity，不能在 fresh source 入口下回填旧 prefix 并声称全新构建。

## API 不兼容时的处理

修改 mpv / FFmpeg / libplacebo / renderer 接口时，应把调用方、头文件和运行库作为一组升级：

- 更新相关 exact commit 或 archive digest，并重新生成受影响的 native 包；旧 cache key 自动失效。
- 保持严格 patch apply、编译 feature 检测和 required capability 检查。缺能力或旧 SDK 不继续打包。
- media-kit 消费的 headers、import library、runtime 来自同一个 manifest。Windows 的 DXGI 扩展头和库成对；Apple 默认 OpenGL profile 不冒用 shared-core ABI。
- 原生 producer 的 compile/ELF/Mach-O 检查、Flutter App 编译、运行加载和真机播放是独立证据。当前通用构建不会因为静态检查通过就将 runtime/device 设为 true。

本次已修复 mpv DOVI feature 宏名称与 Meson 不一致，以及 Android FFmpeg HLS patch 与锁定源码不匹配的问题；后者已实际编译 `hls.o` 验证。首轮 Actions 还发现 Android TLS patch 引用了较新 mpv 的 `stream/network.c`，已重基到锁定版本的 `stream/stream_lavf.c`，通过正向应用和反向检查；显式 `false` 初始化保持该版本原有零初始化行为，`--tls-verify=yes` 路径保持不变。Darwin 源码生产在合并架构前移除构建机 RPATH。已锁定的 0.6.8 原始二进制字节保持不变，其历史 RPATH 静态检视记录在 `apple-sdk-audit-20261023.json`。

## OHOS 保留当前应用集成

当前应用已经包含 Managed/Routed playback 和宿主合成能力，旧 Direction B 迁移 patch 不能重复应用。新入口显式选择 `approved-integration`，由提交中的 policy 和固定 SHA256 验证批准基线、关键源码及依赖锁；只允许后续 CI/tooling/docs 变动，仍拒绝应用源码或工作区漂移。

所有 SDK 兼容转换只发生在导出副本中，并保留转换前后证据。原 producer manifest、WebP 功能报告和 archive SHA 检查保留；OHOS 不因通用包校验而绕过现有 native/HAP 身份检查。

## 本地验证命令

```sh
python3 -m unittest discover -s tool/native/tests -v
python3 tool/native/desktop/contract_tests.py
python3 -m unittest discover -s tool/ohos -p 'test_*.py' -v
python3 ../media-kit/tool/native_package/package.py verify \
  --root /absolute/native-package \
  --manifest-sha256 ACTUAL_MANIFEST_SHA256 --platform linux
```

宿主契约测试和真实上游包静态验证可以在 Linux 执行。Flutter、NDK、OHOS、Xcode 的完整产品编译由对应 CI job 给出结果；设备播放和 HDR/Dolby Vision 显示验收需另行记录，不由 artifact 存在推断。

## 已完成的 Linux 源码构建验证

2026-10-23 已实际从锁定的 FFmpeg `9aba43cfbee182ade060cdccbe15340a0fbe3e83`、libplacebo `ea700489fbf27703d8c1f64874a1c6138f17ad28` 和 mpv `e0dc99d0467957ffc16c4afbb4e9f7c3f2a8667d` 完成 configure、compile、install，收集 60 个运行库并逐个设置 `$ORIGIN`，使用产物中的同源 headers/libraries 严格链接 C consumer。共享 package create/verify 通过，打包后 `mpv_create`、API version 和销毁 probe 实际运行退出码为 0。

该次产物 manifest SHA256 为 `7b630c36c046a5d594219916c1a304e9e50739a95496e48741322dec4073e6fc`，identity SHA256 为 `ae4071af9f15e66f1d6d3ededfab128821cd687a8734e4c1d9dbb8607bcadfaa`。这是 native 编译和基础加载证据；尚未进行 Flutter 产品启动、GPU 播放或设备验收，因此 manifest 仍记录 `compiled=true, runtime=false, device=false`。Windows source 已验证完整依赖冻结、真实 CMake 配置和 PE 依赖闭包，完整 LLVM/MinGW 产品构建仍待对应 source CI。

随后已使用同一 native 包、Flutter 3.47.7 和隔离的 App/media-kit checkout，实际执行当前 `build_application.py --platform linux` 并完成 Release 应用编译。22 个 Flutter 补丁、8 个 material_ui 补丁、pub 解析、Dart/AOT、原生插件编译链接、逐 SO 的 `ldd` 检查均通过；App bundle 的 60 个原生 SO 全部与 source manifest 对应文件逐字节相同。记录见 `linux-source-audit-20261023.json`。本地浅克隆的版本计数仅用于编译验证，该测试包没有发布；正式 CI 使用完整应用 Git 历史。
