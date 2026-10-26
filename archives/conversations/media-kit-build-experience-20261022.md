# media-kit-build 工作区经验汇总（2026-10-22）

## Current State

背景：`~/src/media-kit-build` 是 2026-09-30 至 10-22 期间 media-kit 原生构建与实机验证的 scratchpad 工作区（非 git 仓，约 12 万文件、百个任务轮次目录），覆盖 LG API24 构建链、macOS/iOS 构建链、shared 产物验证三大簇及 evidence/jars/scripts/sources 顶层资产。用户要求汇总值得保留的经验；本归档即汇总成果，四路并行 Scout 收集完成，未遗漏重大主题。

当前状态：汇总与资产迁移完成。3 条跨项目经验已去标识化沉淀至长期 memory（android-native-incremental-build / build-artifact-evidence-chain / old-android-forensics-degradation）；全部二进制证据按用户决定放弃；47 份工具与关键文档已迁至 `~/src/media-kit-experiments/media-kit-build-20261022/`，目录清单见该目录 README。原工作区 `~/src/media-kit-build` 当前仍存在，按用户既定决定待用户删除；未代为删除。仓内本归档与迁移副本是已保留内容。

关键结论（对接手有决策价值）：
- **Android 原生构建链可复现的核心配方**：不重跑完整构建系统，用 `make -n V=1` / `compile_commands.json` / `ninja -t commands` 提取原始命令行，重编目标 `.o` 后 `llvm-ar r` 塞回 `libavcodec.a`，重放 ninja 链接命令出 `libmpv.so`；NDK 27.2 + `aarch64-linux-android26` 目标可在 API24 设备运行。JAR 换装须 `zip -0` store + `zipalign -p 4096`，否则 `INSTALL_FAILED_INVALID_APK res=-2`；重链产品库必补 `-lc++_shared`（LG 上 dlopen 失败真因，已实测，即 TASKS.md 2026-10-22 勘误的依据来源）。
- **证据纪律是整个工作区最有复用价值的部分**：每轮固定 env 指纹（repo SHA/device/JAR SHA-256/工具链）、冻结证据包（manifest+SHA256SUMS+raw-logs+独立 review verdict）、fail-closed preflight（pin 为 null 直接 exit 2）、四级 SHA 钉扎（source/JAR/APK/identity json）、负面用例保留不重签。这套模式贯穿 lg-api24 与 shared 两条线。
- **旧/阉割 Android 设备取证有系统性通道降级**：LG API24 上交互式 logcat 恒空须 `adb exec-out`、SF `--latency/--framestats/--timestats` 均不可用、无帧级指标通道，判定只能靠截图+RPC+logcat；应先探测证据通道可用性留 channel-verdict 再设计验收（协议 `lg-api24/LG-DEVICE-LOGCAT-PROTOCOL.md` 全部实测）。
- **命名语义陷阱**：`framePresented` 实为 Metal commandBuffer 完成回调而非 drawable presented；报告字段可能是期望常量而非实测值。验收措辞须区分实测与期望。
- **产物谱系与样片规则已固化**：测试样片按 `类别-内容-分辨率-coding-<SHA256前8>` 命名，来源/ffprobe/dovi_tool 三重记录（`sources/SOURCES.md`）；JAR 谱系 upstream-predidit（阴性对照）→ 各修复版，可按名溯源。
- **两个教训性事故**：①钉住的 `mediacodecdec_common.o` 在诊断轮被覆盖且原字节不可恢复——长期诊断轮的 pinned 中间产物应改"档内生成"；②macOS shared 链因 media-kit 共享 slice 全部 untracked 无法 pin 不可变 commit，candidate preflight fail-closed——发布链依赖的源必须先正式 commit 才能进 CI。

下一步：原工作区 `~/src/media-kit-build` 仍待用户按既定决定删除；迁出的 47 份工具与文档已保存在下方路径。二进制证据不在保留范围内。

接手入口：
- 迁出资产总目录：`~/src/media-kit-experiments/media-kit-build-20261022/`
- LG 设备取证协议：`~/src/media-kit-experiments/media-kit-build-20261022/docs/LG-DEVICE-LOGCAT-PROTOCOL.md`
- LG 构建与验证脚本：`~/src/media-kit-experiments/media-kit-build-20261022/lg-api24-tools/`（依赖原构建树的脚本仅作配方参考）
- macOS universal 构建经验：本归档“macOS/iOS 构建链”章节；原构建树依赖未迁移
- 样片登记规则：`~/src/media-kit-experiments/media-kit-build-20261022/docs/test-sources.md`
- 自动验收脚本：`~/src/media-kit-experiments/media-kit-build-20261022/scripts/`

## Findings

### 一、lg-api24 主线（最大簇，400+ 构建运行轮 + 文档）

- **增量覆盖编译**：基线 prefix 来自 `~/src/libmpv-android-video-build-dv-experiment/buildscripts`；`build-native-dv-facts.py`/`build-native-dv-candidate.py` 提取原编译命令→重编 `.o`→`llvm-ar r` 入 `libavcodec.a`→重放 ninja 链接→`llvm-strip`；facts 版额外覆盖 mpv 侧 6 个源（vulkan context、vo_mediacodec_embed、vd_lavc、command.c 等）。
- **JAR 槽位换装**：`build-native-dv-release.py` 替换 pinned JAR 内 `lib/arm64-v8a/libmpv.so`（JAR/LIB SHA 双钉、构建前后复验）；Flutter 侧 `ORG_GRADLE_PROJECT_mediaKitLocalArm64Jar` 注入；发布链强制逐字节 source approval manifest + APK 内 so SHA 回读 + `apk-identity.json`；diagnostic defines 走 `--dart-define` 白名单。
- **实测坑**：APK 内 .so 换装必须 `zip -0` store + `zipalign -p 4096`（extractNativeLibs=false 场景）；`MKS_DEFINES_OVERRIDE` 是合并语义，放宽实验需显式传 false。
- **P5 根因链（实测闭合）**：mpv 默认 MP4 skipinfo 绕过 `avformat_find_stream_info`→原生 DV 无 CSD→Home 重进崩溃；修复为 demux 层 hvcC 补全（Meson feature `lavf-initial-dovi-hvcc`）+ FFmpeg PPS→SPS→VPS 严格链校验；PS 读探针初版会误开软解，须 PS-only 分支跳过 `try_decode_frame`。
- **验证取证**：`probe-rpc.py` + 各 `run-*-matrix.py`（open→采样 positionMs/hwdec→exec-out 截图+JSON 落盘）；`observe-mks.py` 标准采集器（force-stop→冷启→logcat→路由断言+SF 采样→BACK 严格退出）；设备能力探针先行（codec profile/hdr 能力矩阵，`native-dv-codec-report.txt`）。
- **lifecycle 边界**：失败报告 `closed=true` 不等于持久化证明，完成标记只在 close fulfill 后置位（`lg-failed-exit-review-v2/REVIEW.md`）；后台暂停回前台不恢复需显式 Resume action 且与 lifecycle action 串行化。
- **genbump 演进与事故**：后期改六库 FFmpeg 全量重编（genbump）以退役覆盖版 `.o`；r22 钉住的 `mediacodecdec_common.o` 被诊断轮覆盖不可恢复，事故记录在 `...marble-dv-auto-aspect-final-20261022-build/native-candidate.json` incident 字段。

### 二、shared 系列（macOS shared-core 产物链，2026-10-04~05）

- **链路本质**：media-kit 仓 `tool/shared_gpu_next/` recipe 构建 mpv shared-core（dylib/framework、shared-backend JSON、Swift bridge）→ `fetch_macos_shared_ci_inputs.py` 固定输入 → 消费脚本注入 flutter build 的 App。**卡点**：`reviewed_media_kit_revision: null`（共享 slice 全部 untracked），candidate preflight fail-closed（exit 2）——发布链依赖的源必须先正式 commit。
- **验证方法论**：CPU/mock 测试 + py_compile + `git diff --check`；raw-logs 直录 stdout/stderr/exit code；SHA256SUMS/binding.json + 独立 review-v1/v2 verdict；负面用例（symlink escape、drift、错误 ABI）必须被拒。跨主机门协议：producer 记录身份（checkout root/python/脚本 SHA），consumer 只用固定相对路径语法。
- **failed-frame v3 freeze 复现**：九组 CPU fixture + 七步 receipts.json（exact argv、真实 subprocess 返回码）；诊断需 epoch/mode 锚定、token 去重、默认关闭零开销。
- **命名陷阱**：`framePresented` 是 Metal commandBuffer 完成回调而非 drawable presented；HDR plan 中 `pixelFormat/colorSpace` 是期望字面量非实测。
- **fixture 原生库预载**：standalone Dart 进程测试需 `MEDIA_KIT_TEST_FRAMEWORKS` 预载 @rpath dylib（libass）。
- **FBO 实验**：Lead 叫停 A/B/A 实验，withdrawal r2 全量移除并冻结 sha256/diff——被否决实验也要留冻结退出记录。
- 边界：整个 shared 链未接入正式 CI，无 GPU/签名/上架验收；HDR 亮度验收未关闭。

### 三、macOS/iOS 构建链

- **universal 构建**：arm64 复用已审 `mpv-reviewed-arm64.dylib`，x86_64 用 meson cross file（`-mmacosx-version-min=12.0`、needs_exe_wrapper）新建，`lipo` 合并出 `mpv-rebuilt-universal.dylib`；`mkp4prefix/` 为集中依赖 prefix（libplacebo/libav*/shaderc 等）。
- **产品 FFmpeg**：`product-ffmpeg-lib/GENERATION.txt` 记录 b4d2ea4（P5 RPU 整改版）产物溯源。
- **打包门禁**：`verify_macos_mpv_closure.py` 严格解析 otool 依赖、拒绝逃逸路径/畸形行/空架构集；`package_macos_shared_build.py` 用 `renamex_np(RENAME_EXCL)` 独占发布、sidecar 回滚按 inode 匹配。
- **冻结快照式 commit**：批准 slice 与 live worktree 分离，隔离 checkout 物化快照、逐文件 SHA 绑定；组件哈希匹配≠批准（inventory 中 53 行标 `FROZEN_COMPONENT_IDENTITY_MATCH` 或 `UNKNOWN`）。
- **派生 Info.plist**：源模板→前置 phase 派生→ProcessInfoPlistFile→只读 guard→CodeSign，避免 producer/sign 环。
- **r4 stutter 架构分析（未定案）**：VO 丢帧 1675/179s、缺口在生产端（小窗 drawable 1416×708 但生产恒 3840×1920 RGBA16F，~7.35× 像素）；候选排序：全分辨率 GL 生产+跨 API 同步（高）＞调度/时钟等待与 main 反压＞阶段性缓存；独立 Homebrew mpv 同段复现卡顿，削弱 App 桥接唯一原因假设。telemetry 纪律：GPU100%≠独占、thermal fair≠降频。
- **iOS**：presented handler 用 `#if os(macOS)` + 精确 availability 收窄；shared runner 编译需先 pod install（r2 exit 0），r1 直接 build exit 65。

### 四、顶层资产

- **scripts/ 四脚本**：`merge-accept-round.sh`/`merge-accept-destroy-round.sh`（adb 自动验收：解锁→focus 轮询→logcat→定时截图→关键 grep→EXIT trap 恢复原 APK；后者验证播放中销毁零崩溃+线程闭环）；`pixel-judge.py`（320x180 缩略像素统计判黑/白/紫/纯色/正常，紫屏判据 R>G+25 && B>G+25）；`mk-relink-product.sh`（build.ninja 行提取法重链 + 必补 `-lc++_shared`）。
- **sources/SOURCES.md**：样片命名 `类别-内容-分辨率-coding-<SHA256前8>`，来源三重记录（URL/ffprobe DOVI record/dovi_tool 交叉验证），缺口显式标注（真实 P7 MEL/P8.2 公开样片不存在，用合成替代并注明局限）。
- **evidence/ 22 目录**：oes-buffer-retire（密集播放修复）→ hdr-auto-output（验收主线）→ merge-accept（三组合并验收）→ regression-two-device（双机矩阵）→ b1 系列（LG-G7 HDR10+）→ lg-p84-reopen（failure-chain.txt 分层摘要范例：从原始 log 逐字摘行呈现"能力自报→候选→接线→阻断"）→ compat-marble-20261019（含 HyperOS 脚本适配点：isStatusBarKeyguard 字段差异、横屏 tap 坐标、`path=` 替代 `sample=`；完整交接文档在 `superseded-local-handoff-20261019.md`）。
- **散置**：`history-strip-20261006`（commit-map.json，历史重写 2360 条旧→新映射）；`mk-device-20261011`（MK-ROUTING 轮完整工作区）；`piliplusx-routing-20261013`（APK 构建溯源 hashes.txt）；`local-dirty-snapshots`（脏改防丢快照）。
- **JAR/APK 谱系**：upstream-predidit-v127 作阴性对照起，各修复版 JAR 可按名溯源；APK p5-original-12492 为恢复基线。

### 未覆盖项（Scout 声明）

- lg-api24 的 fullscreen-mount 系列、pili-startup 后期轮最终画面验收汇总未逐目录深读（后者结论以 PiliPlus TASKS.md VIDEO-STARTUP-LATENCY-20261022 为准）。
- `ohos-emulator-evidence-20261007` 仅 3 张 jpeg 未判读。
- macOS universal 合并具体脚本命令未逐条捕获。

## Decisions

- 汇总成果记入本仓 conversation 归档（工作区横跨 media-kit/PiliPlusX/PiliPlus，本次任务从本仓发起）。
- 3 条通用经验已由用户确认并去标识化迁入长期 memory；具体项目事实留在本归档，符合“新经验先记项目内”的写入策略。

## Action Items

- [x] 跨项目沉淀（2026-10-22 用户确认后完成）：①Android 原生库增量覆盖编译+JAR 换装打包规范②构建产物验证证据链方法论③旧 Android 设备取证通道降级预案，均已去标识化写入 `~/ConfigFiles/ai-longterm-repo/memory/2026/2026-10-22__*.md` 并登记 INDEX。
- [x] 工具与关键文档迁移（2026-10-22 完成，后按用户要求移至仓外）：`~/src/media-kit-experiments/media-kit-build-20261022/`。
- [ ] 用户自行删除 `~/src/media-kit-build` 目录（二进制证据全部随之放弃，用户已确认）。
