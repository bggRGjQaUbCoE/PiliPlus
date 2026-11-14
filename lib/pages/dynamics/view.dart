import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show dynamicHorizontalDragRecognizer, tabBarView;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics/widgets/up_panel.dart';
import 'package:PiliPlus/pages/dynamics_create/view.dart';
import 'package:PiliPlus/pages/dynamics_tab/view.dart';
import 'package:PiliPlus/pages/dynamics_up/up_page_view.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide DraggableScrollableSheet;

class DynamicsPage extends StatefulWidget {
  const DynamicsPage({super.key});

  @override
  State<DynamicsPage> createState() => _DynamicsPageState();
}

class _DynamicsPageState extends CommonPageState<DynamicsPage>
    with AutomaticKeepAliveClientMixin {
  final _dynamicsController = Get.putOrFind(DynamicsController.new);
  UpPanelPosition get upPanelPosition => _dynamicsController.upPanelPosition;
  late final MainController _mainController = Get.find<MainController>();

  /// UP 头像栏的收起偏移：0 = 完全展开，_upBarHeight = 完全收起
  final _upBarOffset = 0.0.obs;
  static const double _upBarHeight = 76;

  @override
  bool get wantKeepAlive => true;

  Widget _createDynamicBtn(ColorScheme colorScheme, {bool isRight = true}) =>
      Container(
        width: 34,
        height: 34,
        margin: isRight ? const .only(right: 16) : const .only(left: 16),
        child: IconButton(
          tooltip: '发布动态',
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            backgroundColor: WidgetStatePropertyAll(
              colorScheme.secondaryContainer,
            ),
          ),
          onPressed: () => CreateDynPanel.onCreateDyn(context),
          icon: Icon(
            Icons.add,
            size: 18,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      );

  Widget upPanelPart(ColorScheme colorScheme) {
    final isTop = upPanelPosition == .top;
    final needBg = upPanelPosition.index > 2;
    return Material(
      type: needBg ? .canvas : .transparency,
      color: needBg ? colorScheme.surface : null,
      child: SizedBox(
        width: isTop ? null : 64,
        height: isTop ? 76 : null,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 300) {
              _dynamicsController.onLoadMore();
            }
            return false;
          },
          child: Obx(
            () => _buildUpPanel(_dynamicsController.loadingState.value),
          ),
        ),
      ),
    );
  }

  Widget _buildUpPanel(LoadingState<FollowUpModel> upState) {
    return switch (upState) {
      Loading() => const SizedBox.shrink(),
      Success(:final response) => UpPanel(
        upData: response,
        dynamicsController: _dynamicsController,
      ),
      Error() => Center(
        child: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _dynamicsController.onReload,
        ),
      ),
    };
  }

  /// 吸顶的 UP 头像栏：右侧固定发布按钮，其余横向滚动
  Widget _upBar(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent - 300) {
                _dynamicsController.onLoadMore();
              }
              return false;
            },
            child: Obx(
              () => _buildUpPanel(_dynamicsController.loadingState.value),
            ),
          ),
        ),
        _createDynamicBtn(colorScheme),
      ],
    );
  }

  /// 内容上滑时收起头像栏，下滑或回到顶部时展开
  bool _onUpBarScroll(ScrollNotification notification) {
    // 横向分页自己滚动，不参与收起
    if (notification.metrics.axis != .vertical) return false;
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta;
      if (delta != null && delta != 0 && notification.dragDetails != null) {
        _upBarOffset.value = (_upBarOffset.value + delta).clamp(
          0.0,
          _upBarHeight,
        );
      }
    } else if (notification is OverscrollNotification) {
      _upBarOffset.value = (_upBarOffset.value + notification.overscroll)
          .clamp(0.0, _upBarHeight);
    } else if (notification is ScrollEndNotification ||
        notification is ScrollStartNotification) {
      // 到顶一定展开
      if (notification.metrics.extentBefore == 0) {
        _upBarOffset.value = 0;
      }
    }
    return false;
  }

  Widget _collapsibleUpBar(ColorScheme colorScheme) {
    return Obx(() {
      final progress = (_upBarOffset.value / _upBarHeight).clamp(0.0, 1.0);
      if (progress >= 1) return const SizedBox.shrink();
      final material = Material(
        type: .canvas,
        color: colorScheme.surface,
        child: SizedBox(
          width: double.infinity,
          height: _upBarHeight,
          child: _upBar(colorScheme),
        ),
      );
      return ClipRect(
        child: SizedBox(
          height: _upBarHeight * (1 - progress),
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: _upBarHeight,
            maxHeight: _upBarHeight,
            child: material,
          ),
        ),
      );
    });
  }

  /// 「只保留 UP 主栏」布局：头像栏吸顶 + 当前 UP 的动态流
  Widget _buildUpOnly(BuildContext context, ColorScheme colorScheme) {
    return Scaffold(
      primary: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
        onNotification: _onUpBarScroll,
        child: onBuild(
          Column(
            children: [
              _collapsibleUpBar(colorScheme),
              const Expanded(child: DynUpPageView()),
            ],
          ),
        ),
      ),
    );
  }

  bool get checkPage =>
      _mainController.navigationBars[0] != .dynamics &&
      _mainController.selectedIndex.value == 0;

  @override
  bool onNotificationType1(UserScrollNotification notification) {
    if (checkPage) {
      return false;
    }
    return super.onNotificationType1(notification);
  }

  @override
  bool onNotificationType2(ScrollNotification notification) {
    if (checkPage) {
      return false;
    }
    return super.onNotificationType2(notification);
  }

  /// 顶部分类指示器：一排跟随手势的小圆点（不含文字）
  ///
  /// 取代原来的 [TabBar]：横向滑动切换分类时圆点连续跟随，
  /// 当前分类显示为稍长的胶囊，点圆点可直达对应分类。
  Widget _dynTabIndicator(ColorScheme colorScheme) {
    final tabController = _dynamicsController.tabController;
    final animation = tabController.animation;
    const tabTypes = DynamicsTabType.values;

    Widget buildIndicator(double position) {
      return Row(
        mainAxisSize: .min,
        children: [
          for (int i = 0; i < tabTypes.length; i++)
            GestureDetector(
              behavior: .opaque,
              onTap: () => _toDynTab(i),
              child: SizedBox(
                height: 28,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width:
                        4 + 8 * (1 - (position - i).abs()).clamp(0.0, 1.0),
                    height: 4.5,
                    margin: const .symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(
                        alpha:
                            .22 +
                            .78 * (1 - (position - i).abs()).clamp(0.0, 1.0),
                      ),
                      borderRadius: const .all(.circular(2.25)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    final Widget child;
    if (animation == null) {
      child = buildIndicator(tabController.index.toDouble());
    } else {
      child = AnimatedBuilder(
        animation: animation,
        builder: (context, _) => buildIndicator(animation.value),
      );
    }
    return Center(child: child);
  }

  void _toDynTab(int index) {
    final tabController = _dynamicsController.tabController;
    if (tabController.index != index) {
      tabController.animateTo(index);
      _dynamicsController.animateToTop();
    } else {
      _dynamicsController.animateToTop();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = ColorScheme.of(context);

    if (_dynamicsController.upOnlyMode) {
      return _buildUpOnly(context, colorScheme);
    }

    Widget? drawer;
    Widget? endDrawer;

    Widget? leading;
    Widget actions;

    final swipeSensitivity = Pref.dynSwipeSensitivity;
    final useUpPageView = _dynamicsController.useUpPageView;

    Widget child = tabBarView(
      controller: _dynamicsController.tabController,
      recognizer: () =>
          dynamicHorizontalDragRecognizer(swipeSensitivity),
      children: DynamicsTabType.values
          .map(
            (e) => e == .up && useUpPageView
                ? const DynUpPageView()
                : DynamicsTabPage(dynamicsType: e),
          )
          .toList(),
    );

    switch (upPanelPosition) {
      case .top:
        child = Column(
          children: [
            upPanelPart(colorScheme),
            Expanded(child: child),
          ],
        );
        actions = _createDynamicBtn(colorScheme);
      case .leftFixed:
        child = Row(
          children: [
            upPanelPart(colorScheme),
            Expanded(child: child),
          ],
        );
        actions = _createDynamicBtn(colorScheme);
      case .rightFixed:
        child = Row(
          children: [
            Expanded(child: child),
            upPanelPart(colorScheme),
          ],
        );
        actions = _createDynamicBtn(colorScheme);
      case .leftDrawer:
        drawer = upPanelPart(colorScheme);
        actions = _createDynamicBtn(colorScheme);
        leading = const DrawerButton();
      case .rightDrawer:
        endDrawer = upPanelPart(colorScheme);
        leading = _createDynamicBtn(colorScheme, isRight: false);
        actions = const EndDrawerButton();
    }

    return Scaffold(
      primary: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const .fromHeight(40),
        child: Row(
          children: [
            ?leading,
            Expanded(child: _dynTabIndicator(colorScheme)),
            actions,
          ],
        ),
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      body: onBuild(child),
    );
  }
}
