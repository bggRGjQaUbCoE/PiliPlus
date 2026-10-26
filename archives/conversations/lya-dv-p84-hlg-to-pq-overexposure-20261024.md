# LYA DV P8.4 转 PQ 观感过曝、暗部无层次（lya-dv-p84-hlg-to-pq-overexposure-20261024）

## Current State（2026-10-24 深夜已验收，用户授权提交归档）

- **2026-10-25 证据边界更正**：后续 LG 灰阶/固件排查确认，500 是该机固件能力描述常量，不是即时光学测量；不能仅由常量推其错误。本文历史“真实面板峰值”“HLG 语义固定 1000/整幅约十倍”应按当时推断理解：HLG 峰值与系统 gamma 会适配目标，十倍只直接描述白顶，非所有灰阶。过曝消失的用户验收仍保留，但不等同高光绝对亮度校准。新证据与未闭合项见 [lg-hlg-pq-brightness-mapping-20261025.md](lg-hlg-pq-brightness-mapping-20261025.md)。

- **用户面板观感验收通过**：LYA 与 LG 两台过曝消失、暗部灰阶恢复，任务闭环。media-kit 改动与 PiliPlus 记录已本地提交（不推送，事实以 Git log 为准）。

- **统一修复（media-kit 工作区未提交，V1 可交付无 P0/P1/P2）**：Android 适配器 `VideoRouteCapabilities.java` describeDisplay 采集 `hdrMaxLuminance`（公共 API `getDesiredMaxLuminance()`，原任务卡写的 `getHdrMaxLuminance()` 是 hidden API 编译不过；有效性 finite && ≥80 && ≤10000=PQ 满刻度——用户反馈原 4000 上限过保守，已放宽；无效不上报）；Dart `VideoDisplayCapabilities`/`HdrCapabilities` 透传；`HdrRoute` 新增 `targetPeak`（==/hashCode/toString 纳入，candidateId 不加）；realizer 给 `_metadataReshape`/`_baseLayerConvert` 注入（能力峰值 round().toString()，缺省兜底契约常数 '1000'）；backend 三分支（YUV 契约块读 `route.targetPeak ?? 常数`、texture、platformView+gpu-next）统一条件写入，_setOwned 捕获/恢复语义不变；decision 诊断行加 `peak=`。工作区其它任务未提交改动未触碰。
- **验证**：flutter analyze 与 stash 基线逐条一致零新增；目标批 212 通过、全量 1243+1 既有失败（stash 复现，非本次引入）。构建经用户指定源码通道 `tool/build-android-test.sh --tag lya-dv-peak-fix-20261024`（重建原生库、JDK17、VERIFIED），APK SHA-256 `6e169fc42ee1807fa9ac32db6fc95fb61d5371124d612d7c1d7d525b1aab04ba`（26MB）。装机：LYA `3EP7N18C28016072`（22:44:45）与 LG `LGH870DS42e27764`（22:45:03），均 2.1.6 Success。
- **LYA 实机验证（通过）**：深链 BV1vY4y1N7TY，decision plan/applied 两阶段均 `peak=500`（该机 getDesiredMaxLuminance 实报 500 nits）、路线 `metadataReshape/gpu-next/pq/ext:lya-pq verified=true` 不回退、media_session playing + 双截屏不同 + gfxinfo 18 帧 0 janky、零 FATAL/ANR。**用户面板观感验收待做**（过曝应消失、暗部灰阶恢复；screencap 会 tone-map 不能作亮度证据，需面板目检）。
- **LG 证据闭合（exec-out 通道，用户指正后补跑通过）**：LG 交互 shell logcat 为空是既有环境特性，一律 `adb exec-out logcat -d`。补跑：`baseLayerConvert/surfacetexture/pq/ext:lg-pq verified=true`、plan/applied 两阶段 `peak=500`（LG 实报 500 nits，与 LYA 同值；readback=none 为该路线 API24 既定契约表现）、自动起播推进、零 FATAL/ANR。两台无遗留未验证项，**面板观感验收均待用户**（过曝应消失；screencap tone-map 不能作亮度证据）。
- **背景（诊断结论，代码级闭合）**：reshape 路线 gpu-next 做 HLG→PQ 时目标峰值未知被 libplacebo 按 10000 nits 兜底，`pl_color_space_infer_map` 的「HLG 源峰值跟随目标」规则把 HLG（语义 1000 nits）按约 10× 亮度解读 → 高光裁剪过曝、暗部被抬亮发灰无层次。证据链：实机 HdrDiag（`nativeDolbyVision:displayLacksTransfer`→reshape 唯一 HDR 路线）、`hdr_player_backend.dart` platformView 分支不设 target-peak、`vo_gpu_next.c` Android EGL swapchain `target_csp` 返回空、libplacebo renderer.c:3327 / colorspace.c:342,971 / colorspace.h:310。影响面=所有 reshape→gpu PQ 未设 target-peak 的 Android 设备；历史佐证=LG 点亮轮「target-peak=1000 亮部残余过曝」遗留项（常数 1000 仍高于面板峰值，本次按真实面板峰值收敛）。
- 原始证据：`/tmp/lya-dv-pq-overexp/hdrdiag.log`（复现）、`/tmp/lya-dv-peak-fix-20261024/`（build.log、两机 hdrdiag.log、截屏）。


- **用户报障**：LYA 播 DV P8.4（转 PQ 显示）亮度过曝、暗处没层次。
- **根因（代码级证据链闭合）**：reshape 路线在 gpu-next 上做 HLG→PQ 转换时，目标 PQ 峰值未知被 libplacebo 推断为 **10000 nits 满刻度**，随后 `pl_color_space_infer_map` 的「HLG 源峰值跟随目标峰值」规则把 HLG 信号按 10000 nits 解读（HLG 语义峰值是 **1000 nits**）——整幅画面约 10× 亮度拉伸后编码为 PQ。LYA 面板实际峰值数百 nits，高光大面积裁剪（过曝）、中灰被抬入裁剪区、暗部只剩极窄可用区间（无层次）。症状与 10× 拉伸完全吻合。
- **证据链（逐环节代码核实，无实机 A/B 验证——缺口如实声明）**：
  1. 实机复现（LYA `3EP7N18C28016072`，深链 BV1vY4y1N7TY，2026-10-24 21:08）：HdrDiag `class=dvP84 selected=metadataReshape vo=gpu-next hwdec=mediacodec output=pq topology=platformView stripRpu=false path=ext:lya-pq verified=true`；`nativeDolbyVision:displayLacksTransfer` 被拒 → HLG→PQ reshape 是 LYA 唯一 HDR 路线。
  2. `hdr_player_backend.dart` apply 段：platformView 拓扑分支只设 `target-prim/target-trc` + `target-colorspace-hint=auto`，**不设 `target-peak`，不设 `tone-mapping`**。
  3. `vo_gpu_next.c`（`~/src/mpv`）：Android EGL swapchain `ra_gl_ctx_target_csp` 返回空 `{0}`（`opengl/context.c:307`）→ `target-colorspace-hint=auto` 要求 swapchain 报 transfer 才生效 → `target_hint=false`；target PQ `max_luma=0`。
  4. libplacebo（`/Users/wuweiwei1/src/libplacebo`）：`pl_frames_infer`（renderer.c:3327）调 `pl_color_space_infer_map(image, target)`；`colorspace.c:971` 规则 `if (src->transfer == HLG && dst 是 HDR) src->hdr.max_luma = dst->hdr.max_luma`；dst PQ 未知峰值 fallback `pl_color_transfer_nominal_peak(PQ)` = 10000 nits（colorspace.c:342），HLG 常量 1000 nits（colorspace.h:310）。
- **修复方向（待用户定夺，未实施）**：
  1. **首选（media-kit 层，单变量可控）**：reshape→gpu PQ 路线给 gpu-next 显式设 `target-peak` = 面板真实峰值（Android 适配器从 `Display.getHdrCapabilities().getHdrMaxLuminance()` 采集；`VideoRouteCapabilities` 目前只带 hdrTypes 不带峰值，需扩展字段）。峰值已知后 HLG peak 正确调到面板峰值，tone mapping 正常工作。同理审视 `tone-mapping` 在 platformView 分支的缺省。
  2. 备选（mpv fork 层）：Android swapchain 上报 display 元数据（需 Java→native 传峰值），改动面大。
  3. 注意：该缺陷影响所有走 reshape→gpu PQ 且未设 target-peak 的 Android 设备（LYA 现状；marble 无 bridge 回退同样暴露）。
- **验证缺口**：根因由代码路径推导，未做实机 A/B（候选包设 target-peak 后观感应恢复正常，可作验收）；本机 libplacebo/mpv 版本为当前构建链版本，结论锚定该版本。
- 证据：`/tmp/lya-dv-pq-overexp/hdrdiag.log`（HdrDiag 全行）；实机日志 2026-10-24 21:08 会话。
