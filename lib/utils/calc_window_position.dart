import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';

Future<Offset> calcWindowPosition(Size windowSize) async {
  final allDisplays = screenRetriever.getAllDisplays();
  final cursorScreenPoint = await screenRetriever.getCursorScreenPoint();

  final currentDisplay =
      (await allDisplays).firstWhereOrNull(
        (display) => (display.visiblePosition! & display.size).contains(
          cursorScreenPoint,
        ),
      ) ??
      await screenRetriever.getPrimaryDisplay();

  final double visibleWidth;
  final double visibleHeight;
  if (currentDisplay.visibleSize case final size?) {
    visibleWidth = size.width;
    visibleHeight = size.height;
  } else {
    visibleWidth = currentDisplay.size.width;
    visibleHeight = currentDisplay.size.height;
  }

  final double visibleStartX;
  final double visibleStartY;
  if (currentDisplay.visiblePosition case final offset?) {
    visibleStartX = offset.dx;
    visibleStartY = offset.dy;
  } else {
    visibleStartX = visibleStartY = 0;
  }

  final windowPosition = Pref.windowPosition;
  if (windowPosition != null) {
    try {
      final dx = windowPosition[0];
      final dy = windowPosition[1];
      if (dx >= visibleStartX &&
          dy >= visibleStartY &&
          dx < (visibleWidth - 30) &&
          dy < (visibleHeight - 30)) {
        return Offset(dx, dy);
      }
    } catch (_) {}
  }

  return Offset(
    visibleStartX + (visibleWidth / 2) - (windowSize.width / 2),
    visibleStartY + ((visibleHeight / 2) - (windowSize.height / 2)),
  );
}
