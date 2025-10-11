import 'dart:math' show min;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/audio/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart' hide DraggableScrollableSheet;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();

  static void toAudioPage({
    int? id,
    required int oid,
    List<int>? subId,
    required int itemType,
    required PlaylistSource from,
    String? heroTag,
    Duration? start,
    String? audioUrl,
  }) => Get.toNamed(
    '/audio',
    arguments: {
      'id': ?id,
      'oid': oid,
      'subId': ?subId,
      'from': from,
      'itemType': itemType,
      'heroTag': ?heroTag,
      'start': ?start,
      'audioUrl': ?audioUrl,
    },
  );
}

class _AudioPageState extends State<AudioPage> {
  final _controller = Get.put(
    AudioController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final isPortrait = MediaQuery.sizeOf(context).isPortrait;
    final padding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _showMore,
            icon: const Icon(Icons.more_vert),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20 + padding.left,
          right: 20 + padding.right,
          bottom: 30 + padding.bottom,
        ),
        child: isPortrait
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildInfo(colorScheme, isPortrait)),
                  const SizedBox(height: 25),
                  _buildProgressBar(colorScheme),
                  _buildDuration(colorScheme),
                  _buildControls(),
                ],
              )
            : Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_buildInfo(colorScheme, isPortrait)],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final audioItem = _controller.audioItem.value;
                          if (audioItem != null) {
                            return _buildActions(audioItem);
                          }
                          return const SizedBox.shrink();
                        }),
                        const SizedBox(height: 25),
                        _buildProgressBar(colorScheme),
                        _buildDuration(colorScheme),
                        _buildControls(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showPlaylist() {
    if (_controller.playlist case final playlist?) {
      final initialScrollOffset = 45.0 * _controller.index!;
      final scrollController = ScrollController(
        initialScrollOffset: initialScrollOffset,
      );
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxWidth: min(640, context.mediaQueryShortestSide),
        ),
        builder: (context) {
          final colorScheme = ColorScheme.of(context);
          return FractionallySizedBox(
            heightFactor: !context.mediaQuerySize.isPortrait && Utils.isMobile
                ? 1.0
                : 0.7,
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                InkWell(
                  onTap: Get.back,
                  borderRadius: StyleString.bottomSheetRadius,
                  child: SizedBox(
                    height: 35,
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 3,
                        decoration: BoxDecoration(
                          color: colorScheme.outline,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    type: MaterialType.transparency,
                    child: refreshIndicator(
                      onRefresh: () => _controller.loadPrev(context),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.paddingOf(context).bottom + 100,
                            ),
                            sliver: SliverList.builder(
                              itemCount: playlist.length,
                              itemBuilder: (_, index) {
                                if (index == playlist.length - 1) {
                                  _controller.loadNext(context);
                                }
                                final isCurr = index == _controller.index;
                                final item = playlist[index];
                                return ListTile(
                                  dense: true,
                                  minTileHeight: 45,
                                  onTap: () {
                                    Get.back();
                                    if (!isCurr) {
                                      _controller.playIndex(index);
                                    }
                                  },
                                  title: Text.rich(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: isCurr
                                        ? TextStyle(
                                            height: 1,
                                            fontSize: 14,
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          )
                                        : const TextStyle(
                                            height: 1,
                                            fontSize: 14,
                                          ),
                                    strutStyle: const StrutStyle(
                                      height: 1,
                                      leading: 0,
                                      fontSize: 14,
                                    ),
                                    TextSpan(
                                      children: [
                                        if (isCurr) ...[
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.bottom,
                                            child: Image.asset(
                                              'assets/images/live.gif',
                                              width: 16,
                                              height: 16,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                          const TextSpan(text: '  '),
                                        ],
                                        TextSpan(
                                          text: item.arc.title,
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: isCurr
                                      ? null
                                      : iconButton(
                                          context: context,
                                          icon: Icons.clear,
                                          onPressed: () {
                                            if (index < _controller.index!) {
                                              _controller.index -= 1;
                                            }
                                            _controller.playlist!.removeAt(
                                              index,
                                            );
                                            (context as Element)
                                                .markNeedsBuild();
                                          },
                                          bgColor: Colors.transparent,
                                          iconColor: colorScheme.outline,
                                          size: 28,
                                          iconSize: 18,
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.viewPaddingOf(context).bottom,
                  ),
                  child: InkWell(
                    onTap: Get.back,
                    child: SizedBox(
                      height: 45,
                      child: Center(
                        child: Text(
                          '关闭',
                          style: TextStyle(color: colorScheme.outline),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).whenComplete(scrollController.dispose);
    }
  }

  void _showPlaySettings() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) {
        final colorScheme = ColorScheme.of(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: Get.back,
              borderRadius: StyleString.bottomSheetRadius,
              child: SizedBox(
                height: 35,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: colorScheme.outline,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 12,
                left: 20,
                right: 20,
                bottom: MediaQuery.viewPaddingOf(context).bottom + 20,
              ),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) => Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('播放倍速(${_controller.speed})'),
                        Slider(
                          padding: EdgeInsets.zero,
                          min: 0.5,
                          max: 2.0,
                          divisions: 15,
                          value: _controller.speed,
                          onChanged: (value) {
                            _controller.speed = value.toPrecision(1);
                            (context as Element).markNeedsBuild();
                          },
                          onChangeEnd: (_) =>
                              _controller.setSpeed(_controller.speed),
                        ),
                      ],
                    ),
                  ),
                  const Text('播放模式'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: PlayRepeat.values
                        .sublist(0, 4)
                        .map(
                          (e) => _playModeWidget(
                            colorScheme: colorScheme,
                            playMode: e,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _playModeWidget({
    required ColorScheme colorScheme,
    required PlayRepeat playMode,
  }) {
    final isCurr = playMode == _controller.playMode.value;
    final color = isCurr ? colorScheme.primary : colorScheme.outline;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.back();
        if (!isCurr) {
          _controller.playMode.value = playMode;
          GStorage.setting.put(SettingBoxKey.audioPlayMode, playMode.index);
        }
      },
      child: Column(
        spacing: 6,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurr
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.onInverseSurface.withValues(alpha: 0.8),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                size: 26,
                playMode.icon,
                color: color,
              ),
            ),
          ),
          Text(
            playMode.desc,
            style: TextStyle(fontSize: 13, color: color),
          ),
        ],
      ),
    );
  }

  void _showMore() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) {
        final colorScheme = ColorScheme.of(context);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context).bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: Get.back,
                borderRadius: StyleString.bottomSheetRadius,
                child: SizedBox(
                  height: 35,
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 3,
                      decoration: BoxDecoration(
                        color: colorScheme.outline,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ListTile(
              //   dense: true,
              //   title: const Text(
              //     '定时关闭',
              //     style: TextStyle(fontSize: 14),
              //   ),
              //   onTap: () {
              //     Get.back();
              //     _controller.showTimerDialog();
              //   },
              // ),
              if (_controller.itemType == 1)
                ListTile(
                  dense: true,
                  title: const Text(
                    '举报',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.back();
                    PageUtils.reportVideo(_controller.oid.toInt());
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActions(DetailItem audioItem) {
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => ActionItem(
              animation: _controller.tripleAnimation,
              icon: const Icon(FontAwesomeIcons.thumbsUp),
              selectIcon: const Icon(
                FontAwesomeIcons.solidThumbsUp,
              ),
              selectStatus: _controller.hasLike.value,
              semanticsLabel: '点赞',
              text: NumUtils.numFormat(audioItem.stat.like),
              onStartTriple: _controller.onStartTriple,
              onCancelTriple: _controller.onCancelTriple,
            ),
          ),
          Obx(
            () => ActionItem(
              animation: _controller.tripleAnimation,
              icon: const Icon(FontAwesomeIcons.b),
              selectIcon: const Icon(FontAwesomeIcons.b),
              onTap: _controller.actionCoinVideo,
              selectStatus: _controller.hasCoin,
              semanticsLabel: '投币',
              text: NumUtils.numFormat(
                audioItem.stat.coin,
              ),
            ),
          ),
          Obx(
            () => ActionItem(
              animation: _controller.tripleAnimation,
              icon: const Icon(FontAwesomeIcons.star),
              selectIcon: const Icon(
                FontAwesomeIcons.solidStar,
              ),
              onTap: () => _controller.showFavBottomSheet(context),
              onLongPress: () => _controller.showFavBottomSheet(
                context,
                isLongPress: true,
              ),
              selectStatus: _controller.hasFav.value,
              semanticsLabel: '收藏',
              text: NumUtils.numFormat(
                audioItem.stat.favourite,
              ),
            ),
          ),
          ActionItem(
            icon: const Icon(FontAwesomeIcons.comment),
            onTap: _controller.showReply,
            semanticsLabel: '评论',
            text: NumUtils.numFormat(
              audioItem.stat.reply,
            ),
          ),
          ActionItem(
            icon: const Icon(
              FontAwesomeIcons.shareFromSquare,
            ),
            onTap: () => _controller.actionShareVideo(context),
            selectStatus: false,
            semanticsLabel: '分享',
            text: NumUtils.numFormat(
              audioItem.stat.share,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ColorScheme colorScheme) {
    final primary = colorScheme.primary;
    final thumbGlowColor = primary.withAlpha(80);
    final bufferedBarColor = primary.withValues(alpha: 0.4);
    final baseBarColor = colorScheme.brightness.isDark
        ? const Color(0x33FFFFFF)
        : const Color(0x33999999);
    return Obx(() {
      final child = ProgressBar(
        progress: _controller.position.value,
        total: _controller.duration.value,
        baseBarColor: baseBarColor,
        progressBarColor: primary,
        bufferedBarColor: bufferedBarColor,
        thumbColor: primary,
        thumbGlowColor: thumbGlowColor,
        thumbGlowRadius: 0,
        thumbRadius: 6,
        onDragStart: (_) {},
        onDragUpdate: (details) {
          _controller
            ..isDragging = true
            ..position.value = details.timeStamp;
        },
        onSeek: (value) {
          _controller
            ..player?.platform?.seek(value)
            ..isDragging = false;
        },
      );
      if (Utils.isDesktop) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: child,
        );
      }
      return child;
    });
  }

  Widget _buildDuration(ColorScheme colorScheme) {
    return SizedBox(
      height: 30,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 13, color: colorScheme.outline),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              final position = _controller.position.value;
              if (_controller.player != null) {
                return Text(
                  DurationUtils.formatDuration(position.inSeconds),
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              final duration = _controller.duration.value;
              if (_controller.player != null) {
                return Text(
                  DurationUtils.formatDuration(duration.inSeconds),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(
          () => IconButton(
            onPressed: _showPlaySettings,
            icon: Icon(
              size: 26,
              _controller.playMode.value.icon,
            ),
          ),
        ),
        IconButton(
          onPressed: _controller.playPrev,
          icon: const Icon(
            size: 40,
            Icons.skip_previous_rounded,
          ),
        ),
        IconButton(
          onPressed: _controller.playOrPause,
          icon: AnimatedIcon(
            size: 40,
            icon: AnimatedIcons.play_pause,
            progress: _controller.animController,
          ),
        ),
        IconButton(
          onPressed: _controller.playNext,
          icon: const Icon(
            size: 40,
            Icons.skip_next_rounded,
          ),
        ),
        IconButton(
          onPressed: _showPlaylist,
          icon: const Icon(
            size: 26,
            Icons.menu_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(ColorScheme colorScheme, bool isPortrait) {
    return Obx(() {
      final audioItem = _controller.audioItem.value;
      if (audioItem != null) {
        final cover = audioItem.arc.cover.http2https;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => PageUtils.imageView(
                  imgList: [SourceModel(url: cover)],
                ),
                child: Hero(
                  tag: cover,
                  child: NetworkImgLayer(
                    src: cover,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(
                    audioItem.arc.title,
                    style: const TextStyle(
                      height: 1.7,
                      fontSize: 15,
                    ),
                  ),
                ),
                iconButton(
                  context: context,
                  icon: Icons.keyboard_arrow_down,
                  onPressed: () => _showIntro(audioItem),
                  bgColor: Colors.transparent,
                  iconColor: colorScheme.outline,
                  size: 26,
                  iconSize: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (audioItem.owner.hasName())
              Row(
                spacing: 6,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (audioItem.owner.hasAvatar())
                    NetworkImgLayer(
                      src: audioItem.owner.avatar,
                      width: 22,
                      height: 22,
                      type: ImageType.avatar,
                    ),
                  Text(
                    audioItem.owner.name,
                  ),
                ],
              ),
            if (isPortrait)
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildActions(audioItem),
                ),
              ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  void _showIntro(DetailItem audioItem) {
    final arc = audioItem.arc;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) {
        final colorScheme = ColorScheme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: Get.back,
              borderRadius: StyleString.bottomSheetRadius,
              child: SizedBox(
                height: 35,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: colorScheme.outline,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 12,
                left: 20,
                right: 20,
                bottom: MediaQuery.viewPaddingOf(context).bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('简介', style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 20),
                  Text(
                    arc.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        size: 14,
                        Icons.headphones_outlined,
                        color: colorScheme.outline,
                      ),
                      Text(
                        ' ${NumUtils.numFormat(audioItem.stat.view)}   '
                        '${DateFormatUtils.dateFormat(arc.publish.toInt(), long: DateFormatUtils.longFormatD)}   '
                        '${arc.displayedOid}',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SelectableText(arc.desc),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

extension _PlayReatExt on PlayRepeat {
  IconData get icon => switch (this) {
    PlayRepeat.pause => Icons.pause_rounded,
    PlayRepeat.listOrder => Icons.keyboard_double_arrow_right_rounded,
    PlayRepeat.singleCycle => Icons.play_circle_outline_rounded,
    PlayRepeat.listCycle => Icons.sync_rounded,
    PlayRepeat.autoPlayRelated => throw UnimplementedError(),
  };
}
