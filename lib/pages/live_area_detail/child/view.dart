import 'package:PiliPlus/common/skeleton/video_card_v.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/pages/live/widgets/live_item_app.dart';
import 'package:PiliPlus/pages/live_area_detail/child/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

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

  late ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

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
              bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
            sliver: Obx(() => _buildBody(_controller.loadingState.value)),
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

  Widget _buildBody(LoadingState<List<CardLiveItem>?> loadingState) {
    switch (loadingState) {
      case Loading():
        return SliverPadding(
          padding: const .only(top: Style.safeSpace),
          sliver: SliverGrid(
            gridDelegate: gridDelegate,
            delegate: const SliverSingleChildDelegate(
              count: 10,
              child: VideoCardVSkeleton(),
            ),
          ),
        );
      case Success(:final response):
        final Widget child;
        if (response != null && response.isNotEmpty) {
          child = SliverGrid.builder(
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
          );
        } else {
          child = HttpError(onReload: _controller.onReload);
        }
        if (_controller.newTags case final newTags? when newTags.isNotEmpty) {
          return SliverMainAxisGroup(
            slivers: [
              SliverPinnedHeader(
                backgroundColor: colorScheme.surface,
                child: SizedBox(
                  height: 48,
                  child: Obx(() {
                    final tagIndex = _controller.tagIndex.value;
                    return ListView.separated(
                      scrollDirection: .horizontal,
                      padding: const .symmetric(vertical: Style.safeSpace),
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = newTags[index];
                        final isCurr = index == tagIndex;
                        return SearchText(
                          height: 1,
                          fontSize: 14,
                          padding: const .symmetric(horizontal: 8, vertical: 5),
                          text: item.name!,
                          bgColor: isCurr
                              ? colorScheme.secondaryContainer
                              : Colors.transparent,
                          textColor: isCurr
                              ? colorScheme.onSecondaryContainer
                              : null,
                          onTap: (value) =>
                              _controller.onSelectTag(index, item.sortType),
                        );
                      },
                      itemCount: newTags.length,
                    );
                  }),
                ),
              ),
              child,
            ],
          );
        }
        return SliverPadding(
          padding: const .only(top: Style.safeSpace),
          sliver: child,
        );
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _controller.onReload,
        );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
