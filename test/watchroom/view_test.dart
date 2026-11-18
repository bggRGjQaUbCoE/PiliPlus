import 'package:PiliPlus/features/watchroom/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('room entry uses the host app material localizations', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('zh', 'CN'),
        supportedLocales: [Locale('zh', 'CN')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: WatchroomPage(link: '12345'),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('B站放映厅'), findsOneWidget);
    expect(find.text('12345'), findsOneWidget);
    expect(find.text('加入官方放映厅'), findsOneWidget);
    expect(find.text('登录 PiliPlus 主账号'), findsOneWidget);
  });
}
