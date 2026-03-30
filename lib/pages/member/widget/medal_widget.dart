import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

const _kFontSize = 10.0;
const _kStrutStyle = StrutStyle(height: 1, leading: 0, fontSize: _kFontSize);
const _kPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);

class MedalWidget extends StatelessWidget {
  const MedalWidget({
    super.key,
    required this.medalName,
    required this.level,
    required this.backgroundColor,
    required this.nameColor,
    this.fontSize = _kFontSize,
    this.strutStyle = _kStrutStyle,
    this.padding = _kPadding,
  });

  MedalWidget.fromMedalInfo({
    super.key,
    required UinfoMedal medal,
    this.fontSize = _kFontSize,
    this.strutStyle = _kStrutStyle,
    this.padding = _kPadding,
  }) : medalName = medal.name!,
       level = medal.level!,
       backgroundColor = Utils.parseMedalColor(medal.v2MedalColorStart!),
       nameColor = Utils.parseColor(medal.v2MedalColorText!);

  final String medalName;
  final int level;
  final Color backgroundColor;
  final Color nameColor;
  final double fontSize;
  final StrutStyle strutStyle;
  final EdgeInsets padding;

  static const mediumPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: Style.mdRadius,
        color: backgroundColor,
      ),
      child: Text.rich(
        strutStyle: strutStyle,
        TextSpan(
          children: [
            TextSpan(
              text: medalName,
              style: TextStyle(
                height: 1,
                fontSize: fontSize,
                color: nameColor,
              ),
            ),
            TextSpan(
              text: ' $level',
              style: TextStyle(
                height: 1,
                fontSize: fontSize,
                color: nameColor,
                fontWeight: .bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
