# Ubuntu Touch：CDN 请求头试验

日期：2026-10-16  
对应路线：`docs/ubuntu-touch-port.md` 建议顺序的第 3 步  
机器：OnePlus 6T，`d3ba49e7`。请求从手机发出，不从编译机取地址再交给手机。

## 结论

不写代理。前半段的空头 Range 是 403，所以没有按「空头也 200」那一档把 MPD 写进应用。后半段仍在手机上手工写了一份 AVC+AAC 的 MPD，`Charge` 给 `mediaplayer-app`。这一次有画面、有音轨，范围内的 seek 能停住。

不带 `User-Agent`、也不带 `Referer` 时，视频和音频都是 403，正文是 HTML，没有 `ftyp`。带上页内那一组（`BrowserUa.pc` 和 `Referer: https://www.bilibili.com`）时，两边都是 206，`Content-Type` 是 `video/mp4`，前 16 字节里有 `ftyp`。

把这一组拆开之后，门槛是 `User-Agent`，不是 `Referer`：

| 请求 | 视频 | 音频 |
| --- | --- | --- |
| 只有 `Range: bytes=0-1023` | 403，`AkamaiGHost` | 403，`AkamaiGHost` |
| 只有 `Referer` | 403，`AkamaiGHost` | 403，`AkamaiGHost` |
| 只有页内 `User-Agent` | 206，`openresty`，`ftyp` | 206，`openresty`，`ftyp` |
| 只有 `User-Agent: GStreamer/1.16.2` | 206，`openresty`，`ftyp` | 206，`openresty`，`ftyp` |
| 页内 `User-Agent` 加 `Referer` | 206，`openresty`，`ftyp` | 206，`openresty`，`ftyp` |

手机上的 `gstreamer1.0-plugins-base` 是 `1.16.3-0ubuntu1.4`。上面的 `GStreamer/1.16.2` 是这次手动写上的字符串，不是从 `mediaplayer-app` 里抓到的请求头。后半段的 sidx 和末段探测改用 `GStreamer/1.16.3`，同样是手写的。播放器日志写明 `setMedia() headers empty: true`，也就是 Content Hub 没有附带自定义头。播放仍然进入 `PLAYING`，所以播放器自己带上的 `User-Agent` 已被这条 CDN 接受。线上实际的 UA 字符串这次没有抓包。

## 取到的流

公开稿件 `BV1xx411c7XW`，`cid` `3262388`，时长 96 秒，分 P 名是 `P1`。手机先打开 `https://www.bilibili.com/`，拿到 `buvid3` 和 `b_nut`，再请求 `https://api.bilibili.com/x/player/wbi/playurl`。参数和页内一致的部分：`qn=16`、`fnval=4048`、`try_look=1`，并用当天的 WBI mixin 签名。没有登录。

选出的是带宽最低的一条 AVC 和一条 AAC：

| | id | codecs | 尺寸或带宽 | segmentBase |
| --- | --- | --- | --- | --- |
| 视频 | 16 | `avc1.64001E` | 480×360，349855 bps | `initialization` `0-1029`，`index_range` `1030-1289` |
| 音频 | 30216 | `mp4a.40.2` | 66516 bps | `initialization` `0-932`，`index_range` `933-1204` |

两条 `baseUrl` 的主机都是 `upos-hz-mirrorakam.akamaized.net`。地址里的查询串没有写入这份文档。探测结束后删掉了手机上的 `/tmp/pili-cdn-urls.json`。

带 `Range` 时成功的响应是 206，不是 200。视频 `Content-Range: bytes 0-1023/4198260`。音频 `Content-Range: bytes 0-1023/800050`。音频的 `Content-Type` 也是 `video/mp4`，这是 fMP4 的常见写法。

## 过程里踩到的

- 手机上没有 `curl`，有 Python 3.8。探测在手机上跑。
- `https://api.bilibili.com/x/web-interface/nav` 不带 `User-Agent` 时正文是空的，带上页内 UA 才返回 JSON。未登录时 `code` 是 `-101`，`wbi_img` 仍在。
- `https://api.bilibili.com/x/web-interface/view` 返回 412 的 HTML。`cid` 改从 `https://api.bilibili.com/x/player/pagelist` 取，这一路是 200。

## 手工 MPD 和 Charge

同一条稿件，仍在手机上重新要了 playurl。选的还是带宽最低的 AVC（id 16，`avc1.64001E`，480×360）和 AAC（id 30216，`mp4a.40.2`）。sidx 和末段探测只用 `User-Agent: GStreamer/1.16.3`，不带 `Referer`。视频 sidx 是 206，展开 19 段，timescale 16000。音频 sidx 是 206，展开 20 段，timescale 44100。两条的最后一段 `Range` 都是 206，各 16 字节。主机仍是 `upos-hz-mirrorakam.akamaized.net`。

写出的清单没有 `BaseURL`。`Initialization` 的 `sourceURL` 和每个 `SegmentURL` 的 `media` 都是带查询串的绝对 `https`。视频 19 段，音频 20 段。文件 40023 字节，`presentation` 96 秒，放在 `/home/phablet/pili-avc-133027.mpd`。地址没有写入这份文档。

`CreateExportToPeer` 的对端是 `mediaplayer-app`，应用 id 是 `piliplus.alphaliu01_piliplus_2.1.6`，类型 `videos`。`Charge` 返回的状态是 3（Charged）。播放器把文件收进 `~/.cache/mediaplayer-app/HubIncoming/7/`，和源文件是同一个 inode。`media-hub` 认成 `application/xml`。

13:30:27 起的日志：

- `mediaplayer-app` 启动，`setMedia()` 的自定义头是空的。
- 先报 1 路视频、0 路音频，随即变成 1 路视频、1 路音频。
- playbin 进入 `PLAYING`，播放器状态变成 `playing`。
- surface 被设成 width 480、height 368。流本身是 480×360。
- QML 位置从大约 0.7 秒往前走，时长 96000 毫秒，一直加到 90 秒以后。没有人在扬声器旁边确认声音；音轨存在的证据是上面那次 `streams changed`。没有从屏幕截图。
- 这一段 `mediaplayer-app` 和 `media-hub-server` 的日志里没有 403，也没有 `error`。
- 日志里有 `Using Hybris video sink`。那是系统播放器自己的输出，不是这个 Click 去链 hybris。

Seek 走的是这次会话 `/com/lomiri/MediaHub/Service/sessions/17` 上的 `Seek`。参数是 `t`（uint64）。`Position` 属性读出来是纳秒，但 `SetPosition` 用纳秒没有把进度挪走。`Seek(5000000)` 在大约 91.7 秒时把 QML 位置从 91741 毫秒跳到 5648 毫秒，时长仍是 96000。随后一次超出时长的 `Seek` 把会话停在 0，那是探测写出去的，不是范围内 seek 失败。会话停住之后再 `Seek(30000000)`，位置停在 30.0 秒并且是 `Paused`；接着 `Play`，两秒后是 31.962 秒，再过两秒是 33.983 秒，状态保持 `Playing`。没有弹回 0。没有用手指在进度条上拖。

看完之后 `Stop` 了这次会话，并删掉了家目录和 `HubIncoming` 里的那份 MPD，以及手机上的探测脚本。

## 不做

- 不在 Click 里开转发去补头。播放器在前台时本进程是停住的，而这次空自定义头已经能播。
- 不因为前半段的 403 就改去本机转码。
- 不把 MPD 生成和 `Charge` 写进点播页。那是路线文档里的第 4 步，这次只做到手机上的手工清单。
