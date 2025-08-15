import 'dart:async';

import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/view.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class BottomControl extends StatelessWidget {
  const BottomControl({
    required this.controller,
    required this.buildBottomControl,
    super.key,
  });

  final PlPlayerController controller;
  final Widget Function() buildBottomControl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color colorTheme = theme.colorScheme.primary;
    //阅读器限制
    Timer? accessibilityDebounce;
    double lastAnnouncedValue = -1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 7),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                return Obx(
                  () => Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Obx(() {
                        final int value =
                            controller.sliderPositionSeconds.value;
                        final int max =
                            controller.durationSeconds.value.inSeconds;
                        final int buffer = controller.bufferedSeconds.value;
                        if (value > max || max <= 0) {
                          return const SizedBox.shrink();
                        }
                        return ProgressBar(
                          progress: Duration(seconds: value),
                          buffered: Duration(seconds: buffer),
                          total: Duration(seconds: max),
                          progressBarColor: colorTheme,
                          baseBarColor: Colors.white.withValues(alpha: 0.2),
                          bufferedBarColor: colorTheme.withValues(alpha: 0.4),
                          timeLabelLocation: TimeLabelLocation.none,
                          thumbColor: colorTheme,
                          barHeight: 3.5,
                          thumbRadius: 7,
                          onDragStart: (duration) {
                            feedBack();
                            controller.onChangedSliderStart(duration.timeStamp);
                          },
                          onDragUpdate: (duration) {
                            if (controller.showSeekPreview) {
                              controller.updatePreviewIndex(
                                duration.timeStamp.inSeconds,
                              );
                            }
                            double newProgress =
                                duration.timeStamp.inSeconds / max;
                            if ((newProgress - lastAnnouncedValue).abs() >
                                0.02) {
                              accessibilityDebounce?.cancel();
                              accessibilityDebounce = Timer(
                                const Duration(milliseconds: 200),
                                () {
                                  SemanticsService.announce(
                                    "${(newProgress * 100).round()}%",
                                    TextDirection.ltr,
                                  );
                                  lastAnnouncedValue = newProgress;
                                },
                              );
                            }
                            controller.onUpdatedSliderProgress(
                              duration.timeStamp,
                            );
                          },
                          onSeek: (duration) {
                            if (controller.showSeekPreview) {
                              controller.showPreview.value = false;
                            }
                            controller
                              ..onChangedSliderEnd()
                              ..onChangedSlider(duration.inSeconds.toDouble())
                              ..seekTo(
                                Duration(seconds: duration.inSeconds),
                                isSeek: false,
                              );
                            SemanticsService.announce(
                              "${(duration.inSeconds / max * 100).round()}%",
                              TextDirection.ltr,
                            );
                          },
                        );
                      }),
                      if (controller.segmentList.isNotEmpty)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 5.25,
                          child: IgnorePointer(
                            child: RepaintBoundary(
                              child: CustomPaint(
                                key: const Key('segmentList'),
                                size: const Size(double.infinity, 3.5),
                                painter: SegmentProgressBar(
                                  segmentColors: controller.segmentList,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (controller.viewPointList.isNotEmpty &&
                          controller.showVP.value) ...[
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 5.25,
                          child: IgnorePointer(
                            child: RepaintBoundary(
                              child: CustomPaint(
                                key: const Key('viewPointList'),
                                size: const Size(double.infinity, 3.5),
                                painter: SegmentProgressBar(
                                  segmentColors: controller.viewPointList,
                                ),
                              ),
                            ),
                          ),
                        ),
                        buildViewPointWidget(
                          controller,
                          8.75,
                          maxWidth,
                        ),
                      ],
                      if (controller.dmTrend.isNotEmpty &&
                          controller.showDmTreandChart.value)
                        buildDmChart(theme, controller, 4.5),
                    ],
                  ),
                );
              },
            ),
          ),
          buildBottomControl(),
        ],
      ),
    );
  }
}
