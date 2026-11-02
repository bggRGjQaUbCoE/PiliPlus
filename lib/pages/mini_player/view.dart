import 'dart:math' as math;

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/services/mini_player_service.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// 应用内小窗播放器
///
/// 挂载在 [GetMaterialApp.builder] 中，浮于所有页面之上。
class MiniPlayerView extends StatefulWidget {
  const MiniPlayerView({super.key});

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  /// 小窗宽度
  static const double _width = 190;

  /// 距屏幕边缘的间距
  static const double _margin = 12;

  /// 小窗左上角位置，null 表示使用默认位置（右下角）
  Offset? _offset;

  /// 当前布局计算出来的位置，供拖拽时使用
  Offset _layoutOffset = Offset.zero;

  static final _borderRadius = BorderRadius.circular(12);

  double _aspectRatio(PlPlayerController ctrl) {
    final width = ctrl.width;
    final height = ctrl.height;
    if (width == null || height == null || width <= 0 || height <= 0) {
      return 16 / 9;
    }
    return (width / height).clamp(0.5, 2.5).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final service = MiniPlayerService.instance;
      final ctrl = service.playerController;
      final videoController = ctrl?.videoController;
      if (!service.isShowing.value || ctrl == null || videoController == null) {
        return const SizedBox.shrink();
      }

      final mediaQuery = MediaQuery.of(context);
      final screen = mediaQuery.size;
      final padding = mediaQuery.padding;

      final aspectRatio = _aspectRatio(ctrl);
      var width = math.min(_width, screen.width * 0.55);
      var height = width / aspectRatio;
      final maxHeight = screen.height * 0.45;
      if (height > maxHeight) {
        height = maxHeight;
        width = height * aspectRatio;
      }
      final size = Size(width, height);

      final minTop = padding.top + _margin;
      final maxTop = math.max(
        minTop,
        screen.height - height - padding.bottom - _margin,
      );
      final maxLeft = math.max(_margin, screen.width - width - _margin);

      final defaultOffset = Offset(
        maxLeft,
        // 默认避让底部导航栏
        math.min(maxTop, screen.height - height - padding.bottom - 72),
      );
      final offset = _offset ?? defaultOffset;
      final left = offset.dx.clamp(_margin, maxLeft).toDouble();
      final top = offset.dy.clamp(minTop, maxTop).toDouble();
      _layoutOffset = Offset(left, top);

      return Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            child: _buildCard(context, ctrl, videoController, size),
          ),
        ],
      );
    });
  }

  Widget _buildCard(
    BuildContext context,
    PlPlayerController ctrl,
    VideoController videoController,
    Size size,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: MiniPlayerService.instance.expand,
      onPanUpdate: (details) {
        setState(() {
          _offset = _layoutOffset + details.delta;
        });
      },
      onPanEnd: (_) {
        // 松手后吸附到左右两侧
        final screen = MediaQuery.of(context).size;
        final width = size.width;
        setState(() {
          final offset = _offset;
          if (offset == null) {
            return;
          }
          final isLeft = offset.dx + width / 2 < screen.width / 2;
          _offset = Offset(
            isLeft ? _margin : screen.width - width - _margin,
            offset.dy,
          );
        });
      },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          color: Colors.black,
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SimpleVideo(
                controller: videoController,
                fill: Colors.black,
                aspectRatio: null,
              ),
              // 顶部信息栏
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopBar(context, ctrl),
              ),
              // 播放/暂停
              Center(
                child: _MiniPlayerButton(
                  size: 40,
                  onTap: () {
                    if (ctrl.playerStatus.isPlaying) {
                      ctrl.pause();
                    } else {
                      ctrl.play();
                    }
                  },
                  child: Obx(
                    () => Icon(
                      ctrl.playerStatus.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // 进度条
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Obx(() {
                  final duration = ctrl.duration.value;
                  final position = ctrl.position.value;
                  return LinearProgressIndicator(
                    minHeight: 2,
                    value: duration > 0 ? position / duration : 0,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, PlPlayerController ctrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x99000000), Color(0x00000000)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => Text(
                MiniPlayerService.instance.info.value?.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          _MiniPlayerButton(
            size: 24,
            onTap: MiniPlayerService.instance.release,
            child: const Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _MiniPlayerButton extends StatelessWidget {
  const _MiniPlayerButton({
    required this.child,
    required this.onTap,
    required this.size,
  });

  final Widget child;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0x66000000),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
