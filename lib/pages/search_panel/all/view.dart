import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/models/search/search_esports.dart';
import 'package:PiliPlus/pages/search_panel/all/controller.dart';
import 'package:PiliPlus/pages/search_panel/all/widgets/activity.dart';
import 'package:PiliPlus/pages/search_panel/all/widgets/crisis_card.dart';
import 'package:PiliPlus/pages/search_panel/all/widgets/esports.dart';
import 'package:PiliPlus/pages/search_panel/all/widgets/tip.dart';
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
  Widget buildHeader() {
    // 高危词卡片放在 header，保证结果为空时也能展示；
    // 读取 loadingState 以便搜索完成后重建。
    // 非高危词回落到 mixin 的排序筛选栏。
    return Obx(() {
      final loaded = controller.loadingState.value is! Loading;
      if (controller.isCrisis && loaded) {
        return const SliverToBoxAdapter(child: CrisisCard());
      }
      return super.buildHeader();
    });
  }

  @override
  Widget buildList(List<SearchVideoItemModel> list) {
    // 高危词：屏蔽搜索结果（含视频），关怀卡片由 buildHeader 渲染
    if (controller.isCrisis) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverMainAxisGroup(
      slivers: [
        ...?controller.searchTips?.map((e) {
          return SliverToBoxAdapter(child: SearchTipItem(item: e));
        }),
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
