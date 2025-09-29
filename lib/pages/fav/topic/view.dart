import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_topic/topic_item.dart';
import 'package:PiliPlus/pages/fav/topic/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavTopicPage extends StatefulWidget {
  const FavTopicPage({super.key});

  @override
  State<FavTopicPage> createState() => _FavTopicPageState();
}

class _FavTopicPageState extends State<FavTopicPage>
    with AutomaticKeepAliveClientMixin {
  final FavTopicController _controller = Get.put(FavTopicController());

  @override
  bool get wantKeepAlive => true;

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
              left: StyleString.safeSpace,
              right: StyleString.safeSpace,
              top: StyleString.safeSpace,
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

  late final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    maxCrossAxisExtent: Grid.smallCardWidth,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(30),
  );

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<FavTopicItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => const SliverToBoxAdapter(
        child: SizedBox(
          height: 125,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _controller.onLoadMore();
                  }
                  final item = response[index];

                  void onLongPress() => showConfirmDialog(
                    context: context,
                    title: '确定取消收藏？',
                    onConfirm: () => _controller.onRemove(index, item.id),
                  );

                  return Material(
                    color: theme.colorScheme.onInverseSurface,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: InkWell(
                      onTap: () => Get.toNamed(
                        '/dynTopic',
                        parameters: {
                          'id': item.id!.toString(),
                          'name': item.name!,
                        },
                      ),
                      onLongPress: Utils.isMobile ? onLongPress : null,
                      onSecondaryTap: Utils.isMobile ? null : onLongPress,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 5,
                        ),
                        child: Text(
                          '# ${item.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: response!.length,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
