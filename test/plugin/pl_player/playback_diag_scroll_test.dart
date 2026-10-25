// ignore_for_file: cascade_invocations

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/app_bar_ani.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/bottom_control.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/playback_diag_bar.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  setUpAll(() {
    GStorage.setting = _FakeSettingBox();
  });

  testWidgets('diagnostic viewport scrolls from the upper drag region', (
    tester,
  ) async {
    final viewportKey = GlobalKey(debugLabel: 'test-viewport');
    final controller = _FakePlPlayerController();

    final inheritedController = await _pumpDiagnosticBar(
      tester,
      controller,
      viewportKey,
    );
    addTearDown(inheritedController.dispose);

    // PlaybackDiagBar owns the scrollable; inspect its real ScrollableState.
    final viewportFinder = find.byKey(viewportKey);
    final scrollableFinder = find.descendant(
      of: viewportFinder,
      matching: find.byType(Scrollable),
    );
    final scrollable = tester.state<ScrollableState>(scrollableFinder);
    expect(scrollable.widget.controller, isNot(same(inheritedController)));
    final position = scrollable.position;
    final viewportBox = tester.renderObject<RenderBox>(viewportFinder);
    final center = viewportBox.localToGlobal(
      viewportBox.size.center(Offset.zero),
    );
    final hitTest = tester.hitTestOnBinding(center);

    expect(position.maxScrollExtent, greaterThan(0));
    expect(position.viewportDimension, greaterThan(0));
    expect(
      hitTest.path.any((entry) => entry.target is RenderPointerListener),
      isTrue,
      reason: 'the diagnostic viewport must participate in pointer hit testing',
    );

    final initialPixels = position.pixels;
    final acceptedStart = viewportBox.localToGlobal(
      Offset(viewportBox.size.width / 2, 10),
    );
    await tester.dragFrom(acceptedStart, const Offset(0, -43));
    await tester.pumpAndSettle();

    expect(position.pixels, greaterThan(initialPixels));
    expect(controller.hideTaskControlsCalls, greaterThan(0));

    final afterUpperDrag = position.pixels;
    final lowerStart = viewportBox.localToGlobal(
      Offset(viewportBox.size.width / 2, viewportBox.size.height - 8),
    );
    await tester.dragFrom(lowerStart, const Offset(0, -43));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(afterUpperDrag));
    expect(position.pixels, closeTo(position.maxScrollExtent, 1));

    final afterLowerDrag = position.pixels;
    final returnStart = viewportBox.localToGlobal(
      Offset(viewportBox.size.width / 2, 10),
    );
    await tester.dragFrom(returnStart, const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(position.pixels, lessThan(afterLowerDrag));
    expect(position.pixels, closeTo(0, 1));
    expect(controller.hideTaskControlsCalls, greaterThan(1));

    final beforeTopOverscroll = position.pixels;
    final renewalsBeforeTopOverscroll = controller.hideTaskControlsCalls;
    await tester.dragFrom(returnStart, const Offset(0, 32));
    await tester.pumpAndSettle();
    expect(position.pixels, beforeTopOverscroll);
    expect(
      controller.hideTaskControlsCalls,
      greaterThan(renewalsBeforeTopOverscroll),
    );

    final activeGesture = await tester.startGesture(acceptedStart);
    await activeGesture.moveBy(const Offset(0, -40));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await activeGesture.up();
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('lower 30 dp scrolls in the real diagnostic viewport', (
    tester,
  ) async {
    final viewportKey = GlobalKey(debugLabel: 'test-viewport');
    final controller = _FakePlPlayerController();
    final inheritedController = await _pumpDiagnosticBar(
      tester,
      controller,
      viewportKey,
    );
    addTearDown(inheritedController.dispose);

    final viewportFinder = find.byKey(viewportKey);
    final scrollableFinder = find.descendant(
      of: viewportFinder,
      matching: find.byType(Scrollable),
    );
    final scrollable = tester.state<ScrollableState>(scrollableFinder);
    expect(scrollable.widget.controller, isNot(same(inheritedController)));
    final position = scrollable.position;
    final viewportBox = tester.renderObject<RenderBox>(viewportFinder);
    final bottomStart = viewportBox.localToGlobal(
      Offset(viewportBox.size.width / 2, viewportBox.size.height - 8),
    );
    final initialPixels = position.pixels;

    await tester.dragFrom(bottomStart, const Offset(0, -43));
    await tester.pumpAndSettle();

    expect(position.pixels, greaterThan(initialPixels));
    expect(controller.hideTaskControlsCalls, greaterThan(0));
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('real bottom control keeps buttons and diagnostic viewport', (
    tester,
  ) async {
    final viewportKey = GlobalKey(debugLabel: 'test-viewport');
    final controller = _FakePlPlayerController();
    final detailController = _FakeVideoDetailController();
    var buttonTaps = 0;

    await tester.binding.setSurfaceSize(const Size(400, 260));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              height: 193,
              child: _BottomControlHarness(
                controller: controller,
                detailController: detailController,
                viewportKey: viewportKey,
                onButtonTap: () => buttonTaps++,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = find.byKey(const ValueKey('fake-play-button'));
    expect(button, findsOneWidget);
    final buttonRect = tester.getRect(button);
    final parentRect = tester.getRect(find.byType(_BottomControlHarness));
    expect(buttonRect.top, greaterThanOrEqualTo(parentRect.top));
    expect(buttonRect.bottom, lessThanOrEqualTo(parentRect.bottom));
    await tester.tap(button);
    await tester.pump();
    expect(buttonTaps, 1);

    final viewportFinder = find.byKey(viewportKey);
    final scrollableFinder = find.descendant(
      of: viewportFinder,
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scrollableFinder).position;
    final viewportBox = tester.renderObject<RenderBox>(viewportFinder);
    expect(position.maxScrollExtent, greaterThan(0));

    final lowerStart = viewportBox.localToGlobal(
      Offset(viewportBox.size.width / 2, viewportBox.size.height - 8),
    );
    final initialPixels = position.pixels;
    await tester.dragFrom(lowerStart, const Offset(0, -43));
    await tester.pumpAndSettle();

    expect(position.pixels, greaterThan(initialPixels));
    expect(controller.hideTaskControlsCalls, greaterThan(0));
    await tester.binding.setSurfaceSize(null);
  });
}

Future<ScrollController> _pumpDiagnosticBar(
  WidgetTester tester,
  _FakePlPlayerController controller,
  GlobalKey viewportKey,
) async {
  await tester.binding.setSurfaceSize(const Size(400, 200));
  final inheritedController = ScrollController();
  await tester.pumpWidget(
    PrimaryScrollController(
      controller: inheritedController,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              height: 64,
              child: PlaybackDiagBar(
                controller: controller,
                viewportKey: viewportKey,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  return inheritedController;
}

class _FakePlPlayerController implements PlPlayerController {
  final RxBool _showControls = true.obs;
  final _FakeRoutedPlayback _playback = _FakeRoutedPlayback();

  int hideTaskControlsCalls = 0;
  @override
  final RxInt buffered = 0.obs;
  @override
  final RxInt duration = 360.obs;

  @override
  RxBool get showControls => _showControls;

  @override
  Player? get videoPlayerController => null;

  @override
  VideoController? get videoController => null;

  @override
  RoutedVideoPlayback? get playback => _playback;

  @override
  void hideTaskControls() => hideTaskControlsCalls++;

  @override
  int get progress => 0;

  @override
  bool get enableBlock => false;

  @override
  bool get showViewPoints => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeVideoDetailController implements VideoDetailController {
  @override
  final RxList<Segment> segmentProgressList = <Segment>[].obs;
  @override
  final RxList<ViewPointSegment> viewPointList = <ViewPointSegment>[].obs;
  @override
  final RxBool showVP = false.obs;
  @override
  final RxBool showDmTrendChart = false.obs;

  @override
  Rx<LoadingState<List<double>>?> get dmTrend =>
      Rx<LoadingState<List<double>>?>(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _BottomControlHarness extends StatefulWidget {
  const _BottomControlHarness({
    required this.controller,
    required this.detailController,
    required this.viewportKey,
    required this.onButtonTap,
  });

  final _FakePlPlayerController controller;
  final _FakeVideoDetailController detailController;
  final GlobalKey viewportKey;
  final VoidCallback onButtonTap;

  @override
  State<_BottomControlHarness> createState() => _BottomControlHarnessState();
}

class _BottomControlHarnessState extends State<_BottomControlHarness>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: 1,
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 42),
        Flexible(
          fit: FlexFit.loose,
          child: AppBarAni(
            isTop: false,
            controller: animationController,
            isFullScreen: false,
            removeSafeArea: true,
            child: BottomControl(
              maxWidth: 320,
              isFullScreen: false,
              controller: widget.controller,
              diagViewportKey: widget.viewportKey,
              videoDetailController: widget.detailController,
              buildBottomControl: () => SizedBox(
                height: 52,
                child: Center(
                  child: TextButton(
                    key: const ValueKey('fake-play-button'),
                    onPressed: widget.onButtonTap,
                    child: const Text('播放'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FakeRoutedPlayback implements RoutedVideoPlayback {
  _FakeRoutedPlayback()
    : report = ValueNotifier(
        HdrOutputReport(
          sourceFacts: HdrSourceFacts.fromHint(
            const HdrSourceDescriptor(
              codec: 'hevc',
              transfer: 'hlg',
              primaries: 'bt.2020',
              dynamicMetadata: HdrDynamicMetadata.dolbyVision,
              dvProfile: 8,
              dvCompatibilityId: 4,
            ),
          ),
          actual: const HdrRoute(
            strategy: HdrStrategy.metadataReshape,
            presentation: HdrPresentation.nativeHdr,
            outputTransfer: HdrOutputTransfer.pq,
            appliesDynamicMetadata: true,
            topology: HdrTopology.platformView,
            vo: 'gpu-next',
            hwdec: 'mediacodec',
            targetPrim: 'bt.2020',
            targetTrc: 'pq',
            targetPeak: '1000',
            surfaceTransfer: 'pq',
            stripDvRpu: true,
            metadataHandling: HdrMetadataHandling.consumeForMapping,
          ),
          dataSpaceRequested: 'pq',
          dataSpacePath: 'surfaceControl',
          dataSpaceReadback: 'DATASPACE_BT2020_PQ',
        ),
      );

  @override
  final ValueListenable<HdrOutputReport> report;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSettingBox implements Box<dynamic> {
  @override
  dynamic get(dynamic key, {dynamic defaultValue}) =>
      key == SettingBoxKey.showPlaybackDiagBar ? true : defaultValue;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
