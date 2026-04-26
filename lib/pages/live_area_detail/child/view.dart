import 'package:PiliPlus/common/skeleton/video_card_v.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/pages/live/widgets/live_item_app.dart';
import 'package:PiliPlus/pages/live_area_detail/child/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveAreaChildPage extends StatefulWidget {
  const LiveAreaChildPage({
    super.key,
    required this.areaId,
    required this.parentAreaId,
    required this.showFirstFrame,
  });

  final dynamic areaId;
  final dynamic parentAreaId;
  final bool showFirstFrame;

  @override
  State<LiveAreaChildPage> createState() => _LiveAreaChildPageState();
}

class _LiveAreaChildPageState extends State<LiveAreaChildPage>
    with AutomaticKeepAliveClientMixin {
  late final LiveAreaChildController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      LiveAreaChildController(widget.areaId, widget.parentAreaId),
      tag: '${widget.areaId}${widget.parentAreaId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ThemeData theme = Theme.of(context);
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        controller: _controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              left: Style.safeSpace,
              right: Style.safeSpace,
              top: Style.safeSpace,
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

  late final gridDelegate = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: Style.cardSpace,
    crossAxisSpacing: Style.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth,
    childAspectRatio: Style.aspectRatio,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(90),
  );

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<CardLiveItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverGrid.builder(
        gridDelegate: gridDelegate,
        itemBuilder: (context, index) => const VideoCardVSkeleton(),
        itemCount: 10,
      ),
      Success(:final response) => SliverMainAxisGroup(
        slivers: [
          if (_controller.newTags?.isNotEmpty == true)
            SliverToBoxAdapter(
              child: Obx(() {
                final tagIndex = _controller.tagIndex.value;
                return SelfSizedHorizontalList(
                  padding: const .only(bottom: 12),
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = _controller.newTags![index];
                    final isCurr = index == tagIndex;
                    return SearchText(
                      fontSize: 14,
                      padding: const .symmetric(horizontal: 8, vertical: 3),
                      text: item.name!,
                      bgColor: isCurr
                          ? theme.colorScheme.secondaryContainer
                          : Colors.transparent,
                      textColor: isCurr
                          ? theme.colorScheme.onSecondaryContainer
                          : null,
                      onTap: (value) =>
                          _controller.onSelectTag(index, item.sortType),
                    );
                  },
                  itemCount: _controller.newTags!.length,
                );
              }),
            ),
          response != null && response.isNotEmpty
              ? SliverGrid.builder(
                  gridDelegate: gridDelegate,
                  itemBuilder: (context, index) {
                    if (index == response.length - 1) {
                      _controller.onLoadMore();
                    }
                    return LiveCardVApp(
                      item: response[index],
                      showFirstFrame: widget.showFirstFrame,
                    );
                  },
                  itemCount: response.length,
                )
              : HttpError(onReload: _controller.onReload),
        ],
      ),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
