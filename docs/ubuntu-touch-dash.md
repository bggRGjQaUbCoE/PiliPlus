# Ubuntu Touch：点播页写出 MPD 并 Charge

日期：2026-10-16  
对应路线：`docs/ubuntu-touch-port.md` 建议顺序的第 4 步  
状态：机器上能做的已经记完。第 6 步还差看画面和听声。第 7 步还差看画面。第 3 步里「全部地址都失败」没有另测。

这篇只做到一件事：点播页把一条 DASH 写成本地 MPD，用 Content Hub `Charge` 给 `mediaplayer-app`。先验收 AVC+AAC，再用同一份清单形状验收 HEVC。占位、本片画质、手动上一首和下一首是第 5 步，不在这里。

手工清单已经在 [ubuntu-touch-cdn.md](ubuntu-touch-cdn.md) 里播过。清单形状不再设计。仓库里已经有选出、写文件和 `Charge` 的代码。下面的步骤是验收顺序。某一步的完成标准没有达到，就不要在实现笔记里把它写成通过。

改代码时沿用 [ubuntu-touch-click.md](ubuntu-touch-click.md) 的容器和 Clickable，不在这里重写编译。装上之后，Click 安装树里的 `piliplus` 与 bundle 的 sha256 必须相同。没改代码就用已经装上的 `piliplus.alphaliu01` 2.1.6。

## 不做

- 不写代理，不在 Click 里转发分片。播放器在前台时本进程是停住的。
- 不用 `OpenUriExtended`。不把 `https` 交给 URL Dispatcher，那会打开浏览器。`video://` 会被改成 `file://`。
- 写不出清单就停住，不退回页内 mpv，不调用 `MediaKit.ensureInitialized()`。
- 不交 `durl`，不拼 `edl://`。本地文件不在这一步。
- AV1、DVH1 不进清单。音频不拿 flac 或 dolby。
- 直播不在这里。直播间是 FLV 或 HLS，不和点播 MPD 一起验收。
- 不测自动连播、倍速、字幕、弹幕、小窗。播放器占着前台时收不到播完。
- 不验收「从播放器回到这一页不再自动 Charge」。那是第 5 步。
- 不改桌面构建，不把 Ubuntu Touch 写成所有 `Platform.isLinux`。
- 不为了这一步加宽 AppArmor。只核对已有的 `content_exchange_source`。

## 机器

| 角色 | 机器 | 做什么 |
| --- | --- | --- |
| 安装和日志 | 这台 Linux x64 台式机 | adb、`journalctl`、必要时 `clickable install` |
| 运行 | OnePlus 6T，`d3ba49e7` | Ubuntu Touch 20.04，Click `piliplus.alphaliu01` 2.1.6 |

地址在手机上向哔哩哔哩要。不要在编译机上取了再交给手机。

## 步骤

### 1. 点播不再进 media_kit

`PILI_UBUNTU_TOUCH` 打开、来源不是本地文件时，点播初始化只走写出和交出。不调用 `PlPlayerController.setDataSource`。

完成标准：打开一条线上点播后，journal 里没有 `MediaKit.ensureInitialized must be called`。进程还在。

### 2. 选出 AVC 和 AAC

材料用这一次 playurl 里的 `dash`，不另要一套地址。

- 视频：当前画质里 codecs 以 `avc` 开头的那条。没有就用带宽最低的 AVC。一条 AVC 都没有时，这一步先停，留给第 7 步的 HEVC，不要拿 AV1 或 DVH1 充数。
- 当前这条的镜像全部拒绝播放器时，按带宽从近到远再试其他 AVC，仍没有再试 HEVC。探测仍然不带 `Referer`。换到哪一条，看 `dash quality skip` 后面的 `dash charge`。
- 音频：codecs 以 `mp4a` 开头。当前音质对得上就用它，否则用带宽最低的那条。没有 AAC 就不写文件。当前这条 AAC 也全部拒绝时，再试其余的 `mp4a`。

完成标准：日志里有 `piliplus: dash offers avc=` 和 `hevc=`，随后的 `dash charge` 行是 `avc` 配 `mp4a`。AV1、DVH1、flac、dolby 没有出现在这条 `dash charge` 里。

### 3. 在手机上读 sidx，403 就换地址

`segmentBase` 的 `initialization` 和 `index_range` 都要有。`index_range` 是文件里的 `sidx`。Range 只带 `User-Agent: GStreamer/1.16.3`，不带 `Referer`。查询串按 playurl 原样发送，不用会重新编码的 `Uri`。

某一个 `baseUrl` 返回 403，就换 `playUrls` 里的下一条。视频和音频都这样做。末段再探一小段 Range，不是 206 的地址不用。

不要把整段写成一个 `mediaRange`。那样快进会回到开头。解析不出多段就停，不写文件。

完成标准：写出的清单里视频和音频都有多于一段。日志里可以有 `dash index status=403` 或 `dash tail status=403`，只要后面还有一次成功的 `dash charge`。所有地址都失败时，没有 MPD，也没有 `Charge`。

### 4. 写成已经通过的那种 SegmentList

形状与手工清单相同，不再改：

- 没有 `BaseURL`。带查询串的地址放进 `BaseURL` 时，6T 上的 dashdemux 找不到流。
- `Initialization` 的 `sourceURL` 和每个 `SegmentURL` 的 `media` 都是带查询串的绝对 `https`。
- `SegmentList` 带 `timescale`。初始化用 `range`。每一段用 `mediaRange`。
- 文件在 `~/.cache/piliplus.alphaliu01/dash/`。新文件写好之后，删掉这个目录里其他 `.mpd`，不留过期地址。

完成标准：手机上的 MPD 能对上上面四条。`dash charge` 日志里的 `segs=`、`bytes=` 与文件一致。查询串不要抄进这份笔记。

### 5. Content Hub Charge

`CreateExportToPeer` 的对端按 `mediaplayer-app`、`lomiri-mediaplayer-app` 的顺序挑已注册的那个。类型是 `videos`。应用 id 用环境里的 `APP_ID`。`Charge` 的状态 3 是 Charged。

安装树上的 AppArmor 要有 `content_exchange_source`。没有就只加这个策略组，不加别的。不要用 `lomiri-app-launch` 从 Click 里交，它访问 systemd 会被拒绝。

完成标准：`dash charge` 行以 `state=3` 结束。`media-hub` 的播放 uri 在 `~/.cache/mediaplayer-app/HubIncoming/` 下，并且和缓存里的 MPD 是同一个文件。日志里 `setMedia()` 的自定义头是空的。状态不是 3 时，没有第二次用别的方式再交。

### 6. AVC 真机

用一条线上点播，从应用里打开，不是用手工 MPD。看屏幕的部分由手机前的人做。

1. 有画面。`PLAYING` 和 `Using Hybris video sink` 不够单独算通过。
2. 音轨变成 1 路视频、1 路音频。有人在扬声器旁边就听一声，写进笔记。没人听，就不要把「有声音」写成通过。
3. 范围内 seek 停得住，不弹回 0。手指拖进度条，或沿用 CDN 笔记里对 media-hub 会话的 `Seek`。超出时长的探测不要算进这一次。
4. 播放器到前台后，Click 进程变成 `T`。这是 Lomiri 停住后台 Click，不是崩溃。

完成标准：上面 1、3、4 都有记录。2 至少有音轨变化；听到声音与否按实际写。这一段 `mediaplayer-app` 和 `media-hub` 没有把播放打成错误。单个镜像主机 403 已在第 3 步放过，不在这里另算失败。

### 7. HEVC 用同一份形状再交一次

仍是第 4 步的 MPD。只把视频轨换成 codecs 以 `hev` 或 `hvc` 开头的那条，音频仍是 AAC。没有 HEVC 的稿件记成「这条没有」，换一条再测，不要改清单形状。

完成标准：`dash charge` 的 codec 是 HEVC，`state=3`，playbin 进入 `PLAYING`。看屏幕的人确认有画面。没有画面就停在故障记录里，不按骁龙 845 的规格写成已经能播。AV1 不测。

## 占位上的按钮

占位在 `autoPlay` 为 false 时盖住 16:9。交出时会把它设成 false，所以从系统播放器回到这一页，占位还在。

从首页点进一条视频时，playurl 一回来就直接 `Charge`，不经过播放按钮。那一次选的是当前画质里的 AVC，没有就用带宽最低的 AVC。底部「画质」在交出之后写成「1080P AVC」这种文字，就是刚才交出的格式。日志里的 `dash charge codec=` 是同一次的编码。

| 位置 | 按钮 | 作用 | 现在 |
| --- | --- | --- | --- |
| 左上 | 返回 | 离开这一页 | 能点。不交出 |
| 左上 | 返回主页 | 关掉播放页，回到首页 | 能点。不交出 |
| 右上 | 更多 / 稍后再看 | 加入稍后再看 | 能点。不交出 |
| 右上 | 更多 / 查看笔记 | 打开笔记列表 | 能点。不交出 |
| 右上 | 更多 / 缓存视频 | 下载 | 能点。不交给系统播放器 |
| 右上 | 更多 / 保存封面 | 保存封面图 | 能点 |
| 右上 | 更多 / 听音频 | 只在投稿视频上出现，打开页内音频 | 能点。这条构建没有 libmpv，不能当播放入口 |
| 右上 | 更多 / 举报 | 未登录时提示账号未登录 | 能点。不交出 |
| 中间 | 播放 | playurl 还没有就去要；有了就按当前选择写出 MPD 并 `Charge`。正在请求时再点一次不会重入 | 能点。2026-10-16 之前只是一个图标，外层点击在滚动页里到不了，所以点了没反应 |
| 底部 | 上一条 | 有上一条就换集，重新要 playurl 再 `Charge`。没有就提示「没有上一条」 | 能点 |
| 底部 | 下一条 | 同上，没有时提示「没有下一条」 | 能点 |
| 底部 | 画质 | 列出这条的 AVC 和 HEVC。点一项就按那一条重新 `Charge`。playurl 还没回来时菜单是空的，标签是「画质」 | 能点 |

右下角原来的播放图形不接收点击，而且盖住底部条的右侧。Ubuntu Touch 上不再画。封面空白处仍挂着一层点击，在滚动页里可能点不到，不要把它当成入口。

## 任务

### 等待你完成

- [x] 6T 解锁，`adb devices` 里 `d3ba49e7` 为 `device`。
- [ ] 第 6 步看画面，并在扬声器旁边听一声（人在的时候）。范围内拖一次进度。
- [ ] 第 7 步看 HEVC 有没有画面。

### 等待实现

- [x] 第 1 步打开点播后没有 `MediaKit.ensureInitialized`。
- [x] 第 2 步日志里的第一次 `dash charge` 是 AVC 配 AAC。
- [ ] 第 3 步清单是展开后的多段。全部地址失败时没有写出文件。
- [x] 第 4 步 MPD 的形状与手工清单相同，笔记里没有查询串。
- [x] 第 5 步 `state=3`，文件进了 `HubIncoming`，自定义头为空。
- [ ] 第 6 步 AVC 的画面、seek、进程状态记入实现笔记。
- [ ] 第 7 步 HEVC 的画面记入实现笔记，或明确写成没有画面。

## 实现笔记

每完成一步，按下面的格式加一节。没有达到完成标准的步骤不要写成通过。查询串、cookie、playurl 全文不要写进来。

### 2026-10-16 第 1 步

- 步骤：点播不再进 media_kit。
- 做了什么：没有改代码，用已经装上的 Click。应用读 `~/.cache/piliplus.alphaliu01/open-video` 后自己打开 `BV1d5JQ6pEFS`、cid `42781444806`，不是把手工 MPD 交给播放器。14:55:40 这一次和 14:56:59 这一次的 journal 里，`MediaKit.ensureInitialized` 都是 0 次。
- 产物路径和 sha256：`/opt/click.ubuntu.com/piliplus.alphaliu01/2.1.6/piliplus`，sha256 `173b3cbfbf4a3f2bf28bc06139b3a2ba5df6e404bbcac31f828754d9de10cb02`。与 Click 那篇第 4 步的 bundle 相同，这次没有重编。
- 手机上的 pid 和日志要点：第一次 pid `5462`，交出之后状态 `T`。第二次 pid `5761`。

### 2026-10-16 第 2 步

- 步骤：选出 AVC 和 AAC。
- 做了什么：两次打开的第一次 `dash charge` 都是 `avc1.640033` id 80、1920×1080，音频 `mp4a.40.2` id 30280。`dash offers avc=4 hevc=4`。这两行里没有 AV1、DVH1、flac、dolby。
- 产物路径和 sha256：同上，没有新二进制。
- 手机上的 pid 和日志要点：14:55:42 与 14:57:01 的 `dash offers`；14:55:46 与 14:57:05 的第一次 `dash charge`。

### 2026-10-16 第 3 步

- 步骤：在手机上读 sidx。成功路径达到了。全部地址都失败的分支这次没有做，所以任务勾选先留着。
- 做了什么：`upos-sz-mirrorcosov.bilivideo.com` 的 index 或末段是 403，随后仍写出多段清单并 `Charge`。AVC 那份视频 32 段、音频 31 段。没有把整段写成一个 `mediaRange`。
- 产物路径和 sha256：缓存里当时只剩一份 `.mpd`，62077 字节。查询串没有抄下来。
- 手机上的 pid 和日志要点：14:55:44 `dash index status=403`，14:55:46 `dash tail status=403`，紧接着 `dash charge ... segs=32 ... segs=31 ... state=3`。

### 2026-10-16 第 4 步

- 步骤：SegmentList 的形状。
- 做了什么：AVC 那份没有 `BaseURL`。视频 `timescale` 16000，初始化 `range` `0-934`，`sourceURL` 是 `https`。32 个 `SegmentURL` 都是 `https`，都有 `mediaRange`。音频 `timescale` 48000，初始化 `0-836`，31 段，同样全是绝对 `https`。`mediaPresentationDuration` 为 `PT152.867S`。`dash charge` 的 `segs=` 和 `bytes=62077` 与文件一致。写完后 `dash/` 里只有这一份。HEVC 那份同样没有 `BaseURL`，视频 32 段、音频 31 段，62069 字节，时长 `PT152.866S`。
- 产物路径和 sha256：`~/.cache/piliplus.alphaliu01/dash/` 下的 MPD。二进制 sha256 同上。
- 手机上的 pid 和日志要点：见第 2 步的 `dash charge` 行。

### 2026-10-16 第 5 步

- 步骤：Content Hub Charge。
- 做了什么：安装树上的 AppArmor 已有 `networking` 和 `content_exchange_source`，`policy_version` 20.04。没有加规则。AVC 的 `state=3`。`setMedia()` 自定义头是空的。播放 uri 在 `HubIncoming/3/`，inode `5369353`，和缓存里的 MPD 是同一个文件。没有看到第二次用别的接口再交。
- 产物路径和 sha256：二进制 sha256 同上。
- 手机上的 pid 和日志要点：`mediaplayer-app` pid `5550`。14:55:47 `headers empty: true`。14:55:48 `playing uri` 指向上述 `HubIncoming/3` 文件。

### 2026-10-16 第 6 步（未通过）

- 步骤：AVC 真机。画面和听声没有做，这一步不算通过。seek 和进程状态已经做了。
- 做了什么：播放器到前台后，pid `5462` 的状态是 `T`。media-hub 先报 1 路视频 0 路音频，随即 1 路视频 1 路音频，playbin `PLAYING`。没有人看画面，也没有人听。范围内 seek 用的是会话 1 的 `Seek(30000000)`。时长约 152.9 秒。seek 前位置 35.506 秒、状态 `Playing`；seek 后 30.690 秒，仍是 `Playing`，没有回到 0；再过 2 秒是 32.817 秒。从 14:55:40 到这次 seek 结束，电源键事件是 0。
- 产物路径和 sha256：同上。
- 手机上的 pid 和日志要点：14:55:49 `streams changed` 两次，然后 `State changed on playbin: PLAYING`，播放器状态 `playing`。这一段没有 `media-hub` 的 `error`。

### 2026-10-16 第 7 步（未通过）

- 步骤：HEVC。机器侧已经 `PLAYING`。没有人看画面，这一步不算通过，也不写成「没有画面」。
- 做了什么：同一次打开仍是这条稿件。第一次交出仍是上面的 AVC。播放器占着前台时进程是停住的，测试里对 pid `5761` 发了 `SIGCONT`，15 秒后应用自己的跟踪才跑到 `dash follow hevc`，再交一次。这不是产品路径。HEVC 清单没有 `BaseURL`，视频 `hvc1.1.6.L150.90`、1920×1080、32 段、`timescale` 16000，音频仍是 `mp4a.40.2`、31 段。`state=3`，62069 字节，和 `HubIncoming/5/` 是同一个 inode `5369355`。自定义头仍是空的。14:57:24 playbin `PLAYING`，音轨是 1 路视频 1 路音频。`SIGCONT` 之后进程停在 `S`，这次不能用来证明 `T`。电源键事件是 0。
- 产物路径和 sha256：二进制 sha256 同上。缓存里替换成 HEVC 那一份 MPD。
- 手机上的 pid 和日志要点：pid `5761`，`mediaplayer-app` pid `5872`。14:57:20 `dash follow hevc`。14:57:22 `dash charge codec=hvc1.1.6.L150.90 id=80 1920x1080 segs=32 audio=mp4a.40.2 id=30280 segs=31 bytes=62069 state=3`。

## 故障记录

出现一次就加一行，保留命令输出里能定位的那几行。

| 日期 | 现象 | 关键日志 | 处理 | 结果 |
| --- | --- | --- | --- | --- |
| 2026-10-16 | 停掉上一次 AVC 播放时，media-hub 报视频帧来晚。 | 14:56:59 与 14:57:01，`gst_base_sink_is_too_late`，`GstHybrisSink:video-sink`。新的 `setMedia` 在 14:57:06。 | 没有改清单，也没有加 AppArmor。 | 下一次 AVC 和随后的 HEVC 都进入 `PLAYING`。不记成第 6 步或第 7 步失败。 |
| 2026-10-16 | 有的视频一点播放就提示「写不出清单」。 | 16:10 到 16:16，多次 `dash index status=403`，主机是 `upos-sz-mirrorcosov.bilivideo.com`（nginx）和 `upos-hz-mirrorakam.akamaized.net`（AkamaiGHost），接着 `dash index missing video=false audio=true` 或 `audio=false`。同一段里也有成功的 `dash charge`。 | 在手机上用同样的 `User-Agent: GStreamer/1.16.3`、不带 `Referer` 重探。`cosov` 稳定 403，正文是 nginx 的 HTML。一部分 Akamai 地址同样 403。这两类地址加上 `Referer: https://www.bilibili.com` 会变成 206，但播放器的 `setMedia()` 自定义头是空的，不会带 `Referer`，所以这种地址不能写进清单。`BV19zak6tEy1` 的 AVC id 116 两条镜像都不带 `Referer` 就是 403，id 80 的 Akamai 镜像是 206。 | 当前画质两条都读不到时，改试下一条播放器能读的 AVC，再没有才试 HEVC。不给探测加 `Referer`，也不写代理。新包装已装上，`lib/libapp.so` 含有 `dash quality skip`。还要再点一次以前提示「写不出清单」的视频，看 journal 里是 skip 之后的 `dash charge`，而不是停在 toast。 |

## 进度日志

### 2026-10-16

- 建立这份计划。范围停在点播页写出 MPD 并 `Charge`。先 AVC+AAC，再 HEVC。第 5 步不在这里。
- 用已安装的 2.1.6 跑了第 1 到第 5 步的成功路径，以及第 6 步里除画面和听声以外的部分。第 3 步「全部地址都失败」没有测。
- 第 7 步的 HEVC 清单已经 `Charge` 并且 playbin `PLAYING`。画面等手机前的人看。看的时候播放器停在这一次 HEVC 上。背光读数是 8（最大 1023），画面会很暗。
- AVC 那一次的画面已经不在屏幕上。第 6 步要看画面的话，需要再打开同一条，并且不要带 HEVC 跟踪。
- 占位中间的播放图标点不到。它不是按钮，外层点击在滚动页里到不了。改成按钮，并记下占位上每个按钮的作用。新包装上之后，手机上的 `lib/libapp.so` 含有 `dash play tapped`。可执行文件 sha256 仍是 `173b3cbfbf4a3f2bf28bc06139b3a2ba5df6e404bbcac31f828754d9de10cb02`，变的是快照。
- 播放按钮能点了。一部分稿件提示「写不出清单」。原因和改法在故障记录。探测仍然不带 `Referer`。
