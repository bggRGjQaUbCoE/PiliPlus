import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/models/common/dm_block_type.dart';
import 'package:PiliPlus/models/user/danmaku_block.dart';
import 'package:PiliPlus/models/user/danmaku_rule.dart';
import 'package:PiliPlus/pages/danmaku_block/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DanmakuBlockPage extends StatefulWidget {
  const DanmakuBlockPage({super.key});

  @override
  State<DanmakuBlockPage> createState() => _DanmakuBlockPageState();
}

class _DanmakuBlockPageState extends State<DanmakuBlockPage> {
  final DanmakuBlockController _controller = Get.put(DanmakuBlockController());
  late PlPlayerController plPlayerController;

  @override
  void initState() {
    super.initState();
    plPlayerController = Get.arguments as PlPlayerController;
  }

  @override
  void dispose() {
    final ruleFilter = RuleFilter.fromRuleTypeEntires(_controller.rules);
    plPlayerController.filters = ruleFilter;
    GStorage.localCache.put(LocalCacheKey.danmakuFilterRules, ruleFilter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('弹幕屏蔽'),
        bottom: TabBar(
          controller: _controller.tabController,
          tabs: DmBlockType.values
              .map(
                (e) => Obx(
                  () => Tab(
                    text: '${e.label}(${_controller.rules[e.index].length})',
                  ),
                ),
              )
              .toList(),
        ),
      ),
      body: tabBarView(
        controller: _controller.tabController,
        children: DmBlockType.values
            .map(
              (e) => KeepAliveWrapper(
                builder: (context) => Obx(
                  () => tabViewBuilder(e.index, _controller.rules[e.index]),
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddDialog(DmBlockType.values[_controller.tabController.index]),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget tabViewBuilder(final int tabIndex, List<SimpleRule> list) {
    if (list.isEmpty) {
      return scrollErrorWidget();
    }
    return ListView.builder(
      itemCount: list.length,
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
      ),
      itemBuilder: (context, itemIndex) {
        final SimpleRule item = list[itemIndex];
        final child = IconButton(
          icon: const Icon(Icons.delete_outlined),
          onPressed: () => showConfirmDialog(
            context: context,
            title: '确定删除该规则？',
            onConfirm: () => _controller.danmakuFilterDel(
              tabIndex,
              itemIndex,
              item.id,
            ),
          ),
        );
        return ListTile(
          title: Text(
            item.filter,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: tabIndex == 2
              ? child
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showAddDialog(
                        DmBlockType.values[_controller.tabController.index],
                        initFilter: item.filter,
                        itemIndex: itemIndex,
                        itemId: item.id,
                      ),
                    ),
                    child,
                  ],
                ),
        );
      },
    );
  }

  void _showAddDialog(
    DmBlockType type, {
    String initFilter = '',
    int? itemIndex,
    int? itemId,
  }) {
    assert((itemIndex == null) == (itemId == null));
    String filter = initFilter;
    final hintText = switch (type) {
      DmBlockType.keyword => '输入过滤的关键词，其它类别请切换标签页后添加',
      DmBlockType.regex => '输入//之间的正则表达式，无需包含头尾的"/"',
      DmBlockType.uid => '输入用户UID',
    };
    final isUid = type == DmBlockType.uid;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${itemId != null ? "编辑" : "添加新的"}${type.label}规则'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hintText),
              TextFormField(
                autofocus: true,
                initialValue: filter,
                onChanged: (value) => filter = value,
                keyboardType: isUid ? TextInputType.number : null,
                inputFormatters: isUid
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              child: const Text('添加'),
              onPressed: () async {
                if (filter != initFilter) {
                  Get.back();
                  if (itemId != null) {
                    await _controller.danmakuFilterDel(
                      type.index,
                      itemIndex!,
                      itemId,
                    );
                  }
                  await _controller.danmakuFilterAdd(
                    filter: filter,
                    type: type.index,
                  );
                } else {
                  SmartDialog.showToast(
                    '输入内容${filter.isEmpty ? "不能为空" : "与上次相同"}',
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
