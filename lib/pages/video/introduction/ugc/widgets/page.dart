import 'dart:async';
import 'dart:math';

import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter/material.dart';
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
  });

  final List<Part>? list;
  final String? cover;

  final String bvid;
  final String heroTag;
  final Function? showEpisodes;
  final UgcIntroController ugcIntroController;

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
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        if (widget.showEpisodes != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('视频选集 '),
                Expanded(
                  child: Text(
                    ' 正在播放：${pages[pageIndex].pagePart}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 34,
                  child: TextButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
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
          height: 35,
          child: ListView.builder(
            key: PageStorageKey(widget.bvid),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: pages.length,
            itemExtent: 150,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int i) {
              bool isCurrentIndex = pageIndex == i;
              final item = pages[i];
              return Container(
                width: 150,
                margin: i != pages.length - 1
                    ? const EdgeInsets.only(right: 10)
                    : null,
                child: Material(
                  color: theme.colorScheme.onInverseSurface,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    onTap: () {
                      if (widget.showEpisodes == null) {
                        Get.back();
                      }
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
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          if (isCurrentIndex) ...<Widget>[
                            Image.asset(
                              'assets/images/live.png',
                              color: theme.colorScheme.primary,
                              height: 12,
                              semanticLabel: "正在播放：",
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              item.pagePart!,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                color: isCurrentIndex
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
