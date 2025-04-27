import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/rank/zone/widget/pgc_rank_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/video_card_h.dart';
import 'package:PiliPlus/pages/rank/zone/index.dart';

import '../../../utils/grid.dart';

class ZonePage extends CommonPage {
  const ZonePage({super.key, this.rid, this.seasonType});

  final int? rid;
  final int? seasonType;

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends CommonPageState<ZonePage, ZoneController>
    with AutomaticKeepAliveClientMixin {
  @override
  late ZoneController controller = Get.put(
    ZoneController(rid: widget.rid, seasonType: widget.seasonType),
    tag: '${widget.rid}${widget.seasonType}',
  );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        await controller.onRefresh();
      },
      child: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: StyleString.safeSpace - 5,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            sliver: Obx(() => _buildBody(controller.loadingState.value)),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return SliverGrid(
      gridDelegate: Grid.videoCardHDelegate(context),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const VideoCardHSkeleton();
        },
        childCount: 10,
      ),
    );
  }

  Widget _buildBody(LoadingState<List<dynamic>?> loadingState) {
    return switch (loadingState) {
      Loading() => _buildSkeleton(),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: Grid.videoCardHDelegate(context),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = loadingState.response![index];
                  if (item is HotVideoItemModel) {
                    return VideoCardH(
                      videoItem: item,
                      showPubdate: true,
                    );
                  }
                  return PgcRankItem(item: item);
                },
                childCount: loadingState.response!.length,
              ),
            )
          : HttpError(onReload: controller.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: controller.onReload,
        ),
    };
  }
}
