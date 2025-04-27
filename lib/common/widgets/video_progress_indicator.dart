import 'package:PiliPlus/common/constants.dart';
import 'package:flutter/material.dart';

Widget videoProgressIndicator(double progress) => ClipRect(
      clipper: ProgressClipper(),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: StyleString.imgRadius,
          bottomRight: StyleString.imgRadius,
        ),
        child: LinearProgressIndicator(
          minHeight: 10,
          value: progress,
        ),
      ),
    );

class ProgressClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 6, size.width, size.height - 6);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
