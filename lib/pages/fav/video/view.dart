import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/fav/video/controller.dart';
import 'package:PiliPlus/pages/fav/video/widgets/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class FavVideoPage extends StatefulWidget {
  const FavVideoPage({super.key});

  @override
  State<FavVideoPage> createState() => _FavVideoPageState();
}

class _FavVideoPageState extends State<FavVideoPage>
    with AutomaticKeepAliveClientMixin, GridMixin {
  final FavController _favController = Get.find<FavController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: _favController.onRefresh,
      child: CustomScrollView(
        controller: _favController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: 7,
              bottom: 100 + MediaQuery.viewPaddingOf(context).bottom,
            ),
            sliver: Obx(
              () => _buildBody(_favController.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<FavFolderInfo>?> loadingState) {
    switch (loadingState) {
      case Loading():
        return gridSkeleton;
      case Success(:final response):
        if (response == null || response.isEmpty) {
          return HttpError(onReload: _favController.onReload);
        }
        final folders = _favController.visibleFolders(response);
        if (folders.isEmpty) {
          return HttpError(
            errMsg: '没有找到匹配收藏夹',
            onReload: _favController.isEnd ? null : _favController.onLoadMore,
            btnText: '加载更多收藏夹',
          );
        }
        return SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemBuilder: (BuildContext context, int index) {
            if (index == folders.length - 1) {
              _favController.onLoadMore();
            }
            final item = folders[index];
            String heroTag = Utils.makeHeroTag(item.fid);
            return FavVideoItem(
              heroTag: heroTag,
              item: item,
              onTap: () async {
                final res = await Get.toNamed(
                  '/favDetail',
                  arguments: item,
                  parameters: {
                    'heroTag': heroTag,
                    'mediaId': item.id.toString(),
                  },
                );
                if (res == true) {
                  _favController.loadingState
                    ..value.data!.remove(item)
                    ..refresh();
                }
              },
            );
          },
          itemCount: folders.length,
        );
      case Error(:final errMsg):
        return HttpError(
          errMsg: errMsg,
          onReload: _favController.onReload,
        );
    }
  }
}
