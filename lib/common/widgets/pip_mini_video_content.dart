import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/services/pip_transition_coordinator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// 轻量小窗内容:视频纹理 + 弹幕(仅活跃态) + 缓冲指示。
///
/// 小窗副本不再复用完整 PLVideoPlayer——小窗与页面副本彻底解耦(无共享
/// GlobalKey 土壤),且过渡动画逐帧改布局时只有纹理参与重排。
/// 字幕/控制层不属于小窗内容(与 B 站官方及 pili++ 行为一致)。
class PipMiniVideoContent extends StatelessWidget {
  const PipMiniVideoContent({
    super.key,
    required this.plPlayerController,
    required this.transition,
    this.danmuWidget,
  });

  final PlPlayerController plPlayerController;
  final PipTransitionCoordinator transition;

  /// 由调用方构建(视频小窗传 PlDanmaku,直播小窗不传);
  /// 过渡期间窗口逐帧变尺寸,弹幕仅在活跃态挂载,避免布局翻炒
  final Widget? danmuWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Colors.black,
          child: Obx(() {
            final videoController = plPlayerController.videoController;
            if (videoController == null) {
              return const SizedBox.shrink();
            }
            final videoFit = plPlayerController.videoFit.value;
            return Transform.flip(
              flipX: plPlayerController.flipX.value,
              flipY: plPlayerController.flipY.value,
              child: FittedBox(
                fit: videoFit.boxFit,
                clipBehavior: Clip.hardEdge,
                child: SimpleVideo(
                  controller: videoController,
                  aspectRatio: videoFit.aspectRatio,
                ),
              ),
            );
          }),
        ),
        if (danmuWidget != null)
          ListenableBuilder(
            listenable: transition,
            builder: (_, _) => transition.phase == PipPhase.active
                ? IgnorePointer(child: danmuWidget)
                : const SizedBox.shrink(),
          ),
        Obx(
          () => plPlayerController.isBuffering.value
              ? const Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white70,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
