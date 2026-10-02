import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/view/view.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class BottomControl extends StatelessWidget {
  const BottomControl({
    super.key,
    required this.maxWidth,
    required this.isFullScreen,
    required this.controller,
    required this.buildBottomControl,
    required this.videoDetailController,
    this.isPipMode = false,
  });

  final double maxWidth;
  final bool isFullScreen;
  final PlPlayerController controller;
  final ValueGetter<Widget> buildBottomControl;
  final VideoDetailController videoDetailController;
  final bool isPipMode;

  void onDragStart(ThumbDragDetails duration) {
    feedBack();
    controller
      ..onDesktopProgressDragStart(duration.timeStamp)
      ..onSeekStart(duration.seconds);
  }

  void onDragUpdate(ThumbDragDetails duration) {
    controller.updateDesktopProgressPreviewFromDrag(duration.timeStamp);
    if (!controller.isFileSource && controller.showSeekPreview) {
      controller.updatePreviewIndex(duration.seconds);
    }
    controller.seekPosition.value = duration.seconds;
  }

  void onSeek(int milliseconds) {
    controller
      ..position.value = milliseconds ~/ 1000
      ..onSeekEnd()
      ..seekTo(Duration(milliseconds: milliseconds), isSeek: false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final isDesktop = PlatformUtils.isDesktop;
    final primary = colorScheme.isLight
        ? colorScheme.inversePrimary
        : colorScheme.primary;
    final thumbGlowColor = primary.withAlpha(80);
    final bufferedBarColor = primary.withValues(alpha: 0.4);

    return Padding(
      padding: const .symmetric(horizontal: 10, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 7),
            child: Obx(
              () => Offstage(
                offstage: !controller.showControls.value,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Obx(
                      () => ProgressBar(
                        progress: controller.progress,
                        buffered: controller.buffered.value,
                        total: controller.duration.value,
                        progressBarColor: primary,
                        baseBarColor: const Color(0x33FFFFFF),
                        bufferedBarColor: bufferedBarColor,
                        thumbColor: primary,
                        thumbGlowColor: thumbGlowColor,
                        barHeight: desktopProgressBarHeight,
                        thumbRadius: desktopProgressThumbRadius,
                        thumbGlowRadius: 25,
                        minHeight: isDesktop
                            ? desktopProgressInteractiveHeight
                            : null,
                        onDragStart: onDragStart,
                        onDragUpdate: onDragUpdate,
                        onSeek: onSeek,
                        onHoverStart: isDesktop
                            ? (details) =>
                                  controller.onDesktopProgressHoverStart(
                                    details.timeStamp,
                                  )
                            : null,
                        onHoverUpdate: isDesktop
                            ? (details) =>
                                  controller.onDesktopProgressHoverUpdate(
                                    details.timeStamp,
                                  )
                            : null,
                        onHoverEnd: isDesktop
                            ? controller.onDesktopProgressHoverEnd
                            : null,
                      ),
                    ),
                    if (controller.enableBlock &&
                        videoDetailController.segmentProgressList.isNotEmpty)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: isDesktop ? desktopProgressHoverPadding : 5.25,
                        child: SegmentProgressBar(
                          segments: videoDetailController.segmentProgressList,
                        ),
                      ),
                    if (!isPipMode &&
                        controller.showViewPoints &&
                        videoDetailController.viewPointList.isNotEmpty &&
                        !videoDetailController.showVP.value)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: isDesktop ? desktopProgressHoverPadding : 5.25,
                        child: ViewPointDividerBar(
                          segments: videoDetailController.viewPointList,
                          progress: controller.duration.value > 0
                              ? controller.position.value /
                                    controller.duration.value
                              : 0.0,
                        ),
                      ),
                      if (!isPipMode &&
                        controller.showViewPoints &&
                        videoDetailController.viewPointList.isNotEmpty &&
                        videoDetailController.showVP.value)
                      if (isDesktop)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: desktopProgressBarTopInset,
                          child: ViewPointSegmentProgressBar(
                            segments: videoDetailController.viewPointList,
                            onSeek: (position) =>
                                controller.seekTo(position, isSeek: false),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.75),
                          child: ViewPointSegmentProgressBar(
                            segments: videoDetailController.viewPointList,
                            onSeek: null,
                          ),
                        ),
                    if (!isPipMode &&
                        videoDetailController.showDmTrendChart.value)
                      if (videoDetailController.dmTrend.value?.dataOrNull
                          case final list?)
                        buildDmChart(
                          primary,
                          list,
                          videoDetailController,
                          isDesktop ? desktopProgressDmChartOffset : 4.5,
                          isDesktop,
                        ),
                    if (isDesktop)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Obx(() {
                            final hoverValue =
                                controller.showDesktopProgressFeedback.value
                                ? controller.desktopProgressHoverValue.value
                                : null;
                            return CustomPaint(
                              painter: _DesktopProgressHoverPainter(
                                hoverValue: hoverValue,
                                color: primary,
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          buildBottomControl(),
        ],
      ),
    );
  }
}

class _DesktopProgressHoverPainter extends CustomPainter {
  const _DesktopProgressHoverPainter({
    required this.hoverValue,
    required this.color,
  });

  final double? hoverValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final value = hoverValue;
    if (value == null) {
      return;
    }

    const capRadius = desktopProgressBarHeight / 2;
    final availableWidth = size.width - desktopProgressBarHeight;
    final centerY = size.height / 2;
    final hoverDx = value * availableWidth + capRadius;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const triangleHalfWidth = 4.5;
    const triangleHeight = 5.0;
    const gap = 4.0;

    canvas
      ..drawPath(
        Path()
          ..moveTo(
            hoverDx - triangleHalfWidth,
            centerY - gap - triangleHeight,
          )
          ..lineTo(
            hoverDx + triangleHalfWidth,
            centerY - gap - triangleHeight,
          )
          ..lineTo(hoverDx, centerY - gap)
          ..close(),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(
            hoverDx - triangleHalfWidth,
            centerY + gap + triangleHeight,
          )
          ..lineTo(
            hoverDx + triangleHalfWidth,
            centerY + gap + triangleHeight,
          )
          ..lineTo(hoverDx, centerY + gap)
          ..close(),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _DesktopProgressHoverPainter oldDelegate) {
    return oldDelegate.hoverValue != hoverValue ||
        oldDelegate.color != color;
  }
}
