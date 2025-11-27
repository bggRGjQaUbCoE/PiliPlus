import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/search_panel/user/controller.dart';
import 'package:PiliPlus/pages/search_panel/user/widgets/item.dart';
import 'package:PiliPlus/pages/search_panel/view.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart'
    hide SliverGridDelegateWithMaxCrossAxisExtent;
import 'package:get/get.dart';

class SearchUserPanel extends CommonSearchPanel {
  const SearchUserPanel({
    super.key,
    required super.keyword,
    required super.tag,
    required super.searchType,
  });

  @override
  State<SearchUserPanel> createState() => _SearchUserPanelState();
}

class _SearchUserPanelState
    extends
        CommonSearchPanelState<
          SearchUserPanel,
          SearchUserData,
          SearchUserItemModel
        > {
  @override
  late final SearchUserController controller = Get.put(
    SearchUserController(
      keyword: widget.keyword,
      searchType: widget.searchType,
      tag: widget.tag,
    ),
    tag: widget.searchType.name + widget.tag,
  );

  @override
  Widget buildHeader(ThemeData theme) {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        extent: 40,
        bgColor: theme.colorScheme.surface,
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 25, right: 12),
          child: Row(
            children: [
              Obx(
                () => Text(
                  '排序: ${controller.userOrderType!.value.label}',
                  maxLines: 1,
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ),
              const Spacer(),
              Obx(
                () => Text(
                  '用户类型: ${controller.userType!.value.label}',
                  maxLines: 1,
                  style: TextStyle(color: theme.colorScheme.outline),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  tooltip: '筛选',
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  ),
                  onPressed: () => controller.onShowFilterDialog(context),
                  icon: Icon(
                    Icons.filter_list_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late final gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    mainAxisExtent: 66,
  );

  @override
  Widget buildList(ThemeData theme, List<SearchUserItemModel> list) {
    return SliverGrid.builder(
      gridDelegate: gridDelegate,
      itemBuilder: (BuildContext context, int index) {
        if (index == list.length - 1) {
          controller.onLoadMore();
        }
        return SearchUserItem(
          item: list[index],
        );
      },
      itemCount: list.length,
    );
  }

  @override
  Widget get buildLoading => SliverGrid.builder(
    gridDelegate: gridDelegate,
    itemBuilder: (context, index) => const MsgFeedTopSkeleton(),
    itemCount: 10,
  );
}
