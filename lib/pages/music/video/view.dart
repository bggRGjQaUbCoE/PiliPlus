import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/music/bgm_recommend_list.dart';
import 'package:PiliPlus/pages/music/video/controller.dart';
import 'package:PiliPlus/pages/music/widget/music_video_card_h.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MusicRecommendPage extends StatefulWidget {
  const MusicRecommendPage({super.key});

  @override
  State<MusicRecommendPage> createState() => _MusicRecommendPageState();
}

class _MusicRecommendPageState extends State<MusicRecommendPage>
    with GridMixin {
  final MusicRecommendController _controller = Get.putOrFind(
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
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) =>
                    MusicVideoCardH(videoItem: response[index]),
                itemCount: response.length,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildAppBar(ThemeData theme, EdgeInsets padding) {
    final info = _controller.musicDetail;
    return Obx(() {
      final isSearch = _controller.isSearchMode.value;
      return SliverAppBar(
        pinned: true,
        leading: isSearch
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _controller.isSearchMode.value = false;
                  _controller.searchController.clear();
                },
              )
            : null,
        title: isSearch
            ? TextField(
                autofocus: true,
                focusNode: _controller.searchFocusNode,
                controller: _controller.searchController,
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '搜索',
                  visualDensity: VisualDensity.standard,
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    tooltip: '清空',
                    icon: const Icon(Icons.clear, size: 22),
                    onPressed: () {
                      _controller.searchController.clear();
                      _controller.searchFocusNode.requestFocus();
                    },
                  ),
                ),
              )
            : Row(
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
                        final count =
                            _controller.loadingState.value.dataOrNull?.length;
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
        actions: [
          if (!isSearch) ...[
            IconButton(
              tooltip: '搜索',
              onPressed: () => _controller.isSearchMode.value = true,
              icon: const Icon(Icons.search_outlined),
            ),
            StaticPopupMenuButton<MusicRecommendOrderType>(
              icon: const Icon(Icons.sort),
              initialValue: _controller.order.value,
              tooltip: '排序方式',
              onSelected: (value) => _controller
                ..order.value = value
                ..applySortAndFilter(),
              itemBuilder: (context) => MusicRecommendOrderType.values
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e.label),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(width: 10),
          ]
        ],
      );
    });
  }
}
