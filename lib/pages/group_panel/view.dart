import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/member/tags.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class GroupPanel extends StatefulWidget {
  final int mid;
  final List<int>? tags;
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
  final RxBool showDefaultBtn = true.obs;
  late final Set<int> tags = widget.tags == null
      ? {}
      : Set<int>.from(widget.tags!);

  @override
  void initState() {
    super.initState();
    _queryFollowUpTags();
  }

  void _queryFollowUpTags() {
    MemberHttp.followUpTags().then((res) {
      if (mounted) {
        loadingState = res..dataOrNull?.removeFirstWhere((e) => e.tagid == 0);
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
    if (res.isSuccess) {
      SmartDialog.showToast('保存成功');
      Get.back(result: tags);
    } else {
      res.toast();
    }
  }

  Widget get _buildBody {
    return switch (loadingState) {
      Loading() => m3eLoading,
      Success(:final response) => ListView.builder(
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
      Error(:final errMsg) => scrollErrorWidget(
        controller: widget.scrollController,
        errMsg: errMsg,
        onReload: _queryFollowUpTags,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: .end,
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            tooltip: '关闭',
            onPressed: Get.back,
            icon: const Icon(Icons.close_outlined),
          ),
          title: const Text('设置关注分组'),
          actions: [
            TextButton.icon(
              onPressed: () =>
                  RequestUtils.createFavTag(context, _onCreateFavTag),
              icon: Icon(Icons.add, color: theme.colorScheme.primary),
              label: const Text('新建分组'),
              style: const ButtonStyle(
                visualDensity: .compact,
                padding: WidgetStatePropertyAll(
                  .symmetric(horizontal: 18, vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        Expanded(child: _buildBody),
        Divider(
          height: 1,
          color: theme.disabledColor.withValues(alpha: 0.08),
        ),
        Padding(
          padding: .only(
            right: 20,
            top: 12,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 12,
          ),
          child: FilledButton.tonal(
            onPressed: onSave,
            style: const ButtonStyle(visualDensity: .compact),
            child: Obx(() => Text(showDefaultBtn.value ? '保存至默认分组' : '保存')),
          ),
        ),
      ],
    );
  }

  void _onCreateFavTag(({int tagid, String tagName}) res) {
    if (!mounted) return;
    if (loadingState case Success(:final response)) {
      response.add(MemberTagItemModel.fromCreate(res, count: 1));
      tags.add(res.tagid);
      showDefaultBtn.value = false;
      setState(() {});
    } else {
      _queryFollowUpTags();
    }
  }
}
