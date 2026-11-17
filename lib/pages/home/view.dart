import 'package:PiliPlus/router/search_expansion.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_height_widget.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart' show tabBarView;
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
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
  final _searchIconKey = GlobalKey();
  final _searchPromptKey = GlobalKey();
  late ColorScheme _colorScheme;
  final _homeController = Get.putOrFind(HomeController.new);
  final _mainController = Get.find<MainController>();

  @override
  bool get needsCorrection => _homeController.hideTopBar;

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
      if (_homeController.hideTopBar &&
          _mainController.barHideType == .instant) {
        tabBar = Material(
          color: _colorScheme.surface,
          child: tabBar,
        );
      }
    } else {
      tabBar = const SizedBox(height: 6);
    }
    return Column(
      children: [
        if (!_mainController.useSideBar && MediaQuery.isPortraitOf(context))
          customAppBar(),
        tabBar,
        Expanded(
          child: onBuild(
            tabBarView(
              controller: _homeController.tabController,
              children: _homeController.tabs.map((e) => e.page).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget customAppBar() {
    const padding = EdgeInsets.fromLTRB(14, 6, 14, 0);
    final child = Row(
      children: [
        searchBar(),
        const SizedBox(width: 4),
        msgBadge(_mainController),
        const SizedBox(width: 8),
        userAvatar(colorScheme: _colorScheme, mainController: _mainController),
      ],
    );
    if (_homeController.hideTopBar) {
      if (_mainController.barOffset case final barOffset?) {
        return Obx(
          () {
            final offset = barOffset.value;
            return CustomHeightWidget(
              offset: Offset(0, -offset),
              height: Style.topBarHeight - offset,
              child: Padding(
                padding: padding,
                child: child,
              ),
            );
          },
        );
      }
      if (_homeController.showTopBar case final showTopBar?) {
        return Obx(() {
          final showSearchBar = showTopBar.value;
          return AnimatedOpacity(
            opacity: showSearchBar ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              curve: Curves.easeInOutCubicEmphasized,
              duration: const Duration(milliseconds: 500),
              height: showSearchBar ? Style.topBarHeight : 0,
              padding: padding,
              child: child,
            ),
          );
        });
      }
    }
    return Container(
      height: Style.topBarHeight,
      padding: padding,
      child: child,
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
        Pref.pageTransition == Transition.noTransition;
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
}) {
  return Semantics(
    label: "我的",
    child: Obx(
      () {
        if (mainController.accountService.isLogin.value) {
          return Stack(
            clipBehavior: .none,
            children: [
              NetworkImgLayer(
                type: .avatar,
                width: 34,
                height: 34,
                src: mainController.accountService.face.value,
              ),
              Positioned.fill(
                child: Material(
                  type: .transparency,
                  child: InkWell(
                    onTap: mainController.toMinePage,
                    splashColor: colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    customBorder: const CircleBorder(),
                  ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
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
          width: 38,
          height: 38,
          child: IconButton(
            tooltip: '点击登录',
            style: IconButton.styleFrom(
              padding: .zero,
              backgroundColor: colorScheme.onInverseSurface,
            ),
            onPressed: mainController.toMinePage,
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
