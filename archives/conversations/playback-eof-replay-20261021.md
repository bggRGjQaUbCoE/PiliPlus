# 播放结束后无法重播或拖动（2026-10-21）

## Current State

**所有权迁移完成，迁移包短测及超过15分钟静置恢复通过；用户已授权本次提交、推送。** 当前 `goodwu-dev-rebased@9c77d6e97`，media-kit `98c611a3`，原EOF未提交修复与独立修改保留。实例级PlayerOwnerSlot接管替换队列、清理债和防重复释放，App显式共享实例，保留页面/业务/source guard；相对迁移前App生产净减79行。App14、库1048通过/8跳过、V2/目标analyze/源码构建通过。6155accc包LG切页/快速Back/EOF返回重播20s/EOF直接拖动/暂停拖动/HDR-SDR/退出重进通过。按用户最新指示将长测缩为15min：实际纯静置939.565秒，同源/进程/player且零API/输入；随后单次UI播放20秒真实SF推进，控件正常。之后再次真实EOF直接拖中段亦出帧；本轮不声称30min通过。Home仍有约20秒恢复迟滞，最后直拖后系统媒体会话位置基准未及时同步但UI/native/SF已推进，独立记录；原native销毁完成没有直接标量日志，不以view释放冒充。迁移六源末次hash与APK冻结一致，源码未再改。构建/短测/15min证据分别 `owner-migration/`、`owner-migration-device/`、`owner-migration-long-idle/`。

用户随后授权推送，三仓已核对远端HEAD一致：PiliPlus `feature/ohos@55509baa6`、media-kit `compat/piliplus-zero-change-20261018@98c611a3`、mpv `media-kit/android@1af17925fb`。临时诊断未提交/未推送，原页停留测试不受影响。

**历史第三包状态（不代表迁移包）：短测修复通过，独立31min静置完成但恢复未验证；新改动未提交**。第三包已完成：真实completed页返回重播起点暂停、单次播放20s、普通末秒paused返回保留位置；Home后无输入20→30秒SF持续恢复（有迟滞，非即时）。第二包已通过自然EOF直接拖动、主动暂停后拖动、SDR/HDR，相关代码未再改。gen6真EOF静置t0北京时间17:53:13.255695，18:24:30只读证据确认经过1876.879秒，同源/进程/播放器且零输入/API/源变化；18:25:41首次点空白处控件未显示，未点击播放、未seek，现场保留。因此不能将长时重播记为通过或原生死锁。证据 `navigation3-long-idle/final-stage-summary.json` 与 `reveal-controls-freeze`。计时前gen5极近尾seek缓冲和未明refresh独立保留，不算EOF/静置失败。此前首轮31min首次重播前被用户切页改变源，仍只是历史未定实验。

旧现场已保存并复现，但在同进程重进同视频后，立即EOF重播、EOF后直接seek、熄屏唤醒、全屏EOF自动退竖屏均成功且命令reply0/真实新帧。不能宣称初始故障已修好。此前已验收 gamma+3 已提交并推送；本轮 App/media-kit 修复及临时诊断仍未提交，mpv无新增改动。取证根目录 `/tmp/pili-eof-20261021/`。下面各历史区保留当时状态，不当成当前屏幕状态。

## 初始现场

用户在已验收提亮候选上报告：播放完成后不能再次开始，拖动进度也无效，当前现场仍保留。调查中，不提交。已安装包 `pili-brightness-20261021-release.apk` SHA256 `16bd9761a71d6df26f0c31b9c4e49472b8ebe8faee610eb52cfe2c39a58869ff`，PiliPlus.dev PID3277，北海道视频；初始 MediaSession state2 position1170730ms，此值为会话更新基准，不能单独证明当前mpv状态。先采完整日志/图层/会话状态，再复现play/seek；不重开App覆盖现场，不触PiliPlusX。

保留media-kit当前未提交gamma+3和测试、文档；其面板验收结论见 `video-gray-getx-20261021.md`，与本次EOF问题分别验收。目标优先在media-kit修复；需覆盖自然EOF后重播、EOF后seek、重复结束、HDR/SDR与画面帧推进，构建安装不替代实机验收。

## 首轮现场与分支实验

- `/tmp/pili-eof-20261021/summary.json` 和 baseline/play-at-eof/seek-after-eof/double-tap：旧现场已复现，UI播放、129ms有效双击raw seek/play、拖动到09:45均无新SF帧；会话仍state2、1170730ms，UI时间会变。无直接mpv property/command回读，不能区分命令未完成与seek后的解码/网络失败。debuggerd只读回溯被权限拒绝，没有提权或信号终止。
- 原进程不force-stop，退出页面后同北海道深链重新获取源，15:15:08 nativeHdr/HLG/baseLayerConvert/PQ applied verified=true。两次近片尾后自然EOF均可恢复：第1轮按钮重播state3/position0且新SF帧；第2轮直接拖到中间自动恢复，position585017且新帧。不能将“重进恢复”当成原故障修复；旧源或长会话相关仅是假设，未发现明确HTTP403。
- 代码排查：routed/session不直接因EOF退租或清ready；播放按钮本身走raw player，排除“仅routed gate失效”充分解释。mpv给当前同项playlist-pos赋值不重载。MediaCodec flush源码正常清EOS，但当前没有原生线程栈证实运行行为。
- App `seek(isSeek:true)` 等buffer.first是独立潜在隐患，但当前slider和水平拖动均显式isSeek:false，不解释本现场。临时小修已精确撤回，补丁留 `/tmp/pili-eof-20261021/deferred-buffer-wait.patch`，App业务代码未新增改动。
- 下一步：库内临时、默认关闭的标量transport诊断，区分API入/锁取得/seek submit/reply/EOF/hook；保护签名URL不入日志。询问用户失败是否紧随EOF或长时间放置；需复现后再决定行为修复，不凭假设改codec或强制重开。

## 临时诊断与扩展复现（进行中）

- 仅media-kit native `real.dart` 临时加入默认关闭的 `MEDIA_KIT_TRANSPORT_TRACE`，包含本地player标识、API/锁/命令提交和回复、EOF及hook标量；不记录地址。Dart分析通过，补丁在 `/tmp/pili-eof-20261021/trace.patch`，最终需根据调查结果撤回无用诊断，不作为行为修复。
- 源码诊断APK `pili-eof-trace-20261021` 构建中。短EOF确认诊断后，优先覆盖EOF后熄屏/唤醒再重播（App在completed后500ms关闭wake lock，属实际源码事实；是否相关未知），然后视结果从0连续1x播放到自然EOF。没有确认修复，不提交。

## 诊断包短测结果

源码诊断APK安装成功：SHA256 `433b04c12499843ac166b4878295d711b80d5c5a8cb3d9a5a4016de7a8b65169`，包内libmpv `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a` 与本轮源码shipping一致。新PID10190；短EOF后熄屏/唤醒/原页重播通过：15:24:16 raw seek0及pause属性均reply code0，随后eof=false、state3、SF新帧。没有复现原故障，也未见bridge not initialized；不能以潜在源码生命周期缺口为本次根因。证据 `/tmp/pili-eof-20261021/trace-wake/`。15:24:17起从0、1x连续播放，不跳转，等待约15:43:47自然EOF（缓冲会顺延）。

## 全屏退出分支

原19.5min连续测试在约3分钟暂停计数（正常片段保留，不当作完整EOF）。新加入真横屏全屏→近片尾自然EOF→自动退竖屏：15:28:02结束后按钮重播同样成功，seek/pause reply0、eof=false及新SF帧；待第二轮退全屏后直接seek及全屏完整1x。纯尺寸更新经android-surface-size→external resize，不主动vo=null；所以未实际发生bridge shutdown/reinit前不能以源码假设归因。

## 提交范围（2026-10-21）

用户在31分钟被动停留测试期间要求“先把代码提交了”。本次本地提交只包含此前已验收的gamma提亮及测试/任务记录；本EOF上下文归档当前调查事实，不宣称已修复。native transport/deadline临时诊断留工作区，不纳入提交；App业务代码没有新增改动，mpv没有新增改动，不推送。31分钟测试继续，不因Git提交重启App或换包。

## 长停留期间的源码补证（不是现场根因结论）

- FFmpeg HTTP>=400原始日志为WARN，App release只请求ERROR；media-kit只把特定ffmpeg/tcp ERROR转stream.error。因此没有HTTP403日志不能排除地址失效，mpv的demux底层seek失败也可能只记VERBOSE而command reply仍0。
- NativePlayer非strict seek负返回只记logController，随后仍清completed；错误卸载若已无active file，App先raw seek再play可清掉play()的playlist-pos重开条件。此边界源码闭合但没有现场END_FILE ERROR/idle-active证据；单独strict:true会让App提前抛错，不能作为完整修复。
- App buffered来自demuxer-cache-time的缓存末端媒体时间，不是当前目标可读缓存；unavailable被忽略时可能保留旧值，buffered==0的重试条件有盲区。现refreshPlayer只重开原Media，不重新查询B站地址。
- Codec flush失败原始返回也存在不易传到stream.error的路径，但尚未证实真实发生；不改flush/decoder，不增加无依据超时或强制重开。
- 没有现成native fake绑定seam，现有player-seek-after-completed仅成功EOF5秒后seek；本机mpv现有Ninja目标均Android，未使用预编译/旧源码本机库冒充Debug测试。

备用增强诊断包 `pili-eof-state-20261021-release.apk` 已源码构建（SHA256 `1aae1fc2ee0167a852a62c1f7b61a1e931e466b1fc5133d20f2720f213e3999e`），未安装，避免打断当前31min停留。增加deadline倒计时/END_FILE reason+error/idle-active/bufferMs，trace=true才请求WARN且最多16条HTTP状态/codec-flush/decode固定分类，绝不打印原地址/host/原文；默认关闭。静态分析通过，构建身份见 `/tmp/pili-eof-20261021/state-build/artifacts.json`。本次全部诊断源码仍未提交。

## 31分钟门槛后用户切页（新现场）

- 16:04:09.822只读baseline已满足31min静置，state2/1170730，Awake，代理无输入；在控件揭示后，真实播放按钮位置发生变化，verifier按截图核对，尚未点击play。
- 16:05:15开始出现on_unload/on_load、多player、132000位置、KEYCODE_BACK；用户随后明确“刚才点到过其它视频页再退回来的”，与日志一致，非未知自动动作。verifier只有16:04:27揭示控件和16:05:25点空白核图，未点击真实play，后续输入冻结。
- 当前返回原页spinner，收集新现场并调查跨视频page push/pop时旧Routed会话与HDR owner恢复。31min结果只能标INCONCLUSIVE（恢复前用户切页改变源），不能写PASS或将其归因为纯idle。

## 切页回归归属与修复进展

- Git 对照：HDR 接入前挂载条件包含 `!videoState`，隐藏页移除播放器；`7e2ec4280` 为允许 routed open 前挂载，将条件放宽为 playback 已存在即可保持挂载，遗漏页面可见性。`a01f8ff53` 引入 catch-all fallback 与无身份/串行保护的替换路径。两个页面共用 singleton Player，现场同 handle/gen 对应两个 native view，旧 view dispose 后新输出事实被清空。
- 日志 `trace-short/live.log`：16:05:42 旧 review budget exhausted / Routed open superseded 后，App catch-all 仍走 legacy fallback，毫秒间出现多个 Player；返回原页标题与另一视频进度混合。因而“切其它视频再返回”这条已观察故障链属于我们改动的回归，不能归责上游原生 PiliPlus。
- 修复：App 恢复隐藏页卸载，给源请求/异步副作用加代次保护，取消不进入 fallback，创建/替换/最终释放串行且保留未完成清理；media-kit 用 session generation + backend serial 协作取消旧 review，排队等待可取消，已发出的 native read 必须排空后才释放锁。20s 是采样预算，不承诺挂起 native read 在 20s 内物理结束。
- V2 静态复核当前无代码阻断。App focused 6/6、media-kit focused 59/59、库全量 1038 通过/8跳过。库侧首轮有 1 旧测试先等超时再释放 read，与新 drain 契约循环等待，已修正为预算后断言 review/同锁后继均未完成，释放 read 后断言 timeout 且无后续读取；全量首轮发现 testing 实例方法扩大 implements 接口，已改为私有生产谓词+同库测试 extension，原 widget fake 无需新增实现，V2 补审通过。真实 controller 完整故障注入与 native view 交错仍需验证，不以 helper 单测代替实机验收；源码构建进行中。

## 导航修复候选构建

唯一源码入口 `../media-kit/tool/build-android-test.sh` 已构建成功，tag `pili-eof-navigation-20261021`、trace=true。APK SHA256 `4cfa0a9e56c11511743be223a99bc82b3fe1dc67c6c6f47af3236aefc0fcf47f`，包内 libmpv `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a` 匹配当轮源码 shipping；native manifest 源 hash 全部匹配、Dart hash 构建前后不变。证据 `/tmp/pili-eof-20261021/navigation-build/artifacts.json`、`full-tests-final.log`。构建时 Flutter 自动增加的两条 macOS Pods include 已精确移除，其余未知修改未动。实机回归进行中，尚不宣称故障已修复。

新增 App 测试 `test/plugin/pl_player/player_source_lifecycle_test.dart` 被既有 `.gitignore` 的 `test*` 规则忽略；当前在磁盘上，未暂存。后续提交需显式纳入；跨分支迁移应另行备份该文件，不能仅依赖 `git stash -u`。

## 导航候选实机与重播入口漏接

- 已装APK4cfa0a9e…，PID15391 / player23252125；稳定A→B→Back→A、B尚未applied时0.45秒快速Back、第三轮返回均恢复A nativeHdr/PQ applied、正确标题及SF新帧，单Player、零fallback。第三轮B早期10秒采样未覆盖充分出帧，不单算通过；后续EOF→B场景延长到applied后补证B持续新帧。
- 234ms Java surfaceCreated交叠经architect判读并非双有效producer：临时gen4 view随后释放，最终A在gen6重新init、MKSURF create、verified applied；surfaceCreated不等于锁内bind/accepted owner，旧destroy未破坏最终A。允许动画暂态view重叠，不允许长期隐藏页双挂载、迟到dispose清掉最终owner或回退风暴。
- A真全屏近尾自然EOF自动退竖屏后→B→Back，A gen9 nativeHdr/PQ applied、控件与raw位置1170730ms正确；Android MediaSession暂停base短暂保留B值，不用它代替实际播放位置，重播后已更新0。单次按钮重播17:01:15 seek861/play862成功，2/5/10/20秒均state3及SF持续推进。
- 随后准备下一次EOF时，实际拖至19:25：17:04:07 seek863成功后明确pause864，A暂停在1165379ms，30秒不会自然EOF。没有用户pause输入，实际EOF→中段拖动步骤尚未执行。冻结证据 `/tmp/pili-eof-20261021/navigation-device/final-stage-summary.json`、`key-log-lines.txt`、`eof-direct-seek/freeze-final/`，自己的host logcat已停止，App保留。
- 真正调用链：按钮/双击→`onDoubleTapCenter` completed分支直接raw seek0/play，绕过routed desired intent；下一次`PlPlayerController.seek`走binding，重放旧desired=false而暂停。属我们routed集成漏接，不能归为native seek死锁。修正该App入口委托captured binding，并保护await后source/Player/binding身份；普通toggle同样委托binding，legacy仍raw。
- 独立审计另外找到三处同共享Player旁路：主播放器前后台暂停/恢复、post_panel片段预览play、本地下载单文件循环seek/play。它们纳入同轮必要接线修正；独立audio/gallery Player不动。不再称按钮是唯一漏口。App加小owner-check closure，后台恢复凭据、preview各await/位置listener、local seek完成后均验证source请求和Player/binding身份；保留各入口原UI/audiofocus策略，不引入raw状态镜像。
- 不实施library“seek不重放已应用play意图”的ledger方案：Native seek只清completed不恢复mpv EOF pause，现有重放true正是自然EOF后直接拖动恢复的保障。主动暂停后拖动应仍暂停、EOF desired=true拖动应恢复、paused-open尾部desired=false拖动应仍暂停而按钮重播必须显式play；新包将验证这些语义。亮度映射未改。
- 四文件补丁及owner closure已完成V2复核，preview helper返回bool后caller await恢复另有microtask间隙，两处已补caller即时current复核；App helper6/6再次通过。最终source前缀 controller15eea3a8、player view0f9f90e0、post23873a87、local16fc3f34。library生产与全量1038/8版本一致，未实施ledger；第二源码包`pili-eof-navigation2-20261021`构建中。preview/local真实UI fixture未验，不用helper测试替代这些路径。

第二源码包已构建成功，APK SHA256 `d16bbd3a6f0d5539f551b1f914a1a6f7fa76fd1bd649b0aead06636a88c1de90`、包内libmpv仍 `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a`；native source manifest及全部dirty Dart hash核对通过，库Dart与1038/8测试版本完全相同未重复跑。证据 `/tmp/pili-eof-20261021/navigation2-build/artifacts.json`。当前只做targeted接线回归，不重复首包三轮稳定导航；旧明确pause现场仍保留。新设备证据目录 `navigation2-device/`，未提交或推送。

## 第二包实机与完成页返回起点

- 第二包PID18205、单Player999788588，零fallback。播放中seek近尾后为play而非旧pause并自然EOF；真正自然EOF直接拖到585000ms恢复新帧；主动pause后真实thumb拖到405889ms仍暂停。不能将一次未触发seek的tap记为实现失败或通过。
- Home后surface重建，早期3秒无新SF，随后seek→play恢复新帧；只记“回前台后seek恢复”，无输入自动恢复观察不足，待新包独立被动采样。SDR gen4 sdrDirect与回HDR gen5 nativeHdr/PQ均有3秒SF推进。只停了自己的logcat，App留HDR播放；完整证据 `navigation2-device/final-stage-summary.json`、`key-log-lines.txt`。
- 新失败边界：真完成A→B→Back，新open位置1170621ms/标称1170730ms，差109ms、completed=false；原有50ms近尾判断不触发，按钮只play3、state3但20秒无新SF。返回新open有eof=false且没有true，不能宣称Native漏掉true EOF。证据 `A-return-eof-timeline.txt`、`boundary-observation.json`、`freeze-paused-open-tail-boundary/`。上游HEAD已有50ms规则；没有未修改版实机对照，不能据此把相同整体现象归给上游。
- 不扩大近尾阈值、不改Native.play猜EOF。第三小补丁只在didPopNext捕获的离页状态为真实completed时传`restartCompleted`，playerInit优先defaultST，其次重播起点zero，再经过原getFirstSegment片头策略，保持暂停；普通paused末秒、其他初始化/画质切换不改，playedTime/defaultST不新增直接写。两文件V2通过，既有hide Subtitle import warning不动；source view890acc18、video controllerb866e9c6。第三源码包构建中。
- preview/local缺真实UI fixture仍未实机；helper单测和静态复核不替代它们。独立原页>30min恢复仍未验证。

第三包源码构建成功，APK SHA256 `3c6a922c9ae262c91e2a76eded8e88e33b6c745b6540b87d5f9279dd3b7802cf`；包内libmpv仍81386a07…c79616a1a、source manifest核对通过、Dart hash构建前后不变。相对第二包只有授权的page view/controller两文件变化；库与1038/8基线相同未重复测试。证据 `/tmp/pili-eof-20261021/navigation3-build/artifacts.json`。放行定向实机：真实completed返回重播准备、普通末秒paused返回不reset、Home后充分无输入恢复观察；不重复已过的所有第二包测试，不提交。

## 第三包短测与独立长停留

- installed APK3c6a922c…7802cf，PID20286、单Player91670992/handle501085689424，零fallback。真EOF→B→Back后A在66ms、UI00:00/暂停，单次播放2/10/20秒SF持续推进。普通paused近尾1169076ms→B→Back返回1169101ms（+25ms定位），paused/completedfalse/eoffalse，未重置起点。
- Home前确认持续出帧，HOME4秒→bring现task，返回后零触摸/seek；2/10秒SF静止，20→30秒native format43层持续推进，state3。判迟滞自动恢复通过，不说即时。证据 `navigation3-device/final-stage-summary.json`、`key-log-lines.txt`，自有logcat已停；preview/local/显式start/片头/关闭autoPlay缺fixture，仍仅静态边界。
- 独立31min前置：一次tap没触发seek，不计；真实drag到1170000ms（距标称尾部730ms）→play后45秒buffering、没有eoftrue，已冻结保留 `navigation3-long-idle/precondition-buffering-freeze`。源TTL6472秒且无403，仅对当前源排除即将过期。随后blanktap/drag未产生新seek，却发生gen5→6源重开，触发方未完全定位，不能声称19:25seek成功或原缓冲已被seek修复。
- gen6于17:53:12.591真eoftrue；新独立baseline t0=17:53:13.255695（UTC09:53:13.255695、monotonic222785.447564），deadline=18:24:13.255695。t0-settled为A原页竖屏、state2/end1170625、SF静止，stayOn7/timeout30000/电源窗口只读归档，未改设置。接受这次新gen6 EOF后的独立静置，不混同gen5故障；t0后111秒同进程、零load/applied/API/输入。source仅输出SHA，不导出原URL。证据 `navigation3-long-idle/deadline.json` 与对应baseline。

## media-kit 迁移边界复核（只读）

用户询问能否进一步下沉以减少上游同步冲突。架构复核：review取消和原生输出校验已在库；可进一步设计显式共享的实例级 owner slot，承载播放器替换串行化与退休 owner 清理债务，但不能把 App 静态全局队列原样复制到库，避免不同播放器互相阻塞。须确实减少 App 创建/fallback 的所有权重复，而不是仅搬 helper 文件。

GetX 可见页门、completed 返回起点/片头策略、fallback 选择，以及后台/预览/循环调用接线仍由 App 决定。capturePlaybackOwnerCheck 包含 App singleton/计数/源身份，库 generation 不能完全代替。不能用 playing 事件自动同步 raw/routed 意图（EOF/用户暂停/内部 paused open 无法区分），也不通过底层隐式拦截改变所有客户；当前最小修复是 UI 委托已有 binding。可先内联 runIfCurrent 减少样板；本次仅评估，源码及设备未改，未新增提交。

## 所有权迁移实施与审核（2026-10-21）

用户授权按边界实施、回归、不提交。media-kit 新增并导出 `PlayerOwnerSlot` / `PlayerOwnerTransition`，显式实例级队列/清理债与弱key释放终态；不同slot互不阻塞，失败清理保留原owner/disposer，成功释放后重复请求不再次dispose。tx内直接清理不递归排队，结束后拒绝新retire并等待已提交清理。App static显式共享一个slot，init/fallback/unpublished/final-close接入；删除helper本地队列/清理机制并内联pause/rate source guard，保留业务判断和await前后身份门。相对迁移前快照生产代码净减79行（controller2161→2143，helper97→36），App helper测试162→46，库新增10项所有权交错测试。

slot10/10、App请求/回调2/2、双方目标analyze及diff-check通过；V2最终审查通过，无阻断。测试不替代真实controller/native失败/设备恢复验收，公共API要求retirement成功才创建后继，回调内不等待同slot另一个排队操作。源码冻结清单 `/tmp/pili-eof-20261021/owner-migration/final-source-hashes.json`：controller35dcf4fc、helper8cf231f0、slotdabc6891。完整测试及源码构建正在进行。

旧31min后续只读检查发现设备已由外部切至Links杜比视界视频，旧EOF控件现场不再可操作；此次零UI输入，不把新页状态归原故障，证据 `navigation3-long-idle-followup/summary.json`。新包须重新回归。

### 迁移后全量与源码构建

App完整14/14、media_kit_video完整1048通过/8跳过，均当前源码新跑。唯一入口 `tool/build-android-test.sh` 构建 `pili-owner-migration-20261021`（trace=true）；APK SHA256 `6155accc8a3bccc49bc10d1355511ed14a88b6054ae9c2fb741560746e81b39a`，包内libmpv、JAR内libmpv及本轮shipping均 `81386a07de9af47ff5deff8ad99c44574ac9b11cd01a34f99143322c79616a1a`。当前App `goodwu-dev-rebased@9c77d6e97`，6个迁移冻结文件与其他dirty Dart前后hash不变。macOS配置等HEAD无修改；未使用旧APK兜底，未提交。构建证据 `owner-migration/artifacts.json`。设备旧用户页只读baseline保存后，已安装此包并重新进入北海道A，设备回归进行中；不能以构建代替播放验收。

### 迁移后 LG 短测通过，独立31min进行中

迁移包6155accc已核installed SHA，PID25484。首A原生HDR/PQ verified且SF推进/控件可见；稳定A→B→A和B未applied即快速Back均单Player626814041、零fallback；真实EOF→B→Back A gen7 UI00:00/state2/66ms，单次play8后2/10/20秒SF持续推进。真实EOF后直接中段seek11→play12恢复；主动pause后seek13停在新位置，seek帧后SF静止，未意外播放。Home后无seek/换源20→30秒SF恢复，仍有此前迟滞，非即时。SDR gen8 h264/bt1886/texture与回HDR gen9 HLG→PQ均applied并推进。

退出到首页：旧view销毁、MKSURF shutdown/releaseSurface released、on_unload/endfile2/idletrue、MediaSession state0且原format43图层消失。重进新Player626019968/handle501083515984（旧626814041/500945403472），gen1 nativeHdr输出/控件/连续SF通过。代码队列要求dispose future完成才新建，但现有scalar日志没有明确mpv_terminate_destroy完成事件，不把view释放冒充native Player销毁证据。证据 `owner-migration-device/`。

长测前置真实seek1139502ms后自然EOF19:36:48.829；新独立t0北京时间19:36:49.970112（UTC11:36:49.970112、mono229002.163892416），最早恢复20:07:49.970112。A原页竖屏、PID25484/Player626019968/handle501083515984/gen1、state2/end1170664，SF静止；stayOn7/timeout30000只读未变。t0后56秒零source/API/touch，之后严格不输入，待完成才判长时重播。证据 `owner-migration-long-idle/deadline.json`。源码继续冻结，尚未提交。

### 用户调整静置时长

用户最新明确「别等30分钟了，先看15分钟的问题」。保留同一t0，恢复门槛改为15min：北京时间19:51:49.970112（mono229902.163892416）。原31min计划只保留历史，不再等待、不宣称本轮覆盖30分钟。到15min先只读基线，再揭示真实控件、单次play和20秒SF；若失败先保留现场，禁止seek掩盖。

### 迁移包15分钟恢复及最终EOF直拖

按用户指示停止31min目标，原deadline另存 `deadline-original-31min.json`，未把本轮标31min通过。15min只读基线实际939.565秒（19:52:29），PID25484/Player626019968/handle501083515984/gen1、A state2/end1170664，t0后零source/API/touch。控件真实显示并细像素匹配play三角score0，只点一次；19:52:53 seek4 target0→play5/6是单次UI经binding意图产生，非重复点击。2/10/20秒SF115639129472551→115647307735048→115657559886399推进，UI00:21/pause、MediaSession state3/base0，保持同源/owner。

最终19:54:57.161真实EOF后仅揭示控件并拖动，无点击play：seek9 target583748→play10/eoffalse，SF115772175329115→115775285042968持续推进，UI09:51/pause，同源/owner不变。系统MediaSession state3但旧base1170602未及时同步；不能把该旧base当native seek失败，作为元数据更新缺口单列，未扩改本轮迁移。六迁移源hash最终复核一致、两仓diffcheck通过，mpv无新增改动，所有改动仍未提交。

封包完成：合并短测与15min结论 `owner-migration-device/final-stage-summary.json`，独立静置结果 `owner-migration-long-idle/final-stage-summary.json`；首次恢复touch19:52:51.107之前零source/API/touch。两条自有logcat19992/93374均已停止exit130，设备留北海道播放，同PID25484/Player626019968/handle501083515984/gen1，零fallback。三仓HEAD/status与设备测试起点一致；没有实现、设置、提交或推送操作。

## 本次提交与推送边界

用户明确授权「提交、推送」。本次仅提交两仓正式EOF/切页恢复、review取消与所有权下沉修复及相关测试/验收记录，使用中文语义化提交信息。App在当前 `goodwu-dev-rebased` 推新PiliPlus的origin；media-kit在 `compat/piliplus-zero-change-20261018` 推origin。临时 `media_kit/lib/src/player/native/player/real.dart` transport诊断保持本地未提交；App TASKS 中独立仓改名/分支迁移段落、branch-migration归档和环境配置不带入。App请求辅助测试因test*忽略规则，按精确路径force-add；不扩大忽略配置。mpv无新增改动，不造空提交。不重跑未变化源码的已通过测试，提交前复核冻结hash与暂存差异，推送后以远端branch SHA核对。提交SHA以Git log为准。
