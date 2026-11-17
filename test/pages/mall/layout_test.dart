import 'package:PiliPlus/common/widgets/main_layout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'reports real bottom layout height and preserves body behind floating bar',
    (tester) async {
      final measurements = <double>[];
      Widget layout(Widget? navigation) => MaterialApp(
        home: SizedBox(
          width: 400,
          height: 800,
          child: MainLayout(
            sideBar: null,
            bottomNav: navigation,
            body: const SizedBox.expand(key: ValueKey('body')),
            onBottomNavHeightChanged: measurements.add,
          ),
        ),
      );
      await tester.pumpWidget(
        layout(
          const SizedBox(key: ValueKey('navigation'), width: 344, height: 107),
        ),
      );
      expect(measurements, [107]);
      final body = tester.getRect(find.byKey(const ValueKey('body')));
      final navigation = tester.getRect(
        find.byKey(const ValueKey('navigation')),
      );
      expect(body.bottom, navigation.bottom);
      await tester.pumpWidget(layout(null));
      expect(measurements, [107, 0]);
    },
  );
}
