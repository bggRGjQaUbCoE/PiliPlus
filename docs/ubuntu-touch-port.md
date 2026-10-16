# Ubuntu Touch：从 GasTube 搬到 PiliPlus

日期：2026-10-16

对照的是 `docs/doc_from_gastube/` 里已经在 OnePlus 6T（Ubuntu Touch 20.04）上跑通的记录，主要是 `ubuntu-touch-phase0.md`、`ubuntu-touch-phase1.md`、`ubuntu-touch-system-player.md`。本文只判断路线能不能搬，不改代码。

## 结论

可以按几乎同一条路移植，而且播放这一半更短。

PiliPlus 已经是 Flutter 3.47.7 的 Linux GTK 应用，播放地址由 Dart 自己向哔哩哔哩要，没有 Java sidecar，没有内置 JRE，也没有自带的 hybris 解码器。GasTube 里为 NewPipe、JRE、FFmpeg、libmpv 和 `h264_hybris` / `vp9_hybris` 花掉的阶段，这里整段不做。

留下的两块和 GasTube 相同：

1. 让官方 GTK embedder 在 Lomiri 上画出界面。
2. 把画面交给系统播放器 `mediaplayer-app`，解码和出图都留在手机根文件系统里的 GStreamer hybris 上。

页内硬解不作为退路。GasTube 把 hybris 解码器留在 Click 里，是因为短视频的 `PageView` 必须停在本进程。那种解码器按厂商颜色格式拷贝，换芯片就不够用。PiliPlus 不走这条。点播的画面一律交出。交不出去就停在占位，不在 Click 里再链一份 libmpv。

不能原样复制的只有三处，都在动手前用手动命令确认，不先写进应用：

- 哔哩哔哩的 CDN 会不会在没有 `Referer` 的情况下给系统播放器 200。GasTube 的 googlevideo 可以，这里还没试过。
- 本仓库的 Linux runner 链了 WebKit。6T 的 Click 运行时没有这份库，不拆掉的话进程起不来。
- 弹幕画在 Flutter 自己的画面上。系统播放器是另一个全屏应用，弹幕过不去。这是这条路线的产品代价，不是还没做完的步骤。

## 这个仓库里已经有的

| 项目 | 现状 |
| --- | --- |
| 界面 | Flutter，`pubspec.yaml` 固定 `flutter: 3.47.7` |
| Linux 窗口 | `linux/runner/my_application.cc`，`GtkApplication`，header bar，默认 1280×720 |
| 应用 ID | `com.example.piliplus` |
| 取流 | `lib/http/video.dart` 的 playurl，结果是 `PlayUrlModel` |
| 点播 | 正常是 DASH：`dash.video` 和 `dash.audio` 各一条地址。播放器在 `pl_player/controller.dart` 里用 `edl://` 把两条拼进 mpv |
| 地址上的头 | `player.setMediaHeader(userAgent: BrowserUa.pc, referer: https://www.bilibili.com)` |
| 分片信息 | `BaseItem.segmentBase` 已经解析了 `initialization` 和 `index_range` |
| 旧格式 | `durl` 只是兜底，代码注明 FLV/MP4 已淘汰。多段时拼的也是 `edl://` |
| 编码 | `VideoDecodeFormatType`：DVH1、AV1、HEVC、AVC |
| Linux 构建 | `.github/workflows/linux_x64.yml` 在较新的 Ubuntu 上装 `libgtk-3-dev`、`webkit2gtk-4.1`、`libmpv-dev`、`libasound2-dev`、`libayatana-appindicator3-dev` |
| 登录 | 扫码和粘贴 cookie 不经过 WebView。密码登录遇到极验时走 `linux/runner/plugins/linux_webview_plugin.cc` |
| 本地数据 | Hive，不是 SQLite |

桌面 Linux 继续用现在这条 runner。Ubuntu Touch 只在单独的构建开关里分叉，和 GasTube 的 `GASTUBE_UBUNTU_TOUCH` 一样。不要把 `Platform.isLinux` 改成「就是手机」。

## GTK：可以直接照做的

Phase 0 和 Phase 1 的壳子不依赖 YouTube，也不依赖 sidecar。PiliPlus 的 Linux 目标同样是 GTK3，所以下面这些原样成立。

构建仍用 Ubuntu 20.04 的 `linux/arm64` 容器跑 `flutter build linux --release`。6T 的用户空间是 glibc 2.31、libstdc++ 10.5、GTK 3.24.20。现在的 x64 CI 镜像比这新，编出来的二进制不能装进这个 Click。引擎要用 3.47.7 自己的 `linux-arm64` GTK 包，不要把 GasTube 那份 3.47.1 的 `libflutter_linux_gtk.so` 换进来。

Click 仍是：容器里链好的 bundle，x64 上的 Clickable 只打包、不重新链接。可执行文件 `RUNPATH` 用 `$ORIGIN/lib`。`Exec` 直接是二进制，不要用 shell 脚本，Phase 0 里脚本以状态 126 退出。AppArmor 先只加 `networking`。数据目录用 Click 允许的 `~/.local/share/<包名>.<维护者>/`。`path_provider` 去执行 `/usr/bin/xdg-user-dir` 会被拒绝，手机上没有旧库可迁，直接跳过。

窗口这一段照 Phase 1 的最终做法，不照它最初那一版：

- `gtk_init` 之前设置 `GDK_GL=gles`。桌面 GL 在 libhybris 上创建失败，窗口会只剩背景色。
- 用普通 `GtkWindow`，不要 `GtkApplication`。后者向会话总线注册名字，Lomiri 会拒绝。现在的 `my_application.cc` 正是 `GtkApplication`，还带 `G_APPLICATION_HANDLES_COMMAND_LINE`。
- 不要 header bar，不要 1280×720。`gtk_window_fullscreen` 会把顶栏藏起来。只最大化，停在指示器下面（6T 上是 1080×2277，比面板少 63 像素）。
- Wayland 上 GTK 3.24 不读 `GDK_SCALE`，输出 scale 是 1。按 `GRID_UNIT_PX` 取整数倍（6T 上是 3），只对 `FlView` 把分配尺寸和触摸坐标除以这个倍数，再把 scale 报成同样的数。竖屏逻辑宽度才会落到 360，现有的窄屏布局才会出现。不要为了手机去改桌面断点。
- 中文必须在第一版就接上。官方 arm64 引擎没有 fontconfig 的按字回退，缺字就是方框。主题的 `fontFamilyFallback` 按族名要文泉驿、Noto CJK，或打进包里的 Droid Sans Fallback。`font_utils.dart` 里用 `libfontconfig.so.1` 枚举字体，管的是字体选择器，不管 Flutter 怎么画汉字。
- 软键盘：Lomiri 会设 `GTK_IM_MODULE=Maliit`，系统 GTK 的 immodules 里没有这个模块。`gtk_init` 之前清掉它。6T 的 Wayland 上没有 text-input v3，用 Click 里自带的 `im-maliit.so`，模块缓存写到 Click 可写的 `~/.cache/`。

滚动帧率沿用官方 embedder 的整帧提交。GasTube 在这条路径上测到大约 44 fps，局部重绘在没有 buffer age 字符串的 Adreno 上留下残影，已经否掉。PiliPlus 的 runner 还写了 `fl_dart_project_set_enable_impeller(project, FALSE)`，桌面 Linux 用的是 Skia。不要把 GasTube 那份改过的 Impeller `wl_surface` 引擎塞进这个包。界面能滑、字能看清，就进入播放。视频流畅度不靠这次改 embedder。

启动期缺库要变成跳过，而不是没捕获的异常。手机上有 `libasound.so.2`。没有 libmpv，也没有 WebKit，tray 用的 ayatana appindicator 同样不要假设存在。

## GTK：这一仓库多出来的一步

`linux/CMakeLists.txt` 和 `linux/runner/CMakeLists.txt` 把 `webkit2gtk-4.1`（没有则 4.0）链进主程序。GasTube 的 runner 不链它。Ubuntu Touch 的 Click 框架不提供这份库，根分区也不能再装包。

Ubuntu Touch 构建不要链接 WebKit，登录页里的 `LinuxWebview` 在这个开关下不创建。扫码登录和粘贴 cookie 已经在 `lib/pages/login/controller.dart` 里，不依赖这个插件。密码登录的极验对话框会缺页面，第一版就保持这样。不要把 WebKit 打进 Click。

同一构建关掉 media_kit 对 libmpv 的链接，Dart 侧不调用 `MediaKit.ensureInitialized()`，也不创建 `Player`。这和 GasTube 在 Phase 1 用 `MEDIA_KIT_LIBS_AVAILABLE` 关掉插件是同一件事，只是这里关掉之后不再打开：没有页内画面要画。

## 系统播放器：为什么更短

GasTube 的长视频最后停在这条交法上，并且在 6T 上对过：

- Content Hub 把一个本地文件 `Charge` 给 `mediaplayer-app`，类型 `videos`。`https` 不要交给 URL Dispatcher，那会打开浏览器。`video://` 会被改成 `file://`。
- 合成的一条地址可以直接交。更高画质是纯视频加一条音轨，系统播放器一次只收一条地址，所以写成一份本地 MPD，里面两条绝对 https。文件进 `HubIncoming` 之后相对地址会失效。
- 带查询串的地址不能放在 `BaseURL` 里，dashdemux 会找不到流。每一段的 `media` 用绝对 https。`SegmentBase` 加这种 `BaseURL` 在 6T 上没有出画面。
- 跳转要文件里有 `sidx`，清单用展开后的 `SegmentList`。整段普通 mp4 硬写成一个 `SegmentList` 时，快进会回到开头。
- H.264 的 fMP4 和 VP9 的 WebM（按 Matroska Cues 拆段）都播过，音画同步，手指快进留得住。请求头是空的，YouTube 那两条地址仍然 200。
- 播放器在前台时，Lomiri 把 Click 所在 cgroup 里的每个进程停住（状态 `T`）。GasTube 不再画整窗，功耗大约降到页内播放的一半。
- 进度条、倍速、字幕、小窗、播完自动下一首，都到不了另一个应用的窗口上。`media-hub` 的 `setPlaybackRate` 仍是未实现。

PiliPlus 的点播比这少两步。

没有「先交 360p 合成流，高清以后再说」。`PlayUrlModel.dash` 才是正常结果，视频和音频本来就是两条。`durl` 是淘汰格式，还可能是多段 `edl://`，系统播放器不认 edl。第一版只交 DASH。写不出清单就停在占位，不退回页内 mpv。

清单的材料已经在 `BaseItem` 上：`baseUrl`、`mimeType`、`codecs`、`segmentBase.initialization`、`segmentBase.index_range`。音频优先普通 AAC（`dash.audio`），不要先拿 flac 或 dolby。视频优先 AVC，其次 HEVC。AV1 和 DVH1 不进第一份清单。骁龙 845 的系统解码器列表里没有可用的 AV1；HEVC 要在真机上看到画面再算通过，不按芯片规格写成已经能播。

MPD 的形状沿用已经通过的那一种：`SegmentList`，初始化用 `sourceURL` 加 range，每一段的 `media` 是带查询串的绝对地址。哔哩哔哩的 `index_range` 指向文件里的 `sidx`。若整段只写成一个 `mediaRange` 而快进回到开头，就按 GasTube 对 YouTube itag 136 的做法，把 `sidx` 展开成多段。这一步是对照试验，不是新设计。

没有短视频解码器分支，也就没有「长视频交出、Shorts 留在页内」的双路径。竖屏单条视频同样交出。需要在本进程里一条条预加载的滑动页，第一版不做。

也不做这些 GasTube 后期才补上、并且依赖页内解码器或 cgroup 外常驻进程的事：hybris 的 flush、锁屏切片、`gastube-seek` 用户服务、豁免暂停之后的自动连播。OpenStore 的机器没有那份用户服务。Click 自己 `setsid` 也出不了 cgroup，Lomiri 会把表里的 pid 全部停住。续播可以后做。第一版从开头放，或者接受系统播放器自己的继续对话框（GasTube 记录过这个对话框会把进度冲掉）。

## 系统播放器：必须先做的一次试验

前一步不过，就不写交出代码。6T 上用 `lomiri-app-launch` 不适合从 Click 里调用，它访问 systemd 会被拒绝。试验用手动命令。应用里正式的交法仍是 Content Hub。

1. 在手机上取一条点播的 AVC 视频 m4s 和对应的 AAC m4s。地址绑在取它的那台机器上，不能在编译机上取了再交给手机。
2. 不带 `Referer`、不带 User-Agent，对视频和音频各做一次带 Range 的 GET，再各做一次带上页内那组头的 GET。要记的是状态码。
3. 若两边不带头也是 200，就写成上面那份 MPD，`Charge` 给 `mediaplayer-app`。看有没有画面、有没有声音、拖一次之后还在不在。
4. 若不带头是 403、带头是 200，就停在这里。系统播放器的 `%u` 和 Content Hub 都不带请求头。`OpenUriExtended` 能带头，但那是本应用自己的 media-hub 会话，画面不在系统播放器里，而且会把整窗光栅留在本进程。不要在 Click 里开一个转发来补头：播放器在前台时这个进程是停住的，转发一停，后面的分片就断。GasTube 为高清排除过同一种「在 Click 里合成」的做法。

这一步是和 YouTube 不一样的地方。播放器代码把 `Referer: https://www.bilibili.com` 设在每一次 `open` 上。系统播放器看不到这个头。试验没有结果之前，不要把「GasTube 的 URL 能播」写成「哔哩哔哩的 m4s 也能播」。

通过之后，HEVC 用同一份清单形状再交一次。直播不并进这一步。直播间走 `getRoomPlayInfo`，协议是另一套（常见是 FLV 或 HLS）。手机上有 `libgsthls.so`。FLV 要单独看 playbin 认不认，不和点播 MPD 混成一次验收。

## 交出之后留在应用里的

和 GasTube 长视频页最后的样子相同，只是占位上没有弹幕层。

- 第一次打开点播，写出清单并交出。
- 从系统播放器回到这一页，16:9 的位置是封面和播放按钮，不自动再交一次。点按钮才按当前画质重写清单。地址过期就在这一次重写里重新要 playurl。
- 画质在这个框上选，只影响这一条。换画质就是另一份清单、另一次 Charge。
- 上一首、下一首放在视频页上，由人点。播放器占着前台时本进程是停住的，收不到播完，不能自己交下一条。
- 评论和推荐仍在这一页，要等系统播放器让出前台才能看。两边不能同时操作。手机上的 `player.qml` 在应用不再处于前台时自己 `pause()`，所以按 Home 或锁屏，画面和声音一起停。

弹幕、倍速、字幕、页内小窗，都不排进实现。`canvas_danmaku` 画在 `Video` 上面。系统播放器的窗口不属于这个 Click，Lomiri 也不会让一个 Click 画在另一个应用上。全屏和旋转同样改不到播放器：Content Hub 的 `Charge` 只有类型、名字和地址。旋转锁定开着时，横视频会在竖屏窗口里打开，这是外壳的限制。

## 建议的顺序

1. Ubuntu Touch 的 runner：GLES、普通 `GtkWindow`、最大化、整数缩放、输入法、中文回退。不链 WebKit，不链 libmpv。桌面构建不动。
2. 打成 Click，在 6T 上打开首页、搜索和设置。Hive 落在 Click 可写目录。旋转、锁屏、切走再回来，进程还在。

这两步的执行计划、实现笔记和故障记录在 [ubuntu-touch-click.md](ubuntu-touch-click.md)。
3. 做上面的 CDN 头试验。403 就停，不写代理。
4. 试验通过后，只在点播页写 MPD 并 Charge。先 AVC 加 AAC，再 HEVC。
5. 占位、本片画质、手动上一首和下一首。

直播、后台纯音频、观看历史在播放器占着前台时继续写，都排在这五步之后。它们在 GasTube 里也是主路径通过以后的修补，而且后台音频还要再对哔哩哔哩的音轨做 Range，不能把 YouTube 那次切片结果直接拿来用。
