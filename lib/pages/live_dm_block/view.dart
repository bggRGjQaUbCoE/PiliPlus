import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart' show tabBarView;
import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:PiliPlus/pages/live_dm_block/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class LiveDmBlockPage extends StatefulWidget {
  const LiveDmBlockPage({super.key});

  @override
  State<LiveDmBlockPage> createState() => _LiveDmBlockPageState();
}

class _LiveDmBlockPageState extends State<LiveDmBlockPage> {
  final _controller = Get.put(
    LiveDmBlockController(),
    tag: Utils.generateRandomString(8),
  );
  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    padding = MediaQuery.viewPaddingOf(context);
    Widget tabBar = TabBar(
      controller: _controller.tabController,
      tabs: const [
        Tab(text: '关键词'),
        Tab(text: '用户'),
      ],
    );

    Widget view = tabBarView(
      hitTestBehavior: .translucent,
      controller: _controller.tabController,
      children: [
        KeepAliveWrapper(
          child: Obx(() => _buildKeyword(_controller.keywordList)),
        ),
        KeepAliveWrapper(
          child: Obx(() => _buildKeyword(_controller.shieldUserList)),
        ),
      ],
    );

    return SimpleScaffold(
      appBar: AppBar(title: const Text('弹幕屏蔽')),
      body: Padding(
        padding: .only(left: padding.left, right: padding.right),
        child: Column(
          children: [
            tabBar,
            Expanded(child: view),
          ],
        ),
      ),
      fab: Padding(
        padding: .only(
          right: kFloatingActionButtonMargin + padding.right,
          bottom: kFloatingActionButtonMargin + padding.bottom,
        ),
        child: FloatingActionButton(
          tooltip: '添加',
          onPressed: _addShieldKeyword,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildKeyword(List list) {
    if (list.isEmpty) {
      return scrollableError;
    }
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: padding.bottom + 100,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: list.mapIndexed(
          (i, e) {
            return SearchText(
              text: e is ShieldUserList ? e.uname : e as String,
              onTap: (value) => showConfirmDialog(
                context: context,
                title: const Text('确定删除该规则？'),
                onConfirm: () => _controller.onRemove(i, e),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  void _addShieldKeyword() {
    bool isKeyword = _controller.tabController.index == 0;
    String value = '';
    showConfirmDialog(
      context: context,
      title: Text('${isKeyword ? '关键词' : '用户'}屏蔽'),
      content: TextFormField(
        autofocus: true,
        initialValue: value,
        onChanged: (val) => value = val,
        decoration: isKeyword ? null : const InputDecoration(hintText: 'UID'),
        keyboardType: isKeyword ? null : TextInputType.number,
        inputFormatters: isKeyword
            ? null
            : [FilteringTextInputFormatter.digitsOnly],
      ),
      onConfirm: () {
        if (value.isNotEmpty) {
          _controller.addShieldKeyword(isKeyword, value);
        }
      },
    );
  }
}
