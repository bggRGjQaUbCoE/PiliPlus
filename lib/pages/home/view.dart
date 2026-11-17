import 'package:PiliPlus/common/widgets/advanced_materials.dart';
import 'package:PiliPlus/common/widgets/scroll_intent.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_height_widget.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/scroll_under_toolbar.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/router/search_expansion.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends CommonPageState<HomePage>
    with AutomaticKeepAliveClientMixin {
  late ColorScheme _colorScheme;
  final _homeController = Get.putOrFind(HomeController.new);
  final _mainController = Get.find<MainController>();
  final _searchIconKey = GlobalKey();
  final _searchPromptKey = GlobalKey();

  @override
  bool get isScrollPageActive =>
      _mainController.navigationBars[_mainController.selectedIndex.value] ==
      .home;

  @override
  bool get needsCorrection => _homeController.hideTopBar;

  @override
  bool get restoreBarsOnTickerResume => false;

  late int _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = _homeController.tabController.index;
    _homeController.tabController.addListener(_restoreBarsOnTabChange);
  }

  void _restoreBarsOnTabChange() {
    final index = _homeController.tabController.index;
    if (index == _activeTab) return;
    _activeTab = index;
    if (isScrollPageActive) _mainController.restoreBars();
  }

  @override
  void dispose() {
    _homeController.tabController.removeListener(_restoreBarsOnTabChange);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorScheme = ColorScheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget tabBar;
    if (_homeController.tabs.length > 1) {
      tabBar = Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SizedBox(
          height: 42,
          width: double.infinity,
          child: TabBar(
            controller: _homeController.tabController,
            tabs: _homeController.tabs.map((e) => Tab(text: e.label)).toList(),
            isScrollable: true,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            splashBorderRadius: Style.mdRadius,
            tabAlignment: TabAlignment.center,
            onTap: (_) {
              feedBack();
              if (!_homeController.tabController.indexIsChanging) {
                _homeController.animateToTop();
              }
            },
          ),
        ),
      );
    } else {
      tabBar = const SizedBox(height: 6);
    }
    final tabs = _homeController.tabs;
    final pages = tabs.map((e) => e.page).toList();
    final underlaps = {
      for (final (index, tab) in tabs.indexed)
        if (tab == HomeTabType.rcmd ||
            tab == HomeTabType.hot ||
            tab == HomeTabType.bangumi ||
            tab == HomeTabType.cinema)
          index,
    };
    final leadingSpaces = {
      for (final (index, tab) in tabs.indexed)
        if (tab == HomeTabType.rcmd) index: Style.cardSpace,
    };
    final tabExtent = tabs.length > 1 ? 46.0 : 6.0;
    final tint = AdvancedMaterials.tint(_colorScheme);
    final dark = _colorScheme.brightness == Brightness.dark;
    Widget layout(double barHeight, Widget? bar) => onBuild(
      ScrollUnderToolbar(
        extent: barHeight + tabExtent,
        controller: _homeController.tabController,
        pages: pages,
        underlaps: underlaps,
        leadingSpaces: leadingSpaces,
        backdropGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.55, 1],
          colors: [
            _colorScheme.surface,
            tint.withValues(alpha: dark ? .77 : .82),
            tint.withValues(alpha: dark ? .56 : .62),
          ],
        ),
        toolbar: Column(
          children: [?bar, tabBar],
        ),
      ),
    );
    if (_mainController.useSideBar || !MediaQuery.isPortraitOf(context)) {
      return layout(0, null);
    }
    return _buildTopBar(layout);
  }

  Widget _buildTopBar(Widget Function(double height, Widget bar) layout) {
    const padding = EdgeInsets.fromLTRB(14, 4, 14, 0);
    final child = Row(
      children: [
        searchBar(),
        const SizedBox(width: 8),
        msgBadge(_mainController),
        userAvatar(
          touchSize: 48,
          colorScheme: _colorScheme,
          mainController: _mainController,
          onTap: () {
            if (ModalRoute.of(context)?.isCurrent != true) return;
            final account = Accounts.main;
            if (account.isLogin) {
              Get.toNamed('/member?mid=${account.mid}');
            } else {
              Get.toNamed('/loginPage');
            }
          },
        ),
      ],
    );
    if (_homeController.hideTopBar) {
      if (_mainController.barOffset case final barOffset?) {
        return Obx(
          () {
            final offset = barOffset.value;
            final height = Style.topBarHeight - offset;
            return layout(
              height,
              IgnorePointer(
                ignoring: offset > 0,
                child: ExcludeSemantics(
                  excluding: offset > 0,
                  child: ClipRect(
                    child: CustomHeightWidget(
                      offset: Offset(0, -offset),
                      height: height,
                      child: Padding(padding: padding, child: child),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
      if (_homeController.showTopBar case final showTopBar?) {
        return Obx(() {
          final showSearchBar = showTopBar.value;
          return TweenAnimationBuilder<double>(
            tween: Tween(end: showSearchBar ? 1.0 : 0.0),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : ScrollVisibility.duration,
            curve: ScrollVisibility.curve,
            child: Padding(padding: padding, child: child),
            builder: (context, progress, child) {
              final height = progress * Style.topBarHeight;
              return layout(
                height,
                IgnorePointer(
                  ignoring: !showSearchBar,
                  child: ExcludeSemantics(
                    excluding: !showSearchBar,
                    child: Opacity(
                      opacity: progress,
                      child: SizedBox(height: height, child: child),
                    ),
                  ),
                ),
              );
            },
          );
        });
      }
    }
    return layout(
      Style.topBarHeight,
      SizedBox(
        height: Style.topBarHeight,
        child: Padding(padding: padding, child: child),
      ),
    );
  }

  Widget searchBar() {
    const borderRadius = BorderRadius.all(Radius.circular(22));
    final color = Color.alphaBlend(
      _colorScheme.onSecondaryContainer.withValues(alpha: 0.10),
      _colorScheme.surface,
    );
    return Expanded(
      child: SizedBox(
        height: 44,
        child: Material(
          borderRadius: borderRadius,
          color: color,
          child: Builder(
            builder: (sourceContext) => InkWell(
              borderRadius: borderRadius,
              splashColor: _colorScheme.primaryContainer.withValues(
                alpha: 0.3,
              ),
              onTap: () => _openSearch(sourceContext, borderRadius, color),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(
                    Icons.search_outlined,
                    key: _searchIconKey,
                    color: _colorScheme.onSecondaryContainer,
                    semanticLabel: '搜索',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '搜索视频、UP主',
                      key: _searchPromptKey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _colorScheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openSearch(BuildContext source, BorderRadius radius, Color color) {
    if (ModalRoute.of(source)?.isCurrent != true) return;
    SearchExpansion? expansion;
    final bar = source.findRenderObject();
    final immediate =
        MediaQuery.disableAnimationsOf(source) ||
        (Pref.pageTransition == Transition.noTransition &&
            !Pref.layeredPageTransition &&
            !Pref.coverPageTransition);
    if (bar is RenderBox && !immediate) {
      final overlay = Navigator.of(source).overlay!.context.findRenderObject();
      final icon = _searchIconKey.currentContext?.findRenderObject();
      final prompt = _searchPromptKey.currentContext?.findRenderObject();
      if (overlay is RenderBox &&
          overlay.hasSize &&
          bar.hasSize &&
          icon is RenderBox &&
          icon.hasSize &&
          prompt is RenderParagraph &&
          prompt.hasSize) {
        final rect = MatrixUtils.transformRect(
          bar.getTransformTo(overlay),
          Offset.zero & bar.size,
        );
        final viewport = Offset.zero & overlay.size;
        if (rect.isFinite &&
            !rect.isEmpty &&
            rect.left >= 0 &&
            rect.top >= 0 &&
            rect.right <= viewport.right &&
            rect.bottom <= viewport.bottom) {
          expansion = SearchExpansion(
            source: radius.toRRect(rect),
            viewport: overlay.size,
            color: Color.alphaBlend(color, Theme.of(source).canvasColor),
            icon:
                icon.localToGlobal(Offset.zero, ancestor: overlay) & icon.size,
            iconColor: _colorScheme.onSecondaryContainer,
            prompt: (
              span: prompt.text,
              baseline: prompt.localToGlobal(
                Offset(
                  0,
                  prompt.getDryBaseline(
                    prompt.constraints,
                    TextBaseline.alphabetic,
                  )!,
                ),
                ancestor: overlay,
              ),
              width: prompt.size.width,
              scaler: prompt.textScaler,
            ),
          );
        }
      }
    }
    Get.toNamed(
      '/search',
      arguments: immediate ? SearchOpening.immediate : expansion,
      parameters: _homeController.enableSearchWord
          ? {'hintText': _homeController.defaultSearch.value}
          : null,
    );
  }
}

Widget userAvatar({
  required ColorScheme colorScheme,
  required MainController mainController,
  VoidCallback? onTap,
  double? touchSize,
}) {
  return Semantics(
    label: "我的",
    child: Obx(
      () {
        if (mainController.accountService.isLogin.value) {
          final avatarSize = touchSize == null ? 34.0 : 32.0;
          final inset = ((touchSize ?? avatarSize) - avatarSize) / 2;
          return Stack(
            clipBehavior: .none,
            children: [
              Padding(
                padding: EdgeInsets.all(inset),
                child: NetworkImgLayer(
                  type: .avatar,
                  width: avatarSize,
                  height: avatarSize,
                  src: mainController.accountService.face.value,
                ),
              ),
              Positioned.fill(
                child: Material(
                  type: .transparency,
                  child: InkWell(
                    onTap: onTap ?? mainController.toMinePage,
                    splashColor: colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    customBorder: const CircleBorder(),
                  ),
                ),
              ),
              Positioned(
                right: inset - 4,
                bottom: inset - 4,
                child: Obx(
                  () => MineController.anonymity.value
                      ? IgnorePointer(
                          child: Container(
                            padding: const .all(2),
                            decoration: BoxDecoration(
                              shape: .circle,
                              color: colorScheme.secondaryContainer,
                            ),
                            child: Icon(
                              size: 14,
                              MdiIcons.incognito,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          );
        }
        return SizedBox(
          width: touchSize ?? 38,
          height: touchSize ?? 38,
          child: IconButton(
            tooltip: '点击登录',
            style: IconButton.styleFrom(
              padding: .zero,
              backgroundColor: touchSize == null
                  ? colorScheme.onInverseSurface
                  : null,
            ),
            onPressed: onTap ?? mainController.toMinePage,
            icon: Icon(
              Icons.person_rounded,
              size: 22,
              color: colorScheme.primary,
            ),
          ),
        );
      },
    ),
  );
}

Widget msgBadge(MainController mainController) {
  return Obx(
    () {
      if (mainController.accountService.isLogin.value) {
        final count = mainController.msgUnReadCount.value;
        final isNumBadge = mainController.msgBadgeMode == .number;
        return IconButton(
          tooltip: '消息',
          onPressed: () {
            mainController
              ..clearUnreadMsg()
              ..lastCheckUnreadAt = DateTime.now().millisecondsSinceEpoch;
            Get.toNamed('/whisper');
          },
          icon: Badge(
            isLabelVisible:
                mainController.msgBadgeMode != .hidden && count != null,
            alignment: isNumBadge
                ? const Alignment(0.0, -0.85)
                : const Alignment(1.0, -0.85),
            label: isNumBadge && count != null ? Text(count) : null,
            child: const Icon(Icons.notifications_none),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}
