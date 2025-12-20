import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics/widgets/up_panel.dart';
import 'package:PiliPlus/pages/dynamics_create/view.dart';
import 'package:PiliPlus/pages/dynamics_tab/view.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:flutter/material.dart' hide DraggableScrollableSheet;
import 'package:get/get.dart';

class DynamicsPage extends StatefulWidget {
  const DynamicsPage({super.key});

  @override
  State<DynamicsPage> createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage>
    with AutomaticKeepAliveClientMixin {
  final _dynamicsController = Get.putOrFind(DynamicsController.new);
  UpPanelPosition get upPanelPosition => _dynamicsController.upPanelPosition;

  @override
  bool get wantKeepAlive => true;

  Widget _createDynamicBtn(ThemeData theme, [bool isRight = true]) => Center(
    child: Container(
      width: 34,
      height: 34,
      margin: EdgeInsets.only(left: !isRight ? 16 : 0, right: isRight ? 16 : 0),
      child: IconButton(
        tooltip: '发布动态',
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          backgroundColor: WidgetStatePropertyAll(
            theme.colorScheme.secondaryContainer,
          ),
        ),
        onPressed: () {
          if (_dynamicsController.accountService.isLogin.value) {
            CreateDynPanel.onCreateDyn(context);
          }
        },
        icon: Icon(
          Icons.add,
          size: 18,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    ),
  );

  Widget upPanelPart(ThemeData theme) {
    bool isTop = upPanelPosition == UpPanelPosition.top;
    bool needBg = upPanelPosition.index > 1;
    return Material(
      color: needBg ? theme.colorScheme.surface : null,
      type: needBg ? MaterialType.canvas : MaterialType.transparency,
      child: SizedBox(
        width: isTop ? null : 64,
        height: isTop ? 76 : null,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 300) {
              _dynamicsController.onLoadMoreUp();
            }
            return false;
          },
          child: Obx(() => _buildUpPanel(_dynamicsController.upState.value)),
        ),
      ),
    );
  }

  Widget _buildUpPanel(LoadingState<FollowUpModel> upState) {
    return switch (upState) {
      Loading() => const SizedBox.shrink(),
      Success<FollowUpModel>() => UpPanel(
        dynamicsController: _dynamicsController,
      ),
      Error() => Center(
        child: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            _dynamicsController
              ..upState.value = LoadingState<FollowUpModel>.loading()
              ..queryFollowUp();
          },
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        primary: false,
        leading: upPanelPosition == UpPanelPosition.rightDrawer
            ? _createDynamicBtn(theme, false)
            : null,
        leadingWidth: 50,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        title: SizedBox(
          height: 50,
          child: TabBar(
            controller: _dynamicsController.tabController,
            isScrollable: true,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            tabAlignment: TabAlignment.center,
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface,
            labelStyle:
                TabBarTheme.of(context).labelStyle?.copyWith(fontSize: 13) ??
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
        actions: upPanelPosition == UpPanelPosition.rightDrawer
            ? null
            : [_createDynamicBtn(theme)],
      ),
      drawer: upPanelPosition == UpPanelPosition.leftDrawer
          ? upPanelPart(theme)
          : null,
      drawerEnableOpenDragGesture: true,
      endDrawer: upPanelPosition == UpPanelPosition.rightDrawer
          ? upPanelPart(theme)
          : null,
      endDrawerEnableOpenDragGesture: true,
      body: Row(
        children: [
          if (upPanelPosition == UpPanelPosition.leftFixed) upPanelPart(theme),
          Expanded(
            child: Column(
              children: [
                if (upPanelPosition == UpPanelPosition.top) upPanelPart(theme),
                Expanded(
                  child: videoTabBarView(
                    controller: _dynamicsController.tabController,
                    children: DynamicsTabType.values
                        .map((e) => DynamicsTabPage(dynamicsType: e))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          if (upPanelPosition == UpPanelPosition.rightFixed) upPanelPart(theme),
        ],
      ),
    );
  }
}
