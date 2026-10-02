import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

/// 让一块区域支持键盘滚动（tab 驱动）。
///
/// 包住整个 tab 内容区后，切到内容 tab 即自动获得焦点，方向键 / PgUp / PgDn
/// 滚动当前激活 tab 的内容（[controller] 按状态返回对应滚动控制器），方向键
/// 长按持续滚动。点/悬停视频区会把焦点归还给播放器，方向键恢复音量控制。
/// [controller] 返回 null 时放行按键（冒泡给 PlayerFocus）。
class KeyboardScrollable extends StatefulWidget {
  const KeyboardScrollable({
    super.key,
    required this.controller,
    this.focusNode,
    required this.child,
  });

  /// 按当前状态返回滚动目标（如按激活 tab 解析）
  final ScrollController? Function() controller;

  /// 外部焦点节点（页面持有，切 tab 时主动 requestFocus 实现免点击）
  final FocusNode? focusNode;

  final Widget child;

  @override
  State<KeyboardScrollable> createState() => _KeyboardScrollableState();
}

class _KeyboardScrollableState extends State<KeyboardScrollable> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  Timer? _repeatTimer;

  static const double _arrowStep = 60;
  static const Duration _repeatDelay = Duration(milliseconds: 400);
  static const Duration _repeatInterval = Duration(milliseconds: 80);

  @override
  void initState() {
    super.initState();
    // 焦点丢失时停止长按滚动，防 KeyUp 丢失导致停不下来
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _repeatTimer?.cancel();
      _repeatTimer = null;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _repeatTimer?.cancel();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _scrollBy(double delta) {
    final ctr = widget.controller();
    if (ctr == null || !ctr.hasClients) return;
    // 走滚轮同路径：ExtendedNestedScrollView 的 animateTo 会把内层内容重置到
    // 顶部（nestOffset 对范围内值返回 inner.minScrollExtent），pointerScroll
    // 则正确分配 delta（竖屏滚轮正常即走此路径）
    ctr.position.pointerScroll(delta);
  }

  void _startRepeat(double delta) {
    // 先等待长按阈值再进入连续滚动，短按不会被误判为长按
    _repeatTimer?.cancel();
    _repeatTimer = Timer(_repeatDelay, () {
      _repeatTimer = Timer.periodic(_repeatInterval, (_) => _scrollBy(delta));
    });
  }

  void _stopRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  bool _isScrollKey(LogicalKeyboardKey key) =>
      key == LogicalKeyboardKey.arrowUp ||
      key == LogicalKeyboardKey.arrowDown ||
      key == LogicalKeyboardKey.pageUp ||
      key == LogicalKeyboardKey.pageDown;

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    final key = event.logicalKey;
    if (!_isScrollKey(key)) {
      return KeyEventResult.ignored;
    }
    // OS 重复事件是 KeyRepeatEvent（不是 KeyDownEvent），同样触发滚动；
    // 仅 KeyUp 停止长按定时器
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final ctr = widget.controller();
      switch (key) {
        case LogicalKeyboardKey.arrowUp:
          _scrollBy(-_arrowStep);
          _startRepeat(-_arrowStep);
          break;
        case LogicalKeyboardKey.arrowDown:
          _scrollBy(_arrowStep);
          _startRepeat(_arrowStep);
          break;
        case LogicalKeyboardKey.pageUp:
          if (ctr != null && ctr.hasClients) {
            _scrollBy(-ctr.position.viewportDimension * 0.9);
            _startRepeat(-ctr.position.viewportDimension * 0.9);
          }
          break;
        case LogicalKeyboardKey.pageDown:
          if (ctr != null && ctr.hasClients) {
            _scrollBy(ctr.position.viewportDimension * 0.9);
            _startRepeat(ctr.position.viewportDimension * 0.9);
          }
          break;
      }
    } else if (event is KeyUpEvent) {
      _stopRepeat();
    }
    // KeyUp 一并消费，避免冒泡到 PlayerFocus
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _onKeyEvent,
      child: MouseRegion(
        // 桌面端：悬停即认领，与"滚轮跟随指针"的既有交互一致
        onEnter: (_) => _focusNode.requestFocus(),
        child: Listener(
          onPointerDown: (_) => _focusNode.requestFocus(),
          child: widget.child,
        ),
      ),
    );
  }
}
