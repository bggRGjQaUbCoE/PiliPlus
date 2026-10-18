import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' as material;

void main() {
  test('all original seed variants construct both light and dark schemes', () {
    expect(FlexSchemeVariant.values, hasLength(21));
    for (final variant in FlexSchemeVariant.values) {
      for (final brightness in Brightness.values) {
        final scheme = SeedColorScheme.fromSeeds(
          primaryKey: const Color(0xff6750a4),
          secondaryKey: const Color(0xff006a6a),
          tertiaryKey: const Color(0xff7d5260),
          brightness: brightness,
          variant: variant,
        );
        expect(scheme.brightness, brightness, reason: variant.name);
        expect(scheme.primary.a, 1, reason: variant.name);
      }
    }
  });

  testWidgets('fixed Material and Cupertino packages build on OHOS', (tester) async {
    await tester.pumpWidget(
      material.MaterialApp(
        theme: material.ThemeData(
          colorScheme: SeedColorScheme.fromSeeds(
            primaryKey: const Color(0xff6750a4),
            variant: FlexSchemeVariant.vivid,
          ),
        ),
        home: const material.Scaffold(
          body: Center(child: Text('Material UI retained')),
        ),
      ),
    );
    expect(find.text('Material UI retained'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      const cupertino.CupertinoApp(
        home: cupertino.CupertinoPageScaffold(
          child: Center(child: Text('Cupertino UI retained')),
        ),
      ),
    );
    expect(find.text('Cupertino UI retained'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant({TargetPlatform.ohos}));
}
