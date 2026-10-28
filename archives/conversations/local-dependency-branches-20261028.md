# 本地依赖分支切换（2026-10-28）

## Current State

- 本地分支切换已完成。最初按用户要求保持全部改动未提交；2026-10-29 用户进一步授权提交、推送，本次仅提交 PiliPlus 的任务记录、四份相关 conversation 与 Claude Code 入口。原生构建配方自动补丁、构建缓存及 App `view.dart` 的意外格式变化继续保留在工作区，不纳入提交。
- 提交前将 PiliPlus 从切换时的 `c4b61dccd` 快进到 `origin/feature/dv@472b30e91`；上游改动与本地记录路径不重叠，工作区内容保留。文档已检查，未发现私钥或 token 内容。
- `PiliPlus`、`media-kit`、`mpv`、`FFmpeg`、`libmpv-android-video-build-dv-experiment` 五个顶层仓库均已切至 `feature/dv`；切换时的远端 SHA 历史快照分别为：`c4b61dccd61f0563f4f2d648bdd12783c3be298e`、`a6f17b9220705ca61c554ce1f9c2771764825bbc`、`e46016c3ec87af6002c98e6135b14981f0912ebe`、`9aba43cfbee182ade060cdccbe15340a0fbe3e83`、`3605f300ecfe16bc084addd0b403d2cd55ef6a81`。
- 原生构建目录 `libmpv-android-video-build-dv-experiment/buildscripts/deps/` 内的独立 `ffmpeg`、`mpv` 副本亦切到 `feature/dv`；该目录内 `libplacebo` 切到 `optimize/dovi-linear-decode@ea700489fbf27703d8c1f64874a1c6138f17ad28`。顶层 `~/src/libplacebo` 原已在同一目标分支，未改动。
- 其余已盘点的依赖远端未发现 `feature/dv`，保留原状态。

## 保全与回放

- 切换前备份：`/Users/wuweiwei1/src/PiliPlus/.git/branch-switch-backups/20261028-235559`。按仓库保存原 HEAD/分支、目标 SHA、tracked binary patch、原 index patch、相关非 ignored 未跟踪文件及修改文件 tar、文件 SHA-256 清单。
- PiliPlus 原有 4 项 tracked 修改和 2 项未跟踪文件保留。`TASKS.md` 的顶部插入冲突通过同时保留远端 `ALL-PLATFORM-NATIVE-CI-20261028` 和本地 `GITHUB-BUILD-CI-DIFF-20261027` 完整块解决；另 3 项 tracked 内容及两个未跟踪文件与备份哈希一致。
- 顶层 FFmpeg 的 `configure` 临时配置清空补丁保留；构建目录内 ffmpeg 的 `configure`、`libavformat/hls.c` 补丁，mpv 的 `meson.build` 配置清空补丁，以及 libplacebo 的 `src/glsl/spirv.c`、`src/shaders/custom_mpv.c` 补丁保留为 unstaged。未删除构建缓存或辅助备份文件。
- 构建目录内 ffmpeg 原仅有 tag fetch 映射；补充单一 `feature/dv` fetch 映射以正确跟踪远端分支，原 tag 获取规则保留。

## 验证与边界

- 切换完成时各仓 HEAD 与当时获取的目标远端分支 SHA 一致，`git ls-files -u` 为空、`git diff --cached` 为空。2026-10-29 的文档提交在最新远端分支基础上进行；原生构建补丁继续保留未提交。
- 备份清单中所有非 ignored 未跟踪文件哈希保持一致；tracked 文件仅 TASKS 合并和构建目录内 mpv 的 meson.build 合入新上游内容导致整体哈希变化，剩余原文件与备份逐字一致。mpv 相对目标只剩原配置清空补丁。
- 本次仅验证分支、文件保全与 Git 状态；未运行编译、APK 安装、设备播放、硬解、HDR 或画面验收。
