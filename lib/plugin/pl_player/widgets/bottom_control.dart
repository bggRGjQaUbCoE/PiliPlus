import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/view.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomControl extends StatelessWidget {
  const BottomControl({
    super.key,
    required this.maxWidth,
    required this.isFullScreen,
    required this.controller,
    required this.buildBottomControl,
    required this.videoDetailController,
  });

  final double maxWidth;
  final bool isFullScreen;
  final PlPlayerController controller;
  final ValueGetter<Widget> buildBottomControl;
  final VideoDetailController videoDetailController;

  void onDragStart(ThumbDragDetails duration) {
    feedBack();
    controller.onChangedSliderStart(duration.timeStamp);
  }

  void onDragUpdate(ThumbDragDetails duration) {
    if (!controller.isFileSource && controller.showSeekPreview) {
      controller.updatePreviewIndex(duration.timeStamp.inSeconds);
    }
    controller.onUpdatedSliderProgress(duration.timeStamp);
  }

  void onSeek(Duration duration) {
    if (controller.showSeekPreview) {
      controller.showPreview.value = false;
    }
    controller
      ..onChangedSliderEnd()
      ..onChangedSlider(duration.inSeconds)
      ..seekTo(Duration(seconds: duration.inSeconds), isSeek: false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final primary = colorScheme.isLight
        ? colorScheme.inversePrimary
        : colorScheme.primary;
    final thumbGlowColor = primary.withAlpha(80);
    final bufferedBarColor = primary.withValues(alpha: 0.4);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
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
                    Obx(() {
                      final int value = controller.sliderPositionSeconds.value;
                      final int max = controller.duration.value.inSeconds;
                      return ProgressBar(
                        progress: Duration(seconds: value),
                        buffered: Duration(
                          seconds: controller.bufferedSeconds.value,
                        ),
                        total: Duration(seconds: max),
                        progressBarColor: primary,
                        baseBarColor: const Color(0x33FFFFFF),
                        bufferedBarColor: bufferedBarColor,
                        thumbColor: primary,
                        thumbGlowColor: thumbGlowColor,
                        barHeight: 3.5,
                        thumbRadius: 7,
                        thumbGlowRadius: 25,
                        onDragStart: onDragStart,
                        onDragUpdate: onDragUpdate,
                        onSeek: onSeek,
                      );
                    }),
                    if (controller.enableBlock &&
                        videoDetailController.segmentProgressList.isNotEmpty)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 5.25,
                        child: SegmentProgressBar(
                          segments: videoDetailController.segmentProgressList,
                        ),
                      ),
                    if (controller.showViewPoints &&
                        videoDetailController.viewPointList.isNotEmpty &&
                        videoDetailController.showVP.value)
                      Padding(
                        padding: const .only(bottom: 8.75),
                        child: ViewPointSegmentProgressBar(
                          segments: videoDetailController.viewPointList,
                          onSeek: PlatformUtils.isDesktop
                              ? (position) =>
                                    controller.seekTo(position, isSeek: false)
                              : null,
                        ),
                      ),
                    if (videoDetailController.showDmTrendChart.value)
                      if (videoDetailController.dmTrend.value?.dataOrNull
                          case final list?)
                        buildDmChart(primary, list, videoDetailController, 4.5),
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
