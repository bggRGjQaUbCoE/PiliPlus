import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/search_panel/article/controller.dart';
import 'package:PiliPlus/pages/search_panel/view.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchArticlePanel extends CommonSearchPanel {
  const SearchArticlePanel({
    super.key,
    required super.keyword,
    required super.tag,
    required super.searchType,
    super.hasHeader = true,
  });

  @override
  State<SearchArticlePanel> createState() => _SearchArticlePanelState();
}

class _SearchArticlePanelState extends CommonSearchPanelState<
    SearchArticlePanel, SearchArticleModel, SearchArticleItemModel> {
  @override
  late final SearchArticleController controller = Get.put(
    SearchArticleController(
      keyword: widget.keyword,
      searchType: widget.searchType,
      tag: widget.tag,
    ),
    tag: widget.searchType.name + widget.tag,
  );

  late TextStyle textStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
      color: Theme.of(context).colorScheme.outline,
    );
  }

  @override
  Widget buildHeader(LoadingState<List<SearchArticleItemModel>?> loadingState) {
    if (loadingState is Success) {
      return SliverPersistentHeader(
        pinned: false,
        floating: true,
        delegate: CustomSliverPersistentHeaderDelegate(
          extent: 40,
          bgColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 40,
            padding: const EdgeInsets.only(left: 25, right: 12),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    '排序: ${controller.orderFiltersList[controller.currentOrderFilterval.value]['label']}',
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Text(
                    '分区: ${controller.zoneFiltersList[controller.currentZoneFilterval.value]['label']}',
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    tooltip: '筛选',
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      controller.onShowFilterDialog(context);
                    },
                    icon: Icon(
                      Icons.filter_list_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const SliverToBoxAdapter();
  }

  late final TextStyle style = TextStyle(fontSize: 13);

  @override
  Widget buildList(List<SearchArticleItemModel> list) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 80),
      sliver: SliverGrid(
        gridDelegate: Grid.videoCardHDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == list.length - 1) {
              controller.onLoadMore();
            }
            final item = list[index];
            return InkWell(
              onTap: () {
                Get.toNamed(
                  '/articlePage',
                  parameters: {
                    'id': '${item.id}',
                    'type': 'read',
                  },
                );
              },
              onLongPress: () => imageSaveDialog(
                context: context,
                title: item.title?.map((item) => item['text']).join() ?? '',
                cover: item.imageUrls?.firstOrNull,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StyleString.safeSpace,
                  vertical: 5,
                ),
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    final double width = (boxConstraints.maxWidth -
                            StyleString.cardSpace *
                                6 /
                                MediaQuery.textScalerOf(context).scale(1.0)) /
                        2;
                    return Container(
                      constraints: const BoxConstraints(minHeight: 88),
                      height: width / StyleString.aspectRatio,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (item.imageUrls?.isNotEmpty == true)
                            AspectRatio(
                              aspectRatio: StyleString.aspectRatio,
                              child: LayoutBuilder(
                                  builder: (context, boxConstraints) {
                                double maxWidth = boxConstraints.maxWidth;
                                double maxHeight = boxConstraints.maxHeight;
                                return NetworkImgLayer(
                                  width: maxWidth,
                                  height: maxHeight,
                                  src: item.imageUrls?.firstOrNull,
                                );
                              }),
                            ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  maxLines: 2,
                                  TextSpan(
                                    children: [
                                      for (var i in item.title!) ...[
                                        TextSpan(
                                          text: i['text'],
                                          style: TextStyle(
                                            color: i['type'] == 'em'
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  Utils.dateFormat(item.pubTime,
                                      formatType: 'detail'),
                                  style: textStyle,
                                ),
                                Row(
                                  children: [
                                    Text('${item.view}浏览', style: textStyle),
                                    Text(' • ', style: textStyle),
                                    Text('${item.reply}评论', style: textStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }
}
