import 'package:PiliPlus/utils/desktop/window_bounds.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart' show Offset, Rect, Size;
import 'package:nativeapi/nativeapi.dart' as nativeapi;
import 'package:screen_retriever/screen_retriever.dart';

const _displayManager = nativeapi.DisplayManager.instance;

nativeapi.Rectangle calcWindowBounds() {
  final workArea = _currentWorkArea;
  final windowSize = workArea == null
      ? Pref.windowSize
      : fitWindowSizeToWorkArea(Pref.windowSize, workArea);
  final offset = workArea == null
      ? Offset.zero
      : calcWindowOffset(
          windowSize: windowSize,
          workArea: workArea,
          savedPosition: _savedWindowPosition,
        );
  return nativeapi.Rectangle(
    x: offset.dx,
    y: offset.dy,
    width: windowSize.width,
    height: windowSize.height,
  );
}

/// 最小窗口尺寸：默认取 [DeviceUtils.desktopMinSize]，但不得超过当前工作区。
///
/// 小屏（例如 1024×640 的平板，或高分屏开启整数缩放）上，720 的最小高度
/// 比屏幕还高，窗口无法收缩到屏幕内，标题栏和底栏会一直被裁掉。
nativeapi.Size calcWindowMinSize() {
  const base = DeviceUtils.desktopMinSize;
  final workArea = _currentWorkArea;
  if (workArea == null) return base;
  final size = fitMinSizeToWorkArea(
    Size(base.width, base.height),
    workArea,
  );
  return nativeapi.Size(width: size.width, height: size.height);
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
