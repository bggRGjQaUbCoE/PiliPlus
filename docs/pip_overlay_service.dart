// lib/services/pip_overlay_service.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 尝试加一个视频页面堆栈管理器解决 PiP 返回问题
class VideoStackManager {
  static int _videoPageCount = 0;

  /// 当 VideoDetailController onInit 时调用
  static void increment() {
    _videoPageCount++;
  }

  /// 当 VideoDetailController onClose 时调用
  static void decrement() {
    if (_videoPageCount > 0) {
      _videoPageCount--;
    }
  }

  /// 检查是否正返回到另一个视频页
  /// 在 _onPopInvokedWithResult 中调用时，当前页面尚未销毁，
  /// 所以 _videoPageCount 仍然包含当前页。
  /// 如果 _videoPageCount > 1，意味着栈中至少还有另一个视频页。
  static bool isReturningToVideo() {
    return _videoPageCount > 1;
  }
}

class PipOverlayService {
  static OverlayEntry? _overlayEntry;
  static bool isInPipMode = false;

  // 保存回调，以便在外部关闭时调用
  static VoidCallback? _onCloseCallback;
  static VoidCallback? _onTapToReturnCallback;

  // 启动 PiP - 支持传入播放器 Widget builder
  static void startPip({
    required BuildContext context,
    required Widget Function(bool isPipMode) videoPlayerBuilder,
    VoidCallback? onClose,
    VoidCallback? onTapToReturn,
  }) {
    if (isInPipMode) return;

    // 立即设置标志，防止重复调用
    isInPipMode = true;
    _onCloseCallback = onClose;
    _onTapToReturnCallback = onTapToReturn;

    _overlayEntry = OverlayEntry(
      builder: (context) => PipWidget(
        videoPlayerBuilder: videoPlayerBuilder,
        onClose: () {
          // 调用 stopPip 时传递 immediate: true，确保立即移除
          stopPip(callOnClose: true, immediate: true);
        },
        onTapToReturn: () {
          // 1. 保存回调
          final callback = _onTapToReturnCallback;
          _onCloseCallback = null;
          _onTapToReturnCallback = null;

          // 2. 立即调用回调打开新页面
          // 注意：不在这里设置 isInPipMode = false，让新页面的 initState 来处理
          callback?.call();

          // 3. overlay 将在新页面的 initState 中通过 stopPip 被清理
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // 停止 PiP
  static void stopPip({bool callOnClose = true, bool immediate = false}) {
    if (!isInPipMode && _overlayEntry == null) {
      // 已经停止，直接返回
      return;
    }

    // 先设置标志
    isInPipMode = false;

    // 保存回调
    final closeCallback = callOnClose ? _onCloseCallback : null;
    _onCloseCallback = null;
    _onTapToReturnCallback = null;

    // 保存 overlay 引用
    final overlayToRemove = _overlayEntry;
    _overlayEntry = null;

    // 移除和回调的逻辑
    void removeAndCallback() {
      try {
        overlayToRemove?.remove();
      } catch (e) {
        if (kDebugMode) {
          print('Error removing overlay: $e');
        }
      }
      // 调用回调
      closeCallback?.call();
    }

    if (immediate) {
      // 如果要求立即执行，则不延迟
      removeAndCallback();
    } else {
      // 多延迟几帧再移除 overlay，给 GetX 足够的时间完成清理
      // 使用 Future.delayed 而不是 addPostFrameCallback，确保有足够的延迟
      Future.delayed(const Duration(milliseconds: 300), removeAndCallback);
    }
  }
}

// PiP 小窗 Widget
// 缓存 videoPlayerBuilder 返回的 Widget，避免拖动时重复构建
class PipWidget extends StatefulWidget {
  final Widget Function(bool isPipMode) videoPlayerBuilder;
  final VoidCallback onClose;
  final VoidCallback onTapToReturn;

  const PipWidget({
    super.key,
    required this.videoPlayerBuilder,
    required this.onClose,
    required this.onTapToReturn,
  });

  @override
  State<PipWidget> createState() => _PipWidgetState();
}

class _PipWidgetState extends State<PipWidget> {
  double? _left; // 改为可空，表示尚未初始化
  double? _top; // 改为可空，表示尚未初始化
  final double _width = 200;
  final double _height = 112; // 16:9 比例

  bool _showControls = true;
  Timer? _hideTimer;

  // 标记是否正在关闭，用于提前隐藏 widget 避免 Obx 订阅清理错误
  bool _isClosing = false;

  // 缓存videoPlayer widget
  late final Widget _videoPlayerWidget;

  @override
  void initState() {
    super.initState();
    // 在 initState 中只构建一次播放器
    _videoPlayerWidget = widget.videoPlayerBuilder(true);
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    // 清理静态回调，防止内存泄漏
    // 即使 stopPip 没被调用（譬如App异常退出），也能在widget销毁时清理
    if (PipOverlayService._overlayEntry != null) {
      PipOverlayService._onCloseCallback = null;
      PipOverlayService._onTapToReturnCallback = null;
    }
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _onTap() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果正在关闭，立即返回空 widget，避免 videoPlayerBuilder 中的 Obx 继续订阅
    if (_isClosing) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;

    // 第一次构建时初始化位置到右下角
    _left ??= screenSize.width - _width - 16;
    _top ??= screenSize.height - _height - 100;

    return Positioned(
      left: _left!,
      top: _top!,
      child: GestureDetector(
        // 点击显示/隐藏控件
        onTap: _onTap,
        // 拖动使用 delta 更新
        onPanStart: (details) {
          _hideTimer?.cancel();
        },
        onPanUpdate: (details) {
          // 只更新位置，不更新 video player
          setState(() {
            _left = (_left! + details.delta.dx).clamp(
              0.0,
              screenSize.width - _width,
            );
            _top = (_top! + details.delta.dy).clamp(
              0.0,
              screenSize.height - _height,
            );
          });
        },
        onPanEnd: (details) {
          if (_showControls) {
            _startHideTimer();
          }
        },
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // 视频播放器 - 使用 AbsorbPointer 阻止所有手势传递给播放器
                Positioned.fill(
                  child: AbsorbPointer(
                    child: _videoPlayerWidget,
                  ),
                ),

                // 控件层 - 只在显示时渲染
                if (_showControls) ...[
                  // 半透明遮罩
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),

                  // 关闭按钮（右上角）
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        _hideTimer?.cancel();
                        // 先设置关闭标志，触发 build 返回空 widget
                        setState(() {
                          _isClosing = true;
                        });
                        // 延迟一帧后再真正关闭，确保 Obx 有时间清理订阅
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.onClose();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  // 返回按钮（中间）
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _hideTimer?.cancel();
                        // 先设置关闭标志，触发 build 返回空 widget
                        setState(() {
                          _isClosing = true;
                        });
                        // 延迟一帧后再真正执行返回，确保 Obx 有时间清理订阅
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.onTapToReturn();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.open_in_full,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}