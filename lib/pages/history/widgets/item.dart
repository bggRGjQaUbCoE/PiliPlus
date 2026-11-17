import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/pages/article/view.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

class HistoryItem extends StatefulWidget {
  final HistoryItemModel item;
  final MultiSelectBase ctr;
  final void Function(int kid, String business) onDelete;

  const HistoryItem({
    super.key,
    required this.item,
    required this.ctr,
    required this.onDelete,
  });

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  HistoryItemModel get item => widget.item;
  MultiSelectBase get ctr => widget.ctr;
  void Function(int, String) get onDelete => widget.onDelete;
  Object _coverTag = Object();
  ImageProvider? _coverImage;
  Dimension? _dimension;
  bool _opening = false;
  bool get _candidate =>
      Pref.coverPageTransition && item.history.business == 'archive';

  @override
  void didUpdateWidget(HistoryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != item) {
      _coverTag = Object();
      _coverImage = null;
      _dimension = null;
    }
  }

  Future<void> _open() async {
    if (!_candidate ||
        _coverImage == null ||
        MediaQuery.disableAnimationsOf(context) ||
        PlPlayerController.instance?.videoController != null) {
      return onPushHistory(item);
    }
    if (_opening) return;
    _opening = true;
    final current = item;
    try {
      await onPushHistory(
        current,
        resolveDimension: true,
        knownDimension: _dimension,
        openVideo: (cid, dimension) async {
          if (!mounted ||
              !identical(current, item) ||
              ctr.enableMultiSelect.value ||
              !ModalRoute.of(context)!.isCurrent) {
            return;
          }
          _dimension = dimension;
          final w = dimension?.width, h = dimension?.height;
          final portraitAspectRatio = CoverTransitionData.portraitAspectRatio(
            w,
            h,
          );
          final motion =
              _candidate &&
                  w != null &&
                  h != null &&
                  w > 0 &&
                  h > 0 &&
                  (w > h || portraitAspectRatio != null) &&
                  !MediaQuery.disableAnimationsOf(context) &&
                  PlPlayerController.instance?.videoController == null
              ? CoverTransitionData(
                  tag: _coverTag,
                  image: _coverImage!,
                  radius: Style.mdRadius,
                  contentAspectRatio: portraitAspectRatio,
                )
              : null;
          await PageUtils.toVideoPage(
            aid: current.history.oid,
            bvid: current.history.bvid,
            cid: cid,
            cover: current.cover,
            title: current.title,
            dimension: dimension,
            progress: current.playbackProgress,
            coverTransition: motion,
          );
        },
      );
    } finally {
      _opening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDuration = item.hasDuration;
    final business = item.history.business;
    final enableMultiSelect = ctr.enableMultiSelect.value;

    final onLongPress = enableMultiSelect
        ? null
        : () => ctr
            ..enableMultiSelect.value = true
            ..onSelect(item);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: enableMultiSelect ? () => ctr.onSelect(item) : _open,
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Style.safeSpace,
                vertical: 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: Style.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        double maxWidth = boxConstraints.maxWidth;
                        double maxHeight = boxConstraints.maxHeight;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            HeroMode(
                              enabled:
                                  _candidate &&
                                  !enableMultiSelect &&
                                  !MediaQuery.disableAnimationsOf(context),
                              child: Hero(
                                tag: _coverTag,
                                curve: CoverTransitionData.motionCurve,
                                reverseCurve: CoverTransitionData.motionCurve,
                                flightShuttleBuilder:
                                    CoverTransitionData.flight,
                                child: NetworkImgLayer(
                                  src: item.cover?.isNotEmpty == true
                                      ? item.cover
                                      : item.covers?.firstOrNull ?? '',
                                  width: maxWidth,
                                  height: maxHeight,
                                  onImageReady: _candidate
                                      ? (image) => _coverImage = image
                                      : null,
                                ),
                              ),
                            ),
                            ?item.label,
                            if (hasDuration)
                              ...item.progressIndicator(theme.colorScheme),
                            Positioned.fill(
                              child: selectMask(
                                theme.colorScheme,
                                item.checked,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  content(theme),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 0,
              width: 29,
              height: 29,
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                tooltip: '功能菜单',
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: theme.colorScheme.outline,
                  size: 18,
                ),
                position: PopupMenuPosition.under,
                itemBuilder: (_) => [
                  if (item.authorMid != null &&
                      item.authorName?.isNotEmpty == true)
                    PopupMenuItem(
                      onTap: () => Get.toNamed('/member?mid=${item.authorMid}'),
                      height: 38,
                      child: Row(
                        children: [
                          const Icon(
                            MdiIcons.accountCircleOutline,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '访问：${item.authorName}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  if (business != 'pgc' &&
                      item.badge != '番剧' &&
                      item.tagName?.contains('动画') != true &&
                      business != 'live' &&
                      business?.contains('article') != true)
                    PopupMenuItem(
                      onTap: () =>
                          UserHttp.toViewLater(bvid: item.history.bvid),
                      height: 38,
                      child: const Row(
                        children: [
                          Icon(Icons.watch_later_outlined, size: 16),
                          SizedBox(width: 6),
                          Text('稍后再看', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    onTap: () => onDelete(item.kid!, business!),
                    height: 38,
                    child: const Row(
                      children: [
                        Icon(Icons.close_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('删除记录', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(ThemeData theme) {
    return Expanded(
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title!,
            style: TextStyle(
              fontSize: theme.textTheme.bodyMedium!.fontSize,
              height: 1.42,
              letterSpacing: 0.3,
            ),
            maxLines: item.videos! > 1 ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.history.business == 'pgc' &&
              item.showTitle?.isNotEmpty == true)
            Text(
              item.showTitle!,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.outline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const Spacer(),
          if (item.authorName?.isNotEmpty == true)
            Text(
              item.authorName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: theme.textTheme.labelMedium!.fontSize,
                color: theme.colorScheme.outline,
              ),
            ),
          Text(
            DateFormatUtils.chatFormat(item.viewAt!, isHistory: true),
            style: TextStyle(
              fontSize: theme.textTheme.labelMedium!.fontSize,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> onPushHistory(
  HistoryItemModel item, {
  bool resolveDimension = false,
  Dimension? knownDimension,
  Future<void> Function(int cid, Dimension? dimension)? openVideo,
}) async {
  final business = item.history.business;
  if (business?.contains('article') == true) {
    ArticlePage.toArticlePage(
      id: (business == 'article-list' ? item.history.cid : item.history.oid)
          .toString(),
      type: .read,
    );
  } else if (business == 'live') {
    if (item.liveStatus == 1) {
      PageUtils.toLiveRoom(item.history.oid);
    } else {
      SmartDialog.showToast('直播未开播');
    }
  } else if (business == 'pgc') {
    PageUtils.viewPgc(
      epId: item.history.epid,
      progress: item.playbackProgress,
    );
  } else if (business == 'cheese') {
    if (item.uri?.isNotEmpty == true) {
      PageUtils.viewPgcFromUri(
        item.uri!,
        isPgc: false,
        aid: item.history.oid,
        progress: item.playbackProgress,
      );
    }
  } else {
    final aid = item.history.oid!;
    final bvid = item.history.bvid ?? IdUtils.av2bv(aid);
    int? cid = item.history.cid;
    Dimension? dimension = knownDimension;
    if (cid == null || (resolveDimension && dimension == null)) {
      if (await SearchHttp.ab2cWithDimension(
            aid: aid,
            bvid: bvid,
            part: item.history.page,
          )
          case final res?) {
        cid ??= res.cid;
        if (cid == res.cid) dimension = res.dimension;
      }
    }
    if (cid != null) {
      if (openVideo != null) return openVideo(cid, dimension);
      PageUtils.toVideoPage(
        aid: aid,
        bvid: bvid,
        cid: cid,
        cover: item.cover,
        title: item.title,
        dimension: dimension,
        progress: item.playbackProgress,
      );
    }
  }
}
