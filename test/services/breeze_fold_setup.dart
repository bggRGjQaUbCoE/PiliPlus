import 'dart:io';

import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/services/breeze/breeze_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

// Shared setup for BreezeFold widget tests. Keep one testWidgets per file:
// Hive writes started in a test's fake async zone can stay pending after it
// ends and block BreezeService's serialized writes in the next test.

const breezeTestRaw = BreezeRaw(
  kind: BreezeKind.dynamic,
  text: '新品上市，戳链接购买',
  author: '测试UP',
  authorId: '123',
  itemId: '1',
);

/// Opens temporary boxes, saves an API key and caches an ad result for
/// [breezeTestRaw], so no request is sent.
void setUpBreezeFold() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('piliplus-breeze-test-');
    Hive.init(tempDir.path);
    GStorage.setting = await Hive.openBox('setting');
    await BreezeService.init();
    await BreezeService.saveApi(
      apiKey: 'test',
      provider: BreezeProvider.jev,
      apiUrl: '',
      apiModel: '',
      apiProtocol: BreezeProtocol.openai,
    );
    await Hive.box('breezeCache').put(
      breezeCacheKey(sanitize(breezeTestRaw), BreezeService.config),
      {
        'result': BreezeResult(
          prob: .9,
          categories: ['ad'],
          kind: 'ad',
        ).toJson(),
        'expires': DateTime.now()
            .add(const Duration(days: 1))
            .millisecondsSinceEpoch,
      },
    );
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });
}

/// Hive writes need real IO, then the fake zone must run their callbacks.
Future<void> settleBreeze(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
  }
  // Let the last write reach the disk before the fake zone ends.
  await tester.runAsync(() => Hive.box('breezeHistory').flush());
  await tester.pumpAndSettle();
}
