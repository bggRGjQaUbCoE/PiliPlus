import 'dart:io' show Platform;

import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:material_ui/material_ui.dart';

const Set<PointerDeviceKind> desktopDragDevices = {
  .touch,
  .mouse,
  .trackpad,
  .stylus,
  .invertedStylus,
  .unknown,
};

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  // P0-1 桌面滚动条：极简「常显细条」。
  // 仅竖向（横向列表不加，避免视频卡/标签横向列表出现大量滚动条）；
  // 仅宽屏桌面（沿用项目统一 breakpoint：context.showNavbar = width > 800）；
  // 常显细条、无轨道、hover 不变粗；不占布局宽度（绘制在内容之上）。
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final isVertical =
        details.direction == AxisDirection.down ||
        details.direction == AxisDirection.up;
    if (!isVertical) return child;
    if (!context.showNavbar) return child;
    final controller = details.controller;
    if (controller == null) return child;
    // 右侧「专用车道」：为滚动条预留固定宽度（10 逻辑 px），滚动条画在车道内，
    // 不覆盖内容、也不改变内容自身排版（仅视口整体让出这条带）。
    const laneWidth = 10.0;
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbVisibility: const WidgetStatePropertyAll(true),
        trackVisibility: const WidgetStatePropertyAll(false),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(3),
        crossAxisMargin: 2,
        thumbColor: WidgetStatePropertyAll(
          ColorScheme.of(context).outline.withValues(alpha: .55),
        ),
      ),
      child: Scrollbar(
        controller: controller,
        child: Padding(
          padding: const EdgeInsets.only(right: laneWidth),
          child: child,
        ),
      ),
    );
  }

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
  Set<PointerDeviceKind> get dragDevices => desktopDragDevices;
}

class NoOverscrollIndicator extends CustomScrollBehavior {
  const NoOverscrollIndicator();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
