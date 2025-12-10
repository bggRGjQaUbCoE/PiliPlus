import 'package:PiliPlus/common/skeleton/video_card_h.dart';
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
    with AutomaticKeepAliveClientMixin {
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
        physics: const AlwaysScrollableScrollPhysics(),
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

  Widget _buildBody(ThemeData theme, LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => SliverPadding(
        padding: const EdgeInsets.only(top: 7),
        sliver: SliverGrid.builder(
          gridDelegate: Grid.videoCardHDelegate(context),
          itemBuilder: (context, index) => const VideoCardHSkeleton(),
          itemCount: 10,
        ),
      ),
      Success(:var response) =>
        (response as List?)?.isNotEmpty == true
            ? SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: Obx(
                      () => _buildItem(theme, _controller.first.value, true),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(
                      () => _buildItem(theme, _controller.second.value, false),
                    ),
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

  Theme _buildItem(ThemeData theme, SpaceFavData data, bool isFirst) {
    return Theme(
      data: theme.copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        dense: true,
        initiallyExpanded: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: data.name,
                style: const TextStyle(fontSize: 14),
              ),
              TextSpan(
                text: ' ${data.mediaListResponse?.count}',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        children: [
          ...?data.mediaListResponse?.list?.map(
            (item) => SizedBox(
              height: 98,
              child: MemberFavItem(
                item: item,
                callback: (res) {
                  if (res == true) {
                    _controller
                      ..first.value.mediaListResponse?.list?.remove(item)
                      ..first.refresh();
                  }
                },
              ),
            ),
          ),
          Obx(
            () =>
                (isFirst
                    ? _controller.firstEnd.value
                    : _controller.secondEnd.value)
                ? const SizedBox.shrink()
                : _buildLoadMoreItem(theme, isFirst),
          ),
        ],
      ),
    );
  }

  ListTile _buildLoadMoreItem(ThemeData theme, bool isFirst) {
    return ListTile(
      dense: true,
      onTap: () {
        if (isFirst) {
          _controller.userfavFolder();
        } else {
          _controller.userSubFolder();
        }
      },
      title: Text(
        '查看更多内容',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
