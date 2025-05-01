import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/video_card_h.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/common/common_search_page.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LaterSearchPage extends CommonSearchPage {
  const LaterSearchPage({super.key});

  @override
  State<LaterSearchPage> createState() => _LaterSearchPageState();
}

class _LaterSearchPageState
    extends CommonSearchPageState<LaterSearchPage, Map, HotVideoItemModel> {
  @override
  final LaterSearchController controller = Get.put(
    LaterSearchController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget buildList(List<HotVideoItemModel> list) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 80,
      ),
      sliver: SliverGrid(
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
                VideoCardH(
                  videoItem: item,
                  source: 'later',
                  onViewLater: (cid) {
                    PageUtils.toVideoPage(
                      'bvid=${item.bvid}&cid=$cid',
                      arguments: {
                        'videoItem': item,
                        'oid': item.aid,
                        'heroTag': Utils.makeHeroTag(item.bvid),
                        'sourceType': 'watchLater',
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
                    onPressed: () {
                      controller.toViewDel(
                        context,
                        index,
                        item.aid,
                      );
                    },
                    icon: Icons.clear,
                    iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    bgColor: Colors.transparent,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
