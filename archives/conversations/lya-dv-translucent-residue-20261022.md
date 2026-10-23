# LYA 播放杜比视界界面残留（半透明透出）（lya-dv-translucent-residue）

## Current State（2026-10-23 已验收，用户授权本地提交归档）

- **用户验收完成**：无alpha清除对照包横竖屏、全屏进出、控件显隐均“全部正常，无残留”。APK SHA256 `fd1882ecb327e491a79856b5a0f158a7ccab52c68056e7e56d6e997cae72fda9`；内含 stripped `libmpv` SHA256 `c9c6c89900da7eaa42be10e95852c37a5459960ef227aa74f298d13a4c742520`。独立设备验证：Flutter TextureView、OMX.hisi 硬解、10-bit BT2020_PQ视频层、帧持续推进，无FATAL/ANR。用户授权本任务本地提交归档，不推送；实际提交以Git log为准。
- **正式texture修复**：media-kit/vendor `requiresFlutterTextureView` 默认false，LYA适配器在既有applicability范围自报true；App通用查询并按Activity缓存，无机型分支。原生视频Surface、硬解和真实PQ HDR不变。texture对照支持旧Flutter根Surface/合成拓扑参与残留；完整alpha状态以及HWC/驱动的具体因果根因未定，不作定案。
- **alpha补丁与打点**：此前的alpha清除和GL/Vulkan临时打点已从mpv源码撤回；补丁、原文件及旧APK备份于 `/Users/wuweiwei1/src/PiliPlus/.git/diagnostic-backups/lya-alpha-removal-20261023-104644/`。mpv无本任务diff。`f_decoder_wrapper.c` 的既有改动属于其它任务，不纳入本任务提交。
- **已知现象（关闭处理）**：同一暂停帧、控件隐藏时，竖屏与横屏全屏仍有明显亮度/色彩变化；用户决定接受现状，不再定位或修复。该现象不阻塞本任务验收。
- **证据边界**：本次人工验收闭合的是LYA残留与控件场景；设备核验支持硬解、10-bit PQ及帧推进。更广的跨设备、SDR稳态、全量HDR↔SDR循环与性能验收未覆盖。此前关于alpha/HWC具体根因的说法保留在历史记录中作为当时判断，不作为当前结论。


## 无alpha对照的构建与保护证据（2026-10-23）

- 两个Android context精确恢复mpv HEAD；六项保护文件SHA前后相同，f_decoder_wrapper补丁前后cmp一致。NDK27.2执行 `ninja -C ~/src/mpv/_build-arm64-mks libmpv.so` exit0，新未strip库SHA `3944919500d675410dabc722e6171cf9791046676191a60a64758c9146d50616`。同基线JAR只替换libmpv entry并zipalign，候选JAR SHA `5779622a2b04dd67eea12603cf41191a9fdc4b191a3d16bba1755e76ae904a13`；最终APK/stripped库SHA见Current State。其它.so与上包逐字节一致。
- 最终包lastUpdateTime `2026-10-23 10:49:35`，当前PID3231独立采样3秒frame799→892；源码、原包及恢复patch备份见Current State。构建/设备证据 `/tmp/lya-no-alpha-20261023/`（`ninja.log`、`apk-build.log`、`independent-device-verification/REPORT.md`）。标准wrapper仍引用已删历史脚本，本轮仅延续单变量增量重编及本地JAR通道，未改发布JAR/构建wrapper。

## 正式texture修复实施与上一候选验收（2026-10-23，native仍含alpha）


- **结论强度**：用户已确认首个单变量texture诊断包横屏全屏“看不到残留，控件正常”。同native库、硬解与PQ路径保持，模式往返层栈证据证实旧Flutter Surface消失，支持旧根表面保留/合成拓扑参与；未证明具体alpha/HWC/驱动缺陷。撤回的旧“alpha已修复”判断不恢复。
- **正式实现（未提交）**：media-kit `SurfaceDataSpaceExt.requiresFlutterTextureView()` 默认false，`LyaPqDataSpaceExt` 在原SDK29+精确fingerprint范围自报true；核心静态helper同时检查isApplicable，诊断map同源一致。PiliPlus `MainActivity.getRenderMode()` 启动时读取通用能力并按Activity缓存，删除诊断extra/Log，无机型分支。非匹配设备仍用宿主默认surface。视频Surface、硬解与PQ路由零改动。
- **注册/生命期**：当前AudioServiceActivity默认engine自动注册插件，早于FlutterView创建及模式首次选择；custom/cached engine须先注册，晚注册需重建Activity。查询不调用vendor私有ABI，但首次引用PlatformVideoView会尝试已有的通用HDR bridge静态加载；不能称完全无native加载。不监听/隐藏Flutter内部surface，避开revert等首帧恢复风险。
- **正式候选已装LYA**：`/tmp/lya-host-composition-fix-20261023/candidate.apk` SHA256 `20ed2d8ba12a832bf9460da97791f1aebb523f1bd1043e70c1a107cb875ad928`，lastUpdateTime `2026-10-23 10:37:46`。Release dev/Flutter3.47.7/JDK21；libmpv SHA256仍为 `6fe5b42a92161dbb438491023e5beed178bbcfe45a071046ebefe52d62da1310`，与首个诊断包及原基线一致。本轮为保留native基线的宿主修复验证，不宣称已恢复latest-source native构建链。
- **机器复核**：普通launcher冷启动（无extra）`launcher-top.txt` + `mapping.txt` 确认为FlutterTextureView；HDR1/HDR2均OMX.hisi HEVC/mediacodec/gpu-next/ext:lya-pq/PQ verified=true，SF视频Surface为format43(RGBA1010102)、BT2020_PQ；HOME→launcher返回后PQ仍在、视频buffer frame计数从130推进到581。退出HDR进SDR测试看到sdrDirect计划且SF PQ层消失，随后返回HDR2重新applied；SDR自身稳态推进尚未闭合，不将其写为完整SDR播放验收。
- **验证状态**：新增5项JVM能力边界测试通过；目标整批50项为48过/2失败（未改LG实现返回validatedPredictionTransfers=[pq]，旧断言仍期望null，未在本任务修改）；两仓diff check通过。独立V1审核无阻塞问题，可进入设备验证。需求文档R5.1补宿主接线/注册/验收边界。
- **正式候选面板验收通过**：用户针对本候选横竖屏切换、全屏进出、控件显隐确认“全部正常，无残留”。这次确认属于正式APK20ed2d8b，非仅复用前一诊断包结论。用户可从launcher正常冷启自动生效，无诊断参数依赖。
- **独立Verifier实机证据**：设备base.apk回读SHA与候选完全一致；当前PID31761为OMX.hisi HEVC硬解，根视图FlutterTextureView、无旧FlutterSurfaceView，PQ/format43视频层保持；间隔3秒视频buffer frame=1967→2033，推进确认，日志无FATAL/ANR。报告 `/tmp/lya-host-composition-fix-20261023/independent-device-verification/REPORT.md`。
- **验收范围与残余边界**：本次LYA核心残留/控件问题通过；SDR稳态推进、HDR↔SDR完整人工循环、退出/后台面板观感与普通UI性能未全量验收，不夸大为全设备/全场景通过。非匹配设备默认模式由JVM边界验证，未向marble/LG装候选。原生latest-source构建链恢复、旧alpha补丁的独立去留均不是本次变更结论。无提交/推送。
- 原因与实现细节：本页历史；库侧需求 `../media-kit/docs/requirements/android-hdr-auto-output.md` R5.1。正式证据 `/tmp/lya-host-composition-fix-20261023/`，首个诊断证据 `/tmp/lya-texture-ab-20261023/`。

## texture 对照与正式方案形成记录（2026-10-23）


- **用户目检通过（本轮新事实）**：用户确认“texture 模式下横屏全屏已经看不到残留了，控件也正常”，并授权继续确认原因和正式修复，保持硬解与真实 HDR。原生库、视频载体和PQ路径不变的对照下，支持“旧Flutter根Surface保留/合成拓扑参与残留”；尚不能进一步归因为视频alpha、HWC或驱动具体环节。
- **正式候选决策**：media-kit `SurfaceDataSpaceExt` 新增只读 `requiresFlutterTextureView`（默认false）；已验证vendor适配器在既有applicability范围自报true；库提供通用静态查询，Activity启动时消费并按Activity缓存选择。App不写机型判断，非匹配设备保持默认surface。删除诊断Intent extra。不在库里隐藏Flutter管理的Surface，不改解码/原生视频Surface/PQ路由。
- **源码机制与方案取舍**：Flutter3.47.7 `convertToImageView`保存原renderSurface并pause，`FlutterSurfaceView.pause`仅置isPaused=true、不清buffer；`revertImageView`恢复旧surface并等首帧后才释放ImageView。暂停时surfaceDestroyed受到`!isPaused`保护，不能声称隐藏必然断开renderer；但库外以ImageView对象存在判断暂停期不可靠（恢复等首帧期间ImageView仍在），不直接产品化hide/restore。全App常量texture会扩大性能验收面，故优先vendor能力约束下的公共getRenderMode入口。
- **open / 设备通道已恢复，候选已装LYA**。用户明确授权：LYA 已连接，继续 texture 对照，装好后由用户目检；保持硬解与真实 HDR。本轮已重新通过 ADB 连接 `3EP7N18C28016072`，此前 ADB listener 阻塞已解除。
- **实验范围**：仅 App `MainActivity.getRenderMode()` 增加 Intent boolean extra `piliplus_diag_flutter_texture`（缺省 false 调 super，true 返回 texture），日志 tag `PiliPlusRenderMode`。必须 force-stop 后冷启动（singleTask 已存在 Activity 的 extra 不会重建根视图）。不加机型分支、不改视频 Surface、解码或 PQ 路由。代码独立 V1 审核无阻塞问题。
- **机制边界**：Flutter 3.47.7 的 Hybrid Composition 仍可能 `convertToImageView()`，因此实验改变的是被保留的 Flutter 根 surface；不能说播放期间全部 UI 始终由 TextureView 输出。预期检验旧 Flutter SurfaceView 是否参与残留。
- **原生基线保全**：设备原 APK 已回读 `/tmp/lya-texture-ab-20261023/baseline-installed.apk`，SHA256 `4aca26c1778bc83b38b558060af66440249afc680d110085c9e624b2d9baadd8`；原生 libmpv SHA256 `6fe5b42a92161dbb438491023e5beed178bbcfe45a071046ebefe52d62da1310`。`mks-opaque-instr3.jar` SHA256 `e1b711cfab638993c9eb6fa02625a0a7e0c52e1704fdb43d66b48a44a04d7a73` 经 NDK strip 后与该 libmpv 逐字节相同。本轮 Release 单变量诊断保留基线原生库；不是 latest-source/native build 验收。media-kit 标准构建 wrapper 引用的 `media-kit-build/.../build-mks-r1.py` 已随用户清理删除，本轮未修改该链或姊妹仓源码。
- **A0 原包现测**：同一 `BV1vY4y1N7TY` 冷启：HdrDiag `metadataReshape/nativeHdr/gpu-next/mediacodec/pq/ext:lya-pq/verified=true`，硬解组件 `OMX.hisi.video.decoder.hevc`；SF 视频 SurfaceView#1 为 RGBA1010102 / `BT2020_PQ` / DEVICE，Flutter 旧 SurfaceView#0 在位。证据目录 `/tmp/lya-texture-ab-20261023/` 的 `a0-*`。这确认未回退 SDR，但面板观感仍由用户确认。
- **构建与安装完成**：Flutter3.47.7 + 临时 JDK21，Release dev APK `/tmp/lya-texture-ab-20261023/candidate.apk` SHA256 `4641e7b66bc8b218c8e432448c754e0cbf2712dd47d293108a1745437d07918d`；`adb install -r` Success，设备 lastUpdateTime `2026-10-23 10:15:06`。APK libmpv 为上述6fe5，与基线完全一致。构建日志 `build-clean.log`。曾误取旧split APK，哈希门禁拦住，未安装；最终取本次 `app-release.apk`。原merge/strip中间目录可恢复移至证据目录重建，未动发布JAR。未提交/推送。
- **同APK模式往返已执行**：B1(texture)→A1(surface)→B2(texture)，均force-stop后cold start同一源。`a1-activity-top.txt` 为 `uq`，`b1/b2-activity-top.txt` 为 `wq`；本次 `candidate-mapping.txt` 明确 `FlutterSurfaceView -> uq`、`FlutterTextureView -> wq`，视图树直接证实模式；本次logcat未留下选择模式Log.i行，不拿不存在的日志作验收。A1保留Flutter SurfaceView#0和视频#1；B1/B2仅原生PQ视频SurfaceView#0及App Window，旧Flutter Surface消失。B2 HdrDiag仍为 `metadataReshape/nativeHdr/gpu-next/mediacodec/pq/ext:lya-pq/verified=true/degrade=none`，SF为 `BT2020_PQ`、format43、DEVICE；当前pid27760硬解为OMX.hisi HEVC，未见FATAL/ANR。此为层拓扑往返验证，**不等于面板残留人工A/B/A**。
- **当前留B2(texture)播放供目检**：用户需手动横屏/全屏、控件显隐确认中央logo/左侧竖屏UI印记是否消失。冷开、旋转、全屏、控件、HDR↔SDR往返的面板验收和残留因果闭环未完成，不能宣称已修复。系统截图干净不能替代面板目检。若从launcher重新冷开，extra缺省false会回surface；复验texture需上述cold start命令。

## 接手复核依据（2026-10-23，保留）


- **open / 实机步骤 blocked**：用户再次报告 LYA DV 播放中央 logo 或左侧竖屏 UI 残留，系统截图未捕获。当前会话 `adb devices -l` 启动本机 ADB server 失败：`could not install *smartsocket* listener: Operation not permitted`，尚未连接设备、安装或执行新实验。保留现有源码/装机候选；本轮不宣称修复。
- **撤回前轮根因定案**：`isOpaque=0` / `PREMULTIPLIED` 仅说明层允许混合，不证明实际 buffer alpha 未定义；alpha clear 的执行日志也不等于最终 buffer alpha 实测。前轮“视频 buffer alpha 已修复”“当前不是视频透明”“上层旧像素被截图 tone-map 洗掉”均缺因果证据，降为假说。截图层内容变化与候选修复可能相关，但未有同状态 A/B/A，不能单独归因。
- **找回重要历史对照**：`../media-kit/archives/conversations/android-hdr-dv-display-plan-20260922.md` 的 10429–10437 记录：①10429 同机 P5 视频 Surface PixelCopy 竖/横 16×16 各 256 点 alpha 均255（稀疏且经过 PixelCopy，不能等同完整原始 buffer）；②10433 视频 z=-1 仍有印记；③10434 视频 z=+1 用户确认印记消失，但遮住控件；④10436/10437 保持 z=-1，改同页真正全屏并移除 AppBar/底部列表后，用户确认印记消失。这是历史实验回报，尚未在当前 App/P8.4 版本复现，不能直接当本轮修复验收。
- **当前可复查证据**：`/tmp/lya-layer-audit/r01-sf.txt:1628–1642` 显示旧 Flutter SurfaceView#0、视频#1、应用 Window 三层均为 `DEVICE` 合成；旧 Flutter 层 `ROT_90`、visibleRegion `[0,0,1440,1440]`，视频 z-index=1，Window z-index=2。此结构支持优先调查合成/旧表面生命周期，但不证明哪一层造成面板印记。
- **代码路径**：Flutter 3.47.7 `FlutterView.convertToImageView()` 暂停旧 renderSurface 后切 ImageView；`FlutterSurfaceView.pause()` 不清理旧 buffer；Hybrid Composition 的 `PlatformViewsController.onEndFrame()` / `finishFrame()` 继续管理 ImageView 和平台视图。media-kit `platformview/PlatformVideoView.java` 当前 PQ 路径已 `setZOrderMediaOverlay(true)`，因此再次改 z=-1 不是新实验。
- **诊断日志漏洞**：`context_android.c` 的 `first clear executing` 在实际 `color_mask && eglQuerySurface(...)` 条件之前；只证明进入 alpha 门控，不能证明本次 Clear 已执行/成功，更不能证明每帧最终 alpha。若续用此探针应移至 Clear 后并记录 GL 错误及有限读回，避免再次把日志当最终像素证据。
- **恢复设备通道后的最小实验**（逐项单变量，不并改）：先固定同一视频暂停帧并用另一台相机记录面板与系统截图。首选独立诊断候选：仅 `MainActivity.getRenderMode()` 改为 `RenderMode.texture`（改变 Flutter UI 呈现，不改变视频载体），保持 media-kit 原生视频 SurfaceView、RGBA1010102/PQ 与硬解；冷启动 A/B/A，SF 必须验证旧 Flutter SurfaceView 层消失且视频 PQ 层仍在。若残留消失，只能说明层拓扑参与，不能单独定为 alpha 或 HWC 哪一环。必要时再临时隐藏已暂停、非当前 renderSurface 的旧 Flutter SurfaceView（确认 ImageView 首帧已接管，revert 前恢复；此为 engine 生命周期实验，不直接产品化）。若无效，再测上层透明区域/帧更新。z=+1 仅作短时定位对照，不能交付遮挡控件的方案。不要以 SDR、软解或关闭 HDR 获得“无残留”通过。
- **验收**：同一源保持硬解 + PQ HDR；冷开、竖转横、全屏进出、控件显隐和 HDR→SDR→HDR 均无面板残留、控件可用，退出恢复无黑屏/冻结；面板照片/用户目检是必需证据，截图干净不算通过。

## 前轮状态（2026-10-23 00:55；以下定因结论已由接手复核降级）

- **运行时证据定案（instr3 打点包，LYA 在装）**：`android_init enter (GL context)`（GL 上下文确认，非 Vulkan）；`gate=1 alpha_bits=2`（EGL 配置 RGBA_1010102、ALPHA_SIZE=2，门控真）；`first clear executing`（**alpha 清除每帧执行**）。同时 screencap 全画面判读与静态亮像素检测全部干净（含全新打开 30 帧连拍、x=1440 孤儿层区无亮度台阶）。
- **用户目视仍有残留；截图确认看不到** ⇒ 残留为**面板可见、screencap 不可见**。结论修正：视频层 buffer alpha 机制已修复且真实有效（修复前截图可见的中央 logo 已消失）；当前面板残留**不是视频层透明**——头号嫌疑改为 **z=0 Flutter 窗口表面在"视频洞"区的陈旧像素**（洞仅为遮挡元数据；旧像素按自身 alpha 混合画在视频上方；其约 26% 黑色光晕暗化在 1000nit HDR 亮画面上肉眼明显、经 screencap tone-map 后被洗掉无法检出）。孤儿层 SurfaceView#0（z=-2，视图树外，盖左半 x<1440）在视频不透明后不可见，基本排除。
- 待用户输入：①另一台手机拍摄的 LYA 面板照片（screencap 之外的面板真实证据）；②退出/重进全屏（或退出视频页重进）后残留是否消失（直接检验陈旧像素假说：全量重绘会清洞区）。
- 若假说成立，修复方向在 Flutter/media-kit 侧（平台视图挂载后强制整面重绘/清洞），与 mpv alpha 无关；mpv 侧 opaque-alpha 修复保留（对截图层残留已证实有效）。
- 打点包沿革：instr2 曾构建但未验证是否生效；instr3（GL+Vulkan 双入口打点+android_log 直写）确认链路。当前在装=instr3 候选（含一次性打点日志，保留无碍）。

- **修复已实施并装机 LYA（候选，待用户横屏目检确认；未提交）**：mpv fork `video/out/opengl/context_android.c` 新增 **opaque-alpha 每帧清除**——`android_swap_buffers` 在 `eglSwapBuffers` 前对默认帧缓冲做仅 alpha 通道的 masked clear（`ColorMask(F,F,F,T)+Clear`，rgb 不动，premultiplied 下 alpha=1 为恒等）；`android_init` 按 EGL 配置 `EGL_ALPHA_SIZE>0 && 非 YUV diag 分支` 记 `window_has_alpha` 门控（ColorMask/GetBooleanv/GetFloatv 按 `is_enabled` 先例 `eglGetProcAddress` 解析，完整保存/恢复 scissor box、write mask、clear color、read/draw fb 绑定）。改动仅在 `~/src/mpv`（media-kit/android 分支工作区未提交），App 与 media-kit Dart 零改动。
- 根因链补充（代码级闭合）：渲染链从不定义 RGBA_1010102 的 2-bit alpha（mpv `want_alpha` 默认 false、libplacebo 按目标不写 alpha）→ 垃圾 alpha 进 SurfaceFlinger（`blend=PREMULTIPLIED`、层 isOpaque=0）→ 视频按垃圾 alpha 混合，下方冻结的 Flutter 主表面旧帧透出（实测残留像素 max 217 vs 不透明控件 255）。
- 构建链（本轮实测）：`ninja -C ~/src/mpv/_build-arm64-mks libmpv.so`（NDK 27.2 `darwin-x86_64/bin` 补 PATH）→ 新 so `a6eaa4f6…`；按 zip -0 -X + `zipalign -f -p 4096` 换装 mks JAR（保留 libc++_shared/libmediakitandroidhelper）得候选 JAR `f5461124…`（放 `media-kit/libs/android/media_kit_libs_android_video/android/build/libmpv-android-v2026.013/mks-arm64-v8a-opaquealpha.jar`）；App 经 `--android-project-arg mediaKitLocalArm64Jar=<该JAR>` 构建（本地 JAR 验证通道，钉住发布 JAR 未动）。候选 APK SHA-256 `e6e5f6ae…f18`（27.7MB），00:20:42 装 LYA（versionName 2.1.6；APK 内 libmpv 为 strip 后 `a4b655a8…`）。
- 验证状态：HdrDiag 路由不变（applied nativeHdr/ext:lya-pq/verified、OMX.hisi hevc）；竖屏播放器区（28s 控制条隐藏）无 logo/文字形态簇；logcat 零 FATAL/ANR。**未完成**：横屏全屏目检（adb 合成点击进不了 App 全屏，需用户手切全屏确认中央 logo/文字残留消失）；修复前竖屏阶段本就无确凿残留证据，横屏 05/09-1 才是对照基线。
- 待办：用户横屏目检通过后——mpv 仓提交 opaque-alpha 修复；发布 JAR 更新（钉住的 GitHub release + SHA，或维持本地 JAR 通道）由用户定；LG 同法取证（是否有同样 isOpaque=0 但被暗色下层掩盖）顺带确认。
- 并行会话注意：构建期间 media-kit 工作区被另一会话实时编辑（routed_video_playback.dart 加 report getter），00:17 后稳定；本轮构建撞过一次其半成品状态（HdrOutputReport 缺 import），等待后通过。

## 旧 Current State（2026-10-22 深夜·诊断轮）

- **已定位根因（诊断结论，未实施修复）**：LYA（`3EP7N18C28016072`，API29/hisi）播放 DV 时，界面上"隐约的覆盖层"= **视频层半透明把下层冻结的 Flutter 主表面旧帧透出来**，中央 B 站小电视 logo 是页面打开时缓冲指示器的残影，不是常驻控件。
- 复现：dev 包 `f8447fb1…`（22:21:53 安装，含置灰+容差修复，**不含** 23:15 后未提交的 PlaybackDiagBar/preferCodecs 自动配置——与本问题无关）；深链 `BV1vY4y1N7TY`（4K DV）。HdrDiag：`class=dvP84 selected=metadataReshape presentation=nativeHdr vo=gpu-next hwdec=mediacodec output=pq topology=platformView surface=pq path=ext:lya-pq applied verified=true`。
- 证据链（全部在 `/tmp/lya-dv-residue/`）：
  1. **SF 层栈**（`sf-full.txt`，横屏全屏时抓取）：视频层 `SurfaceView #1` z=-1、pos(120,0) 2880×1440、格式 **RGBA_1010102**、dataspace BT2020 SMPTE2084 Full、**isOpaque=0**（半透明合成）；其下 z=-2 为 Flutter 主表面（SurfaceView #0，RGBA_8888，isOpaque=1）；其上 z=0 为 App 窗口覆盖层（FlutterImageView，TransparentRegion 洞 [120,0,3000,1429] 恰为视频区域）。
  2. **像素衰减定量**：残留 logo 簇 max=217/p99=213，而确定不透明的控制条文字 max=255 → 残留内容被约 85% 衰减后混合，符合"下层内容按 (1−α) 透出"。
  3. **语义树**（`ui2.xml`，uiautomator）：仅暴露 `87%, 进度条` 一个 Flutter 语义节点；缓冲 widget（semanticLabel "加载中"）**不在树中** → widget 早已移除，屏幕像素是下层旧帧。
  4. **视觉判读**（09-center-zoom）：logo"呈半透明白色，透过 logo 可以看到后面的视频画面"；用户肉眼同感（"像盖了一层隐约的覆盖层 / 视频层半透明把底下的界面透出来了"）。
  5. 残留跨越全屏进/出、竖屏/横屏切换持续存在（01→09 全程）；位置相对全屏中心略偏（x1400-1472 vs 中心 1560），符合"竖屏布局的旧帧被旋转到横屏"的解释。
- 机制：platformView（混合合成）挂载后 Flutter 主表面停止重绘、保留含启动期 UI（缓冲 logo+光晕+页面文字）的最后一帧；LYA hisi 路径（p5Pipeline/lya-pq ext）渲染进 RGBA_1010102 的 final-pass 缓冲**未把 alpha 写满 1.0**，SurfaceFlinger 按 isOpaque=0 预乘混合 → 旧帧以约 (1−α) 强度透出视频下方。
- 为何只有 LYA：marble DV 走 mediacodec_embed（无 platformView SurfaceView）不受影响；LG 同为 platformView+rgba1010102 但（未证实）alpha 写满故无透出——**待办：LG DV 播放时抓 SF 层对比**；LYA SDR 无 platform view 同样无碍。
- 修复方向（**media-kit 侧**，App 零改动；`PlatformVideoView.java:466` `setFormat(RGBA_1010102)` 上下文）：让 lya-pq/p5 路径 final-pass 每帧写 alpha=1.0（渲染 clear alpha=1 或关 alpha blend/后处理钳制），或强制该 SurfaceControl 层按 opaque 合成。具体渲染写入点在 hisi vendor 管线内，需在姊妹仓跟进。
- 证据截图：`01/03/04/05/09-*.png`（残留各时点）、`05-left-zoom/05-center-zoom/09-center-zoom`（判读裁剪）、`sf-full.txt`、`sf-layer-list.txt`、`ui2.xml`、`ui.xml`。

## 历史依据

- 用户报障原文："LYA上播放杜比视界会有文字残留在界面上" → "我肉眼可见中间残留b站logo，像是盖了一层隐约的覆盖层" → "我切全屏了，还有其它残留的界面信息…在画面左侧" → "感觉是覆盖了一层半透明的界面。或者视频层半透明把底下的界面透出来了"（最后一句与实测机制一致）。
- 相关前科：PLAYBACK-LOW-FPS 任务曾修"PQ→SDR诊断三字段残留"（同为表面残留类）；LG-HDR 轮已知"播放控件被 ON-TOP 视频盖住"（z 序家族）。本问题与 PlaybackDiagBar（未提交、默认关、不在装机包）无关。
- 排除项：uiautomator 树无缓冲控件节点（排除 widget 卡死）；残留区域像素随视频内容波动（排除稳定不透明覆盖层）；跨全屏切换持续（排除一次性脏区）。
- 远端图像判读教训再犯一次：`05-left-zoom` 判读声称左侧有"1080P 高清/智能倍速"文字（代码库无"智能倍速"字串），为幻觉读数；后续以像素簇检测+语义树+SF 层事实为准。
