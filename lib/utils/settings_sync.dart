import 'dart:convert';

import 'package:hive_ce/hive.dart';

/// 负责设置 Box 的序列化与恢复，不依赖任何平台或 UI 实现。
abstract final class SettingsSync {
  static const _jsonEncoder = JsonEncoder.withIndent('    ');

  /// 导出设置与视频配置，字段结构保持现有 WebDAV 载荷不变。
  static String export(Box<dynamic> setting, Box<dynamic> video) {
    return _jsonEncoder.convert({
      setting.name: setting.toMap(),
      video.name: video.toMap(),
    });
  }

  /// 从 JSON 字符串恢复设置；解析成功后沿用原有的整 Box 替换规则。
  static Future<List<void>> import(
    String data,
    Box<dynamic> setting,
    Box<dynamic> video,
  ) {
    return importMap(jsonDecode(data), setting, video);
  }

  /// 用同一份快照分别替换设置与视频 Box，避免新旧配置混合。
  static Future<List<void>> importMap(
    Map<String, dynamic> map,
    Box<dynamic> setting,
    Box<dynamic> video,
  ) {
    return Future.wait([
      setting.clear().then((_) => setting.putAll(map[setting.name])),
      video.clear().then((_) => video.putAll(map[video.name])),
    ]);
  }
}
