import 'dart:io';
import 'dart:ui' as ui;

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/search/view.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/router/search_expansion.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

class _Home extends HomeController {
  @override
  // ignore: must_call_super
  void onInit() {
    hideTopBar = false;
    tabs = [];
    tabController = TabController(length: 0, vsync: this);
    enableSearchWord = true;
    defaultSearch.value = '首页提示词';
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class _Main extends MainController {
  @override
  // ignore: must_call_super
  void onInit() {
    navigationBars = NavigationBarType.values;
    controller = PageController();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  final pending = <String, (RequestOptions, RequestInterceptorHandler)>{};
  const history = '本地历史词条';
  final searchBar = find.byIcon(Icons.search_outlined);
  final field = find.byType(TextField);

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('pili-home-search-');
    Hive.init(directory.path);
    GStorage.setting = await Hive.openBox('setting');
    GStorage.historyWord = await Hive.openBox('history');
    GStorage.localCache = await Hive.openBox('cache');
    GStorage.userInfo = await Hive.openBox('user');
    await Accounts.init();
    Request();
    Request.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final path = options.path;
          if (path == Api.searchTrending || path == Api.searchRecommend) {
            pending[path] = (options, handler);
          } else if (path == Api.searchSuggest) {
            pending[options.queryParameters['term'] as String] = (
              options,
              handler,
            );
          } else {
            handler.resolve(
              Response(requestOptions: options, data: {'code': -1}),
            );
          }
        },
      ),
    );
  });

  setUp(() async {
    await GStorage.setting.clear();
    await GStorage.setting.put(SettingBoxKey.searchSuggestion, false);
    await GStorage.historyWord.put('cacheList', [history]);
  });

  void respond(String path, Map<String, dynamic> data) {
    final (options, handler) = pending.remove(path)!;
    handler.resolve(Response(requestOptions: options, data: data));
  }

  tearDown(() {
    for (final path in pending.keys.toList()) {
      respond(path, {'code': -1, 'message': '测试结束'});
    }
    Accounts.accountMode[AccountType.main.index] = AnonymousAccount();
    Get.reset();
  });

  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  Future<void> start(
    WidgetTester tester, {
    bool reduceMotion = false,
    GlobalKey? frameKey,
  }) async {
    tester.view
      ..physicalSize = const Size(450, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    Get
      ..put(AccountService())
      ..put<MainController>(_Main())
      ..put<HomeController>(_Home());
    HomeSearchTransition.install();
    await tester.pumpWidget(
      GetMaterialApp(
        builder: (context, child) => RepaintBoundary(
          key: frameKey,
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(disableAnimations: reduceMotion),
            child: child!,
          ),
        ),
        getPages: [
          GetPage(
            name: '/',
            page: () => const Material(child: HomePage()),
          ),
          GetPage(name: '/search', page: () => const SearchPage()),
          GetPage(name: '/loginPage', page: () => const Text('登录路由')),
          GetPage(
            name: '/member',
            page: () => Text('主页 ${Get.parameters['mid']}'),
          ),
          GetPage(
            name: '/searchResult',
            page: () => Text('结果 ${Get.parameters['keyword']}'),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'home search reverses during entry and focuses only when expanded',
    (tester) async {
      await start(tester);
      final source = tester.getRect(searchBar);
      await tester.tap(searchBar);
      await tester.pump();
      await tester.pump();
      final route = ModalRoute.of(tester.element(field))!;
      expect(route.settings.arguments, isA<SearchExpansion>());
      expect(route.transitionDuration, const Duration(milliseconds: 300));
      expect(
        (route.settings.arguments as SearchExpansion).viewport,
        const Size(450, 800),
      );
      final panel = find.byWidgetPredicate(
        (w) => w is ClipRRect && w.clipper != null,
      );
      RRect bounds() => tester
          .widget<ClipRRect>(panel)
          .clipper!
          .getClip(const Size(450, 800));
      expect(bounds().outerRect.contains(source.center), isTrue);
      expect(bounds().outerRect.height, 44);
      expect(bounds().tlRadiusX, 22);
      expect(tester.getRect(searchBar), source);
      final originalPanel = bounds();
      await tester.pump(const Duration(milliseconds: 45));
      expect(bounds().bottom, closeTo(originalPanel.bottom, .001));
      expect(bounds().width, greaterThan(originalPanel.width));
      await tester.pump(const Duration(milliseconds: 30));
      final centeredPanel = bounds();
      expect(centeredPanel.center.dx, closeTo(225, .001));
      expect(centeredPanel.top, closeTo(originalPanel.top, 1));
      expect(centeredPanel.bottom, greaterThan(originalPanel.bottom));
      await tester.pump(const Duration(milliseconds: 65));
      expect(bounds().center.dx, closeTo(225, .001));
      expect(bounds().left, greaterThanOrEqualTo(0));
      expect(bounds().right, lessThanOrEqualTo(450));
      expect(bounds().bottom, greaterThan(centeredPanel.bottom));
      expect(tester.widget<TextField>(field).focusNode!.hasFocus, isFalse);
      await tester.tapAt(source.center);
      final midway = bounds();
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(bounds(), midway);
      await tester.pumpAndSettle();
      expect(field, findsNothing);
      expect(tester.testTextInput.isVisible, isFalse);
      respond(Api.searchTrending, {'code': -1, 'message': '测试超时'});
      respond(Api.searchRecommend, {'code': -1, 'message': '测试超时'});
      await tester.pump();

      await tester.tap(searchBar);
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 299));
      expect(tester.widget<TextField>(field).focusNode!.hasFocus, isFalse);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(field).focusNode!.hasFocus, isTrue);
      expect(
        (tester.widget<TextField>(field).decoration!.hint as Text).data,
        '首页提示词',
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 250);
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(field, findsOneWidget);
      expect(tester.widget<TextField>(field).focusNode!.hasFocus, isFalse);
      tester.view.resetViewInsets();
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(searchBar, findsOneWidget);
    },
  );

  testWidgets('slow discovery does not move history or block its selection', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(searchBar);
    await tester.pumpAndSettle();
    expect(
      pending.keys,
      containsAll([Api.searchTrending, Api.searchRecommend]),
    );
    final chip = find.byWidgetPredicate(
      (w) => w is SearchText && w.text == history,
    );
    final before = tester.getRect(chip);
    respond(Api.searchRecommend, {'code': -1, 'message': '弱网失败'});
    await tester.pumpAndSettle();
    expect(tester.getRect(chip), before);
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(find.text('结果 $history'), findsOneWidget);
    respond(Api.searchTrending, {
      'code': 0,
      'data': {
        'list': [
          {'keyword': '稍后到达的热搜'},
        ],
      },
    });
    Get.back<void>();
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field).controller!.text, history);
    expect(tester.getRect(chip), before);
    expect(find.text('稍后到达的热搜'), findsOneWidget);
  });

  testWidgets(
    'painted nonempty prompt survives the first frame and interruption',
    (tester) async {
      final frameKey = GlobalKey();
      await start(tester, frameKey: frameKey);
      final box = tester.getRect(find.text('搜索视频、UP主'));
      final boundary =
          frameKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      Future<Set<int>> promptInk() async => (await tester.runAsync(() async {
        final image = await boundary.toImage();
        final pixels = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        final width = image.width;
        image.dispose();
        return {
          for (int y = box.top.floor(); y < box.bottom.ceil(); y++)
            for (int x = box.left.floor(); x < box.left.floor() + 105; x++)
              if (pixels.getUint8((y * width + x) * 4 + 1) < 190) y * width + x,
        };
      }))!;
      final original = await promptInk();
      expect(original.length, greaterThan(20));
      await tester.tap(searchBar);
      await tester.pump();
      await tester.pump();
      final first = await promptInk();
      expect(
        first.intersection(original).length,
        greaterThan(original.length * .9),
      );
      await tester.pump(const Duration(milliseconds: 75));
      expect((await promptInk()).length, greaterThan(20));
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(await promptInk(), original);
      expect(tester.testTextInput.isVisible, isFalse);
    },
  );

  testWidgets(
    'reduced motion keeps the normal route with empty history and recording off',
    (tester) async {
      await tester.runAsync(() async {
        await GStorage.setting.put(SettingBoxKey.recordSearchHistory, false);
        await GStorage.historyWord.delete('cacheList');
      });
      await start(tester, reduceMotion: true);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      expect(
        ModalRoute.of(tester.element(field))!.transitionDuration,
        Duration.zero,
      );
      expect(find.text('搜索历史'), findsNothing);
      await tester.enterText(field, '新关键词');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text('结果 新关键词'), findsOneWidget);
      expect(GStorage.historyWord.get('cacheList'), isNull);
    },
  );

  testWidgets('no-animation preference bypasses the source expansion', (
    tester,
  ) async {
    await tester.runAsync(
      () => GStorage.setting.put(
        SettingBoxKey.pageTransition,
        Transition.noTransition.index,
      ),
    );
    await start(tester);
    await tester.tap(searchBar);
    await tester.pumpAndSettle();
    expect(
      ModalRoute.of(tester.element(field))!.transitionDuration,
      Duration.zero,
    );
    expect(tester.widget<TextField>(field).focusNode!.hasFocus, isTrue);
  });

  testWidgets(
    'rotation preserves search input and returns without a stale portrait clip',
    (tester) async {
      await start(tester);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      await tester.enterText(field, '横竖屏输入');
      tester.view.physicalSize = const Size(800, 450);
      await tester.pumpAndSettle();
      expect(find.text('横竖屏输入'), findsOneWidget);
      expect(find.text('搜索历史'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pump(const Duration(milliseconds: 120));
      expect(
        find.ancestor(of: field, matching: find.byType(FadeTransition)),
        findsWidgets,
      );
      await tester.pumpAndSettle();
      expect(field, findsNothing);
    },
  );

  testWidgets(
    'a late suggestion cannot replace the current query suggestions',
    (tester) async {
      await tester.runAsync(() async {
        await GStorage.setting.put(SettingBoxKey.searchSuggestion, true);
        await GStorage.localCache.putAll({
          LocalCacheKey.timeStamp: DateTime.now().millisecondsSinceEpoch,
          LocalCacheKey.mixinKey: 'fixture',
        });
      });
      await start(tester);
      await tester.tap(searchBar);
      await tester.pumpAndSettle();
      for (final query in ['先输入', '后输入']) {
        await tester.enterText(field, query);
        await tester.pump(const Duration(milliseconds: 210));
      }
      Map<String, dynamic> suggestions(String text) => {
        'code': 0,
        'data': {
          'result': {
            'tag': [
              {'term': text, 'name': text},
            ],
          },
        },
      };
      respond('后输入', suggestions('新联想'));
      await tester.pumpAndSettle();
      expect(find.text('新联想', findRichText: true), findsOneWidget);
      respond('先输入', suggestions('旧联想'));
      await tester.pumpAndSettle();
      expect(find.text('新联想', findRichText: true), findsOneWidget);
      expect(find.text('旧联想', findRichText: true), findsNothing);
    },
  );
}
