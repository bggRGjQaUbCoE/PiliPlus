# OHOS 构建适配工具

本目录将已提交的 PiliPlus 源码导出为独立 OHOS 构建副本。
Flutter 使用固定的官方 `CPF-Flutter/flutter_flutter:oh-3.44.9-dev`。
当前应用已包含 `ManagedVideoPlayback` / `RoutedVideoPlayback` 接入；新模式保留
这套源码，并从明确指定的 media-kit 提交和原生包准备构建。

`approved_integration.json` 是当前批准的源码身份。`baseline.json` 保留旧
`feature/ohos` 阶段的历史记录，不代表当前集成已完成 HAP 或设备验收。

## 构建目录与上游同步

源码检查有两个明确模式：

- `addition-only`：保留原有默认行为，比较与 `origin/main` 的共同祖先，拒绝改变
  原上游文件，适用于尚未修改应用代码的旧 OHOS 分支。
- `approved-integration`：验证独立锁定的批准文件及其 SHA256，接受当前已集成的
  应用基线 `2a09397994bdfd9c4f0801c40fd165a763c65505`。它锁定该 Git tree 和
  18 个集成边界文件；基线之后只允许批准文件列出的 CI、工具和文档路径变更。
  应用源码、资源和平台工程的新增、删除、修改仍被拒绝；`pubspec.yaml`
  只接受批准文件中 SHA-256 明确锁定的已审查版本，其他修改仍会失败。
  `archives/conversations/` 仅允许 Markdown 文档，`CLAUDE.md` 只允许根目录该文件。

两种模式都检查工作文件和暂存区。新模式的 `prepare` / `prepare-build` 要求
所选提交已 checkout，且所有已跟踪文件均无本地漂移；未跟踪的签名和缓存不会导出。
旧模式的只读源码导出继续忽略未提交内容，保持兼容。

OHOS 构建适配只修改独立副本。**构建副本确实修改部分原应用文件和依赖**，
这些变化及 source-policy 身份记录在 `ohos/source-manifest.json`；原 checkout
的 `lib/`、依赖锁和各平台工程不会被改写。

要求 Python 3.12+、Git，以及构建主机可访问的公开依赖仓库。SDK、Pub 缓存和
构建副本均应使用独立目录；不要将这些工具指向其他项目共享的 SDK 或缓存。

```sh
python3 tool/ohos/ohos.py check-source \
  --source-policy approved-integration \
  --source-policy-sha256 5e594b3170242b81e8ac44d953d327fae37ef102365615209dafd3f16e178972
python3 -m unittest discover -s tool/ohos -p 'test_*.py' -v
```

CI 中的期望 SHA256 应来自已审阅的应用依赖锁。不能通过给下载内容现场计算
摘要来代替独立的期望值。checkout 需要包含批准基线及祖先关系；建议使用
`fetch-depth: 0`。补丁锚点、源摘要、批准文件或 SDK 提交漂移都会停止准备。

## 1. 准备指定的 Flutter SDK

以下路径只是示例，选择不存在的独立输出目录：

```sh
export PUB_CACHE=/tmp/piliplus-ohos-pub-cache
python3 tool/ohos/prepare_sdk.py \
  --flutter-root /tmp/piliplus-flutter-ohos \
  --pub-cache "$PUB_CACHE"
python3 tool/ohos/ohos.py doctor \
  --flutter /tmp/piliplus-flutter-ohos/bin/flutter
```

`prepare_sdk.py` 从官方仓库取固定提交和真实官方 tag，验证 engine，再应用
上游 SDK patch 链。它不会伪造 Flutter/Dart 版本。固定来源、每个补丁摘要和
适配说明见 [sdk_compat](sdk_compat/README.md)。已经准备的 SDK 可加 `--check`
复验。`doctor` 的通过只表示 SDK 身份、实际版本和 HAP 命令符合 OHOS 配置。

上游仍声明 Flutter 3.47.7 / Dart >=3.13.0。只有 OHOS 生成副本使用
Flutter >=3.44.0 <3.45.0 / Dart >=3.12.0 <4.0.0，随后通过实际解析和编译检验
兼容性；原平台依赖声明和版本选择不变。

## 2. 准备构建副本

先提交要构建的源码，checkout 应用与 media-kit 的锁定提交，再提供原生输入。
以下文件应已通过上层统一 native package 的摘要和清单验证：

```sh
export PILIPLUS_MEDIA_KIT_ROOT=/work/media-kit
export PILIPLUS_OHOS_LIBMPV_LIBRARY=/work/native-ohos/lib/libmpv.so
export MEDIA_KIT_OHOS_LIBMPV_ARCHIVE=/work/native-ohos/lib/libmpv_aarch64.zip
export MEDIA_KIT_OHOS_LIBMPV_SHA256=EXPECTED_ARCHIVE_SHA256_FROM_LOCK
```

`libmpv.so` 同目录必须保留原生 producer 的 `manifest.json`。门禁继续验证
AArch64 ELF、archive/library 精确摘要，以及真实编译记录中的
`CONFIG_LIBWEBP_ENCODER`、`CONFIG_LIBWEBP_ANIM_ENCODER`、`CONFIG_WEBP_MUXER`。
包根目录的通用 `manifest.json` 不替代这个平台构建证明文件。

然后执行：

```sh
python3 tool/ohos/ohos.py prepare-build \
  --output /tmp/PiliPlus-ohos-build \
  --source-policy approved-integration \
  --source-policy-sha256 5e594b3170242b81e8ac44d953d327fae37ef102365615209dafd3f16e178972
```

`--revision <commit>` 可指定源提交；输出目录必须不存在且位于 Git checkout
之外。工具先用 `git archive` 导出并逐文件核对所选源码 Git blob，再调整 OHOS
副本的环境约束、应用平台接入和依赖。原包名 `PiliPlus` 及其导入路径保留。
未跟踪的本机签名、缓存和未提交修改均不会混入构建输入。

兼容步骤包括：

- 应用已有控件的 OHOS 枚举分支、移动端识别及必要系统交互。
- 原有主页返回行为对接 `UIAbilityContext.moveAbilityToBackground()`。
- 动态色插件缺失时沿用上游 seed 配色；不替换主题算法。
- 使用真实 OHOS 相册保存确认，不伪造权限或保存成功。
- 验证并保留已提交的播放器接入，不重放旧 Direction B 七文件补丁。
- 将 media-kit 包闭包绑定到其干净、已提交源码的导出快照，并检查最终解析来源。
- 按 [dependencies.json](dependencies.json) 的固定 Git SHA 或发布包 SHA-256
  准备 OHOS 平台实现以及保持现有 Dart 接口的兼容副本。

当前应用的 `pubspec.lock` 和已有 `pubspec_overrides.yaml` 使用批准文件中的精确
摘要验证。只在这个明确模式下允许将副本中的 overrides 替换为 OHOS 图；原文件
逐字节备份到 `ohos/source-pubspec-overrides.yaml`，转换记录进入依赖报告。
旧模式仍拒绝覆盖已有 overrides。

当前 OHOS recipe 暂时保留既有兼容包与补丁：`material_ui 1.6.0`、
`cupertino_ui 1.1.2`、`hive_ce 2.21.0` 以及 cached-image 提交 `733d4aae…`，
对应应用锁中的较新版本及转换原因均逐项记录在批准文件。这里没有自动将新
pubspec 锁认定为与旧 recipe 等价；新的 Pub 解析、分析、UI 测试和 HAP 构建
必须通过后才能报告兼容。

`prepare` 命令仍保留为**只导出、不适配**的源码检查入口，供轻量 CI 使用。
`prepare-build` 会获取依赖源码，但依赖准备本身不等于 Pub 解析或 HAP 构建成功。
失败的构建副本记录具体错误，修复适配后从新输出目录重新准备。

## 3. 解析依赖和构建

先配置 HarmonyOS command line tools、Hvigor、OHPM 和 Java 17。
Flutter 在 Pub 解析后的原生插件注入阶段就会调用它们：

```sh
export PILIPLUS_OHOS_COMMAND_LINE_TOOLS=/path/to/command-line-tools
export HOS_SDK_HOME="$PILIPLUS_OHOS_COMMAND_LINE_TOOLS/sdk"
export PATH="$PILIPLUS_OHOS_COMMAND_LINE_TOOLS/bin:$PILIPLUS_OHOS_COMMAND_LINE_TOOLS/tool/node/bin:$PATH"
```

完成环境配置后执行：

```sh
cd /tmp/PiliPlus-ohos-build
/tmp/piliplus-flutter-ohos/bin/flutter pub get
python3 tool/ohos/dependencies.py patch \
  --workspace /tmp/PiliPlus-ohos-build --pub-cache "$PUB_CACHE"
python3 tool/ohos/build_profile.py \
  --workspace /tmp/PiliPlus-ohos-build --refresh-manifest
/tmp/piliplus-flutter-ohos/bin/flutter analyze lib \
  --no-pub --no-fatal-infos --no-fatal-warnings
```

然后在已完成上述步骤的副本运行：

```sh
/tmp/piliplus-flutter-ohos/bin/flutter build hap --release --no-codesign --no-pub \
  --dart-define-from-file=ohos/build-defines.json
```

`ohos/build-defines.json` 由准备工具同步主线版本名、版本号、所构建提交和 Unix
时间，传入原有 `BuildConfig`。在同一环境中也可直接执行完整门禁：

```sh
python3 tool/ohos/build.py --workspace /tmp/PiliPlus-ohos-build \
  --flutter-root /tmp/piliplus-flutter-ohos --pub-cache "$PUB_CACHE"
```

该命令核对 SDK、执行 Pub 解析和依赖来源检查、运行 petitparser/XML 解析验证与
Material/Cupertino/Flex UI 测试、分析 `lib/`、构建原入口，并检查 HAP 内的应用
版本和 arm64 ELF。完整日志及实际通过的阶段分别记录在
副本的 `ohos/build-logs/` 和 `ohos/build-result.json`，失败保留诊断并返回非零。

锁定的 Flutter OHOS SDK 会将 `entry/src/main/resources/base/profile/buildinfo.json5`
移至 `entry/src/main/resources/rawfile/buildinfo.json5`。只有 HAP 和包内原生库身份
检查通过后，最终源码清单才接受并记录这一个迁移：原位置必须缺失，目标必须是
无符号链接的普通文件，内容必须与导出基线逐字节一致。记录包含原 Git blob、
目标路径及 blob，以及 SDK 提交和迁移实现文件的 SHA256；其他文件缺失仍然失败。

原生配置使用 unsigned 构建，不包含签名密钥。安装和系统功能验收另行记录。
请以 [当前验证记录](../../docs/ohos/README.md) 为准，区分源码保护、依赖解析、
Dart 编译、ArkTS/HAP 构建和真机验收；本工具不把其中任一步代称为全部完成。

## 同步上游后

```sh
git fetch origin
git switch goodwu-dev-rebased
git merge origin/main
python3 tool/ohos/ohos.py check-source \
  --source-policy approved-integration \
  --source-policy-sha256 APPROVED_POLICY_SHA256_FROM_LOCK
```

合并改变应用源码后，旧批准基线会按预期拒绝构建。先审阅新播放器、依赖和
OHOS 补丁适配，再更新批准 commit/tree、文件摘要及两个引用它的期望摘要
（应用依赖锁和 `media_backend.json`）；不能只更新哈希掩盖未处理的源码变化。
随后在新输出目录重做 SDK 检查、依赖解析、分析、构建和受影响功能验证。
不要提交 OHOS 副本生成的 Pub 锁回原主线 `pubspec.lock`。

## 当前开发线 media-kit

六平台 CI 解析 `Goodwu/media-kit@feature/dv` 的 SHA 并在所有 jobs 冻结。
本地保持 `../media-kit` 路径覆盖；使用本地构建前在 App 兄弟仓执行：

```bash
git -C ../media-kit fetch origin feature/dv
git -C ../media-kit switch feature/dv
git -C ../media-kit merge --ff-only origin/feature/dv
```

仓库主线/上游同步分支不会被改变。如果本地 `media-kit` 含未提交修改，
先保留工作树，不要执行强制切换或重置。`media_kit_native_event_loop`
在 Goodwu/media-kit 中不存在，保留其原始独立 Git 来源。

## 2026-10-28 唯一开发线集成

原生包 CI 与播放器诊断功能已经汇入 `goodwu-dev-rebased`，本分支是现行受审 OHOS 源码基线。审批文件记录当前 App 完整 tree `30fa1f46ab086e2c5a22d88e6bb9eacbe87b854f`，增加已存在的播放器诊断/控件源码 SHA，且会在后续任何 App 代码改动时失败关闭；不允许通过删除 guard 或放宽 mutable_paths 来掩盖变更。
