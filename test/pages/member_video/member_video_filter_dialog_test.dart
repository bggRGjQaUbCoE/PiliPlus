import 'package:PiliPlus/pages/member_video/video_filter.dart';
import 'package:PiliPlus/pages/member_video/widgets/member_video_filter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // 回归背景：material_ui 迁移后，弹窗若再依赖 flutter/material 的
  // showModalBottomSheet，会因树中缺少 flutter/material 的
  // MaterialLocalizations 而断言失败 / 空断言崩溃，按钮点击无任何反应。
  // 本测试在 material_ui MaterialApp + material_ui 本地化代理下驱动完整
  // 弹窗链路（打开 → 数字输入 → 确认写回），任一环节退回 flutter/material
  // 都会立即失败。
  testWidgets('filter dialog opens and applies draft under material_ui app', (
    tester,
  ) async {
    final filter = MemberVideoFilter();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('zh', 'CN')],
        locale: const Locale('zh', 'CN'),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => MemberVideoFilterDialog.show(context, filter),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // A1：BottomSheet 弹出且内容完整
    expect(find.text('播放量筛选（万）'), findsOneWidget);
    expect(find.byType(RangeSlider), findsOneWidget);
    expect(find.text('隐藏已看完'), findsOneWidget);
    expect(find.text('隐藏看过未看完'), findsOneWidget);
    expect(find.text('确认'), findsOneWidget);

    // A3：点击左端数字标签 → 数字输入对话框 → 解析「10.5万」
    await tester.tap(find.text('不限').first);
    await tester.pumpAndSettle();
    expect(find.text('最小播放量'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '10.5万');
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(find.text('10.5万'), findsOneWidget);

    // A2：确认写回 filter 并关闭弹窗
    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();
    expect(find.text('播放量筛选（万）'), findsNothing);
    expect(filter.enableMinPlay, isTrue);
    expect(filter.minPlay, 105000);
    expect(filter.hasActiveFilter, isTrue);
  });
}
