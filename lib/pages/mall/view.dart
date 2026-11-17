import 'dart:async';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/scroll_intent.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mall/webview.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MallPage extends StatefulWidget {
  const MallPage({super.key, this.initialUrl});
  final Uri? initialUrl;

  static const homeUrl = 'https://mall.bilibili.com/';

  @override
  State<MallPage> createState() => _MallPageState();
}

class _MallPageState extends State<MallPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final _mainController = Get.find<MainController>();
  GlobalKey<MallWebViewState> _webKey = GlobalKey();
  late final _scriptReady = Future.wait([
    rootBundle.loadString('assets/mall/adapter.js'),
    rootBundle.loadString('assets/mall/home.css'),
    rootBundle.loadString('assets/mall/core.css'),
    rootBundle.loadString('assets/mall/detail.css'),
    rootBundle.loadString('assets/mall/secondary.css'),
  ]);
  late Future<List<String>> _ready;
  late final StreamSubscription<Future<void>?> _accountListener;
  final _scrollIntent = ScrollVisibility();
  bool _tickerEnabled = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = TickerMode.valuesOf(context).enabled;
    if (enabled && !_tickerEnabled) {
      _scrollIntent.reset();
      _mainController.restoreBars();
    }
    _tickerEnabled = enabled;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _tickerEnabled) {
      _scrollIntent.reset();
      _mainController.restoreBars();
    }
  }

  void _onPageScroll(double delta, bool ended, bool atTop) {
    if (!_mainController.useBottomNav ||
        !_tickerEnabled ||
        _mainController.navigationBars[_mainController.selectedIndex.value] !=
            NavigationBarType.mall) {
      return;
    }
    final intent = _scrollIntent.updateDelta(delta);
    if (atTop) {
      _scrollIntent.reset();
      _mainController.restoreBars();
      return;
    }
    final offset = _mainController.barOffset;
    if (offset != null) {
      if (!ended && _mainController.bottomBarSettling.value) {
        if (_mainController.bottomNavVisibility.value case final visibility?) {
          offset.value = (1 - visibility) * Style.topBarHeight;
        }
      }
      _mainController.bottomBarSettling.value = ended;
      if (ended) {
        offset.value = offset.value < Style.topBarHeight / 2
            ? 0
            : Style.topBarHeight;
      } else if (intent != null) {
        offset.value = (offset.value + delta).clamp(0.0, Style.topBarHeight);
      }
    } else if (intent != null) {
      _mainController.showBottomBar?.value = intent == .forward;
    }
    if (ended) _scrollIntent.reset();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final accountService = Get.find<AccountService>();
    _ready = (accountService.webSession.value ?? LoginUtils.syncMallWebCookie())
        .then((_) => _scriptReady);
    if (widget.initialUrl == null) _mainController.mallGoBack = _goBack;
    _accountListener = accountService.webSession.listen((ready) {
      if (ready == null) return;
      setState(() {
        _webKey = GlobalKey();
        _ready = ready.then((_) => _scriptReady);
      });
    });
  }

  Future<bool> _goBack() async => await _webKey.currentState?.goBack() == true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _accountListener.cancel();
    if (_mainController.mallGoBack == _goBack) {
      _mainController.mallGoBack = null;
    }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final page = FutureBuilder<List<String>>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('商城登录态同步失败，请重试'),
                TextButton(
                  onPressed: () => setState(() {
                    _ready = LoginUtils.syncMallWebCookie().then(
                      (_) => _scriptReady,
                    );
                  }),
                  child: const Text('重试同步'),
                ),
              ],
            ),
          );
        }
        return Obx(
          () => MallWebView(
            key: _webKey,
            initialUrl: widget.initialUrl,
            bottomVisibility: widget.initialUrl == null
                ? _mainController.bottomNavVisibility
                : null,
            onPageScroll: widget.initialUrl == null ? _onPageScroll : null,
            onRootBack: widget.initialUrl == null
                ? _mainController.onMallBack
                : () async {
                    if (!await _goBack() && mounted) Get.back();
                  },
            adapterSource: snapshot.data![0],
            homeStyleSource: snapshot.data!.skip(1).join('\n'),
            bottomOverlayInset:
                _mainController.bottomNavHeight.value *
                (widget.initialUrl == null ? 1 : 0),
          ),
        );
      },
    );
    if (widget.initialUrl == null) return page;
    // Web overlays/history must resolve before popping the native detail route.
    // This legacy async back boundary does not provide predictive-back preview.
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => !await _goBack(),
      child: Material(child: SafeArea(child: page)),
    );
  }
}
