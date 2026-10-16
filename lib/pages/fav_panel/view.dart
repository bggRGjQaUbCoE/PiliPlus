import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class FavPanel extends StatefulWidget {
  const FavPanel({
    super.key,
    required this.ctr,
    this.scrollController,
  });

  final FavMixin ctr;
  final ScrollController? scrollController;

  @override
  State<FavPanel> createState() => _FavPanelState();
}

class _FavPanelState extends State<FavPanel> {
  LoadingState loadingState = LoadingState.loading();
  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();
    _queryVideoInFolder();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  Future<void> _queryVideoInFolder() async {
    final res = await widget.ctr.queryVideoInFolder();
    if (mounted) {
      loadingState = res;
      setState(() {});
    }
  }

  Widget get _buildBody {
    switch (loadingState) {
      case Loading():
        return m3eLoading;
      case Success():
        final list = widget.ctr.favFolderData.value.list!;
        return ListView.builder(
          controller: widget.scrollController,
          itemCount: list.length,
          itemBuilder: (context, index) {
            FavFolderInfo item = list[index];
            return Material(
              type: .transparency,
              child: Builder(
                builder: (context) {
                  final isChecked = item.favState == 1;

                  void onTap() {
                    item
                      ..favState = isChecked ? 0 : 1
                      ..mediaCount += isChecked ? -1 : 1;
                    (context as Element).markNeedsBuild();
                  }

                  final isFull =
                      BiliUtils.isFavFolderFull(item.attr, item.mediaCount) &&
                      !isChecked;
                  TextStyle? textStyle;
                  if (isFull) {
                    textStyle = TextStyle(color: colorScheme.outline);
                  }

                  return ListTile(
                    onTap: isFull ? null : onTap,
                    dense: true,
                    leading: BiliUtils.isPublicFav(item.attr)
                        ? isFull
                              ? Icon(
                                  Icons.folder_outlined,
                                  color: colorScheme.outline,
                                )
                              : const Icon(Icons.folder_outlined)
                        : isFull
                        ? Icon(
                            Icons.lock_outline,
                            color: colorScheme.outline,
                          )
                        : const Icon(Icons.lock_outline),
                    minLeadingWidth: 0,
                    title: Text(item.title),
                    subtitle: Text(
                      '${NumUtils.numFormat(item.mediaCount)}个内容${isFull ? '(已满)' : ''} · ${BiliUtils.isPublicFavText(item.attr)}',
                      style: textStyle,
                    ),
                    trailing: isFull
                        ? Padding(
                            padding: const .only(right: 8),
                            child: Icon(
                              size: 21.6,
                              color: colorScheme.outline,
                              Icons.indeterminate_check_box_outlined,
                            ),
                          )
                        : Transform.scale(
                            scale: 0.9,
                            alignment: .centerRight,
                            child: Checkbox(
                              value: isChecked,
                              materialTapTargetSize: .shrinkWrap,
                              onChanged: (bool? checkValue) => onTap(),
                            ),
                          ),
                  );
                },
              ),
            );
          },
        );
      case Error(:final errMsg):
        return scrollErrorWidget(
          errMsg: errMsg,
          controller: widget.scrollController,
          onReload: _queryVideoInFolder,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                if (data is FavFolderInfo && mounted) {
                  widget.ctr.favFolderData.value.list?.insert(
                    1,
                    data
                      ..favState = 1
                      ..mediaCount = 1,
                  );
                  setState(() {});
                }
              }),
              icon: Icon(Icons.add, color: colorScheme.primary),
              label: const Text('新建收藏夹'),
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
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
        Padding(
          padding: .only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 12,
          ),
          child: Row(
            spacing: 25,
            mainAxisAlignment: .end,
            children: [
              FilledButton.tonal(
                onPressed: Get.back,
                style: FilledButton.styleFrom(
                  visualDensity: .compact,
                  foregroundColor: colorScheme.outline,
                  backgroundColor: colorScheme.onInverseSurface,
                ),
                child: const Text('取消'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  feedBack();
                  widget.ctr.actionFavVideo();
                },
                style: const ButtonStyle(visualDensity: .compact),
                child: const Text('完成'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
