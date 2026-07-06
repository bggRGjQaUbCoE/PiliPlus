import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/draggable_scrollable_sheet.dart';
import 'package:PiliPlus/common/widgets/marquee.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart'
    show showPlayerVolumeDialog;
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart'
    show shutdownTimerService;
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LiveHeaderControl extends StatefulWidget {
  const LiveHeaderControl({
    super.key,
    required this.title,
    required this.upName,
    required this.plPlayerController,
    required this.onSendDanmaku,
    required this.onPlayAudio,
    required this.isPortrait,
    required this.liveController,
    required this.onlineWidget,
  });

  final String? title;
  final String? upName;
  final PlPlayerController plPlayerController;
  final VoidCallback onSendDanmaku;
  final VoidCallback onPlayAudio;
  final bool isPortrait;
  final LiveRoomController liveController;
  final Widget onlineWidget;

  @override
  State<LiveHeaderControl> createState() => _LiveHeaderControlState();
}

class _LiveHeaderControlState extends State<LiveHeaderControl>
    with TimeBatteryMixin {
  @override
  late final plPlayerController = widget.plPlayerController;

  @override
  bool get horizontalScreen => true;

  @override
  bool get isFullScreen => plPlayerController.isFullScreen.value;

  @override
  bool get isPortrait => widget.isPortrait;

  @override
  Widget build(BuildContext context) {
    final isFullScreen = this.isFullScreen;
    showCurrTimeIfNeeded(isFullScreen);
    final liveController = widget.liveController;
    Widget child;
    child = Obx(
      key: titleKey,
      () => MarqueeText(
        liveController.title.value,
        spacing: 30,
        velocity: 30,
        style: const TextStyle(
          fontSize: 15,
          height: 1,
          color: Colors.white,
        ),
      ),
    );
    if (isFullScreen) {
      child = Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          Row(
            spacing: 10,
            children: [
              if (widget.upName case final upName?)
                Text(
                  upName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              liveController.watchedWidget,
              widget.onlineWidget,
              liveController.timeWidget,
            ],
          ),
        ],
      );
    }
    child = Expanded(child: child);
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      primary: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          if (isFullScreen || plPlayerController.isDesktopPip)
            ComBtn(
              height: 30,
              tooltip: '返回',
              icon: const Icon(FontAwesomeIcons.arrowLeft, size: 15),
              onTap: () {
                if (plPlayerController.isDesktopPip) {
                  plPlayerController.exitDesktopPip();
                } else {
                  plPlayerController.triggerFullScreen(status: false);
                }
              },
            ),
          child,
          ...?timeBatteryWidgets,
          const SizedBox(width: 10),
          if (PlatformUtils.isDesktop && !plPlayerController.isDesktopPip)
            Obx(() {
              final isAlwaysOnTop = plPlayerController.isAlwaysOnTop.value;
              return ComBtn(
                height: 30,
                tooltip: '${isAlwaysOnTop ? '取消' : ''}置顶',
                icon: isAlwaysOnTop
                    ? const Icon(
                        size: 18,
                        Icons.push_pin,
                        color: Colors.white,
                      )
                    : const Icon(
                        size: 18,
                        Icons.push_pin_outlined,
                        color: Colors.white,
                      ),
                onTap: () => plPlayerController.setAlwaysOnTop(!isAlwaysOnTop),
              );
            }),
          if (isFullScreen || PlatformUtils.isDesktop)
            ComBtn(
              height: 30,
              tooltip: '发弹幕',
              icon: const Icon(
                size: 18,
                Icons.comment_outlined,
                color: Colors.white,
              ),
              onTap: widget.onSendDanmaku,
            ),
          if (Platform.isAndroid || (PlatformUtils.isDesktop && !isFullScreen))
            ComBtn(
              height: 30,
              tooltip: '画中画',
              onTap: () {
                if (PlatformUtils.isDesktop) {
                  plPlayerController.toggleDesktopPip();
                  return;
                }
                if (AndroidHelper.isPipAvailable) {
                  plPlayerController.enterPip();
                }
              },
              icon: const Icon(
                size: 18,
                Icons.picture_in_picture_outlined,
                color: Colors.white,
              ),
            ),
          Obx(
            () {
              final onlyPlayAudio = plPlayerController.onlyPlayAudio.value;
              return ComBtn(
                height: 30,
                tooltip: '仅播放音频',
                onTap: () {
                  plPlayerController.onlyPlayAudio.value = !onlyPlayAudio;
                  widget.onPlayAudio();
                },
                icon: onlyPlayAudio
                    ? const Icon(
                        size: 18,
                        MdiIcons.musicCircle,
                        color: Colors.white,
                      )
                    : const Icon(
                        size: 18,
                        MdiIcons.musicCircleOutline,
                        color: Colors.white,
                      ),
              );
            },
          ),
          if (PlatformUtils.isMobile)
            Obx(() {
              final continuePlayInBackground =
                  plPlayerController.continuePlayInBackground.value;
              return ComBtn(
                height: 30,
                tooltip: '${continuePlayInBackground ? '关闭' : ''}后台播放',
                onTap: plPlayerController.setContinuePlayInBackground,
                icon: continuePlayInBackground
                    ? const Icon(
                        size: 18,
                        Icons.play_circle,
                        color: Colors.white,
                      )
                    : const Icon(
                        size: 18,
                        Icons.play_circle_outline,
                        color: Colors.white,
                      ),
              );
            }),
          ComBtn(
            height: 30,
            tooltip: '定时关闭',
            onTap: () => shutdownTimerService.showScheduleExitDialog(
              context,
              isFullScreen: isFullScreen,
              isLive: true,
            ),
            icon: const Icon(
              size: 18,
              Icons.schedule,
              color: Colors.white,
            ),
          ),
          if (plPlayerController.videoPlayerController case final player?)
            SizedBox.square(
              dimension: 30,
              child: PopupMenuButton(
                iconSize: 18,
                padding: .zero,
                iconColor: Colors.white,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    height: 35,
                    onTap: _showLiveStreamDialog,
                    child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.alt_route, size: 17),
                        Text('切换路线', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    height: 35,
                    child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.info_outline, size: 17),
                        Text('播放信息', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () => HeaderControlState.showPlayerInfo(
                      context,
                      player: player,
                    ),
                  ),
                  if (PlatformUtils.isMobile)
                    PopupMenuItem(
                      height: 35,
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.volume_up, size: 17),
                          Text(
                            '播放器音量: ${player.getProperty('volume').subLength(3)}%',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      onTap: () => showPlayerVolumeDialog(
                        context,
                        () {},
                        onChanged: player.setVolume,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showLiveStreamDialog() {
    final controller = widget.liveController;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: math.min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) {
        final maxChildSize =
            PlatformUtils.isMobile && !context.mediaQuerySize.isPortrait
            ? 1.0
            : 0.7;
        return DynDraggableScrollableSheet(
          minChildSize: 0,
          maxChildSize: maxChildSize,
          snap: true,
          expand: false,
          snapSizes: [maxChildSize],
          initialChildSize: maxChildSize,
          builder: (context, scrollController) {
            final theme = Theme.of(context);
            final secondary = theme.colorScheme.secondary;
            final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
            final currStyle = TextStyle(fontSize: 14, color: secondary);
            return Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  InkWell(
                    onTap: Get.back,
                    borderRadius: Style.bottomSheetRadius,
                    child: SizedBox(
                      height: 35,
                      child: Center(
                        child: Container(
                          width: 32,
                          height: 3,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outline,
                            borderRadius: const .all(.circular(1.5)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: .only(
                        bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
                      ),
                      children: controller.stream.mapIndexed((si, stream) {
                        final isCurrStream = si == controller.streamIndex;
                        final streamColor = isCurrStream
                            ? secondary
                            : onSurfaceVariant;
                        return _ExpansionTile(
                          initiallyExpanded: isCurrStream,
                          iconColor: streamColor,
                          collapsedIconColor: streamColor,
                          title: Text(
                            stream.protocolName ?? si.toString(),
                            style: isCurrStream
                                ? currStyle
                                : const TextStyle(fontSize: 14),
                          ),
                          children: stream.format.mapIndexed((fi, format) {
                            final isCurrFormat =
                                isCurrStream && fi == controller.formatIndex;
                            final formatColor = isCurrFormat
                                ? secondary
                                : onSurfaceVariant;
                            return _ExpansionTile(
                              initiallyExpanded: isCurrFormat,
                              iconColor: formatColor,
                              collapsedIconColor: formatColor,
                              title: Text(
                                format.formatName ?? fi.toString(),
                                style: isCurrFormat
                                    ? currStyle
                                    : const TextStyle(fontSize: 14),
                              ),
                              children: format.codec.mapIndexed((ci, codec) {
                                final isCurrCodec =
                                    isCurrFormat && ci == controller.codecIndex;
                                final codecColor = isCurrCodec
                                    ? secondary
                                    : onSurfaceVariant;
                                return _ExpansionTile(
                                  initiallyExpanded: isCurrCodec,
                                  iconColor: codecColor,
                                  collapsedIconColor: codecColor,
                                  title: Text(
                                    '${codec.codecName ?? ci.toString()} (${LiveQuality.fromCode(codec.currentQn)?.desc ?? codec.currentQn})',
                                    style: isCurrCodec
                                        ? currStyle
                                        : const TextStyle(fontSize: 14),
                                  ),
                                  children: codec.urlInfo.mapIndexed((ui, url) {
                                    final isCurrUrl =
                                        isCurrCodec &&
                                        ui == controller.liveUrlIndex;
                                    return ListTile(
                                      dense: true,
                                      title: Text(
                                        '${url.host}...',
                                        style: isCurrUrl
                                            ? const TextStyle(fontSize: 14)
                                            : TextStyle(
                                                fontSize: 14,
                                                color: onSurfaceVariant,
                                              ),
                                      ),
                                      selected: isCurrUrl,
                                      onTap: isCurrUrl
                                          ? null
                                          : () {
                                              Get.back();
                                              controller.initLiveUrl(
                                                streamIndex: si,
                                                formatIndex: fi,
                                                codecIndex: ci,
                                                liveUrlIndex: ui,
                                              );
                                              GStorage.setting.put(
                                                SettingBoxKey.liveStream,
                                                [
                                                  stream.protocolName!,
                                                  format.formatName!,
                                                  codec.codecName!,
                                                ],
                                              );
                                            },
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ExpansionTile extends ExpansionTile {
  const _ExpansionTile({
    required super.title,
    // ignore: unused_element_parameter
    super.dense = true,
    // ignore: unused_element_parameter
    super.controlAffinity = .leading,
    // ignore: unused_element_parameter
    super.childrenPadding = const .only(left: 20),
    super.initiallyExpanded,
    super.iconColor,
    super.collapsedIconColor,
    super.children,
  });
}
