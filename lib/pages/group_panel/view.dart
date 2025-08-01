import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/member/tags.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class GroupPanel extends StatefulWidget {
  final int mid;
  final List? tags;
  final ScrollController? scrollController;
  const GroupPanel({
    super.key,
    required this.mid,
    this.tags,
    this.scrollController,
  });

  @override
  State<GroupPanel> createState() => _GroupPanelState();
}

class _GroupPanelState extends State<GroupPanel> {
  LoadingState<List<MemberTagItemModel>> loadingState = LoadingState.loading();
  RxBool showDefaultBtn = true.obs;
  late final Set<int> tags = widget.tags?.cast<int>().toSet() ?? {};

  @override
  void initState() {
    super.initState();
    _query();
  }

  void _query() {
    MemberHttp.followUpTags().then((res) {
      if (mounted) {
        loadingState = res..dataOrNull.removeFirstWhere((e) => e.tagid == 0);
        showDefaultBtn.value = tags.isEmpty;
        setState(() {});
      }
    });
  }

  Future<void> onSave() async {
    if (!loadingState.isSuccess) {
      Get.back();
      return;
    }
    feedBack();
    // 保存
    final res = await MemberHttp.addUsers(
      widget.mid.toString(),
      tags.isEmpty ? '0' : tags.join(','),
    );
    SmartDialog.showToast(res['msg']);
    if (res['status']) {
      Get.back(result: tags);
    }
  }

  Widget get _buildBody {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success(:var response) => ListView.builder(
        controller: widget.scrollController,
        itemCount: response.length,
        itemBuilder: (context, index) {
          final item = response[index];
          return Material(
            type: MaterialType.transparency,
            child: Builder(
              builder: (context) {
                void onTap() {
                  final tagid = item.tagid!;
                  if (tags.contains(tagid)) {
                    tags.remove(tagid);
                    item.count--;
                  } else {
                    tags.add(tagid);
                    item.count++;
                  }
                  (context as Element).markNeedsBuild();
                  showDefaultBtn.value = tags.isEmpty;
                }

                return ListTile(
                  onTap: onTap,
                  dense: true,
                  leading: const Icon(Icons.group_outlined),
                  minLeadingWidth: 0,
                  title: Text('${item.name} (${item.count})'),
                  subtitle: item.tip?.isNotEmpty == true
                      ? Text(item.tip!)
                      : null,
                  trailing: Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: tags.contains(item.tagid),
                      onChanged: (_) => onTap(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      Error(:var errMsg) => scrollErrorWidget(
        controller: widget.scrollController,
        errMsg: errMsg,
        onReload: _query,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            tooltip: '关闭',
            onPressed: Get.back,
            icon: const Icon(Icons.close_outlined),
          ),
          title: const Text('设置关注分组'),
        ),
        Expanded(child: _buildBody),
        Divider(
          height: 1,
          color: theme.disabledColor.withValues(alpha: 0.08),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.paddingOf(context).bottom + 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onSave,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  foregroundColor: theme.colorScheme.onPrimary,
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: Obx(() => Text(showDefaultBtn.value ? '保存至默认分组' : '保存')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
