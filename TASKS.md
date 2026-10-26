# TASKS.md

任务事实源：只保留当前状态、验收门槛和下一步；按各项 `context` 查看持续更新的依据。
## LG-HLG-PQ-BRIGHTNESS-MAPPING-20261025
- **completed、用户采用，已授权提交推送**：1000参考峰值/gamma0，取消自动+3，不加曲线；105 tests/analyze0与5份生产源哈希保持。
- **同帧观感**：熊35.035秒、夕阳720.052666667秒、近黑600.032766667秒用户均反馈基本一致；夕阳明确无明显过曝/细节丢失。近黑HDR10直通/离屏参考一致。
- **交付与运行**：标准源码PiliPlus APK SHA6da37fb9…已安装LG且base.apk一致；北海道原片硬解SurfaceTexture→PQ/ext:lg-pq、peak1000、applied verified=true、HDR1。用户确认主应用连续播放“正常，采用这版”，验收通过。
- **证据边界**：原片35秒0.1–1000nit分段中位偏差最大3.87%，稀少高光+6.79%，无<.1nit样本；fixture暗边缘/高光残差未消除，不宣称逐像素或全片一致。面板nits未量测。
- **context**：[lg-hlg-pq-brightness-mapping-20261025.md](archives/conversations/lg-hlg-pq-brightness-mapping-20261025.md)；永久交付摘要在PiliPlus `archives/evidence/lg-hlg-pq-minimal-20261027.json`。用户2026-10-27授权提交、推送；仅纳入本任务范围，保留其他修改。


姊妹仓：本地 media-kit checkout 在 `../media-kit`（compat 分支），本仓的一切播放器行为变化先看其 `TASKS.md` 的 MK-ROUTING 段。
**镜像红线（2026-10-17 起；改名后仅适用于旧仓 PiliPlus.old）**：旧仓 `main/dev/dom` 与全部 tag 由 `ci/upstream-sync` 孤儿分支每日强镜像自上游（force+prune），自有提交只能放特性分支（当前工作分支 `feature/ohos`，不受镜像影响）。

## MACOS-XCCONFIG-PODS-INCLUDE-20261024

- **done（本地提交，不推送）**：恢复 `macos/Flutter/Flutter-Debug.xcconfig` 与 `Flutter-Release.xcconfig` 的上游默认第一行 `#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.{debug,release}.xcconfig"`。属标准 Flutter macOS 工程结构：`pod install` 后由该两行向 Runner 注入 Pod 构建设置；Pods 目录未生成时为无害空操作。无行为验证项（macOS 构建另行复验，见 CODEC-CAPABILITY-GRAYING-20261022）。

## CODEC-GRAY-PRE29-KIND-20261023

- **已修复并实机验证 / media-kit 已本地提交（不推送），本仓仅文档，提交事实以 Git log 为准**：用户报障"P10 Plus 所有格式选项全灰"。根因在姊妹仓：`VideoRouteCapabilities.decoderKind` 在 API<29 永不返回 hardware（厂商 OMX 归 unknown），App `_decodableAtSize` 把"无 hardware 解码器"判不可播 → VKY（API28）/LG G6（API24）三族全灰。决策依据（AOSP 源码核实）：API29 `isHardwareAccelerated` 对 OMX 组件本就是"非 OMX.google 前缀+无 software-codec 声明"的命名推导，pre-29 镜像它同级可信；参考 Parseus/codecinfo 实机验证软解黑名单。修复仅改 media-kit（decoderKind pre-29 分支 + `isSoftwareDecoderName` 黑名单；API≥29 行为不变），**App 侧按用户指令零改动**。
- 验证（dev 变体 77.9MB，5 台全装）：VKY 探测旧版三连灰→新版仅 av01 灰、流级仅 AV1 各档灰（正确）、1080P 硬解实跑（OMX.hisi + `hwdecCurrent=mediacodec-copy verified=true`）；LG G6 同闭合；LYA（API29）回归通过零置灰。用户另报"无法加载解码器"toast：查明为**预先存在**（旧 APK 对照复现相同序列）——路由 planner 对 VKY 规划 `hwdec=mediacodec` 直接模式，hisi OMX 直接模式缓冲分配失败（DynamicANWBuffer/buffer count 全拒）→ 首轮落软解并外泄错误事件成 toast → 路由 degrade → 重开 `mediacodec-copy` 硬解成功（最终硬解非软解）；与 decoderKind 修复及 libmpv 换链无关，修复方向候选见归档，待用户定夺。
- 工程教训（已入姊妹仓 TASKS.md）：构建须 `ORG_GRADLE_PROJECT_dev=true`+`JAVA_HOME=openjdk@21`；忘带 dev 属性时 `adb install -r` 对无后缀包报 Success 实为并列新装，复测跑旧包——install 后必须核对 on-device base.apk 尺寸/lastUpdateTime。
- context：[codec-capability-graying-20261022.md](archives/conversations/codec-capability-graying-20261022.md)（2026-10-23 晚追加段）；姊妹仓 TASKS.md `DECODER-KIND-PRE29-20261023`。

## PLAYBACK-DIAG-BAR-20261022

- **done（2026-10-25，色彩信息拆分，本地提交、不推送）**：原mpv色彩改为独立片源元数据和输出观测；未知逐项省略，不猜测、不显示“不可用”。原生实际硬解直通显示“输出=解码直通”；GPU显示“输出目标”。库9项/App14项测试、定向analyze、V1通过；同包原生getter在带标签/无标签SDR样本及current-tracks alias实测通过。LYA实测目标bt.2020/pq/full/rgb、滚动与按钮正常；marble实测原生DV“解码直通”。实际Bili测试视频未显示片源字段，不声称已直接确认其raw缺失原因。标准源码构建VERIFIED，APK27,610,981B SHA `96d5b558…434571b`，当前在线5台全安装且逐机哈希一致，最终重枚举5台全部OFF（两OLED Asleep；Redmi8 Dozing/OFF）。完整结果：[playback-color-diag-20261025.json](docs/validation/playback-color-diag-20261025.json)。播放/HDR路由保持不变。
- **done（2026-10-25，纳入本次本地提交）**：LYA 竖屏诊断不再挤出进度/播放/倍速/全屏按钮；footer/诊断按真实剩余高度分配，诊断可内部上下滚动。已局部绕过项目SDK滚动视口底30dp禁拖补丁，保留区域外播放器手势/全局策略。真实生产widget 3/3、定向analyze、V1通过；最终c999包LYA实机上下滚动按字段变化验收通过，按钮/进度始终可见，无误全屏。
- **marble结论**：报告场景实际系统native DV/HDR已激活（10-bit P010/DEVICE、HDR1、mHdrVisible=true及帧推进）。原色彩字段是mpv/MediaCodec帧参数，并非显示输出，已改标“mpv色彩”。不据BT709标签判SDR；不扩大成面板光学亮度/EOTF验收。
- **构建/部署**：标准源码入口VERIFIED、结果单verified；最终APK 27,606,857 B，SHA-256 `c999a25a…222eb602`，包`com.example.piliplus.dev` v2.1.6。六台在线机LYA/LG/VKY/Redmi8/Note5A/marble全安装成功，逐机base.apk SHA一致。用户要求OLED测试后熄屏，最终两机均Asleep/OFF，旋转恢复原1/0；LYA媒体音量/静音状态已精确恢复index0/Muted=false。
- 验证结果：[playback-diag-final-20261025.json](docs/validation/playback-diag-final-20261025.json)；唯一context：[playback-diag-bar-20261022.md](archives/conversations/playback-diag-bar-20261022.md)。旧阶段/失败测试与修正依据保留于context，用户授权本地提交；不推送，提交事实以Git log为准。

## LYA-DV-P84-HLG-TO-PQ-OVEREXPOSURE-20261024

- **implemented / 修复已实施并装机（2026-10-24 晚，media-kit 改动未提交，V1 可交付）**：统一方案落地——Android 适配器经公共 API `getDesiredMaxLuminance()`（原 hidden API 编译不过，已偏差追认）采集面板峰值，有效窗 finite && 80–10000（用户反馈原 4000 上限过保守，已放宽），Dart `HdrRoute.targetPeak` 贯通 planner→backend 三分支，reshape/baseLayerConvert 注入真实峰值、缺省兜底 '1000'，decision 行加 `peak=`；YUV 契约常数降为兜底（同步解决 LG 点亮轮「target-peak=1000 亮部残余过曝」遗留）。验证：analyze 零新增、目标批 212 过；源码通道构建 VERIFIED，APK `6e169fc4…b04ba` 装 LYA+LG。**LYA 实机验证通过**：decision `peak=500`（该机实报 500 nits）、路线 verified 不回退、推进/零崩溃；**面板观感验收待用户**（过曝应消失；screencap tone-map 不可作亮度证据）。**LG 证据闭合**：exec-out 通道补跑通过（`peak=500`、baseLayerConvert verified、零崩溃；交互 shell logcat 为空属既有环境特性，一律 exec-out）。两台**面板观感验收通过（用户，2026-10-24 深夜）**。根因诊断与代码级证据链见 context。
- context：[lya-dv-p84-hlg-to-pq-overexposure-20261024.md](archives/conversations/lya-dv-p84-hlg-to-pq-overexposure-20261024.md)。

## MARBLE-DV-P84-ROUTE-REGRESSION-20261023

- **两项修复均已实施并实机验证（2026-10-23 凌晨；media-kit/App 改动未提交）**：
  - **修复A（reshape dataspace，media-kit Java）**：`PlatformVideoView.setColorSpace` API≥34 先走生产者侧 NDK `ANativeWindow_setBuffersDataSpace`（BLAST 逐帧事务携带 dataspace，层状态得以保持），`surfaceControl` 一次性层事务降为窗口设置失败的回退（原实现 commit 后被逐帧 buffer 事务覆盖，层恒 SRGB）。API<34 分支逐字节不变。javadoc/`real.dart` 路径注释同步；需求文档 §8 已实机注记。验证（中间包 83af7d78，无本地 JAR→marble 走 reshape）：`path=ndk applied=true readback=DATASPACE_BT2020_PQ`、SF 视频层 `dataspace=BT2020_PQ`（修复前全机零 PQ 层）、播放推进、零 FATAL/ANR；dataspace 报告契约测试 7/7。**用户面板观感验收待定**（dvP84×reshape 仍 experimental：P8.4 走 hwdec=mediacodec 时 DV RPU 到不了 gpu-next，观感为 HLG 基层→PQ 非真 DV）。
  - **修复B（恢复硬解 DV）**：最终包带 `--android-project-arg mediaKitLocalArm64Jar=…/mks-arm64-v8a-opaquealpha.jar`（f5461124）重建，APK `2367b927…65de1` 已装 marble。验证：`nativeDolbyVision:ok` 首候选命中、`phase=applied vo=mediacodec_embed hwdec=mediacodec output=dolbyVision verified=true`、MediaMetrics `c2.dolby.decoder.hevc` configure 3840×1920（当前 pid）、播放推进 14%、零 FATAL/ANR。**发布 JAR v2026.013 仍缺 bridge（mpv d24c59905 早于 ca571a35a8）——不带本地 JAR 的默认构建在 DV P8.4 设备上会落 reshape**，发布 JAR 升版收录 bridge 待立项。
  - **experimental 条件控制复查（2026-10-23 凌晨，用户指令"全部取消"）**：全链 grep 证实 **maturity/experimental 已无任何行为分支**——planner/realizer/session（含 native DV policy）/open-plan/review/report 全部只作数据携带与诊断输出；`HdrStrategyMaturity` 零比较（仅 `==`/hashCode）；App 与 Java 零命中。两处表面命中均非门控：`video_route_options.dart` 是**丢弃旧 experimental 键的迁移代码**（即当年取消动作本身），`media_kit real.dart` 的 `strict=experimental` 是上游 FFmpeg demuxer 标志与 HDR 无关。唯一实质残留＝`_evaluate` 的 `gateMaturity` 参数名（已无门控语义、仅标记 SDR 安全网）→ 已改名 `safetyNet`（纯重命名零行为，media-kit 工作区未提交）；`experimentalStrategySkipped` 死枚举保留（文档明示 planner 不再产生，测试以反向断言钉住其不出现，属防回归护栏）。相邻但**非** experimental 的结构性拒绝（未动，如实登记）：nativeDV 单层白名单 P5/P8.4（FFmpeg native_dv 契约对齐）、dvP10/AV1 全拒（Phase 1 范围）、nativeHdr10Plus/Vivid routeNotImplemented（无传输实现）、dvP5 baseLayer 拒绝（忽略 RPU 输出错色，红线一致）、`_convertRouteLock` lab define（生产默认 pq 不受影响）。验证：planner 测试 48/48、maturity/admission/v73/source-routing 批 29/29、analyze 零问题。
  - 诊断轮根因与证据（JAR 字符串比对、SF 层普查、logcat 序列）见 context。
  - context：[marble-dv-p84-route-regression-20261023.md](archives/conversations/marble-dv-p84-route-regression-20261023.md)。

## LG-DVP84-NATIVE-UNAVAILABLE-20261024

- **已修复并装 LG 验证，按用户授权本地提交归档，不推送；提交事实以 Git log 为准**：标准入口从当前本地源码构建原生链，核对 native receipt→JAR→最终 arm64 split APK 三成员；允许且精确验证同 NDK strip 的正常变换，拒绝旧库/重复成员/foreign ABI/缺能力标记。dev 缺本地 JAR 直接失败。首轮门检实抓插件额外 ABI，修为默认 split 后整链重跑通过。APK `e17d3aee…028c9`（27,541,013 B）设备回读一致，libmpv `6a657dd0…ecc43a` 与本次 JAR 精确一致。
- decoder review 因实际 `hwdecMismatch` 重规划耗尽时，保留该首因，不再误报其它候选的 `nativeDvUnavailable`；原始 native DV 准入失败语义保留。PiliPlus `AGENTS.local.md` 已记录标准源码构建命令与禁止使用旧 JAR 打包规则。session 53项、构建工具11项与定向analyze通过，独立V2审核无阻塞。
- LG 两源 `BV1vY4y1N7TY`（3840×1920）/`BV1uZ4y1U7h8`（本轮实际3840×2160）均为 DV8/compat4、高通HEVC硬解、`surfacetexture + baseLayerConvert → PQ/ext:lg-pq verified=true`；视频层format43/7FA30C04、面板HDR开启，约73s/61s观察窗内真实buffer检查点推进，零FATAL/ANR/阻断。用户明确确认“能看到正常视频”。不宣称nativeDV直通、精确FPS/逐帧零丢帧或面板光学校准；系统截图视频区仍黑，与用户实看证据分开。本轮验收结束时 LG 正在播放第二源。context：[marble-dv-p84-route-regression-20261023.md](archives/conversations/marble-dv-p84-route-regression-20261023.md)；持久机器证据：姊妹仓 `docs/validation/lg-dvp84-source-build-20261024.json`。

## LYA-DV-TRANSLUCENT-RESIDUE-20261022

- **已验收 / 用户授权本地提交归档（不推送）**：texture正式修复保留；用户确认去除alpha清除补丁后的LYA候选横竖屏、全屏进出及控件显隐“全部正常，无残留”。无alpha APK SHA `fd1882ecb327e491a79856b5a0f158a7ccab52c68056e7e56d6e997cae72fda9`，其 `libmpv` 为 `c9c6c89900da7eaa42be10e95852c37a5459960ef227aa74f298d13a4c742520`；独立设备核验确认 texture 根视图、OMX.hisi 硬解、10-bit BT2020_PQ、帧推进，无FATAL/ANR。用户授权本任务本地提交归档，不推送；提交事实与hash以Git log为准。
- **实现与根因边界**：media-kit/vendor `requiresFlutterTextureView` 默认false，由LYA适配器在既有能力范围自报true；App通过通用能力查询并按Activity缓存，无机型分支。视频Surface、硬解及真实PQ HDR路径未改。texture对照支持旧Flutter根Surface/合成拓扑参与残留；alpha清除和GL/Vulkan临时打点已从mpv源码撤回并备份于 `.git/diagnostic-backups/lya-alpha-removal-20261023-104644/`。具体alpha状态或HWC/驱动因果根因未定，不作定案。mpv当前无本任务diff；`f_decoder_wrapper.c` 的既有改动属于其它任务，不纳入本任务提交。
- **已知现象（用户决定不处理）**：同一暂停帧且控件隐藏时，竖屏与横屏全屏亮度/色彩仍明显变化；用户决定接受现状，不再定位或修复。它不是本残留修复的阻塞项。
- context：[lya-dv-translucent-residue-20261022.md](archives/conversations/lya-dv-translucent-residue-20261022.md)。

## CODEC-CAPABILITY-GRAYING-20261022

- **implemented / 已本地提交（未推送）**（按用户 review 重构：App 侧平台代码全部迁 media-kit，既有文件 diff 最小化）；实机视觉复核由用户持续进行中。两轮过滤：①**显示轮（全平台）**：HDR 画质（125/126/129 等）只在面板一种 HDR 能力（PQ/DV/HLG）都没有（SDR 面板）时置灰，支持任意一种即全部不置灰（HDR 格式间转换由解码库内部处理）。数据统一经 media_kit_video `VideoRouteCapabilities.query(target: applicationView)` → `display.hdrTypes`：Android 原生适配器 + 本轮在 fork 新增的 darwin（macOS EDR/iOS 未知）与 Windows（Advanced Color）适配器（见姊妹仓 VIDEO-ROUTE-CAPABILITIES-DARWIN-WINDOWS-20261022）；Linux 无适配器按未知不置灰。②**解码轮（仅 Android，PC 不做解码过滤）**：同 API 的 sources 查询按 RFC 6381 codec 串+分辨率+帧率判硬件解码器（`kind: hardware`；DV 串按 HEVC Main10 基层或原生 DV 解码器任一）；census 不完整/未知/查询失败一律按支持（宁可漏灰不可误灰）。UI：画质弹窗（显示轮 + 该画质全部流均无硬解才灰）、解码格式弹窗（格式族全部流均无硬解才灰），当前已选项保持可选防锁死。自动选流：`CodecCapability.findPlayableTargetVideo`（过滤+acceptQuality 收敛+全滤回退）与 `playableVideosOf`（findVideoByQa 用），全部被滤时回退原列表不阻断播放。
- App 改动（重构后足迹）：新增 `lib/utils/codec_capability.dart`（全部判定+查询+选流包装）；`header_control.dart` 两弹窗接线；`controller.dart` 仅 import + 两处调用点。**零改动**：`video_utils.dart`（谓词逻辑移入 codec_capability 包装，放弃非必需的编码池收敛增强）、Android 原生、macOS/Windows Runner。fork 改动：darwin/Windows 显示适配器（`common/darwin/.../MediaKitVideoPlugin.swift`、`windows/media_kit_video_plugin.cc`）。
- 验收：`flutter analyze` 无新增问题；fork `swiftc -parse` 通过。**2026-10-22 21:25**：dev 变体 arm64 release APK（SHA-256 `a613bf9a…58b0`）已装三台在线设备（LG/Redmi Note 5A/marble，`dumpsys com.example.piliplus.dev` 验证 2.1.6）；构建时修复了磁盘清理丢失的 material_ui-1.8.0 pub-cache 补丁链（按 patch.ps1 android 顺序补打 9 个）。**未验证**：实机置灰效果（包已装、未验收）；macOS 构建（磁盘已腾出待复验）；Windows C++。
- 依赖事实：media_kit_video 经根级 `pubspec_overrides.yaml`（path → `../media-kit`）解析；pubspec.yaml 内 git override（bggRGjQaUbCoE ref native）仅在 overrides 移除时生效——该 ref 是否含 `VideoRouteCapabilities` 等导出未确认。构建须用 `~/flutter-sdks/3.47.7`（PATH 3.47.2 与 lock 不符）。
- **2026-10-22 22:00 报障修复**：用户在 Redmi Note 5A 实测"杜比视界/4K 未灰"——根因是**全屏底部条的第二个画质菜单**（`lib/plugin/pl_player/view/view.dart` `BottomControlType.qa` PopupMenu）漏接能力判定（仅有会员置灰）；设备能力数据经 logcat 实证正常（`displayHdrTypes=none` 空集、`hevc4k=false`、`hevcMain10=false`）。已接入 `qualityUnsupportedReason`（enabled=当前项 || 会员可用 && 无置灰原因），重建 APK SHA-256 `fd14d303…f1994` 并装全部 5 台在线设备（LG/Redmi Note 5A/marble/LYA/VKY）。**人工视觉验收待确认**（header 弹窗与全屏 popup 两入口；adb 盲点弹窗未能取得截图证据）。设置页"默认画质"SelectDialog 不支持逐项置灰（共享组件），维持不灰的范围决策。21:28/21:33 另装新上线 LYA `3EP7N18C28016072`、VKY `WJX5T17314001484`（同包验证 2.1.6）。
- **2026-10-22 22:06 二轮报障修复**：用户报"1080P 高码率/高清被误灰"——根因为解码轮照搬了 fork 为 HDR 路由设计的 profile/level/format 严格校验（低端机厂商声明表保守）。修复：`_decodableAtSize` 只按分辨率+帧率（sizeAndRate）+ "有无该编码硬件解码器"置灰，并加 `decode-gray` logcat 诊断。日志实证：1080P 高清恢复可选；4K/AV1/DV 正常灰。**边界待用户定夺**：1080P 高码率在 2:1 片源下是 2160×1080，超设备声明最大宽 1920 仍灰（如实判定）。新包 `ad216857…` 已装 4 台（VKY 离线）。
- **2026-10-22 22:22 尺寸容差（用户拍板）**：解码轮 sizeAndRate 全挂且有该编码硬解的流，÷1.125 尺寸复探（2160×1080→1920×960），过即不灰；无硬解（AV1）或复探仍挂（4K）维持灰。Redmi 日志终验：1080P 高码率 tolerance-ok 恢复可选、4K 全编码与 AV1 全档灰、1080P 高清（1920×960）首轮通过。最终包 `f8447fb1…` 已装 4 台（VKY 离线）；待用户实机视觉复核。
- **2026-10-22 晚 preferCodecs 初始化自动配置（未提交）**：用户先提"过滤后同档按 DASH 倒序取流"，确认后改为**选流逻辑不动（仍按 preferCodecs 排序），应用初始化时自动重写 preferCodecs**——按设备能力过滤后以 DV>HEVC>AV1>AVC 固定序写入。规则：SDR 面板（明确无任何 HDR 能力）排除 DV（DV 只在 HDR 画质档）；Android 解码轮以 1080p30 基准探测排除无硬解的编码族（复用置灰判定 `_decodableAtSize`，PC 不做解码过滤）；查询失败/未知按支持保留；全部被排除不写入。**仅当 preferCodecs 从未设置过时执行一次**（用户手动排序不会被覆盖；初版为每次启动重写，按用户要求改为一次性）；`preferCodecsCellular` 未触碰（未设置时自动跟随）。改动：`codec_capability.dart` 新增 `autoConfigurePreferCodecs`、`main.dart` GStorage.init 后 fire-and-forget 挂接。验收：两文件 analyze 零问题、`video_quality_select_test` 3/3 过；**未实机验证**（各设备实际生成的 preferCodecs 顺序未取证）。
- context：[codec-capability-graying-20261022.md](archives/conversations/codec-capability-graying-20261022.md)

## REPOSITORY-RENAME-20261021

- **done**：旧Goodwu/PiliPlus已改名PiliPlus.old（repo ID R_kgDOVH5pww），原PiliPlus1已改名PiliPlus（R_kgDOVR4zZw），身份核验通过。
- `~/src/PiliPlus` 当前分支 `goodwu-dev-rebased@9c77d6e97`，跟踪新仓 `origin/goodwu-dev-rebased`，ahead/behind=0/0；old remote保留PiliPlus.old，本地feature/ohos保留并跟踪old/feature/ohos。独立迁移克隆remote也已同步更正。
- 用户确认另一个EOF任务暂停后，已快照+stash -u→切分支→stash apply恢复。8个tracked逐字节匹配预计算三方合并，8个untracked SHA256全部保留，无冲突；快照与stash保留，业务修改未commit/push。本轮只验证迁移与改动保全，未重新验收EOF业务。context：[branch-migration-piliplus1.md](archives/conversations/branch-migration-piliplus1.md)。

## BRANCH-MIGRATION-PILIPLUS1-20261021

- **done**：按用户更正，将 `Goodwu/PiliPlus:feature/ohos` 上我们的13个原始提交迁入新分支 `goodwu-dev-rebased`，Rebase 到最新 `Goodwu/PiliPlus1/main`。后续用户授权清理后，已删除内容冗余的 `goodwu-dev` 与 `goodwu-dev-file-migration`，15个旧文件迁移提交已本地bundle备份。
- 临时克隆（已评估可删除，尚未删除）：`/Users/wuweiwei1/src/PiliPlus1-rebase-20261021`；必要备份/映射已校验复制至主工作区`.git/migration-20261021-retained/`；13 个原始提交已 Rebase，候选 `9c77d6e97`；文件树与现有 `goodwu-dev` 完全相同。原两旧分支均为 `fcd719718`，删除前已核实且保存可恢复bundle。
- 验收：历史/文件树独立审核通过；Flutter 12/12、OHOS Python 54/54、Android arm64 Release bundle通过。已仅推新分支 `goodwu-dev-rebased@9c77d6e97`，实时核对 `main@a5665fbe3`、`goodwu-dev`/备份均未动。未重做APK/HAP或设备验收；OHOS既有check-source/CI限制见context。context：[branch-migration-piliplus1.md](archives/conversations/branch-migration-piliplus1.md)。

## PLAYBACK-LOW-FPS-20261021

- **SDR embed恢复已验收 / 按授权本地提交归档，不推送**：库legacy桥接恢复SDK既有默认SDR mediacodec_embed直出，App代码零新增。旧挂载互等/idle post-frame饥饿的基线修复已补因果回归并在实机绑定闭环确认；同时修PQ→SDR诊断三字段残留。最终1084+8skip/App16/V2通过；最终源码包241aabdf已装LG，原片真实4K AVC native约30fps；最终包冷启动/真实退出重进/明确DV-PQ与SDR往返通过，绑定132–261ms。暂停继续/EOF重播/HOME重建在前一候选验证，未计作最终包重测。最终4K AVC全屏留场；无新增超时规避/机型分支，原有OOM未宣告根治，GL与其它设备边界不扩大。context沿用下方。

- **2026-10-21 再诊断（未改实现）**：当前4K SDR稳定呈现约8–9fps，VTS44–45°C、GPU上限214MHz/大核979MHz，明确热限频；缺少PQ层对SDR正常，不能作错误路由依据。追溯发现库已有SDR AVC mediacodec_embed→SurfaceView优化（旧LG受控约30fps），当前legacy桥接显式sdrEmbed:false禁用了它；false源自26a2c2c6的outputBind挂起规避，并非新生命周期迁移引入。下一步若恢复该路由须复核输出绑定与生命周期，当前只读定位、无实现变更。context沿用下方。

- **migrated / 生产候选已装LG，按授权本地提交归档，不推送**：对齐已验收基线后将完整fallback/实例生命周期迁入media-kit，App净减202行，保留业务请求与仅SDR兜底授权。43定向、库1081+8skip/App16全量、V2通过；源码包284acf6c已装，原片PQ硬解/format43/30.02及29.91fps。探针同进程SDR fallback→refresh（rate1.25/volume65）及→新HDR源通过；HDR异常拒绝降SDR成立，但随后切页复现既有Flutter位图OOM，此恢复场景未通过，不声称全实机验收完成。context沿用下方。

- **fixed / 候选已装LG，未提交**：fallback限定当前request；下一次切源/refresh在owner slot内退休legacy并重试routed，refresh保留rate/volume。8定向/20全量/analyze/V2通过；一次性故障注入实机验证同进程fallback→refresh及fallback→新源均恢复PQ。撤掉注入后源码重建APK `b15dcd1b...`已装，原片PQ verified、SF format43、29.91fps，零FATAL/回退。初始异常及独立位图OOM仍未闭合。context：[playback-low-fps-20261021.md](archives/conversations/playback-low-fps-20261021.md)。

## ANDROID-LOCAL-MEDIA-KIT-20261020（本地 media-kit 构建与路由播放主线）

- **2026-10-22 勘误+LG 覆盖确认:此前"测试链 libmpv android26 编译在 API24 不可加载"结论错误**——LG 上 dlopen 失败真因是缺 libc++_shared.so。实测:mks 链 libmpv(android26-clang 编译,未 vkweak)在 LG API24 上 **dlopen 成功且 native check 三 CLI 582/0 全绿**;APK minSdk=24 可直接安装。两链(发布/测试)其实同为 android26 crossfile 编译,差别仅是发布 JAR 额外做了 vkweak(弱化 vkGetPhysicalDeviceProperties2/QueueFamilyProperties2 两个 Vulkan 1.1 导入)——而当前 mks 库根本不导入这两个符号,故无需弱化。r23 已装 LG:应用启动、视频页打开、**首帧解码渲染成功**,但播放未推进(media session state=0、帧间差 0)——LG 播放行为属该机既有专项边界(挂载门/embed 载体历史),不在本次"测试链覆盖"范围。LG native check 现场保留在 /data/local/tmp/pnp(含 libc++_shared)。

- 2026-10-21 **所有权管理下沉完成，LG短测及15min恢复通过，按授权提交推送**：用户授权将播放器替换串行队列、旧 owner 清理重试迁至 media-kit 的显式共享实例；App 保留页面/源请求/业务判断并精简辅助包装。App净减79行；slot10/App2定向、App14/库1048+8skip全量、V2及源码构建通过，新包6155accc LG切页/快速返回/EOF重播20s/EOF拖动/暂停拖动/HDR-SDR/退出重进通过；Home仍有20秒恢复迟滞。用户改为15min，实际939.565秒同源零输入静置后单次重播20s及再次EOF直接拖动通过；不声称本轮30min覆盖，系统媒体位置基准同步缺口单列。本次提交正式修复和验收记录，临时transport诊断及独立仓迁移/配置改动排除。context：[`playback-eof-replay-20261021.md`](archives/conversations/playback-eof-replay-20261021.md)。

- 2026-10-21 **重播/切页恢复短测通过，31min静置后恢复未验证，未提交**：两类本轮HDR接入回归已修正：隐藏页挂载/旧请求fallback竞争、raw重播与routed seek意图失配；另以真实completed保存状态修正返回末帧不能重播边界，不扩大50ms判断。第三源码包完成单次重播20s、普通近尾paused返回、Home迟滞自动恢复；第二包EOF直接拖/主动暂停拖/SDR-HDR通过。库focused59/59、全量1038/8，Apphelper6/6、V2通过。gen6真EOF完成1876.879秒零输入/源变化静置；首次点空白处控件未显示，未点play/seek，保留现场，不能记长时重播通过。计时前极近尾seek缓冲及未明refresh单独保留。context：[`playback-eof-replay-20261021.md`](archives/conversations/playback-eof-replay-20261021.md)。

- 2026-10-21 **HDR提亮验收通过，本地提交归档**：取消PiliPlusX对比，media-kit侧保守gamma候选，保持peak1000；定向23项/全量1031通过8跳过、V1通过；源码包已装LG，HDR→SDR→HDR applied通过；用户确认“亮度合适，高光正常”，面板验收通过；确认时最终背光未另采样。用户现授权本地提交已验收修复及记录：media-kit `98c611a3`，本仓仅相关记录。不推送，临时EOF诊断不提交。context：[`video-gray-getx-20261021.md`](archives/conversations/video-gray-getx-20261021.md) 顶部Current State。

- 本次按用户授权分别本地提交：配套 `mpv@1af17925fb`、`media-kit@917405a7`；App保留修复与本任务/验收记录随当前提交归档。不推送，不含环境配置。

- 2026-10-21（三）**灰屏根因修复、跨仓回退与上游同步精简已完成（本地提交归档，不推送）**：真实灰层为字幕Obx异常的Release ErrorWidget，原修复版用户确认画面及控件正常。最终App业务差异只剩两个文件（8新增/4删除）；vendor依赖已迁到media-kit；mpv只保留有效占位初始化；SDK项目补丁保留。最终源码1023测试通过/8跳过，精简包已装LG，HDR/SDR/重进真实复核通过；末版用户已明确确认“画面和控件都正常”，本次灰屏修复与精简验收完成。详见 [`archives/conversations/video-gray-getx-20261021.md`](archives/conversations/video-gray-getx-20261021.md) 与 [`docs/plans/video-gray-cleanup-audit-20261021.md`](docs/plans/video-gray-cleanup-audit-20261021.md)。以下旧透明洞根因和实验结论仅作历史，已被本条更正。
- 2026-10-21（三）**历史实验结论（已证伪，非当前状态）：曾归因为 API24 透明洞，修复候选未验收**。现状：**未完成验收**。LG 设备 `LGH870DS42e27764` 本轮末从 USB 消失（`adb devices` 空、USB 树无 LGE 项），装机与面板验收阻塞。
  - **根因（实测闭合，非推断）**：PiliPlus 的 Flutter 平台视图容器 `fr`（FlutterView）比 PiliPlusX 多一个 **`PlatformOverlayView`（obfuscated `ba0`）**，与视频矩形完全重合且排在视频 `FlutterMutatorView`（`nq`）之后。API24 AOSP `ViewGroup.gatherTransparentRegion` 按子节点顺序走：绘制型 View 用 `DIFFERENCE` 扣掉自身矩形，SurfaceView 用 `UNION` 加回；该 overlay 在视频 SurfaceView 的 `UNION` 之后扣掉视频矩形 → 窗口 `transparentRegion` 变空 → 应用窗口表面在视频矩形保持不透明 → 均匀 (181,181,181)。PiliPlusX 无此 overlay → `transparentRegion=[0,141,1440,861]` → 画面正常。层级身份经 DEX 结构 + 运行时 `instanceof PlatformOverlayView` 双证（`eq`=`FlutterImageView` 根图，`ba0`=`PlatformOverlayView`）。
  - **判别实验（每个都装机实测，APK 内 libmpv 恒 `fbe0bc8b`）**：①对 overlay `setWillNotDraw(true)` → `transparentRegion` 恢复视频矩形、采样 (0,0,0)，机制成立；②对 overlay `setAlpha(0f)`（不画但仍参与扣减）→ **仍然灰、region 仍空** ⇒ 成因是**空透明区**，不是 overlay 的像素内容；③把 overlay 移到 `nq` 之前（preDraw 持续纠正）→ region 正确、视频可见，但**控件不可见**（`SurfaceView.draw`/`dispatchDraw` 恒对自身矩形 `CLEAR`，先画的都被擦掉），且**退出再进复现灰**；④移除 media-kit 两处 Flutter 覆盖层（ready/visible cover）→ overlay 照旧创建、仍灰 ⇒ **此前"cover 触发 overlay"假设已证伪**；⑤去掉 `SimpleVideo` 外层 Stack → overlay 照旧创建 ⇒ Stack 不是触发条件。PiliPlusX 点击后视频矩形出现 15 种颜色 ⇒ 参考实现的控件确实画在视频之上（由全屏 `FlutterImageView` 承担，其扣减发生在视频 `UNION` 之前故洞存活）。
  - **结构约束（为什么简单改法都不行）**：`SurfaceView` 始终 `CLEAR` 自身矩形 ⇒ 画在它之前的被擦除；画在它之后的必然扣减透明区。API24 下"视频上方有窗口内容 + 窗口挖洞"不能靠常规 View 顺序共存。
  - **修复候选（已构建，未装机）**：media-kit `PlatformVideoView.java` 新增 `TransparentRegionRestorer` —— 不绘制（`setWillNotDraw(true)`）的 View，覆写 `gatherTransparentRegion` 把视频矩形 `UNION` 回去，插到 FlutterView 中 overlay 之后并用 `OnPreDrawListener` 持续保持最后。预期同时满足：洞恢复 + overlay 仍绘制控件。构建 `BUILD_EXIT=0`（Gradle 57.5s），随后 adb 安装时设备消失。
  - **测试/静态**：`flutter test test/routed_simple_video_test.dart test/piliplus_view_compat_test.dart` → 8/8 通过；两文件 `dart analyze` 仅 2 条既有 warning（`unnecessary_non_null_assertion`、`unnecessary_import`）。
  - **更正（撤回前文错误结论）**：①此前断言 `eq`=`PlatformOverlayView` 错误，`eq` 为 `FlutterImageView`、`ba0` 才是 `PlatformOverlayView`；②此前"根因已确定=Flutter cover"错误，cover 与 overlay 创建无关；③`transparentRegion` 不是"逐像素 alpha 证据"，但①/②实验证明它在本机型上确实是成因环节。
  - **工作区（未提交）**：media-kit Dart `routed_simple_video.dart`（ready cover 已删，待定稿）、`simple_video.dart`（cover 改为 `!visible && !platformSurface && !platformOutput`，并实验性去掉无 cover 时的 Stack）；media-kit Java `PlatformVideoView.java`（`diagRelaxOverlaySiblings()` 诊断 + `TransparentRegionRestorer`，交付前须清理）；mpv 工作区补丁已备份到 scratchpad（`mpv-context_android-working.patch`、`context_android.c.working-backup`）。保留项未动：viewport、pending-open 稳定性、HC 入口、`target-peak=1000`。
  - **下一步（设备恢复后）**：装机 → 校验 `transparentRegion=[0,141,1440,861]` → 面板确认"视频正常 + 控件可见可点" → 退出重进一次确认不复发 → BV1uZ4y1U7h8 / BV1T7t96BECu 回归 + 零 ANR/FATAL。证据：scratchpad `x4..x8*.png/sf/vh/logcat`、`arm-X2-*`、`arm-X3-*`。
- 2026-10-20（一）**零改动 Android 构建链跑通 + brightness 供给修复**：PiliPlus 源码/pubspec 零改动，经根级 `pubspec_overrides.yaml`（全量 path 指向 `../media-kit`，保留 inappwebview 两条 git override，`media_kit_native_event_loop` 无本地包且无代码引用可安全移除）构建 Android arm64。compat 分支 direction B 兼容层实测消除 lib/ 全部 156 个 API 错误；`flutter test` 通过；analyze 剩余错误全在 `tool/ohos/`（Android 不编译）。装机后「手势调亮度数字变但亮度不变」根因＝PiliPlus 直依赖 `screen_brightness_platform_interface`，原生实现历来由旧 media_kit_video fork（bggRGjQaUbCoE native）依赖声明带入，本地库缺该声明→插件从 GeneratedPluginRegistrant 消失；修复在 media-kit 侧 `media_kit_video/pubspec.yaml`（f61311fc），App 零改动。
- 2026-10-20（二）**路由验收定位门死锁与丢帧根因**：零改动路径不走路由（legacy 默认 texture），LYA 播 BV1vY4y1N7TY（4K DV）SF 层实测 **15.3fps**（中位 65.4ms、64/126 间隔>2 vsync＝丢半帧），根因＝copy+gpu-next DV→SDR 色调映射+4K 纹理上传链。显式 `RoutedVideoPlayback` 接线后复核门确定性拒绝（iter=7 endpoint-changed，direct 与 copy 候选同拒）；LG 另有 outputBindTimeout（挂载门环）与 SDK16-25 默认 embed 载体挂死。EDL 双流源规划时事实全空（source=none class=sdr）。证据 `/tmp/pili-verify-20261020/`。
- 2026-10-20（三）**接线落地 + 自动播放修复 + 三机路由验收全绿**（App `a01f8ff53` + media-kit `26a2c2c6`）：播放器接 `RoutedVideoPlayback/RoutedSimpleVideo`（transport 走 binding、属性/订阅留原 player、`onlyPlayAudio` 传 `video:false`、open 被拒时 `_switchToLegacyOutput` 回退兜底）；修复两处视图侧死锁——页面挂载门 `videoController==null` 改为 `videoController==null && playback==null`（会话控制器在 open 期间才出现，Obx 只对 Rx 响应），`RoutedSimpleVideo` 空控制器占位是 1px 盒需 `aspectRatio: videoFit.aspectRatio ?? 16/9` 兜底；字幕改跟随 `playback.controller` listenable。`autoPlayEnable` 默认改 **true**（用户目标；旧行为＝深链不播、单击只切控制条、需拖推荐栏才触发）。终版实测（深链+自动播放零手工干预）：LYA review×2 success→dvP84 事实→toneMapSdr→applied，**30.6fps**（中位 32.7ms、5/126 超限）；LG review×2 success→applied（OMX.qcom HEVC 硬解），**30.4fps**；marble（displayHdrTypes=1,2,3,4 全能力）applied+播放推进；三机零 ANR/FATAL。
- 关键机理（写入 media-kit 侧但 App 验收依赖）：hisi/qcom 直连 attach 本可成功，旧复核门飞行中采样-重建风暴才是端点翻覆元凶；media-kit 已改静止后单采样+复核超时候选回退，legacy 桥 require(sdr)+sdrEmbed:false。App 侧不得再自造 preferCopy/回退优先级——候选序交给规划器。

### 构建手册（复现）
### 2026-10-20（二）晚 HDR 点亮轮（matched full 配对 + Z 序修复 + 契约写入，接路由验收三）

- 2026-10-20（二）晚 **HDR 链路实机点亮 + 灰蒙根因闭环 + 剩余四项记录**（全部 media-kit 侧，App 零代码改动，仅构建 define）：BV1vY4y1N7TY 实测 `phase=applied selected=baseLayerConvert presentation=nativeHdr vo=gpu-next hwdec=surfacetexture output=pq` **零降级零回退**、lg-pq dataspace applied、MKSURF latch 30fps 连续（4179 帧 733→844s 实时推进）、playing=true position 推进、零 ANR/FATAL——**面板 HDR 输出端到端点亮**（screencap 对 PQ 层只能拍均匀灰=采集盲区，面板观感待人眼最终确认）。
- 三因子修复（均 media-kit 侧，详见 `../media-kit/archives/conversations/piliplus-lg-hdr-lit-handoff-20261020.md`）：
  ①**双 SurfaceView Z 序竞态**——fork 的 PlatformVideoView（offscreen swapchain + final-pass vendor 窗口）attach 顺序竞态让 offscreen（uniform PQ 灰）盖住 YUV 窗口=灰盖视频/全屏灰条；修复=final-pass（rgba1010102 格式）`setZOrderOnTop` 钉图层栈最顶 + offscreen 保持 media overlay（PlatformVideoView.java）。
  ②**HLG→PQ 转换缺失**——契约写入从未下发 `target-trc`，HLG 数值被 PQ 容器按绝对亮度解释=亮部约 2 倍过曝；修复=契约写入补 `target-trc=pq`（hdr_player_backend.dart，同块）。
  ③**full/limited 标签错配**——`surfaceTransfer='pq'`（FULL 标签）配 route 契约 full 电平=matched full 配对（euv13/euv17 已验证接受的组合），实机确认"过曝轻一些"。
- **videoState 循环等待门修复**（pages/video/view.dart）：页面要求 open 完成才挂播放器，平台视图 open 又要视图先挂载=循环等待；修复=routed 会话存在（playback!=null）即挂载，不等 videoState（RoutedSimpleVideo 自带 ready 遮罩）。
- **sessionReady 门控**（pl_player/controller.dart `panelHdrCapable`）：仅当 `displayHdrTypes 非空 && (sdkInt>=28 || ext.applicable && ext.validatedPredictionTransfers 非空)` 才进会话；lg-pq 已声明 `validated={pq}`（vendor 插件 Java 覆写，实测注释指向本轮）→ LG `sessionReady=true` 门控放行；API≥28 设备照常。
- **遗留四项**（全 media-kit 侧或 App 一处小改，详见 media-kit 侧 handoff 文档）：
  ①~~亮部残余过曝~~——**已验证有效并保留**：契约写入追加 `target-peak=1000`（HLG 参考峰值，`HdrYuvPresentationContract.targetPeak`，owned 写入/回读/恢复，契约测试钉住）；用户确认「亮度现在可接受」；
  ②**出视频前灰屏 + 全屏灰条——未修复**：实际是 Flutter 应用表面没有为平台视图挖透明洞（`transparentRegion` 为空），页面背景盖住视频；PiliPlusX 同路由同设备洞正常。本轮尝试的 FBO 清黑、not-ready 黑帧、`clearSurfaceBlack`、HdrVideo/无 FittedBox、viewport、TLHC 入口、Z 序/可见性回退、Flutter 3.47.2 降级均**未生效**，已回退。完整证据、对照与待查假设见 `docs/plans/lg-hdr-gray-cover-investigation-20261020.md`；
  ③播放控件被 ON-TOP 视频盖住（可点击不可见）——已知兜底 `setZOrderOnTop` 能恢复画面但会盖住控件；用户要求保留控件，暂不采用；
  ④滑动时 final-pass 重建空隙短暂蓝屏——偶发，未专项定位。
- **后续轮实机（2026-10-20 晚）**：target-peak 版实测 BV1vY4y1N7TY / BV1uZ4y1U7h8 均 `phase=applied nativeHdr/surfacetexture/pq` 零降级，SDR BV1T7 正常，三样片零 ANR/FATAL；亮度用户确认可接受。灰屏仍在（见上）。最后一版验证 APK 是临时 3.47.2 构建；源码已恢复 3.47.7，需重新构建/安装。证据 `/tmp/hdr-targetpeak-run.log`、`/tmp/sf-*.txt`。
- **验收记录**：BV1T7（SDR）全彩播放 motion 47；BV1vY4y1N7TY（4K DV）applied 零降级 sat 58→蓝屏闪后 legacy 回退色彩正常；BV1uZ/BV1W（DV）applied 零降级 sat 127/125；四样片零 ANR/FATAL。证据 `/tmp/pili-yuv/`（yuv8-19、vfinal-*、fin2/fin3-*、confirm、itu-*）。
- **依赖变化**：pubspec.yaml 新增 `media_kit_android_dataspace_vendor: 1.0.0`（vendor 插件入包，ext=lg-pq 注册的前提）；flutter 约束曾临时放宽 pub get 后已恢复 3.47.7 钉值。


```bash
export PATH=~/flutter-sdks/3.47.7/bin:$PATH          # 独立 SDK（pubspec 精确钉 3.47.7；全局 3.47.2 不可用）
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
cd ~/src/PiliPlus
flutter pub get                                       # 首次或 media-kit 依赖变化后
flutter build apk --release --split-per-abi --target-platform android-arm64 \
  --android-project-arg dev=1 --no-pub                # dev 变体＝debug 签名+.dev 包名后缀
adb -s <serial> install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

前置一次性：Flutter SDK 补丁链（等效 `lib/scripts/patch.ps1 android`，bash 版）——SDK 25 补丁（modal_barrier…double_tap_gesture + bottom_sheet_android/scroll_view/navigator）打在 `~/flutter-sdks/3.47.7`，material_ui 9 补丁打在 `~/.pub-cache/hosted/pub.dev/material_ui-*`（删缓存重新 pub get 后打）。残留 Gradle daemon 锁 `journal-1` 时 `cd android && ./gradlew --stop`。

### 设备与取证经验

- 三机 serial：LG `LGH870DS42e27764`（API24，lucye）、LYA `3EP7N18C28016072`（API29，hisi）、marble `dede0cd2`（API35，HyperOS）。
- 帧率证据用 `dumpsys SurfaceFlinger --latency`：华为层名带空格 `SurfaceView - pkg/act#0`，LG（Nougat）不带 `#0`；先 `--latency-clear` 再采样；截图像素差不可作帧推进判据（多次 0% 假阴性）。
- LG 的 uiautomator dump 无输出、交互 shell logcat 为空：一律 `adb exec-out`；进度判据用 uiautomator（LYA/marble 可用）读 `N%, 进度条`。
- 长构建期间设备会自动锁屏：每轮先 `input keyevent KEYCODE_WAKEUP` + 上滑解锁，再 force-stop+深链。
- marble USB 安装被「应用安装拦截」需机主放开开发者选项，不绕过；同包名升级安装不触发拦截。
- 深链验收 URL：`https://www.bilibili.com/video/BV1vY4y1N7TY`（4K DV 样片）/ `BV1T7t96BECu`（SDR 复入片）。
- 路由证据通道：`lib/main.dart` 的 `HdrOutputDiagnostics.enabled = true`（HdrDiag 行；`routed error:`/`routed open failed,` 标记为 App 侧回退路径指示）。

### 开放项

- [ ] 发布前移除 `lib/main.dart` 的 HdrDiag 诊断行（或改 kDebugMode 门控）。
- [ ] media-kit 侧不变量 3（唯一重开权威）落地后评估删除 App 侧 `_switchToLegacyOutput` 回退。
- [ ] media-kit DV nativeHdr 实现段在 LYA 静默停滞待查——legacy 桥已 require(sdr) 规避，显式 HDR 接入前不解锁。
- [ ] marble 帧率未量化（本轮只验 applied+进度+零崩溃）。
- [ ] media-kit 本地提交（f61311fc/4df7755e/26a2c2c6 等）与 App `a01f8ff53` 均未推送，推送需用户确认。
- [ ] `pubspec.lock`/`pubspec_overrides.yaml` 已随 `a01f8ff53` 提交在 `feature/ohos`；该分支不受每日镜像影响，合回 main 前须评估镜像语义。
- [ ] HDR 点亮轮遗留（2026-10-20 晚）：亮部残余过曝（target-peak=1000 A/B，media-kit 侧）；出视频前短暂灰屏+pillarbox 灰条（vendor native clearSurfaceBlack，media-kit 侧）；播放控件被 ON-TOP 视频盖住（App 侧控件迁移平台视图或维持现状）；滑动蓝屏观察。详见 `../media-kit/archives/conversations/piliplus-lg-hdr-lit-handoff-20261020.md`。
- [ ] 本轮 App 侧变更（pages/video/view.dart playerReady 门、pl_player controller 门控+看门狗+liveness、pubspec vendor 依赖）未 commit；`.gitignore`/`.commandcode/`/AGENTS 等非本轮产物未动。

## 接手入口

- 播放器接线：`lib/plugin/pl_player/controller.dart`（`_initPlayer`/`_createVideoController`/`_switchToLegacyOutput`）、`lib/plugin/pl_player/view/view.dart`（RoutedSimpleVideo/字幕）、`lib/pages/video/view.dart`（挂载门）。
- 依赖接线：`pubspec_overrides.yaml`；构建输入变化后重跑 pub get。
- media-kit 侧对应任务/设计：`../media-kit/TASKS.md` MK-ROUTING 段、`../media-kit/docs/plans/review-gate-invariants-auto-routing-20261020.md`。
- 本轮证据：`/tmp/pili-verify-20261020/`（lya-final/lg-final/marble-final 含 HdrDiag 全序列与 SF 帧率）。

## MARBLE-DV-ASPECT-RATIO-20261022

- **真实 HDR/DV 比例实机验收通过**：用户更正此前结果来自 SDR后撤回；本次在 marble 安装的当前源码 Release dev APK 上，播放 DJI Air 3 杜比视界源，MediaMetrics 确认 `mime=video/dolby-vision` 且解码器为 `c2.dolby.decoder.hevc`。同一播放会话反复切换比例：4:3 原生视口 `[480,0][1920,1080]`（1440×1080），16:9 原生视口 `[240,0][2160,1080]`（1920×1080），返回4:3再次得到1440×1080；切换截图 `/tmp/pili-marble-aspect-hdr/land-controls-visible.png`（4:3）与 `/tmp/pili-marble-aspect-hdr/after-169.png`（16:9），独立视觉复核确认可见宽高与黑边变化。两张截图来自播放中不同时间点，原生视口尺寸及所选比例状态为主要几何证据。根因是 media-kit 旧布局只覆盖 `gpu-next`，未覆盖 marble DV 的 `mediacodec_embed`；现已统一让 Android PlatformView 按当前 fit/layout 更新原生边界，保留 gpu-next 专属输出缓冲策略。布局回归9/9、目标 analyze、V1复核通过。临时设备全屏已用返回键退出，自动旋转仍为开启、用户旋转为0、window rotation mode为free。此前 failed Debug build 清理与 Release source build 记录见 context；media-kit `real.dart` 及原有 dirty work 保留。context：[marble-dv-aspect-ratio-20261022.md](archives/conversations/marble-dv-aspect-ratio-20261022.md)。
- **自动画幅回到原始比例修复并实机确认**：media-kit 的 `VideoViewParameters.copyWith` 与 Android/Web `VideoState.update` 现区分“未传 aspectRatio”（保留）和显式 `null`（清除），因此先选4:3或16:9后选自动会回到原始比例；数值参数仍兼容整数并归一化为 double。当前源码 Release APK 已装 marble，播放 DJI Air 3 Dolby Vision 时 MediaMetrics 仍显示 `c2.dolby.decoder.hevc`；用户手工确认“没有问题”。V1 复核最终差异通过。APK、截图及完整验收上下文见上方 context。

## VIDEO-STARTUP-LATENCY-20261022

- **Round 7 收尾(2026-10-22 晚):按用户授权 revert 临时诊断(codec-stats vd_lavc +168、App STARTUPTRACE 四文件)并分批本地提交(不推送)。** 提交分组:media-kit ①公共功能件(probe owner/open coordinator/DV policy/batch ABI/legacy options)②今日延迟改动(hint plumbing+dispose 宽限期剥离);mpv 单批(pending-proof 基线+关键帧起播三件套+eager seek+refresh 门控);PiliPlus 单批(API hint 推导+携带+注册表+本归档)。revert 后验证:App analyze/4测试过、mpv 重编+native check 582/0×6轮。r22(含诊断)为当前装机,r23 源码态=提交态。效果汇总:切换点击→启动 4.3s→0.2s(dispose宽限期);续播 10s→4.5-6s(关键帧起播);首开 probe+promotion 跳过(API hint);后续:统一启动定位编排(规范在案)。

- **Round 6 旧播放器退役延迟已解决(r22 最终版在装,V2 PASS+P2/P3 已处置):DV 切换点击→open_submit 从 4.3-4.6s 降至 0.16-0.27s,点击→首帧 2.37-2.71s(5 次实机切换)。** 定位链(r17t-r19t 三轮插桩):切换时 `_managedPlayback.ensure()` 退役旧 owner,其中 transport/session dispose 仅 0-150ms,**元凶=media_kit `Player.dispose()` 内硬编码 `await Future.delayed(5s)`(mpv_terminate_destroy 前的"grace period"),player_dispose_done 实测 +5110~5174ms 恒定**。修复:宽限期+native 销毁剥离为分离任务,dispose() 在 super.dispose() 后即完成;新增 `nativeDestructionComplete` getter 供需观察完整销毁者等待。managed/routed 44/44 通过;player_test/wakeup 测试加载失败为既有 NativePlayer 命名冲突(与本改动无关)。V2 PASS:P2(native销毁错误零观察者)已修(print sink 挂分离future)、P3(getter足枪)已文档化;P3-c(进程退出窗口泄漏面)记录在案待消费方决策。MKRETIRE 打点已清理;App 侧 STARTUPTRACE 临时打点保留至延迟专项收尾。剩余切换延迟=库相位(2.4-2.7s,归下一轮统一启动定位编排)。context 同上;证据 /tmp/pili-startup-r3/usertrace{,2,3,4}.log。

- **Round 5 关键帧起播收官(V2 全项处置,r16 在装):续播 ~10s→4.5-6.3s(网络窗口相关;当前晚间降级蜂窝 6.1-6.3s,午后窗口同级代码 4.5-5.3s),首帧落点 80.101(回看~4.9s=1 GOP,P2-1 随 P1 修复顺带解决),播放推进与 A/V 正常;暖首开回归 1.55/1.75s✓;native 582/0×5轮。V2 结论全处置:P1(vo_has_frame 每次seek重置致交互seek误判)已修——startup 判定追加 `!hrseek_active`;P2-2(refresh门误伤播放中切轨)已修——限定 `!ds->has_returned_packet` 启动期;P2-1 已如上消解;P3(switch_segment 偏离/mkv字幕预卷/warm探测fallback)记录在案接受。APK `pili-startup-r16`。** mpv 三项生效改动:①mp_seek 启动关键帧规则(当前条目未渲染过帧时 DEFAULT 精度绝对 seek 不升 HR;EXACT/播后交互 seek 不受影响)②switch_segment 去除无条件 SEEK_HR(EDL 时间轴曾把任何 seek 强制精确)③timeline demuxer 跳过顶层 refresh seek(refresh_skip_timeline,防 audio 选轨刷新把整条时间轴拖回一个 GOP)。实测落点:target85 → 双流联合落在 75.096(**audio 关键帧 ~10s 粒度主导**;video GOP 实为 5s,80.101 关键帧存在)。已回退:coarse_slave_align 反向对齐块(d_seek 时序下永不触发,死代码清除)。剩余 ~2.5-3s 分解(插桩实测):app 0.9 + video 85→80.101 两跳 RTT(~0.5s)+ audio 稀疏关键帧引发的 cache/range HR seek 链(~0.6s)+ 第二次 mp_seek(80.1,来源待查)+ 最终 75.096 对齐跳(~0.35s)+ 首GOP切片+解码。**下一轮规范(设计已定)**:统一启动定位编排——video 关键帧落地(大负载)、audio 用 HR 便宜追赶(audio 帧~150KB/10s,decode-through 无痛),一次性双流对齐,消灭 6 次串行 seek 到 ≤3 次;预期续播 ~2s@蜂窝/更好@WiFi。证据:/tmp/pili-startup-r3/r9-r15*.log。APK pili-startup-r15。

- **Round 4 蜂窝流量实测(r8,用户关WiFi用流量,3.6→2.7MB/s 窗口):暖进程首开≈达标、冷深链差0.4-0.8s,目标仍未全量稳定<2s。** 计时法:亮度突变锚+录像帧分析+MediaCodec render 交叉验证(冷启动进程全新、render 行无污染,与光学吻合 c1=2.38/2.42s)。**暖开×5:1.13s✓(视觉证实)、0.96s✓(证实)、1.03s、1.84s、1 例蜂窝卡顿>15s**;**冷开×5(render 口径):2.42/2.57/2.59/2.60/2.82s**(聚齐,均值~2.6s)。冷相位分解:进程+引擎 0.34-0.42s(不可压)+ 引擎后 0.70-1.05s(view API→playurl API 两跳串行 RTT+页面构建,可压)+ 库 ~1.2-1.4s(children HTTP 双握手+seek+首GOP+解码,hint 已跳 probe)。WiFi 真因澄清:lixiang-guest 访客网带宽随时段塌缩(Cloudflare 全主机同慢),非 CDN;误切 lixiang-public(无外网)已恢复。**剩余两杠杆(下一轮)**:①playurl 链路提前(view API 在路由解析即发,~0.1-0.2s)②mpv EDL 双 child 并行 open(~0.2s)——冷开可压至 ~2.0-2.3s@3MB/s、~1.85s@6MB/s;DASH host 并行 curl 因需鉴权未测,续播 GOP 网络墙方案(并行连接预取)仍待立项数据。r8 仍在装。证据:/tmp/pili-startup-r3/g55-*.{log,mp4} 与 v3-*.png。

- **Round 3 实测收官(未稳定达标,数据与归因齐备):marble 回连后完成冷却基线/curl/hint路由修复/r8 六组光学与日志计时。** 验收口径"任意视频首次打开"点击→第一帧<2s。实测(r8,当晚 CDN 谷底 0.56MB/s,比早晨慢10×):**暖进程切换首开 2/4 样本 <2s(o3 光学 1.50s 有录像与逐格判读、w1 日志 1.96s;另 o2=2.25s、w2=3.16s)**;冷深链首开 3.7-5.9s(进程启动+1s);t=85 DV 续播 ~10s(网络墙,单连接 558KB/s 时 25MB GOP 不可能<2s)。冷却基线证明热降频非变量(冷却后 9.5s 与热态同量级,差异全在网络时段)。**修复链**:r4 hint 缺 primaries→路由劣化 metadataReshape(experimental);r5 补 bt.2020 仍拒(缺 enhancementLayer);r6 补 EL=false → 首plan即 nativeDolbyVision(hint直开生效,probe/pending-proof 链整体跳过);r7/r8 增加 AVC(codecid7,非DV档)恒SDR 推导(矛盾元数据保守不推导),SDR 首开也跳过 probe。4/4 单测。curl:mp4 镜像单连接 558KB/s、并行 4 路中 2 路被压到 3KB/s(该镜像并行收益不明确,真实 DASH host+好时段需复测)。**下一步**:①并行连接预取立项(预设计已归档)②正常网络时段复测暖/冷首开×N 求<2s稳定③t=85 续播<2s 依赖①。产物:pili-startup-r8 `725c1084…`;证据 /tmp/pili-startup-r3/(六组 log+录像+接触表)与 /tmp/pili-startup-ugg/。context:[video-startup-latency-20261022.md](archives/conversations/video-startup-latency-20261022.md)。
- **Round 3 前史(实现与验证):**验收口径已确认为"任意视频首次打开"点击链接→第一帧<2s;真瓶颈定位为网络供数据墙,变体A(eager seek+F2)已实现过V2与native全量,另新增 playurl API 推导 hint(任意视频首次打开跳过 probe+promotion≈0.7s,仅 DV 稳判:qn126+codecid12→hevc P8.4,误判=一次修正重建,3/3 单测),装测等 marble 回连。** 用户体感~5s与实测吻合:同一视频同一起播点 first packet→correct frame 旧测1.31s/热轮4.09s,decode-through 是网络 bound 的 GOP 追赶下载(~20-25MB);旧"2.290s基线"只是网络好时同场景。Round 3 已做:mpv `demux_timeline.c` eager startup seek(未选轨 d_seek 内立即 child 定位,网络 range 重开与 discovery/promotion 并行)+ 同位置 re-arm 跳过(F2)+V2 两轮(P1 eager状态首读失效/P2定位失败不标记done/P3 pending-else清状态,均已修);包队列预取变体因 child 级 select/读状态污染 refresh-seek/proof 语义(变体B 14项断言失败)回退,待专项设计。native check 在 Redmi Note 5A(API37,marble 掉线期间)582/0、帧断言37/37、eager 路径44次踩到。APK:`pili-startup-r3` `9831fab4…`(无API hint)已被 `pili-startup-r4` `8962c52b…`(含API hint+变体A,trace define)取代,验收脚本已改用 r4。待 marble 回连:冷却基线复测(r2t,t=85,分离热/网络变量)+curl 单/并行速率,装 r3 测 t=85 续播与 t=0 首播光学计时。预估:6MB/s 网络 t=85 仍~5.4-5.8s(网络墙),20MB/s ~2.5-2.9s 冷;t=0 首播预期~1.5-2s。Round 2(L3a prefetch 激活+L1 hint 布线)已过 V2,L1 不适用首次打开场景但保留。context:[video-startup-latency-20261022.md](archives/conversations/video-startup-latency-20261022.md)。
- **点击至实际运动视频仍未稳定低于2秒。** Pending-proof三文件（含cover history修正）V2通过，APK `/tmp/pili-startup-goal/pending-proof-04d2f249.apk` SHA `04d2f2492ad22966f1e3943885c8993ad440f2d009b59868927db2a0061f9e9e`，native `1026aaef1f07d2c15048d5fbf806237a3befb063e115d8bf49ae7b59888e5fe5`，JAR `0f2f91c57c07f0b3b85a3ab9da2862d38987cda3f82a6e60ae9cef53081180ab`，核验通过，SDK默认128KiB。Native专项582 checks/0 fail，37 target/cover断言全过，25 proof-use全守guard；JPEG cover历史负例通过，PNG环境缺decoder，cache-range-join和stale-callback race未验证，2 flush仅观察。`proof-clock1` down epoch1792619211.162→正确帧f124 epoch1792619213.452=2.290s、motion2.459s；use1重复刷新消失，但目标仍超时。随后codec-stats诊断APK `5734f95a…` 已核验安装且当前设备运行此版；reset85从library start到正确帧2.173s，first packet→correct1.312s，单轮API统计约79%后段时间。~~下一步只读评估有界video预取/FFmpeg标准重建可行性~~（已由 Round 2 完成）；lazyTexture约60ms方案暂停，不引入SDR reopen回归。唯一context：[video-startup-latency-20261022.md](archives/conversations/video-startup-latency-20261022.md)。

## LG-HDR-FIT-20261022

- **候选已装 LG；宽屏兼容限制解除、自动模式原生几何恢复满屏，完整 fit 验收待用户回报**：用户指出 Dolby Vision/HDR 播放时“自动”和“等宽”四周留边不正确；“等高”是否裁切上下尚待核实。撤回先前把四周留边解释为正常画幅适配的结论。baseline `/tmp/lg-fit-sf-current.txt`：LG `LGH870DS42e27764` 横屏面板 2880×1440，应用可见区 2672×1440、左偏移104；HDR Surface 2672×1336、位置(104,52)、format43，Activity 为 `compat={640dpi cdd-aspect}`（`/tmp/lg-fit-activity-current.txt`）。
- 独立 V1 初审认为 metadata 位置和值合理；项目原已声明 `resizeableActivity=true`，标准 Android 应可支持宽屏，因此不能单凭缺少 metadata 断定原因为何。after 实测本应用 compat 已从 `cdd-aspect` 变为 `display-aspect` 且全屏边界恢复；此行为支持候选解释，但 OEM compatibility 判定细节仍不作超出实测的推断。Android 官方说明：[Update your app to take advantage of the larger aspect ratio on new Android flagship devices](https://android-developers.googleblog.com/2017/03/update-your-app-to-take-advantage-of.html)。
- 候选 Release APK 已 `adb install -r` 到 LG，独立设备 APK 流 SHA-256 与产物匹配：`0d388cb819b7f8c98777996a291ccd1eb518d0a21347407a8409452d3a017d71`，versionName `2.1.6`；源码构建 JAR SHA-256 `23c7aeba19aad5d8aa648992764e56659bf77d386de5416b9df0e0aa87837f1e`。after `/tmp/pili-lg-fit-20261022/activity-after.txt` 显示 compat 从 `cdd-aspect` 变为 `display-aspect`；`sf-landscape.txt` 与 `sf-auto-playing.txt` 中应用/HDR Surface 均覆盖全屏 2880×1440、pos=(0,0)、format43，baseline 的应用和视频内缩均消失。直接 VideoParams 输出 `/tmp/pili-lg-fit-20261022/logcat-after.txt:34729` 为 `source=3840x1920 target=1440x720`；34784–87 为 DV P8.4、`OMX.qcom.video.decoder.hevc`、PQ applied、`verified=true`。深链 `BV1vY4y1N7TY` 后标题仍为“蹲守一周，我终于拍到了夕阳下的梦幻场景｜北海道VLOG | Links 4K HDR”；原切换前 BVID 未知，只能确认标题匹配。V1 after 复核认可兼容边界解除和自动原生几何满屏，仍保留视频像素、等宽等高及非2:1源验收边界。
- 当前自动模式截图 `/tmp/pili-lg-fit-20261022/menu-attempt2.png` 的原生视频内容不可见，不作肉眼比例/裁切验收；等宽、等高还没有菜单选项状态与对应几何证据。等高验收要求上下贴合且不应上下裁切，左右可留边或裁切。用户异步实机确认正在等待；旋转设置仍为自动且用户旋转值未改。manifest 候选改动（`android.max_aspect=2.4`）已于 2026-10-22 经用户授权提交至 `goodwu-dev-rebased`（变更记录以 Git log 为准），未推送；完整 fit 验收仍开放。唯一 context：[lg-hdr-fit-20261022.md](archives/conversations/lg-hdr-fit-20261022.md)。

## MEDIA-KIT-BUILD-EXPERIENCE-20261022

- **done（汇总，无实现改动）**：四路并行 Scout 收集 `~/src/media-kit-build`（约 12 万文件、百个任务轮次，2026-09-30~10-22 原生构建与实机验证 scratchpad），值得保留的经验已汇总写入归档：Android 增量覆盖编译/JAR 换装配方（zip -0 + zipalign -p 4096、-lc++_shared）、证据纪律（env 指纹/冻结证据包/fail-closed preflight/SHA 钉扎）、LG API24 取证通道降级（exec-out、SF 通道探测）、macOS universal 构建链、shared 产物链卡点（untracked 源不可 pin）、两起事故教训（pinned .o 被覆盖、slice 未 commit 致 preflight fail）、样片/脚本/取证协议资产索引。跨项目沉淀候选（3 条）列归档 Action Items 待用户确认后迁长期 memory；工作区清理未启动。context：[media-kit-build-experience-20261022.md](archives/conversations/media-kit-build-experience-20261022.md)。
- **处置完成（同日用户确认）**：3 条经验已沉淀长期 memory（android-native-incremental-build / build-artifact-evidence-chain / old-android-forensics-degradation + INDEX）；二进制证据按用户决定全部放弃；文本工具与关键文档（47 文件，含 scripts/、lg-api24 全部构建验证脚本、LG 取证协议、P5 根因报告等）迁至 `~/src/media-kit-experiments/media-kit-build-20261022/`（仓外保留目录，README 记录用途）；`~/src/media-kit-build` 由用户自行删除。
