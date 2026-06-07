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
    GStorage.setting.delete(SettingBoxKey.tagEnrichCacheMaxMb);
  });

  group('recommendSettings', () {
    test('contains entries for tag enrichment', () {
      final list = recommendSettings;

      final titles = list.map((e) => e.effectiveTitle).toList();
      expect(titles, contains('标签获取并发数'));
      expect(titles, contains('标签获取超时'));
      expect(titles, contains('标签缓存上限'));
      expect(titles, contains('标签缓存状态'));
      expect(titles, isNot(contains('标签获取并发数（调试）')));
      expect(titles, isNot(contains('标签获取超时（调试）')));
      expect(titles, isNot(contains('标签缓存（调试）')));
    });

    test('tag enrichment entries appear after filter settings', () {
      final list = recommendSettings;

      final filterIdx = list.indexWhere(
        (e) => e.effectiveTitle == '过滤器也应用于相关视频',
      );
      expect(filterIdx, isNot(-1));

      final tagIdx1 = list.indexWhere(
        (e) => e.effectiveTitle == '标签获取并发数',
      );
      expect(tagIdx1, greaterThan(filterIdx));
    });

    test('concurrency entry shows default value of 5', () {
      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取并发数',
      );
      expect(entry.effectiveSubtitle, contains('当前: 5'));
      expect(entry.effectiveSubtitle, contains('默认5'));
      expect(entry.effectiveSubtitle, contains('范围1–10'));
    });

    test('timeout entry shows default value of 3s', () {
      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取超时',
      );
      expect(entry.effectiveSubtitle, contains('当前: 3s'));
      expect(entry.effectiveSubtitle, contains('默认3s'));
      expect(entry.effectiveSubtitle, contains('范围1–10'));
    });

    test('cache limit entry shows default value of 10MB', () {
      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签缓存上限',
      );
      expect(entry.effectiveSubtitle, contains('当前: 10MB'));
      expect(entry.effectiveSubtitle, contains('默认10MB'));
      expect(entry.effectiveSubtitle, contains('范围1–50'));
    });

    test('cache status entry shows estimated size and count', () {
      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签缓存状态',
      );
      expect(entry.effectiveSubtitle, contains('/ 10 MB'));
      expect(entry.effectiveSubtitle, isNot(contains('/ 200')));
      expect(entry.effectiveSubtitle, contains('点击可清空缓存'));
    });

    test('concurrency entry reflects stored setting', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichConcurrency, 7);

      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取并发数',
      );
      expect(entry.effectiveSubtitle, contains('当前: 7'));
    });

    test('timeout entry reflects stored setting', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichTimeout, 5);

      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签获取超时',
      );
      expect(entry.effectiveSubtitle, contains('当前: 5s'));
    });

    test('cache status reflects stored max size setting', () {
      GStorage.setting.put(SettingBoxKey.tagEnrichCacheMaxMb, 25);

      final list = recommendSettings;
      final entry = list.firstWhere(
        (e) => e.effectiveTitle == '标签缓存状态',
      );
      expect(entry.effectiveSubtitle, contains('/ 25 MB'));
    });

    test('total settings count includes tag enrichment entries', () {
      final list = recommendSettings;
      expect(list.length, 12);
    });
  });
}
