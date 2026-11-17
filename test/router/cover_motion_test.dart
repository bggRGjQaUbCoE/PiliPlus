import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  final image = MemoryImage(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
    ),
  );
  testWidgets('a reused surface waits for the new media frame', (tester) async {
    var signal = Future<void>.value();
    late StateSetter update;
    final data = CoverTransitionData(
      tag: Object(),
      image: image,
      radius: BorderRadius.zero,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Scaffold(
              body: CoverHandoff(data: data, firstFrame: signal),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    Opacity cover() => tester.widget<Opacity>(
      find
          .descendant(
            of: find.byType(CoverHandoff),
            matching: find.byType(Opacity),
          )
          .first,
    );
    expect(cover().opacity, 0);
    final nextMedia = Completer<void>();
    update(() {
      signal = nextMedia.future;
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(cover().opacity, 1);
    nextMedia.complete();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(cover().opacity, 0);
  });
  testWidgets('portrait cover interpolates its contained content window', (
    tester,
  ) async {
    const viewport = Size(406.6667, 587.6);
    final data = CoverTransitionData(
      tag: Object(),
      image: image,
      radius: BorderRadius.circular(12),
      contentAspectRatio: 9 / 16,
    );
    final contentRect = data.contentRectFor(viewport)!;
    expect(contentRect.top, 0);
    expect(contentRect.bottom, 1);
    expect(contentRect.left, closeTo(.0936, .001));
    expect(contentRect.right, closeTo(.9064, .001));

    final sourceKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            Hero(
              key: sourceKey,
              tag: 'source',
              child: CoverVisual(
                data: data,
                targetContentRect: contentRect,
              ),
            ),
            const Hero(
              key: ValueKey('target-key'),
              tag: 'target',
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
    final shuttle = CoverTransitionData.flight(
      sourceKey.currentContext!,
      const AlwaysStoppedAnimation(.5),
      HeroFlightDirection.push,
      sourceKey.currentContext!,
      tester.element(find.byKey(const ValueKey('target-key'))),
    );
    await tester.pumpWidget(MaterialApp(home: shuttle));
    final visual = tester.widget<CoverVisual>(find.byType(CoverVisual));
    expect(visual.progress, .5);
    expect(visual.targetContentRect, contentRect);
    expect(
      tester
          .widget<Image>(
            find.byWidgetPredicate(
              (widget) => widget is Image && identical(widget.image, image),
            ),
          )
          .fit,
      BoxFit.cover,
    );
  });
  testWidgets('portrait handoff follows the route video zoom matrix', (
    tester,
  ) async {
    const viewport = Size(400, 800);
    final data = CoverTransitionData(
      tag: Object(),
      image: image,
      radius: BorderRadius.zero,
      contentAspectRatio: 9 / 16,
    );
    final transform = TransformationController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoverHandoff(
            data: data,
            viewport: viewport,
            transform: transform,
          ),
        ),
      ),
    );
    CoverVisual target() => tester.widget<CoverVisual>(
      find.descendant(
        of: find.byType(CoverHandoff),
        matching: find.byType(CoverVisual),
      ),
    );
    expect(target().targetContentRect, data.contentRectFor(viewport));
    transform.value = Matrix4.identity()..scale(1.5);
    await tester.pump();
    final scaledRect = target().targetContentRect!;
    expect(scaledRect.top, closeTo(.08333, .001));
    expect(scaledRect.bottom, closeTo(1.41667, .001));
    await tester.pumpWidget(const SizedBox());
    transform.dispose();
  });
  testWidgets('cover image keeps cover fit at each content-window stage', (
    tester,
  ) async {
    const viewport = Size(406.6667, 587.6);
    const progressValues = [0.0, .5, 1.0];
    final data = CoverTransitionData(
      tag: Object(),
      image: image,
      radius: BorderRadius.zero,
      contentAspectRatio: 9 / 16,
    );
    final contentRect = data.contentRectFor(viewport)!;
    final frameKey = GlobalKey();
    final imageFinder = find.byWidgetPredicate(
      (widget) => widget is Image && identical(widget.image, image),
    );

    for (final progress in progressValues) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                key: frameKey,
                width: viewport.width,
                height: viewport.height,
                child: CoverVisual(
                  data: data,
                  targetContentRect: contentRect,
                  progress: progress,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final imageRect = tester.getRect(imageFinder);
      final frameRect = tester.getRect(find.byKey(frameKey));
      final targetRect = Rect.fromLTRB(
        contentRect.left * viewport.width,
        contentRect.top * viewport.height,
        contentRect.right * viewport.width,
        contentRect.bottom * viewport.height,
      );
      final expected = Rect.lerp(Offset.zero & viewport, targetRect, progress)!;
      expect(imageRect.left - frameRect.left, closeTo(expected.left, .01));
      expect(imageRect.top - frameRect.top, closeTo(expected.top, .01));
      expect(imageRect.width, closeTo(expected.width, .01));
      expect(imageRect.height, closeTo(expected.height, .01));
      expect(tester.widget<Image>(imageFinder).fit, BoxFit.cover);
    }
  });
  testWidgets('reverse shuttle starts square and ends at source radius', (
    tester,
  ) async {
    final data = CoverTransitionData(
      tag: Object(),
      image: image,
      radius: BorderRadius.circular(12),
    );
    final from = GlobalKey();
    final to = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Hero(
              key: from,
              tag: 'from',
              child: CoverVisual(data: data),
            ),
            Hero(key: to, tag: 'to', child: const SizedBox()),
          ],
        ),
      ),
    );
    final start = CoverTransitionData.flight(
      from.currentContext!,
      const AlwaysStoppedAnimation(1),
      HeroFlightDirection.pop,
      from.currentContext!,
      to.currentContext!,
    );
    await tester.pumpWidget(MaterialApp(home: start));
    expect(
      tester.widget<CoverVisual>(find.byType(CoverVisual)).radius,
      BorderRadius.zero,
    );
  });
  for (final readyFirst in [false, true]) {
    testWidgets(
      'cover waits for route and frame, reverse remains available $readyFirst',
      (tester) async {
        final signal = Completer<void>();
        final playerKey = GlobalKey();
        final data = CoverTransitionData(
          tag: Object(),
          image: image,
          radius: BorderRadius.circular(12),
        );
        late BuildContext source;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                source = context;
                return Scaffold(
                  body: Hero(
                    tag: data.tag,
                    child: CoverVisual(data: data),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        Navigator.of(source).push(
          PageRouteBuilder<void>(
            settings: RouteSettings(arguments: {'coverTransition': data}),
            transitionDuration: const Duration(milliseconds: 320),
            reverseTransitionDuration: const Duration(milliseconds: 280),
            pageBuilder: (_, _, _) => Scaffold(
              body: CoverHandoff(
                data: data,
                firstFrame: signal.future,
                child: StatefulBuilder(
                  key: playerKey,
                  builder: (_, _) => const ColoredBox(color: Colors.black),
                ),
              ),
            ),
            transitionsBuilder: (context, a, b, child) =>
                const CoverPageTransitionsBuilder().buildTransitions(
                  ModalRoute.of(context)! as PageRoute,
                  context,
                  a,
                  b,
                  child,
                ),
          ),
        );
        await tester.pump();
        expect(find.byType(CoverHandoff, skipOffstage: false), findsOneWidget);
        final playerState = playerKey.currentState;
        expect(playerState, isNotNull);
        expect(find.byKey(playerKey), findsNothing);
        if (readyFirst) {
          signal.complete();
          await tester.pump();
          await tester.pump();
        }
        await tester.pump(const Duration(milliseconds: 150));
        Opacity cover() => tester.widget<Opacity>(
          find
              .descendant(
                of: find.byType(CoverHandoff, skipOffstage: false),
                matching: find.byType(Opacity),
              )
              .first,
        );
        expect(cover().opacity, 0);
        expect(find.byKey(playerKey), findsNothing);
        await tester.pumpAndSettle();
        expect(find.byKey(playerKey), findsOneWidget);
        expect(playerKey.currentState, same(playerState));
        if (!readyFirst) {
          expect(cover().opacity, 1);
          signal.complete();
          await tester.pump();
          await tester.pump();
        }
        await tester.pumpAndSettle();
        expect(cover().opacity, 0);
        Navigator.of(source).pop();
        await tester.pump();
        expect(cover().opacity, 0);
        expect(find.byKey(playerKey), findsNothing);
        expect(playerKey.currentState, same(playerState));
        await tester.pumpAndSettle();
        expect(find.byType(CoverHandoff, skipOffstage: false), findsNothing);
        expect(find.byType(Hero), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'pop during entry and late frame leave no endpoint or state update',
    (tester) async {
      final signal = Completer<void>();
      final data = CoverTransitionData(
        tag: Object(),
        image: image,
        radius: BorderRadius.circular(12),
      );
      late BuildContext source;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              source = context;
              return const Scaffold(body: Text('source'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      Navigator.of(source).push(
        PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => Scaffold(
            body: CoverHandoff(data: data, firstFrame: signal.future),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      Navigator.of(source).pop();
      await tester.pumpAndSettle();
      signal.complete();
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(CoverHandoff), findsNothing);
      expect(find.text('source'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'cover route reverses from its visible progress when interrupted',
    (
      tester,
    ) async {
      final data = CoverTransitionData(
        tag: Object(),
        image: image,
        radius: BorderRadius.circular(12),
      );
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: Hero(
              tag: data.tag,
              child: CoverVisual(data: data),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final route = PageRouteBuilder<void>(
        settings: RouteSettings(arguments: {'coverTransition': data}),
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, _, _) => Scaffold(body: CoverHandoff(data: data)),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            const CoverPageTransitionsBuilder().buildTransitions(
              ModalRoute.of(context)! as PageRoute,
              context,
              animation,
              secondaryAnimation,
              child,
            ),
      );
      navigatorKey.currentState!.push(route);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      final beforePop = route.animation!.value;
      expect(beforePop, greaterThan(0));
      expect(beforePop, lessThan(1));
      double flightProgress() => tester
          .widgetList<CoverVisual>(
            find.byType(CoverVisual, skipOffstage: false),
          )
          .map((visual) => visual.progress)
          .firstWhere((progress) => progress > 0 && progress < 1);

      final beforeFlightPop = flightProgress();

      navigatorKey.currentState!.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      final afterPop = route.animation!.value;
      expect(afterPop, lessThan(beforePop));
      expect(afterPop, greaterThan(0));
      final afterFlightPop = flightProgress();
      expect(afterFlightPop, lessThan(beforeFlightPop));
      expect(beforeFlightPop - afterFlightPop, lessThan(0.2));
      await tester.pumpAndSettle();
      expect(find.byType(CoverHandoff), findsNothing);
      expect(find.byType(ImageFiltered), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('reduced motion disables the target shared flight', (
    tester,
  ) async {
    final data = CoverTransitionData(
      tag: Object(),
      image: image,
      radius: BorderRadius.zero,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(body: CoverHandoff(data: data)),
        ),
      ),
    );
    final mode = tester.widget<HeroMode>(
      find.descendant(
        of: find.byType(CoverHandoff),
        matching: find.byType(HeroMode),
      ),
    );
    expect(mode.enabled, isFalse);
  });
}
