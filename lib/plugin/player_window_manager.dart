/*
 * @Author: tao
 * @LastEditors: tao
 */
import 'dart:convert';

import 'package:PiliPlus/services/multi_window/player_window_service.dart';
import 'package:PiliPlus/services/multi_window/window_arguments.dart';
import 'package:PiliPlus/services/multi_window/window_controller_extension.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

/// PlayerWindow 管理器（前端接口）
///
/// - `channelName`：多窗口间默认用于传递 `playVideo` / `openInMain` 等消息的通道名称。
class PlayerWindowManager {
  PlayerWindowManager._();

  static const String channelName = 'player_window_channel';

  static final PlayerWindowManager instance = PlayerWindowManager._();

  /// Known fields that should be extracted to top-level PlayerWindowArguments
  static const _knownFields = {
    'aid', 'bvid', 'cid', 'seasonId', 'epId', 'pgcType',
    'cover', 'title', 'progress', 'videoType', 'heroTag', 'pic',
    'settings', 'extraArguments', 'businessId',
  };

  /// 打开播放器窗口（接受 Map 或 PlayerWindowArguments）
  static Future<void> openPlayerWindow(dynamic arguments) async {
    if (arguments == null) return;

    // 如果已经是 PlayerWindowArguments 则直接使用，否则从 Map 转换
    PlayerWindowArguments args;
    if (arguments is PlayerWindowArguments) {
      args = arguments;
    } else if (arguments is String) {
      final parsed = jsonDecode(arguments) as Map<String, dynamic>;
      args = _parseMapToArgs(parsed);
    } else if (arguments is Map) {
      args = _parseMapToArgs(Map<String, dynamic>.from(arguments));
    } else {
      throw ArgumentError('Unsupported arguments type for openPlayerWindow');
    }

    return PlayerWindowService.instance.openPlayerWindow(args);
  }

  /// Parse a map to PlayerWindowArguments, collecting unknown fields into extraArguments
  static PlayerWindowArguments _parseMapToArgs(Map<String, dynamic> json) {
    // Collect unknown fields into extraArguments and serialize enums to strings
    dynamic _serializeValue(dynamic v) {
      if (v == null) return null;
      // Enum -> extract name from toString() (e.g., "SourceType.watchLater" -> "watchLater")
      if (v is Enum) {
        final str = v.toString();
        final dotIndex = str.lastIndexOf('.');
        return dotIndex >= 0 ? str.substring(dotIndex + 1) : str;
      }
      if (v is Map) {
        return Map<String, dynamic>.fromEntries(
          v.entries.map((e) => MapEntry(e.key.toString(), _serializeValue(e.value))),
        );
      }
      if (v is Iterable) return v.map(_serializeValue).toList();
      return v;
    }

    final extraArgs = <String, dynamic>{};
    for (final entry in json.entries) {
      if (!_knownFields.contains(entry.key)) {
        extraArgs[entry.key.toString()] = _serializeValue(entry.value);
      }
    }

    // If there's already an extraArguments field, merge it (serialized)
    final existingExtra = json['extraArguments'] as Map<String, dynamic>?;
    if (existingExtra != null) {
      extraArgs.addAll(Map<String, dynamic>.fromEntries(
        existingExtra.entries.map(
          (e) => MapEntry(e.key.toString(), _serializeValue(e.value)),
        ),
      ));
    }

    // Handle videoType being either a String or VideoType enum
    final rawVideoType = json['videoType'];
    String videoTypeStr;
    if (rawVideoType is String) {
      videoTypeStr = rawVideoType;
    } else if (rawVideoType != null) {
      videoTypeStr = rawVideoType.toString().split('.').last;
    } else {
      videoTypeStr = 'ugc';
    }

    return PlayerWindowArguments(
      aid: json['aid'] as int,
      bvid: json['bvid'] as String,
      cid: json['cid'] as int,
      seasonId: json['seasonId'] as int?,
      epId: json['epId'] as int?,
      pgcType: json['pgcType'] as int?,
      cover: (json['cover'] ?? json['pic']) as String?,
      title: json['title'] as String?,
      progress: json['progress'] as int?,
      videoType: videoTypeStr,
      extraArguments: extraArgs.isNotEmpty ? extraArgs : null,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  /// 在主窗口打开一个路由（播放器窗口向主窗口请求导航）
  Future<void> openInMainWindow(String route, dynamic arguments) async {
    try {
      final channel = WindowMethodChannel(channelName);
      await channel.invokeMethod('openInMain', {
        'route': route,
        'arguments': arguments,
      });
    } catch (_) {
      // 忽略错误，调用方可自行 fallback
    }
  }

  /// 关闭播放器窗口
  static Future<void> closePlayerWindow() async {
    return PlayerWindowService.instance.closePlayerWindow();
  }

  /// 查找播放器窗口
  static Future<WindowController?> findPlayerWindow() async {
    return PlayerWindowService.instance.findPlayerWindow();
  }

  /// 检查播放器窗口是否已打开
  static Future<bool> isPlayerWindowOpen() async {
    final controller = await findPlayerWindow();
    return controller != null;
  }

  /// 聚焦播放器窗口（如果存在）
  static Future<bool> focusPlayerWindow() async {
    final controller = await findPlayerWindow();
    if (controller != null) {
      await controller.show();
      await controller.focus();
      return true;
    }
    return false;
  }

  /// 检查当前设置是否启用播放器窗口
  static bool get usePlayerWindow => PlayerWindowService.usePlayerWindow;
}
