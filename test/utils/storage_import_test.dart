import 'dart:io';

import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('piliplus-storage-test-');
    Hive.init(tempDir.path);
    GStorage.setting = await Hive.openBox<dynamic>('setting');
    GStorage.video = await Hive.openBox<dynamic>('video');
  });

  setUp(() async {
    await GStorage.setting.clear();
    await GStorage.video.clear();
    await GStorage.setting.putAll({'theme': 'dark', 'obsolete': true});
    await GStorage.video.putAll({'speed': 2.0});
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('validates every section before clearing existing settings', () async {
    await expectLater(
      GStorage.importAllJsonSettings({
        'setting': {'theme': 'light'},
        'video': <Object?>[],
      }),
      throwsA(isA<FormatException>()),
    );

    expect(GStorage.setting.toMap(), {'theme': 'dark', 'obsolete': true});
    expect(GStorage.video.toMap(), {'speed': 2.0});
  });

  test('restores both snapshots when a box replacement fails', () async {
    await expectLater(
      GStorage.importAllJsonSettings({
        'setting': {'theme': 'light'},
        'video': {'invalid': Object()},
      }),
      throwsA(anything),
    );

    expect(GStorage.setting.toMap(), {'theme': 'dark', 'obsolete': true});
    expect(GStorage.video.toMap(), {'speed': 2.0});
  });

  test('replaces both settings sections after validation', () async {
    await GStorage.importAllJsonSettings({
      'setting': {'theme': 'light'},
      'video': {'speed': 1.5, 'quality': 80},
    });

    expect(GStorage.setting.toMap(), {'theme': 'light'});
    expect(GStorage.video.toMap(), {'speed': 1.5, 'quality': 80});
  });
}
