import 'dart:io';

import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory testDir;

  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp(
      'piliplus_storage_import_test_',
    );
    appSupportDirPath = testDir.path;
    await GStorage.init();
  });

  setUp(() async {
    await Future.wait([GStorage.setting.clear(), GStorage.video.clear()]);
    await GStorage.setting.putAll({'theme': 'old', 'settingOnly': true});
    await GStorage.video.putAll({'quality': 80, 'videoOnly': true});
  });

  tearDownAll(() async {
    await GStorage.close();
    await testDir.delete(recursive: true);
  });

  test('rejects a missing section before changing existing settings', () async {
    await expectLater(
      GStorage.importAllJsonSettings({
        GStorage.setting.name: {'theme': 'new'},
      }),
      throwsA(isA<FormatException>()),
    );

    expect(GStorage.setting.toMap(), {'theme': 'old', 'settingOnly': true});
    expect(GStorage.video.toMap(), {'quality': 80, 'videoOnly': true});
  });

  test('rolls both boxes back if writing imported values fails', () async {
    await expectLater(
      GStorage.importAllJsonSettings({
        GStorage.setting.name: {'theme': Object()},
        GStorage.video.name: {'quality': 120},
      }),
      throwsA(anything),
    );

    expect(GStorage.setting.toMap(), {'theme': 'old', 'settingOnly': true});
    expect(GStorage.video.toMap(), {'quality': 80, 'videoOnly': true});
  });

  test('valid import replaces both settings sections', () async {
    await GStorage.importAllJsonSettings({
      GStorage.setting.name: {'theme': 'new'},
      GStorage.video.name: {'quality': 120},
    });

    expect(GStorage.setting.toMap(), {'theme': 'new'});
    expect(GStorage.video.toMap(), {'quality': 120});
  });
}
