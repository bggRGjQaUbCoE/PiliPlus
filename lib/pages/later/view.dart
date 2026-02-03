import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/common/widgets/flutter/page/tabs.dart';
import 'package:PiliPlus/common/widgets/gesture/horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/fav_detail/view.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/material.dart' hide TabBarView;
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LaterPage extends StatefulWidget {
  const LaterPage({super.key});

  @override
  State<LaterPage> createState() => _LaterPageState();
}

class _LaterPageState extends State<LaterPage>
    with SingleTickerProviderStateMixin {
  final LaterBaseController _baseCtr = Get.put(LaterBaseController());
  late final TabController _tabController;

  LaterController currCtr([int? index]) {
    final type = LaterViewType.values[index ?? _tabController.index];
    return Get.putOrFind(
      () => LaterController(type),
      tag: type.type.toString(),
    );
  }

  final _sortKey = GlobalKey();
  void listener() {
    (_sortKey.currentContext as Element?)?.markNeedsBuild();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: LaterViewType.values.length,
      vsync: this,
    )..addListener(listener);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(listener)
      ..dispose();
    Get.delete<LaterBaseController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final enableMultiSelect = _baseCtr.enableMultiSelect.value;
        return PopScope(
          canPop: !enableMultiSelect,
          onPopInvokedWithResult: (didPop, result) {
            if (enableMultiSelect) {
              currCtr().handleSelect();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppbar(enableMultiSelect),
            floatingActionButtonLocation: const CustomFabLocation(),
            floatingActionButton: Padding(
              padding: const .only(right: kFloatingActionButtonMargin),
              child: Obx(
                () => currCtr().loadingState.value.isSuccess
                    ? AnimatedSlide(
                        offset: _baseCtr.isPlayAll.value
                            ? Offset.zero
                            : const Offset(0.75, 0),
                        duration: const Duration(milliseconds: 120),
                        child: GestureDetector(
                          onHorizontalDragDown: (details) =>
                              _baseCtr.dx = details.localPosition.dx,
                          onHorizontalDragStart: (details) =>
                              _baseCtr.setIsPlayAll(
                                details.localPosition.dx < _baseCtr.dx,
                              ),
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              if (_baseCtr.isPlayAll.value) {
                                currCtr().toViewPlayAll();
                              } else {
                                _baseCtr.setIsPlayAll(true);
                              }
                            },
                            label: const Text('播放全部'),
                            icon: const Icon(Icons.playlist_play),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            body: ViewSafeArea(
              child: Column(
                children: [
                  TabBar(
                    // isScrollable: true,
                    // tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    tabs: LaterViewType.values.map((item) {
                      final count = _baseCtr.counts[item.index];
                      return Tab(
                        text: '${item.title}${count != -1 ? '($count)' : ''}',
                      );
                    }).toList(),
                    onTap: (_) {
                      if (!_tabController.indexIsChanging) {
                        currCtr().scrollController.animToTop();
                      } else if (enableMultiSelect) {
                        currCtr(_tabController.previousIndex).handleSelect();
                      }
                    },
                  ),
                  Expanded(
                    child: TabBarView<CustomHorizontalDragGestureRecognizer>(
                      physics: enableMultiSelect
                          ? const NeverScrollableScrollPhysics()
                          : const CustomTabBarViewScrollPhysics(),
                      controller: _tabController,
                      horizontalDragGestureRecognizer:
                          CustomHorizontalDragGestureRecognizer(),
                      children: LaterViewType.values
                          .map((item) => item.page)
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppbar(bool enableMultiSelect) {
    final theme = Theme.of(context);
    Color color = theme.colorScheme.secondary;
    final btnStyle = TextButton.styleFrom(visualDensity: .compact);
    final textStyle = TextStyle(color: theme.colorScheme.onSurfaceVariant);
    return MultiSelectAppBarWidget(
      visible: enableMultiSelect,
      ctr: currCtr(),
      actions: [
        TextButton(
          style: btnStyle,
          onPressed: () {
            final ctr = currCtr();
            RequestUtils.onCopyOrMove<LaterItemModel>(
              context: context,
              isCopy: true,
              ctr: ctr,
              mediaId: null,
              mid: ctr.mid,
            );
          },
          child: Text('复制', style: textStyle),
        ),
        TextButton(
          style: btnStyle,
          onPressed: () {
            final ctr = currCtr();
            RequestUtils.onCopyOrMove<LaterItemModel>(
              context: context,
              isCopy: false,
              ctr: ctr,
              mediaId: null,
              mid: ctr.mid,
            );
          },
          child: Text('移动', style: textStyle),
        ),
      ],
      child: AppBar(
        title: const Text('稍后再看'),
        actions: [
          IconButton(
            tooltip: '搜索',
            onPressed: () {
              final mid = Accounts.main.mid;
              Get.toNamed(
                '/laterSearch',
                arguments: {
                  'type': 0,
                  'mediaId': mid,
                  'mid': mid,
                  'title': '稍后再看',
                  'count': _baseCtr.counts[LaterViewType.all.index],
                },
              );
            },
            icon: const Icon(Icons.search),
          ),
          Builder(
            key: _sortKey,
            builder: (context) {
              final value = currCtr().asc.value;
              return PopupMenuButton(
                initialValue: value,
                tooltip: '排序',
                onSelected: (value) => currCtr()
                  ..asc.value = value
                  ..onReload(),
                borderRadius: const .all(.circular(20)),
                child: Padding(
                  padding: const .symmetric(horizontal: 12, vertical: 6),
                  child: Text.rich(
                    style: TextStyle(fontSize: 14, height: 1, color: color),
                    strutStyle: const StrutStyle(
                      leading: 0,
                      height: 1,
                      fontSize: 14,
                    ),
                    TextSpan(
                      children: [
                        TextSpan(text: value ? '最早添加' : '最近添加'),
                        WidgetSpan(
                          alignment: .middle,
                          child: Icon(
                            size: 14,
                            MdiIcons.unfoldMoreHorizontal,
                            color: color,
                          ),
                        ),
                      ],
                      style: TextStyle(color: color),
                    ),
                  ),
                ),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: false,
                    child: Text('最近添加'),
                  ),
                  const PopupMenuItem(
                    value: true,
                    child: Text('最早添加'),
                  ),
                ],
              );
            },
          ),
          PopupMenuButton(
            tooltip: '清空',
            borderRadius: const .all(.circular(20)),
            child: Padding(
              padding: const .symmetric(horizontal: 12, vertical: 6),
              child: Text.rich(
                style: TextStyle(fontSize: 14, height: 1, color: color),
                strutStyle: const StrutStyle(
                  leading: 0,
                  height: 1,
                  fontSize: 14,
                ),
                TextSpan(
                  children: [
                    const TextSpan(text: '清空'),
                    WidgetSpan(
                      alignment: .middle,
                      child: Icon(
                        size: 14,
                        MdiIcons.unfoldMoreHorizontal,
                        color: color,
                      ),
                    ),
                  ],
                  style: TextStyle(color: color),
                ),
              ),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => currCtr().toViewClear(context, 1),
                child: const Text('清空失效'),
              ),
              PopupMenuItem(
                onTap: () => currCtr().toViewClear(context, 2),
                child: const Text('清空看完'),
              ),
              PopupMenuItem(
                onTap: () => currCtr().toViewClear(context),
                child: const Text('清空全部'),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
