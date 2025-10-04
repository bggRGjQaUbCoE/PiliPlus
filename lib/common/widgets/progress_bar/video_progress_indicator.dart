import 'package:PiliPlus/common/constants.dart';
import 'package:flutter/material.dart';

Widget videoProgressIndicator(double progress) => ClipRect(
  clipper: ProgressClipper(),
  child: ClipRRect(
    borderRadius: const BorderRadius.vertical(bottom: StyleString.imgRadius),
    child: ProgressIndicatorTheme(
      data: const ProgressIndicatorThemeData(),
      child: LinearProgressIndicator(
        minHeight: 10,
        value: progress,
        stopIndicatorColor: Colors.transparent,
      ),
    ),
  ),
);

class ProgressClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 7.75, size.width, size.height - 7.75);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
