import 'package:PiliPlus/common/widgets/video_card/shield_quick_action.dart';
import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('VideoCardShieldQuickAction', () {
    test('offers uid as separate UP action', () {
      final options = VideoCardShieldQuickAction.upRuleOptions(
        upName: '测试UP',
        upUid: 12345,
      );

      expect(options, hasLength(1));
      expect(options.single.type, ShieldRuleType.uid);
      expect(options.single.pattern, '12345');
      expect(options.single.label, '屏蔽用户 UID: 12345');
    });

    test('uses inline UP block action when uid is missing', () {
      final options = VideoCardShieldQuickAction.upRuleOptions(
        upName: '测试UP',
      );

      expect(options, isEmpty);
    });

    testWidgets('recommendation dialog shows editable title and UP inputs', (
      tester,
    ) async {
      await _pumpLauncher(
        tester,
        onTap: (context) => VideoCardShieldQuickAction.showRecommendationDialog(
          context: context,
          title: '原始标题',
          upName: '测试UP',
          upUid: 12345,
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      expect(find.text('标题'), findsOneWidget);
      expect(find.text('UP'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.widgetWithText(TextField, '原始标题'), findsOneWidget);
      expect(find.widgetWithText(TextField, '测试UP'), findsOneWidget);
      expect(find.text('屏蔽'), findsNWidgets(2));
      expect(find.text('屏蔽用户 UID: 12345'), findsOneWidget);
      expect(find.text('屏蔽用户名关键词: 测试UP'), findsNothing);
    });

    testWidgets(
      'recommendation dialog shows cover preview with save and cancel below',
      (tester) async {
        await _pumpLauncher(
          tester,
          onTap: (context) =>
              VideoCardShieldQuickAction.showRecommendationDialog(
                context: context,
                title: '原始标题',
                cover: 'https://example.com/cover.jpg',
                bvid: 'BV1',
              ),
        );

        await tester.tap(find.text('打开'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final preview = find.byKey(const Key('recommendation-cover-preview'));
        final save = find.text('保存封面');
        final cancel = find.text('取消');

        expect(preview, findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(save, findsOneWidget);
        expect(cancel, findsOneWidget);
        expect(find.text('关闭'), findsNothing);

        expect(
          tester.getTopLeft(save).dy,
          greaterThan(tester.getBottomLeft(preview).dy - 48),
        );
        expect(
          tester.getTopLeft(cancel).dy,
          greaterThan(tester.getBottomLeft(preview).dy - 48),
        );
      },
    );

    testWidgets('edited UP text is used for username keyword rule', (
      tester,
    ) async {
      final store = ShieldSettingsStore(box: _MemoryBox());

      await _pumpLauncher(
        tester,
        onTap: (context) => VideoCardShieldQuickAction.showRecommendationDialog(
          context: context,
          title: '原始标题',
          upName: '测试UP',
          upUid: 12345,
          store: store,
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, '测试UP'), '编辑后UP');
      await tester.tap(find.byKey(const Key('up-keyword-block-button')));
      await tester.pumpAndSettle();

      final rules = (await store.load()).rules;
      expect(rules, hasLength(1));
      expect(rules.single.type, ShieldRuleType.userKeyword);
      expect(rules.single.scope, ShieldScope.recommendation);
      expect(rules.single.matchMode, ShieldMatchMode.token);
      expect(rules.single.pattern, '编辑后UP');
    });

    testWidgets('recommendation reason action creates reason keyword rule', (
      tester,
    ) async {
      final store = ShieldSettingsStore(box: _MemoryBox());

      await _pumpLauncher(
        tester,
        onTap: (context) => VideoCardShieldQuickAction.showRecommendationDialog(
          context: context,
          title: '原始标题',
          reason: '因为你看过游戏攻略',
          store: store,
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('屏蔽').last);
      await tester.pumpAndSettle();

      final rules = (await store.load()).rules;
      expect(rules, hasLength(1));
      expect(rules.single.type, ShieldRuleType.reasonKeyword);
      expect(rules.single.scope, ShieldScope.recommendation);
      expect(rules.single.matchMode, ShieldMatchMode.exact);
      expect(rules.single.pattern, '因为你看过游戏攻略');
    });

    testWidgets('UID action keeps original uid after UP text edit', (
      tester,
    ) async {
      final store = ShieldSettingsStore(box: _MemoryBox());

      await _pumpLauncher(
        tester,
        onTap: (context) => VideoCardShieldQuickAction.showRecommendationDialog(
          context: context,
          title: '原始标题',
          upName: '测试UP',
          upUid: 12345,
          store: store,
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, '测试UP'), '编辑后UP');
      await tester.tap(find.text('屏蔽用户 UID: 12345'));
      await tester.pumpAndSettle();

      final rules = (await store.load()).rules;
      expect(rules, hasLength(1));
      expect(rules.single.type, ShieldRuleType.uid);
      expect(rules.single.matchMode, ShieldMatchMode.exact);
      expect(rules.single.pattern, '12345');
    });
  });
}

Future<void> _pumpLauncher(
  WidgetTester tester, {
  required void Function(BuildContext context) onTap,
}) async {
  await tester.pumpWidget(
    GetMaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => onTap(context),
            child: const Text('打开'),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

class _MemoryBox implements ShieldSettingsBox {
  final values = <String, Object?>{};

  @override
  Object? get(String key, {Object? defaultValue}) =>
      values.containsKey(key) ? values[key] : defaultValue;

  @override
  Future<void> put(String key, Object? value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }
}
