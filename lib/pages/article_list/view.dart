import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/article/article_list/article.dart';
import 'package:PiliPlus/models_new/article/article_list/list.dart';
import 'package:PiliPlus/pages/article_list/controller.dart';
import 'package:PiliPlus/pages/article_list/widgets/item.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> with GridMixin {
  final _controller = Get.put(
    ArticleListController(),
    tag: Utils.generateRandomString(8),
  );

  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    padding = MediaQuery.viewPaddingOf(context);
    return Material(
      color: theme.colorScheme.surface,
      child: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            Obx(() => _buildHeader(theme, _controller.list.value)),
            SliverPadding(
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
                bottom: padding.bottom + 100,
              ),
              sliver: Obx(
                () => _buildBody(theme, _controller.loadingState.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget get gridSkeleton => SliverPadding(
    padding: EdgeInsets.only(
      top: padding.top + kToolbarHeight + 120,
    ),
    sliver: super.gridSkeleton,
  );

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<ArticleListItemModel>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => gridSkeleton,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) =>
                    ArticleListItem(item: response[index]),
                itemCount: response!.length,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildHeader(ThemeData theme, ArticleListInfo? item) {
    if (item == null) {
      return const SliverToBoxAdapter();
    }
    late final style = TextStyle(color: theme.colorScheme.onSurfaceVariant);
    late final divider = TextSpan(
      text: '  |  ',
      style: TextStyle(color: theme.colorScheme.outline.withValues(alpha: 0.7)),
    );
    return SliverAppBar.medium(
      title: Text(item.name!),
      pinned: true,
      expandedHeight: kToolbarHeight + 127,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 120,
          margin: EdgeInsets.only(
            left: 12 + padding.left,
            right: 12,
            top: padding.top + kToolbarHeight,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.imageUrl?.isNotEmpty == true) ...[
                NetworkImgLayer(
                  width: 91,
                  height: 120,
                  src: item.imageUrl,
                  radius: 6,
                ),
                const SizedBox(width: 10),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_controller.author != null) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed('/member?mid=${_controller.author!.mid}'),
                      child: Row(
                        children: [
                          NetworkImgLayer(
                            width: 30,
                            height: 30,
                            src: _controller.author!.face,
                            type: ImageType.avatar,
                          ),
                          const SizedBox(width: 10),
                          Text(_controller.author!.name!),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${NumUtils.numFormat(item.articlesCount)}篇专栏',
                        ),
                        divider,
                        TextSpan(text: '${NumUtils.numFormat(item.words)}个字'),
                        divider,
                        TextSpan(text: '${NumUtils.numFormat(item.read)}次阅读'),
                      ],
                      style: style,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${DateFormatUtils.dateFormat(item.updateTime)}更新',
                        ),
                        divider,
                        TextSpan(text: '文集号: ${item.id}'),
                      ],
                      style: style,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          tooltip: '浏览器打开',
          onPressed: () => PageUtils.inAppWebview(
            '${HttpString.baseUrl}/read/mobile-readlist/rl${_controller.id}',
          ),
          icon: const Icon(Icons.open_in_browser_outlined, size: 19),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
