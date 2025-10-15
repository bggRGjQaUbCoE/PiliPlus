import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/media_bangumi.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/search_panel/controller.dart';
import 'package:PiliPlus/pages/search_panel/pgc/widgets/item.dart';
import 'package:PiliPlus/pages/search_panel/view.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPgcPanel extends CommonSearchPanel {
  const SearchPgcPanel({
    super.key,
    required super.keyword,
    required super.tag,
    required super.searchType,
  });

  @override
  State<SearchPgcPanel> createState() => _SearchPgcPanelState();
}

class _SearchPgcPanelState
    extends
        CommonSearchPanelState<
          SearchPgcPanel,
          SearchPgcData,
          SearchPgcItemModel
        > {
  @override
  late final controller = Get.put(
    SearchPanelController<SearchPgcData, SearchPgcItemModel>(
      keyword: widget.keyword,
      searchType: widget.searchType,
      tag: widget.tag,
    ),
    tag: widget.searchType.name + widget.tag,
  );

  late final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    mainAxisExtent: 160,
  );

  @override
  Widget buildList(ThemeData theme, List<SearchPgcItemModel> list) {
    return SliverGrid.builder(
      gridDelegate: gridDelegate,
      itemBuilder: (BuildContext context, int index) {
        if (index == list.length - 1) {
          controller.onLoadMore();
        }
        return SearchPgcItem(item: list[index]);
      },
      itemCount: list.length,
    );
  }

  @override
  Widget get buildLoading => SliverGrid.builder(
    gridDelegate: SliverGridDelegateWithExtentAndRatio(
      mainAxisSpacing: 2,
      maxCrossAxisExtent: Grid.smallCardWidth * 2,
      childAspectRatio: StyleString.aspectRatio * 1.5,
      minHeight: MediaQuery.textScalerOf(context).scale(155),
    ),
    itemBuilder: (context, index) => const MediaPgcSkeleton(),
    itemCount: 10,
  );
}
