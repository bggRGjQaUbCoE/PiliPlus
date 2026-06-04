import 'package:PiliPlus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a visible diagnostic screen when bootstrap fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      BootstrapApp(
        initialize: () async => throw StateError('storage unavailable'),
        onInitialized: () async => true,
        child: const SizedBox.shrink(),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Startup failed'), findsOneWidget);
    expect(
      find.textContaining('storage unavailable', findRichText: true),
      findsOneWidget,
    );
  });
}
