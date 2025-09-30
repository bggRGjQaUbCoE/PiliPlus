import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/member/tags.dart';
import 'package:PiliPlus/pages/follow/child/child_controller.dart';
import 'package:PiliPlus/pages/follow/child/child_view.dart';
import 'package:PiliPlus/pages/follow/controller.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:get/get.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final _tag = Utils.generateRandomString(8);
  late final FollowController _followController = Get.put(
    FollowController(),
    tag: _tag,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          _followController.isOwner ? '我的关注' : '${_followController.name}的关注',
        ),
        actions: _followController.isOwner
            ? [
                IconButton(
                  onPressed: _onCreateTag,
                  icon: const Icon(Icons.add),
                  tooltip: '新建分组',
                ),
                IconButton(
                  onPressed: () => Get.toNamed(
                    '/followSearch',
                    arguments: {
                      'mid': _followController.mid,
                    },
                  ),
                  icon: const Icon(Icons.search_outlined),
                  tooltip: '搜索',
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => Get.toNamed('/blackListPage'),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.block, size: 19),
                          SizedBox(width: 10),
                          Text('黑名单管理'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
              ]
            : null,
      ),
      body: _followController.isOwner
          ? Obx(() => _buildBody(_followController.followState.value))
          : _childPage(),
    );
  }

  Widget _childPage([MemberTagItemModel? item]) => FollowChildPage(
    tag: _tag,
    controller: _followController,
    mid: _followController.mid,
    tagid: item?.tagid,
  );

  bool _isCustomTag(int? tagid) {
    return tagid != null && tagid != 0 && tagid != -10 && tagid != -2;
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewSafeArea(
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: _followController.tabController,
              tabs: List.generate(_followController.tabs.length, (index) {
                return Obx(() {
                  final item = _followController.tabs[index];
                  int? count = item.count;
                  if (_isCustomTag(item.tagid)) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onLongPress: () {
                        Feedback.forLongPress(context);
                        _onHandleTag(index, item);
                      },
                      onSecondaryTap: Utils.isMobile
                          ? null
                          : () => _onHandleTag(index, item),
                      child: Tab(
                        child: Row(
                          children: [
                            Text(
                              '${item.name}${count != null ? '($count)' : ''} ',
                            ),
                            const Icon(Icons.menu, size: 18),
                          ],
                        ),
                      ),
                    );
                  }
                  return Tab(
                    text: '${item.name}${count != null ? '($count)' : ''}',
                  );
                });
              }),
              onTap: (value) {
                if (!_followController.tabController!.indexIsChanging) {
                  final item = _followController.tabs[value];
                  // if (_isCustomTag(item.tagid)) {
                  //   _onHandleTag(value, item);
                  // }
                  try {
                    Get.find<FollowChildController>(
                      tag: '$_tag${item.tagid}',
                    ).animateToTop();
                  } catch (_) {}
                }
              },
            ),
          ),
          Expanded(
            child: tabBarView(
              controller: _followController.tabController,
              children: _followController.tabs.map(_childPage).toList(),
            ),
          ),
        ],
      ),
      Error() => _childPage(),
    };
  }

  void _onHandleTag(int index, MemberTagItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Get.back();
                  String tagName = item.name!;
                  showConfirmDialog(
                    context: context,
                    title: '编辑分组名称',
                    content: TextFormField(
                      autofocus: true,
                      initialValue: tagName,
                      onChanged: (value) => tagName = value,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onConfirm: () {
                      if (tagName.isNotEmpty) {
                        _followController.onUpdateTag(item, tagName);
                      }
                    },
                  );
                },
                dense: true,
                title: const Text(
                  '修改名称',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  showConfirmDialog(
                    context: context,
                    title: '删除分组',
                    content: '删除后，该分组下的用户依旧保留？',
                    onConfirm: () => _followController.onDelTag(item.tagid),
                  );
                },
                dense: true,
                title: const Text(
                  '删除分组',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCreateTag() {
    String tagName = '';
    showConfirmDialog(
      context: context,
      title: '新建分组',
      content: TextFormField(
        autofocus: true,
        initialValue: tagName,
        onChanged: (value) => tagName = value,
        inputFormatters: [
          LengthLimitingTextInputFormatter(16),
        ],
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      onConfirm: () => _followController.onCreateTag(tagName),
    );
  }
}
