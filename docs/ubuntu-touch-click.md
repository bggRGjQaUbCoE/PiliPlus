# Ubuntu Touch：打成 Click 并装到 6T

日期：2026-10-16  
对应路线：`docs/ubuntu-touch-port.md` 建议顺序的第 1 步和第 2 步  
状态：第 7 步手测已通过。视频不能播，滑动也不满 60 帧，这两项都在这份 Click 的范围之外。

这篇只做到一件事：PiliPlus 的界面在 OnePlus 6T 上从启动器打开，首页、搜索和设置能进，设置能写入 Hive，旋转、锁屏和切走不会把进程打崩。系统播放器、CDN 请求头试验、MPD 都不在这里。

GasTube 的 GTK 探针和 Flutter hello 已在 2026-10-02 于同一台手机上通过，见 `docs/doc_from_gastube/ubuntu-touch-phase0.md`。这次不重做探针，也不再做一个空的 hello。窗口做法用 Phase 1 里最后生效的那一版，不重复「先全屏、再改缩放、再修键盘」的来回。

## 不做

- 不升级 Flutter，仍是 `pubspec.yaml` 里的 3.47.7。不要换 GasTube 的 3.47.1 引擎，也不要换那份改过的 `libflutter_linux_gtk.so`。
- 不在手机 rootfs 里 apt 安装任何包。系统分区只剩约 94 MB。
- 不在容器里安装 libmpv、WebKit、JDK、FFmpeg。
- 不把 Ubuntu Touch 写成所有 `Platform.isLinux`。桌面、现有 x64 CI 保持原样。差异只在 `--dart-define=PILI_UBUNTU_TOUCH=true` 和对应的 CMake 开关里。
- 不把 shell 脚本设成 Click 的 `Exec`。Phase 0 里这样做以状态 126 退出。
- 不使用 `GtkApplication`。它在 Lomiri 上注册 D-Bus 名会被拒绝。
- 不调用 `gtk_window_fullscreen`。那会藏起顶部状态栏。
- 不在 x64 台式机上直接 `flutter build linux`。这台机器的 glibc 高于 2.31，链出来的 runner 在 6T 上加载不了。

## 机器

| 角色 | 机器 | 做什么 |
| --- | --- | --- |
| 打包和安装 | 这台 Linux x64 台式机 | adb、Clickable 只复制已经编好的 bundle，不重新链接。`clickable review`、安装、收日志 |
| 编译 | MacBook Pro，`alpha@10.0.0.118` | Docker Desktop 里的 `ubuntu:20.04` `linux/arm64` 容器，`flutter build linux --release` |
| 运行 | OnePlus 6T，`d3ba49e7` | Ubuntu Touch 20.04.6，OTA-12，arm64，framework `ubuntu-sdk-20.04` |

非交互 SSH 的 `PATH` 里没有 `docker`。使用 `/Applications/Docker.app/Contents/Resources/bin/docker`。钥匙串锁着时 `docker pull` 会失败，沿用 Phase 0 的做法：匿名 token 下载 20.04 arm64 rootfs，`docker import`，构建时 `DOCKER_BUILDKIT=0`。

Flutter SDK 放在 Mac 上的新 volume `piliplus-flutter-sdk`。不要写入 `gastube-flutter-sdk`，那份是 3.47.7 之外的 3.47.1。

官方 stable 压缩包是 x64。容器里用 `git clone --branch 3.47.7`，再让 Flutter 工具自己下载 arm64 的 Dart SDK 和 GTK engine。把 `flutter --version` 印出的 engine revision 记到实现笔记，不要沿用 `5d531788691ec3404cac0cee66ead4007b177363`。

若 Mac 上还留着 `gastube-flutter-focal-ut:20.04`，可以把它当编译依赖的起点（已有 GTK 3.24.20 和 `libasound2-dev`），再打一个新标签 `piliplus-flutter-focal:20.04`。不要往 GasTube 那个标签里加包。新标签里仍然不装 libmpv 和 WebKit。

## 包

| 项目 | 值 |
| --- | --- |
| Click 名 | `piliplus.alphaliu01` |
| 版本 | `2.1.6`，与 `pubspec.yaml` 一致 |
| framework | `ubuntu-sdk-20.04` |
| 架构 | `arm64` |
| `Exec` | `piliplus` |
| AppArmor | 只有 `networking` |
| 可写数据 | `~/.local/share/piliplus.alphaliu01/` |
| 缓存 | `~/.cache/piliplus.alphaliu01/` |

维护者名和 GasTube 的 `gastube.alphaliu01` 相同。Click 允许写入的是这个名字，不是 `com.example.piliplus`，也不是 `~/.local/share/piliplus`。以后若要改维护者名，目录和已经装上的应用 id 会一起变，在第一次 `clickable review` 之前定下来。

工程放在 `packaging/ubuntu-touch/piliplus/`。Clickable 的构建步骤只把 Mac 上拉回来的 release bundle 拷进包，不调用编译器。装完后对比 bundle 里的 `piliplus` 和 Click 安装树里的同一文件，sha256 必须相同。

## 步骤

### 1. 核对三台机器

不重做探针。只确认路径还在。

在台式机上：

```bash
adb devices -l
clickable --version
ssh -o BatchMode=yes alpha@10.0.0.118 'uname -m; /Applications/Docker.app/Contents/Resources/bin/docker info >/dev/null && echo docker-ok'
```

在手机上再读一次系统和库，与 Phase 0 的设备记录对照：

```bash
adb shell 'cat /etc/os-release; getconf GNU_LIBC_VERSION; dpkg-query -W libc6 libstdc++6 libgtk-3-0'
```

完成标准：`d3ba49e7` 是 `device`；系统仍是 20.04；glibc 仍是 2.31；GTK 仍是 3.24.20；Mac 上的 Docker 服务端仍是 `linux/arm64`。有一项对不上就停，把输出写进故障记录，不开始编。

### 2. 容器

在 Mac 的 arm64 容器里准备 Focal 的编译环境：GTK 3 开发包、`libasound2-dev`、Flutter 3.47.7。容器内的 `libc6`、`libstdc++6`、`libgtk-3-0` 版本要和手机相同。

源码从台式机同步到 Mac，排除 `build/` 和 `.dart_tool/`。不在 Mac 上用它自己的系统编译器编这份 Linux 目标。

完成标准：容器里 `flutter --version` 是 3.47.7，`dpkg-query` 的三个库版本与 6T 一致。engine revision 已写入实现笔记。

### 3. Ubuntu Touch 构建开关

桌面 runner 不动。开关打开时才走下面这些。

CMake（只在 Ubuntu Touch 构建）：

- 不查找、不链接 WebKit。`linux/runner/CMakeLists.txt` 里的 `PkgConfig::WEBKIT` 和 `linux_webview_plugin.cc` 不进这个目标。
- 不链接 libmpv。media_kit 的 Linux 插件走不链 libmpv 的桩，与 GasTube 关掉 `MEDIA_KIT_LIBS_AVAILABLE` 相同。
- 不链接 ayatana appindicator。`tray_manager` 若因此编不过，就从这个构建里拿掉，不往容器里装那个开发包。
- `libasound` 可以链。手机上已有 `libasound.so.2`。

runner，在 `gtk_init` 之前：

- `GDK_GL=gles`
- 清掉环境里的 `GTK_IM_MODULE=Maliit`

窗口：

- 普通 `GtkWindow`，不要 header bar，不要默认 1280×720
- 去掉装饰后只 `gtk_window_maximize`
- 启动时打印每个 monitor 的几何尺寸、`gdk_monitor_get_scale_factor`，以及 `GDK_SCALE`、`GDK_DPI_SCALE`、`GRID_UNIT_PX`
- 整数倍取 `GRID_UNIT_PX / 8` 的四舍五入，最小为 1。6T 上 `GRID_UNIT_PX=21`，结果是 3。只对 `FlView` 把报告给 Flutter 的分配尺寸和触摸坐标除以这个倍数，并把 scale 报成同一个数。不要在代码里写死 3，日志里要能看出算式。

输入法：Wayland 上若没有 `zwp_text_input_manager_v3` 和 `gtk_text_input_manager`，使用 Click 内的 `lib/im-maliit.so`。这个模块按 GPL-3.0-or-later 放进 `third_party/im-maliit/`，实现笔记里写下它从哪一份 GasTube 构建拷来、或在容器里如何编出。模块缓存写到 `~/.cache/piliplus.alphaliu01/immodules.cache`，包内不写绝对路径。不往 rootfs 装 immodule。

Dart，仅当 `PILI_UBUNTU_TOUCH` 为真：

- `main` 不调用 `MediaKit.ensureInitialized()`，也不创建 `Player`。
- `getApplicationSupportDirectory()` 的结果改到 `~/.local/share/piliplus.alphaliu01/`，再交给 `GStorage.init`。Hive 仍在这个目录下的 `hive/`。不要让 path_provider 去建 `com.example.piliplus` 或单独的 `piliplus` 目录。
- 临时目录和下载目录同样落在上述数据目录或 `~/.cache/piliplus.alphaliu01/`。不调用 `getApplicationDocumentsDirectory()`，那会执行 `/usr/bin/xdg-user-dir`，AppArmor 会拒绝。
- `PlatformUtils.isDesktop` 在 Linux 上为真，现在的 `main` 会走 `window_manager` 并设置桌面窗口尺寸。这个开关下跳过那一段，窗口大小只由 runner 和 Lomiri 决定。
- `Pref.uiScale` 保持默认 1。runner 已经把 device pixel ratio 设成整数倍，Dart 再乘一次会把界面放大两次。
- 极验对话框不创建 `LinuxWebview`。扫码和粘贴 cookie 保持原样。
- 主题的 `fontFamilyFallback` 带上文泉驿、Noto CJK 和 Droid Sans Fallback。arm64 引擎没有按字回退，只认族名。Material 自带的西文回退列表在合并时会盖掉主题级列表，所以每个文字样式都要带上这份中文列表，Cupertino 的 `inherit: false` 也要补。手机上这两套中文字体在 `/usr/share/fonts/`，AppArmor 的 fonts 抽象允许读取。

构建命令：

```bash
flutter build linux --release --dart-define=PILI_UBUNTU_TOUCH=true
```

完成标准：台式机上不带这个开关的 Linux 构建配置没有被改成手机窗口。这一步先不要求手机已经打开。

### 4. 在容器里编出 bundle

完成标准：

- `build/linux/arm64/release/bundle/piliplus` 存在，旁边有 `lib/libflutter_linux_gtk.so` 和 `data/icudtl.dat`。
- `file` 显示 ARM aarch64。
- `readelf -d` 的 `RUNPATH` 是 `$ORIGIN/lib`。没有 `RPATH`，没有 `/home/alpha` 或 x64 库路径。
- `readelf -V` 里的 `GLIBC_*` 不超过 2.31，`GLIBCXX_*` 不超过手机上的 libstdc++ 10.5。
- `NEEDED` 里没有 `libwebkit`、`libmpv`、`libayatana-appindicator`。其余每一条要么在 bundle 的 `lib/` 里，要么是手机上已有的 GTK、glib、libstdc++、libgcc、libc、libasound。多出来的库先改构建，不装到手机上试。

把 `readelf` 的原文贴进实现笔记。

### 5. 在台式机上打 Click

把 bundle 拉回台式机，用 `packaging/ubuntu-touch/piliplus/` 打包。

```bash
clickable build --arch arm64
clickable review --arch arm64
```

完成标准：review 是 pass。安装树里的 `piliplus` 与容器产物 sha256 相同。desktop 的 `Exec` 是 `piliplus`，不是脚本。

### 6. 装到 6T 并看到第一帧

```bash
clickable install --arch arm64
clickable launch --arch arm64
clickable logs
```

完成标准：

- 进程保持运行。日志里有 `GDK_GL=gles context created`，没有 `Unable to create a GL context`，没有 D-Bus `RequestName` 被拒绝后退出。
- 窗口在状态栏下面，没有桌面 header bar。日志里的逻辑宽度约 360、device pixel ratio 为 3、物理宽度 1080。顶栏还在。
- 首页的汉字不是方框。
- 不要求这一步已经改完一项设置。进程若因为 Hive 目录被拒绝而退出，停在故障记录里，先改目录再装，不要加宽 AppArmor。

Lomiri 对失去焦点的 Click 发 SIGSTOP，状态会变成 `T`。切回来应变回运行。这不是崩溃。

### 7. 手测

每项做一次，结果写进实现笔记。看屏幕的部分由手机前的人做。

1. 首页、搜索页、设置页都能打开。搜索可以没有结果，但不能把进程打崩。
2. 在设置里改一项会写入 Hive 的值，完全划掉再打开，值还在。手机上应能看到 `~/.local/share/piliplus.alphaliu01/hive/` 里的文件。
3. 搜索框获得焦点后软键盘升起。中文和英文各输入一次，收起后焦点还在。
4. 竖屏是底部导航，不是侧栏。字号接近系统应用，而不是 96 DPI 的桌面字号。
5. 竖屏转到横屏再转回，锁屏约 10 秒后解锁，切到系统设置再回来，从应用列表划掉再打开，拔掉 USB 后再从启动器打开。进程还在，当前路由还在。

## 任务

### 等待你完成

- [x] 6T 用数据线接到台式机，解锁屏幕。`adb devices` 里 `d3ba49e7` 为 `device`。
- [x] 构建期间 Mac 开机、接电、不睡眠，Docker Desktop 在运行。
- [x] 装上之后看首页、设置、搜索、键盘、旋转、锁屏、切走和划掉。

### 等待实现

- [x] 第 1 步核对通过，版本没有偏离 Phase 0。
- [x] 第 2 步容器和 Flutter 3.47.7 engine revision 记入实现笔记。
- [x] 第 3 步开关：GLES、普通窗口、最大化、整数缩放、输入法、中文回退、数据目录、不链 WebKit 和 libmpv。
- [x] 第 4 步 `readelf` 通过。
- [x] 第 5 步 `clickable review` 为 pass，sha256 一致。
- [x] 第 6 步进程在 6T 上保持运行，并画出第一帧。
- [x] 第 7 步手测记入实现笔记。

## 实现笔记

### 2026-10-16 第 1 步

- 步骤：核对三台机器。
- 做了什么：`adb devices -l` 里 `d3ba49e7` 为 `device usb:1-7`。Clickable 8.10.0，已是最新。`ssh -o BatchMode=yes alpha@10.0.0.118` 返回 `aarch64` 和 `docker-ok`。手机 `/etc/os-release` 为 Ubuntu 20.04.6 LTS、VARIANT=Touch。`getconf GNU_LIBC_VERSION` 为 2.31。`dpkg-query`：`libc6 2.31-0ubuntu9.18`，`libstdc++6 10.5.0-1ubuntu1~20.04`，`libgtk-3-0 3.24.20-0ubuntu1.2`。与 Phase 0 一致，开始编。
- 产物路径和 sha256：无。
- 手机上的 pid 和日志要点：未启动应用。

### 2026-10-16 第 2 步

- 步骤：容器。
- 做了什么：Mac 上已有 `gastube-flutter-focal-ut:20.04`（`498491ed61bb`）。`DOCKER_BUILDKIT=0 docker build --pull=false` 只改标签，得到 `piliplus-flutter-focal:20.04`，没有往 GasTube 标签里加包，也没有 apt 安装 libmpv 或 WebKit。新 volume `piliplus-flutter-sdk` 里 `git clone --depth 1 --branch 3.47.7`。`flutter --version`：Flutter 3.47.7，framework `abaf9c5237`，engine `deb287481e3ce9468f3434937ced4240a70539ca`（revision deb287481e），Dart 3.13.5。不是 GasTube 的 `5d531788691ec3404cac0cee66ead4007b177363`。pub 缓存在独立 volume `piliplus-flutter-pub`，不和 GasTube 的缓存混用。
- 产物路径和 sha256：镜像 `piliplus-flutter-focal:20.04`。bundle 还没有。
- 手机上的 pid 和日志要点：未启动应用。

### 2026-10-16 第 3 步

- 步骤：构建开关。
- 做了什么：桌面 `linux/runner/my_application.cc` 未改，而且只编进桌面目标。`linux/runner/main.cc` 只在 `PILI_UBUNTU_TOUCH` 时进入 `pili_ubuntu_touch_main`。CMake 在环境变量 `PILI_UBUNTU_TOUCH` 时跳过 WebKit，并在 `include(flutter/generated_plugins.cmake)` 之前把 `MEDIA_KIT_LIBS_AVAILABLE` 和 `MIMALLOC_USE_STATIC_LIBS` 都强制设为 `OFF`。只关前者不够：`media_kit_libs_linux` 1.2.1 仍会按后者的默认值下载 mimalloc。`tray_manager` 0.8 的仓库根目录没有 `linux/`，不是会链 ayatana 的 CMake 插件，所以没有从 `generated_plugins.cmake` 里删它（只删插件、不改 `generated_plugin_registrant.cc` 会在链接时报未定义引用）。`jni` 的 Linux CMake 找不到 JVM 时不把库打进包。`third_party/im-maliit/` 从 FluxTube 的 GasTube 树拷来，许可证 GPL-3.0-or-later；容器里用 `gcc -shared` 编进 bundle 的 `lib/im-maliit.so`，不装进 rootfs。缩放用 `--export-dynamic` 和 `dlsym(RTLD_NEXT)` 拦截 `gtk_widget_get_scale_factor`、`gtk_widget_get_allocation`、`gdk_event_get_coords`，倍数是 `round(GRID_UNIT_PX/8)`，日志格式为 `piliplus: flutter scale N = round(GRID_UNIT_PX/8)`。Dart 侧数据目录、日志、图片缓存都不走 `path_provider`；`window_manager` 和托盘在这个开关下跳过；`Pref.uiScale` 在 builder 里强制为 1；极验和内置浏览器页不创建 `LinuxWebview`。容器在编译前执行与 `lib/scripts/patch.ps1 Linux` 相同的 Flutter 和 `material_ui` 补丁。
- 产物路径和 sha256：源码在仓库里。
- 手机上的 pid 和日志要点：未启动应用。

### 2026-10-16 第 4 步

- 步骤：arm64 bundle。
- 做了什么：`piliplus` 是 ARM aarch64 ELF。`RUNPATH` 是 `$ORIGIN/lib`，没有 `RPATH`。可执行文件的版本需求是 `GLIBC_2.17`、`GLIBCXX_3.4`、`CXXABI_1.3`。`check-bundle.sh` 走过可执行文件和 `lib/*.so`，没有超过 glibc 2.31 / GLIBCXX 3.4.28 / CXXABI 1.3.12，也没有 `libwebkit`、`libmpv`、`libayatana`、`libappindicator`、`libjvm`。`libapp.so` 里有字符串 `piliplus: logical=`，说明 `--dart-define=PILI_UBUNTU_TOUCH=true` 进了内核快照。`libcnativeapi.so` 需要 `libX11.so.6` 和 `libXi.so.6`，手机上这两份库都在。`libflutter_linux_gtk.so` 需要 `libepoxy.so.0`，手机上也有。
- 产物路径和 sha256：`packaging/ubuntu-touch/piliplus/bundle/piliplus`，sha256 `173b3cbfbf4a3f2bf28bc06139b3a2ba5df6e404bbcac31f828754d9de10cb02`，md5 `73ad5e2faf4f2d0332236da2939f91a3`。
- 手机上的 pid 和日志要点：还没安装。

### 2026-10-16 第 5 步

- 步骤：打 Click。
- 做了什么：`clickable build --arch arm64` 只复制 bundle。review 是 pass。安装树里的 `manifest.json` 已替换成 `architecture=arm64`、`framework=ubuntu-sdk-20.04`，apparmor 的 `policy_version` 是 `20.04`。`Exec=piliplus`，文件是 ELF，不是脚本。安装树里的 `piliplus` 与容器产物 sha256 相同。`clickable install` 在清理临时文件时打印了 `ADB_COMMAND_FAILED`，包本身已经装上：手机上的二进制 md5 与 bundle 一致。
- 产物路径和 sha256：`packaging/ubuntu-touch/piliplus/build/aarch64-linux-gnu/app/piliplus.alphaliu01_2.1.6_arm64.click`。二进制 sha256 同上。
- 手机上的 pid 和日志要点：安装完成，还没启动。

### 2026-10-16 第 6 步

- 步骤：第一帧。
- 做了什么：`clickable launch` 之后进程保持运行。日志有 `GDK_GL=gles context created`，有 `piliplus: flutter scale 3 = round(GRID_UNIT_PX/8) GRID_UNIT_PX=21`，随后 `configure 1080x2277`，再有 `piliplus: logical=360.0x759.0 dpr=3.0`。没有 `Unable to create a GL context`，也没有 D-Bus `RequestName`。输入法日志是 `wayland text-input v3=0`，然后用包内的 `lib/im-maliit.so`，缓存写到 `/home/phablet/.cache/piliplus.alphaliu01/immodules.cache`。dconf 写 `/run/user/32011/dconf/user` 被拒绝，ALSA 读不到 `/usr/share/alsa/alsa.conf`，音量插件因此没有默认声卡。这两条没有让进程退出，AppArmor 仍只有 `networking`，没有加规则。汉字是不是方框要看屏幕，不在这次日志里。
- 产物路径和 sha256：手机路径 `/opt/click.ubuntu.com/piliplus.alphaliu01/2.1.6/piliplus`，md5 `73ad5e2faf4f2d0332236da2939f91a3`。
- 手机上的 pid 和日志要点：pid `13531`，状态 `Ssl`。

### 2026-10-16 第 7 步

- 步骤：手测。手机前的人确认首页汉字、Hive、搜索、软键盘、底部导航、旋转、锁屏和切走都通过。下面是同一时段 journal 和 Hive 文件能对上的部分。
- 做了什么：
  1. 首页三次启动的逻辑尺寸都是 `360.0x759.0`、`dpr=3.0`（12:52:47 pid 13531，12:55:39 pid 13763，12:59:18 pid 13905）。360 低于侧栏断点，竖屏走底部导航。首页汉字由看屏幕的人确认不是方框。搜索记录里留下的是 UTF-8「第七翼刀」，说明这条路径上的中文没有丢成问号或空字节。
  2. Hive 在 `~/.local/share/piliplus.alphaliu01/hive/`。`setting.hive` 在 12:54 已有内容，进程换成 13905 之后于 12:59:53 增长到 327 字节，里面有 `horizontalScreen`、`themeMode`、`textScale`。`historyword.hive` 在 12:55:47 写成 40 字节，键 `cacheList`，值是「第七翼刀」。12:56:10 进程被划掉、12:59:17 再次打开后，这个文件还在，没有被空文件替换。
  3. 每次启动都有 `im context id=maliit`，模块是包内的 `lib/im-maliit.so`。软键盘升起、中文和英文各输入一次，由看屏幕的人确认。journal 里没有单独的键盘弹出行；能对上的是 12:55:47 写入的那条中文搜索记录。
  4. 旋转没有重启进程。pid 13531：12:54:00 `configure 2340x1017`，12:54:02 回到 `1080x2277`，12:54:07 再横、12:54:08 再竖。pid 13763：12:56:05 横、12:56:08 竖。
  5. 锁屏和切走由看屏幕的人确认，进程没有打出崩溃。Lomiri 在 12:55:18 和 12:56:10 记了 `ApplicationManager::onProcessStopped`，应用 id 是 `piliplus.alphaliu01_piliplus`。划掉之后是新进程：13531 停在 12:55:18，13763 于 12:55:38 启动；13763 停在 12:56:10，13905 于 12:59:17 启动。13905 手测结束时仍是 `Ssl`。拔掉 USB 这一项 journal 里看不出来，没有单独记成通过。
- 视频：12:54:51 和 12:55:03，点击进了 `PlPlayerController.setDataSource`，抛出 `MediaKit.ensureInitialized must be called before using any API from package:media_kit`。这是这个 Click 故意不调用 `MediaKit.ensureInitialized()` 的结果。两次异常之后 pid 13531 都还在，直到 12:55:18 才被外壳停掉。
- 滑动帧率：journal 里没有帧时间。看屏幕的人确认滑动和 GasTube 一样到不了 60。这一项不改 AppArmor，也不换引擎。
- 产物路径和 sha256：Hive 目录如上。二进制仍是第 6 步那个 md5。
- 手机上的 pid 和日志要点：手测结束时 pid `13905`，状态 `Ssl`。同一次启动仍有 AppArmor 拒绝 `/etc/gtk-3.0/settings.ini`、`/usr/share/alsa/alsa.conf`、`/proc/sys/vm/max_map_count`、`/proc/self/loginuid`，以及 `exec /usr/bin/stat`。这些拒绝没有让第 7 步失败，规则保持只有 `networking`。

## 故障记录

出现一次就加一行，保留命令输出里能定位的那几行。

| 日期 | 现象 | 关键日志 | 处理 | 结果 |
| --- | --- | --- | --- | --- |
| 2026-10-16 | 容器里第一次 `flutter build linux` 在 Dart 前端失败。Flutter 3.47.7（`abaf9c5237`）和锁文件里的 `material_ui` 1.6.0 与当天绿灯的 Linux CI 相同，但 `TabBarState`、`textPainter`、`horizontalDragGestureRecognizer` 这些类型不存在。 | `Target kernel_snapshot_program failed`。`dyn_tab_bar.dart:48` `Type 'TabBarState' not found`。`paragraph_ellipsis.dart` `textPainter` 未定义。 | 上游 Linux 任务在编译前执行 `lib/scripts/patch.ps1 Linux`，给 Flutter SDK 和 pub-cache 里的 `material_ui` 打补丁。容器脚本补上同一组补丁，不改 `pubspec.yaml`，不升级 Flutter。 | 补丁能加上。Dart 前端随后通过。 |
| 2026-10-16 | `app_links_linux` 1.0.4 在 Focal 的 glib 2.64 上编不过。桌面 CI 用的是更新的 Ubuntu，同一行能过。 | `app_links_plugin_linux.cc:133` `cannot initialize a variable of type 'GPtrArray_autoptr' with an rvalue of type 'void *'`。`pkg-config --modversion glib-2.0` 为 2.64.6。 | 只在这个容器里把 `g_steal_pointer` 的结果 `static_cast` 成 `GPtrArray*`。不改桌面依赖。 | 这一行不再报错。下一次失败是链接。 |
| 2026-10-16 | 关掉 `MEDIA_KIT_LIBS_AVAILABLE` 之后，`media_kit_video` 走了不链 libmpv 的桩，但 `media_kit_libs_linux` 1.2.1 仍会下载并 `make` mimalloc。Flutter 只印出 `clang: error: linker command failed`，真正的命令在构建目录的 `mimalloc/out`。 | `CMakeCache.txt` 里 `MEDIA_KIT_LIBS_AVAILABLE:BOOL=OFF`。构建树里有 `mimalloc/out/release`。 | 在包含插件之前再把 `MIMALLOC_USE_STATIC_LIBS` 强制设为 `OFF`。桌面不设这个环境变量，仍走原来的默认值。 | 下一次链接不再进入 mimalloc。 |
| 2026-10-16 | 链接 `piliplus` 失败。Ubuntu Touch 目标没有编译 `linux_webview_plugin.cc`，但 `my_application.cc` 仍在目标里并调用注册函数。 | `my_application.cc:(.text+0x538): undefined reference to LinuxWebviewPluginRegister` | Ubuntu Touch 目标不再编译 `my_application.cc`。桌面目标仍编译它和 WebKit 插件。 | 链接通过。Click 已装上。 |
| 2026-10-16 | 打开点播后没有画面。进程没有退出。 | 12:54:51 与 12:55:03，`PlPlayerController.setDataSource`：`MediaKit.ensureInitialized must be called before using any API from package:media_kit`。栈顶是一次指针事件。 | 这个 Click 本来就不调用 `MediaKit.ensureInitialized()`，也不链 libmpv。不在这里补上。播放留给系统播放器那一步。 | 意料之中。pid 13531 在两次异常之后仍在。 |

## 进度日志

### 2026-10-16

- 建立这份计划。范围停在 Click 装上 6T 并且界面能用。播放不在这里。
- Click `piliplus.alphaliu01` 2.1.6 已安装。进程 13531 画出第一帧：逻辑宽度 360，dpr 3，物理宽度 1080。手测未做。
- 手测通过。`historyword.hive` 留下「第七翼刀」。旋转在同一进程里于 1080×2277 和 2340×1017 之间切换。划掉后新进程仍读到原来的 Hive。点播抛出 `MediaKit.ensureInitialized`，进程未退出。滑动帧率 journal 无计数，看屏幕的人确认与 GasTube 一样不满 60。
