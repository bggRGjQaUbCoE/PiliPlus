import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/subtitle_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubtitleOverlay extends StatelessWidget {
  final Rx<SubtitleLine?> subtitle;
  final PlPlayerController plPlayerController;
  final VideoDetailController? videoDetailController;

  const SubtitleOverlay({
    super.key,
    required this.subtitle,
    required this.plPlayerController,
    this.videoDetailController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final line = subtitle.value;
      if (line == null) return const SizedBox.shrink();
      
      final subTitleStyle = plPlayerController.subTitleStyle;
      final scale = videoDetailController?.subtitleFontScaleSecondary.value ?? 1.5;
      
      // Secondary subtitle style: scaled based on primary
      final secondaryStyle = subTitleStyle.copyWith(
         fontSize: subTitleStyle.fontSize! * scale, 
         color: Colors.white,
      );

      // Check FullScreen
      final isFS = plPlayerController.isFullScreen.value;
      final paddingB = plPlayerController.subtitlePaddingB;
      // Primary is usually at bottom with margin. We stack this above it.
      
      return Positioned(
        left: 20,
        right: 20,
        bottom: paddingB + (isFS ? 60 : 40), // Offset above primary subtitle
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            line.text,
            textAlign: TextAlign.center,
            style: secondaryStyle,
            // Outline/Stroke logic similar to primary if needed, 
            // but for now simple text with shadow/outline
          ),
        ),
      );
    });
  }
}
