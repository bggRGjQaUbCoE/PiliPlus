import 'dart:io';

import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

class _TickerController extends GetxController implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class _TripleController extends _TickerController with TripleMixin {
  int likeCount = 0;
  int tripleCount = 0;

  @override
  int get copyright => 1;

  @override
  bool get isLogin => true;

  @override
  void actionLikeVideo() => likeCount++;

  @override
  void actionTriple() => tripleCount++;

  @override
  void onPayCoin(int coin, bool coinWithLike) {}
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('piliplus-triple-test-');
    Hive.init(tempDir.path);
    GStorage.setting = await Hive.openBox('setting');
  });

  setUp(() => GStorage.setting.clear());

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('triple remains enabled by default', (tester) async {
    final controller = _TripleController();
    expect(Pref.disableTriple, isFalse);

    controller.onStartTriple();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));

    expect(controller.tripleCount, 1);
    expect(controller.likeCount, 0);
    controller.onClose();
  });

  group('when triple is disabled', () {
    setUp(() async {
      await GStorage.setting.put(SettingBoxKey.disableTriple, true);
    });

    testWidgets('a short press remains a normal like', (tester) async {
      expect(Pref.disableTriple, isTrue);
      final controller = _TripleController()..onStartTriple();
      await tester.pump(const Duration(milliseconds: 100));
      controller.onCancelTriple(true);

      expect(controller.tripleCount, 0);
      expect(controller.likeCount, 1);
      controller.onClose();
    });

    testWidgets('a long press reports that triple is disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: FlutterSmartDialog.init(),
          home: const Scaffold(body: SizedBox.expand()),
        ),
      );
      final controller = _TripleController()..onStartTriple();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      expect(find.text('已禁用'), findsOneWidget);
      controller.onCancelTriple(true);

      expect(controller.tripleCount, 0);
      expect(controller.likeCount, 0);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox.shrink());
      controller.onClose();
    });

    testWidgets('a cancelled press does nothing', (tester) async {
      final controller = _TripleController()..onStartTriple();
      await tester.pump(const Duration(milliseconds: 100));
      controller.onCancelTriple();

      expect(controller.tripleCount, 0);
      expect(controller.likeCount, 0);
      controller.onClose();
    });
  });
}
