import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space_fav/data.dart';
import 'package:PiliPlus/pages/member_favorite/controller.dart';
import 'package:PiliPlus/pages/member_favorite/widget/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberFavorite extends StatefulWidget {
  const MemberFavorite({
    super.key,
    required this.heroTag,
    required this.mid,
  });

  final String? heroTag;
  final int mid;

  @override
  State<MemberFavorite> createState() => _MemberFavoriteState();
}

class _MemberFavoriteState extends State<MemberFavorite>
    with AutomaticKeepAliveClientMixin, GridMixin {
  @override
  bool get wantKeepAlive => true;

  late final _controller = Get.put(
    MemberFavoriteCtr(mid: widget.mid),
    tag: widget.heroTag,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        physics: _FavScrollPhysics(controller: _controller),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
            sliver: Obx(
              () => _buildBody(theme, _controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<SpaceFavData>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverPadding(
        padding: const EdgeInsets.only(top: 7),
        sliver: SliverGrid.builder(
          gridDelegate: Grid.videoCardHDelegate(context),
          itemBuilder: (context, index) => const VideoCardHSkeleton(),
          itemCount: 10,
        ),
      ),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverMainAxisGroup(
                slivers: [
                  _buildItem(
                    theme,
                    data: _controller.favState,
                    isEnd: _controller.favEnd,
                    isFav: true,
                  ),
                  _buildItem(
                    theme,
                    data: _controller.subState,
                    isEnd: _controller.subEnd,
                    isFav: false,
                  ),
                ],
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildItem(
    ThemeData theme, {
    required Rx<SpaceFavData> data,
    required RxBool isEnd,
    required bool isFav,
  }) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: CustomSliverPersistentHeaderDelegate(
            child: Material(
              color: theme.colorScheme.surface,
              child: Builder(
                builder: (context) {
                  return InkWell(
                    onTap: () {
                      _controller.setExpand(isFav);
                      (context as Element).markNeedsBuild();
                      data.refresh();
                      if (!isEnd.value) {
                        isEnd.refresh();
                      }
                    },
                    child: Container(
                      height: 45,
                      alignment: .centerLeft,
                      padding: const .only(left: 12),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: .middle,
                              child: Icon(
                                _controller.isExpand(isFav)
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            TextSpan(
                              text: ' ${data.value.name}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            TextSpan(
                              text: ' ${data.value.mediaListResponse?.count}',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            bgColor: null,
          ),
        ),
        Obx(() {
          final list = data.value.mediaListResponse?.list;
          if (!_controller.isExpand(isFav)) {
            return const SliverToBoxAdapter();
          }
          if (list != null && list.isNotEmpty) {
            return SliverGrid.builder(
              gridDelegate: gridDelegate,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return SizedBox(
                  height: 98,
                  child: MemberFavItem(
                    item: item,
                    onDelete: (isDeleted) {
                      if (isDeleted ?? false) {
                        _controller.favState
                          ..value.mediaListResponse?.list?.remove(item)
                          ..refresh();
                      }
                    },
                  ),
                );
              },
            );
          }
          return const SliverToBoxAdapter();
        }),
        Obx(
          () => isEnd.value || !_controller.isExpand(isFav)
              ? const SliverToBoxAdapter()
              : SliverToBoxAdapter(child: _buildLoadMoreItem(theme, isFav)),
        ),
      ],
    );
  }

  Widget _buildLoadMoreItem(ThemeData theme, bool isFav) {
    return Padding(
      padding: const .only(top: 7),
      child: InkWell(
        onTap: () {
          if (isFav) {
            _controller.userFavFolder();
          } else {
            _controller.userSubFolder();
          }
        },
        child: Container(
          height: 40,
          alignment: .center,
          child: Text(
            '查看更多内容',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

class _FavScrollPhysics extends AlwaysScrollableScrollPhysics {
  const _FavScrollPhysics({super.parent, required this.controller});

  final MemberFavoriteCtr controller;

  @override
  _FavScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _FavScrollPhysics(
      parent: buildParent(ancestor),
      controller: controller,
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (controller.flag) {
      controller.flag = false;
      return 0;
    }
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }
}
