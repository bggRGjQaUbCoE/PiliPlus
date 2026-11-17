import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File;

import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mall/view.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/soft_dynamic_colors.dart';
import 'package:PiliPlus/pages/mall/navigation.dart';
import 'package:PiliPlus/pages/mall/webview.dart';
import 'package:PiliPlus/pages/webview/view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

class _Controller extends PlatformInAppWebViewController {
  _Controller(super.params) : super.implementation();
  final calls = <String>[];
  final loads = <Uri>[];
  final handlers = <String>[];
  final sources = <String>[];
  bool back = false;
  bool popup = false;
  bool aftersaleTemplate = false;
  String? accountAppShortcut;
  WebHistory? history;
  bool disposed = false;
  int reloads = 0;
  InAppWebViewController get facade =>
      InAppWebViewController.fromPlatform(platform: this);
  PlatformWebViewCreationParams get events => params.webviewParams!;
  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    sources.add(source);
    if (source.contains('dismissOverlay()')) {
      calls.add('popup');
      return popup;
    }
    if (source.contains('activeElement')) calls.add('blur');
    if (source.contains('dataset.ppPage')) return aftersaleTemplate;
    if (source.contains('accountAppShortcut(')) return accountAppShortcut;
    return null;
  }

  @override
  Future<bool> canGoBack() async {
    calls.add('canGoBack');
    return back;
  }

  @override
  Future<WebHistory?> getCopyBackForwardList() async => history;

  @override
  Future<void> goBack() async {
    calls.add('goBack');
  }

  @override
  Future<void> goBackOrForward({required int steps}) async {
    calls.add('goBackOrForward:$steps');
  }

  @override
  Future<void> clearFocus() async {
    calls.add('clearFocus');
  }

  @override
  Future<void> reload() async {
    reloads++;
  }

  @override
  Future<void> stopLoading() async {
    calls.add('stop');
  }

  @override
  Future<void> loadUrl({
    required URLRequest urlRequest,
    Uri? iosAllowingReadAccessTo,
    WebUri? allowingReadAccessTo,
  }) async {
    loads.add(urlRequest.url!.uriValue);
  }

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required JavaScriptHandlerCallback callback,
  }) {
    handlers.add(handlerName);
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    disposed = true;
  }
}

class _Platform extends InAppWebViewPlatform {
  final controllers = <_Controller>[];
  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) => _WebWidget(params, this);
}

class _WebWidget extends PlatformInAppWebViewWidget {
  _WebWidget(super.params, this.owner) : super.implementation();
  final _Platform owner;
  @override
  Widget build(BuildContext context) =>
      _NativeStub(key: params.key, params: params, owner: owner);
  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) =>
      params.controllerFromPlatform!(controller) as T;
  @override
  void dispose() {}
}

class _NativeStub extends StatefulWidget {
  const _NativeStub({super.key, required this.params, required this.owner});
  final PlatformInAppWebViewWidgetCreationParams params;
  final _Platform owner;
  @override
  State<_NativeStub> createState() => _NativeStubState();
}

class _NativeStubState extends State<_NativeStub> {
  late final _Controller controller;
  @override
  void initState() {
    super.initState();
    controller = _Controller(
      PlatformInAppWebViewControllerCreationParams(
        id: widget.owner.controllers.length,
        webviewParams: widget.params,
      ),
    );
    widget.owner.controllers.add(controller);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.params.onWebViewCreated?.call(controller.facade),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

class _AccountService extends AccountService {
  @override
  // The fixture publishes controlled sessions without reading cached user data.
  // ignore: must_call_super
  void onInit() {}
}

class _Shell extends MainController {
  @override
  // This shell fixture does not start polling or allocate a TabController.
  // ignore: must_call_super
  void onInit() {}
  @override
  // ignore: must_call_super
  void onClose() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('piliplus-mall-webview-');
    Hive.init(directory.path);
    GStorage.setting = await Hive.openBox('setting');
    // Serve the real source bytes deterministically inside the fake async zone.
    final assets = <String, ByteData>{};
    for (final name in [
      'adapter.js',
      'home.css',
      'core.css',
      'detail.css',
      'secondary.css',
    ]) {
      final bytes = await File('assets/mall/$name').readAsBytes();
      assets['assets/mall/$name'] = bytes.buffer.asByteData();
    }
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
          'flutter/assets',
          (message) async =>
              assets[utf8.decode(
                message!.buffer.asUint8List(
                  message.offsetInBytes,
                  message.lengthInBytes,
                ),
              )],
        );
    rootBundle.clear();
  });
  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
    rootBundle.clear();
    await Hive.close();
    await directory.delete(recursive: true);
  });
  late _Platform platform;
  late GlobalKey<MallWebViewState> key;
  setUp(() {
    rootBundle.clear();
    platform = _Platform();
    InAppWebViewPlatform.instance = platform;
    key = GlobalKey();
    Get.testMode = true;
  });
  tearDown(Get.reset);
  Widget app({
    double keyboard = 0,
    ThemeData? theme,
    double textScale = 1,
    Uri? initialUrl,
    ValueNotifier<double?>? visibility,
  }) => GetMaterialApp(
    theme: theme,
    getPages: [
      GetPage(
        name: '/loginPage',
        page: () => const Scaffold(body: Text('原生登录验证页')),
      ),
    ],
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        viewInsets: EdgeInsets.only(bottom: keyboard),
        textScaler: TextScaler.linear(textScale),
      ),
      child: MallWebView(
        key: key,
        initialUrl: initialUrl,
        bottomVisibility: visibility,
        onRootBack: () {},
        adapterSource: '// adapter fixture',
        homeStyleSource: '/* home style fixture */',
        bottomOverlayInset: 107,
      ),
    ),
  );

  testWidgets(
    'visible bottom inset changes without rebuilding the browser and keyboard removes it',
    (tester) async {
      final visibility = ValueNotifier<double?>(1);
      await tester.pumpWidget(app(visibility: visibility));
      await tester.pumpAndSettle();
      final browser = platform.controllers.single;
      browser.sources.clear();
      visibility.value = .5;
      await tester.pump(const Duration(milliseconds: 40));
      expect(browser.sources.single, contains(', 53.5)'));
      visibility.value = 0;
      await tester.pump(const Duration(milliseconds: 40));
      expect(browser.sources.last, contains(', 0.0)'));
      visibility.value = 1;
      await tester.pumpWidget(app(visibility: visibility, keyboard: 250));
      await tester.pump(const Duration(milliseconds: 40));
      expect(browser.sources.last, contains(', 0.0)'));
      expect(platform.controllers, hasLength(1));
      expect(browser.reloads, 0);
      await tester.pumpWidget(const SizedBox());
      visibility.dispose();
    },
  );

  testWidgets(
    'web back from an unknown official child restores its page without opening another route',
    (tester) async {
      final url = Uri.parse(
        'https://mall.bilibili.com/neul-next/index.html?page=flow_searchResult&keyword=test',
      );
      await tester.pumpWidget(app(initialUrl: url));
      await tester.pump();
      final controller = platform.controllers.single;
      controller.events.onLoadStart!(
        controller.facade,
        WebUri('https://mall.bilibili.com/unknown.html'),
      );
      controller.back = true;
      expect(await key.currentState!.goBack(), isTrue);
      controller.events.onUpdateVisitedHistory!(controller.facade, null, false);
      controller.events.onUpdateVisitedHistory!(
        controller.facade,
        WebUri.uri(url),
        false,
      );
      await tester.pump();
      expect(platform.controllers, hasLength(1));
      expect(controller.calls, contains('goBack'));
      expect(find.text('搜索'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'a home cart link opens one secondary view and leaves its parent unloaded',
    (tester) async {
      Get.put<AccountService>(_AccountService()).webSession.value =
          Future.value();
      Get.put<MainController>(_Shell());
      await tester.pumpWidget(app());
      await tester.pump();
      final parent = platform.controllers.single;
      final policy = await parent.events.shouldOverrideUrlLoading!(
        parent.facade,
        NavigationAction(
          request: URLRequest(url: WebUri(MallDestination.cart.url)),
          isForMainFrame: true,
        ),
      );
      expect(policy, NavigationActionPolicy.CANCEL);
      await tester.pumpAndSettle();
      expect(parent.loads, isEmpty);
      expect(platform.controllers, hasLength(2));
      expect(
        platform
            .controllers
            .last
            .events
            .initialUrlRequest!
            .url!
            .uriValue
            .queryParameters['page'],
        'mall_cart',
      );
      expect(find.text('分类'), findsNothing);
      Get.back();
      await tester.pumpAndSettle();
      expect(parent.disposed, isFalse);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'a secondary product retains one WebView without homepage tools',
    (tester) async {
      final url = Uri.parse(
        'https://mall.bilibili.com/neul-next/detailuniversal/detail.html?page=detailuniversal_detail&itemsId=10120458',
      );
      await tester.pumpWidget(app(initialUrl: url));
      await tester.pump();
      final controller = platform.controllers.single;
      expect(controller.events.initialUrlRequest!.url!.uriValue, url);
      expect(find.text('商品详情'), findsOneWidget);
      expect(find.text('分类'), findsNothing);
      expect(find.text('购物车'), findsNothing);
      expect(find.byTooltip('票务工具'), findsNothing);
      controller.events.onUpdateVisitedHistory!(
        controller.facade,
        WebUri(
          url
              .replace(queryParameters: {...url.queryParameters, 'skuId': '1'})
              .toString(),
        ),
        false,
      );
      await tester.pump();
      expect(platform.controllers, hasLength(1));
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'mall settings do not change ordinary WebView behavior or share injection',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      final mall = platform.controllers.single;
      expect(mall.events.initialSettings!.forceDark, ForceDark.OFF);
      expect(mall.events.initialSettings!.algorithmicDarkeningAllowed, isFalse);
      // Verify the existing constructor contract; the plugin deprecates this field.
      // ignore: deprecated_member_use
      expect(mall.events.initialSettings!.clearCache, isFalse);
      expect(mall.events.shouldInterceptRequest, isNull);
      expect(mall.events.initialUserScripts!.single.forMainFrameOnly, isTrue);
      expect(mall.handlers, ['piliMallScroll']);
      await tester.pumpWidget(
        const GetMaterialApp(
          home: WebviewPage(url: 'https://www.bilibili.com/'),
        ),
      );
      await tester.pump();
      final ordinary = platform.controllers.last;
      expect(ordinary.events.initialSettings!.forceDark, ForceDark.AUTO);
      // ignore: deprecated_member_use
      expect(ordinary.events.initialSettings!.clearCache, isTrue);
      expect(ordinary.events.initialUserScripts, isNull);
      expect(ordinary.events.shouldInterceptRequest, isNotNull);
      expect(ordinary.handlers, ['finishButtonClicked', 'infoBarClicked']);
    },
  );

  testWidgets(
    'settled native themes reach the existing page without reload or duplicate view',
    (tester) async {
      final schemes = [
        for (final brightness in Brightness.values)
          for (final seed in [const Color(0xff6750a4), const Color(0xff006c4c)])
            for (final soft in [false, true])
              (brightness: brightness, seed: seed, soft: soft),
      ];
      await tester.pumpWidget(app());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      final controller = platform.controllers.single;
      for (final sample in schemes) {
        final raw = ColorScheme.fromSeed(
          seedColor: sample.seed,
          brightness: sample.brightness,
        );
        final scheme = sample.soft ? SoftDynamicColors.apply(raw) : raw;
        final theme = ThemeData(colorScheme: scheme);
        controller.sources.clear();
        Get.changeTheme(theme);
        await tester.pumpAndSettle(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 120));
        final source = controller.sources.last;
        final encoded = source.substring(
          source.indexOf('update(') + 7,
          source.length - 2,
        );
        final config = jsonDecode(encoded) as Map<String, dynamic>;
        final variables = config['theme'] as Map<String, dynamic>;
        expect(variables['color-scheme'], sample.brightness.name);
        String hex(Color color) =>
            '#${(color.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0')}ff';
        expect(variables['surface'], hex(theme.scaffoldBackgroundColor));
        expect(variables['card'], hex(scheme.surfaceContainerLow));
        expect(variables['primary'], hex(scheme.primary));
        expect(variables['on-primary'], hex(scheme.onPrimary));
        expect(variables['primary-container'], hex(scheme.primaryContainer));
        expect(
          variables['on-primary-container'],
          hex(scheme.onPrimaryContainer),
        );
        expect(variables['on-surface'], hex(scheme.onSurface));
        expect(
          variables['font-size'],
          Theme.of(tester.element(find.byType(MallWebView)))
              .textTheme
              .bodyMedium!
              .fontSize,
        );
        expect(config['homeStyle'], '/* home style fixture */');
        expect(
          controller.sources.length,
          1,
          reason: 'AnimatedTheme must not inject every frame',
        );
        final first = scheme.onSurface.computeLuminance();
        final second = scheme.surfaceContainerLow.computeLuminance();
        expect(
          (first > second
              ? (first + .05) / (second + .05)
              : (second + .05) / (first + .05)),
          greaterThanOrEqualTo(4.5),
        );
        final searchText = scheme.onSurfaceVariant.computeLuminance();
        final searchFill = scheme.surfaceContainerHigh.computeLuminance();
        expect(
          (searchText > searchFill
              ? (searchText + .05) / (searchFill + .05)
              : (searchFill + .05) / (searchText + .05)),
          greaterThanOrEqualTo(4.5),
        );
      }
      expect(platform.controllers.length, 1);
      expect(controller.loads, isEmpty);
      expect(controller.reloads, 0);
      expect(controller.disposed, isFalse);
    },
  );

  testWidgets(
    'web typography and card overrides follow the native theme without reload',
    (tester) async {
      await tester.pumpWidget(
        app(
          theme: ThemeData(
            cardTheme: const CardThemeData(color: Color(0xff080808)),
          ),
          textScale: 1.3,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      final controller = platform.controllers.single;
      final source = controller.sources.last;
      final config = jsonDecode(
        source.substring(source.indexOf('update(') + 7, source.length - 2),
      ) as Map<String, dynamic>;
      final variables = config['theme'] as Map<String, dynamic>;
      expect(variables['font-size'], closeTo(18.2, .001));
      expect(variables['label-size'], closeTo(15.6, .001));
      expect(variables['card'], '#080808ff');
      expect(find.text('商城账户'), findsOneWidget);
      expect(controller.reloads, 0);
    },
  );

  testWidgets(
    'ticket tools open independent official pages with the native toolbar',
    (tester) async {
      Get.put<AccountService>(_AccountService()).webSession.value =
          Future.value();
      Get.put<MainController>(_Shell());
      await tester.pumpWidget(app());
      await tester.pump();
      final parent = platform.controllers.single;
      await tester.tap(find.byTooltip('票务工具'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(MallTicketDestination.movie.label));
      await tester.pumpAndSettle();
      expect(parent.loads, isEmpty);
      expect(platform.controllers, hasLength(2));
      expect(
        platform.controllers.last.events.initialUrlRequest!.url!.uriValue,
        Uri.parse(MallTicketDestination.movie.url),
      );
      expect(find.text(MallPageKind.ticketMovie.label), findsOneWidget);
      expect(find.byTooltip('票务工具'), findsOneWidget);
      Get.back<void>();
      await tester.pumpAndSettle();
      expect(parent.disposed, isFalse);
    },
  );

  testWidgets(
    'ticket activity opens as a native secondary page and event links open event details',
    (tester) async {
      Get.put<AccountService>(_AccountService()).webSession.value =
          Future.value();
      Get.put<MainController>(_Shell());
      await tester.pumpWidget(app());
      await tester.pump();
      final home = platform.controllers.single;
      await tester.tap(find.byTooltip('票务工具'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(MallTicketDestination.activity.label).last);
      await tester.pumpAndSettle();

      expect(home.loads, isEmpty);
      expect(platform.controllers, hasLength(2));
      final activity = platform.controllers.last;
      expect(
        activity.events.initialUrlRequest!.url!.uriValue,
        Uri.parse(MallTicketDestination.activity.url),
      );
      expect(find.text('漫展演出'), findsOneWidget);

      final detail = Uri.parse(
        'https://show.bilibili.com/platform/detail.html?id=113289',
      );
      final policy = await activity.events.shouldOverrideUrlLoading!(
        activity.facade,
        NavigationAction(
          request: URLRequest(url: WebUri.uri(detail)),
          isForMainFrame: true,
        ),
      );
      expect(policy, NavigationActionPolicy.CANCEL);
      await tester.pumpAndSettle();
      expect(platform.controllers, hasLength(3));
      expect(
        platform.controllers.last.events.initialUrlRequest!.url!.uriValue,
        detail,
      );
      expect(find.text('活动详情'), findsOneWidget);

      Get.back<void>();
      await tester.pumpAndSettle();
      expect(activity.disposed, isFalse);
      expect(find.text('漫展演出'), findsOneWidget);

      await tester.tap(find.byTooltip('票务工具'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(MallTicketDestination.collection.label));
      await tester.pumpAndSettle();
      expect(
        platform.controllers.last.events.initialUrlRequest!.url!.uriValue,
        Uri.parse(MallTicketDestination.collection.url),
      );
      expect(find.text(MallPageKind.ticketCollection.label), findsOneWidget);
      Get.back<void>();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('票务工具'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(MallTicketDestination.order.label));
      await tester.pumpAndSettle();
      expect(
        platform.controllers.last.events.initialUrlRequest!.url!.uriValue,
        Uri.parse(MallTicketDestination.order.url),
      );
      expect(find.text(MallPageKind.ticketOrder.label), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'ticket login return reuses its existing secondary page',
    (tester) async {
      final url = Uri.parse(MallTicketDestination.collection.url);
      await tester.pumpWidget(app(initialUrl: url));
      await tester.pump();
      final controller = platform.controllers.single;
      controller.events.onLoadStart!(
        controller.facade,
        WebUri('https://passport.bilibili.com/h5-app/passport/login'),
      );
      final policy = await controller.events.shouldOverrideUrlLoading!(
        controller.facade,
        NavigationAction(
          request: URLRequest(url: WebUri.uri(url)),
          isForMainFrame: true,
        ),
      );
      expect(policy, NavigationActionPolicy.ALLOW);
      expect(platform.controllers, hasLength(1));
      expect(controller.loads, isEmpty);
    },
  );

  testWidgets(
    'back consumes keyboard then popup then history, root yields to shell',
    (tester) async {
      final keyboardCalls = <String>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.textInput, (call) async {
            keyboardCalls.add(call.method);
            return null;
          });
      await tester.pumpWidget(app(keyboard: 250));
      await tester.pump();
      final controller = platform.controllers.single..back = true;
      expect(await key.currentState!.goBack(), isTrue);
      expect(controller.calls, ['blur', 'clearFocus']);
      expect(keyboardCalls, contains('TextInput.hide'));
      await tester.pumpWidget(app());
      await tester.pump();
      controller.calls.clear();
      controller.popup = true;
      expect(await key.currentState!.goBack(), isTrue);
      expect(controller.calls, ['popup']);
      controller.popup = false;
      expect(await key.currentState!.goBack(), isTrue);
      expect(controller.calls.last, 'goBack');
      controller.back = false;
      expect(await key.currentState!.goBack(), isFalse);
    },
  );

  testWidgets(
    'back skips the no-referrer marker without losing the previous page',
    (tester) async {
      const url = 'https://mall.bilibili.com/orderlist.html?hashstatus=3';
      await tester.pumpWidget(app(initialUrl: Uri.parse(url)));
      await tester.pump();
      final controller = platform.controllers.single
        ..back = true
        ..history = WebHistory(
          currentIndex: 2,
          list: [
            WebHistoryItem(
              url: WebUri(
                'https://mall.bilibili.com/orderlist.html?hashstatus=0',
              ),
            ),
            WebHistoryItem(url: WebUri(url)),
            WebHistoryItem(url: WebUri('$url#noReffer=true')),
          ],
        );
      expect(await key.currentState!.goBack(), isTrue);
      expect(controller.calls.last, 'goBackOrForward:-2');
    },
  );

  testWidgets(
    'an initial document redirect does not trap back in the same secondary page',
    (tester) async {
      final entry = WebUri(
        'https://mall.bilibili.com/neul/index.html?page=aftersale_aftersaleList',
      );
      final landing = WebUri('https://mall.bilibili.com/neul-next/index.html');
      await tester.pumpWidget(app(initialUrl: entry.uriValue));
      await tester.pump();
      final controller = platform.controllers.single
        ..back = true
        ..history = WebHistory(
          currentIndex: 0,
          list: [WebHistoryItem(url: entry)],
        );
      controller.events.onLoadStop!(controller.facade, entry);
      await tester.pump();
      controller
        ..aftersaleTemplate = true
        ..history = WebHistory(
          currentIndex: 1,
          list: [
            WebHistoryItem(url: entry),
            WebHistoryItem(url: landing),
          ],
        );
      controller.events.onLoadStart!(controller.facade, landing);
      await tester.pump();
      controller.events.onLoadStop!(controller.facade, landing);
      await tester.pump();
      expect(await key.currentState!.goBack(), isFalse);
      expect(controller.calls, isNot(contains('goBack')));
    },
  );

  testWidgets(
    'main document errors are visible, subresources and obsolete loads are ignored',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      final controller = platform.controllers.single;
      final error = WebResourceError(
        type: WebResourceErrorType.HOST_LOOKUP,
        description: 'offline',
      );
      controller.events.onReceivedError!(
        controller.facade,
        WebResourceRequest(
          url: WebUri('https://i0.hdslb.com/image.jpg'),
          isForMainFrame: false,
        ),
        error,
      );
      await tester.pump();
      expect(find.text('重新加载'), findsNothing);
      controller.events.onReceivedError!(
        controller.facade,
        WebResourceRequest(
          url: WebUri(MallDestination.home.url),
          isForMainFrame: true,
        ),
        error,
      );
      await tester.pump();
      expect(find.text('重新加载'), findsOneWidget);
      expect(controller.reloads, 0);
      await tester.tap(find.text('重新加载'));
      await tester.pump();
      expect(controller.reloads, 1);
      expect(find.text('重新加载'), findsNothing);
      controller.events.onUpdateVisitedHistory!(
        controller.facade,
        WebUri('https://mall.bilibili.com/?view=changed'),
        false,
      );
      controller.events.onReceivedError!(
        controller.facade,
        WebResourceRequest(
          url: WebUri(MallDestination.home.url),
          isForMainFrame: true,
        ),
        error,
      );
      await tester.pump();
      expect(find.text('重新加载'), findsNothing);
    },
  );

  testWidgets(
    'renderer exit removes dead view and recreates only after explicit retry',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      final controller = platform.controllers.single;
      controller.events.onRenderProcessGone!(
        controller.facade,
        RenderProcessGoneDetail(didCrash: true),
      );
      await tester.pump();
      expect(controller.disposed, isTrue);
      expect(find.text('网页渲染进程已退出，请重新加载'), findsOneWidget);
      expect(platform.controllers.length, 1);
      controller.events.onReceivedError!(
        controller.facade,
        WebResourceRequest(
          url: WebUri(MallDestination.home.url),
          isForMainFrame: true,
        ),
        WebResourceError(
          type: WebResourceErrorType.HOST_LOOKUP,
          description: 'late event',
        ),
      );
      controller.events.onLoadStart!(
        controller.facade,
        WebUri(MallDestination.home.url),
      );
      await tester.pump();
      expect(find.text('网页渲染进程已退出，请重新加载'), findsOneWidget);
      final retry = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .onPressed!;
      retry();
      retry();
      await tester.pump();
      await tester.pump();
      expect(platform.controllers.length, 2);
      expect(
        platform.controllers.last.events.initialUrlRequest!.url.toString(),
        MallDestination.home.url,
      );
    },
  );

  testWidgets(
    'new-window transport ID is adopted; closing returns to retained parent',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      final parent = platform.controllers.single;
      final accepted = await parent.events.onCreateWindow!(
        parent.facade,
        CreateWindowAction(
          windowId: 42,
          request: URLRequest(url: WebUri('about:blank')),
          isForMainFrame: true,
        ),
      );
      expect(accepted, isTrue);
      await tester.pump();
      await tester.pump();
      expect(platform.controllers.length, 2);
      final child = platform.controllers.last
        ..back = true
        ..history = WebHistory(
          currentIndex: 1,
          list: [
            WebHistoryItem(url: WebUri('about:blank')),
            WebHistoryItem(
              url: WebUri('https://mall.bilibili.com/unknown.html'),
            ),
          ],
        );
      expect(child.events.windowId, 42);
      expect(child.events.initialUrlRequest, isNull);
      expect(await key.currentState!.goBack(), isTrue);
      await tester.pump();
      expect(child.disposed, isTrue);
      expect(parent.disposed, isFalse);
      expect(platform.controllers.length, 2);
    },
  );

  testWidgets(
    'the verified account ticket shortcut offers the official app guide',
    (tester) async {
      await tester.pumpWidget(
        app(initialUrl: Uri.parse(MallDestination.account.url)),
      );
      await tester.pump();
      final controller = platform.controllers.single
        ..accountAppShortcut = 'ticket';
      final result = controller.events.shouldOverrideUrlLoading!(
        controller.facade,
        NavigationAction(
          request: URLRequest(
            url: WebUri('bilibili://mall/test-ticket-shortcut'),
          ),
          isForMainFrame: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('在哔哩哔哩打开电子票'), findsOneWidget);
      expect(find.textContaining('会员购中心 → 我的订单'), findsOneWidget);
      await tester.tap(find.text('知道了'));
      await tester.pumpAndSettle();
      expect(await result, NavigationActionPolicy.CANCEL);
      expect(controller.loads, isEmpty);
      expect(controller.disposed, isFalse);
    },
  );

  testWidgets(
    'the receiving shortcut opens the official filtered order list inside the app',
    (tester) async {
      Get.put<AccountService>(_AccountService()).webSession.value =
          Future.value();
      Get.put<MainController>(_Shell());
      await tester.pumpWidget(
        app(initialUrl: Uri.parse(MallDestination.account.url)),
      );
      await tester.pump();
      final parent = platform.controllers.single
        ..accountAppShortcut = 'receiving';
      final result = await parent.events.shouldOverrideUrlLoading!(
        parent.facade,
        NavigationAction(
          request: URLRequest(
            url: WebUri('bilibili://mall/test-receiving-shortcut'),
          ),
          isForMainFrame: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(result, NavigationActionPolicy.CANCEL);
      expect(platform.controllers, hasLength(2));
      expect(
        platform
            .controllers
            .last
            .events
            .initialUrlRequest!
            .url!
            .queryParameters['hashstatus'],
        '3',
      );
      expect(find.text('打开外部链接'), findsNothing);
      Get.back<void>();
      await tester.pumpAndSettle();
      expect(parent.disposed, isFalse);
    },
  );

  testWidgets(
    'redirect mapping is main-frame only and preserves official cart arguments',
    (tester) async {
      await tester.pumpWidget(
        app(initialUrl: Uri.parse(MallDestination.cart.url)),
      );
      await tester.pump();
      final controller = platform.controllers.single;
      final target = WebUri('https://mall.bilibili.com/cart.html?noTitleBar=1');
      expect(
        await controller.events.shouldOverrideUrlLoading!(
          controller.facade,
          NavigationAction(
            request: URLRequest(url: target),
            isForMainFrame: false,
          ),
        ),
        NavigationActionPolicy.ALLOW,
      );
      expect(controller.loads, isEmpty);
      expect(
        await controller.events.shouldOverrideUrlLoading!(
          controller.facade,
          NavigationAction(
            request: URLRequest(url: target),
            isForMainFrame: true,
          ),
        ),
        NavigationActionPolicy.CANCEL,
      );
      expect(controller.loads.single.queryParameters['page'], 'mall_cart');
      expect(controller.loads.single.queryParameters['noTitleBar'], '1');
    },
  );

  testWidgets(
    'external navigation requires a user decision and never loads into mall',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      final controller = platform.controllers.single;
      final action = controller.events.shouldOverrideUrlLoading!(
        controller.facade,
        NavigationAction(
          request: URLRequest(url: WebUri('https://example.org/')),
          isForMainFrame: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('打开外部链接'), findsOneWidget);
      final duplicate = await controller.events.shouldOverrideUrlLoading!(
        controller.facade,
        NavigationAction(
          request: URLRequest(url: WebUri('https://example.org/')),
          isForMainFrame: true,
        ),
      );
      expect(duplicate, NavigationActionPolicy.CANCEL);
      expect(find.text('打开外部链接'), findsOneWidget);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(await action, NavigationActionPolicy.CANCEL);
      expect(controller.loads, isEmpty);
      expect(platform.controllers.length, 1);
    },
  );

  testWidgets(
    'official expired-login redirect uses existing native login and retains cancelled page',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pump();
      final controller = platform.controllers.single;
      for (final path in ['/login', '/h5-app/passport/login']) {
        final action = controller.events.shouldOverrideUrlLoading!(
          controller.facade,
          NavigationAction(
            request: URLRequest(
              url: WebUri(
                'https://passport.bilibili.com$path?gourl=https%3A%2F%2Fmall.bilibili.com',
              ),
            ),
            isForMainFrame: true,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('原生登录验证页'), findsOneWidget);
        Get.back();
        await tester.pumpAndSettle();
        expect(await action, NavigationActionPolicy.CANCEL);
        expect(controller.disposed, isFalse);
        expect(controller.loads, isEmpty);
      }
    },
  );

  testWidgets(
    'account change removes old pages immediately and waits for synchronization',
    (tester) async {
      final account = Get.put<AccountService>(_AccountService());
      Get.put<MainController>(_Shell());
      account.webSession.value = Future.value();
      await tester.pumpWidget(const GetMaterialApp(home: MallPage()));
      await tester.pumpAndSettle();
      final original = platform.controllers.single;
      final pending = Completer<void>();
      account.webSession.value = pending.future;
      await tester.pump();
      expect(original.disposed, isTrue);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(platform.controllers.length, 1);
      pending.complete();
      await tester.pumpAndSettle();
      expect(platform.controllers.length, 2);
      final replacement = platform.controllers.last;
      final failed = Completer<void>();
      account.webSession.value = failed.future;
      await tester.pump();
      failed.completeError(
        PlatformException(
          code: 'cookie_sync_failed',
          details: {'SESSDATA': 'secret-test-value'},
        ),
      );
      await tester.pumpAndSettle();
      expect(replacement.disposed, isTrue);
      expect(find.text('商城登录态同步失败，请重试'), findsOneWidget);
      expect(find.textContaining('secret-test-value'), findsNothing);
      expect(platform.controllers.length, 2);
    },
  );
}
