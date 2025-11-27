import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/data.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/pages/common/search/common_search_page.dart';
import 'package:PiliPlus/pages/fav_detail/widget/fav_video_card.dart';
import 'package:PiliPlus/pages/fav_search/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavSearchPage extends StatefulWidget {
  const FavSearchPage({super.key});

  @override
  State<FavSearchPage> createState() => _FavSearchPageState();
}

class _FavSearchPageState
    extends
        CommonSearchPageState<
          FavSearchPage,
          FavDetailData,
          FavDetailItemModel
        > {
  @override
  final FavSearchController controller = Get.put(
    FavSearchController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  List<Widget>? get extraActions => [
    Obx(
      () {
        return PopupMenuButton<FavOrderType>(
          icon: const Icon(Icons.sort),
          requestFocus: false,
          initialValue: controller.order.value,
          tooltip: '排序方式',
          onSelected: (value) => controller
            ..order.value = value
            ..onReload(),
          itemBuilder: (context) => FavOrderType.values
              .map(
                (e) => PopupMenuItem(
                  value: e,
                  child: Text(e.label),
                ),
              )
              .toList(),
        );
      },
    ),
  ];

  late final gridDelegate = Grid.videoCardHDelegate(context, minHeight: 110);

  @override
  Widget buildList(List<FavDetailItemModel> list) {
    return SliverGrid.builder(
      gridDelegate: gridDelegate,
      itemBuilder: (context, index) {
        if (index == list.length - 1) {
          controller.onLoadMore();
        }
        final item = list[index];
        return FavVideoCardH(
          item: item,
          index: index,
          ctr: controller,
        );
      },
      itemCount: list.length,
    );
  }
}
