import 'package:PiliPlus/common/widgets/scroll_physics.dart' show tabBarView;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics/widgets/up_panel.dart';
import 'package:PiliPlus/pages/dynamics_create/view.dart';
import 'package:PiliPlus/pages/dynamics_tab/view.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
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

  @override
  bool get wantKeepAlive => true;

  Widget _createDynamicBtn(ThemeData theme, {bool isRight = true}) => Container(
    width: 34,
    height: 34,
    margin: isRight ? const .only(right: 16) : const .only(left: 16),
    child: IconButton(
      tooltip: '发布动态',
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        backgroundColor: WidgetStatePropertyAll(
          theme.colorScheme.secondaryContainer,
        ),
      ),
      onPressed: () => CreateDynPanel.onCreateDyn(context),
      icon: Icon(
        Icons.add,
        size: 18,
        color: theme.colorScheme.onSecondaryContainer,
      ),
    ),
  );

  Widget upPanelPart(ThemeData theme) {
    final isTop = upPanelPosition == .top;
    final needBg = upPanelPosition.index > 2;
    return Material(
      type: needBg ? .canvas : .transparency,
      color: needBg ? theme.colorScheme.surface : null,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    Widget? drawer;
    Widget? endDrawer;

    Widget? leading;
    Widget actions;

    Widget child = tabBarView(
      controller: _dynamicsController.tabController,
      children: DynamicsTabType.values
          .map((e) => DynamicsTabPage(dynamicsType: e))
          .toList(),
    );

    switch (upPanelPosition) {
      case .top:
        child = Column(
          children: [
            upPanelPart(theme),
            Expanded(child: child),
          ],
        );
        actions = _createDynamicBtn(theme);
      case .leftFixed:
        child = Row(
          children: [
            upPanelPart(theme),
            Expanded(child: child),
          ],
        );
        actions = _createDynamicBtn(theme);
      case .rightFixed:
        child = Row(
          children: [
            Expanded(child: child),
            upPanelPart(theme),
          ],
        );
        actions = _createDynamicBtn(theme);
      case .leftDrawer:
        drawer = upPanelPart(theme);
        actions = _createDynamicBtn(theme);
        leading = const DrawerButton();
      case .rightDrawer:
        endDrawer = upPanelPart(theme);
        leading = _createDynamicBtn(theme, isRight: false);
        actions = const EndDrawerButton();
    }

    return Scaffold(
      primary: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const .fromHeight(50),
        child: Row(
          children: [
            ?leading,
            Expanded(
              child: TabBar(
                dividerHeight: 0,
                isScrollable: true,
                tabAlignment: .start,
                dividerColor: Colors.transparent,
                labelColor: theme.colorScheme.primary,
                indicatorColor: theme.colorScheme.primary,
                controller: _dynamicsController.tabController,
                unselectedLabelColor: theme.colorScheme.onSurface,
                labelStyle:
                    TabBarTheme.of(
                      context,
                    ).labelStyle?.copyWith(fontSize: 13) ??
                    const TextStyle(fontSize: 13),
                tabs: DynamicsTabType.values
                    .map((e) => Tab(text: e.label))
                    .toList(),
                onTap: (index) {
                  if (!_dynamicsController.tabController.indexIsChanging) {
                    _dynamicsController.animateToTop();
                  }
                },
              ),
            ),
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
