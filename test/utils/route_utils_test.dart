import 'package:PiliPlus/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('completes the initiating route without popping a newer route', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: const Text('home'),
      ),
    );

    final navigator = navigatorKey.currentState!;
    late Route<Object?> initiatingRoute;
    final initiatingResult = navigator.push<Object?>(
      MaterialPageRoute<Object?>(
        builder: (context) {
          initiatingRoute = ModalRoute.of<Object?>(context)!;
          return const Text('initiating');
        },
      ),
    );
    await tester.pumpAndSettle();

    navigator.push<void>(
      MaterialPageRoute<void>(builder: (_) => const Text('newer')),
    );
    await tester.pumpAndSettle();

    completeRoute<Object?>(navigator, initiatingRoute, 'done');
    await tester.pumpAndSettle();

    expect(find.text('newer'), findsOneWidget);
    expect(await initiatingResult, 'done');

    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(find.text('initiating'), findsNothing);
  });

  testWidgets('pops the initiating route when it is current', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: const Text('home'),
      ),
    );

    final navigator = navigatorKey.currentState!;
    late Route<Object?> route;
    final result = navigator.push<Object?>(
      MaterialPageRoute<Object?>(
        builder: (context) {
          route = ModalRoute.of<Object?>(context)!;
          return const Text('current');
        },
      ),
    );
    await tester.pumpAndSettle();

    completeRoute<Object?>(navigator, route, 42);
    await tester.pumpAndSettle();

    expect(await result, 42);
    expect(find.text('home'), findsOneWidget);
  });
}
