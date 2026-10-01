# V1c：单连接 localhost Range 代理基础阶段

日期：2026-10-01。开发分支：feature/streaming-accelerator。版本验证摘要见 VALIDATION.md。

## 功能和启用
设置 → 视频设置 → 播放加速 → 本地 Range 代理 / Proxy（实验，单连接）。下一次加载视频/画质生效。OFF/Auto/CDN 优选保持原行为；不会自动迁移已有设置。此阶段不是 V2 多线程或 V3 多 CDN。

仅网络 DASH 视频通过随机会话路径的 127.0.0.1 随机端口；音频沿用直连 EDL，页面保留远端 URL 给下载/DLNA。只听音频不创建代理。单上游透传不测速、不切线、不预读、不增加缓存；每个新请求取消上个视频请求，不累积后台队列。

## 协议和生命周期
支持 GET/HEAD、无 Range、单一闭合/开放/后缀字节 Range；416 保留总长度。多 Range/错误语法在本地拒绝。206 必须匹配请求的 Content-Range 和 Content-Length，拒绝 Range 被忽略的 200、编码响应、无长度、错误边界和重定向，关闭上游而不是下载全片测速。签名查询完整保留，不允许下游选择远端目标。不转发 Cookie、Location、任意客户端请求头或带签名 URL 到诊断。
流式 addStream 遵循下游消费，未自行累积完整视频。请求/响应头和流空闲限时15秒，错误尝试原源恢复一次并停用该会话代理。seek/network-change 取消在途请求；关闭仅作用于本会话服务器。实际用户关流和上游 EOF 分开，避免把 mpv 的 demux/seek 当作 CDN 截断。

## 计量
诊断新增 throughputSource、proxyThroughputBps、proxyUpstreamBytes、proxyForwardedBytes、proxyRequests、proxyErrors、proxyFailureReason、proxyActiveRequests。
proxyForwardedWindow 表示最近约3秒的视频转发窗口速率，包含空闲时间，不含音频。forwardedBytes 是交给下游流的字节，可能包含 seek 重读，不声称等于播放器最终消费或去重 goodput。已有逐CDN stats 仍是短 probe 样本，Proxy 不产生这些探测。

## 文件
新增 range_protocol.dart 和 local_stream_server.dart；配置增加独立 rangeProxy 字符串。Session 管理服务器和一次性恢复；player controller 最小接入，把视频 URL 换为 loopback，原音频和 EDL 逻辑不改。macOS Release 补 network.server；未放宽全局 TLS/Android 明文权限，未改变 media_kit/mpv 或依赖版本。

## 验证与后续
真实 localhost 合成服务覆盖闭合/开放/后缀 Range、GET/HEAD、416、坏协议/超时、源选择、seek 取消、原源恢复和 OFF 零服务器。
Windows 固定原生 mpv 对合成60秒 AVI + WAV 完成 proxy-video/direct-audio EDL、30秒 seek、切回远端、暂停/1.25倍速，代理请求5次、错误0。首次 native 测试发现一次关流被误判截断，修正后重跑。
Android 测试 APK 独立构建并检查注册、CRC、签名和对齐；此阶段尚未在用户手机启用代理复测。iOS/Linux/macOS、后台/PiP/锁屏与代理恢复竞态均不以 Windows 结果代替。
实机先对比当前顺畅视频的 Auto 与 Proxy；确认音画、seek、长播、错误恢复，再开展 V2 bounded chunk/cache/scheduler 和动态并发。不提前开启多线程。

协议参考：https://www.rfc-editor.org/rfc/rfc9110.html#name-range
Dart 请求关闭：https://api.dart.dev/dart-io/HttpClientRequest/abort.html
