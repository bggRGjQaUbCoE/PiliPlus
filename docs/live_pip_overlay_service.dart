// lib/services/live_pip_overlay_service.dart
import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/view/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

/// 直播小窗 Overlay 服务
/// 用于在退出直播详情页后继续以小窗形式播放直播
class LivePipOverlayService {
  static OverlayEntry? _overlayEntry;
  static bool _isInPipMode = false;
  static String? _currentLiveHeroTag;
  static int? _currentRoomId;

  // 保存回调
  static VoidCallback? _onCloseCallback;
  static VoidCallback? _onReturnCallback;

  /// 是否正在小窗模式
  static bool get isInPipMode => _isInPipMode;

  /// 当前小窗的直播间ID
  static int? get currentRoomId => _currentRoomId;

  /// 启动直播小窗
  ///
  /// [context] - 构建上下文
  /// [heroTag] - 播放器的 heroTag
  /// [roomId] - 直播间ID
  /// [plPlayerController] - 播放器控制器
  /// [onClose] - 关闭小窗回调
  /// [onReturn] - 返回直播详情页回调
  static void startLivePip({
    required BuildContext context,
    required String heroTag,
    required int roomId,
    required PlPlayerController plPlayerController,
    VoidCallback? onClose,
    VoidCallback? onReturn,
  }) {
    //SmartDialog.showToast('启动小窗: roomId=$roomId');
    // 如果已经有小窗在播放，先关闭
    if (_isInPipMode) {
      stopLivePip(callOnClose: true);
    }

    // 立即设置标志
    _isInPipMode = true;
    _currentLiveHeroTag = heroTag;
    _currentRoomId = roomId;
    _onCloseCallback = onClose;
    _onReturnCallback = onReturn;

    _overlayEntry = OverlayEntry(
      builder: (context) => LivePipWidget(
        heroTag: heroTag,
        roomId: roomId,
        plPlayerController: plPlayerController,
        onClose: () {
          stopLivePip(callOnClose: true);
        },
        onReturn: () {
          // 执行返回回调
          final callback = _onReturnCallback;

          // 先移除overlay
          final overlayToRemove = _overlayEntry;
          _overlayEntry = null;

          try {
            overlayToRemove?.remove();
          } catch (e) {
            if (kDebugMode) {
              print('Error removing live pip overlay: $e');
            }
          }

          // 然后调用返回回调，打开直播详情页
          callback?.call();
        },
      ),
    );

    // 插入 overlay
    // 延迟插入 overlay，避免 context 失效
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final overlayContext = Get.overlayContext ?? context;
        Overlay.of(overlayContext).insert(_overlayEntry!);
        //SmartDialog.showToast(' Overlay 插入成功');
      } catch (e) {
        SmartDialog.showToast(' Overlay 插入失败: $e');
        // 清理状态
        _isInPipMode = false;
        _overlayEntry = null;
      }
    });
  }

  /// 停止直播小窗
  ///
  /// [callOnClose] - 是否调用关闭回调
  static void stopLivePip({bool callOnClose = true}) {
    //SmartDialog.showToast('关闭小窗: callOnClose=$callOnClose');
    if (!_isInPipMode && _overlayEntry == null) {
      //SmartDialog.showToast('小窗已经不存在了');
      return;
    }

    // 先设置标志
    _isInPipMode = false;
    _currentLiveHeroTag = null;
    _currentRoomId = null;

    // 保存回调
    final closeCallback = callOnClose ? _onCloseCallback : null;
    _onCloseCallback = null;
    _onReturnCallback = null;

    // 保存 overlay 引用
    final overlayToRemove = _overlayEntry;
    _overlayEntry = null;

    // 直接移除 overlay 并调用回调
    try {
      overlayToRemove?.remove();
    } catch (e) {
      if (kDebugMode) {
        print('Error removing live pip overlay: $e');
      }
    }

    // 调用回调
    closeCallback?.call();
  }

  /// 检查是否是当前直播间的小窗
  static bool isCurrentLiveRoom(int roomId) {
    return _isInPipMode && _currentRoomId == roomId;
  }
}

/// 直播小窗 Widget
class LivePipWidget extends StatefulWidget {
  final String heroTag;
  final int roomId;
  final PlPlayerController plPlayerController;
  final VoidCallback onClose;
  final VoidCallback onReturn;

  const LivePipWidget({
    super.key,
    required this.heroTag,
    required this.roomId,
    required this.plPlayerController,
    required this.onClose,
    required this.onReturn,
  });

  @override
  State<LivePipWidget> createState() => _LivePipWidgetState();
}

class _LivePipWidgetState extends State<LivePipWidget> {
  // 小窗位置和尺寸
  double? _left; // 改为可空，表示尚未初始化
  double? _top; // 改为可空，表示尚未初始化
  final double _width = 200;
  final double _height = 112; // 16:9 比例

  // 控件显示状态
  bool _showControls = true;
  Timer? _hideTimer;

  // 缓存
  late final Widget _videoPlayerWidget;

  @override
  void initState() {
    super.initState();
    // 只初始化一次 video player widget
    _videoPlayerWidget = PLVideoPlayer(
      maxWidth: _width,
      maxHeight: _height,
      plPlayerController: widget.plPlayerController,
      // 小窗模式不显示任何控件
      headerControl: const SizedBox.shrink(),
      bottomControl: const SizedBox.shrink(),
      danmuWidget: const SizedBox.shrink(),
    );
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    // 清理静态回调，防止内存泄漏
    // 即使 stopLivePip 没被调用（如App异常退出），也能在widget销毁时清理
    if (LivePipOverlayService._overlayEntry != null) {
      LivePipOverlayService._onCloseCallback = null;
      LivePipOverlayService._onReturnCallback = null;
    }
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
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
    final screenSize = MediaQuery.of(context).size;

    // 第一次构建时初始化位置到右下角，不触发setState
    _left ??= screenSize.width - _width - 16;
    _top ??= screenSize.height - _height - 100;

    return Positioned(
      left: _left!,
      top: _top!,
      child: GestureDetector(
        // 点击显示/隐藏控件
        onTap: _onTap,
        // 简化拖动逻辑，使用 delta 更新
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
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 12,
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
                        widget.onClose();
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

                  // 返回直播详情页按钮（中间）
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _hideTimer?.cancel();
                        widget.onReturn();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.open_in_full,
                          color: Colors.white,
                          size: 28,
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
