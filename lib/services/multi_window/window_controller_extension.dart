import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

/// WindowController 扩展，用于窗口间通信
extension WindowControllerExtension on WindowController {
  /// 初始化窗口方法处理器
  Future<void> doCustomInitialize() async {
    return await setWindowMethodHandler((call) async {
      switch (call.method) {
        case 'window_center':
          return await windowManager.center();
        case 'window_close':
          return await windowManager.close();
        case 'window_show':
          return await windowManager.show();
        case 'window_focus':
          return await windowManager.focus();
        case 'window_hide':
          return await windowManager.hide();
        case 'window_minimize':
          return await windowManager.minimize();
        case 'window_maximize':
          return await windowManager.maximize();
        case 'window_restore':
          return await windowManager.restore();
        default:
          throw MissingPluginException(
            'Not implemented method: ${call.method}',
          );
      }
    });
  }

  /// 让目标窗口居中
  Future<void> center() {
    return invokeMethod('window_center');
  }

  /// 关闭目标窗口
  Future<void> close() {
    return invokeMethod('window_close');
  }

  /// 显示目标窗口
  Future<void> show() {
    return invokeMethod('window_show');
  }

  /// 聚焦目标窗口
  Future<void> focus() {
    return invokeMethod('window_focus');
  }

  /// 隐藏目标窗口
  Future<void> hide() {
    return invokeMethod('window_hide');
  }

  /// 最小化目标窗口
  Future<void> minimize() {
    return invokeMethod('window_minimize');
  }

  /// 最大化目标窗口
  Future<void> maximize() {
    return invokeMethod('window_maximize');
  }

  /// 恢复目标窗口
  Future<void> restore() {
    return invokeMethod('window_restore');
  }
}
