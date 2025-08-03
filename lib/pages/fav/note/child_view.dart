import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_note/list.dart';
import 'package:PiliPlus/pages/fav/note/controller.dart';
import 'package:PiliPlus/pages/fav/note/widget/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavNoteChildPage extends StatefulWidget {
  const FavNoteChildPage({super.key, required this.isPublish});

  final bool isPublish;

  @override
  State<FavNoteChildPage> createState() => _FavNoteChildPageState();
}

class _FavNoteChildPageState extends State<FavNoteChildPage>
    with AutomaticKeepAliveClientMixin {
  late final FavNoteController _favNoteController = Get.put(
    FavNoteController(widget.isPublish),
    tag: '${widget.isPublish}',
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final padding = MediaQuery.paddingOf(context);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [
          refreshIndicator(
            onRefresh: _favNoteController.onRefresh,
            child: CustomScrollView(
              controller: _favNoteController.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(bottom: padding.bottom + 80),
                  sliver: Obx(
                    () => _buildBody(_favNoteController.loadingState.value),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: constraints.maxHeight,
            left: 0,
            right: 0,
            child: Obx(
              () => AnimatedSlide(
                offset: _favNoteController.enableMultiSelect.value
                    ? const Offset(0, -1)
                    : Offset.zero,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onInverseSurface,
                    border: Border(
                      top: BorderSide(
                        width: 0.5,
                        color: theme.colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  width: double.infinity,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      iconButton(
                        size: 32,
                        tooltip: '取消',
                        context: context,
                        icon: Icons.clear,
                        onPressed: _favNoteController.onDisable,
                      ),
                      const SizedBox(width: 12),
                      Obx(
                        () => Checkbox(
                          value: _favNoteController.allSelected.value,
                          onChanged: (value) {
                            _favNoteController.handleSelect(
                              !_favNoteController.allSelected.value,
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _favNoteController.handleSelect(
                          !_favNoteController.allSelected.value,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                            top: 14,
                            bottom: 14,
                            right: 12,
                          ),
                          child: Text('全选'),
                        ),
                      ),
                      const Spacer(),
                      FilledButton.tonal(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          if (_favNoteController.checkedCount != 0) {
                            showConfirmDialog(
                              context: context,
                              title: '确定删除已选中的笔记吗？',
                              onConfirm: _favNoteController.onConfirm,
                            );
                          }
                        },
                        child: const Text('删除'),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<FavNoteItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid(
        gridDelegate: Grid.videoCardHDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const VideoCardHSkeleton();
          },
          childCount: 10,
        ),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid(
                gridDelegate: Grid.videoCardHDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == response.length - 1) {
                      _favNoteController.onLoadMore();
                    }
                    final item = response[index];
                    return FavNoteItem(
                      item: item,
                      ctr: _favNoteController,
                      onSelect: () => _favNoteController.onSelect(item),
                    );
                  },
                  childCount: response!.length,
                ),
              )
            : HttpError(onReload: _favNoteController.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _favNoteController.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
