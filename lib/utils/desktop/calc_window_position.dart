import 'package:PiliPlus/utils/desktop/window_bounds.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart' show Offset, Rect;
import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:screen_retriever/screen_retriever.dart';

const _kMinSize = nativeapi.Size(width: 400, height: 720);

const _displayManager = nativeapi.DisplayManager.instance;

(nativeapi.Size minSize, nativeapi.Rectangle bounds) calcWindowBounds() {
  final workArea = _currentWorkArea;

  final nativeapi.Size minSize;
  final nativeapi.Rectangle bounds;

  if (workArea == null) {
    minSize = _kMinSize;

    final windowSize = Pref.windowSize;
    bounds = nativeapi.Rectangle(
      x: 0,
      y: 0,
      width: windowSize.width,
      height: windowSize.height,
    );
  } else {
    minSize = fitMinSizeToWorkArea(_kMinSize, workArea);

    final windowSize = fitWindowSizeToWorkArea(Pref.windowSize, workArea);
    final offset = calcWindowOffset(
      windowSize: windowSize,
      workArea: workArea,
      savedPosition: _savedWindowPosition,
    );
    bounds = nativeapi.Rectangle(
      x: offset.dx,
      y: offset.dy,
      width: windowSize.width,
      height: windowSize.height,
    );
  }

  return (minSize, bounds);
}

Rect? get _currentWorkArea => _currentDisplay?.workArea.toRect();

Offset? get _savedWindowPosition {
  final position = Pref.windowPosition;
  if (position == null || position.length < 2) return null;
  return Offset(position[0], position[1]);
}

nativeapi.Display? get _currentDisplay {
  final displays = _displayManager.getAll();
  final cursorPosition = _displayManager.getCursorPosition().toOffset();
  return displays.firstWhereOrNull(
        (display) => (display.position.toOffset() & display.size.toSize())
            .contains(cursorPosition),
      ) ??
      _displayManager.getPrimary();
}
