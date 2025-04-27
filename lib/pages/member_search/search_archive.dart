import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/video_card_h.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/member/archive.dart';
import 'package:PiliPlus/pages/member_search/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SearchArchive extends StatefulWidget {
  const SearchArchive({
    super.key,
    required this.ctr,
  });

  final MemberSearchController ctr;

  @override
  State<SearchArchive> createState() => _SearchArchiveState();
}

class _SearchArchiveState extends State<SearchArchive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        await widget.ctr.refreshArchive();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: StyleString.safeSpace - 5,
              bottom: MediaQuery.paddingOf(context).bottom + 80,
            ),
            sliver:
                Obx(() => _buildBody(context, widget.ctr.archiveState.value)),
          )
        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, LoadingState<List<VListItemModel>?> loadingState) {
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
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: Grid.videoCardHDelegate(context),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == loadingState.response!.length - 1) {
                    EasyThrottle.throttle(
                        'searchArchives', const Duration(milliseconds: 500),
                        () {
                      widget.ctr.searchArchives(false);
                    });
                  }
                  return VideoCardH(
                    videoItem: loadingState.response![index],
                  );
                },
                childCount: loadingState.response!.length,
              ),
            )
          : HttpError(
              onReload: () {
                widget.ctr.archiveState.value = LoadingState.loading();
                widget.ctr.refreshArchive();
              },
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: () {
            widget.ctr.archiveState.value = LoadingState.loading();
            widget.ctr.refreshArchive();
          },
        ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
