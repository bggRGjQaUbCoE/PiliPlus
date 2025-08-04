import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/common/common_search_page.dart';
import 'package:PiliPlus/pages/later/widgets/video_card_h_later.dart';
import 'package:PiliPlus/pages/later_search/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaterSearchPage extends CommonSearchPage {
  const LaterSearchPage({super.key});

  @override
  State<LaterSearchPage> createState() => _LaterSearchPageState();
}

class _LaterSearchPageState
    extends CommonSearchPageState<LaterSearchPage, LaterData, LaterItemModel> {
  @override
  final LaterSearchController controller = Get.put(
    LaterSearchController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget buildList(List<LaterItemModel> list) {
    return SliverGrid(
      gridDelegate: Grid.videoCardHDelegate(context, minHeight: 110),
      delegate: SliverChildBuilderDelegate(childCount: list.length, (
        context,
        index,
      ) {
        if (index == list.length - 1) {
          controller.onLoadMore();
        }
        final item = list[index];
        final enableMultiSelect = controller.enableMultiSelect.value;
        return VideoCardHLater(
          videoItem: item,
          onViewLater: (cid) {
            PageUtils.toVideoPage(
              bvid: item.bvid,
              cid: cid,
              cover: item.pic,
              title: item.title,
              extraArguments: {
                'oid': item.aid,
                'sourceType': SourceType.watchLater,
                'count': controller.count,
                'favTitle': '稍后再看',
                'mediaId': controller.mid,
                'desc': false,
                'isContinuePlaying': index != 0,
              },
            );
          },
          onRemove: () => controller.toViewDel(
            context,
            index,
            item.aid!,
          ),
          onTap: !enableMultiSelect ? null : () => controller.onSelect(item),
          onLongPress: enableMultiSelect
              ? null
              : () {
                  controller.enableMultiSelect.value = true;
                  controller.onSelect(item);
                },
        );
      }),
    );
  }
}
