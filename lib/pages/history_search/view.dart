import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/models_new/history/data.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/pages/common/common_search_page.dart';
import 'package:PiliPlus/pages/history/widgets/item.dart';
import 'package:PiliPlus/pages/history_search/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistorySearchPage extends CommonSearchPage {
  const HistorySearchPage({super.key});

  @override
  State<HistorySearchPage> createState() => _HistorySearchPageState();
}

class _HistorySearchPageState
    extends
        CommonSearchPageState<
          HistorySearchPage,
          HistoryData,
          HistoryItemModel
        > {
  @override
  final HistorySearchController controller = Get.put(
    HistorySearchController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: refa
    return Obx(() {
      final parent = super.build(context) as Scaffold;
      final enableMultiSelect = controller.enableMultiSelect.value;
      return PopScope(
        canPop: !enableMultiSelect,
        onPopInvokedWithResult: (didPop, result) {
          if (enableMultiSelect) {
            controller.handleSelect();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: parent.resizeToAvoidBottomInset,
          appBar: MultiSelectAppBarWidget(
            ctr: controller,
            child: parent.appBar as AppBar,
          ),
          body: parent.body,
        ),
      );
    });
  }

  @override
  Widget buildList(List<HistoryItemModel> list) {
    return SliverGrid(
      gridDelegate: Grid.videoCardHDelegate(context, minHeight: 110),
      delegate: SliverChildBuilderDelegate(
        childCount: list.length,
        (context, index) {
          if (index == list.length - 1) {
            controller.onLoadMore();
          }
          final item = list[index];
          return HistoryItem(
            item: item,
            ctr: controller,
            onDelete: (kid, business) =>
                controller.onDelHistory(index, kid, business),
          );
        },
      ),
    );
  }
}
