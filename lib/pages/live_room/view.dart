import 'dart:io';
import 'dart:ui';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/send_danmaku/view.dart';
import 'package:PiliPlus/pages/live_room/widgets/bottom_control.dart';
import 'package:PiliPlus/pages/live_room/widgets/chat.dart';
import 'package:PiliPlus/pages/live_room/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/view.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/duration_util.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:screen_brightness/screen_brightness.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with WidgetsBindingObserver {
  final String heroTag = Utils.generateRandomString(6);
  late final LiveRoomController _liveRoomController;
  late final PlPlayerController plPlayerController;
  bool get isFullScreen => plPlayerController.isFullScreen.value;

  final GlobalKey chatKey = GlobalKey();
  final GlobalKey playerKey = GlobalKey();

  final Color _color = const Color(0xFFEEEEEE);

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

  void playerListener(PlayerStatus? status) {
    if (status != PlayerStatus.playing) {
      plPlayerController.danmakuController?.pause();
      _liveRoomController
        ..cancelLiveTimer()
        ..msgStream?.close()
        ..msgStream = null;
    } else {
      plPlayerController.danmakuController?.resume();
      _liveRoomController
        ..startLiveTimer()
        ..liveMsg();
    }
  }

  @override
  void dispose() {
    videoPlayerServiceHandler.onVideoDetailDispose(heroTag);
    WidgetsBinding.instance.removeObserver(this);
    ScreenBrightness.instance.resetApplicationScreenBrightness();
    PlPlayerController.setPlayCallBack(null);
    plPlayerController
      ..removeStatusLister(playerListener)
      ..dispose();
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
              landScape();
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

  @override
  Widget build(BuildContext context) {
    final isPortrait = context.isPortrait;
    if (Platform.isAndroid) {
      return Floating().isPipMode
          ? videoPlayerPanel(isFullScreen, isPipMode: true)
          : childWhenDisabled(isPortrait);
    } else {
      return childWhenDisabled(isPortrait);
    }
  }

  Widget videoPlayerPanel(
    bool isFullScreen, {
    bool isPipMode = false,
    Color? fill,
    Alignment? alignment,
    bool needDm = true,
  }) {
    return PopScope(
      canPop: !isFullScreen,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (isFullScreen) {
          plPlayerController.triggerFullScreen(status: false);
        }
      },
      child: Obx(() {
        if (_liveRoomController.isLoaded.value) {
          final roomInfoH5 = _liveRoomController.roomInfoH5.value;
          return PLVideoPlayer(
            key: playerKey,
            fill: fill,
            alignment: alignment,
            plPlayerController: plPlayerController,
            headerControl: LiveHeaderControl(
              title: roomInfoH5?.roomInfo?.title,
              upName: roomInfoH5?.anchorInfo?.baseInfo?.uname,
              plPlayerController: plPlayerController,
              onSendDanmaku: onSendDanmaku,
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
                    plPlayerController: plPlayerController,
                    isFullScreen: isFullScreen,
                    isPipMode: isPipMode,
                  ),
          );
        }
        return const SizedBox.shrink();
      }),
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

  Widget childWhenDisabled(bool isPortrait) {
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
                  final size = Get.size;
                  child = CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: size.width,
                    height: size.height,
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
            SafeArea(
              top: !isFullScreen,
              left: !isFullScreen,
              right: !isFullScreen,
              bottom: false,
              child: isPortrait
                  ? Obx(
                      () {
                        if (_liveRoomController.isPortrait.value) {
                          return _buildPP;
                        }
                        return _buildPH;
                      },
                    )
                  : _buildBodyH,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildPH {
    final isFullScreen = this.isFullScreen;
    final size = Get.size;
    return Column(
      children: [
        if (!isFullScreen) _buildAppBar,
        SizedBox(
          width: size.width,
          height: isFullScreen ? size.height : size.width * 9 / 16,
          child: videoPlayerPanel(isFullScreen),
        ),
        ..._buildBottomWidget,
      ],
    );
  }

  Widget get _buildPP {
    final isFullScreen = this.isFullScreen;
    Widget child = Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: videoPlayerPanel(
            isFullScreen,
            alignment: isFullScreen ? null : Alignment.topCenter,
            needDm: isFullScreen,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 55,
          child: Visibility(
            maintainState: true,
            visible: !isFullScreen,
            child: SizedBox(
              height: Get.height * 0.32,
              child: _buildChatWidget(true),
            ),
          ),
        ),
      ],
    );
    if (isFullScreen) {
      return child;
    }
    return Column(
      children: [
        _buildAppBar,
        Expanded(child: child),
        _buildInputWidget,
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
                        final duration = DurationUtil.formatDurationBetween(
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
        clampDouble(context.height / context.width * 1.08, 0.58, 0.75) *
        context.width;
    return Obx(
      () {
        final isFullScreen = this.isFullScreen;
        final size = Get.size;
        Widget child = Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              width: isFullScreen ? size.width : videoWidth,
              height: isFullScreen ? size.height : size.width * 9 / 16,
              child: videoPlayerPanel(
                isFullScreen,
                fill: Colors.transparent,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildBottomWidget,
              ),
            ),
          ],
        );
        if (isFullScreen) {
          return child;
        }
        return Column(
          children: [
            _buildAppBar,
            Expanded(child: child),
          ],
        );
      },
    );
  }

  List<Widget> get _buildBottomWidget => [
    Expanded(child: _buildChatWidget()),
    _buildInputWidget,
  ];

  Widget _buildChatWidget([bool? isPP]) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: LiveRoomChat(
      key: chatKey,
      isPP: isPP ?? false,
      roomId: _liveRoomController.roomId,
      liveRoomController: _liveRoomController,
    ),
  );

  Widget get _buildInputWidget => Container(
    padding: EdgeInsets.only(
      top: 5,
      left: 10,
      right: 10,
      bottom: 15 + MediaQuery.paddingOf(context).bottom,
    ),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      border: Border(
        top: BorderSide(color: Color(0x1AFFFFFF)),
      ),
      color: Color(0x1AFFFFFF),
    ),
    child: GestureDetector(
      onTap: onSendDanmaku,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 10),
        child: Row(
          children: [
            Obx(
              () {
                final enableShowDanmaku =
                    plPlayerController.enableShowDanmaku.value;
                return IconButton(
                  onPressed: () {
                    final newVal = !enableShowDanmaku;
                    plPlayerController.enableShowDanmaku.value = newVal;
                    if (!Pref.tempPlayerConf) {
                      GStorage.setting.put(
                        SettingBoxKey.enableShowDanmaku,
                        newVal,
                      );
                    }
                  },
                  icon: Icon(
                    enableShowDanmaku
                        ? Icons.subtitles_outlined
                        : Icons.subtitles_off_outlined,
                    color: _color,
                  ),
                );
              },
            ),
            Expanded(
              child: Text(
                '发送弹幕',
                style: TextStyle(color: _color),
              ),
            ),
            Builder(
              builder: (context) {
                final theme = Theme.of(context).colorScheme;
                return Material(
                  type: MaterialType.transparency,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        overlayColor: overlayColor(theme),
                        customBorder: const CircleBorder(),
                        onTapDown: _liveRoomController.onLikeTapDown,
                        onTapUp: _liveRoomController.onLikeTapUp,
                        onTapCancel: _liveRoomController.onLikeTapUp,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.thumb_up_off_alt, color: _color),
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
                                color: theme.brightness.isDark
                                    ? theme.primary
                                    : theme.inversePrimary,
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
            IconButton(
              onPressed: () => onSendDanmaku(true),
              icon: Icon(Icons.emoji_emotions_outlined, color: _color),
            ),
          ],
        ),
      ),
    ),
  );

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

  void onSendDanmaku([bool fromEmote = false]) {
    if (!_liveRoomController.isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.generalDialog(
      barrierLabel: '',
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return LiveSendDmPanel(
          fromEmote: fromEmote,
          liveRoomController: _liveRoomController,
          items: _liveRoomController.savedDanmaku,
          onSave: (msg) {
            if (msg.isEmpty) {
              _liveRoomController
                ..savedDanmaku?.clear()
                ..savedDanmaku = null;
            } else {
              _liveRoomController.savedDanmaku = msg.toList();
            }
          },
        );
      },
      transitionDuration: fromEmote
          ? const Duration(milliseconds: 400)
          : const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.linear));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class LiveDanmaku extends StatefulWidget {
  final PlPlayerController plPlayerController;
  final bool isPipMode;
  final bool isFullScreen;

  const LiveDanmaku({
    super.key,
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
          opacity: plPlayerController.enableShowDanmaku.value ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          child: DanmakuScreen(
            createdController: (DanmakuController e) {
              plPlayerController.danmakuController = e;
            },
            option: DanmakuOption(
              fontSize: _fontSize,
              fontWeight: plPlayerController.fontWeight,
              area: plPlayerController.showArea,
              opacity: plPlayerController.danmakuOpacity,
              hideTop: plPlayerController.blockTypes.contains(5),
              hideScroll: plPlayerController.blockTypes.contains(2),
              hideBottom: plPlayerController.blockTypes.contains(4),
              duration:
                  plPlayerController.danmakuDuration /
                  plPlayerController.playbackSpeed,
              staticDuration:
                  plPlayerController.danmakuStaticDuration /
                  plPlayerController.playbackSpeed,
              strokeWidth: plPlayerController.strokeWidth,
              lineHeight: plPlayerController.danmakuLineHeight,
            ),
          ),
        );
      },
    );
  }
}
