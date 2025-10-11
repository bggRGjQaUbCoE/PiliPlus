import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_v.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_list.dart';
import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/pages/live/controller.dart';
import 'package:PiliPlus/pages/live/widgets/live_item_app.dart';
import 'package:PiliPlus/pages/live_area/view.dart';
import 'package:PiliPlus/pages/live_follow/view.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends CommonPageState<LivePage, LiveController>
    with AutomaticKeepAliveClientMixin {
  @override
  LiveController controller = Get.put(LiveController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ThemeData theme = Theme.of(context);
    return onBuild(
      Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
        decoration: const BoxDecoration(borderRadius: StyleString.mdRadius),
        child: refreshIndicator(
          onRefresh: controller.onRefresh,
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: StyleString.cardSpace,
                  bottom: 100,
                ),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    Obx(() => _buildTop(theme, controller.topState.value)),
                    Obx(() => _buildBody(theme, controller.loadingState.value)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop(ThemeData theme, Pair<LiveCardList?, LiveCardList?> data) {
    return SliverMainAxisGroup(
      slivers: [
        if (data.first != null)
          SliverToBoxAdapter(child: _buildFollowList(theme, data.first!)),
        if (data.second?.cardData?.areaEntranceV3?.list?.isNotEmpty == true)
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: SelfSizedHorizontalList(
                    gapSize: 12,
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 12,
                    ),
                    childBuilder: (index) {
                      late final item = data
                          .second!
                          .cardData!
                          .areaEntranceV3!
                          .list![index - 1];
                      return Obx(
                        () {
                          final isCurr = index == controller.areaIndex.value;
                          return SearchText(
                            fontSize: 14,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            text: index == 0 ? '推荐' : '${item.title}',
                            bgColor: isCurr
                                ? theme.colorScheme.secondaryContainer
                                : Colors.transparent,
                            textColor: isCurr
                                ? theme.colorScheme.onSecondaryContainer
                                : null,
                            onTap: (value) {
                              controller.onSelectArea(
                                index,
                                index == 0 ? null : item,
                              );
                            },
                          );
                        },
                      );
                    },
                    itemCount:
                        data.second!.cardData!.areaEntranceV3!.list!.length + 1,
                  ),
                ),
                iconButton(
                  size: 26,
                  iconSize: 16,
                  context: context,
                  tooltip: '全部标签',
                  icon: Icons.widgets,
                  onPressed: () => Get.to(const LiveAreaPage()),
                ),
              ],
            ),
          )
        else
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
      ],
    );
  }

  late final gridDelegate = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: StyleString.cardSpace,
    crossAxisSpacing: StyleString.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth,
    childAspectRatio: StyleString.aspectRatio,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(90),
  );

  Widget _buildBody(ThemeData theme, LoadingState<List?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid.builder(
        gridDelegate: gridDelegate,
        itemBuilder: (context, index) => const VideoCardVSkeleton(),
        itemCount: 10,
      ),
      Success(:var response) => SliverMainAxisGroup(
        slivers: [
          if (controller.newTags?.isNotEmpty == true)
            SliverToBoxAdapter(
              child: SelfSizedHorizontalList(
                gapSize: 12,
                padding: const EdgeInsets.only(bottom: 8),
                childBuilder: (index) {
                  late final item = controller.newTags![index];
                  return Obx(
                    () {
                      final isCurr = index == controller.tagIndex.value;
                      return SearchText(
                        fontSize: 13,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        text: '${item.name}',
                        bgColor: isCurr
                            ? theme.colorScheme.secondaryContainer
                            : Colors.transparent,
                        textColor: isCurr
                            ? theme.colorScheme.onSecondaryContainer
                            : null,
                        onTap: (value) {
                          controller.onSelectTag(
                            index,
                            item.sortType,
                          );
                        },
                      );
                    },
                  );
                },
                itemCount: controller.newTags!.length,
              ),
            ),
          response?.isNotEmpty == true
              ? SliverGrid.builder(
                  gridDelegate: gridDelegate,
                  itemBuilder: (context, index) {
                    if (index == response.length - 1) {
                      controller.onLoadMore();
                    }
                    final item = response[index];
                    if (item is LiveCardList) {
                      return LiveCardVApp(
                        item: item.cardData!.smallCardV1!,
                      );
                    }
                    return LiveCardVApp(item: item);
                  },
                  itemCount: response!.length,
                )
              : HttpError(onReload: controller.onReload),
        ],
      ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: controller.onReload,
      ),
    };
  }

  Widget _buildFollowList(ThemeData theme, LiveCardList item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '我的关注  '),
                  TextSpan(
                    text:
                        '${item.cardData?.myIdolV1?.extraInfo?.totalCount ?? 0}',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: '人正在直播',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.to(const LiveFollowPage()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '查看更多',
                    style: TextStyle(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Icon(
                    size: 20,
                    Icons.keyboard_arrow_right_outlined,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (item.cardData?.myIdolV1?.list?.isNotEmpty == true)
          _buildFollowBody(theme, item.cardData!.myIdolV1!.list!),
      ],
    );
  }

  Widget _buildFollowBody(ThemeData theme, List<CardLiveItem> followList) {
    return SelfSizedHorizontalList(
      gapSize: 5,
      padding: EdgeInsets.zero,
      childBuilder: (index) {
        final item = followList[index];
        return SizedBox(
          width: 65,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => PageUtils.toLiveRoom(item.roomid),
            onLongPress: () {
              Feedback.forLongPress(context);
              Get.toNamed('/member?mid=${item.uid}');
            },
            onSecondaryTap: Utils.isMobile
                ? null
                : () => Get.toNamed('/member?mid=${item.uid}'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: theme.colorScheme.primary,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: NetworkImgLayer(
                    type: ImageType.avatar,
                    width: 45,
                    height: 45,
                    src: item.face,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.uname!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
      itemCount: followList.length,
    );
  }
}
