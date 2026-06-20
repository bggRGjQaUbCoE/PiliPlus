import 'dart:io' show Platform;

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';

const _clampingPhysics = ClampingScrollPhysics();
const _bouncingPhysics = BouncingScrollPhysics();
const _bouncingDesktopPhysics = BouncingScrollPhysics(decelerationRate: .fast);

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (Platform.isAndroid) {
      return StretchingOverscrollIndicator(
        axisDirection: details.direction,
        clipBehavior: details.decorationClipBehavior ?? .hardEdge,
        child: child,
      );
    }
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    if (Platform.isIOS) {
      return _bouncingPhysics;
    }
    if (Platform.isMacOS) {
      return _bouncingDesktopPhysics;
    }
    return _clampingPhysics;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => desktopDragDevices;
}

const Set<PointerDeviceKind> desktopDragDevices = {
  .touch,
  .stylus,
  .invertedStylus,
  .trackpad,
  .unknown,
  .mouse,
};
