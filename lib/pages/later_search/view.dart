import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: refa
  //   return Obx(() {
  //     final parent = super.build(context) as Scaffold;
  //     final enableMultiSelect = controller.enableMultiSelect.value;
  //     return PopScope(
  //       canPop: !enableMultiSelect,
  //       onPopInvokedWithResult: (didPop, result) {
  //         if (enableMultiSelect) {
  //           controller.handleSelect();
  //         }
  //       },
  //       child: Scaffold(
  //         resizeToAvoidBottomInset: parent.resizeToAvoidBottomInset,
  //         appBar: MultiSelectAppBarWidget(
  //           ctr: controller,
  //           child: parent.appBar as AppBar,
  //         ),
  //         body: parent.body,
  //       ),
  //     );
  //   });
  // }

  @override
  Widget buildList(List<LaterItemModel> list) {
    return SliverGrid(
      gridDelegate: Grid.videoCardHDelegate(context, minHeight: 110),
      delegate: SliverChildBuilderDelegate(
        childCount: list.length,
        (context, index) {
          if (index == list.length - 1) {
            controller.onLoadMore();
          }
          final item = list[index];
          return Stack(
            clipBehavior: Clip.none,
            children: [
              VideoCardHLater(
                videoItem: item,
                onViewLater: (cid) {
                  PageUtils.toVideoPage(
                    'bvid=${item.bvid}&cid=$cid',
                    arguments: {
                      'videoItem': item,
                      'oid': item.aid,
                      'heroTag': Utils.makeHeroTag(item.bvid),
                      'sourceType': SourceType.watchLater,
                      'count': controller.count,
                      'favTitle': '稍后再看',
                      'mediaId': controller.mid,
                      'desc': false,
                      'isContinuePlaying': index != 0,
                    },
                  );
                },
              ),
              Positioned(
                right: 12,
                bottom: 0,
                child: iconButton(
                  tooltip: '移除',
                  context: context,
                  onPressed: () => showConfirmDialog(
                    context: context,
                    title: '提示',
                    content: '即将移除该视频，确定是否移除',
                    onConfirm: () => controller.toViewDel(
                      context,
                      index,
                      item.aid!,
                    ),
                  ),
                  icon: Icons.clear,
                  iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  bgColor: Colors.transparent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
