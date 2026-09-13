import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/models/common/dynamic/dynamic_up_list_mode.dart';
import 'package:PiliPlus/utils/settings_sync.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

/// 验证新模式沿用现有设置导出/导入链路，而设备阅读状态不会混入同步数据。
void main() {
  late Directory tempDir;
  late Box<dynamic> settingBox;
  late Box<dynamic> videoBox;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'piliplus-dynamic-setting-test-',
    );
    Hive.init(tempDir.path);
    settingBox = await Hive.openBox<dynamic>('setting');
    videoBox = await Hive.openBox<dynamic>('video');
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('动态 UP 模式随 WebDAV 设置载荷同步', () async {
    await settingBox.put(
      SettingBoxKey.dynamicUpListMode,
      DynamicUpListMode.video.index,
    );

    final payload = SettingsSync.export(settingBox, videoBox);
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final setting = json['setting'] as Map<String, dynamic>;
    expect(
      setting[SettingBoxKey.dynamicUpListMode],
      DynamicUpListMode.video.index,
    );
    expect(payload, isNot(contains(LocalCacheKey.dynamicUpUnread)));

    await settingBox.clear();
    await SettingsSync.import(payload, settingBox, videoBox);
    expect(
      settingBox.get(SettingBoxKey.dynamicUpListMode),
      DynamicUpListMode.video.index,
    );
  });
}
