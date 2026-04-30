import 'package:PiliPlus/common/widgets/reorder_mixin.dart';
import 'package:PiliPlus/http/follow.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/member/tags.dart';
import 'package:PiliPlus/pages/follow/controller.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FollowTagSortPage extends StatefulWidget {
  const FollowTagSortPage({super.key, required this.controller});

  final FollowController controller;

  @override
  State<FollowTagSortPage> createState() => _FollowTagSortPageState();
}

class _FollowTagSortPageState extends State<FollowTagSortPage>
    with ReorderMixin {
  final List<MemberTagItemModel> _defTags = <MemberTagItemModel>[];
  final List<MemberTagItemModel> _customTags = <MemberTagItemModel>[];

  @override
  void initState() {
    super.initState();
    for (final e in widget.controller.tabs) {
      if (BiliUtils.isCustomFollowTag(e.tagid)) {
        _customTags.add(e);
      } else {
        _defTags.add(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('关注分组排序'),
        actions: _customTags.isNotEmpty
            ? [
                TextButton(
                  onPressed: () async {
                    final res = await FollowHttp.sortFollowTag(
                      tagids: _customTags.map((e) => e.tagid).join(','),
                    );
                    if (res.isSuccess) {
                      SmartDialog.showToast('排序完成');
                      final tabs = _defTags + _customTags;
                      widget.controller
                        ..tabs.value = tabs
                        ..onInitTab()
                        ..followState.value = Success(tabs.hashCode);
                      if (mounted) {
                        Get.back();
                      }
                    } else {
                      res.toast();
                    }
                  },
                  child: const Text('完成'),
                ),
                const SizedBox(width: 16),
              ]
            : null,
      ),
      body: _buildBody,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final tabsItem = _customTags.removeAt(oldIndex);
    _customTags.insert(newIndex, tabsItem);

    setState(() {});
  }

  Widget get _buildBody {
    return ReorderableListView.builder(
      onReorder: onReorder,
      proxyDecorator: proxyDecorator,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
      ),
      header: Column(
        children: _defTags.map((e) => _buildItem(e, enabled: false)).toList(),
      ),
      itemCount: _customTags.length,
      itemBuilder: (context, index) {
        return _buildItem(_customTags[index]);
      },
    );
  }

  Widget _buildItem(
    MemberTagItemModel item, {
    bool enabled = true,
  }) {
    return ListTile(
      textColor: enabled ? null : scheme.outline,
      key: ValueKey(item.tagid),
      leading: enabled
          ? const Icon(Icons.group_outlined)
          : Icon(
              size: 23,
              Icons.lock_outline,
              color: scheme.outline,
            ),
      minLeadingWidth: 0,
      title: Text('${item.name} (${item.count})'),
      subtitle: item.tip?.isNotEmpty == true ? Text(item.tip!) : null,
    );
  }
}
