import 'dart:io';

import 'package:PiliPlus/pages/setting/models/recommend_settings.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
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

  setUp(() {
    // Reset settings to defaults between tests.
    GStorage.setting.delete(SettingBoxKey.tagEnrichConcurrency);
    GStorage.setting.delete(SettingBoxKey.tagEnrichTimeout);
  });

  group('recommendSettings', () {
    test('contains debug entries for tag enrichment', () {
      final list = recommendSettings;

      // The debug entries should be present.
      final titles = list.map((e) => e.effectiveTitle).toList();
      expect(titles, contains('标签获取并发数（调试）'));
      expect(titles, contains('标签获取超时（调试）'));
      expect(titles, contains('标签缓存（调试）'));
    });

    test('debug entries appear after filter settings', () {
      final list = recommendSettings;

      // Find the index of the last non-debug setting.
      final filterIdx = list.indexWhere(
        (e) => e.effectiveTitle == '过滤器也应用于相关视频',
      );
      expect(filterIdx, isNot(-1));

      final debugIdx1 = list.indexWhere(
        (e) => e.effectiveTitle == '标签获取并发数（调试）',
      );
      expect(debugIdx1, greaterThan(filterIdx));
    });

    test('debug concurrency entry shows default value of 5', () {
      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取并发数（调试）',
      );
      expect(entry.effectiveSubtitle, contains('当前: 5'));
      expect(entry.effectiveSubtitle, contains('默认5'));
      expect(entry.effectiveSubtitle, contains('范围1–10'));
    });

    test('debug timeout entry shows default value of 3s', () {
      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取超时（调试）',
      );
      expect(entry.effectiveSubtitle, contains('当前: 3s'));
      expect(entry.effectiveSubtitle, contains('默认3s'));
      expect(entry.effectiveSubtitle, contains('范围1–10'));
    });

    test('debug cache entry shows cache count', () {
      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签缓存（调试）',
      );
      // Subtitle should mention the cache count and max.
      expect(entry.effectiveSubtitle, contains('/ 200'));
      expect(entry.effectiveSubtitle, contains('点击可清空缓存'));
    });

    test('debug concurrency entry reflects stored setting', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichConcurrency, 7);

      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取并发数（调试）',
      );
      expect(entry.effectiveSubtitle, contains('当前: 7'));
    });

    test('debug timeout entry reflects stored setting', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichTimeout, 5);

      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取超时（调试）',
      );
      expect(entry.effectiveSubtitle, contains('当前: 5s'));
    });

    test('total settings count includes debug entries', () {
      final list = recommendSettings;
      // Original: 8 items + 3 debug = 11 total
      expect(list.length, 11);
    });
  });
}
