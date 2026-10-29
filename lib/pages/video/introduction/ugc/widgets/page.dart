import 'dart:math' as math;

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

const double _itemExtent = 150;

double scrollOffset(int index, double itemExtent) {
  if (index < 0) return 0;
  return math.max(0, index * itemExtent - itemExtent / 2);
}

class PagePanel extends StatefulWidget {
  const PagePanel({
    super.key,
    this.parts,
    this.bvid,
    this.cover,

    this.cidSet,
    this.onDownload,

    this.onBack,
    this.showList = true,

    this.showEpisodes,
    required this.ugcIntroController,
  });

  final String? bvid;
  final String? cover;
  final List<Part>? parts;

  final Set<int>? cidSet;
  final bool Function(Part part)? onDownload;

  final bool showList; // ugc side panel
  final VoidCallback? onBack; // episode panel

  final ShowEpisodes? showEpisodes;
  final UgcIntroController ugcIntroController;

  @override
  State<PagePanel> createState() => _PagePanelState();
}

class _PagePanelState extends State<PagePanel> {
  String? _bvid;
  late List<Part> _parts;
  late bool _isCurr;
  int get _index => _ugcController.partIndex;
  double get _scrollOffset => scrollOffset(_index, _itemExtent);

  late ColorScheme colorScheme;
  late final ScrollController _scrollController;
  late final _ugcController = widget.ugcIntroController;
  late final _videoDetailCtr = _ugcController.videoDetailCtr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = .of(context);
  }

  @override
  void didUpdateWidget(PagePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parts != oldWidget.parts) {
      _reset();
    }
  }

  @override
  void dispose() {
    _ugcController.indexNotifier.removeListener(_listener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _reset();
    _scrollController = ScrollController(
      keepScrollOffset: false,
      initialScrollOffset: _isCurr ? _scrollOffset : 0,
    );
  }

  void _reset() {
    if (_isCurr = widget.parts == null) {
      _initIfNeeded();
      _ugcController.indexNotifier.addListener(_listener);
    } else {
      _ugcController.indexNotifier.removeListener(_listener);
      _parts = widget.parts!;
    }
  }

  (bool bvidChanged, bool dispose) _initIfNeeded() {
    assert(_isCurr);
    final videoDetail = _ugcController.videoDetail.rawValue;
    if (!videoDetail.hasParts) return const (true, true);
    final bvidChanged = _bvid != _videoDetailCtr.bvid;
    _bvid = _videoDetailCtr.bvid;
    _parts = videoDetail.pages!;
    return (bvidChanged, false);
  }

  void _listener() {
    final (bool bvidChanged, bool dispose) = _initIfNeeded();
    if (dispose) return;
    if (!mounted) return;
    setState(() {});
    if (bvidChanged) {
      _scrollController.jumpTo(_scrollOffset);
    } else {
      _scrollController.animateTo(
        _scrollOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.showList
        ? SizedBox(
            height: 45,
            child: ListView.builder(
              padding: .zero,
              itemExtent: _itemExtent,
              itemCount: _parts.length,
              scrollDirection: .horizontal,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildItem(index),
            ),
          )
        : null;

    if (widget.showEpisodes != null) {
      final header = Padding(
        padding: const .only(top: 8, bottom: 2),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            const Text('视频选集 '),
            Expanded(
              child: Text(
                ' 正在播放：${_parts[_index].part}',
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
                onPressed: () => widget.showEpisodes!(type: .part),
                child: Text(
                  '共${_parts.length}集',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      );
      if (widget.showList) {
        return Column(children: [header, child!]);
      }
      return header;
    }

    return child!;
  }

  Widget _buildItem(int index) {
    final isCurr = _isCurr && _index == index;
    final item = _parts[index];
    return Container(
      width: _itemExtent,
      margin: index != _parts.length - 1 ? const .only(right: 10) : null,
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
            widget.onBack?.call();
            if (isCurr) return;
            _ugcController.onChangeEpisode(
              item
                ..bvid ??= widget.bvid
                ..cover ??= widget.cover,
            );
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
                      color: isCurr
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                    strutStyle: const .new(height: 1.1, fontSize: 13),
                    TextSpan(
                      children: [
                        if (isCurr)
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
                        else if (widget.cidSet?.contains(item.cid) ?? false)
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
  }
}
