import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/music/bgm_recommend_list.dart';
import 'package:PiliPlus/pages/music/video/controller.dart';
import 'package:PiliPlus/pages/music/widget/music_video_card_h.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicRecommandPage extends StatefulWidget {
  const MusicRecommandPage({super.key});

  @override
  State<MusicRecommandPage> createState() => _MusicRecommandPageState();
}

class _MusicRecommandPageState extends State<MusicRecommandPage>
    with GridMixin {
  late final MusicRecommendController _controller = Get.putOrFind(
    MusicRecommendController.new,
    tag: (Get.arguments as MusicRecommendArgs).id,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    return Material(
      color: theme.colorScheme.surface,
      child: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(theme, padding),
            SliverPadding(
              padding: EdgeInsets.only(
                top: 7,
                left: padding.left,
                right: padding.right,
                bottom: padding.bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(_controller.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<BgmRecommend>?> loadingState) {
    return switch (loadingState) {
      Loading() => gridSkeleton,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) =>
                    MusicVideoCardH(videoItem: response[index]),
                itemCount: response!.length,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildAppBar(ThemeData theme, EdgeInsets padding) {
    final info = _controller.musicDetail;
    return SliverAppBar(
      pinned: true,
      title: Row(
        spacing: 12,
        children: [
          NetworkImgLayer(
            width: 40,
            height: 40,
            src: info.mvCover,
            type: ImageType.avatar,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.musicTitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              Obx(() {
                final count = _controller.loadingState.value.dataOrNull?.length;
                return count == null
                    ? const SizedBox.shrink()
                    : Text(
                        '共$count条视频',
                        style: theme.textTheme.labelMedium,
                      );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
