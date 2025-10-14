import 'dart:convert';

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/pages/danmaku/controller.dart';
import 'package:PiliPlus/pages/danmaku/dnamaku_model.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 传入播放器控制器，监听播放进度，加载对应弹幕
class PlDanmaku extends StatefulWidget {
  final int cid;
  final PlPlayerController playerController;
  final bool isPipMode;
  final bool isFullScreen;

  const PlDanmaku({
    super.key,
    required this.cid,
    required this.playerController,
    this.isPipMode = false,
    required this.isFullScreen,
  });

  @override
  State<PlDanmaku> createState() => _PlDanmakuState();
}

class _PlDanmakuState extends State<PlDanmaku> {
  PlPlayerController get playerController => widget.playerController;

  late PlDanmakuController _plDanmakuController;
  DanmakuController<DanmakuExtra>? _controller;
  int latestAddedPosition = -1;

  @override
  void initState() {
    super.initState();
    _plDanmakuController = PlDanmakuController(
      widget.cid,
      playerController,
    );
    if (playerController.enableShowDanmaku.value) {
      _plDanmakuController.queryDanmaku(
        _plDanmakuController.calcSegment(
          playerController.position.value.inMilliseconds,
        ),
      );
    }
    playerController
      ..addStatusLister(playerListener)
      ..addPositionListener(videoPositionListen);
  }

  @override
  void didUpdateWidget(PlDanmaku oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPipMode != widget.isPipMode ||
        oldWidget.isFullScreen != widget.isFullScreen) {
      _updateFontSize();
    }
  }

  void _updateFontSize() {
    _controller?.updateOption(
      _controller!.option.copyWith(fontSize: _fontSize),
    );
  }

  double get _fontSize => !widget.isFullScreen || widget.isPipMode
      ? 15 * playerController.danmakuFontScale
      : 15 * playerController.danmakuFontScaleFS;

  // 播放器状态监听
  void playerListener(PlayerStatus? status) {
    if (status == PlayerStatus.playing) {
      _controller?.resume();
    } else {
      _controller?.pause();
    }
  }

  void videoPositionListen(Duration position) {
    if (_controller == null || !playerController.enableShowDanmaku.value) {
      return;
    }

    if (!playerController.showDanmaku && !widget.isPipMode) {
      return;
    }

    if (playerController.playerStatus.status.value != PlayerStatus.playing) {
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
      final blockColorful = playerController.blockColorful;
      for (DanmakuElem e in currentDanmakuList) {
        if (e.mode == 7) {
          try {
            _controller!.addDanmaku(
              SpecialDanmakuContentItem.fromList(
                DmUtils.decimalToColor(e.color),
                e.fontsize.toDouble(),
                jsonDecode(e.content.replaceAll('\n', '\\n')),
              ),
            );
          } catch (_) {}
        } else {
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
              count: e.hasCount() ? e.count : null,
              selfSend: e.isSelf,
              extra: VideoDanmaku(id: e.id.toInt(), mid: e.midHash),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    playerController
      ..removePositionListener(videoPositionListen)
      ..removeStatusLister(playerListener);
    _plDanmakuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: playerController.enableShowDanmaku.value
            ? playerController.danmakuOpacity.value
            : 0,
        duration: const Duration(milliseconds: 100),
        child: DanmakuScreen<DanmakuExtra>(
          createdController: (e) {
            playerController.danmakuController = _controller = e;
          },
          option: DanmakuOption(
            fontSize: _fontSize,
            fontWeight: playerController.danmakuFontWeight,
            area: playerController.showArea,
            hideTop: playerController.blockTypes.contains(5),
            hideScroll: playerController.blockTypes.contains(2),
            hideBottom: playerController.blockTypes.contains(4),
            duration:
                playerController.danmakuDuration /
                playerController.playbackSpeed,
            staticDuration:
                playerController.danmakuStaticDuration /
                playerController.playbackSpeed,
            strokeWidth: playerController.danmakuStrokeWidth,
            lineHeight: playerController.danmakuLineHeight,
          ),
        ),
      ),
    );
  }
}
