import 'dart:io' show File;

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/image_viewer/gallery_viewer.dart';
import 'package:PiliPlus/common/widgets/image_viewer/hero_dialog_route.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryOverviewView extends StatefulWidget {
  const GalleryOverviewView({
    super.key,
    required this.sources,
    this.initIndex = 0,
    this.tag = '',
  });

  final List<SourceModel> sources;
  final int initIndex;
  final String tag;

  @override
  State<GalleryOverviewView> createState() => _GalleryOverviewViewState();
}

class _GalleryOverviewViewState extends State<GalleryOverviewView> {
  static const int _crossAxisCount = 3;
  static const double _spacing = 4;
  final _scrollController = ScrollController();
  final Set<int> _selected = <int>{};
  bool _enableMultiSelect = false;
  bool _initialJumpDone = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _syncMultiSelect(bool value) {
    if (_enableMultiSelect == value) {
      return;
    }
    setState(() {
      _enableMultiSelect = value;
      if (!value) {
        _selected.clear();
      }
    });
  }

  void _toggleSelect(int index) {
    setState(() {
      _enableMultiSelect = true;
      if (!_selected.add(index)) {
        _selected.remove(index);
      }
      if (_selected.isEmpty) {
        _enableMultiSelect = false;
      }
    });
  }

  void _selectAll() {
    final isAllSelected = _selected.length == widget.sources.length &&
        widget.sources.isNotEmpty;
    setState(() {
      if (isAllSelected) {
        _enableMultiSelect = false;
        _selected.clear();
      } else {
        _enableMultiSelect = true;
        _selected
          ..clear()
          ..addAll(List.generate(widget.sources.length, (index) => index));
      }
    });
  }

  Future<void> _downloadSelected() async {
    if (_selected.isEmpty) {
      return;
    }
    final urls = <String>[];
    final livePhotos = <SourceModel>[];
    for (final index in _selected) {
      final item = widget.sources[index];
      if (item.sourceType == SourceType.livePhoto && item.liveUrl != null) {
        livePhotos.add(item);
      } else {
        urls.add(item.url);
      }
    }
    if (urls.isNotEmpty) {
      await ImageUtils.downloadImg(urls);
    }
    for (final item in livePhotos) {
      await ImageUtils.downloadLivePhoto(
        url: item.url,
        liveUrl: item.liveUrl!,
        width: item.width ?? 1,
        height: item.height ?? 1,
      );
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _enableMultiSelect = false;
      _selected.clear();
    });
  }

  Future<void> _openViewer(int index) async {
    await Get.key.currentState!.push<void>(
      HeroDialogRoute(
        pageBuilder: (context, animation, secondaryAnimation) => GalleryViewer(
          sources: widget.sources,
          allSources: widget.sources,
          initIndex: index,
          quality: GlobalData().imgQuality,
          tag: '${widget.tag}#all',
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialJumpDone || widget.sources.isEmpty) {
      return;
    }
    _initialJumpDone = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      final mediaQuery = MediaQuery.of(context);
      final horizontalPadding = 24.0;
      final spacingWidth = _spacing * (_crossAxisCount - 1);
      final tileExtent =
          (mediaQuery.size.width - mediaQuery.padding.left - mediaQuery.padding.right -
                  horizontalPadding -
                  spacingWidth) /
              _crossAxisCount;
      final row = widget.initIndex ~/ _crossAxisCount;
      final offset = row * (tileExtent + _spacing);
      final max = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(offset.clamp(0.0, max));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = 24.0;
    final spacingWidth = _spacing * (_crossAxisCount - 1);
    final tileExtent =
        (size.width -
                padding.left -
                padding.right -
                horizontalPadding -
                spacingWidth) /
        _crossAxisCount;
    return popScope(
      canPop: !_enableMultiSelect,
      onPopInvokedWithResult: (didPop, result) {
        if (_enableMultiSelect) {
          _syncMultiSelect(false);
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            tooltip: _enableMultiSelect ? '取消选择' : '返回',
            onPressed: () {
              if (_enableMultiSelect) {
                _syncMultiSelect(false);
              } else {
                Get.back<void>();
              }
            },
            icon: Icon(_enableMultiSelect ? Icons.close_outlined : Icons.arrow_back_ios_new),
          ),
          title: Text(
            _enableMultiSelect
                ? '已选 ${_selected.length}/${widget.sources.length}'
                : '资源总览',
          ),
          actions: [
            if (_enableMultiSelect)
              IconButton(
                tooltip: _selected.length == widget.sources.length
                    ? '取消全选'
                    : '全选',
                onPressed: _selectAll,
                icon: const Icon(Icons.select_all_outlined),
              )
            else
              IconButton(
                tooltip: '多选',
                onPressed: () => _syncMultiSelect(true),
                icon: const Icon(Icons.checklist_rtl),
              ),
            if (_enableMultiSelect)
              IconButton(
                tooltip: '下载',
                onPressed: _selected.isEmpty ? null : _downloadSelected,
                icon: const Icon(Icons.download_outlined),
              ),
            const SizedBox(width: 6),
          ],
        ),
        body: GridView.builder(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + padding.bottom),
          itemCount: widget.sources.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount,
            crossAxisSpacing: _spacing,
            mainAxisSpacing: _spacing,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = widget.sources[index];
            final checked = _selected.contains(index);
            final borderRadius = Style.mdRadius;
            final tile = Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: () {
                  if (_enableMultiSelect) {
                    _toggleSelect(index);
                  } else {
                    _openViewer(index);
                  }
                },
                onLongPress: () => _toggleSelect(index),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: item.sourceType == SourceType.fileImage
                            ? Image.file(
                                File(item.url),
                                width: tileExtent,
                                height: tileExtent,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (_, __, ___) => Container(
                                  color: theme.colorScheme.onInverseSurface
                                      .withValues(alpha: 0.4),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image_outlined),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: ImageUtils.thumbnailUrl(
                                  item.url,
                                  100,
                                ),
                                width: tileExtent,
                                height: tileExtent,
                                fit: BoxFit.cover,
                                alignment: item.isLongPic
                                    ? Alignment.topCenter
                                    : Alignment.center,
                                filterQuality: FilterQuality.high,
                                placeholder: (_, __) => Container(
                                  color: theme.colorScheme.onInverseSurface
                                      .withValues(alpha: 0.4),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    Assets.loading,
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: theme.colorScheme.onInverseSurface
                                      .withValues(alpha: 0.4),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image_outlined),
                                ),
                              ),
                      ),
                    ),
                    if (item.sourceType == SourceType.livePhoto)
                      const PBadge(text: 'Live', right: 8, bottom: 8, type: PBadgeType.gray)
                    else if (item.isLongPic)
                      const PBadge(text: '长图', right: 8, bottom: 8),
                    Positioned.fill(
                      child: selectMask(theme.colorScheme, checked, borderRadius: borderRadius),
                    ),
                  ],
                ),
              ),
            );
            final heroChild = Hero(
              tag: '${item.url}${widget.tag}#all',
              child: tile,
            );
            return Semantics(
              label: '图片，第 ${index + 1} 张，共 ${widget.sources.length} 张',
              button: true,
              child: heroChild,
            );
          },
        ),
      ),
    );
  }
}
