import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/space_fav/datum.dart';
import 'package:PiliPlus/models/space_fav/list.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/content/favorite/member_favorite_ctr.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/content/favorite/widget/item.dart';
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
    return Obx(() => _buildBody(_controller.loadingState.value));
  }

  _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? refreshIndicator(
              onRefresh: () async {
                await _controller.onRefresh();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Obx(
                      () => _buildItem(_controller.first.value, true),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(
                      () => _buildItem(_controller.second.value, false),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 80 + MediaQuery.of(context).padding.bottom,
                    ),
                  )
                ],
              ),
            )
          : scrollErrorWidget(
              onReload: _controller.onReload,
            ),
      Error() => scrollErrorWidget(
          errMsg: loadingState.errMsg,
          onReload: _controller.onReload,
        ),
    };
  }

  _buildItem(Datum data, bool isFirst) {
    return Theme(
      data: Theme.of(context).copyWith(
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
                style: TextStyle(fontSize: 14),
              ),
              TextSpan(
                text: ' ${data.mediaListResponse?.count}',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        children: [
          ...(data.mediaListResponse?.list as List<FavList>).map(
            (item) => SizedBox(
              height: 98,
              child: MemberFavItem(
                item: item,
                callback: (res) {
                  if (res == true) {
                    _controller.first.value.mediaListResponse?.list
                        ?.remove(item);
                    _controller.first.refresh();
                  } else {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _controller.onRefresh();
                    });
                  }
                },
              ),
            ),
          ),
          Obx(
            () => (isFirst
                    ? _controller.firstEnd.value
                    : _controller.secondEnd.value)
                ? const SizedBox.shrink()
                : _buildLoadMoreItem(isFirst),
          ),
        ],
      ),
    );
  }

  _buildLoadMoreItem(bool isFirst) {
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
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
