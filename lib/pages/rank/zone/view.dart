import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/rank/zone/controller.dart';
import 'package:PiliPlus/pages/rank/zone/widget/pgc_rank_item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZonePage extends StatelessWidget {
  const ZonePage({super.key, this.rid, this.seasonType});

  final int? rid;
  final int? seasonType;

  @override
  Widget build(BuildContext context) {
    final tag = '$rid$seasonType';
    final controller = Get.put(
      ZoneController(rid: rid, seasonType: seasonType),
      tag: tag,
    );

    final gridDelegate = Grid.videoCardHDelegate(context);

    Widget buildBody(LoadingState<List<dynamic>?> loadingState) {
      return switch (loadingState) {
        Loading() => SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemBuilder: (_, _) => const VideoCardHSkeleton(),
          itemCount: 10,
        ),
        Success(:final response) =>
          response != null && response.isNotEmpty
              ? SliverGrid.builder(
                  gridDelegate: gridDelegate,
                  itemBuilder: (context, index) {
                    final item = response[index];
                    if (item is HotVideoItemModel) {
                      return VideoCardH(
                        videoItem: item,
                        onRemove: () => controller.loadingState
                          ..value.data!.removeAt(index)
                          ..refresh(),
                      );
                    }
                    return PgcRankItem(item: item);
                  },
                  itemCount: response.length,
                )
              : HttpError(onReload: controller.onReload),
        Error(:final errMsg) => HttpError(
          errMsg: errMsg,
          onReload: controller.onReload,
        ),
      };
    }

    return refreshIndicator(
      onRefresh: controller.onRefresh,
      child: CustomScrollView(
        key: PageStorageKey(tag),
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 7, bottom: 100),
            sliver: Obx(() => buildBody(controller.loadingState.value)),
          ),
        ],
      ),
    );
  }
}
