# 当前播放低帧率与路由检查（2026-10-21）

## Current State

**SDR mediacodec_embed 恢复与本轮验收完成：最终源码候选已装LG，按用户授权本地提交归档，不推送。** App播放代码零新增改动；库legacy桥接撤销`sdrEmbed:false`，遵循既有SDK默认能力策略；明确software/preferCopy、API≥26原路径及HDR候选边界保留。最终4K AVC SDR为`mediacodec_embed + mediacodec + platformView`、3840×2160/7FA30C06，多窗约30fps；前一候选完成暂停/继续、EOF重播及HOME返回；最终241aabdf包复核冷启动、真实退出重进、明确SDR↔DV/PQ往返及4K留场，未将前一候选的生命周期用例计作最终包重测。本次未重做15min静置，未宣告既有FlutterImageView OOM根因已修复。

- **挂起根因与修复边界：** 历史E3归档记载App等待videoController再mount，而session绑定依赖view先mount的互等；当前路径已先publish再waitReady、ready=false仍mount并用viewport保留真实布局。另一处确定性缺陷是VideoController只注册post-frame callback却不安排帧，idle界面可永远停在platform.future，甚至尚未进入下一步10秒绑定超时。`917405a7`基线已有ensureVisualUpdate和viewport修复；本轮保留这些真实修复并新增回归，未假造新的binding核心补丁、未延长超时。原始历史/tmp日志已不可读，不能把所有旧outputBindTimeout唯一归为同一事件。
- **回归：** 真实VideoController在scheduler idle、无排帧时必须自行安排帧；删去ensureVisualUpdate一行在pump前hasScheduledFrame断言确定性红，按SHA精确恢复后绿。视图用零/未知尺寸（实际0×0，非显式null）、400×300 viewport、ready=false及null→A→null→B验证不塌缩和持续挂载；host fake不冒充Android Surface绑定。对应bridge/default/copy/software测试保持语义，native Surface闭环另以设备证明。
- **额外诊断修复：** 同一backend PQ→SDR时三项dataspace观测未清空，旧requested=pq/path=ext:lg-pq残留。实机已有disarm→旧wid release/ACK/destroy→hal_native→新SDRSurface，证明是报告残留而非仍将SDR输出为PQ。configure入口每轮清空requested/path/readback三字段；PQ仅由本轮setter结果重填，未改native设置/清理/门。新同backend PQ→SDR→PQ用例钉三字段、SDR不增加setter调用、新PQ观测更新。红日志新用例明确Expected null/Actual pq-itu；同时出现的旧gamma扩展路径fixture失败单列，不能把整份红→绿都归因三行重置。
- **主机/V2：** 最终冻结9文件，独立库全量1084通过/8跳过、App16通过。SDK8目标analyze仅HEAD原有curly-braces info，App7目标仅HEAD原有hide Subtitle warning（命令exit1如实保留，无新增诊断）；增量backend局部analyze0。两轮V2无代码阻断，最终全量与设备补足条件。Flutter3.47.7 + --no-pub，隔离material_ui补丁/两package_config、两仓HEAD、原有real.dart临时诊断字节不变；未动全局SDK/cache。
- **恢复路由实机：** 首个源码repro包91108170，PID11166先720p SDR，再同进程切原片实际4K AVC SDR，native约30.08fps；全片到242.3s EOF、MEDIA_PLAY重播及HOME销毁/重建Surface后继续约29.91fps，暂停状态state2→继续state3与帧推进成立；全屏/退出全屏正常。明确UI选杜比视界gen3恢复baseLayerConvert/surfacetexture/PQ verified、format43、29.98fps，再选4K SDR gen4为HEVC embed/29.88fps。此阶段诊断残留随后已修复。脚本`repro-hdr.json`只因等待PQ标记未达而timeout，当轮实际选了4K AVC SDR并已verified，不能记HDR通过或绑定挂起。
- **最终生产候选：** `pili-sdr-embed-final-20261021-release.apk` SHA256 `241aabdff4f303c20f87cf081559abd40bc2c3e542e6bf6e203520a4d548d7b1`。规定ninja→最新native源码JAR→APK，APK/JAR/shipping native SHA同为 `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a`，native manifest/source匹配；9文件SHA在最终构建前冻结，构建后和artifact绑定完全一致，libapp无注入marker。仅启用既有transport/surface timeline诊断，无测试注入。设备动态base.apk MD5与候选相同。
- **最终包设备闭环：** PID13729，4K AVC冷启动bind request→complete为140.373ms；BACK真实退出（旧handle500862926416 dispose、旧wid1050986 release）→同PID重进新owner/wid2458绑定140.244ms，native约29.91fps。界面明确选DV，gen2 PQ/format43/29.86fps；切回4K SDR gen3为HEVC embed/30.02fps，requested/path/readback全none。随后冷启动留场PID14386原片AVC，bind260.821ms，3840×2160/7FA30C06；三窗native30.03/29.90/29.98fps且时间戳推进，Flutter旧ring未混用。无FATAL/legacy fallback/outputBindTimeout。最终原片4K AVC全屏继续播放。
- **验收限度：** 最后VTS41.7°C、GPU max315MHz/pwrlevel5、大核max1056MHz仍有限频；初始低帧窗口VTS44–45°C/GPU214MHz不同热态，未做相同温控AB，不能唯一量化路由/温控贡献。仅LG/API24本轮实测，其余SDK16–25设备未逐一验证；SDK原有embed的GL超分/滤镜不执行、screenshot-raw未验证取舍保持，不新增开关。机器证据不替代新的人眼面板色彩验收。
- **证据与未提交范围：** `/tmp/pili-sdr-embed-20261021/`：baseline、source-freeze、final-build-inputs（构建前）、regressions/红绿与RESULT、report-reset/红绿、verify/final-test-verification、review-summary（Lead摘录）及verify/independent-final-audit、三候选artifacts、device-live与分PID/case JSON/SF/latency、installed、final-thermal。最终独立审计复算native节奏、匹配安装身份与源码溯源；任务记录更新之外的既有dirty内容保持。

**2026-10-21 再次4K SDR低帧诊断（只读检查，未改实现/未重开或换源）：** 用户确认当前为SDR，不能以没有PQ层判断路由异常。LG PID9467、原片标题，安装APK MD5仍为已验收候选 `275083fa8fbdf825866322d36adad327`（本次安装路径变为dev-1）。稳定SF窗口约9.39/9.41fps；后两窗约8.00/8.60fps且帧时间戳推进。先前57/60fps窗口夹有用户seek/界面刷新，不当作解码帧率。VTS44.3→45.2°C，GPU thermal_pwrlevel6/max214MHz（硬件652.8MHz），CPU大核scaling_max979.2MHz（硬件2342.4MHz）；thermal-engine运行且阈值配置吻合，存在明确热限频，但未做冷却A/B，不能唯一归因。当前观测AVC硬解、Flutter RGBA表面；codec dumps未提供源宽高或独立decoder FPS，不将片名4K当参数读取，也不声称当前正在tone-map。

- **用户要求追溯AVC优化路径：** 已在media-kit现源码/历史定位旧的SDR优化：`sdrDirect + hwdec=mediacodec + vo=mediacodec_embed + platformView`，硬解直接送SDR SurfaceView，避开copy/CPU上传/gpu-next纹理链，不需PQ。库TASKS的2026-10-17 P2受控验收（HEAD7540034b）记录三轮约30.34fps、无>100ms停顿、GPU近0%、App CPU5–6%/PSS约185MB；只属于当时受控显式opt-in，不冒充当前温控同条件A/B。后续产品默认启用规则位于VideoRouteOptions.sdrEmbed（null=true，sdk16–25能力准入；显式preferCopy/源硬解unsupported会抑制）。
- **当前接入屏蔽点：** `media_kit_video/lib/src/integration/routed_video_playback.dart:290–309` 的legacy配置桥接显式传 `sdrEmbed:false`，ManagedVideoPlayback仍经此入口创建；因此PiliPlus绕开了SDK已有的SDR embed默认候选。git blame证实false来自较早 `26a2c2c6`（2026-10-20），提交说明是LG默认接入发生output-bind挂起而保留texture；`917405a7`仅补充保守注释，非本次生命周期迁移新增。恢复优化需针对当前受控会话/输出绑定/生命周期验证，并保留明确copy意图及既有GL功能取舍规则；本轮只定位，未改false或其它参数。
- **新证据：** `/tmp/pili-4k-current-20261021/`，包括当前日志/图层/分窗latency与thermal原始sysfs/配置/线程/codec dumps。仅为读取播放信息尝试单次显示控件，未切源/重启/修改温控；采帧窗口在该操作之前。诊断collector已停止，播放保留。

**2026-10-21 管理对象迁移完成，生产候选已装LG；按用户授权本地提交归档，不推送，切页OOM仍未解决。** 先保存helper中间态并精确恢复已验收SHA `13d5ee35…`（基线8项通过），再将完整routed/legacy实例生命周期迁入media-kit。App生产代码相对已验收基线净减202行。迁移控制流和原片PQ实机检查通过；HDR异常后再切页恢复受既有位图OOM阻断，不能记为全部实机场景通过。

- **库/App边界：** 新增 `media_kit_video/integration/ManagedVideoPlayback`，统一持有互斥routed/legacy owner；异常只在当前request且调用方明确授权时fallback，新request/refresh重新尝试routed。独立Player按owner创建，旧资源退休后才准入后继；open在slot外，仍允许新请求抢占。`PlayerOwnerSlot`保留按identity去重的FIFO清理债，关闭manager被丢弃也不能丢掉资源债；分步dispose成功标记避免重复已成功步骤。rate/volume意图revision、发布前同步复核及snapshot返回后current/closed/identity检查已覆盖。App仅保留源/页面token、Media/EDL/headers/cache/shaders/业务配置、owner变化监听重绑及回退授权。
- **输出约束：** fallback默认关闭；App只按本次实际选中video ID的明确SDR白名单授权。HDR125/DV126/Vivid129/未知127、本地及live默认拒绝。不允许HDR→SDR tone-map充当成功；无机型判断分支。
- **验证：** 最终43/43定向（manager33+slot10），独立库全量1081通过/8跳过、App16/16；SDK目标5文件analyze无问题，App7目标仅HEAD已有的hide Subtitle warning。新prepare async info已消除，原force-window Future现在被await。最终V2无剩余阻断，7文件freeze及13生产源码hash均一致；两仓diff check通过。`real.dart`原有临时诊断SHA `3d83f682…`保留原字节，未纳入迁移修改。原先未补丁material_ui/错误SDK的失败轮不作为合格结果；最终全部用Flutter3.47.7和既有隔离补丁依赖 `--no-pub`，无共享cache/SDK改动。
- **探针实机：** 从规定ninja→JAR→APK源码链构建一次性探针包 `f33ec51b…`；仅在每进程首次routed open成功返回后主动抛错，验证编排，不冒充真实native清理故障。PID6642 SDR→legacy→真实App refresh同进程恢复routed/SDR，rate1.25、volume65保持，37.31fps。PID7028 SDR fallback后立即深链HDR新源，同进程恢复baseLayerConvert/surfacetexture/PQ/platformView/ext:lg-pq verified=true/degrade=none，SF format43、原生层29.89fps；旧Timer没有物理取消，但request guard使其不执行refresh。
- **负向与未通过场景：** PID7351 HDR首次注入明确 `allowLegacyFallback=false`，全程无fallback-complete，拒绝降SDR成立。随后深链切页触发 `Bitmap.createBitmap → FlutterImageView.onDraw` 申请15,732,748B的OOM（mapping中的bq），此“异常后再切源恢复”场景FAILED，不能计通过。迁移前21:42同分配大小/调用链OOM证据仍在 `/tmp/pili-fps-20261021/live-route.txt`，本轮不扩展修复，也不声称已查清原始首次fallback触发原因。
- **最终生产候选：** 撤除探针后App/SDK恢复测试冻结版精确字节，再走同一源码构建链。APK SHA256 `284acf6c278f60caf1a70f766a6e5b8a6e5f79e047fe6ef3c43c95f396ee56f8`，APK/JAR/shipping native SHA均 `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a`，manifest新源码hash匹配；libapp无probe marker。设备base.apk MD5与候选相同。PID8003冷启动原片BV1uZ4y1U7h8，23:08:03 applied真实PQ硬解、SF format43/7FA30C04；两窗native127帧30.02/29.91fps且时间戳推进，非Flutter层；无FATAL/注入/legacy fallback。vendor的 `ext dataspace fallback: transfer=pq, applied=true` 是PQ设置链，不是普通播放器回退。机器证据不替代新一轮人眼面板/控件验收；不重做15min EOF长期静置或实际native dispose失败注入。最终原片播放现场保留。
- **证据：** `/tmp/pili-route-migration-20261021/`：baseline/alignment、production-source-freeze、app-size、stabilize/v2-freeze与红绿日志、verify/test-verification、injection/两构建artifacts JSON、probe-*、final-*、installed.json、device-live.txt。独立验证角色复算帧率/源码绑定/安装身份并明确保留OOM失败边界。最终审计 `verify/independent-final-audit.json` 与 `.md`，两仓HEAD未变。

**2026-10-21 修复完成，候选已装LG，未提交/推送。** legacy fallback只复用于触发失败的source request；新源或refresh在既有PlayerOwnerSlot内退休旧owner、检查request仍有效后重新尝试routed。正常routed及同request fallback继续复用；排队状态锁内读取，清理失败仍由slot保留债并阻止后继；创建发布保持request/实例/存活校验。refresh更换Player时恢复原rate/volume并保持原play:true语义，不增加自动播放回调。独立OOM与最初fallback触发原因仍未修复/未闭合。

- 生产修改：App `controller.dart`、`utils/player_source_lifecycle.dart`；新增编排定向测试使用实际PlayerOwnerSlot。8/8定向、全量20/20、目标analyze、diff check通过，V2无阻断。全量初轮因未patch的material_ui1.8加载失败；按迁移既有方式核验9个补丁并复用`/tmp/piliplus1-migration-20261021/material_ui-1.8.0`隔离副本，仅改ignored package_config，`--no-pub`复跑全量20通过，未改共享cache/SDK。生成的两macOS xcconfig include精确恢复任务前字节。
- 故障注入包`0b07e845...`仅临时拒绝每进程首次routed open，并以captured-request guard安排refresh探针，源码差异/备份在证据目录；注入不进入最终源码。PID3506：22:10:12主动拒绝后进入legacy，22:10:26同进程refresh，22:10:38 PQ applied verified，rate1.25→1.25；实际volume100→100，未覆盖任意65音量保持。native视频层127帧37.35fps，符合1.25倍速；不把Flutter层或不同层时间轴合并统计。
- 同一注入包第二轮PID4289：原片fallback已on_load后深链切北海道，新request使旧探针不执行refresh（不是物理Timer取消），22:11:34 PQ applied verified，native层30.02fps。两轮均同进程完成fallback→新routed恢复，无FATAL。
- 随后精确恢复生产源码，SHA与V2冻结一致，再经唯一源码构建入口ninja→JAR→APK。最终APK SHA256 `b15dcd1b7b6d50b4e783d56884446c15bb680b8e7efbc9456e850910cfe89bcb`；APK/JAR/shipping native SHA同为`81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a`，native manifest新源码hash匹配；最终libapp无probe marker。安装后设备base.apk MD5与该APK吻合。
- 最终生产候选PID4679原片BV1uZ4y1U7h8，22:12:17 `baseLayerConvert/nativeHdr/surfacetexture/PQ/platformView/ext:lg-pq,verified=true,degrade=none`；SF format43/7FA30C04，原生视频层127帧29.91fps（非Flutter层），前台App、无FATAL/回退/注入标记，原片播放现场保留。本次不重做EOF长静置/独立OOM修复，不反推最初回退的异常。
- 证据根目录 `/tmp/pili-route-recovery-20261021/`：`full-app-tests-patched-env.log`、`flutter-test.log`、`flutter-analyze.log`、`probe-device-live.txt`、`fps.json`、`final-*`、`installed.json`、两构建artifacts JSON及`injection.json`。源码创建期间取消/分步native清理失败仍是静态/slot测试支持，不冒充真实native故障注入覆盖。



**2026-10-21 21:44 更新：发现共享实例粘滞legacy回退的代码缺陷，旧现场最初异常仍缺日志；原片冷启动PQ路由已恢复。**

- App `controller.dart:880-885` 的 `_initPlayer` 复用existing；open/refresh异常经1072/1132的catch进入 `_switchToLegacyOutput`，1081起清空playback并 `_createPlayer(routed:false)`。此后切源1050/refresh1122遇playback=null直接raw open，不重试路由，直到所有共享页面释放或closeAll。故一次异常可让后续HDR片持续绕过HDR规划。V1独立复核确认该结构缺陷；旧PID25484无HDR输出、多源重开只有TransportTrace，与此机制吻合，但缺首次fallback日志，不能当成触发已实证。
- 先按原Activity intent冷启动BV1vY4y1N7TY（北海道，非初始正在看的动漫片），新PID1401于21:41:01 applied `baseLayerConvert/nativeHdr/surfacetexture/PQ/platformView/ext:lg-pq,verified=true,degrade=none`，SF format43/7FA30C04，30.03fps。温度已降至42°C/GPU cap315MHz，不是严格A/B。
- 随后深链切回原片：按标题在B站原页核对为 `BV1uZ4y1U7h8`（https://www.bilibili.com/video/BV1uZ4y1U7h8/）。21:42:07新gen2初始unknown/SDR texture plan后，Java OOM：`Bitmap.createBitmap -> eq.onDraw` 申请15732748B，heap余14MB，FATAL main；此轮不能记路由成功，也不能把停止日志归为native阻塞。OOM与最初回退无因果证据。
- 再次直接冷启动原片，新PID2124于21:43:51 applied `baseLayerConvert/nativeHdr/surfacetexture/PQ/platformView,verified=true,degrade=none`。SF原片冷启动format43，127有效帧测得30.035fps、中位32.902ms；最终前台仍为App，无错误弹窗。说明片源识别、能力检测和转PQ策略本身可正常选择。恢复现场在原片；未修复上述代码缺陷，不提交/推送。
- 本轮实时日志 `live-route.txt`；原片冷启动证据 `original-cold-*`；首次原片重进OOM `original-reopen-sf.txt`。初始logcat prune列表为1000，缓冲几乎只保留system，App历史日志被淘汰，后续改连续采集才获取完整日志。若要查明最早失败的异常，仍需新复现，不能凭常见review超时猜测。

### 初始现场

初始只读诊断后，用户要求继续确认路由原因；本轮保留初始证据后进行了重新进页及两次冷启动，未修改代码/温控设置。LG `LGH870DS42e27764` 前台 `com.example.piliplus.dev`、PID25484，播放 Links 杜比视界视频。证据 `/tmp/pili-fps-20261021/`。

- 清除 SF 统计后重新采样，三窗分别 8.49/9.41/8.99 fps，中位间隔约115ms，时间戳持续推进，证明当前视频显示层确有低帧率。初始SF时间与/proc/uptime不宜直接比较，不以时钟差认定旧数据。
- 当前 SF 只有 Flutter RGBA_8888 实际缓冲层和同名 LayerDim，未见此前 nativeHdr 路由的 format43 最终输出层；当前不是先前验收的原生HDR输出拓扑。具体内部策略、回退原因无法确认：当前logcat未提供本会话HdrDiag/MKSURF，不能将19:33旧日志的 applied/PQ 当成现在。可能为legacy/texture链，但尚无当前vo/hwdec回读证实。
- 热限频有强佐证：vts=43.4–43.5°C，电池40.9°C、TSENS约55–60°C；GPU thermal_pwrlevel=6，gpuclk/max_gpuclk=214MHz，可用表最高652MHz；cpu2/3 scaling_max=1.056GHz 对 cpuinfo_max=2.3424GHz。msm8996设备的 thermal-engine-8996.conf GPU_MONITOR 在vts43°C限制214MHz，与现场吻合；日志21:31:41 thermal-engine state=1。未直接读取daemon当前加载配置或做冷却对照，不能把全部掉帧唯一归因热降频。
- 系统同时有内存回收压力（reclaim_task/kswapd占用明显、可用内存约330MB），为潜在并发因素；未做因果对照。没有当前源参数/播放器丢帧计数/缓冲读取，解码、网络及渲染耗时未分别闭合。

下一步如需定位路由回退触发点，先取得新会话完整HdrDiag及vo/hwdec/源参数；冷却前后同源同路径对照才能量化温控贡献。当前保留现场，不为采日志擅自重开。
