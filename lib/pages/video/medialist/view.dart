import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/media_list/media_list.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:flutter/material.dart' hide RefreshCallback;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MediaListPanel extends CommonSlidePage {
  const MediaListPanel({
    super.key,
    required this.mediaList,
    required this.onChangeEpisode,
    this.panelTitle,
    required this.bvid,
    required this.loadMoreMedia,
    required this.count,
    required this.desc,
    required this.onReverse,
    required this.loadPrevious,
    this.onDelete,
  });

  final RxList<MediaListItemModel> mediaList;
  final ValueChanged<BaseEpisodeItem> onChangeEpisode;
  final String? panelTitle;
  final String bvid;
  final VoidCallback loadMoreMedia;
  final int? count;
  final bool desc;
  final VoidCallback onReverse;
  final RefreshCallback? loadPrevious;
  final void Function(MediaListItemModel item, int index)? onDelete;

  @override
  State<MediaListPanel> createState() => _MediaListPanelState();
}

class _MediaListPanelState extends State<MediaListPanel>
    with SingleTickerProviderStateMixin, CommonSlideMixin {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    final bvid = widget.bvid;
    final bvIndex = widget.mediaList.indexWhere((item) => item.bvid == bvid);
    _controller = ScrollController(
      initialScrollOffset: bvIndex == -1 ? 0 : bvIndex * 100.0 + 7,
    );
  }

  @override
  Widget buildPage(ThemeData theme) {
    return Material(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          AppBar(
            primary: false,
            toolbarHeight: 45,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Text(widget.panelTitle ?? '稍后再看'),
            backgroundColor: Colors.transparent,
            actions: [
              mediumButton(
                tooltip: widget.desc ? '顺序播放' : '倒序播放',
                icon: widget.desc
                    ? MdiIcons.sortAscending
                    : MdiIcons.sortDescending,
                onPressed: () {
                  Get.back();
                  widget.onReverse();
                },
              ),
              mediumButton(
                tooltip: '关闭',
                icon: Icons.close,
                onPressed: Get.back,
              ),
              const SizedBox(width: 14),
            ],
            shape: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          Expanded(
            child: enableSlide ? slideList(theme) : buildList(theme),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildList(ThemeData theme) {
    return widget.loadPrevious != null
        ? refreshIndicator(
            onRefresh: widget.loadPrevious!,
            child: _buildList(theme),
          )
        : _buildList(theme);
  }

  Widget _buildList(ThemeData theme) {
    final showDelBtn = widget.onDelete != null && widget.mediaList.length > 1;
    return CustomScrollView(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: 7,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
          ),
          sliver: Obx(
            () => SliverFixedExtentList.builder(
              itemExtent: 100,
              itemCount: widget.mediaList.length,
              itemBuilder: (context, index) {
                if (index == widget.mediaList.length - 1 &&
                    (widget.count == null ||
                        widget.mediaList.length < widget.count!)) {
                  widget.loadMoreMedia();
                }
                var item = widget.mediaList[index];
                final isCurr = item.bvid == widget.bvid;
                return _buildItem(theme, index, item, isCurr, showDelBtn);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(
    ThemeData theme,
    int index,
    MediaListItemModel item,
    bool isCurr,
    bool showDelBtn,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: SizedBox(
        height: 98,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              if (item.type != 2) {
                SmartDialog.showToast('不支持播放该类型视频');
                return;
              }
              Get.back();
              widget.onChangeEpisode(item);
            },
            onLongPress: () => imageSaveDialog(
              title: item.title,
              cover: item.cover,
              aid: item.aid,
              bvid: item.bvid,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          NetworkImgLayer(
                            src: item.cover,
                            width: 140.8,
                            height: 88,
                          ),
                          if (item.badge?.isNotEmpty == true)
                            PBadge(
                              text: item.badge,
                              right: 6.0,
                              top: 6.0,
                              type: switch (item.badge) {
                                '充电专属' => PBadgeType.error,
                                _ => PBadgeType.primary,
                              },
                            ),
                          PBadge(
                            text: DurationUtils.formatDuration(
                              item.duration,
                            ),
                            right: 6.0,
                            bottom: 6.0,
                            type: PBadgeType.gray,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: isCurr ? FontWeight.bold : null,
                                color: isCurr
                                    ? theme.colorScheme.primary
                                    : null,
                              ),
                            ),
                            if (item.type == 24 &&
                                item.intro?.isNotEmpty == true) ...[
                              const SizedBox(height: 3),
                              Text(
                                item.intro!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                            const Spacer(),
                            Text(
                              item.upper!.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            if (item.type == 2) ...[
                              const SizedBox(height: 3),
                              Row(
                                spacing: 8,
                                children: [
                                  StatWidget(
                                    type: StatType.play,
                                    value: item.cntInfo!.play,
                                  ),
                                  StatWidget(
                                    type: StatType.danmaku,
                                    value: item.cntInfo!.danmaku,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showDelBtn && !isCurr)
                  Positioned(
                    right: 12,
                    bottom: -6,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => showConfirmDialog(
                        context: context,
                        title: '确定移除该视频？',
                        onConfirm: () => widget.onDelete!(item, index),
                      ),
                      onLongPress: () => widget.onDelete!(item, index),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
