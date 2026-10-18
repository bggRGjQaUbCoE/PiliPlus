# PiliPlus OHOS 适配

开发分支：`feature/ohos`。基础是用户指定的 `Goodwu/PiliPlus/main` 提交
`849c56b035ac8acf1b4fd677c2c94debe161da8e`；PiliPlusX 只作为原生适配参考。
本轮范围为 OHOS，媒体后端按用户要求暂缓，不包含 HDR 开发。

## 已实现的结构

**Git 分支内原有 1,639 个文件保持不变。** 主线 `lib/`、`pubspec.yaml`、
`pubspec.lock`、`.fvmrc`、原平台工程及工作流均保留。适配实现放在新增的
`ohos/`、`tool/ohos/`、`docs/ohos/` 和 OHOS 专用工作流中。

构建时从指定提交导出独立副本，并使用该提交自身的规则应用必要补丁。
**副本内存在真实的应用和依赖修改**，清单写入 `ohos/source-manifest.json`；
“原文件零修改”指 Git 分支中的主线文件，不意味着兼容层没有维护成本。

| 适配部分 | 处理方式 |
| --- | --- |
| Flutter | 只使用官方 CPF `oh-3.44.9-dev`，固定提交 `3ffe70c6280cc6ddf613bffa59dd70611f238f7e` |
| Flutter 扩展 | 保留主线默认 22 项 SDK 补丁语义，针对 3.44/OHOS 回移其中 3 项 |
| Dart / Flutter 环境 | 仅副本使用 Dart 3.12 / Flutter 3.44 约束，不改变原平台工具链 |
| 原控件与业务 | 补足 OHOS 平台分支及等价的旧 Dart API 写法，不移植参考分支的功能或主题改动 |
| 原生依赖 | 固定可追溯的 OHOS 实现，适配主线现有 Dart 接口，校对文件、权限、唤醒锁及音频会话协议 |
| 系统行为 | 对接真实后台化、文件选择/保存、相册确认、分享、深链与系统插件 |
| media-kit | 保留现有 Dart 依赖和 API，暂缓 OHOS 初始化及播放入口，明确提示；Live Photo 保留静图查看，直播房间继续调用原聊天流程 |
| 同步保护 | 检查提交、工作文件与暂存区；补丁或源摘要漂移时停止准备，要求复核 |

插件接口、生成副本的修改路径及功能验收矩阵见
[兼容性审计](compatibility-audit.md)。原生结构与权限见
[OHOS 工程说明](../../ohos/README.md)。

## 当前验证状态

| 阶段 | 当前结果 |
| --- | --- |
| 原主线文件保护 | 1,639 个文件，0 个修改 |
| 源码准备与补丁防护 | 31 项 Python 回归通过；包含原文件、暂存区、路径、漂移及指定提交的规则隔离 |
| 官方 Flutter SDK | 实际运行 Flutter 3.44.9+ohos-0.0.1-canary1 / Dart 3.12.2，来源、host / target engine 已核对 |
| SDK 控件验证 | 4 项真实 Flutter 控件测试通过 |
| 最小入口原生宿主 | arm64 release unsigned HAP 构建通过；不代表完整应用 |
| 完整依赖 | 干净提交副本完成 Pub 解析、OHOS 插件注入及 35 个隔离依赖来源核对 |
| 依赖行为验证 | petitparser / XML 实际解析验证通过；2 项 UI 测试通过，涵盖原有 21 种 Flex 配色的明暗主题与 OHOS 控件构建 |
| 完整应用 Dart 分析 | 同一候选完整 `lib/` 分析通过：0 错误、0 警告、40 条原风格及弃用提示 |
| 完整应用 HAP | 原 `lib/main.dart` 的 arm64 release unsigned HAP 构建通过，44,165,697 字节；版本和 ELF 校验通过 |
| 设备功能 | 未验证，当前环境没有连接 OHOS 设备 |

验证日期为 2026-10-18 UTC。完整构建工具的 SDK、Pub、parser、UI、analyze、HAP
六个步骤退出码均为 0，最终状态为 `built-unsigned-media-deferred`。产物为
PiliPlus `2.1.6+1`，包含实际 arm64 的 `libapp.so`、`libflutter.so`，归档 CRC
检查通过。对应的来源、阶段、日志摘要和产物摘要见 [本轮验证数据](validation.json)，
具体工具链值见 [工具链记录](toolchain-audit.md)。

[已验证代码提交](https://github.com/Goodwu/PiliPlus/commit/aeadc3e1655e332387f0beea708a87a4df0131e1)
与本地验证源码的 Git tree 完全一致。验证数据记录的是一次已完成的构建，后续
提交、构建时间及包摘要可不同，应以各次构建附带的 `ohos/build-result.json` 为准。

这次验证覆盖完整应用构建；设备安装、首次启动和功能操作尚未验证。原生 SDK
及插件仍有弃用、权限和设备能力警告，不能将 Dart 的零警告外推为整个原生工程
零警告。真实运行结果须按兼容性审计中的设备矩阵逐项记录。

当前干净候选生成副本中有 24 个原路径发生变化：22 个应用 Dart 文件及
`pubspec.yaml`、`pubspec.lock`。这些变化只存在于构建副本，开发分支内原文件仍为
零修改。完整路径、前后摘要、补丁来源与依赖解析结果均随构建记录保留。

## 构建入口

详细环境和命令见 [构建工具说明](../../tool/ohos/README.md)。使用已提交的
源码、独立官方 SDK、Pub 缓存以及 Git checkout 之外的新输出目录：

```sh
python3 tool/ohos/prepare_sdk.py \
  --flutter-root /path/to/dedicated-flutter-ohos \
  --pub-cache /path/to/dedicated-ohos-pub-cache
python3 tool/ohos/ohos.py prepare-build --output /path/to/PiliPlus-ohos-build
python3 /path/to/PiliPlus-ohos-build/tool/ohos/build.py \
  --workspace /path/to/PiliPlus-ohos-build \
  --flutter-root /path/to/dedicated-flutter-ohos \
  --pub-cache /path/to/dedicated-ohos-pub-cache
```

Pub 的原生插件注入阶段就需要 `HOS_SDK_HOME` 和 OHPM 环境。完整构建使用
原 `lib/main.dart`，自动传入同步了版本和提交信息的 Dart defines，输出
unsigned HAP；签名和安装验证在设备环境完成。

`.github/workflows/ohos-source.yml` 只做源码保护；新增
`.github/workflows/ohos-build.yml` 定义完整 SDK、依赖、分析和 HAP 门禁，
在 `feature/ohos` 相关代码更新时执行，也可手动运行。构建产物名称明确标记
`media-deferred`，不会作为具备播放功能的正式发布包。

## 同步上游

```sh
git fetch origin
git switch feature/ohos
git merge origin/main
python3 tool/ohos/ohos.py check-source
```

检查使用本分支已合入的上游提交为基准。同步后重新准备独立副本，针对实际
漂移维护 SDK 补丁、应用补丁和依赖接口。新的 main 锁文件需要与
`dependencies.json` 重新核对；不要把 OHOS 生成的锁文件提交回原主线路径。

降低 Git 合并冲突并不能免除这些 API 维护。构建工具保留精确来源和差异记录，
便于上游合并时定位必须调整的适配点。
