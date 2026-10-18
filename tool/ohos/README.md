# OHOS 构建适配工具

本目录只服务于 `feature/ohos`。应用功能和界面基线仍是 PiliPlus `main`，
Flutter 只使用用户指定的官方 `CPF-Flutter/flutter_flutter:oh-3.44.9-dev`。
媒体后端按本轮要求暂缓接入；播放器 Dart 接口和媒体源提交保留。

## 构建目录与上游同步

Git 开发目录保留上游的 `lib/`、`pubspec.yaml`、`pubspec.lock`、`.fvmrc`
及原平台工程。所有 OHOS 适配实现放在新增目录内，构建时按检查过的补丁生成
独立副本。**构建副本确实修改了部分原应用文件和依赖**，这些变化记录在副本
的 `ohos/source-manifest.json`，仍需随上游 API 变化维护。

要求 Python 3.12+、Git，以及构建主机可访问的公开依赖仓库。SDK、Pub 缓存和
构建副本均应使用独立目录；不要将这些工具指向其他项目共享的 SDK 或缓存。

```sh
python3 tool/ohos/ohos.py check-source
python3 -m unittest discover -s tool/ohos -p 'test_*.py' -v
```

检查涵盖提交、工作文件和暂存区。默认比较开发分支与 `origin/main` 的共同
祖先，因此已 fetch 但尚未合并的新 main 不会被误报。补丁锚点、源摘要或 SDK
提交漂移会停止准备，要求针对变动维护适配，不会自动模糊匹配或关闭门禁。

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

先提交要构建的 OHOS 文件，再执行：

```sh
python3 tool/ohos/ohos.py prepare-build \
  --output /tmp/PiliPlus-ohos-build
```

`--revision <commit>` 可指定源提交；输出目录必须不存在且位于 Git checkout
之外。工具先用 `git archive` 导出并逐文件核对原上游 Git blob，再调整 OHOS
副本的环境约束、应用平台接入和依赖。原包名 `PiliPlus` 及其导入路径保留。
未跟踪的本机签名、缓存和未提交修改均不会混入构建输入。

兼容步骤包括：

- 应用已有控件的 OHOS 枚举分支、移动端识别及必要系统交互。
- 原有主页返回行为对接 `UIAbilityContext.moveAbilityToBackground()`。
- 动态色插件缺失时沿用上游 seed 配色；不替换主题算法。
- 使用真实 OHOS 相册保存确认，不伪造权限或保存成功。
- 暂缓媒体初始化，并在尝试播放时明确提示后端尚未接入。
- 按 [dependencies.json](dependencies.json) 的固定 Git SHA 或发布包 SHA-256
  准备 OHOS 平台实现以及保持现有 Dart 接口的兼容副本。

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

该命令核对 SDK、执行 Pub 解析和依赖来源检查、分析 `lib/`、构建原入口，
并检查 HAP 内的应用版本和 arm64 ELF。完整日志及实际通过的阶段分别记录在
副本的 `ohos/build-logs/` 和 `ohos/build-result.json`，失败保留诊断并返回非零。

原生配置使用 unsigned 构建，不包含签名密钥。安装和系统功能验收另行记录。
请以 [当前验证记录](../../docs/ohos/README.md) 为准，区分源码保护、依赖解析、
Dart 编译、ArkTS/HAP 构建和真机验收；本工具不把其中任一步代称为全部完成。

## 同步上游后

```sh
git fetch origin
git switch feature/ohos
git merge origin/main
python3 tool/ohos/ohos.py check-source
```

再使用新输出目录重做 SDK 补丁检查、构建准备、解析和受影响功能验证。
新增目录降低 Git 合并冲突，但不会消除 Flutter API、插件接口和补丁上下文的
维护工作。不要提交生成的 Pub 锁回原主线 `pubspec.lock`。
