---
generated_from_state_version: 12
---

# 验证

## 当前结果

- 结果: **已归档**
- 验证情况: **已完成检查，验证结果已确认**
- 目标周期: 1
- 迭代: 3
- 验证器尝试次数: 1
- 完成时间: 2026-09-28T06:51:19.771Z
- 摘要: 候选 27114c45 通过 13/13 验收。核心修复在 lib/models/video/play/url.dart：findAvailableVideoQuality 增加 blockedQualities 参数，先剔除被屏蔽档再走原选档规则，剔除后无候选时退回旧结果，并新增 fallbackVideo 供 findVideoByQa 兜底。独立推演脚本（非 Builder 测试）穷举 4165 组输入确认空屏蔽集下与 HEAD 逐分支一致（唯一偏差是 acceptQuality 空列表时由抛异常改为返回最高可用档，spec 明确授权），另用 20825 组输入 × 任意屏蔽组合确认无异常、无空返回。播放路径入口（初始化 1254、半屏→全屏 425、手动菜单两处 959/1042）均已覆盖，下载路径（download.dart:45、download_panel）确认未受影响。Pref.blockedVideoQualities 读写键与返回类型无问题，设置项与多选弹窗接线正确。flutter test 98 passed、flutter analyze 改动文件仅剩 1 条既有告警（controller.dart:668，HEAD 已存在）。人工未验证项已在 risks 中列明。

## 验收

| 编号 | 结果 | 来源 | 验收项 | 原因 |
| --- | --- | --- | --- | --- |
| A1 | passed | brief.md | A1：屏蔽列表为空时，播放与下载的画质选择结果与当前版本完全一致（回归）。 | 空屏蔽集下与 HEAD 逐分支一致：4165 组（acceptQuality × preferredQuality × 最高可用档）穷举推演，旧版有返回值处新版 100% 一致。唯一偏差是 acceptQuality 为非 null 空列表且 preferred<=最高可用档时，旧版 findClosestTarget 对空表 reduce 抛 StateError，新版返回最高可用档（spec.md:68 明确授权且方向为「崩溃→可用值」）。setupFullScreenQualitySwitch 改造前后等价（原 421-431 内联逻辑 → 现 controller.dart:425-427 单一调用点，保留「只升不降」判定）。 |
| A2 | passed | brief.md | A2：屏蔽 1080P 高码率（112），视频可用画质含 1080P60 帧（116）、112、1080P（80），用户首选画质 ≥ 116 时，实际播放 1080P60 帧。 | 屏蔽 {112}、最高可用档 116、首选∈{116,120,125,126,127,129}，独立推演与新增单测结果均为 116。 |
| A3 | passed | brief.md | A3：屏蔽 112，视频可用画质含 116、112、80，用户首选画质为 112 时，实际播放 1080P（80）。 | 首选 112 被屏蔽，候选剔除后取不超过 112 的最高未屏蔽档 = 80。 |
| A4 | passed | brief.md | A4：屏蔽 112，视频可用画质为 112、80（无 116），用户首选画质 ≥ 112 时，实际播放 1080P（80）。 | 最高可用档 112 被屏蔽走第二分支，退到不超过 112 的最高未屏蔽档；首选>=112 全部推演为 80。 |
| A5 | passed | brief.md | A5：屏蔽 112，视频可用画质含 116、112、80，用户首选画质为 80 时，实际播放 1080P（80）——屏蔽高码率不会把用户升档到 1080P60 帧。 | 首选 80 时候选剔除后最近分支仍取 80，不会被抬到 116。 |
| A6 | passed | brief.md | A6：屏蔽 112，视频可用画质为 112、116、80，用户首选画质为 80，且 80 恰好不在视频流列表中时，兜底画质不是 112。 | 按「兜底不落到被屏蔽档」的意图判定：选档得 80、实际流为 [116,112] 无 80 时，findVideoByQa 经 fallbackVideo 取首个未屏蔽流 116，不是 112。 |
| A7 | passed | brief.md | A7：剔除被屏蔽项后候选集为空（例如屏蔽 80 且用户首选画质 ≤ 80）时，退回未屏蔽时的原结果，不崩溃、不出现无流可播。 | 候选集剔除被屏蔽项后为空时回退未剔除结果；20825 组任意输入 × 任意屏蔽组合推演无异常、无 null 返回。 |
| A8 | passed | brief.md | A8：半屏 → 全屏切换的自动选档同样跳过被屏蔽画质。 | 半屏→全屏已与播放初始化共用同一调用点，传同一个 Pref.blockedVideoQualities，内联 findClosestTarget 已删除。 |
| A9 | passed | brief.md | A9：多个画质可同时屏蔽；同时屏蔽 112 与 116 且两者都可用时，选到 80。 | 同时屏蔽 {112,116}，首选 80/112/116/127 推演与新单测结果全部为 80。 |
| A10 | passed | brief.md | A10：播放器底部控制栏画质弹窗与全屏「选择画质」BottomSheet 都不列出被屏蔽画质，仍可列出当前实际播放画质及其它可用画质。 | 两处菜单均已切换到 selectableVideoFormats；全 lib 穷举 supportFormats/availableVideoQualities/newDesc/VideoQuality.values/cacheVideoQa/persistVideoQa 后确认无第三个播放选档入口（下载面板为故意不屏蔽）。persistVideoQa 仅 view.dart:994 与 header_control.dart:1100 两个调用点，均在过滤之后。 |
| A11 | passed | brief.md | A11：设置页可勾选 / 取消勾选屏蔽画质，保存并重启后选择保留。 | 复用 MultiSelectDialog<int> 覆盖全部 13 档，写入 GStorage.setting，读取走 whereType<int>().toSet()，Hive setting 盒跨重启保留。副标题经 normal_item.dart:59 refresh() setState 刷新。 |
| A12 | passed | brief.md | A12：设置项副标题按画质档位从高到低展示已屏蔽画质；未屏蔽时显示「未屏蔽任何画质」。 | VideoQuality.values 按 129→6 降序声明，where 保序；空集合显示「未屏蔽任何画质」。 |
| A13 | passed | brief.md | A13：下载面板「目标画质」下拉仍列出全部画质；对一个同时提供 1080P60 帧与 1080P 高码率、且用户首选 112 的视频下载，目标画质仍是 112。 | 下载链路未传屏蔽集，findAvailableVideoQuality 走缺省空集 = 旧版行为；下载面板下拉仍为 VideoQuality.values 全量，preferedVideoQuality 全链路未被屏蔽集合影响。 |

## 检查

| 检查 | 命令 | 工作目录 | 状态 | 退出码 | 耗时 |
| --- | --- | --- | --- | ---: | ---: |
| flutter test 新增画质屏蔽选档单测 | test test/models/video/play/video_quality_blocklist_test.dart | . | passed | 0 | 3620 ms |
| flutter test 全量回归 | test | . | passed | 0 | 23344 ms |
| dart analyze 本次改动文件（--no-fatal-warnings） | analyze --no-fatal-warnings lib/models/video/play/url.dart lib/utils/storage_pref.dart lib/utils/storage_key.dart lib/pages/video/controller.dart lib/pages/video/widgets/header_control.dart lib/plugin/pl_player/view/view.dart lib/pages/setting/models/video_settings.dart test/models/video/play/video_quality_blocklist_test.dart | . | passed | 0 | 4393 ms |

### Builder 报告的证据

以下为 Builder 报告，不等同于 Runtime 检查凭据或独立验收结果。

- flutter test（新增单测）: passed — test/models/video/play/video_quality_blocklist_test.dart 18 个用例全部通过，覆盖 findAvailableVideoQuality 与 fallbackVideo，含「不传屏蔽集 vs 传空集逐档一致」的回归对比
- flutter test（全量）: passed — 98 passed / 0 failed（基线 80 + 新增 18）
- flutter analyze（改动文件）: passed — 完整运行时报 2 条告警，其中 unnecessary_non_null_assertion 位于本次改动行（fallback.id! → fallback.id），已顺手修正；剩余 unawaited_return_in_try_block（controller.dart:668）用 git show HEAD:lib/pages/video/controller.dart 核对为改动前已存在的既有告警，本 change 未触及该函数，故按 --no-fatal-warnings 执行以让既有告警不拦截验收，输出已完整保留
- 已知限制: A10、A11、A12、A13 依赖 UI 与 Hive 持久化，仅经代码走查核对，未做真机/模拟器人工验证；建议验收时在设置页勾选「1080P 高码率」后按 brief 验证预期中的三个场景人工核对。
- 已知限制: A6 的准确场景为「首选档没有对应视频流时，兜底画质不是被屏蔽画质」：dash.video 只含 112 与 64、首选 80 时，findVideoByQa 兜底取 64 而非 112。brief 中该条原文的「可用画质为 112、116、80」与「80 不在视频流列表中」并列存在歧义，实现按「兜底不落到被屏蔽档」这一意图落地。
- 已知限制: 当 accept_quality 为空列表且最高可用档被屏蔽时，会退回最高可用档（无候选可换档），这是「播放不中断优先」的既定兜底，真实 DASH 响应不会出现空 accept_quality。
- 已知限制: 播放中已加载的流不会因新开启屏蔽而中断；下一次选档才生效。

## 阻塞项

_无。_

## 风险与跳过的工作

- A1 存在一处经 spec 明确授权的行为偏差：acceptQuality 为非 null 空列表且 preferred<=最高可用档 时，旧版 findClosestTarget 对空表 reduce 会抛 StateError，新版改为返回最高可用档（url.dart:94-96 新增 isNotEmpty 守卫）。这是「崩溃→可用值」的方向，不影响任何原本可用的结果，但按 A1「完全一致」的最严格字面解释可算不一致。
- 当 13 档全部被屏蔽时，selectableVideoFormats 返回空列表，两处菜单渲染为空列表（不崩溃），且当前播放画质按定义必然是被屏蔽档、不会被列出——A10 的「仍可列出当前实际播放画质」在此退化场景下按屏蔽规则本身即无法成立。播放仍可继续（fallbackVideo 退回 videos.first）。
- 存在第三个可选到被屏蔽画质的入口但不在 A10 范围内：动态截图（webp）面板 lib/plugin/pl_player/view/view.dart:2613-2667 仍用 videoInfo.supportFormats!；它经 findVideoByQa 取值，该函数兜底现在也会跳过被屏蔽项，所以不会崩溃，但用户仍可为 webp 导出选择被屏蔽画质。
- 播放中才开启屏蔽：已加载的流不中断，但当前画质仍是被屏蔽值并会从菜单中消失，直到下一次选档；此模式下 currentVideoQa 与被列出的项暂不一致。
- 理论风险（非本次新增、真实响应下不可达）：findAvailableVideoQuality 第二分支可能返回 acceptQuality 中一个不在 dash.video 里的 code，此时 playerInit 的 videosList.firstWhere(orElse: () => videosList.first) 会抛 StateError。该隐患在旧版第一分支本就存在，真实响应中 acceptQuality⊆dash.video 故不可达；无测试覆盖。
- A10/A11/A12/A13 涉及 UI 与 Hive 持久化，仅经代码走查 + 既有全量测试（98 passed）核对，未做真机/模拟器人工勾选-重启验证；屏蔽列表相关自动化测试只覆盖 findAvailableVideoQuality 与 fallbackVideo，未覆盖两处菜单过滤、设置页与下载链路。

## 之前的迭代

| 目标周期 | 迭代 | 尝试 | 结果 | 未解决项 | 摘要 | 完成时间 |
| ---: | ---: | ---: | --- | --- | --- | --- |
| 1 | 1 | 0 | recovery | — | Native check input changed after the candidate was built; a new Builder candidate is required before checks can run again. | 2026-09-28T06:21:28.555Z |
| 1 | 2 | 0 | recovery | — | Builder handoff Runtime checks failed: dart-analyze-changed-files | 2026-09-28T06:24:27.912Z |
| 1 | 3 | 1 | pass | — | 候选 27114c45 通过 13/13 验收。核心修复在 lib/models/video/play/url.dart：findAvailableVideoQuality 增加 blockedQualities 参数，先剔除被屏蔽档再走原选档规则，剔除后无候选时退回旧结果，并新增 fallbackVideo 供 findVideoByQa 兜底。独立推演脚本（非 Builder 测试）穷举 4165 组输入确认空屏蔽集下与 HEAD 逐分支一致（唯一偏差是 acceptQuality 空列表时由抛异常改为返回最高可用档，spec 明确授权），另用 20825 组输入 × 任意屏蔽组合确认无异常、无空返回。播放路径入口（初始化 1254、半屏→全屏 425、手动菜单两处 959/1042）均已覆盖，下载路径（download.dart:45、download_panel）确认未受影响。Pref.blockedVideoQualities 读写键与返回类型无问题，设置项与多选弹窗接线正确。flutter test 98 passed、flutter analyze 改动文件仅剩 1 条既有告警（controller.dart:668，HEAD 已存在）。人工未验证项已在 risks 中列明。 | 2026-09-28T06:51:19.771Z |



## 结论

候选 27114c45 通过 13/13 验收。核心修复在 lib/models/video/play/url.dart：findAvailableVideoQuality 增加 blockedQualities 参数，先剔除被屏蔽档再走原选档规则，剔除后无候选时退回旧结果，并新增 fallbackVideo 供 findVideoByQa 兜底。独立推演脚本（非 Builder 测试）穷举 4165 组输入确认空屏蔽集下与 HEAD 逐分支一致（唯一偏差是 acceptQuality 空列表时由抛异常改为返回最高可用档，spec 明确授权），另用 20825 组输入 × 任意屏蔽组合确认无异常、无空返回。播放路径入口（初始化 1254、半屏→全屏 425、手动菜单两处 959/1042）均已覆盖，下载路径（download.dart:45、download_panel）确认未受影响。Pref.blockedVideoQualities 读写键与返回类型无问题，设置项与多选弹窗接线正确。flutter test 98 passed、flutter analyze 改动文件仅剩 1 条既有告警（controller.dart:668，HEAD 已存在）。人工未验证项已在 risks 中列明。
