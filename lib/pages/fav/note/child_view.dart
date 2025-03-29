import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
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
  late final FavNoteController _favNoteController =
      Get.put(FavNoteController(widget.isPublish), tag: '${widget.isPublish}');

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [
          refreshIndicator(
            onRefresh: () async {
              await _favNoteController.onRefresh();
            },
            child: CustomScrollView(
              slivers: [
                Obx(() => _buildBody(_favNoteController.loadingState.value)),
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
                    ? Offset(0, -1)
                    : Offset.zero,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding: MediaQuery.paddingOf(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    border: Border(
                      top: BorderSide(
                        width: 0.5,
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.5),
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
                                !_favNoteController.allSelected.value);
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _favNoteController.handleSelect(
                              !_favNoteController.allSelected.value);
                        },
                        child: const Text('全选'),
                      ),
                      const Spacer(),
                      FilledButton.tonal(
                        style: TextButton.styleFrom(
                          visualDensity:
                              VisualDensity(horizontal: -2, vertical: -2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          showConfirmDialog(
                            context: context,
                            title: '确定删除已选中的笔记吗？',
                            onConfirm: _favNoteController.onRemove,
                          );
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

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 2,
            maxCrossAxisExtent: Grid.mediumCardWidth * 2,
            childAspectRatio: StyleString.aspectRatio * 2.2,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const VideoCardHSkeleton();
            },
            childCount: 10,
          ),
        ),
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 2,
                  maxCrossAxisExtent: Grid.mediumCardWidth * 2,
                  childAspectRatio: StyleString.aspectRatio * 2.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return FavNoteItem(
                      item: loadingState.response[index],
                      ctr: _favNoteController,
                      onSelect: () {
                        _favNoteController.onSelect(index);
                      },
                    );
                  },
                  childCount: loadingState.response.length,
                ),
              ),
            )
          : HttpError(callback: _favNoteController.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          callback: _favNoteController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
