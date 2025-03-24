import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

abstract class _StatItemBase extends StatelessWidget {
  final BuildContext context;
  final Object value;
  final String? theme;
  final String? size;
  final Color? textColor;
  final double iconSize;

  const _StatItemBase({
    required this.context,
    required this.value,
    this.theme,
    this.size,
    this.textColor,
    this.iconSize = 13,
  });

  IconData get iconData;
  String get semanticsLabel;

  Color get color {
    return textColor ??
        switch (theme) {
          'gray' => Theme.of(context).colorScheme.outline.withOpacity(0.8),
          'black' => Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          _ => Colors.white,
        };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: iconSize,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          Utils.numFormat(value),
          style: TextStyle(
            fontSize: size == 'medium' ? 12 : 11,
            color: color,
          ),
          overflow: TextOverflow.clip,
          semanticsLabel: semanticsLabel,
        ),
      ],
    );
  }
}

class StatView extends _StatItemBase {
  final String? goto;

  const StatView({
    required super.context,
    required super.value,
    this.goto,
    super.theme,
    super.size,
    super.textColor,
  }) : super(iconSize: 13);

  @override
  IconData get iconData => goto == 'picture'
      ? Icons.remove_red_eye_outlined
      : Icons.play_circle_outlined;

  @override
  String get semanticsLabel =>
      '${Utils.numFormat(value)}次${goto == "picture" ? "浏览" : "播放"}';
}

class StatDanMu extends _StatItemBase {
  const StatDanMu({
    required super.context,
    required super.value,
    super.theme,
    super.size,
    super.textColor,
  }) : super(iconSize: 14);

  @override
  IconData get iconData => Icons.subtitles_outlined;

  @override
  String get semanticsLabel => '${Utils.numFormat(value)}条弹幕';
}
