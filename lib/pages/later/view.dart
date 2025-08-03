import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/material.dart';
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
  late final TabController _tabController = TabController(
    length: LaterViewType.values.length,
    vsync: this,
  );

  LaterController currCtr([int? index]) {
    final type = LaterViewType.values[index ?? _tabController.index];
    return Get.put(
      LaterController(type),
      tag: type.type.toString(),
    );
  }

  final sortKey = GlobalKey();
  void listener() {
    (sortKey.currentContext as Element?)?.markNeedsBuild();
  }

  @override
  void initState() {
    super.initState();
    _tabController.addListener(listener);
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
            floatingActionButton: Obx(
              () => currCtr().loadingState.value.isSuccess
                  ? FloatingActionButton.extended(
                      onPressed: currCtr().toViewPlayAll,
                      label: const Text('播放全部'),
                      icon: const Icon(Icons.playlist_play),
                    )
                  : const SizedBox.shrink(),
            ),
            body: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  TabBar(
                    // isScrollable: true,
                    // tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    tabs: LaterViewType.values.map((item) {
                      final count = _baseCtr.counts[item];
                      return Tab(
                        text: '${item.title}${count != -1 ? '($count)' : ''}',
                      );
                    }).toList(),
                    onTap: (_) {
                      if (!_tabController.indexIsChanging) {
                        currCtr().scrollController.animToTop();
                      } else {
                        if (enableMultiSelect) {
                          currCtr(_tabController.previousIndex).handleSelect();
                        }
                      }
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: enableMultiSelect
                          ? const NeverScrollableScrollPhysics()
                          : const CustomTabBarViewScrollPhysics(),
                      controller: _tabController,
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

    return MultiSelectAppBarWidget(
      visible: enableMultiSelect,
      ctr: currCtr(),
      children: [
        TextButton(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () {
            final ctr = currCtr();
            RequestUtils.onCopyOrMove<LaterData, LaterItemModel>(
              context: context,
              isCopy: true,
              ctr: ctr,
              mediaId: null,
              mid: ctr.accountService.mid,
            );
          },
          child: Text(
            '复制',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () {
            final ctr = currCtr();
            RequestUtils.onCopyOrMove<LaterData, LaterItemModel>(
              context: context,
              isCopy: false,
              ctr: ctr,
              mediaId: null,
              mid: ctr.accountService.mid,
            );
          },
          child: Text(
            '移动',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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
                  'count': _baseCtr.counts[LaterViewType.all],
                },
              );
            },
            icon: const Icon(Icons.search),
          ),
          Material(
            clipBehavior: Clip.hardEdge,
            type: MaterialType.transparency,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Builder(
              key: sortKey,
              builder: (context) {
                final value = currCtr().asc.value;
                return PopupMenuButton(
                  initialValue: value,
                  tooltip: '排序',
                  onSelected: (value) {
                    currCtr()
                      ..asc.value = value
                      ..onReload();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: value ? '最早添加' : '最近添加',
                          ),
                          WidgetSpan(
                            child: Icon(
                              size: 16,
                              MdiIcons.unfoldMoreHorizontal,
                              color: color,
                            ),
                          ),
                        ],
                        style: TextStyle(color: color),
                      ),
                    ),
                  ),
                  itemBuilder: (BuildContext context) => [
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
          ),
          Material(
            clipBehavior: Clip.hardEdge,
            type: MaterialType.transparency,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: PopupMenuButton(
              tooltip: '清空',
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '清空',
                      ),
                      WidgetSpan(
                        child: Icon(
                          size: 16,
                          MdiIcons.unfoldMoreHorizontal,
                          color: color,
                        ),
                      ),
                    ],
                    style: TextStyle(color: color),
                  ),
                ),
              ),
              itemBuilder: (BuildContext context) => [
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
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
