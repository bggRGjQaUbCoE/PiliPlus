# PiliBoost Accelerator — Phase 0 架构分析与实施路线

分析日期：2026-10-01（Asia/Tokyo）。本轮只新增分析文档、独立协议验证脚本和结果记录；生产 Dart、平台配置和播放器代码保持原样。V1 尚未实施，V2/V3 尚未实施。

## 1. 基线、仓库关系与许可证

| 对象 | 本轮读取基线 | 角色 |
|---|---|---|
| [jyh9521/PiliBoost](https://github.com/jyh9521/PiliBoost) | main `c102a6115c7ac040f6a0c6a1653944b81b82dcb4` | 唯一开发仓库；origin |
| [bggRGjQaUbCoE/PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus) | main `c102a6115c7ac040f6a0c6a1653944b81b82dcb4` | upstream，只读取/同步 |
| [realzza/bilibili-accelerator](https://github.com/realzza/bilibili-accelerator) | `1f2726b6866f4bae78db8fbb9e256291cd57ec24` | 算法参考，MIT |
| [MrTangLuyao/Bilibili-thread-ripper](https://github.com/MrTangLuyao/Bilibili-thread-ripper) | `e64553b1ea911946387a1cf14992ac3fc008e07d` | 算法参考，MIT |
| My-Responsitories/media-kit | lockfile `73771ec38176be2d984a3049c28177bce23b54a0` | 当前实际播放器依赖，native 分支 |

本地初始目录只有无提交的 `.git`，没有生产源码或本地改动。本轮配置 origin、拉取并检出 main，配置 upstream 并 fetch main；`git rev-list --left-right --count origin/main...upstream/main` 输出 `0 0`。两者此刻提交、树一致，GitHub 页面也标示 fork。这个结论只针对本轮抓取的提交；后续开发前重新核对。

主开发 checkout 为 PiliBoost，参考 checkout 位于旁边的 PiliBoost-phase0-references，不合入应用。本报告记录阶段 0 当时的只读分析；后续开发与验证见 V1.md、V1C.md、VALIDATION.md。上游仓库未修改。

PiliBoost `LICENSE` 是 GPL-3.0；继续保留。两个参考许可证分别署名 `Copyright (c) 2026 realzza` 和 `Copyright (c) 2026 Bilibili-thread-ripper contributors`。V1 增加 NOTICE/README References；如直接移植或明显改写具体 MIT 源码，随相关模块保留完整许可及署名。本轮 PoC 为独立编写，不复制 JS。

当前 `pubspec.yaml` 的包名仍是 `PiliPlus`，README/平台显示名也未整体改名。新模块/UI 使用 PiliBoost；第一轮不重命名全项目 import 和 application ID，以减少同步冲突。

## 2. 当前播放链路：源码证据

以下行号均对应上述 PiliBoost main；路径相对本开发目录。没有用 README 的功能列表替代调用关系。

```text
VideoDetailController.queryVideoUrl / _queryVideoUrl
  → _getVideoUrl(quality)
  → VideoHttp.videoUrl(videoType.api, WbiSign params)
  → PlayUrlModel.fromJson
  → Dash.video / Dash.audio / Dolby / FLAC
  → 选择画质、编码、音质对应 representation
  → BaseItem.playUrls: baseUrl + backupUrl
  → VideoUtils.getCdnUrl(video / audio)
  → VideoDetailController.playerInit
  → NetworkSource(videoSource, audioSource)
  → PlPlayerController.setDataSource
  → _createVideoController
  → EDL 两个独立流（或只播放 audio）
  → player.open(Media(edl-or-url, start, extras), play:false)
  → 锁定 native media_kit: libmpv loadfile
  → mpv/FFmpeg HTTP 读取、解复用、解码、A/V 时钟同步
```

| 源码位置 | 已核实的行为 | 接入含义 |
|---|---|---|
| `lib/http/video.dart:201–275` | `videoUrl` 设置 fnval=4048、fourk=1，WBI 签名；UGC/PGC/PUGV 分别解析不同响应层级 | Accelerator 不重写 API 或认证 |
| `lib/models/common/video/video_type.dart:3–18` / `lib/http/api.dart:20–26` | UGC `/x/player/wbi/playurl`，PGC `/pgc/player/web/v2/playurl`，PUGV `/pugv/player/web/playurl` | URL 过期刷新交回原页面查询函数 |
| `lib/models/video/play/url.dart:186–212,256–307` | Dash 有 duration；BaseItem 有 `bandWidth`、segmentBase、baseUrl/backupUrl；playUrls 是同步生成器 | 保留选中 representation 的所有候选与元数据，不能只传最终 String |
| `lib/pages/video/controller.dart:797–810,842–991` | 请求 playurl、补全画质、选 codec/video/audio，963/982 选择 CDN | 不混合不同 codec/质量/资源的字节 |
| `lib/pages/video/controller.dart:680–709` | `updatePlayer()` 记录 position，重新选视频音频并 playerInit | 质量/音质切换必须更新 session/generation |
| `lib/pages/video/controller.dart:721–767` | playerInit 在 FileSource 与 NetworkSource 之间分支，传入 seek/duration/字幕初始化等 | 最佳适配入口，保留其余参数 |
| `lib/plugin/pl_player/models/data_source.dart:4–43` | NetworkSource 只有两个字符串；FileSource 构造本地路径 | 不给 DataSource 强塞下载器/完整 CDN 池 |
| `lib/plugin/pl_player/controller.dart:583–676,766–827` | setDataSource 与 _createVideoController 保留现有播放器，DASH 用 `!new_stream` EDL；onlyPlayAudio 直接读音频 | 替换底层资源 URL，不修改 EDL/A/V 机制 |
| `lib/plugin/pl_player/controller.dart:728–759` | Player.create / VideoController.create；设置 UA、Referer | Proxy 向 CDN 请求时仍必须带等价媒体 headers |
| `lib/plugin/pl_player/controller.dart:945–986` | position/buffer/buffering/error 订阅 | 监控，不另建播放器时钟 |
| `lib/plugin/pl_player/controller.dart:1057–1088,1433–1447,1538–1597` | seek、公开 position/status listeners、播放器引用计数和最终 dispose | seek hook 小而集中；生命周期不能只挂页面销毁 |
| `lib/utils/storage_pref.dart:823–847` | 缓冲默认 4 MiB、16 秒；cache-secs 按速度缩放；前后 demuxer 各有字节上限；直播单独配置 | 新缓存预算必须与 mpv 缓存一起计量 |

实际依赖不是仅 `media_kit:1.1.11` 的 pub.dev 实现。`dependency_overrides` 指向 native Git 分支，lockfile 固定 SHA。读取锁定源码发现：

- `media_kit/lib/src/player/native/player/real.dart:401–414`：`loadfile` 收到 Media.uri、start/extras。
- 同文件 `1081–1090`：`stream.buffer` 来自 `demuxer-cache-time`，表示缓存末端时间戳，不是“剩余缓冲秒数”。应计算 `max(0, bufferEnd - position)`，同时处理无效/旧 generation 值。
- 同文件 `956`：NativePlayer 提供 `getProperty`；V1 直连可以读取 `cache-speed` 辅助观察，但这不是逐 CDN/逐音频精确测量。
- `PlPlayerController.refreshPlayer()` 重新 open 当前 Media；原有错误订阅会触发刷新。Accelerator 的恢复流程必须与它串行，避免双重 reopen。

### 2.1 现有 CDN 功能并非运行时健康度服务

`lib/models/common/video/cdn_type.dart:6–34` 的 CDNService 是枚举（baseUrl、backupUrl、多种 host），不是负责调度/测速的 service。

`VideoUtils.getCdnUrl()` 是同步映射函数：baseUrl 返回第一个 URL；普通 upgcxcode URL 按枚举替换 host；backupUrl/disableAudioCDN 有原逻辑；mcdn、302、bcache、szbdyd 有特殊分支及 proxy-tf 包装。不能把所有 `bilivideo` URL 当作任意 host 可换的资源。

`lib/pages/setting/widgets/select_dialog.dart:93–238` 已有真实下载测速：逐枚举测试，普通 GET，无 Range header，收到 8 MiB 或超过 15 秒取消。它不是 ping，但也不是 Range 严格测速，没有会话 EWMA、冷却/播放缓冲联动。应保留现有 UI 和 OFF 行为；启用 Accelerator 后可复用统一 probe，避免两套同时抢资源。

### 2.2 需要隔离的其他调用路径

全局搜索还发现：

- `lib/http/download.dart:80,114,152` 调用 getCdnUrl：下载保持原实现，别把 localhost/session URL 写入下载记录。
- `lib/pages/audio/controller.dart:344–372` 独立 Media.open：第一版不改变独立音频页面；本报告中的 V1 audio 指 DASH 音轨。
- `lib/pages/live_room/controller.dart:223–224` 使用同一个 PlPlayerController，并传入直播状态：直播原逻辑完全绕过新模块。
- `lib/pages/video/controller.dart:891–921` durl/FLV/MP4 兼容分支：初版仅加速 DASH，durl 保持原路径。
- 同文件 `1420–1430,1589–1607` 的下载/投屏等 URL 使用点需要保留远端源；127.0.0.1 是客户端自己，不是电视的代理地址。
- `FileSource`、手动编辑播放 URL、本地播放、已转成 EDL 的兼容来源，不当作可替换 DASH representation。

## 3. 两个参考项目：可迁移算法与不能照搬的部分

### 3.1 bilibili-accelerator

实际阅读 `src/core/routing.js` 与 `src/page/bili-accelerator.page.js`，不是只看简介。

- `routing.js:16–64`：768 KiB bounded race、4 秒 timeout；fast/slow EWMA 半衰期 2/5 秒；至少 16 KB sample、128 KB 总量才给估计；切换收益 1.5 倍；短缺/失败触发；切换与无结果有退避。
- `createEstimator` 把 TTFB 等待纳入每次媒体传输 goodput，取 fast/slow 较低值，下降快、恢复慢。
- `stuckVerdict/evaluate` 把剩余传输 ETA 与 buffer deadline 比较，忽略很小的 init/index；持续不足才触发，而不是任一 waiting 事件立刻切换。
- `pickChallengers` 优先 API 已发备用，有限候选，结合历史衰减和探索，不在启动时逐几十个 CDN 扫描。
- `raceVerdict/stuckRaceVerdict` 区分“一个 segment 坏连接”与“整个 host 不够快”；失败 segment 可换线重试，而不一定更换全视频。
- `nextCooldown` 对无改善竞赛和多次切换退避；page 层真实 fetch/XHR 进度、取消、history 接入。

移植：纯 Dart estimator/health/decision；配置集中；clock/random/transport 注入便于测试。不要移植 fetch/XHR monkeypatch、DOM、网页事件、Safari UI。

注意这里 SWITCH_GAIN 和媒体 safetyFactor 是两个不同参数；参考值不是本项目已经调优的值。

### 3.2 Bilibili-thread-ripper

实际阅读 `src/range-core.js`、`cdn-resolver.js`、`idm-downloader.js`、`native-mse-player.js`。

- range-core 严格解析闭合 Range/Content-Range、拆块、长度检查、ordered concat；但 `parseRangeHeader` 只接受 `bytes=N-M`。mpv 会请求 `bytes=N-`，本项目必须独立扩充 open-ended、suffix、HEAD、416。
- cdn-resolver 维护 node/address/pair 失败归因、时效 90 秒的测量、0.65/0.35 平滑、指数 blockedUntil、少量探索；失败地址不应自动永久处罚所有节点。
- idm-downloader 有优先级 semaphore、首字节/总耗时超时、取消、有限 retry、保留收到的前缀、失败回退、按 piece 顺序渐进输出，以及全局 concurrency 限制。
- `assignPrimaries` 在未知时轮转，有测量时采用 smooth weighted round-robin 与 exploration；权重主要用速度。本项目 V3 不照抄轮转，采用预计完成时间+健康度+在途负载的动态派发。
- autoConcurrency 结合吞吐、buffer、deadline、试升/回撤、429 等限流降载；网页版可选并发包含 32/64/128，PiliBoost 初期只暴露 Auto/4/8/12/16。
- native-mse-player 通过 generation cancellation 处理 seek、SourceBuffer quota 与按时间预读。

移植：Range 验证、任务队列/代际取消、有限重试、ordered streaming、健康度/预算思想。不要移植 MediaSource/SourceBuffer、接管网页播放器、JS runtime、直播加速。mpv 已做解复用，本项目不先自己解析 SIDX 再重写播放层。

## 4. 推荐插入点和统一架构

首选：页面完成质量/codec/音频 representation 选择以后，`playerInit()` 的 NetworkSource 构造之前，由独立 adapter 生成播放源。所有质量/音质切换都走同一 prepare 接口；不是在 Media.open 或 mpv native 源码里拦截。

```text
selected DASH video/audio + original URLs + metadata + original CDN setting
                    ↓
              PlaybackSourceAdapter
       OFF / file / live / durl → 原 NetworkSource / FileSource
                    ↓ enabled
        一个 AcceleratorSession（video/audio 子资源）
                    ↓
 Resolver → Probe/Health/EWMA → Decision/Diagnostics
                    ↓
 V1: 直连优选 URL；必要时单上游透明转发
 V2: 单 CDN video Range scheduler，audio 普通 CDN
 V3: 多 CDN video Range scheduler，audio 普通 CDN
                    ↓
       有限 cache / 有界 ordered output / backpressure
                    ↓
     localhost Range server（V1 透明转发或 V2/V3 video）
                    ↓
      原 NetworkSource → 原 EDL → media_kit → mpv
```

职责只存在一份：Resolver 负责合法候选，Health 负责测量与冷却，Decision 负责是否切线，Scheduler 负责派任务。设置测速和 session probe 共用同一预算/统计服务，而不是单独跑另一套排名器。

OFF 必须在构建服务、绑定端口、发 probe 之前返回原始函数结果。mode 只属于网络 DASH 播放；保持原 CDN 设置、disableAudioCDN 意图。API 候选完整保留，显式 CDN 设置作为初始优先/配置策略，不把旧选择删除。

### 4.1 V1 运行时观测的工程取舍

仅把 getCdnUrl 变成“测试最快 host”还不够：直连模式媒体流量由 mpv 读取，Dart 没有浏览器 XHR 那样每个请求的 bytes/time。

建议分小步：

1. V1a：独立 resolver + bounded Range probe + EWMA/冷却 + 设置默认 OFF。原地址马上开播，后台最多测试 1–2 个候选；读取 bufferAhead、buffering、NativePlayer cache-speed 作为辅助。必要切换通过现有重新初始化路径保存位置/速度/暂停/轨道。
2. V1b：如果要逐 CDN 测量、失败 Range 换线而不 reopen，加单上游透明 Range Proxy。每个播放器请求只对应一个上游请求；video/audio 均可 Smart CDN，不拆块、不多线程、不主动预取。记录所有请求真实 goodput，切换在请求边界生效。

V1a 不声称掌握音频每条 CDN 的精确吞吐；V1b 不等于 V2。持续 open-ended 请求不能靠“改变 session.activeHost”立即切换正在传输的 socket：要明确在有限检查点截断重试/有界重连，或受控 reopen；先在实验中验证 mpv 恢复方式。

## 5. localhost HTTP Range Proxy 可行性

### 5.1 本轮实际验证

新增 `tool/phase0/localhost_range_probe.py`：仅独立 HTTP/native transport fixture，不是生产 Accelerator，不是 Python/JS runtime 集成。

采用锁定 media-kit Windows CMake 指定的库：

- `mpv-dev-x86_64-20260607-git-43b14a4.7z`
- 下载地址为原 CMake 中的 GitHub release URL。
- MD5 实测 `b84900bbc6fcb995ca6a24f62bee671f`，与 CMake 一致；DLL SHA256 在 evidence.json。
- DLL 报告版本 `mpv v0.41.0-725-g43b14a4c9`。

本机运行两个随机 loopback 端口：fixture origin → 单请求透传代理 → 客户端 / 同版本 libmpv。测试 closed/open/suffix/clamped range、HEAD、无 Range、416、无效 token；native 使用合成 120 秒 WAV、空音频输出，载入并 seek 到 80 秒继续推进，观察 `Range: bytes=0-`。全部通过并关闭服务。

结果：**Windows 当前 libmpv 可以把 localhost 看作普通 HTTP 可 seek 媒体；没有需要 fork media_kit/mpv 的证据。** 前向 seek 可能在 FFmpeg 内部读过已有流，不保证每次 seek 都产生新 Range。不要把 time-pos=80 等同为观察到某一新 offset 请求。

尚待验证：Dart HttpServer 实现、完整 Flutter media_kit 路径、DASH EDL A/V 同步、真实视频、多 Range、异常中断后的恢复、五平台 release 包、硬件解码、PiP/后台和网络切换。WAV 测试不证明这些。当前没有海外 CDN benchmark 数据。

### 5.2 HTTP 与字节一致性契约

生产服务用 Dart `HttpServer.bind(InternetAddress.loopbackIPv4, 0)`；127.0.0.1 避免 localhost IPv6/DNS歧义，系统分配端口；只绑定 loopback。随机 session token 仅映射既定资源，不接受任意上游 URL 参数；关闭后失效，不在 release 日志泄露签名/token。

来源：[Dart HttpServer.bind](https://api.dart.dev/dart-io/HttpServer/bind.html)。

- GET/HEAD、200/206/416 语义正确；返回 Accept-Ranges、准确 Content-Type/Length/Range。HEAD 无 body；无 Range 的 200 可以持续流式传输，绝不完整读入 RAM。
- 支持 `bytes=N-M`、`bytes=N-`、`bytes=-K`，依据已验证 total length 归一化。非法和多区间 header 单独分类：初版不拆 multipart；可忽略 unsupported Range 返回有界流式 200，或后续实现 multipart，别伪装单 206。PoC 只覆盖单区间协议，不是生产完整 RFC 实现。
- CDN 小 Range 预期 206；核对 start/end/total、Content-Length（若存在）、实际 bytes、预期 chunk size、跨候选总长/validator。设置 Accept-Encoding: identity，禁止透明解压改变 offset。
- 上游 200 忽略 Range 时立即中止 bounded probe/分块请求；禁止截取随便一段假称 206。若证明只支持顺序读，绕回原始播放，不把整个文件下载后 slice。
- 403：区分单 CDN 拒绝、签名过期/认证失败；404 尝试合法备用或结束资源；416 重新核对总长及请求边界；429 按 Retry-After/冷却降低全局请求数；5xx、timeout、reset 做有限 retry/退避/failover。所有候选同类拒绝时上报 playurl 刷新，只允许有限 refresh 次数。
- URL 刷新必须保持 aid/cid/representation/codec 身份，不把新资源混入旧 cache。跨 CDN 数据至少验证长度、ETag/Last-Modified（可用时）、初始化元数据一致性；这些不是强加密同一性证明，未确认镜像一致时保持单源。
- 已发给 mpv 的 body 字节不能撤回；上游损坏不能用别的 offset 补齐。只在校验完整 chunk 后输出，保持严格连续前缀；中途故障在原 offset 重试/结束连接并通知 adapter 恢复。

### 5.3 V2 必须避免“先下载整次请求再拼接”

mpv 可能请求 `bytes=10485760-` 到 EOF。应把它看作一个消费者流：按固定大小 rolling chunks 调度，有限并发/在途字节/重排窗口，按 offset 连续输出并等待 backpressure；**不是对 EOF 整段 Future.wait 后返回**。

只有已验证的 chunk 可进入 cache/输出；offset 去重，重复请求共用受引用计数约束的任务。客户端断开或 seek 后立即撤销无消费者且低优先级的任务；一条连接取消不应误杀仍被 audio/其他请求引用的任务。

播放时间不能用 `bitrate × seconds` 精确映射 VBR offset。初期优先实际 mpv Range demand 附近的字节；mpv 负责 init/index 和时间 seek。只有必要时额外解析 segmentBase/SIDX 做更精确时间预读。

## 6. 五平台风险与处理

| 平台 | 当前源码证据 | 风险/下一验证 |
|---|---|---|
| Android | Manifest 有 INTERNET；未发现 usesCleartextTraffic/networkSecurityConfig；native libmpv + audio_service | 需 release 实机测 127.0.0.1；不要推断 Java cleartext policy 必然阻断或必然不影响 FFmpeg；必要时仅 loopback 定向允许。后台/PiP 下 Dart 服务与 socket 持续运行、电量、Wi-Fi→蜂窝、系统回收要测 |
| iOS | Info.plist 有 background audio、DLNA local network 描述；未配置专门 ATS localhost 例外 | ATS 对实际 native HTTP 栈的适用性要测，不套用 URLSession 结论；loopback 与 LAN/DLNA 权限不同。后台/PiP/锁屏暂停 isolate 或服务导致播放停顿是重点；不先全局 NSAllowsArbitraryLoads |
| Windows | 锁定版本 libmpv 原生 loopback/WAV/seek 实测通过 | Flutter EDL、两个资源、代理环境、断连/端口释放还待测；系统代理不得把 loopback 送远端；session 临时文件清理和 app 退出要测 |
| Linux | 原生 media_kit；存在专门构建 workflow | distro/沙盒 Flatpak/Snap、资源限制、IPv4可达、libmpv 构建差异需测试；常规 loopback 没看到架构级阻碍，不等于已通过 |
| macOS | DebugProfile 同时 network.client/server；Release 只有 client | **已识别配置缺口：Release 应补 network.server entitlement**，只用于 loopback service；release 签名/sandbox、休眠、后台和 ATS实际栈要测。这个配置问题不构成重写 mpv 的理由 |

资料：[Android cleartext 配置](https://developer.android.com/privacy-and-security/security-config)、[Apple network.server entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.network.server)、[Apple NSAllowsLocalNetworking](https://developer.apple.com/documentation/bundleresources/information-property-list/nsapptransportsecurity/nsallowslocalnetworking)。这些是风险依据，不是五平台运行结果。

mpv `http-proxy`/环境变量与本地资源需要单独验证，保留远端 Bilibili 代理设置但绕过 loopback。buffer 属性定义依据 [mpv 手册](https://mpv.io/manual/stable/#properties)；它是近似值，不能直接当剩余秒数，更不能当 audio/video 全轨道保证。

## 7. 建议新增目录与职责

```text
lib/services/video_accelerator/
  accelerator.dart                 # facade，模式 gate、会话替换、dispose
  accelerator_config.dart          # 默认 OFF，所有阈值/预算/实验参数
  accelerator_session.dart         # resource identity、networkEpoch、generation
  playback_source_adapter.dart     # prepare source / original-source recovery
  cdn_resolver.dart                # API 候选+保守 host 镜像扩展；不改签名参数
  cdn_probe.dart                   # bounded真实媒体 Range，取消/超时/计量
  cdn_stats.dart                   # 单位明确的 metrics、fast/slow EWMA
  cdn_health.dart                  # error归因、TTL、cooldown、half-open
  accelerator_decision.dart        # V1 switching / V2 auto / V3 policy
  accelerator_diagnostics.dart     # 不泄露URL签名的快照/benchmark计数
  local_stream_server.dart         # V1b 透传；V2/V3 ordered output
  range_protocol.dart              # header parser、Content-Range validator
  range_task.dart                  # offset、priority、deadline、generation
  range_downloader.dart            # V2/V3有限retry、连接取消、严格验证
  range_scheduler.dart             # V2单源；V3加权、在途负载、seek取消
  segment_cache.dart               # V2/V3字节窗口、LRU、临时文件配额
lib/pages/setting/pages/streaming_accelerator.dart
lib/pages/setting/pages/accelerator_diagnostics.dart
test/services/video_accelerator/   # fake clock / fake transport / HTTP fixture
docs/accelerator/                  # 本报告、阶段验证和 benchmark
```

这是阶段路线图，不是第一轮把全部文件空壳落地。V1a 先实现 config/session/adapter/resolver/probe/stats/health/decision/diagnostics 与对应 tests；V1b 才接 server/protocol。V2/V3 稳定后再增加 scheduler/cache。

## 8. 需要修改的现有文件：最小集中改动

| 文件 | 阶段 | 目的/约束 |
|---|---|---|
| `lib/pages/video/controller.dart` | V1 | playerInit 的 NetworkSource 前调用 adapter；传原 video/audio representations、bitrate/duration 与原远端 URL；初次和 updatePlayer 统一接入；reset/quality change 更新 session。下载/投屏继续使用远端 URL |
| `lib/plugin/pl_player/controller.dart` | V1/V2 | 最少量 attach/replace/final dispose hooks；seek前通知generation；错误恢复串行化；保留 EDL、字幕、SponsorBlock、历史、速度、PiP/后台逻辑。最终 dispose 才结束仍由播放器持有的 session |
| `lib/utils/storage_key.dart` | V1 | 新设置 key，字符串 mode/合法并发；旧 CDN enum index/name 不动 |
| `lib/utils/storage_pref.dart` | V1 | 新配置读写默认OFF；不改旧 buffer/CDN defaults |
| `lib/pages/setting/models/video_settings.dart` | V1 | 加一个通往独立“播放加速 / Streaming Accelerator”的入口；复用已有导航方式，初版不新增整个设置分类 |
| `lib/pages/setting/widgets/select_dialog.dart` | V1后续 | Accelerator启用时让手动测速复用统一probe，OFF保留原测速；不删除CDN选择 |
| `macos/Runner/Release.entitlements` | Proxy落地时 | 补齐 network.server；Debug已有，不盲目扩大其他权限 |
| `.github/workflows/build.yml` | V1 | 核对 fork 的仓库判断与发布名称；PR条件仍写上游且PR触发被注释。增加独立analyze/test CI；保留原构建patch流程，不为分析运行有全局git副作用的patch脚本 |
| `README.md`、`README.en.md`，新增 NOTICE | V1 | PiliBoost新功能说明、默认OFF、分阶段能力、参考与许可；中英文对应 |

`video_utils.dart`、`cdn_type.dart`、`data_source.dart`、`http/video.dart`：**V1默认无需修改**。尤其不要把同步 getCdnUrl 改成全局 async，扩大所有调用方改动。候选扩展由 resolver/adapter 包装原函数，必要后续仅抽无副作用 helper。无需修改 media-kit 依赖、mpv native source、下载、直播及本地播放。

若选择整个设置分类而非独立页面入口，才额外修改 `models/common/setting_type.dart` 和 `pages/setting/view.dart`；不是首选。所有原文件 hook 注释使用 `PiliBoost Accelerator integration point`。

## 9. 分阶段实施与验收

### V1 Smart CDN（先 V1a，后 V1b）

1. 建立 config/mode 默认OFF、纯Dart resolver/health/metrics和fake测试，API全候选去重。只对已知可替换 upgcxcode mirror 创建少量合成候选，mcdn/302/akamai 等逐类证明后开放；新模块不用固定唯一CDN。
2. `requiredBps = bitrateBitsPerSecond × safetyFactor × playbackSpeed`，初始 safetyFactor=1.5 集中配置。单轨使用bandWidth；总链路用video+audio。没有可靠bandWidth时用 `contentLength × 8 / durationSeconds` 并标为估计/置信度低；不要把bytes/s与bits/s混算。
3. 原源立即起播、后台probe（例如最多2候选、每个256–768KiB、总字节/超时预算）；采用相同Range比较，probe在buffer正常时暂停，不为测速无限读取。
4. 统计请求起止、headers/首body byte、传输bytes、成功/错误/timeout、最近成功；DNS/connect时间只有transport实际提供时记值。Dart/Dio普通计时不是TCP RTT，TTFB也不是RTT；未测量字段为null，不能填0伪装精准。若需分DNS/TCP/TLS，单独受控ConnectionFactory/Socket实现并验证复用影响。
5. 低缓冲+持续低于目标才挑战，最少样本量/持续时间，EWMA、switchGain（例如1.5，不是safetyFactor）、minStateDuration、minSwitchInterval、失败冷却、half-open。seek/暂停/quality change不记成CDN失败。
6. 在 V1a 保存状态受控reopen，序列化与原refreshPlayer；任何准备/打开/运行错误提供原源恢复路径和一次性bypass latch，避免重试振荡。V1b单上游透传可按请求换CDN，不分块。
7. 设置只开放OFF/Auto/CDN优选；“多线程”“多CDN多线程”以未发布状态禁用，不能显示可用却静默做别的事。视频和DASH audio允许Smart CDN，尊重旧音频配置。
8. unit：scoring/EWMA/sample不足/TTL/cooldown/迟到probe/同资源候选/签名刷新/OFF零网络操作；widget设置持久化；DASH播放及所有保留功能回归。通过后再推进V2。

### V2 单CDN多Range

1. 先完善严格protocol、bounded chunk downloader与单源scheduler、有限cache；audio保持普通CDN，保留原EDL。
2. 手动4/8/12/16；Auto 从较低档开始，按真实聚合有效bytes/墙钟时间、bufferAhead、目标bitrate升档。不要把并发每条速度相加当作端到端聚合；已缓存字节/重复retry不重复计goodput。
3. 缓冲充足逐档降，最少状态驻留、试升有效才保留，429/network change降载；达到目标立即停止增长，不用分辨率固定规则。
4. session + resource + networkEpoch + generation 标识每个task/cache；seek显式通知先取消旧代低优先级任务，当前mpv请求最高，init/index高优先；旧结果不能进入新代消费。不因正常位置事件每秒取消全队列。
5. cache限制 maxMemoryBytes/maxAheadBytes/maxBehindBytes/maxConcurrentRequests；总在途+重排+缓存一起受预算约束。临时文件 maxDiskBytes、session命名、磁盘满/异常退出清理；mpv已有缓存单独计入。
6. unit：parser/splitter/完整性/ordered merge/priority/timeout/retry/client disconnect/cache eviction/seek cancellation；HTTP fault fixture覆盖200、206、403、404、416、429、5xx/reset/截短/错误total；实机快速连续seek、质量切换、退出/后台。

### V3 多CDN多Range

1. 仅使用已经确认同一representation字节身份的候选；未知镜像先验证再进入pool。
2. 动态按 `estimatedFinish = queuedBytes / effectiveGoodput + TTFB + failurePenalty` 比较，结合在途负载、timeout/error、近期稳定性选节点；未测候选限量探索，不做blind round-robin。
3. 更快稳定线路多分，连续失败cooldown，过期少量half-open，恢复再入pool；单一签名过期归因到resource不是网络所有host。
4. generation/网络变更清空或衰减旧健康数据；Connectivity事件只是接口提示，不证明互联网可用；桌面还要处理同为Ethernet时的路由变化/请求失败触发重新评价。
5. 防抖Auto状态：NORMAL → LOW_BUFFER → ACCELERATING → RECOVERING → NORMAL；多Range先升一档，仍不足再扩大CDN，恢复缓冲后逐步缩小。最低驻留与冷却统一Config，不会4→32来回跳。
6. 多CDN正确性与带宽收益回归/海外benchmark通过后，才讨论Auto成为默认。直播仍不纳入。

## 10. 生命周期、错误回原源与原版功能保护

加速错误处理不是只在prepare外catch：还需处理 `Media.open` 失败、运行期代理错误、URL过期、Range不支持、网络切换。恢复原始视频/音频URL，通过现有playerInit/setDataSource保留position、play/pause、speed、volume、画质/音质、字幕选择，最多一次原源恢复并对当前会话禁用加速；原源本身失败继续显示正常播放错误，不承诺所有视频必成功。

后台/PiP可能页面onClose而player仍活跃，controller也有引用计数，所以session应由播放源 lease/最终player dispose持有，不能只页面onClose就关闭localhost。页面reset与质量变化先用generation撤旧，再在新源绑定成功后释放旧源；准备异步返回必须检查其session仍为当前。

保持功能的检查清单：DASH视频与分离音轨/同步、画质/音质切换、seek/进度、弹幕、字幕、SponsorBlock、FileSource、本地/后台/PiP、历史、倍速、断点、下载、原CDN；额外检查只听音频与DLNA远端URL。每项都对OFF与ON作成对检查，报告不把源码未改等同为运行期验证通过。

## 11. 测试、CI与benchmark记录

本轮已运行：

| 命令/输入 | 结果 | 状态 |
|---|---|---|
| `git rev-list --left-right --count origin/main...upstream/main` | `0 0` | exit 0 |
| `git diff --exit-code`，生产源码基线 | 无输出 | exit 0；新增未跟踪文件另外列出 |
| 参考accelerator：Node `--test` | 115 tests / 115 pass / 0 fail | exit 0 |
| thread-ripper：Node `scripts/build.mjs`，随后设置bundled NODE_PATH并执行 `dev/run-tests.js` | 5个unit组+4个browser组全部通过；未配置BTR_TEST_BVID/CID，真实视频测试跳过 | 最终exit 0；首次缺playwright的失败也保留在参考目录日志 |
| Python fixture + locked Windows libmpv | `HTTP_CONTRACT PASS 8 cases`；`WINDOWS_LIBMPV PASS duration=120 seek=80 http-range-observed=true`；`CLEANUP PASS proxy-and-origin-closed` | exit 0 |
| `flutter analyze` / `flutter test` | PowerShell `The term 'flutter' is not recognized...` | CommandNotFoundException，无Flutter进程exit code；未通过验证 |

Flutter要求由 `.fvmrc`/pubspec声明：Flutter 3.47.5、Dart>=3.13.0。当前PATH未配置Flutter/Dart。后续需要匹配SDK并按原CI patch流程准备，先运行原基线，再跑V1同命令；不把任意未patch SDK analyzer大量错误归为本模块。现有只有 `test/utils/accounts/deleted_account_test.dart`，无视频加速测试。

现有CI是Android/iOS/macOS/Windows/Linux构建，未发现flutter analyze/test步骤；build.yml中PR触发被注释，仓库条件仍指上游。V1补独立analysis/test workflow，平台构建使用原workflow，远端运行需另行实际触发并记录，不伪造本轮结果。

Benchmark必须用真实日本海外网络，冷门1080P/1080P60/4K/4K60；同账号、codec/质量/视频、时间和网络，OFF/ON交错重复，多样本避免热CDN缓存偏差。Wi-Fi/4G/5G及切换另组，记录：

```text
runId, appSHA, mode, networkEpoch, videoId, representationId, codec,
bitrateBps, safetyFactor, startTime, sampleWindowSeconds,
mean/P10/P50/P95/min throughputBps,
bufferEventCount, bufferTotalSeconds, startupMs, seekResumeMs,
mean/peakConnections, distinctCDNs,
usefulBytes, upstreamBytes, retryBytes, probeBytes, downloadedUnusedBytes,
downloadOverhead = (upstreamBytes - uniqueUsefulBytes) / uniqueUsefulBytes
```

预定义buffer事件：播放意图为playing且排除启动/seek/主动暂停后的buffering区间，seek恢复单列；throughput分位只在有需求/下载活跃窗口统计，同时另外报告含idle的wall-clock均值。先以减少stall总时长且不显著增加startup/seek/流量为主验收；阈值需baseline样本确定，不虚构“提升X倍”。

Diagnostics显示bitrate、有效aggregate吞吐、bufferAhead、concurrency、active CDN、逐CDN throughput/TTFB/RTT（未测null）/errors/timeouts/weight/cooldown、active/queued ranges/cache/inflight bytes。V1 direct没有ranges则显示0/不适用；release快照按需或低频，错误聚合限速，不每秒刷完整URL日志。

## 12. 本轮交付和下一步

交付：本报告、可重跑的localhost协议/native探针、test logs、固定SHA/树/hash evidence。所有生产文件hash与main一致；没有加速UI或生产代码悄悄生效。

下一开发阶段是 **V1a Smart CDN**：默认OFF、候选池/真实Range probe/EWMA/冷却/设置与最小adapter，先恢复Flutter验证环境与原基线测试，再写纯算法unit tests，最后接播放；V1b单上游Proxy完成真实请求观测后再推进V2。不先上多CDN、不改mpv、不接JS、不重构全controller。
