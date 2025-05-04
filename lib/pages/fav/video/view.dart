import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/user/fav_folder.dart';
import 'package:PiliPlus/pages/fav/video/controller.dart';
import 'package:PiliPlus/pages/fav/video/widgets/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavVideoPage extends StatefulWidget {
  const FavVideoPage({super.key});

  @override
  State<FavVideoPage> createState() => _FavVideoPageState();
}

class _FavVideoPageState extends State<FavVideoPage>
    with AutomaticKeepAliveClientMixin {
  final FavController _favController = Get.find<FavController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: () async {
        await _favController.onRefresh();
      },
      child: CustomScrollView(
        controller: _favController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: StyleString.safeSpace - 5,
              bottom: 80 + MediaQuery.paddingOf(context).bottom,
            ),
            sliver: Obx(
              () => _buildBody(_favController.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(LoadingState<List<FavFolderItemData>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid(
          gridDelegate: Grid.videoCardHDelegate(context),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return const VideoCardHSkeleton();
            },
            childCount: 10,
          ),
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: Grid.videoCardHDelegate(context),
              delegate: SliverChildBuilderDelegate(
                childCount: loadingState.response!.length,
                (BuildContext context, int index) {
                  if (index == loadingState.response!.length - 1) {
                    _favController.onLoadMore();
                  }
                  final item = loadingState.response![index];
                  String heroTag = Utils.makeHeroTag(item.fid);
                  return FavItem(
                    heroTag: heroTag,
                    favFolderItem: item,
                    onTap: () async {
                      dynamic res = await Get.toNamed(
                        '/favDetail',
                        arguments: item,
                        parameters: {
                          'heroTag': heroTag,
                          'mediaId': item.id.toString(),
                        },
                      );
                      if (res == true) {
                        _favController.loadingState.value.data!.removeAt(index);
                        _favController.loadingState.refresh();
                      }
                    },
                  );
                },
              ),
            )
          : HttpError(
              onReload: _favController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _favController.onReload,
        ),
    };
  }
}
