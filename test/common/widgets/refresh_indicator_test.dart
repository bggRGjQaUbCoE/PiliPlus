import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpIndicator(WidgetTester tester, bool isRefreshing) =>
      tester.pumpWidget(
        MaterialApp(home: RefreshIndicator_(isRefreshing: isRefreshing)),
      );

  testWidgets('hidden, it runs no ticker', (tester) async {
    await pumpIndicator(tester, false);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('it spins while refreshing and stops once hidden again', (
    tester,
  ) async {
    await pumpIndicator(tester, false);
    await pumpIndicator(tester, true);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.transientCallbackCount, greaterThan(0));

    await pumpIndicator(tester, false);
    // It shrinks away, then lets the spinner go.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.binding.transientCallbackCount, 0);
  });
}
