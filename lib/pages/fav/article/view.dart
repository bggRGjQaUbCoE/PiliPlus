import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/fav/article/controller.dart';
import 'package:PiliPlus/pages/fav/article/widget/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavArticlePage extends StatefulWidget {
  const FavArticlePage({super.key});

  @override
  State<FavArticlePage> createState() => _FavArticlePageState();
}

class _FavArticlePageState extends State<FavArticlePage>
    with AutomaticKeepAliveClientMixin {
  final FavArticleController _favArticleController =
      Get.put(FavArticleController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        await _favArticleController.onRefresh();
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: StyleString.safeSpace - 5,
              bottom: MediaQuery.paddingOf(context).bottom + 80,
            ),
            sliver:
                Obx(() => _buildBody(_favArticleController.loadingState.value)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<dynamic>?> loadingState) {
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
                    _favArticleController.onLoadMore();
                  }
                  return FavArticleItem(
                    item: loadingState.response![index],
                    onDelete: () {
                      showConfirmDialog(
                          context: context,
                          title: '确定取消收藏？',
                          onConfirm: () {
                            _favArticleController.onRemove(
                              index,
                              loadingState.response![index]['opus_id'],
                            );
                          });
                    },
                  );
                },
                childCount: loadingState.response!.length,
              ),
            )
          : HttpError(onReload: _favArticleController.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _favArticleController.onReload,
        ),
    };
  }
}
