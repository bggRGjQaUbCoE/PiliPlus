# PiliPlus OHOS 适配

## 当前状态

开发分支：`feature/ohos`。从用户指定的 `Goodwu/PiliPlus/main` 提交
`849c56b035ac8acf1b4fd677c2c94debe161da8e` 创建，未从仓库默认分支或
PiliPlusX 的功能分支派生。当前范围仅为 OHOS 适配。

本次已经落地独立 OHOS 工程壳、源码隔离准备、原有文件差异检查及兼容性审计。
**尚未完成可运行的 OHOS 应用：没有通过本基线的 HAP 构建、安装或功能验收。**
当前原有文件修改数为零；应用源码、依赖声明及锁文件、图标来源和原平台工程
均保持建分支时的上游内容。两个 OHOS 图标复用原图，不另做界面和品牌设计。

| 项目 | 状态 | 记录 |
| --- | --- | --- |
| 基线与 OHOS 开发分支 | 已建立 | [来源记录](../../tool/ohos/baseline.json) |
| OHOS 原生工程壳 | 已新增；静态结构检查通过 | [工程说明](../../ohos/README.md) |
| 原有文件保护与隔离源码准备 | 已实现；含正向与拒绝路径验证 | [工具说明](../../tool/ohos/README.md) |
| Flutter / Dart / engine 工具链 | 所检查的组合未满足主线要求 | [实测证据](toolchain-audit.md) |
| 保持现有 API 的 OHOS 插件和媒体后端 | 待实现、待验证 | [兼容性审计](compatibility-audit.md) |
| HAP 构建与完整功能验收 | 未完成 | [验收矩阵](compatibility-audit.md#8-功能验收矩阵) |

`.github/workflows/ohos-source.yml` 只验证源码保护与导出工具。它不构建 HAP，
其绿色结果也不表示 OHOS 应用能够编译或运行。原有平台的工作流没有修改。

## 实施顺序

1. **先补工具链证据。** 要求真实可运行、host / target 配套的 Flutter OHOS
   及 Dart 满足原 `pubspec.yaml`，再核对原项目 Flutter SDK patch 链。
   不根据分支名称或下载成功判断版本兼容。
2. **再闭合平台依赖。** 保留当前应用调用 API，接入路径、深链、WebView、
   原生资源构建和 OHOS 媒体后端；来源与原生库均使用固定版本和可验证摘要。
3. **按实际诊断加入少量应用接入点。** 优先集中于平台判断、初始化及必要的
   switch 分支。每处记录路径、原因、上游上下文和受影响功能，保持原业务实现。
4. **构建完整应用并逐项验收。** 从原 `lib/main.dart` 编译 unsigned arm64 HAP，
   验收登录、原界面、视频/直播、下载、本地播放、音频后台、音量亮度、文件/分享
   与前后台生命周期。无实现的能力继续记录为未完成。

完整的逐文件候选、依赖来源和功能验收要求见兼容性审计。没有把参考项目的
主题替换、隐藏功能或成功空桩作为本项目的适配方案。

## 后续同步上游

保持 `main` 作为上游镜像，本地 OHOS 提交保留在 `feature/ohos`。可以在正常
同步 `main` 后将其合并到开发分支：

```sh
git fetch origin
git switch feature/ohos
git merge origin/main
python3 tool/ohos/ohos.py check-source
```

检查以本分支已合入的上游提交为比较基准；不会把新同步的上游提交计为本地
功能修改。真正开始加入少量既有文件改动后，需将“零修改”门禁升级为有理由、
可审查的逐文件清单，不能简单关闭检查。补丁放在新增文件中也有同步维护成本，
应让上下文漂移明确失败，并只重新验证受影响的功能。

## 本地操作入口

```sh
python3 -m unittest discover -s tool/ohos -p 'test_*.py' -v
python3 tool/ohos/ohos.py check-source
python3 tool/ohos/ohos.py prepare --output /tmp/PiliPlus-ohos-source
python3 tool/ohos/ohos.py doctor --flutter /path/to/flutter-ohos/bin/flutter
```

`prepare` 导出已提交源码，要求输出目录尚不存在；`doctor` 当前报告已核实的
工具链/依赖阻塞并返回非零状态。命令的具体边界见工具说明。
