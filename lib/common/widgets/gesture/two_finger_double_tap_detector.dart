import 'dart:async';

import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:flutter/gestures.dart';

/// 在 `Listener` 层检测“双指双击”，不参与手势竞技场。
///
/// 不放进竞技场是为了避开双指缩放识别器：用户双指点击时只要有一点点位移，
/// 缩放识别器就可能先赢得竞技场，把手势识别器直接踢出局。这里只观察原始
/// 指针事件，因此不受竞技场胜负影响。
class TwoFingerDoubleTapDetector {
  TwoFingerDoubleTapDetector({
    required this.onDoubleTap,
    this.maxFingerDelay = const Duration(milliseconds: 250),
    this.maxTapDuration = const Duration(milliseconds: 500),
    this.doubleTapTimeout = const Duration(milliseconds: 500),
    this.slop = kDoubleTapSlop,
    this.fingerSlop = 300,
    this.moveSlop = kTouchSlop,
  });

  final VoidCallback onDoubleTap;

  /// 两根手指落下的最大间隔。
  final Duration maxFingerDelay;

  /// 一次双指点击（第一根手指按下到最后一根抬起）的最长时间。
  final Duration maxTapDuration;

  /// 两次双指点击之间的最大间隔。
  final Duration doubleTapTimeout;

  /// 两次点击之间的最大距离。
  final double slop;

  /// 两根手指之间的最大距离。
  final double fingerSlop;

  /// 单根手指在一次点击中允许的最大位移，超过则视为缩放/滑动。
  final double moveSlop;

  final Map<int, _Pointer> _pointers = <int, _Pointer>{};

  Offset? _tapCenter;
  Duration? _tapStart;
  bool _candidate = false;
  Offset? _firstTapCenter;
  Duration? _firstTapUpTime;
  Timer? _firstTapTimer;

  void onPointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = _Pointer(event.position, event.timeStamp);

    if (_pointers.length == 1) {
      _candidate = false;
      _tapCenter = null;
      _tapStart = event.timeStamp;
      // 新的点击开始，先停掉上一次点击的超时计时器；是否仍在双击窗口内
      // 由 _firstTapUpTime 显式判断，避免计时器在本次点击过程中触发。
      _firstTapTimer?.cancel();
      _firstTapTimer = null;
      final firstTapUpTime = _firstTapUpTime;
      if (firstTapUpTime != null &&
          event.timeStamp - firstTapUpTime > doubleTapTimeout) {
        _firstTapCenter = null;
        _firstTapUpTime = null;
      }
    } else if (_pointers.length == 2) {
      final pointers = _pointers.values.toList(growable: false);
      final first = pointers[0];
      final second = pointers[1];
      final center = (first.position + second.position) / 2;
      if (_tapStart == null ||
          (second.position - first.position).distance > fingerSlop ||
          second.time - first.time > maxFingerDelay ||
          (_firstTapCenter != null &&
              (center - _firstTapCenter!).distance > slop)) {
        _candidate = false;
        _tapCenter = null;
        _tapStart = null;
      } else {
        _candidate = true;
        _tapCenter = center;
      }
    } else {
      // 三指及以上不处理；等所有手指抬起后重新开始。
      _candidate = false;
      _tapCenter = null;
      _tapStart = null;
    }
  }

  void onPointerUp(PointerUpEvent event) {
    final pointer = _pointers.remove(event.pointer);
    if (pointer == null) return;

    // 手指在点击过程中移动过多，视为缩放/滑动而不是点击。
    if ((event.position - pointer.position).distance > moveSlop) {
      _candidate = false;
      _tapCenter = null;
    }

    if (_pointers.isNotEmpty) return;

    final start = _tapStart;
    final center = _tapCenter;
    if (!_candidate ||
        start == null ||
        center == null ||
        event.timeStamp - start > maxTapDuration) {
      _reset();
      return;
    }

    if (_firstTapCenter == null) {
      _firstTapCenter = center;
      _firstTapUpTime = event.timeStamp;
      _firstTapTimer?.cancel();
      _firstTapTimer = Timer(doubleTapTimeout, _onFirstTapTimeout);
    } else if ((center - _firstTapCenter!).distance <= slop) {
      _reset();
      onDoubleTap();
    } else {
      _reset();
    }
  }

  void onPointerCancel(PointerCancelEvent event) {
    if (_pointers.remove(event.pointer) == null) return;
    // 指针流被取消，本次点击作废；保留仍在按下的其它指针，等它们抬起。
    _resetTapState();
  }

  void _onFirstTapTimeout() {
    _firstTapTimer = null;
    _firstTapCenter = null;
    _firstTapUpTime = null;
  }

  void _resetTapState() {
    _firstTapTimer?.cancel();
    _firstTapTimer = null;
    _tapCenter = null;
    _tapStart = null;
    _candidate = false;
    _firstTapCenter = null;
    _firstTapUpTime = null;
  }

  void _reset() {
    _resetTapState();
    _pointers.clear();
  }

  void dispose() {
    _firstTapTimer?.cancel();
    _firstTapTimer = null;
  }
}

class _Pointer {
  const _Pointer(this.position, this.time);

  final Offset position;
  final Duration time;
}
