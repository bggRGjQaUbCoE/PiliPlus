import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/utils/fav_utils.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavPanel extends StatefulWidget {
  const FavPanel({
    super.key,
    required this.ctr,
    this.scrollController,
  });

  final CommonIntroController ctr;
  final ScrollController? scrollController;

  @override
  State<FavPanel> createState() => _FavPanelState();
}

class _FavPanelState extends State<FavPanel> {
  LoadingState loadingState = LoadingState.loading();

  @override
  void initState() {
    super.initState();
    _query();
  }

  Future<void> _query() async {
    var res = await widget.ctr.queryVideoInFolder();
    if (mounted) {
      loadingState = res;
      setState(() {});
    }
  }

  Widget get _buildBody {
    late final list = widget.ctr.favFolderData.value.list!;
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => ListView.builder(
        controller: widget.scrollController,
        itemCount: list.length,
        itemBuilder: (context, index) {
          FavFolderInfo item = list[index];
          return Material(
            type: MaterialType.transparency,
            child: Builder(
              builder: (context) {
                void onTap() {
                  bool isChecked = item.favState == 1;
                  item
                    ..favState = isChecked ? 0 : 1
                    ..mediaCount = isChecked
                        ? item.mediaCount - 1
                        : item.mediaCount + 1;
                  (context as Element).markNeedsBuild();
                }

                return ListTile(
                  onTap: onTap,
                  dense: true,
                  leading: FavUtils.isPublicFav(item.attr)
                      ? const Icon(Icons.folder_outlined)
                      : const Icon(Icons.lock_outline),
                  minLeadingWidth: 0,
                  title: Text(item.title),
                  subtitle: Text(
                    '${item.mediaCount}个内容 . ${FavUtils.isPublicFavText(item.attr)}',
                  ),
                  trailing: Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: item.favState == 1,
                      onChanged: (bool? checkValue) => onTap(),
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
    final theme = Theme.of(context).colorScheme;
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            tooltip: '关闭',
            onPressed: Get.back,
            icon: const Icon(Icons.close_outlined),
          ),
          title: const Text('添加到收藏夹'),
          actions: [
            TextButton.icon(
              onPressed: () => Get.toNamed('/createFav')?.then((data) {
                if (data != null) {
                  widget.ctr.favFolderData
                    ..value.list?.insert(1, data)
                    ..refresh();
                }
              }),
              icon: Icon(
                Icons.add,
                color: theme.primary,
              ),
              label: const Text('新建收藏夹'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        Expanded(child: _buildBody),
        Divider(
          height: 1,
          color: theme.outline.withValues(alpha: 0.1),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 12,
          ),
          child: Row(
            spacing: 25,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.tonal(
                onPressed: Get.back,
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: theme.outline,
                  backgroundColor: theme.onInverseSurface,
                ),
                child: const Text('取消'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  feedBack();
                  widget.ctr.actionFavVideo();
                },
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('完成'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
