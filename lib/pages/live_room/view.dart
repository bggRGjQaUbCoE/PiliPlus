import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/extra_hittest_stack.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show tabBarScrollPhysics;
import 'package:PiliPlus/models/common/live/live_contribution_rank_type.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/live_room/contribution_rank/controller.dart';
import 'package:PiliPlus/pages/live_room/contribution_rank/view.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/live_room/send_danmaku/view.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_card.dart';
import 'package:PiliPlus/pages/live_room/superchat/superchat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/bottom_control.dart';
import 'package:PiliPlus/pages/live_room/widgets/chat_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/enhancement_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/interaction_panel.dart';
import 'package:PiliPlus/pages/live_room/widgets/interaction_focus_boundary.dart';
import 'package:PiliPlus/pages/live_room/widgets/header_control.dart';
import 'package:PiliPlus/pages/video/widgets/player_focus.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/plugin/pl_player/view/view.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/services/live_interaction_service.dart';
import 'package:PiliPlus/services/in_app_mini_player.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/live_viewer_preferences.dart';
import 'package:PiliPlus/utils/max_screen_size.dart';
import 'package:PiliPlus/utils/mobile_observer.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:canvas_danmaku/danmaku_screen.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';

const baseWhite = Color(0xFFEEEEEE);
const _liveGiftBarHeight = 96.0;

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with WidgetsBindingObserver, RouteAware, RouteAwareMixin {
  late final fullScreenSCWidth = Pref.fullScreenSCWidth;
  final String heroTag = Utils.generateRandomString(6);
  late final LiveRoomController _liveRoomController;
  late final PlPlayerController plPlayerController;
  bool get isFullScreen => plPlayerController.isFullScreen.value;

  late final GlobalKey pageKey = GlobalKey();
  late final GlobalKey chatKey = GlobalKey();
  late final GlobalKey scKey = GlobalKey();
  late final GlobalKey playerKey = GlobalKey();
  late bool _enhancementEnabled = Pref.liveRoomEnhancement;
  bool _inlineEmojiVisible = false;
  StreamSubscription<dynamic>? _enhancementSettings;
  ModalRoute<dynamic>? _enhancementSheetRoute;
  ModalRoute<dynamic>? _enhancementChatRoute;
  LiveInteractionSession? _interactionSession;
  bool _openingOfficialWeb = false;
  final _enhancementPanelKey = GlobalKey<LiveEnhancementPanelState>();
  final _inlineDmKey = GlobalKey<LiveSendDmPanelState>();
  bool get _interactionUIVisible => _enhancementSheetRoute?.isActive == true;
  String get _miniOwnerKey => 'live:${_liveRoomController.requestedRoomId}';

  bool _showMiniPlayer({bool isPop = false}) => InAppMiniPlayer.instance.show(
    ownerKey: _miniOwnerKey,
    routeName: '/liveRoom',
    routeArguments: _liveRoomController.requestedRoomId,
    ownerRoute: ModalRoute.of(context),
    controller: plPlayerController,
    title: _liveRoomController.roomInfoH5.value?.roomInfo?.title,
    isPop: isPop,
  );

  @override
  void initState() {
    super.initState();
    addObserverMobile(this);
    _liveRoomController = Get.put(
      LiveRoomController(heroTag),
      tag: heroTag,
    );
    plPlayerController = _liveRoomController.plPlayerController
      ..addStatusLister(playerListener);
    PlPlayerController.setPlayCallBack(plPlayerController.play);
    _enhancementSettings = GStorage.setting
        .watch(key: SettingBoxKey.liveRoomEnhancement)
        .listen((_) {
          final enabled = Pref.liveRoomEnhancement;
          if (!mounted || enabled == _enhancementEnabled) return;
          setState(() {
            _enhancementEnabled = enabled;
            if (!enabled) _inlineEmojiVisible = false;
          });
          if (!enabled) _interactionSession?.hide();
          if (!enabled) {
            final route = _enhancementSheetRoute;
            _enhancementSheetRoute = null;
            if (route != null && route.isActive) {
              route.navigator?.removeRoute(route);
            }
            final chatRoute = _enhancementChatRoute;
            _enhancementChatRoute = null;
            if (chatRoute != null && chatRoute.isActive) {
              chatRoute.navigator?.removeRoute(chatRoute);
            }
          }
        });
    if (plPlayerController.removeSafeArea) {
      hideSystemBar();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (plPlayerController.removeSafeArea) {
      padding = .zero;
    } else {
      padding = MediaQuery.viewPaddingOf(context);
    }
    final size = MediaQuery.sizeOf(context);
    maxWidth = size.width;
    maxHeight = size.height;
    isWindowMode = MaxScreenSize.isWindowMode(
      width: maxWidth * plPlayerController.uiScale,
      height: maxHeight * plPlayerController.uiScale,
    );
    isPortrait = size.isPortrait;
    plPlayerController.screenRatio = maxHeight / maxWidth;
  }

  @override
  Future<void> didPopNext() async {
    final miniClosed = InAppMiniPlayer.instance.wasClosedForOwner(
      _miniOwnerKey,
    );
    if (miniClosed) _liveRoomController.isPlaying = false;
    final restoredMini =
        InAppMiniPlayer.instance.consumeExistingRestore(_miniOwnerKey) ||
        InAppMiniPlayer.instance.adoptByPage(
          ownerKey: _miniOwnerKey,
          routeName: '/liveRoom',
        );
    addObserverMobile(this);
    if (!plPlayerController.isLive) {
      plPlayerController.isLive = true;
      _liveRoomController.isLoaded.refresh();
    }
    plPlayerController.danmakuController =
        _liveRoomController.danmakuController;
    PlPlayerController.setPlayCallBack(
      miniClosed ? null : plPlayerController.play,
    );
    if (!miniClosed) _liveRoomController.startLiveTimer();
    if (!miniClosed &&
        plPlayerController.playerStatus.isPlaying &&
        plPlayerController.cid == null) {
      _liveRoomController
        ..danmakuController?.resume()
        ..startLiveMsg();
    } else {
      final shouldPlay =
          !miniClosed && (_liveRoomController.isPlaying ?? false);
      if (shouldPlay) {
        _liveRoomController
          ..danmakuController?.resume()
          ..startLiveMsg();
      }
      if (!miniClosed &&
          !restoredMini &&
          !_liveRoomController.adoptedMiniPlayer &&
          !_openingOfficialWeb) {
        await _liveRoomController.playerInit(autoplay: shouldPlay);
      }
    }
    if (!mounted) return;
    plPlayerController.addStatusLister(playerListener);
    if (_interactionUIVisible) _interactionSession?.load();
    super.didPopNext();
  }

  @override
  void didPushNext() {
    final wasPlaying = plPlayerController.playerStatus.isPlaying;
    final miniShown = _showMiniPlayer();
    // When the optional mini-player cannot take ownership, do not leave live
    // audio playing behind another media route. Preserve the original choice
    // for didPopNext before the asynchronous pause changes playerStatus.
    if (Pref.inAppMiniPlayer && !miniShown && wasPlaying) {
      unawaited(plPlayerController.pause());
    }
    _interactionSession?.hide();
    removeObserverMobile(this);
    plPlayerController.removeStatusLister(playerListener);
    _liveRoomController
      ..danmakuController?.clear()
      ..cancelLiveTimer()
      ..closeLiveMsg()
      ..isPlaying = wasPlaying;
    super.didPushNext();
  }

  void playerListener(PlayerStatus status) {
    if (status.isPlaying) {
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
    _enhancementSettings?.cancel();
    _interactionSession?.dispose();
    removeObserverMobile(this);
    videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
    if (Platform.isAndroid && !plPlayerController.setSystemBrightness) {
      ScreenBrightnessPlatform.instance.resetApplicationScreenBrightness();
    }
    PlPlayerController.setPlayCallBack(null);
    plPlayerController
      ..removeStatusLister(playerListener)
      ..dispose();
    for (final e in LiveContributionRankType.values) {
      Get.delete<ContributionRankController>(
        tag: '${_liveRoomController.roomId}${e.name}',
      );
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (plPlayerController.visible = state == .resumed) {
      if (_interactionUIVisible) _interactionSession?.load();
      if (!plPlayerController.showDanmaku) {
        _liveRoomController
          ..refreshMsgIfNeeded()
          ..startLiveTimer();
        plPlayerController.showDanmaku = true;
      }
    } else if (state == .paused) {
      _interactionSession?.hide();
      _liveRoomController.cancelLiveTimer();
      plPlayerController
        ..showDanmaku = false
        ..danmakuController?.clear();
    }
  }

  late double maxWidth;
  late double maxHeight;
  bool isWindowMode = false;
  late EdgeInsets padding;
  late bool isPortrait;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (Platform.isAndroid && AndroidHelper.isPipMode) {
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
        onSendDanmaku: _onSendDanmaku,
        onRefresh: _liveRoomController.queryLiveUrl,
        child: child,
      );
    }
    return Theme(
      data: ThemeUtils.darkTheme,
      child: child,
    );
  }

  Widget videoPlayerPanel(
    bool isFullScreen, {
    required double width,
    required double height,
    bool isPipMode = false,
    Color fill = Colors.black,
    Alignment alignment = Alignment.center,
    bool needDm = true,
  }) {
    if (!isFullScreen && !plPlayerController.isDesktopPip) {
      _liveRoomController.fsSC.value = null;
    }
    _liveRoomController.isFullScreen = isFullScreen;
    Widget player = Obx(
      key: playerKey,
      () {
        if (_liveRoomController.isLoaded.value && plPlayerController.isLive) {
          final roomInfoH5 = _liveRoomController.roomInfoH5.value;
          return PLVideoPlayer(
            maxWidth: width,
            maxHeight: height,
            fill: fill,
            alignment: alignment,
            plPlayerController: plPlayerController,
            headerControl: LiveHeaderControl(
              key: _liveRoomController.headerKey,
              title: roomInfoH5?.roomInfo?.title,
              upName: roomInfoH5?.anchorInfo?.baseInfo?.uname,
              plPlayerController: plPlayerController,
              onSendDanmaku: _onSendDanmaku,
              onPlayAudio: _liveRoomController.queryLiveUrl,
              isPortrait: isPortrait,
              liveController: _liveRoomController,
              onlineWidget: onlineWidget,
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
                    isPipMode: plPlayerController.isDesktopPip || isPipMode,
                    size: Size(width, height),
                  ),
          );
        }
        return const SizedBox.shrink();
      },
    );
    final mountedPlayer = player;
    player = ValueListenableBuilder<MiniPlayback?>(
      valueListenable: InAppMiniPlayer.instance.current,
      builder: (context, session, _) => session?.ownerKey == _miniOwnerKey
          ? const SizedBox.shrink()
          : mountedPlayer,
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
                  final item = SuperChatItem.random;
                  _liveRoomController
                    ..fsSC.value = item
                    ..addDm(item);
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
            width: fullScreenSCWidth,
            child: Obx(() {
              final item = _liveRoomController.fsSC.value;
              if (item == null) {
                return const SizedBox.shrink();
              }
              try {
                return ExtraHitTestStack(
                  key: ValueKey(item.id),
                  clipBehavior: Clip.none,
                  children: [
                    SuperChatCard(
                      item: item,
                      onRemove: () => _liveRoomController.fsSC.value = null,
                      onReport: () => _liveRoomController.reportSC(item),
                    ),
                    Positioned(
                      right: -6,
                      top: -6,
                      child: iconButton(
                        size: 24,
                        iconSize: 14,
                        bgColor: const Color(0xEEFFFFFF),
                        iconColor: Colors.black54,
                        icon: const Icon(Icons.clear),
                        onPressed: () => _liveRoomController.fsSC.value = null,
                      ),
                    ),
                  ],
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
    return popScope(
      canPop: !isFullScreen && !plPlayerController.isDesktopPip,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _showMiniPlayer(isPop: true)) return;
        plPlayerController.onPopInvokedWithResult(didPop, result);
      },
      child: player,
    );
  }

  Widget get childWhenDisabled {
    return Obx(() {
      final isFullScreen = this.isFullScreen || plPlayerController.isDesktopPip;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          const SizedBox.expand(child: ColoredBox(color: Colors.black)),
          if (!isFullScreen)
            Obx(
              () {
                final appBackground = _liveRoomController
                    .roomInfoH5
                    .value
                    ?.roomInfo
                    ?.appBackground;
                Widget child;
                if (appBackground != null && appBackground.isNotEmpty) {
                  child = CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: maxWidth,
                    height: maxHeight,
                    memCacheWidth: maxWidth.cacheSize(context),
                    imageUrl: ImageUtils.safeThumbnailUrl(appBackground),
                    placeholder: (_, _) => const SizedBox.shrink(),
                  );
                } else {
                  child = Image.asset(
                    Assets.livingBackground,
                    fit: BoxFit.cover,
                    width: maxWidth,
                    height: maxHeight,
                    cacheWidth: maxWidth.cacheSize(context),
                  );
                }
                return Positioned.fill(
                  child: Opacity(opacity: 0.6, child: child),
                );
              },
            ),
          ScaffoldLayout(
            appBar: isWindowMode && isFullScreen && !isPortrait
                ? null
                : _buildAppBar(isFullScreen),
            body: isPortrait
                ? Obx(
                    () {
                      if (_liveRoomController.isPortrait.value) {
                        return _buildPP(isFullScreen);
                      }
                      return _buildPH(isFullScreen);
                    },
                  )
                : _buildBodyH(isFullScreen),
          ),
        ],
      );
    });
  }

  Widget _buildPH(bool isFullScreen) {
    final height = maxWidth / Style.aspectRatio16x9;
    final showActions = _enhancementEnabled && !plPlayerController.isDesktopPip;
    final actionHeight = showActions ? _liveGiftBarHeight : 0.0;
    final videoHeight = isFullScreen
        ? maxHeight -
              (isWindowMode && !isPortrait ? 0 : padding.top) -
              actionHeight
        : _enhancementEnabled
        ? min(
            height,
            max(0.0, maxHeight - padding.top - kToolbarHeight - actionHeight),
          )
        : height;
    final bottomHeight =
        maxHeight - padding.top - videoHeight - kToolbarHeight - actionHeight;
    return Column(
      children: [
        SizedBox(
          width: maxWidth,
          height: videoHeight,
          child: videoPlayerPanel(
            isFullScreen,
            width: maxWidth,
            height: videoHeight,
          ),
        ),
        if (showActions) _buildLiveActionBar,
        if (!_enhancementEnabled)
          Offstage(
            offstage: isFullScreen,
            child: SizedBox(
              width: maxWidth,
              height: max(0.0, bottomHeight),
              child: _buildBottomWidget,
            ),
          )
        else if (!isFullScreen)
          SizedBox(
            width: maxWidth,
            height: max(0.0, bottomHeight),
            child: _buildBottomWidget,
          ),
      ],
    );
  }

  Widget _buildPP(bool isFullScreen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final enhanced =
            _enhancementEnabled && !plPlayerController.isDesktopPip;
        final available = constraints.maxHeight;
        final oldInputHeight = 70 + padding.bottom;
        final actionHeight = enhanced
            ? min(_liveGiftBarHeight, available)
            : 0.0;
        final emojiHeight = _inlineEmojiVisible
            ? min(180.0, MediaQuery.sizeOf(context).height * 0.25)
            : 0.0;
        final inputHeight = enhanced && !isFullScreen
            ? min(
                oldInputHeight + 32 + emojiHeight,
                max(0.0, available - actionHeight),
              )
            : 0.0;
        final chatHeight = enhanced && !isFullScreen
            ? min(
                min(240.0, max(80.0, available * 0.28)),
                max(0.0, available - actionHeight - inputHeight),
              )
            : 0.0;
        final bottomVideo = enhanced
            ? actionHeight + chatHeight + inputHeight
            : isFullScreen
            ? 0.0
            : oldInputHeight;
        final videoHeight = enhanced
            ? max(0.0, available - bottomVideo)
            : isFullScreen
            ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
            : maxHeight - oldInputHeight;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              bottom: bottomVideo,
              child: videoPlayerPanel(
                width: maxWidth,
                height: videoHeight,
                isFullScreen,
                needDm: isFullScreen,
                alignment: isFullScreen
                    ? Alignment.center
                    : Alignment.topCenter,
              ),
            ),
            if (enhanced) ...[
              Positioned(
                left: 0,
                right: 0,
                bottom: isFullScreen ? 0 : inputHeight + chatHeight,
                height: actionHeight,
                child: _buildLiveActionBar,
              ),
              if (!isFullScreen) ...[
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: inputHeight,
                  height: chatHeight,
                  child: _buildChatWidget(true),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: inputHeight,
                  child: _buildInlineInputWidget,
                ),
              ],
            ] else ...[
              Positioned(
                left: 0,
                right: 0,
                bottom: 55 + oldInputHeight,
                height: maxHeight * 0.32,
                child: Offstage(
                  offstage: isFullScreen,
                  child: _buildChatWidget(true),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: oldInputHeight,
                child: Offstage(
                  offstage: isFullScreen,
                  child: _buildInputWidget,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget get onlineWidget => GestureDetector(
    onTap: _showRank,
    child: Obx(() {
      if (_liveRoomController.onlineCount.value case final onlineCount?) {
        return Text(
          '高能观众($onlineCount)',
          style: const TextStyle(fontSize: 12, color: Colors.white),
        );
      }
      return const SizedBox.shrink();
    }),
  );

  void _showRank() {
    if (_liveRoomController.ruid case final ruid?) {
      final heightFactor = PlatformUtils.isMobile && !isPortrait ? 1.0 : 0.7;
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        clipBehavior: .hardEdge,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 450),
        builder: (context) => FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: heightFactor,
          child: ContributionRankPanel(
            ruid: ruid,
            roomId: _liveRoomController.roomId,
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(bool isFullScreen) {
    return AppBar(
      primary: !plPlayerController.removeSafeArea,
      toolbarHeight: isFullScreen ? 0 : null,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(color: Colors.white),
      title: isFullScreen || plPlayerController.isDesktopPip
          ? null
          : Obx(
              () {
                RoomInfoH5Data? roomInfoH5 =
                    _liveRoomController.roomInfoH5.value;
                if (roomInfoH5 == null) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      Get.toNamed('/member?mid=${roomInfoH5.roomInfo?.uid}'),
                  child: Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      NetworkImgLayer(
                        width: 34,
                        height: 34,
                        type: .avatar,
                        src: roomInfoH5.anchorInfo!.baseInfo!.face,
                      ),
                      Flexible(
                        child: Column(
                          spacing: 1,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 10,
                              mainAxisSize: .min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    roomInfoH5.anchorInfo!.baseInfo!.uname!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onlineWidget,
                              ],
                            ),
                            Row(
                              spacing: 10,
                              mainAxisSize: .min,
                              children: [
                                _liveRoomController.watchedWidget,
                                _liveRoomController.timeWidget,
                              ],
                            ),
                          ],
                        ),
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
              CheckedPopupMenuItem<bool>(
                checked: _enhancementEnabled,
                onTap: () => GStorage.setting.put(
                  SettingBoxKey.liveRoomEnhancement,
                  !_enhancementEnabled,
                ),
                child: const Text('直播界面增强（实验性）'),
              ),
              PopupMenuItem(
                onTap: () => Utils.copyText(liveUrl),
                child: const Row(
                  spacing: 10,
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.copy, size: 19),
                    Text('复制链接'),
                  ],
                ),
              ),
              if (PlatformUtils.isMobile)
                PopupMenuItem(
                  onTap: () => ShareUtils.shareText(liveUrl),
                  child: const Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.share, size: 19),
                      Text('分享直播间'),
                    ],
                  ),
                ),
              PopupMenuItem(
                onTap: () => PageUtils.inAppWebview(liveUrl, off: true),
                child: const Row(
                  spacing: 10,
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.open_in_browser, size: 19),
                    Text('浏览器打开'),
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
                  child: const Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.forward_to_inbox, size: 19),
                      Text('分享至消息'),
                    ],
                  ),
                ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildBodyH(bool isFullScreen) {
    double videoWidth =
        clampDouble(maxHeight / maxWidth * 1.08, 0.56, 0.7) * maxWidth;
    final rightWidth = min(400.0, maxWidth - videoWidth - padding.horizontal);
    videoWidth = maxWidth - rightWidth - padding.horizontal;
    final videoHeight = maxHeight - padding.top - kToolbarHeight;
    final width = isFullScreen ? maxWidth : videoWidth;
    final height = isFullScreen
        ? maxHeight - (isWindowMode && !isPortrait ? 0 : padding.top)
        : videoHeight;
    final showActions = _enhancementEnabled && !plPlayerController.isDesktopPip;
    final actionHeight = showActions ? _liveGiftBarHeight : 0.0;
    return Padding(
      padding: isFullScreen
          ? EdgeInsets.zero
          : EdgeInsets.only(left: padding.left, right: padding.right),
      child: Row(
        children: [
          Container(
            width: width,
            height: height,
            margin: EdgeInsets.only(bottom: padding.bottom),
            child: Column(
              children: [
                Expanded(
                  child: videoPlayerPanel(
                    isFullScreen,
                    fill: Colors.transparent,
                    width: width,
                    height: max(0, height - actionHeight),
                  ),
                ),
                if (showActions) _buildLiveActionBar,
              ],
            ),
          ),
          if (!_enhancementEnabled)
            Offstage(
              offstage: isFullScreen,
              child: SizedBox(
                width: rightWidth,
                height: videoHeight,
                child: _buildBottomWidget,
              ),
            )
          else if (!isFullScreen)
            SizedBox(
              width: rightWidth,
              height: videoHeight,
              child: _buildBottomWidget,
            ),
        ],
      ),
    );
  }

  Widget get _buildBottomWidget =>
      _enhancementEnabled &&
          useLiveEnhancementSidebar(
            width: maxWidth,
            isFullScreen: isFullScreen,
          )
      ? _buildEnhancementPanel
      : _buildOriginalBottomWidget;

  Widget get _buildOriginalBottomWidget => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: _buildChatWidget()),
      _enhancementEnabled ? _buildInlineInputWidget : _buildInputWidget,
    ],
  );

  Widget get _buildEnhancementPanel => LiveEnhancementPanel(
    key: _enhancementPanelKey,
    controller: _liveRoomController,
    inputBuilder: () => _buildInlineInputWidget,
    onMention: _onAtUser,
  );

  Widget get _buildLiveActionBar => Obx(() {
    final room = _liveRoomController.roomInfoH5.value;
    final anchorUid = room?.roomInfo?.uid ?? _liveRoomController.ruid;
    return LiveGiftActionBar(
      session: anchorUid == null || anchorUid <= 0
          ? null
          : _sessionFor(anchorUid),
      onFullMenu: () => _showEnhancement(0),
      onQuickGift: (gift, quantity) =>
          _showEnhancement(0, quickGift: gift, quickQuantity: quantity),
    );
  });

  LiveInteractionSession _sessionFor(int anchorUid) {
    final existing = _interactionSession;
    if (existing != null &&
        existing.service.anchorUid == anchorUid &&
        existing.service.roomId == _liveRoomController.roomId) {
      return existing;
    }
    existing?.hide(notify: false);
    if (existing != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => existing.dispose());
    }
    return _interactionSession = LiveInteractionSession(
      service: LiveInteractionService(
        roomId: _liveRoomController.roomId,
        anchorUid: anchorUid,
      ),
      isEnabled: () => mounted && _enhancementEnabled,
    );
  }

  Widget _buildInteractionWidget(
    int initialTab, {
    LiveGift? quickGift,
    int quickQuantity = 1,
  }) => Obx(() {
    final room = _liveRoomController.roomInfoH5.value;
    final anchorUid = room?.roomInfo?.uid ?? _liveRoomController.ruid;
    if (anchorUid == null || anchorUid <= 0) {
      return const Center(child: Text('等待官方主播信息；当前不能提交互动。'));
    }
    final session = _sessionFor(anchorUid);
    return LiveInteractionPanel(
      key: ObjectKey(session),
      session: session,
      anchorName: room?.anchorInfo?.baseInfo?.uname ?? '主播 UID $anchorUid',
      onLogin: () => Get.toNamed('/loginPage'),
      onRecharge: _openOfficialRecharge,
      onOpenGuard: () => _openOfficialGuard(anchorUid),
      initialTab: initialTab,
      quickGift: quickGift,
      quickQuantity: quickQuantity,
    );
  });

  Future<void> _openOfficialRecharge() async {
    await _openOfficialWeb('https://link.bilibili.com/p/live-h5-recharge/');
  }

  Future<void> _openOfficialGuard(int anchorUid) async {
    final url = Uri.https(
      'live.bilibili.com',
      '/p/html/live-app-guard-info/index.html',
      {'uid': '$anchorUid', 'is_live_webview': '1'},
    ).toString();
    await _openOfficialWeb(url);
  }

  Future<void> _openOfficialWeb(String url) async {
    final account = Accounts.main;
    final mainGeneration = Accounts.mainChangeGeneration;
    if (!account.isLogin) {
      SmartDialog.showToast('请先在 PiliPlus 登录；若官方页仍要求登录，请刷新登录后重试');
      return;
    }
    try {
      await LoginUtils.prepareOfficialLiveWebview(account);
    } catch (_) {
      SmartDialog.showToast(
        Platform.isLinux
            ? 'Linux 暂无法核验官方网页登录态，已阻止打开付费页面'
            : '无法确认官方网页与当前主账号一致，已阻止打开；请刷新登录后重试',
      );
      return;
    }
    if (!mounted ||
        !identical(Accounts.main, account) ||
        Accounts.mainChangeGeneration != mainGeneration) {
      SmartDialog.showToast('主账号已切换，已阻止打开官方页面');
      return;
    }
    final wasPlaying = plPlayerController.playerStatus.isPlaying;
    _openingOfficialWeb = true;
    if (wasPlaying) await plPlayerController.pause();
    InAppMiniPlayer.instance.suppressNextNavigation(_miniOwnerKey);
    try {
      await Get.toNamed(
        '/webview',
        parameters: {'url': url},
        arguments: {'inApp': true, 'officialLiveAccount': account},
      );
    } finally {
      _openingOfficialWeb = false;
      if (mounted &&
          wasPlaying &&
          identical(Accounts.main, account) &&
          Accounts.mainChangeGeneration == mainGeneration) {
        await plPlayerController.play();
      }
    }
  }

  Future<void> _showSuperChatPurchase() async {
    if (!Accounts.main.isLogin) {
      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        constraints: const BoxConstraints(maxWidth: 480),
        builder: (sheetContext) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '醒目留言 SC',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                '访客可以阅读直播中的 SC。编辑、购买与发送需要先在 PiliPlus 登录；官方页面若仍要求登录，请返回刷新登录后重试。',
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('知道了'),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    final room = _liveRoomController.roomInfoH5.value?.roomInfo;
    final anchorUid = room?.uid ?? _liveRoomController.ruid;
    final config = anchorUid == null || anchorUid <= 0
        ? null
        : _sessionFor(anchorUid).service.loadSuperChatConfig(
            parentAreaId: room?.parentAreaId ?? 0,
            areaId: room?.areaId ?? 0,
          );
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (sheetContext) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '醒目留言 SC',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (config == null)
                const Text('房间或主播信息未就绪，SC 档位尚不能读取。')
              else
                FutureBuilder<LiveSuperChatConfig>(
                  future: config,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const LinearProgressIndicator();
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text('SC 当前档位读取失败；以官方页面的最新价格和权限为准。');
                    }
                    final tiers = snapshot.data!.tiers;
                    if (tiers.isEmpty) return const Text('此房间未返回 SC 档位候选数据。');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('以下为官方配置接口的只读候选字段；单位与当前可购性待登录核实。'),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final tier in tiers)
                              Chip(
                                label: Text(
                                  '原始档位值 ${tier.price}（单位待核实）'
                                  '${tier.maxLength == null ? "" : " · ${tier.maxLength}字"}'
                                  '${tier.visibleSeconds == null ? "" : " · ${tier.visibleSeconds}秒"}',
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              const SizedBox(height: 12),
              const Text(
                '当前版本打开哔哩哔哩官方直播间；如该房间支持 SC，请在官方页面完成编辑、付款与审核。若官方页要求登录，请返回 PiliPlus 刷新登录后重试。返回本页不代表留言已发送成功。',
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  Navigator.pop(sheetContext);
                  await _openOfficialWeb(
                    'https://live.bilibili.com/${_liveRoomController.roomId}',
                  );
                  if (mounted) {
                    _interactionSession?.load();
                  }
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('在应用内打开官方直播间查看 SC'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEnhancement(
    int initialTab, {
    LiveGift? quickGift,
    int quickQuantity = 1,
  }) async {
    if (!_enhancementEnabled) return;
    if (_enhancementSheetRoute?.isActive != true) {
      _enhancementSheetRoute = null;
    }
    if (_enhancementSheetRoute != null) return;
    if (_interactionSession?.snapshot != null) _interactionSession?.load();
    try {
      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 560),
        builder: (sheetContext) {
          _enhancementSheetRoute = ModalRoute.of(sheetContext);
          return FractionallySizedBox(
            heightFactor: 0.85,
            child: LiveEnhancementDrawer(
              controller: _liveRoomController,
              interactions: _buildInteractionWidget(
                initialTab,
                quickGift: quickGift,
                quickQuantity: quickQuantity,
              ),
              onShowRank: _showRank,
              title: initialTab < 2 ? '礼物' : '粉丝团与大航海',
            ),
          );
        },
      );
    } finally {
      _enhancementSheetRoute = null;
      _interactionSession?.hide();
    }
  }

  void _onSendDanmaku([bool fromEmote = false]) {
    if (_enhancementEnabled) {
      _focusEnhancedChat(showEmote: fromEmote);
      return;
    }
    _liveRoomController.onSendDanmaku(fromEmote);
  }

  void _onAtUser(DanmakuMsg item) {
    if (_enhancementEnabled) {
      _focusEnhancedChat(mention: item);
      return;
    }
    _liveRoomController.onAtUser(item);
  }

  void _focusEnhancedChat({bool showEmote = false, DanmakuMsg? mention}) {
    if (kReleaseMode && !_liveRoomController.isLogin) {
      _liveRoomController.toastNotLogin();
      return;
    }
    final composer = _inlineDmKey.currentState;
    if (composer != null &&
        ((!isFullScreen && !plPlayerController.isDesktopPip) ||
            _enhancementChatRoute?.isActive == true)) {
      if (mention case final item?) {
        // PopupMenu closes after onTap. Wait for it to release focus before
        // moving the cursor into the inline composer.
        _focusInlineAfterFrame(showEmote: false, mention: item);
      } else {
        composer.focusInput(showEmote: showEmote);
      }
      return;
    }
    if (isFullScreen || plPlayerController.isDesktopPip) {
      _showInlineChat(showEmote: showEmote, mention: mention);
      return;
    }
    _enhancementPanelKey.currentState?.showChat();
    _focusInlineAfterFrame(showEmote: showEmote, mention: mention);
  }

  void _focusInlineAfterFrame({
    required bool showEmote,
    DanmakuMsg? mention,
    int framesRemaining = 2,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_enhancementEnabled) return;
      final composer = _inlineDmKey.currentState;
      if (composer == null) {
        if (framesRemaining > 0) {
          _focusInlineAfterFrame(
            showEmote: showEmote,
            mention: mention,
            framesRemaining: framesRemaining - 1,
          );
        }
      } else if (mention case final item?) {
        composer.mention(item);
      } else {
        composer.focusInput(showEmote: showEmote);
      }
    });
  }

  Future<void> _showInlineChat({
    bool showEmote = false,
    DanmakuMsg? mention,
  }) async {
    if (!_enhancementEnabled || _enhancementChatRoute != null) return;
    var focusRequested = false;
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 560),
      builder: (sheetContext) {
        _enhancementChatRoute = ModalRoute.of(sheetContext);
        if (!focusRequested) {
          focusRequested = true;
          _focusInlineAfterFrame(showEmote: showEmote, mention: mention);
        }
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: LiveInteractionFocusBoundary(
              child: Material(
                color: Theme.of(sheetContext).colorScheme.surface,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        const Expanded(child: Text('直播聊天')),
                        IconButton(
                          tooltip: '关闭聊天',
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    Expanded(
                      child: LiveRoomChatPanel(
                        liveRoomController: _liveRoomController,
                        isPP: false,
                        onMention: _onAtUser,
                      ),
                    ),
                    _buildInlineInputWidget,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    _enhancementChatRoute = null;
  }

  void _saveInlineDraft(List<RichTextItem> items) {
    _liveRoomController.savedDanmaku = items.isEmpty ? null : items.toList();
  }

  void _onInlineEmojiChanged(bool value) {
    if (mounted && _inlineEmojiVisible != value) {
      setState(() => _inlineEmojiVisible = value);
    }
  }

  Widget get _buildInlineInputWidget => LiveInteractionFocusBoundary(
    child: Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: LiveSendDmPanel(
        key: _inlineDmKey,
        inline: true,
        autofocus: false,
        onInlineEmojiChanged: _onInlineEmojiChanged,
        onFanClub: () => _showEnhancement(2),
        onSuperChat: _showSuperChatPurchase,
        fanSession: _interactionSession,
        liveRoomController: _liveRoomController,
        items: _liveRoomController.savedDanmaku,
        onSave: _saveInlineDraft,
      ),
    ),
  );

  Widget _buildChatWidget([bool isPP = false]) {
    Widget chat() => LiveRoomChatPanel(
      key: chatKey,
      isPP: isPP,
      liveRoomController: _liveRoomController,
      onMention: _enhancementEnabled ? _onAtUser : null,
    );
    return Padding(
      padding: .only(bottom: 12, top: isPortrait ? 12 : 0),
      child: _liveRoomController.showSuperChat
          ? PageView(
              key: pageKey,
              controller: _liveRoomController.pageController,
              physics: tabBarScrollPhysics,
              onPageChanged: _liveRoomController.pageIndex.call,
              horizontalDragGestureRecognizer:
                  CustomHorizontalDragGestureRecognizer.new,
              children: [
                KeepAliveWrapper(child: chat()),
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
      padding: .only(top: 5, left: 10, right: 10, bottom: padding.bottom),
      height: 70 + padding.bottom,
      decoration: const BoxDecoration(
        borderRadius: .vertical(top: .circular(20)),
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
        color: Color(0x1AFFFFFF),
      ),
      child: GestureDetector(
        onTap: _liveRoomController.onSendDanmaku,
        behavior: .opaque,
        child: Padding(
          padding: const .only(top: 5, bottom: 10),
          child: Align(
            alignment: .topCenter,
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
                        style: IconButton.styleFrom(padding: .zero),
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
                                color: baseWhite,
                              )
                            : const Icon(
                                size: 22,
                                CustomIcons.dm_off,
                                color: baseWhite,
                              ),
                      ),
                    );
                  },
                ),
                const Expanded(
                  child: Text('发送弹幕', style: TextStyle(color: baseWhite)),
                ),
                Builder(
                  builder: (context) {
                    final isLogin = kDebugMode || _liveRoomController.isLogin;
                    final colorScheme = ColorScheme.of(context);
                    return Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            overlayColor: _overlayColor(colorScheme),
                            customBorder: const CircleBorder(),
                            onTap: isLogin
                                ? null
                                : _liveRoomController.toastNotLogin,
                            onTapDown: isLogin
                                ? _liveRoomController.onLikeTapDown
                                : null,
                            onTapUp: isLogin
                                ? _liveRoomController.onLikeTapUp
                                : null,
                            onTapCancel: isLogin
                                ? _liveRoomController.onLikeTapUp
                                : null,
                            child: const SizedBox.square(
                              dimension: 34,
                              child: Icon(
                                size: 22,
                                color: baseWhite,
                                Icons.thumb_up_off_alt,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 30,
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
                      color: baseWhite,
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
          child,
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Obx(
              () => _BorderIndicator(
                radius: const Radius.circular(20),
                isLeft: _liveRoomController.pageIndex.value == 0,
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }

  WidgetStateProperty<Color?>? _overlayColor(ColorScheme colorScheme) =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        final color = states.contains(WidgetState.selected)
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant;
        if (states.contains(WidgetState.pressed)) {
          return color.withValues(alpha: 0.1);
        } else if (states.contains(WidgetState.hovered)) {
          return color.withValues(alpha: 0.08);
        } else if (states.contains(WidgetState.focused)) {
          return color.withValues(alpha: 0.1);
        } else {
          return Colors.transparent;
        }
      });
}

class _BorderIndicator extends LeafRenderObjectWidget {
  const _BorderIndicator({
    required this.radius,
    required this.isLeft,
  });

  final Radius radius;
  final bool isLeft;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBorderIndicator(
      radius: radius,
      isLeft: isLeft,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderBorderIndicator renderObject,
  ) {
    renderObject
      ..radius = radius
      ..isLeft = isLeft;
  }
}

class _RenderBorderIndicator extends RenderBox {
  _RenderBorderIndicator({
    required this._radius,
    required this._isLeft,
  });

  Radius _radius;
  Radius get radius => _radius;
  set radius(Radius value) {
    if (_radius == value) return;
    _radius = value;
    markNeedsLayout();
  }

  bool _isLeft;
  bool get isLeft => _isLeft;
  set isLeft(bool value) {
    if (_isLeft == value) return;
    _isLeft = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrainDimensions(constraints.maxWidth, _radius.x);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final size = this.size;
    final canvas = context.canvas;
    final width = size.width / 2;

    BoxBorder.paintNonUniformBorder(
      canvas,
      Rect.fromLTWH(
        offset.dx + (_isLeft ? 0 : width),
        offset.dy,
        width,
        size.height,
      ),
      borderRadius: BorderRadius.only(
        topLeft: _isLeft ? _radius : .zero,
        topRight: _isLeft ? .zero : _radius,
      ),
      textDirection: null,
      top: const BorderSide(),
      color: Colors.white38,
    );
  }
}

class LiveDanmaku extends StatefulWidget {
  final LiveRoomController liveRoomController;
  final PlPlayerController plPlayerController;
  final bool isPipMode;
  final bool isFullScreen;
  final Size size;

  const LiveDanmaku({
    super.key,
    required this.liveRoomController,
    required this.plPlayerController,
    this.isPipMode = false,
    required this.isFullScreen,
    required this.size,
  });

  @override
  State<LiveDanmaku> createState() => _LiveDanmakuState();

  bool get notFullscreen => !isFullScreen || isPipMode;
}

class _LiveDanmakuState extends State<LiveDanmaku> {
  PlPlayerController get plPlayerController => widget.plPlayerController;

  @override
  void didUpdateWidget(LiveDanmaku oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notFullscreen != widget.notFullscreen &&
        !DanmakuOptions.sameFontScale) {
      plPlayerController.danmakuController?.updateOption(
        DanmakuOptions.get(notFullscreen: widget.notFullscreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final option = DanmakuOptions.get(notFullscreen: widget.notFullscreen);
    return Obx(
      () => AnimatedOpacity(
        opacity: plPlayerController.enableShowLiveDanmaku.value
            ? plPlayerController.danmakuOpacity.value
            : 0,
        duration: const Duration(milliseconds: 100),
        child: DanmakuScreen<DanmakuExtra>(
          createdController: (e) {
            widget.liveRoomController.danmakuController =
                plPlayerController.danmakuController = e;
          },
          option: option,
          size: widget.size,
        ),
      ),
    );
  }
}
