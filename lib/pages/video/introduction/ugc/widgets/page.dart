import 'dart:async' show StreamSubscription;
import 'dart:math' as math;

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

const double _itemExtent = 150;

double scrollOffset(int index, double itemExtent) {
  if (index < 0) return 0;
  return math.max(0, index * itemExtent - itemExtent / 2);
}

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
  final ShowEpisodes? showEpisodes;
  final UgcIntroController ugcIntroController;

  final Set<int>? cidSet;
  final bool Function(Part part)? onDownload;

  @override
  State<PagesPanel> createState() => _PagesPanelState();
}

class _PagesPanelState extends State<PagesPanel> {
  int pageIndex = -1;
  double get _scrollOffset => scrollOffset(pageIndex, _itemExtent);
  late final VideoDetailController _videoDetailController;
  late final ScrollController _scrollController;
  StreamSubscription? _listener;

  List<Part> get pages =>
      widget.list ?? widget.ugcIntroController.videoDetail.value.pages!;

  void _updatePageIndex() {
    final cid = _videoDetailController.cid.rawValue;
    pageIndex = math.max(0, pages.indexWhere((e) => e.cid == cid));
  }

  @override
  void initState() {
    super.initState();
    _videoDetailController = Get.find<VideoDetailController>(
      tag: widget.heroTag,
    );
    double offset = 0;
    if (widget.list == null) {
      _updatePageIndex();
      offset = _scrollOffset;
      _listener = _videoDetailController.cid.listen((cid) {
        _updatePageIndex();
        if (!mounted) return;
        setState(() {});
        jumpToCurr();
      });
    }
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  void jumpToCurr() {
    if (!_scrollController.hasClients || pages.isEmpty) {
      return;
    }
    _scrollController.animateTo(
      _scrollOffset,
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

  late ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  @override
  Widget build(BuildContext context) {
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
                      episodes: pages,
                      bvid: _videoDetailController.bvid,
                      aid: _videoDetailController.aid,
                      cid: _videoDetailController.cid.rawValue,
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
            padding: .zero,
            itemExtent: _itemExtent,
            itemCount: pages.length,
            scrollDirection: .horizontal,
            controller: _scrollController,
            key: PageStorageKey(widget.bvid),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final isCurrentIndex = pageIndex == index;
              final item = pages[index];
              return Container(
                width: _itemExtent,
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
                    child: Stack(
                      clipBehavior: .none,
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const .symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer.withValues(
                                alpha: .7,
                              ),
                              borderRadius: const .only(
                                topLeft: .circular(2),
                                bottomRight: .circular(6),
                              ),
                            ),
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize: 10.5,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ),
                        Padding(
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
                      ],
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
