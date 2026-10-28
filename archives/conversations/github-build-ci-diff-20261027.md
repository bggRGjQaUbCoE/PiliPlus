# GitHub 构建脚本与本地编译差异对齐（2026-10-27）

## Current State

- **完成（2026-10-28 凌晨，四步目标全部闭环）**：
  1. **依赖项**：Android 源码链三基点对齐进锁并全链验证——run `40532253215`（push）android native 四 ABI 编译/打包/manifest/能力校验全通过并**存缓存**（inputs_sha256 `bd4fc154…`）；ohos App 修复（归档文件移除）后 run `40539338358` 中 ohos/linux/android App 全绿。
  2. **手工触发**：`workflow_dispatch` run [`40542347182`](https://github.com/Goodwu/PiliPlus/actions/runs/40542347182)（`platforms=["android"]`、native_mode=auto）；首次 attempt 因 runner 下载 `ndk;28.2.13676358`（`:jni` 子项目自动安装）zip 损坏 transient 失败（`Archive is not a ZIP archive`→`InstallFailedException`），`gh run rerun --failed` 后 **attempt 2 全绿**。
  3. **下载**：artifact `PiliPlus-android-6af28958bcd367940b8bc2f83ebe58a82adfb45a` → `PiliPlus-arm64-v8a-release.apk` 28,022,162B，SHA-256 `a79448c84cdc32e3a322974d35cfbf359fdbab817e9a1061ae61e0f6ae131249`；build-provenance.json：app `6af28958b`、media-kit `d7662218`、native `bd4fc154`、run attempt 2。
  4. **装机测试**（Redmi Note 5A，serial `a869cea9`，arm64-v8a/API37）：install Success；versionName `2.1.6-6af28958b`、versionCode 5559、minSdk26；**on-device base.apk SHA-256 与候选逐字一致**；显式冷启动 `com.example.piliplus/.MainActivity` Status ok/2478ms（注意：直接 `am start -W VIEW <bilibili链接>` 会被旧 `.dev` 应用或浏览器抢走，需显式 `-n` 或 `-p`）；带 VIEW 数据深链 BV1vY4y1N7TY 后视频页加载、播放进度 1%→4% 实时推进；全程零 FATAL/ANR；截图 `/tmp/pili-ci-note5a-playing.png`；测后 force-stop，应用保留安装。
- **遗留（不阻塞）**：run `40539338358` 的 windows App 因同一 NDK zip transient 失败未单独 rerun（android 无关；如需补绿 `gh run rerun 40539338358 --failed` 即可）；run #3/#4 中 macos/ios App 的 cancelled 为我 force-push 新 run 时同组 pending 被取代的连带效应，非代码问题。
- **media-kit Dart 侧对齐（compat `c8c5aaab`）列为后续独立任务**：锁 ref 钉的是机制分支 `ci/verified-native-packages-20261023`（tip=`d7662218`，CI 校验依赖其 `tool/native_package`，compat 线从未有该目录，两线分叉非前进，不可简单 bump——run `40525579467` 已实证四平台秒败）。对齐需把 native-package 机制移植到 compat 线、或在锁中拆分"机制 ref/应用 ref"。
- **本轮全部修正轨迹（按序）**：①"五工作流 CI 全断"误判（未查 `gh run list`/`gh workflow list`，五处克隆步骤已回退）；②deps 工作树四处"修改"误判为手工脏改动（实为配方自动补丁：`patch.sh`+`patches/*`、`scripts/ffmpeg.sh:26` sed；hls.c 与配方应用结果仅差 1 空行、libplacebo 两补丁逐字吻合）；③media-kit 钉定错提 compat 头（run `40525579467` 四 upstream 秒败，取消并回退 `d7662218`）；④能力名 `pl-dovi-linear-disable`→`pl-dovi-linear-optimize`（libplacebo 重写改宏，run `40527046246` 唯一失败点，锁已更正）；⑤归档文件带上 CI 分支触发 ohos approved-integration 源保护 `unapproved_additions` 拒绝（run `40527046246`/`40532253215` ohos App 失败根因，已移除，记录归 goodwu-dev-rebased 主工作区）。
- **App 层差异（设计内）**：CI temurin JDK 21（native 17）vs 本地 openjdk@17；CI release 变体（`pili_release.json`、3 ABI、minSdk26、ndkVersion 钉 27.2，但 `:jni` 子项目仍会自动装 NDK 28.2——潜在 flaky 点）vs 本地 dev 变体。`build_application.py` 调用同一 `build.ps1`+`patch.ps1`；Flutter 3.47.7 两边一致；producer `3605f300`、helper `b768ce10`、NDK 27.2/API26 一致。
- 验证边界：CI 侧 run `40542347182` attempt2 全绿＋provenance 哈希链；设备侧装机/启动/深链/播放推进/零崩溃实测。未验证：长时间播放、HDR/硬解路由行为（CI media-kit Dart 为机制分支代码，与本地 compat 有既定差距）、桌面平台装机。

## 执行历史（2026-10-27，已由上方 Current State 收敛）

- **三基点对齐已推送，media-kit 钉定经一次失败后回退（2026-10-27，用户授权"按你说的操作"）**：`ci/native-packages-update-20261027` 最终态＝`tool/native/inputs.lock.json` 中 Android 源码链 mpv/FFmpeg/libplacebo 三基点对齐本地已验证组合；media-kit 保持原钉定 `d7662218`。**android 能力名同步更正**：run `40527046246` 的 android native 全链（四 ABI 编译/打包/manifest/校验，约 25 分钟）唯一失败在能力清单——新源码产出 `mpv.pl-dovi-linear-optimize`（producer `package_native_bundle.py` 按 `HAVE_PL_DOVI_LINEAR_OPTIMIZE` 宏映射），锁原要求旧名 `mpv.pl-dovi-linear-disable`（旧 libplacebo 实现的宏）；已把 required_capabilities 更为 `optimize`（反映本地已验证链的真实能力，非放松门检）。**ohos App 失败归因（第五次修正）**：run `40527046246`/`40532253215` 的 ohos App 均死在 `ohos.py check-source --source-policy approved-integration`，报 `unapproved_additions: archives/conversations/github-build-ci-diff-20261027.md`——我把归档文件提交进了 CI 分支，而该分支受 approved-integration 源保护约束、拒绝未过审新增文件；已从 CI 分支移除该文件（记录本就归属 goodwu-dev-rebased 主工作区），分支改带一行 TASKS 注记。
  - mpv：`codex/piliplus-dovi-capabilities-20261023@e0dc99d0` → `media-kit/android@4c6e1796`。
  - FFmpeg：`routing/MK-ROUTING-20261011@9aba43cf` → `lg-p84-d1-vui-fix-20261010@d4bb79394b`（配方补丁已验证在该基点干净应用）。
  - libplacebo：`optimize/dovi-linear-decode@ea700489` → **新分支** `optimize/dovi-external-yuv-20261027@c9fd8798`。本地树与远端旧分支是重写型分叉（远端 4 细粒度提交 vs 本地 2 收敛提交，tip diff +93/−305），**未强推**；旧分支原样保留。
- **media-kit 钉定不能提到 compat 头（本轮关键教训，第四次误判更正）**：首次执行曾把 media-kit 一并提到 `c8c5aaab`（compat 头）——run `40525579467` plan 通过、android/ohos 源码开跑，但 win/ios/macos/linux 四个 upstream job 秒败，已取消该 run。根因：锁的 `media_kit` ref 钉的是**专用机制分支** `ci/verified-native-packages-20261023`（tip=`d7662218`），CI 的 native 校验依赖其 `tool/native_package/`（package.py/consume.cmake/tests）；compat 线**从未有过**该目录（`git log d7662218..c8c5aaab -- tool/native_package` 为空，两线分叉），提到 compat 头＝抽掉校验机制。已回退 `d7662218`。
- **media-kit Dart 侧对齐（compat `c8c5aaab`）列为后续独立任务**：CI 的 app 构建经 `pubspec_overrides.yaml` 消费 media-kit@锁 ref，即机制分支的 Dart 代码；与本地 compat（含 HLG→PQ 峰值修正、pre-29 解码器修复等 8 提交）有既定差距。对齐需把 native-package 机制移植到 compat 线、或在锁中拆分"机制 ref / 应用 ref"，不可简单 bump。
- **deps 工作树"修改"定性（二轮核实）**：`deps/ffmpeg`（configure/hls.c）与 `deps/libplacebo`（spirv.c/custom_mpv.c）四处修改全部为构建配方自动产生（`patch.sh`+`patches/*`、`scripts/ffmpeg.sh:26` sed 置空 `FFMPEG_CONFIGURATION`），本地与 CI 同源复现，不构成链间差异。hls.c 与配方补丁应用结果仅差 1 空行；libplacebo 两补丁 reverse-check 逐字吻合。首轮"手工脏改动"判断错误已更正。
- **completed（2026-10-27 追加，云端配置，未动仓库文件）**：CI 签名统一到本地 debug key。经用户确认后 `gh secret set` 向 `Goodwu/PiliPlus` 配置 4 个 Actions Secrets：`SIGN_KEYSTORE_BASE64`（`~/.android/debug.keystore` 的 base64）、`KEYSTORE_PASSWORD`/`KEY_PASSWORD`=`android`、`KEY_ALIAS`=`androiddebugkey`；`gh secret list` 确认就位。`build.yml` 既有 "Write key" 步骤（仅 `workflow_dispatch` 触发生效）会在 CI 解码生成 `android/key.properties`，release 产物与本地包同签名、可互相覆盖安装。边界：debug key 密码为公开约定值，安全性=keystore 文件保密性，不可用于商店上架；本地 keystore 为根（sha256 `8d811b0c…0a091`，证书 SHA-256 `2D:5D:47:24:…:41:0E`），删除/换机重生即与 CI 不一致，需自行备份；端到端验收待一次 workflow_dispatch 构建的 APK 证书指纹比对。
- **首轮误判已更正并回退**：曾断言五条旧工作流（build/ios/mac/win_x64/linux_x64）"CI 全断"并加 media-kit 克隆步骤——事实是它们在本仓**从未运行**（`build.yml` 不在默认分支、workflow_dispatch 不可达；`gh workflow list` 仅注册 "Locked source and native package builds"），经 `gh run list` 核实后五处修改已 `git checkout --` 回退。真正在跑的云端链是 `ci/native-packages-20261023` 分支的 `source-build.yml`+`build-platform.yml`+`tool/native/*`，最后成功运行 2026-10-23（六平台全绿）。
- **App 层差异（设计内，未改）**：CI 用 temurin JDK 21 构建 Android App（native 构建用 17），本地入口默认 openjdk@17；CI 发布变体（release+`pili_release.json`、3 ABI、minSdk 提至 API26、ndkVersion 钉 27.2）vs 本地测试变体（`dev=1`、仅 arm64、本地 JAR）。`build_application.py` 调用同一 `lib/scripts/build.ps1`+`patch.ps1`。Flutter 3.47.7 两边一致（CI 从 lock 读取）。producer `3605f300`、helper `b768ce10`、NDK 27.2/API26 一致。
- 验证边界：锁更新经 `ci.py plan` 六平台校验；三基点组合的本地验证依据＝标准入口 2026-10-25/10-27 两次 `=== VERIFIED` 源码构建（含能力标记核验）；CI 侧端到端以最终 run 为准（首次 run 40525579467 已取消，非代码失败，是 media-kit 错提）。

## 对齐后的链路状态

| 维度 | 本地（标准入口） | 云端 CI（update 分支） | 状态 |
| --- | --- | --- | --- |
| mpv 基点 | `4c6e1796`（media-kit/android） | 同 | **一致** |
| FFmpeg 基点 | `d4bb79394b`（lg-p84-d1-vui-fix-20261010） | 同 | **一致** |
| libplacebo 基点 | `c9fd8798`（optimize/dovi-external-yuv-20261027） | 同 | **一致** |
| media-kit Dart | compat `c8c5aaab` | 机制分支 `d7662218`（CI 设计约束） | **既定差距，后续任务** |
| 配方补丁 / producer / helper / NDK / API | 同左 | 同 | 一致 |
| Flutter / patch.ps1 链 | 3.47.7 | lock 3.47.7 | 一致 |
| App 变体 / JDK | dev=1 仅 arm64 / JDK17 | release 3 ABI + minSdk26 / JDK21 | 设计内差异 |
| 旧五工作流 | — | 从未运行（不可 dispatch） | 死路径，未动 |

## libmpv 构建库全景（多链对比）

1. **本地测试链**（`tool/build-android-test.sh` 现编）：mpv `4c6e1796` + FFmpeg `d4bb79394b` + libplacebo `c9fd8798`（配方补丁自动应用）+ helper `b768ce10`，producer `3605f300`，NDK 27.2/android26，JAR 现编注入（`mediaKitLocalArm64Jar`）。
2. **CI source 链（android，本次更新后）**：与本地测试链同基点同配方，四 ABI 源码编译成 native 包再由 App 消费。
3. **发布 JAR 链**（gradle 默认下载，发布/无本地 JAR 时）：`media-kit-d24c59905-ffmpeg-b4d2ea4`（v2026.013，vkweak）+ Predidit v1.2.7 其余 ABI——**已知缺 DV bridge（d24c59905 早于 ca571a35a8），DV P8.4 设备落 reshape**（见 MARBLE-DV-P84 任务）。
4. **CI upstream 链**（win/linux/darwin 默认）：Predidit 预编译包（win mpv `ad59ff1` 20260811；darwin mpv 0.36.0/FFmpeg 6.0 0.6.8）；linux source 档仍钉 mpv `e0dc99d0`/ffmpeg `9aba43cf`/libplacebo `ea700489`（默认走 upstream，未随 android 更新，属 CI 专属档案）。

## 证据

- 推送记录：libplacebo 新分支 `optimize/dovi-external-yuv-20261027`＝`c9fd8798`（ls-remote 确认）；mpv `media-kit/android`＝`4c6e1796`、media-kit compat＝`c8c5aaab`（ls-remote 确认，用户先行推送）。
- 机制分支证据：`d7662218` ∈ `ci/verified-native-packages-20261023`（该分支 tip）；`git log d7662218..c8c5aaab -- tool/native_package` 为空＋diff 显示该目录在 compat 线不存在（-1233 行）→ 两线分叉非前进。
- 失败 run：`40525579467`（media-kit 错提 c8c5aaab 时）plan success、android/ohos source in_progress、win/ios/macos/linux upstream failure（缺 verifier），已 `gh run cancel`。
- 锁校验：回退后 `ci.py plan` android 摘要 `890f79f1…`（与错提时相同——media-kit 不参与 native 输入摘要，证明三基点才是摘要变化来源）、其余平台不变。
- 配方补丁定性：`deps/ffmpeg` hls.c 与"干净 `d4bb79394b`+kazumi 补丁"diff 仅 1 空行；libplacebo 两补丁 reverse-check 通过；configure 空白化命中 `scripts/ffmpeg.sh:26`。
- libplacebo 分叉：远端 `optimize/dovi-linear-decode` 4 提交（6a2f2063/9b6e0834/980742df/ea700489）vs 本地 2 提交（7966d8ec/c9fd8798），tip diff +93/−305，故推新分支不强推。
- 误判过程记录（四次教训）：①`origin/compat` 简写引用不存在致"已推送"误判——分支存在性必须 `git ls-remote`；②未查 `gh run list`/`gh workflow list` 就断言"CI 全断"——断言前先看实际运行记录；③把配方自动补丁当手工脏改动——判断 deps 树修改来源先核对 `patch.sh`/`patches/`/构建脚本；④把锁的 media-kit ref 当"落后版本"去 bump——锁内 ref 先弄清它钉的是什么线（机制分支 vs 应用分支），改动锁前先验证校验机制依赖。
