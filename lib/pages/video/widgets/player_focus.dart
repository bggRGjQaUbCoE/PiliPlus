import 'dart:async';
import 'dart:io' show exit, Platform;
import 'dart:math' as math;

import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/shortcut_action.dart';
import 'package:PiliPlus/services/shortcut_service.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyUpEvent, LogicalKeyboardKey, HardwareKeyboard;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:material_ui/material_ui.dart';

class PlayerFocus extends StatelessWidget {
  const PlayerFocus({
    super.key,
    required this.child,
    required this.plPlayerController,
    this.introController,
    required this.onSendDanmaku,
    this.canPlay,
    this.onSkipSegment,
    this.onRefresh,
  });

  final Widget child;
  final PlPlayerController plPlayerController;
  final CommonIntroController? introController;
  final VoidCallback onSendDanmaku;
  final ValueGetter<bool>? canPlay;
  final ValueGetter<bool>? onSkipSegment;
  final VoidCallback? onRefresh;

  static bool _shouldHandle(LogicalKeyboardKey logicalKey) {
    return logicalKey == LogicalKeyboardKey.tab ||
        logicalKey == LogicalKeyboardKey.arrowLeft ||
        logicalKey == LogicalKeyboardKey.arrowRight ||
        logicalKey == LogicalKeyboardKey.arrowUp ||
        logicalKey == LogicalKeyboardKey.arrowDown;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        final handled = _handleKey(context, event);
        if (handled || _shouldHandle(event.logicalKey)) {
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  bool get isFullScreen => plPlayerController.isFullScreen.value;
  bool get hasPlayer => plPlayerController.videoPlayerController != null;

  void _setVolume({required bool isIncrease}) {
    final volume = isIncrease
        ? math.min(
            plPlayerController.maxVolume,
            plPlayerController.volume.value + 0.1,
          )
        : math.max(0.0, plPlayerController.volume.value - 0.1);
    plPlayerController.setVolume(volume);
  }

  void _updateVolume(KeyEvent event, {required bool isIncrease}) {
    if (event is KeyDownEvent) {
      if (hasPlayer) {
        _setVolume(isIncrease: isIncrease);
        plPlayerController
          ..longPressTimer?.cancel()
          ..longPressTimer = Timer.periodic(
            const Duration(milliseconds: 150),
            (_) => _setVolume(isIncrease: isIncrease),
          );
      }
    } else if (event is KeyUpEvent) {
      plPlayerController.cancelLongPressTimer();
    }
  }

  void _toggleFullScreen({required bool inApp}) {
    final isFullScreen = this.isFullScreen;
    if (isFullScreen && plPlayerController.controlsLock.value) {
      plPlayerController
        ..controlsLock.value = false
        ..showControls.value = false;
    }
    plPlayerController.triggerFullScreen(
      status: !isFullScreen,
      inAppFullScreen: inApp,
    );
  }

  void _setSpeed(double speed) {
    if (hasPlayer) {
      if (speed != plPlayerController.playbackSpeed) {
        plPlayerController.setPlaybackSpeed(speed);
      }
      SmartDialog.showToast('${speed}x播放');
    }
  }

  /// 按「设置 → 倍速设置 → 倍速列表」逐档调整播放速度。
  void _stepSpeed({required bool isIncrease}) {
    if (!hasPlayer) return;
    final list = plPlayerController.speedList;
    if (list.isEmpty) return;

    // 1e-6 容差：长按倍速是 playbackSpeed * 2，浮点乘法可能带出 1.9999999 这类误差
    const eps = 1e-6;
    final current = plPlayerController.playbackSpeed;
    final index = isIncrease
        ? list.indexWhere((s) => s > current + eps)
        : list.lastIndexWhere((s) => s < current - eps);
    if (index < 0) {
      SmartDialog.showToast(isIncrease ? '已是最快倍速' : '已是最慢倍速');
      return;
    }
    _setSpeed(list[index]);
  }

  bool _handleKey(BuildContext context, KeyEvent event) {
    final key = event.logicalKey;

    // 固定系统行为（不可自定义）：macOS Cmd+Q 退出，Meta+Q/R 吞掉
    if (HardwareKeyboard.instance.isMetaPressed &&
        (key == LogicalKeyboardKey.keyQ || key == LogicalKeyboardKey.keyR)) {
      if (key == LogicalKeyboardKey.keyQ && Platform.isMacOS) {
        exit(0);
      }
      return true;
    }

    final action = ShortcutService.matchAction(
      event,
      isLive: plPlayerController.isLive,
    );
    if (action == null) {
      if (event is KeyDownEvent && (introController?.isTripling ?? false)) {
        introController!.onCancelTriple();
      }
      return false;
    }
    return _dispatch(context, action, event);
  }

  bool _dispatch(BuildContext context, ShortcutAction action, KeyEvent event) {
    final isDown = event is KeyDownEvent;
    // 非按住型动作只在初次按下时响应 —— Flutter 对一次按键会依次派发
    // KeyDown / KeyRepeat / KeyUp 三类事件，不在这里拦掉后两者的话，一次敲击会被
    // 执行两次（按下一次、松开一次）。拦住之后，下面各分支就不必再判断 isDown 了。
    // 需要看到 KeyUp 的按住型动作只有 isHold 那 4 个：音量加减、快进、三连。
    if (!isDown && !action.isHold) return true;

    // 任何其他按键按下时取消进行中的三连（Q 长按本身除外）
    if (isDown &&
        action != ShortcutAction.likeTriple &&
        (introController?.isTripling ?? false)) {
      introController!.onCancelTriple();
    }

    switch (action) {
      case ShortcutAction.playPause:
        if ((plPlayerController.isLive || canPlay!()) && hasPlayer) {
          plPlayerController.onDoubleTapCenter();
        }
        return true;

      case ShortcutAction.volumeUp:
        _updateVolume(event, isIncrease: true);
        return true;

      case ShortcutAction.volumeDown:
        _updateVolume(event, isIncrease: false);
        return true;

      case ShortcutAction.seekForward:
        if (!plPlayerController.isLive) {
          if (event is KeyDownEvent) {
            if (hasPlayer && !plPlayerController.longPressStatus.value) {
              plPlayerController
                ..longPressTimer?.cancel()
                ..longPressTimer = Timer(
                  const Duration(milliseconds: 200),
                  () => plPlayerController
                    ..cancelLongPressTimer()
                    ..setLongPressStatus(true),
                );
            }
          } else if (event is KeyUpEvent) {
            plPlayerController.cancelLongPressTimer();
            if (hasPlayer) {
              if (plPlayerController.longPressStatus.value) {
                plPlayerController.setLongPressStatus(false);
              } else {
                plPlayerController.onForward(
                  plPlayerController.fastForBackwardDuration,
                );
              }
            }
          }
        }
        return true;

      case ShortcutAction.seekBackward:
        if (hasPlayer) {
          plPlayerController.onBackward(
            plPlayerController.fastForBackwardDuration,
          );
        }
        return true;

      case ShortcutAction.refreshStream:
        onRefresh?.call();
        return true;

      case ShortcutAction.fullscreen:
        _toggleFullScreen(inApp: false);
        return true;

      case ShortcutAction.inAppFullscreen:
        _toggleFullScreen(inApp: true);
        return true;

      case ShortcutAction.desktopPip:
        if (PlatformUtils.isDesktop && hasPlayer && !isFullScreen) {
          plPlayerController
            ..toggleDesktopPip()
            ..controlsLock.value = false
            ..showControls.value = false;
        }
        return true;

      case ShortcutAction.screenshot:
        if (hasPlayer && isFullScreen) {
          plPlayerController.takeScreenshot();
        }
        return true;

      case ShortcutAction.lockControls:
        if (isFullScreen || plPlayerController.isDesktopPip) {
          plPlayerController.onLockControl(
            !plPlayerController.controlsLock.value,
          );
        }
        return true;

      case ShortcutAction.toggleDanmaku:
        final newVal = !plPlayerController.enableShowDanmakuAdaptive.value;
        plPlayerController.enableShowDanmakuAdaptive.value = newVal;
        if (!plPlayerController.tempPlayerConf) {
          GStorage.setting.put(
            plPlayerController.isLive
                ? SettingBoxKey.enableShowLiveDanmaku
                : SettingBoxKey.enableShowDanmaku,
            newVal,
          );
        }
        return true;

      case ShortcutAction.sendDanmaku:
        if (onSkipSegment?.call() ?? false) {
          return true;
        }
        onSendDanmaku();
        return true;

      case ShortcutAction.mute:
        if (hasPlayer) {
          final isMuted = !plPlayerController.isMuted;
          plPlayerController.videoPlayerController!.setVolume(
            isMuted ? 0 : plPlayerController.volume.value * 100,
          );
          plPlayerController.isMuted = isMuted;
          SmartDialog.showToast('${isMuted ? '' : '取消'}静音');
        }
        return true;

      case ShortcutAction.likeTriple:
        if (event is KeyDownEvent) {
          introController!.onStartTriple();
        } else if (event is KeyUpEvent) {
          introController!.onCancelTriple(true);
        }
        return true;

      case ShortcutAction.coin:
        introController?.actionCoinVideo();
        return true;

      case ShortcutAction.fav:
        introController?.actionFavVideo(isQuick: true);
        return true;

      case ShortcutAction.watchLater:
        introController?.viewLater();
        return true;

      case ShortcutAction.relationMod:
        if (introController case final UgcIntroController ugcCtr) {
          ugcCtr.actionRelationMod(context);
        }
        return true;

      case ShortcutAction.speedDown:
        _stepSpeed(isIncrease: false);
        return true;

      case ShortcutAction.speedUp:
        _stepSpeed(isIncrease: true);
        return true;

      case ShortcutAction.speedReset:
        _setSpeed(plPlayerController.playSpeedDefault);
        return true;

      case ShortcutAction.prevEpisode:
        if (introController case final introController?) {
          if (!introController.prevPlay()) {
            SmartDialog.showToast('已经是第一集了');
          }
        }
        return true;

      case ShortcutAction.nextEpisode:
        if (introController case final introController?) {
          if (!introController.nextPlay()) {
            SmartDialog.showToast('已经是最后一集了');
          }
        }
        return true;
    }
  }
}
