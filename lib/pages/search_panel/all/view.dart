import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/models/search/search_esports.dart';
import 'package:PiliPlus/pages/search_panel/all/controller.dart';
import 'package:PiliPlus/pages/search_panel/all/widgets/activity.dart';
import 'package:PiliPlus/pages/search_panel/all/widgets/esports.dart';
import 'package:PiliPlus/pages/search_panel/all/widgets/user.dart';
import 'package:PiliPlus/pages/search_panel/pgc/widgets/item.dart';
import 'package:PiliPlus/pages/search_panel/video/view.dart';
import 'package:PiliPlus/pages/search_panel/view.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart'
    hide SliverGridDelegateWithMaxCrossAxisExtent;

class SearchAllPanel extends SearchVideoPanel {
  const SearchAllPanel({
    super.key,
    required super.keyword,
    required super.tag,
    required super.searchType,
  });

  @override
  State<SearchAllPanel> createState() => _SearchAllPanelState();
}

class _SearchAllPanelState
    extends
        CommonSearchPanelState<
          SearchAllPanel,
          SearchVideoData,
          SearchVideoItemModel
        >
    with GridMixin, SearchVideoPanelMixin<SearchAllPanel> {
  @override
  late final SearchAllController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      SearchAllController(
        keyword: widget.keyword,
        searchType: widget.searchType,
        tag: widget.tag,
      ),
      tag: widget.searchType.name + widget.tag,
    );
  }

  @override
  Widget buildList(List<SearchVideoItemModel> list) {
    return SliverMainAxisGroup(
      slivers: [
        if (controller.searchEsports != null) ...[
          _buildEsports(controller.searchEsports!),
          SliverToBoxAdapter(
            child: Divider(
              height: 14,
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ],
        ...?controller.searchActivity?.map((e) {
          return SliverToBoxAdapter(
            child: SearchActivityItem(item: e),
          );
        }),
        ...?controller.searchUser?.map((e) {
          return SliverToBoxAdapter(
            child: SearchAllUserItem(item: e),
          );
        }),
        if (controller.searchMedia != null) ...[
          _buildPgc(controller.searchMedia!),
          SliverToBoxAdapter(
            child: Divider(
              height: 14,
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ],
        super.buildList(list),
      ],
    );
  }

  static Widget _buildEsports(SearchEsports item) {
    return SliverToBoxAdapter(child: SearchEsportsItem(item: item));
  }

  static Widget _buildPgc(List<SearchPgcItemModel> list) {
    final Widget child;
    if (list.length == 1) {
      child = SearchPgcItem(item: list.first);
    } else {
      child = ListView.builder(
        padding: .zero,
        itemExtent: 340,
        itemCount: list.length,
        scrollDirection: .horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SearchPgcItem(item: list[index]);
        },
      );
    }
    return SliverToBoxAdapter(child: SizedBox(height: 158, child: child));
  }

  late final pgcGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    mainAxisExtent: 160,
  );
}
