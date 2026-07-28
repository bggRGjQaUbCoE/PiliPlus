import 'dart:async';
import 'dart:math';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// TODO refa
class PagesPanel extends StatefulWidget {
  const PagesPanel({
    super.key,
    this.list,
    this.cover,
    required this.bvid,
    required this.heroTag,
    this.showEpisodes,
    required this.ugcIntroController,
    this.onDownload,
    this.cidSet,
  });

  final List<Part>? list;
  final String? cover;

  final String bvid;
  final String heroTag;
  final Function? showEpisodes;
  final UgcIntroController ugcIntroController;

  final Set<int>? cidSet;
  final bool Function(Part part)? onDownload;

  @override
  State<PagesPanel> createState() => _PagesPanelState();
}

class _PagesPanelState extends State<PagesPanel> {
  late int cid;
  int pageIndex = -1;
  late final VideoDetailController _videoDetailController;
  late final ScrollController _scrollController;
  StreamSubscription? _listener;

  List<Part> get pages =>
      widget.list ?? widget.ugcIntroController.videoDetail.value.pages!;

  @override
  void initState() {
    super.initState();
    _videoDetailController = Get.find<VideoDetailController>(
      tag: widget.heroTag,
    );
    double offset = 0;
    if (widget.list == null) {
      cid = widget.ugcIntroController.cid.value;
      pageIndex = pages.indexWhere((Part e) => e.cid == cid);
      offset = targetOffset;
      _listener = _videoDetailController.cid.listen((cid) {
        this.cid = cid;
        pageIndex = max(0, pages.indexWhere((e) => e.cid == cid));
        if (!mounted) return;
        setState(() {});
        jumpToCurr();
      });
    }
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  double get targetOffset {
    const double itemWidth = 150;
    return max(0, pageIndex * itemWidth - itemWidth / 2);
  }

  void jumpToCurr() {
    if (!_scrollController.hasClients || pages.isEmpty) {
      return;
    }
    final double targetOffset = this.targetOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _listener?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Column(
      children: [
        if (widget.showEpisodes != null)
          Padding(
            padding: const .only(top: 8, bottom: 2),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Text('视频选集 '),
                Expanded(
                  child: Text(
                    ' 正在播放：${pages[pageIndex].part}',
                    overflow: .ellipsis,
                    style: TextStyle(fontSize: 12, color: colorScheme.outline),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 34,
                  child: TextButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(.zero),
                    ),
                    onPressed: () => widget.showEpisodes!(
                      null,
                      null,
                      pages,
                      widget.bvid,
                      IdUtils.bv2av(widget.bvid),
                      cid,
                    ),
                    child: Text(
                      '共${pages.length}集',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            key: PageStorageKey(widget.bvid),
            controller: _scrollController,
            scrollDirection: .horizontal,
            itemCount: pages.length,
            itemExtent: 150,
            padding: .zero,
            itemBuilder: (context, index) {
              bool isCurrentIndex = pageIndex == index;
              final item = pages[index];
              return Container(
                width: 150,
                margin: index != pages.length - 1
                    ? const .only(right: 10)
                    : null,
                child: Material(
                  color: colorScheme.onInverseSurface,
                  borderRadius: const .all(.circular(6)),
                  child: InkWell(
                    borderRadius: const .all(.circular(6)),
                    onTap: () {
                      if (widget.onDownload case final onDownload?) {
                        if (onDownload(item) && mounted) {
                          setState(() {});
                        }
                        return;
                      }
                      if (widget.showEpisodes == null) {
                        Get.back();
                      }
                      if (isCurrentIndex) return;
                      widget.ugcIntroController.onChangeEpisode(
                        item
                          ..bvid ??= widget.bvid
                          ..cover ??= widget.cover,
                      );
                      if (widget.list != null &&
                          widget
                                  .ugcIntroController
                                  .videoDetail
                                  .value
                                  .ugcSeason !=
                              null) {
                        _videoDetailController.seasonCid = pages.first.cid;
                      }
                    },
                    child: Padding(
                      padding: const .symmetric(horizontal: 8),
                      child: Align(
                        alignment: .centerLeft,
                        child: Text.rich(
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: TextStyle(
                            height: 1.1,
                            fontSize: 13,
                            color: isCurrentIndex
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                          strutStyle: const .new(height: 1.1, fontSize: 13),
                          TextSpan(
                            children: [
                              if (isCurrentIndex)
                                WidgetSpan(
                                  alignment: .middle,
                                  child: Padding(
                                    padding: const .only(right: 6),
                                    child: Image.asset(
                                      Assets.livingStatic,
                                      color: colorScheme.primary,
                                      height: 12,
                                      cacheHeight: 12.cacheSize(context),
                                      semanticLabel: "正在播放：",
                                    ),
                                  ),
                                )
                              else if (widget.cidSet?.contains(item.cid) ??
                                  false)
                                WidgetSpan(
                                  alignment: .middle,
                                  child: Icon(
                                    size: 13,
                                    color: colorScheme.secondary.withValues(
                                      alpha: .8,
                                    ),
                                    FontAwesomeIcons.circleDown,
                                  ),
                                ),
                              TextSpan(text: item.part),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
