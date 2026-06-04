import 'dart:io';

import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  setUpAll(() async {
    try {
      final dir = Directory.systemTemp.createTempSync('hive_test_');
      Hive.init(dir.path);
      GStorage.setting = await Hive.openBox('setting');
    } catch (_) {
      // Already initialized by another test file in the same isolate.
    }
  });

  test(
    'legacy shielding entries are removed from old settings source files',
    () {
      final recommendSettingsSource = File(
        'lib/pages/setting/models/recommend_settings.dart',
      ).readAsStringSync();
      final extraSettingsSource = File(
        'lib/pages/setting/models/extra_settings.dart',
      ).readAsStringSync();

      expect(recommendSettingsSource, isNot(contains("title: '标题关键词过滤'")));
      expect(
        recommendSettingsSource,
        isNot(contains("title: 'App推荐/热门/排行榜: 视频分区关键词过滤'")),
      );
      expect(extraSettingsSource, isNot(contains("title: '评论关键词过滤'")));
    },
  );
}
