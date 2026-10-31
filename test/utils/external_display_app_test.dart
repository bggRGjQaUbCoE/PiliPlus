import 'package:PiliPlus/pages/video/widgets/external_playback_header.dart';
import 'package:PiliPlus/utils/ios/external_display_app.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:canvas_danmaku/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.example.piliplus/external-renderer');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('TV danmaku keeps colors, placement and membership decorations', () {
    final item = externalDanmakuItem({
      'text': '彩色顶部弹幕',
      'mode': 5,
      'color': 0xffff5078,
      'colorful': true,
      'selfSend': true,
      'count': 3,
    })!;
    expect(item.type, DanmakuItemType.top);
    expect(item.color.toARGB32(), 0xffff5078);
    expect(item.isColorful, isTrue);
    expect(item.selfSend, isTrue);
    expect(item.count, 3);
    expect(externalDanmakuItem({'text': 'broken special', 'mode': 7}), isNull);
    expect(
      externalDanmakuItem({'text': 'next normal', 'mode': 4})?.type,
      DanmakuItemType.bottom,
    );
  });

  test('TV receives full-screen timing, density and filtering preferences', () {
    final option = externalDanmakuOptions({
      'fontSize': 23.5,
      'area': 0.6,
      'duration': 4.5,
      'staticDuration': 2.5,
      'hideSpecial': true,
      'hideTop': true,
      'massiveMode': true,
      'fixedVelocity': true,
    });
    expect(option.fontSize, 23.5);
    expect(option.area, 0.6);
    expect(option.durationInMilliseconds, 4500);
    expect(option.staticDurationInMilliseconds, 2500);
    expect(option.hideSpecial && option.hideTop, isTrue);
    expect(option.massiveMode && option.scrollFixedVelocity, isTrue);
    expect(option.safeArea, isTrue);
  });

  testWidgets(
    'phone controls collapse without replacing or resizing the source player',
    (tester) async {
      const playerKey = ValueKey('source-player');
      var toggles = 0;
      var controls = 0;
      Widget page(bool connected) => MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SizedBox(
                width: 402,
                height: connected ? ExternalPlaybackHeader.compactHeight : 226,
                child: ExternalPlaybackHeader(
                  connected: connected,
                  playing: true,
                  videoSize: const Size(402, 226),
                  player: const ColoredBox(
                    key: playerKey,
                    color: Colors.black,
                    child: Center(child: Text('手机视频画面')),
                  ),
                  overlay: const SizedBox.shrink(),
                  onBack: () {},
                  onTogglePlayback: () => toggles++,
                  onShowControls: () => controls++,
                ),
              ),
              const Expanded(child: Text('评论区')),
            ],
          ),
        ),
      );
      final playerFinder = find.byKey(playerKey, skipOffstage: false);
      await tester.pumpWidget(page(false));
      final originalPlayer = tester.element(playerFinder);
      expect(tester.getSize(playerFinder), const Size(402, 226));
      await tester.pumpWidget(page(true));
      expect(tester.element(playerFinder), same(originalPlayer));
      expect(tester.getSize(playerFinder), const Size(402, 226));
      expect(TickerMode.valuesOf(tester.element(playerFinder)).enabled, isTrue);
      expect(find.text('手机视频画面'), findsNothing);
      expect(find.text('评论区'), findsOneWidget);
      expect(
        tester.getSize(find.byType(ExternalPlaybackHeader)).height,
        ExternalPlaybackHeader.compactHeight,
      );
      await tester.tap(find.byTooltip('暂停'));
      await tester.tap(find.byTooltip('投屏选项'));
      expect(toggles, 1);
      expect(controls, 1);
      await tester.pumpWidget(page(false));
      expect(tester.element(playerFinder), same(originalPlayer));
      expect(find.text('手机视频画面'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'tablet remote replaces the video while retaining its player and comments',
    (tester) async {
      tester.view.physicalSize = const Size(1366, 1024);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const playerKey = ValueKey('tablet-player');
      var toggles = 0;
      var danmakuToggles = 0;
      double? scale;
      double? savedScale;
      Duration? seek;
      Widget page(bool connected) => MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SizedBox(
                width: 860,
                height: 484,
                child: ExternalPlaybackPanel(
                  connected: connected,
                  playing: true,
                  player: const ColoredBox(
                    key: playerKey,
                    color: Colors.black,
                    child: Center(child: Text('平板视频画面')),
                  ),
                  position: const Duration(seconds: 60),
                  duration: const Duration(minutes: 10),
                  danmaku: true,
                  danmakuScale: 1.2,
                  subtitles: const ['关闭', 'English'],
                  subtitleIndex: 0,
                  onBack: () {},
                  onShowControls: () {},
                  onTogglePlayback: () => toggles++,
                  onSeek: (value) => seek = value,
                  onToggleDanmaku: () => danmakuToggles++,
                  onSubtitle: (_) {},
                  onDanmakuScale: (value) => scale = value,
                  onSaveDanmakuScale: (value) => savedScale = value,
                ),
              ),
              const Expanded(child: Text('右侧评论')),
            ],
          ),
        ),
      );
      await tester.pumpWidget(page(false));
      final source = find.byKey(playerKey, skipOffstage: false);
      final original = tester.element(source);
      await tester.pumpWidget(page(true));
      expect(tester.element(source), same(original));
      expect(tester.getSize(source), const Size(860, 484));
      expect(find.text('平板视频画面'), findsNothing);
      expect(find.text('右侧评论'), findsOneWidget);
      expect(find.text('弹幕字号'), findsOneWidget);
      await tester.tap(find.byTooltip('暂停'));
      await tester.tap(find.byTooltip('前进 15 秒'));
      await tester.tap(find.text('弹幕已开启'));
      await tester.drag(
        find.byKey(const ValueKey('external-danmaku-scale')),
        const Offset(90, 0),
      );
      expect(toggles, 1);
      expect(danmakuToggles, 1);
      expect(seek, const Duration(seconds: 75));
      expect(scale, greaterThan(1.2));
      expect(savedScale, scale);
      await tester.pumpWidget(page(false));
      expect(tester.element(source), same(original));
      expect(find.text('平板视频画面'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'TV text cache retains physical resolution after logical canvas scaling',
    (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      messenger.setMockMethodCallHandler(channel, (_) async => null);
      await tester.pumpWidget(
        const Center(
          child: SizedBox(width: 640, height: 360, child: ExternalDisplayApp()),
        ),
      );
      await tester.pump();
      final item = DanmakuItem<void>(
        content: DanmakuContentItem<void>('清晰弹幕'),
        width: 0,
        height: 0,
      )..drawParagraphIfNeeded(15, 4, 1.5);
      expect(DmUtils.devicePixelRatio, 3);
      expect(item.image!.width, (item.width * 3).ceil());
      expect(item.image!.height, (item.height * 3).ceil());
      item.dispose();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'subtitle and danmaku changes keep the same shared video surface',
    (tester) async {
      final outgoing = <String>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        outgoing.add(call.method);
        return null;
      });
      await tester.pumpWidget(const ExternalDisplayApp());
      await tester.pump();
      expect(outgoing, ['ready']);

      Future<void> send(String method, Object? arguments) async {
        await messenger.handlePlatformMessage(
          channel.name,
          const StandardMethodCodec().encodeMethodCall(
            MethodCall(method, arguments),
          ),
          (_) {},
        );
        await tester.pump();
      }

      final state = <String, Object>{
        'textureId': 41,
        'width': 1920,
        'height': 1080,
        'playing': true,
        'danmaku': true,
        'subtitleText': '独立字幕仍然可见',
        'subtitleStyle': {'backgroundOpacity': 0.65},
      };
      await send('update', state);
      final video = tester.element(find.byType(Texture));
      expect(tester.widget<Texture>(find.byType(Texture)).textureId, 41);
      expect(find.text('独立字幕仍然可见'), findsOneWidget);
      final subtitleText = tester.widget<RichText>(
        find.descendant(
          of: find.text('独立字幕仍然可见'),
          matching: find.byType(RichText),
        ),
      );
      expect(
        subtitleText.text.style?.decoration?.contains(
              TextDecoration.underline,
            ) ??
            false,
        isFalse,
      );
      expect(find.byType(DanmakuScreen<void>), findsOneWidget);

      await send('danmaku', [
        {'text': '普通弹幕', 'color': 0xffff0000, 'mode': 1},
        {'text': 'invalid advanced item', 'mode': 7},
      ]);
      await send('update', {
        ...state,
        'danmaku': false,
        'subtitleText': '切换后的字幕',
      });
      expect(tester.element(find.byType(Texture)), same(video));
      expect(find.text('切换后的字幕'), findsOneWidget);
      expect(find.text('独立字幕仍然可见'), findsNothing);
      final opacity = tester.widget<Opacity>(
        find.byWidgetPredicate(
          (widget) => widget is Opacity && widget.child is DanmakuScreen<void>,
        ),
      );
      expect(opacity.opacity, 0);
      await send('clearDanmaku', null);
      await send('update', {...state, 'playing': false});
      expect(tester.element(find.byType(Texture)), same(video));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
