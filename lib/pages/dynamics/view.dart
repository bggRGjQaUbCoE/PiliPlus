import 'package:PiliPlus/models/common/dynamics_type.dart';
import 'package:PiliPlus/models/common/up_panel_position.dart';
import 'package:PiliPlus/pages/dynamics/create_dyn_panel.dart';
import 'package:PiliPlus/pages/dynamics/tab/controller.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'controller.dart';
import 'widgets/up_panel.dart';
import 'package:PiliPlus/common/widgets/spring_physics.dart';

enum ReplyOption { allow, close, choose }

extension ReplyOptionExtension on ReplyOption {
  String get title => ['允许评论', '关闭评论', '精选评论'][index];

  IconData get iconData => [
        MdiIcons.commentTextOutline,
        MdiIcons.commentOffOutline,
        MdiIcons.commentProcessingOutline,
      ][index];
}

class DynamicsPage extends StatefulWidget {
  const DynamicsPage({super.key});

  @override
  State<DynamicsPage> createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final DynamicsController _dynamicsController = Get.put(DynamicsController());
  late UpPanelPosition upPanelPosition;

  @override
  bool get wantKeepAlive => true;

  Widget _createDynamicBtn([bool isRight = true]) => Center(
        child: Container(
          width: 34,
          height: 34,
          margin:
              EdgeInsets.only(left: !isRight ? 16 : 0, right: isRight ? 16 : 0),
          child: IconButton(
            tooltip: '发布动态',
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return Theme.of(context).colorScheme.secondaryContainer;
              }),
            ),
            onPressed: () {
              if (_dynamicsController.isLogin.value) {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  builder: (context) => const CreateDynPanel(),
                );
              }
            },
            icon: Icon(
              Icons.add,
              size: 18,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    upPanelPosition = UpPanelPosition.values[GStorage.setting.get(
        SettingBoxKey.upPanelPosition,
        defaultValue: UpPanelPosition.leftFixed.index)];
    debugPrint('upPanelPosition: $upPanelPosition');
    if (GStorage.setting
        .get(SettingBoxKey.dynamicsShowAllFollowedUp, defaultValue: false)) {
      _dynamicsController.scrollController.addListener(() {
        if (_dynamicsController.scrollController.position.pixels >=
            _dynamicsController.scrollController.position.maxScrollExtent -
                300) {
          EasyThrottle.throttle('following', const Duration(seconds: 1), () {
            _dynamicsController.queryFollowing2();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _dynamicsController.tabController.removeListener(() {});
    _dynamicsController.scrollController.removeListener(() {});
    super.dispose();
  }

  Widget upPanelPart() {
    return Container(
      //抽屉模式增加底色
      color: upPanelPosition.index > 1
          ? Theme.of(context).colorScheme.surface
          : Colors.transparent,
      width: 64,
      child: Obx(
        () {
          if (_dynamicsController.upData.value.upList == null &&
              _dynamicsController.upData.value.liveUsers == null) {
            return const SizedBox.shrink();
          } else if (_dynamicsController.upData.value.errMsg != null) {
            return Center(
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _dynamicsController.queryFollowUp();
                },
              ),
            );
          } else {
            return UpPanel(
              dynamicsController: _dynamicsController,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: upPanelPosition == UpPanelPosition.rightDrawer
              ? _createDynamicBtn(false)
              : null,
          leadingWidth: 50,
          toolbarHeight: 50,
          title: SizedBox(
            height: 50,
            child: TabBar(
              controller: _dynamicsController.tabController,
              isScrollable: true,
              dividerColor: Colors.transparent,
              dividerHeight: 0,
              tabAlignment: TabAlignment.center,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
              ),
              tabs:
                  DynamicsType.values.map((e) => Tab(text: e.labels)).toList(),
              onTap: (index) {
                if (!_dynamicsController.tabController.indexIsChanging) {
                  feedBack();
                  Get.find<DynamicsTabController>(tag: tabsConfig[index]['tag'])
                      .animateToTop();
                }
              },
            ),
          ),
          actions: upPanelPosition == UpPanelPosition.rightDrawer
              ? null
              : [_createDynamicBtn()],
        ),
        drawer: upPanelPosition == UpPanelPosition.leftDrawer
            ? SafeArea(child: upPanelPart())
            : null,
        drawerEnableOpenDragGesture: true,
        endDrawer: upPanelPosition == UpPanelPosition.rightDrawer
            ? SafeArea(child: upPanelPart())
            : null,
        endDrawerEnableOpenDragGesture: true,
        body: Row(children: [
          if (upPanelPosition == UpPanelPosition.leftFixed) upPanelPart(),
          Expanded(
              child: TabBarView(
            physics: customTabBarViewScrollPhysics,
            controller: _dynamicsController.tabController,
            children: _dynamicsController.tabsPageList,
          )),
          if (upPanelPosition == UpPanelPosition.rightFixed) upPanelPart(),
        ]));
  }
}
