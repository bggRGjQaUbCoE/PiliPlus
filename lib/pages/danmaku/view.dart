import 'dart:convert';

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/pages/danmaku/controller.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';

/// 传入播放器控制器，监听播放进度，加载对应弹幕
class PlDanmaku extends StatefulWidget {
  final int cid;
  final PlPlayerController playerController;
  final bool isPipMode;
  final bool isFullScreen;
  final bool isFileSource;
  final Size size;

  const PlDanmaku({
    super.key,
    required this.cid,
    required this.playerController,
    this.isPipMode = false,
    required this.isFullScreen,
    required this.isFileSource,
    required this.size,
  });

  @override
  State<PlDanmaku> createState() => _PlDanmakuState();

  bool get notFullscreen => !isFullScreen || isPipMode;
}

class _PlDanmakuState extends State<PlDanmaku> {
  PlPlayerController get playerController => widget.playerController;

  late final PlDanmakuController _plDanmakuController;
  DanmakuController<DanmakuExtra>? _controller;
  int latestAddedPosition = -1;
  bool _loggedEarlySpecialDanmaku = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint(
        '[PlDanmaku] init state=${identityHashCode(this)} cid=${widget.cid} '
        'fileSource=${widget.isFileSource} fullScreen=${widget.isFullScreen} '
        'pip=${widget.isPipMode}',
      );
    }
    _plDanmakuController = PlDanmakuController(
      widget.cid,
      playerController,
      widget.isFileSource,
    );
    if (playerController.enableShowDanmaku.value) {
      if (widget.isFileSource) {
        _plDanmakuController.initFileDmIfNeeded();
      } else {
        _plDanmakuController.queryDanmaku(
          DmUtils.calcSegment(playerController.positionInMilliseconds),
        );
      }
    }
    playerController
      ..addStatusLister(playerListener)
      ..addPositionListener(videoPositionListen);
    if (!widget.isPipMode) {
      playerController.danmakuMaskPath.addListener(_onMaskPathChanged);
    }
  }

  void _onMaskPathChanged() =>
      _controller?.setMask(playerController.danmakuMaskPath.value);

  @override
  void didUpdateWidget(PlDanmaku oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notFullscreen != widget.notFullscreen &&
        !DanmakuOptions.sameFontScale) {
      _controller?.updateOption(
        DanmakuOptions.get(notFullscreen: widget.notFullscreen),
      );
    }
    if (oldWidget.isPipMode != widget.isPipMode) {
      if (widget.isPipMode) {
        playerController.danmakuMaskPath.removeListener(_onMaskPathChanged);
        _controller?.setMask(null);
      } else {
        playerController.danmakuMaskPath.addListener(_onMaskPathChanged);
        _onMaskPathChanged();
      }
    }
  }

  // 播放器状态监听
  void playerListener(PlayerStatus status) {
    if (_controller case final controller?) {
      if (status.isPlaying) {
        controller.resume();
      } else {
        controller.pause();
      }
    }
  }

  @pragma('vm:notify-debugger-on-exception')
  void videoPositionListen(Duration position) {
    if (_controller == null || !playerController.enableShowDanmaku.value) {
      return;
    }

    if (!playerController.showDanmaku && !widget.isPipMode) {
      return;
    }

    if (!playerController.playerStatus.isPlaying) {
      return;
    }

    int currentPosition = position.inMilliseconds;
    currentPosition -= currentPosition % 100; //取整百的毫秒数
    if (currentPosition == latestAddedPosition) {
      return;
    }
    latestAddedPosition = currentPosition;

    List<DanmakuElem>? currentDanmakuList = _plDanmakuController
        .getCurrentDanmaku(currentPosition);
    if (currentDanmakuList != null) {
      final blockColorful = DanmakuOptions.blockColorful;
      final danmakuWeight = DanmakuOptions.danmakuWeight;
      for (DanmakuElem e in currentDanmakuList) {
        if (e.weight < danmakuWeight) return;
        if (e.mode == 7) {
          if (kDebugMode &&
              !_loggedEarlySpecialDanmaku &&
              currentPosition <= 10000) {
            _loggedEarlySpecialDanmaku = true;
            debugPrint(
              '[PlDanmaku] early special danmaku state=${identityHashCode(this)} '
              'cid=${widget.cid} position=$currentPosition progress=${e.progress} '
              'mode=${e.mode} contentLength=${e.content.length}',
            );
          }
          try {
            _controller!.addDanmaku(
              SpecialDanmakuContentItem.fromList(
                DmUtils.decimalToColor(e.color),
                e.fontsize.toDouble(),
                jsonDecode(e.content.replaceAll('\n', '\\n')),
                extra: VideoDanmaku(
                  id: e.id.toInt(),
                  mid: e.midHash,
                  like: e.likeCount.toInt(),
                ),
              ),
            );
          } catch (_) {}
        } else {
          final displayCount = e.count > Pref.mergeDanmakuMarkThreshold
              ? e.count
              : null;
          final preferredCountPosition = switch (Pref.mergeDanmakuMarkPosition) {
            0 => DanmakuCountPosition.hidden,
            2 => DanmakuCountPosition.tail,
            _ => DanmakuCountPosition.head,
          };
          final countPosition = displayCount == null
              ? DanmakuCountPosition.hidden
              : preferredCountPosition;
          // Apply fontSize for merged danmaku (count > 1)
          // e.fontsize contains base * enlargeRate, multiply by user's scale
          double? itemFontSize;
          if (e.fontsize > 0 && e.count > 1) {
            final scale = !widget.isFullScreen || widget.isPipMode
                ? DanmakuOptions.danmakuFontScale
                : DanmakuOptions.danmakuFontScaleFS;
            itemFontSize = e.fontsize.toDouble() * scale;
          }
          // If itemFontSize is null, canvas_danmaku uses global fontSize from DanmakuOption
          
          _controller!.addDanmaku(
            DanmakuContentItem(
              e.content,
              color: blockColorful
                  ? Colors.white
                  : DmUtils.decimalToColor(e.color),
              type: DmUtils.getPosition(e.mode),
              isColorful:
                  playerController.showVipDanmaku &&
                  e.colorful == DmColorfulType.VipGradualColor,
              count: displayCount,
              countPosition: countPosition,
              fontSize: itemFontSize,
              selfSend: e.isSelf,
              extra: VideoDanmaku(
                id: e.id.toInt(),
                mid: e.midHash,
                like: e.likeCount.toInt(),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    playerController.danmakuMaskPath.removeListener(_onMaskPathChanged); // 未注册也安全
    if (kDebugMode) {
      debugPrint(
        '[PlDanmaku] dispose state=${identityHashCode(this)} cid=${widget.cid}',
      );
    }
    playerController
      ..removePositionListener(videoPositionListen)
      ..removeStatusLister(playerListener);
    _plDanmakuController.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final option = DanmakuOptions.get(
      notFullscreen: widget.notFullscreen,
      speed: playerController.playbackSpeed,
    );
    return Obx(
      () => AnimatedOpacity(
        opacity: playerController.enableShowDanmaku.value
            ? playerController.danmakuOpacity.value
            : 0,
        duration: const Duration(milliseconds: 100),
        child: DanmakuScreen<DanmakuExtra>(
          createdController: (e) {
            if (kDebugMode) {
              debugPrint(
                '[PlDanmaku] created canvas controller state=${identityHashCode(this)} '
                'cid=${widget.cid} controller=${identityHashCode(e)}',
              );
            }
            playerController.danmakuController = _controller = e;
            if (!widget.isPipMode) {
              e.setMask(playerController.danmakuMaskPath.value);
            }
          },
          option: option,
          size: widget.size,
        ),
      ),
    );
  }
}

