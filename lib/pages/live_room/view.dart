import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/bottom_control.dart';
import 'package:PiliPlus/pages/live_room/widgets/chat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/header_control.dart';
import 'package:PiliPlus/pages/video/widgets/player_focus.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/view.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with WidgetsBindingObserver, RouteAware {
  final String heroTag = Utils.generateRandomString(6);
  late final LiveRoomController _liveRoomController;
  late final PlPlayerController plPlayerController;
  bool get isFullScreen => plPlayerController.isFullScreen.value;

  late final GlobalKey pageKey = GlobalKey();
  late final GlobalKey chatKey = GlobalKey();
  late final GlobalKey scKey = GlobalKey();
  late final GlobalKey playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _liveRoomController = Get.put(
      LiveRoomController(heroTag),
      tag: heroTag,
    );
    plPlayerController = _liveRoomController.plPlayerController;
    PlPlayerController.setPlayCallBack(plPlayerController.play);
    plPlayerController
      ..autoEnterFullscreen()
      ..addStatusLister(playerListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PageUtils.routeObserver.subscribe(
      this,
      ModalRoute.of(context)! as PageRoute,
    );
    padding = MediaQuery.viewPaddingOf(context);
    final size = MediaQuery.sizeOf(context);
    maxWidth = size.width;
    maxHeight = size.height;
    isPortrait = size.isPortrait;
  }

  @override
  Future<void> didPopNext() async {
    WidgetsBinding.instance.addObserver(this);
    PlPlayerController.setPlayCallBack(plPlayerController.play);
    plPlayerController.danmakuController =
        _liveRoomController.danmakuController;
    _liveRoomController.startLiveTimer();
    if (plPlayerController.playerStatus.playing) {
      _liveRoomController
        ..danmakuController?.resume()
        ..startLiveMsg();
    } else {
      final shouldPlay = _liveRoomController.isPlaying ?? false;
      if (shouldPlay) {
        _liveRoomController
          ..danmakuController?.resume()
          ..startLiveMsg();
      }
      await _liveRoomController.playerInit(autoplay: shouldPlay);
    }
    plPlayerController.addStatusLister(playerListener);

    super.didPopNext();
  }

  @override
  void didPushNext() {
    WidgetsBinding.instance.removeObserver(this);
    plPlayerController.removeStatusLister(playerListener);
    _liveRoomController
      ..danmakuController?.clear()
      ..danmakuController?.pause()
      ..cancelLiveTimer()
      ..closeLiveMsg()
      ..isPlaying = plPlayerController.playerStatus.playing;
    super.didPushNext();
  }

  void playerListener(PlayerStatus? status) {
    if (status == PlayerStatus.playing) {
      _liveRoomController
        ..danmakuController?.resume()
        ..startLiveTimer()
        ..startLiveMsg();
    } else {
      _liveRoomController
        ..danmakuController?.pause()
        ..cancelLiveTimer()
        ..closeLiveMsg();
    }
  }

  @override
  void dispose() {
    videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
    WidgetsBinding.instance.removeObserver(this);
    if (Utils.isMobile) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }
    PlPlayerController.setPlayCallBack(null);
    plPlayerController
      ..removeStatusLister(playerListener)
      ..dispose();
    PageUtils.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!plPlayerController.showDanmaku) {
        _liveRoomController.startLiveTimer();
        plPlayerController.showDanmaku = true;
        if (isFullScreen && Platform.isIOS) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_liveRoomController.isPortrait.value) {
              landscape();
            }
          });
        }
      }
    } else if (state == AppLifecycleState.paused) {
      _liveRoomController.cancelLiveTimer();
      plPlayerController
        ..showDanmaku = false
        ..danmakuController?.clear();
    }
  }

  late double maxWidth;
  late double maxHeight;
  late EdgeInsets padding;
  late bool isPortrait;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (plPlayerController.isPipMode) {
      child = videoPlayerPanel(
        isFullScreen,
        width: maxWidth,
        height: maxHeight,
        isPipMode: true,
        needDm: !plPlayerController.pipNoDanmaku,
      );
    } else {
      child = childWhenDisabled;
    }
    if (plPlayerController.keyboardControl) {
      child = PlayerFocus(
        plPlayerController: plPlayerController,
        onSendDanmaku: _liveRoomController.onSendDanmaku,
        child: child,
      );
    }
    return child;
  }

  Widget videoPlayerPanel(
    bool isFullScreen, {
    required double width,
    required double height,
    bool isPipMode = false,
    Color? fill,
    Alignment? alignment,
    bool needDm = true,
  }) {
    if (!isFullScreen && !plPlayerController.isDesktopPip) {
      _liveRoomController.fsSC.value = null;
    }
    _liveRoomController.isFullScreen = isFullScreen;
    Widget player = Obx(
      key: playerKey,
      () {
        if (_liveRoomController.isLoaded.value) {
          final roomInfoH5 = _liveRoomController.roomInfoH5.value;
          return PLVideoPlayer(
            maxWidth: width,
            maxHeight: height,
            fill: fill,
            alignment: alignment,
            plPlayerController: plPlayerController,
            headerControl: LiveHeaderControl(
              title: roomInfoH5?.roomInfo?.title,
              upName: roomInfoH5?.anchorInfo?.baseInfo?.uname,
              plPlayerController: plPlayerController,
              onSendDanmaku: _liveRoomController.onSendDanmaku,
              onPlayAudio: _liveRoomController.queryLiveUrl,
            ),
            bottomControl: BottomControl(
              plPlayerController: plPlayerController,
              liveRoomCtr: _liveRoomController,
              onRefresh: _liveRoomController.queryLiveUrl,
            ),
            danmuWidget: !needDm
                ? null
                : LiveDanmaku(
                    liveRoomController: _liveRoomController,
                    plPlayerController: plPlayerController,
                    isFullScreen: isFullScreen,
                    isPipMode: isPipMode,
                  ),
          );
        }
        return const SizedBox.shrink();
      },
    );
    if (_liveRoomController.showSuperChat &&
        (isFullScreen || plPlayerController.isDesktopPip)) {
      player = Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: player),
          if (kDebugMode) ...[
            Positioned(
              top: 50,
              right: 0,
              child: TextButton(
                onPressed: () {
                  _liveRoomController.fsSC.value = SuperChatItem.fromJson({
                    "id": Utils.random.nextInt(2147483647),
                    "price": 66,
                    "end_time":
                        DateTime.now().millisecondsSinceEpoch ~/ 1000 + 5,
                    "message": Utils.generateRandomString(55),
                    "user_info": {
                      "face": "",
                      "uname": Utils.generateRandomString(8),
                    },
                  });
                },
                child: const Text('add superchat'),
              ),
            ),
            Positioned(
              right: 0,
              top: 90,
              child: TextButton(
                onPressed: () {
                  _liveRoomController.fsSC.value = null;
                },
                child: const Text('remove superchat'),
              ),
            ),
          ],
          Positioned(
            left: padding.left + 25,
            bottom: 25,
            child: Obx(() {
              final item = _liveRoomController.fsSC.value;
              if (item == null) {
                return const SizedBox.shrink();
              }
              try {
                return SizedBox(
                  key: ValueKey(item.id),
                  width: 255,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6, top: 6),
                        child: SuperChatCard(
                          item: item,
                          onRemove: () => _liveRoomController.fsSC.value = null,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: iconButton(
                          size: 24,
                          iconSize: 14,
                          context: context,
                          bgColor: const Color(0xEEFFFFFF),
                          iconColor: Colors.black54,
                          icon: Icons.clear,
                          onPressed: () =>
                              _liveRoomController.fsSC.value = null,
                        ),
                      ),
                    ],
                  ),
                );
              } catch (_) {
                if (kDebugMode) rethrow;
                return const SizedBox.shrink();
              }
            }),
          ),
        ],
      );
    }
    return PopScope(
      canPop: !isFullScreen,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (isFullScreen) {
          plPlayerController.triggerFullScreen(status: false);
        }
      },
      child: player,
    );
  }

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(
    Brightness brightness, [
    Color? backgroundColor,
  ]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    // For backward compatibility, create an overlay style without system navigation bar settings.
    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }

  Widget get childWhenDisabled {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemOverlayStyleForBrightness(
        Brightness.dark,
        Theme.of(context).useMaterial3 ? const Color(0x00000000) : null,
      ),
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(
              () {
                if (isFullScreen) {
                  return const SizedBox.shrink();
                }
                final appBackground = _liveRoomController
                    .roomInfoH5
                    .value
                    ?.roomInfo
                    ?.appBackground;
                Widget child;
                if (appBackground?.isNotEmpty == true) {
                  child = CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: maxWidth,
                    height: maxHeight,
                    imageUrl: appBackground!.http2https,
                  );
                } else {
                  child = Image.asset(
                    'assets/images/live/default_bg.webp',
                    fit: BoxFit.cover,
                  );
                }
                return Positioned.fill(
                  child: Opacity(opacity: 0.6, child: child),
                );
              },
            ),
            if (isPortrait)
              Obx(
                () {
                  if (_liveRoomController.isPortrait.value) {
                    return _buildPP;
                  }
                  return _buildPH;
                },
              )
            else
              _buildBodyH,
          ],
        ),
      ),
    );
  }

  Widget get _buildPH {
    final isFullScreen = this.isFullScreen;
    final height = maxWidth * 9 / 16;
    final videoHeight = isFullScreen ? maxHeight : height;
    final bottomHeight = maxHeight - padding.top - height - kToolbarHeight;
    return Column(
      children: [
        Offstage(
          offstage: isFullScreen,
          child: _buildAppBar,
        ),
        SizedBox(
          width: maxWidth,
          height: videoHeight,
          child: videoPlayerPanel(
            isFullScreen,
            width: maxWidth,
            height: videoHeight,
          ),
        ),
        Offstage(
          offstage: isFullScreen,
          child: SizedBox(
            width: maxWidth,
            height: max(0, bottomHeight),
            child: _buildBottomWidget,
          ),
        ),
      ],
    );
  }

  Widget get _buildPP {
    final isFullScreen = this.isFullScreen;
    final bottomHeight = 70 + padding.bottom;
    final topPadding = padding.top + kToolbarHeight;
    final videoHeight = maxHeight - bottomHeight - topPadding;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: isFullScreen ? 0 : topPadding,
          bottom: isFullScreen ? 0 : bottomHeight,
          child: videoPlayerPanel(
            width: maxWidth,
            height: videoHeight,
            isFullScreen,
            needDm: isFullScreen,
            alignment: isFullScreen ? null : Alignment.topCenter,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Offstage(
            offstage: isFullScreen,
            child: _buildAppBar,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 55 + bottomHeight,
          child: Offstage(
            offstage: isFullScreen,
            child: SizedBox(
              height: maxHeight * 0.32,
              child: _buildChatWidget(true),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Offstage(
            offstage: isFullScreen,
            child: SizedBox(
              height: bottomHeight,
              child: _buildInputWidget,
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget get _buildAppBar {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(color: Colors.white),
      title: Obx(
        () {
          RoomInfoH5Data? roomInfoH5 = _liveRoomController.roomInfoH5.value;
          if (roomInfoH5 == null) {
            return const SizedBox.shrink();
          }
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.toNamed('/member?mid=${roomInfoH5.roomInfo?.uid}'),
            child: Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                NetworkImgLayer(
                  width: 34,
                  height: 34,
                  type: ImageType.avatar,
                  src: roomInfoH5.anchorInfo!.baseInfo!.face,
                ),
                Column(
                  spacing: 1,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomInfoH5.anchorInfo!.baseInfo!.uname!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Obx(() {
                      final liveTime = _liveRoomController.liveTime.value;
                      final textLarge = roomInfoH5.watchedShow?.textLarge;
                      String text = '';
                      if (textLarge != null) {
                        text += textLarge;
                      }
                      if (liveTime != null) {
                        if (text.isNotEmpty) {
                          text += '  ';
                        }
                        final duration = DurationUtils.formatDurationBetween(
                          liveTime * 1000,
                          DateTime.now().millisecondsSinceEpoch,
                        );
                        text += duration.isEmpty ? '刚刚开播' : '开播$duration';
                      }
                      if (text.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Text(text, style: const TextStyle(fontSize: 12));
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        // IconButton(
        //   tooltip: '刷新',
        //   onPressed: _liveRoomController.queryLiveUrl,
        //   icon: const Icon(Icons.refresh, size: 20),
        // ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, size: 20),
          itemBuilder: (BuildContext context) {
            final liveUrl =
                'https://live.bilibili.com/${_liveRoomController.roomId}';
            return <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () => Utils.copyText(liveUrl),
                child: Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.copy,
                      size: 19,
                      color: color,
                    ),
                    const Text('复制链接'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => Utils.shareText(liveUrl),
                child: Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.share,
                      size: 19,
                      color: color,
                    ),
                    const Text('分享直播间'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => PageUtils.inAppWebview(liveUrl, off: true),
                child: Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.open_in_browser,
                      size: 19,
                      color: color,
                    ),
                    const Text('浏览器打开'),
                  ],
                ),
              ),
              if (_liveRoomController.roomInfoH5.value != null)
                PopupMenuItem(
                  onTap: () {
                    try {
                      RoomInfoH5Data roomInfo =
                          _liveRoomController.roomInfoH5.value!;
                      PageUtils.pmShare(
                        this.context,
                        content: {
                          "cover": roomInfo.roomInfo!.cover!,
                          "sourceID": _liveRoomController.roomId.toString(),
                          "title": roomInfo.roomInfo!.title!,
                          "url": liveUrl,
                          "authorID": roomInfo.roomInfo!.uid.toString(),
                          "source": "直播",
                          "desc": roomInfo.roomInfo!.title!,
                          "author": roomInfo.anchorInfo!.baseInfo!.uname,
                        },
                      );
                    } catch (e) {
                      SmartDialog.showToast(e.toString());
                    }
                  },
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.forward_to_inbox,
                        size: 19,
                        color: color,
                      ),
                      const Text('分享至消息'),
                    ],
                  ),
                ),
            ];
          },
        ),
      ],
    );
  }

  Widget get _buildBodyH {
    double videoWidth =
        clampDouble(maxHeight / maxWidth * 1.08, 0.56, 0.7) * maxWidth;
    final rigthWidth = min(400.0, maxWidth - videoWidth - padding.horizontal);
    videoWidth = maxWidth - rigthWidth;
    final videoHeight = maxHeight - padding.top;
    return Obx(
      () {
        final isFullScreen = this.isFullScreen;
        final width = isFullScreen ? maxWidth : videoWidth;
        final height = isFullScreen ? maxHeight : videoHeight;
        return Column(
          children: [
            Offstage(
              offstage: isFullScreen,
              child: _buildAppBar,
            ),
            Expanded(
              child: Padding(
                padding: isFullScreen
                    ? EdgeInsets.zero
                    : EdgeInsets.only(left: padding.left, right: padding.right),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: padding.bottom),
                      width: width,
                      height: height,
                      child: videoPlayerPanel(
                        isFullScreen,
                        fill: Colors.transparent,
                        width: width,
                        height: height,
                      ),
                    ),
                    Offstage(
                      offstage: isFullScreen,
                      child: SizedBox(
                        width: rigthWidth,
                        height: videoHeight,
                        child: _buildBottomWidget,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get _buildBottomWidget => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: _buildChatWidget()),
      _buildInputWidget,
    ],
  );

  Widget _buildChatWidget([bool isPP = false]) {
    Widget chat() => LiveRoomChatPanel(
      key: chatKey,
      isPP: isPP,
      roomId: _liveRoomController.roomId,
      liveRoomController: _liveRoomController,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 12, top: isPortrait ? 12 : 0),
      child: _liveRoomController.showSuperChat
          ? PageView(
              key: pageKey,
              controller: _liveRoomController.pageController,
              physics: const CustomTabBarViewClampingScrollPhysics(),
              onPageChanged: (value) =>
                  _liveRoomController.pageIndex.value = value,
              children: [
                KeepAliveWrapper(builder: (context) => chat()),
                SuperChatPanel(
                  key: scKey,
                  controller: _liveRoomController,
                ),
              ],
            )
          : chat(),
    );
  }

  Widget get _buildInputWidget {
    final child = Container(
      padding: EdgeInsets.only(
        top: 5,
        left: 10,
        right: 10,
        bottom: padding.bottom,
      ),
      height: 70 + padding.bottom,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
        color: Color(0x1AFFFFFF),
      ),
      child: GestureDetector(
        onTap: _liveRoomController.onSendDanmaku,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              spacing: 6,
              children: [
                Obx(
                  () {
                    final enableShowLiveDanmaku =
                        plPlayerController.enableShowLiveDanmaku.value;
                    return SizedBox(
                      width: 34,
                      height: 34,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          final newVal = !enableShowLiveDanmaku;
                          plPlayerController.enableShowLiveDanmaku.value =
                              newVal;
                          if (!plPlayerController.tempPlayerConf) {
                            GStorage.setting.put(
                              SettingBoxKey.enableShowLiveDanmaku,
                              newVal,
                            );
                          }
                        },
                        icon: enableShowLiveDanmaku
                            ? const Icon(
                                size: 22,
                                CustomIcons.dm_on,
                                color: Color(0xFFEEEEEE),
                              )
                            : const Icon(
                                size: 22,
                                CustomIcons.dm_off,
                                color: Color(0xFFEEEEEE),
                              ),
                      ),
                    );
                  },
                ),
                const Expanded(
                  child: Text(
                    '发送弹幕',
                    style: TextStyle(color: Color(0xFFEEEEEE)),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            overlayColor: overlayColor(colorScheme),
                            customBorder: const CircleBorder(),
                            onTapDown: _liveRoomController.onLikeTapDown,
                            onTapUp: _liveRoomController.onLikeTapUp,
                            onTapCancel: _liveRoomController.onLikeTapUp,
                            child: const SizedBox.square(
                              dimension: 34,
                              child: Icon(
                                size: 22,
                                color: Color(0xFFEEEEEE),
                                Icons.thumb_up_off_alt,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -12,
                            top: -12,
                            child: Obx(() {
                              final likeClickTime =
                                  _liveRoomController.likeClickTime.value;
                              if (likeClickTime == 0) {
                                return const SizedBox.shrink();
                              }
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 160),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  key: ValueKey(likeClickTime),
                                  'x$likeClickTime',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.isDark
                                        ? colorScheme.primary
                                        : colorScheme.inversePrimary,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 34,
                  height: 34,
                  child: IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => _liveRoomController.onSendDanmaku(true),
                    icon: const Icon(
                      size: 22,
                      color: Color(0xFFEEEEEE),
                      Icons.emoji_emotions_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (_liveRoomController.showSuperChat) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Obx(() {
              return ClipRect(
                clipper: _BorderClipper(
                  _liveRoomController.pageIndex.value == 0,
                ),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.white38),
                    ),
                  ),
                  child: SizedBox(width: double.infinity, height: 20),
                ),
              );
            }),
          ),
          child,
        ],
      );
    }
    return child;
  }

  WidgetStateProperty<Color?>? overlayColor(ColorScheme theme) =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          if (states.contains(WidgetState.pressed)) {
            return theme.primary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return theme.primary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return theme.primary.withValues(alpha: 0.1);
          }
        }
        if (states.contains(WidgetState.pressed)) {
          return theme.onSurfaceVariant.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return theme.onSurfaceVariant.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return theme.onSurfaceVariant.withValues(alpha: 0.1);
        }
        return Colors.transparent;
      });
}

class _BorderClipper extends CustomClipper<Rect> {
  _BorderClipper(this.isLeft);

  final bool isLeft;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      isLeft ? 0 : size.width / 2,
      0,
      size.width / 2,
      size.height,
    );
  }

  @override
  bool shouldReclip(_BorderClipper oldClipper) {
    return isLeft != oldClipper.isLeft;
  }
}

class LiveDanmaku extends StatefulWidget {
  final LiveRoomController liveRoomController;
  final PlPlayerController plPlayerController;
  final bool isPipMode;
  final bool isFullScreen;

  const LiveDanmaku({
    super.key,
    required this.liveRoomController,
    required this.plPlayerController,
    this.isPipMode = false,
    required this.isFullScreen,
  });

  @override
  State<LiveDanmaku> createState() => _LiveDanmakuState();
}

class _LiveDanmakuState extends State<LiveDanmaku> {
  PlPlayerController get plPlayerController => widget.plPlayerController;

  @override
  void didUpdateWidget(LiveDanmaku oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPipMode != widget.isPipMode ||
        oldWidget.isFullScreen != widget.isFullScreen) {
      _updateFontSize();
    }
  }

  void _updateFontSize() {
    plPlayerController.danmakuController?.updateOption(
      plPlayerController.danmakuController!.option.copyWith(
        fontSize: _fontSize,
      ),
    );
  }

  double get _fontSize => !widget.isFullScreen || widget.isPipMode
      ? 15 * plPlayerController.danmakuFontScale
      : 15 * plPlayerController.danmakuFontScaleFS;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return AnimatedOpacity(
          opacity: plPlayerController.enableShowLiveDanmaku.value
              ? plPlayerController.danmakuOpacity.value
              : 0,
          duration: const Duration(milliseconds: 100),
          child: DanmakuScreen(
            createdController: (DanmakuController e) {
              widget.liveRoomController.danmakuController =
                  plPlayerController.danmakuController = e;
            },
            option: DanmakuOption(
              fontSize: _fontSize,
              fontWeight: plPlayerController.danmakuFontWeight,
              area: plPlayerController.showArea,
              hideTop: plPlayerController.blockTypes.contains(5),
              hideScroll: plPlayerController.blockTypes.contains(2),
              hideBottom: plPlayerController.blockTypes.contains(4),
              duration:
                  plPlayerController.danmakuDuration /
                  plPlayerController.playbackSpeed,
              staticDuration:
                  plPlayerController.danmakuStaticDuration /
                  plPlayerController.playbackSpeed,
              strokeWidth: plPlayerController.danmakuStrokeWidth,
              lineHeight: plPlayerController.danmakuLineHeight,
            ),
          ),
        );
      },
    );
  }
}
