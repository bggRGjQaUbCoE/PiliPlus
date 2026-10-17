# OHOS 源码准备工具

本目录用于 `feature/ohos` 的源码隔离和差异检查。当前提供的是工程准备，
**尚未完成 OHOS 依赖适配、HAP 构建或真机功能验收**。

## 检查上游文件是否被改动

在仓库根目录执行，要求 Python 3.12+ 和 Git：

```sh
python3 tool/ohos/ohos.py check-source
python3 -m unittest discover -s tool/ohos -p 'test_*.py' -v
```

默认比较当前分支与 `origin/main` 的共同祖先，同时检查工作区中原有文件的变化。
因此先 fetch 到尚未合并的新 main 不会被误判为本地删除文件。首次基线是
`849c56b035ac8acf1b4fd677c2c94debe161da8e`，也可显式指定已合入的上游提交：

```sh
python3 tool/ohos/ohos.py check-source --base-ref 849c56b035ac8acf1b4fd677c2c94debe161da8e
```

当前阶段原有文件的允许修改清单为空，包括 `lib/`、`pubspec.yaml`、
`pubspec.lock` 和原平台工程。此门禁用于维持本次基座的边界；后续实装如果确实
需要少量公共接入点，应先记录路径、必要性和回归范围，再调整检查规则。
不能通过另存整份 `lib/` 或隐蔽的批量文本替换逃避审查。

## 导出隔离源码

先把希望导出的 OHOS 文件提交到当前开发分支，再执行：

```sh
python3 tool/ohos/ohos.py prepare --output /tmp/PiliPlus-ohos-source
```

也可使用 `--revision <commit>` 选择已提交的版本。输出目录必须不存在且位于原
checkout 之外。工具仅导出该 Git 提交的文件，不读取本机未跟踪的签名配置、
依赖缓存或其它临时文件；未提交修改不会进入输出。它逐文件验证原有源码的
Git blob，保留完整 `lib/main.dart`、原包名、依赖声明及锁文件。

准备过程中只会在副本的新增 OHOS 工程中同步 `AppScope/app.json5` 的应用版本，
并写入 `ohos/source-manifest.json`。清单明确记录原文件差异为零、没有应用源码
转换、没有依赖替换、没有执行 HAP 构建。输出尚不能直接用于完整 OHOS 构建，
需要先关闭兼容性清单中的工具链及插件阻塞。

此处的隔离目录只是构建工作副本。以后新增的补丁即使只应用在副本中，也必须
记录实际修改的上游文件及上下文，仍然承担上游同步维护成本。

## 工具链诊断

```sh
python3 tool/ohos/ohos.py doctor --flutter /path/to/flutter-ohos/bin/flutter
```

诊断读取原 `pubspec.yaml` 的要求，再运行真实 SDK 的 `--version --machine`。
只有版本满足当前要求才检查 `build hap --help`。工具不安装或修改 SDK、不改变
版本标识，也不放宽原应用约束；Flutter 命令自身可能初始化它自己的缓存。

当前 `doctor` 还会明确报告已核实的 media-kit / cnativeapi OHOS 阻塞并返回
非零状态。通过版本检查不代表插件已兼容，出现 `blocked` 不是 HAP 构建失败
的替代记录。详见 [兼容性审计](../../docs/ohos/compatibility-audit.md) 和
[工具链实测](../../docs/ohos/toolchain-audit.md)。

`baseline.json` 记录建分支时的来源和验收状态。它不是 OHOS 依赖锁文件，
也没有选用 PiliPlusX 的播放器分支。
