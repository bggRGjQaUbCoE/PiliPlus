import 'dart:io';

import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactive_viewer_boundary.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// https://github.com/qq326646683/interactiveviewer_gallery

/// Builds a carousel controlled by a [PageView] for the tweet media sources.
///
/// Used for showing a full screen view of the [TweetMedia] sources.
///
/// The sources can be panned and zoomed interactively using an
/// [InteractiveViewer].
/// An [InteractiveViewerBoundary] is used to detect when the boundary of the
/// source is hit after zooming in to disable or enable the swiping gesture of
/// the [PageView].
///
typedef IndexedFocusedWidgetBuilder =
    Widget Function(
      BuildContext context,
      int index,
      bool isFocus,
      bool enablePageView,
    );

typedef IndexedTagStringBuilder = String Function(int index);

class InteractiveviewerGallery extends StatefulWidget {
  const InteractiveviewerGallery({
    super.key,
    required this.sources,
    required this.initIndex,
    this.itemBuilder,
    this.maxScale = 8,
    this.minScale = 1.0,
    this.onPageChanged,
    this.onDismissed,
    this.onClose,
    required this.quality,
  });

  final int quality;

  final ValueChanged<bool>? onClose;

  /// The sources to show.
  final List<SourceModel> sources;

  /// The index of the first source in [sources] to show.
  final int initIndex;

  /// The item content
  final IndexedFocusedWidgetBuilder? itemBuilder;

  final double maxScale;

  final double minScale;

  final ValueChanged<int>? onPageChanged;

  final ValueChanged<int>? onDismissed;

  @override
  State<InteractiveviewerGallery> createState() =>
      _InteractiveviewerGalleryState();
}

class _InteractiveviewerGalleryState extends State<InteractiveviewerGallery>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  TransformationController? _transformationController;

  /// The controller to animate the transformation value of the
  /// [InteractiveViewer] when it should reset.
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  /// `true` when an source is zoomed in and not at the at a horizontal boundary
  /// to disable the [PageView].
  bool _enablePageView = true;

  late Offset _doubleTapLocalPosition;

  late final RxInt currentIndex = widget.initIndex.obs;

  late final int _quality = Pref.previewQ;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.initIndex);

    _transformationController = TransformationController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(listener);

    var item = widget.sources[currentIndex.value];
    if (item.sourceType == SourceType.livePhoto) {
      _onPlay(item.liveUrl!);
    }
  }

  void listener() {
    _transformationController!.value = _animation?.value ?? Matrix4.identity();
  }

  @override
  void dispose() {
    widget.onClose?.call(true);
    _player?.dispose();
    _pageController?.dispose();
    _animationController
      ..removeListener(listener)
      ..dispose();
    for (var item in widget.sources) {
      if (item.sourceType == SourceType.networkImage) {
        CachedNetworkImageProvider(_getActualUrl(item.url)).evict();
      }
    }
    super.dispose();
  }

  /// When the source gets scaled up, the swipe up / down to dismiss gets
  /// disabled.
  ///
  /// When the scale resets, the dismiss and the page view swiping gets enabled.
  void _onScaleChanged(double scale) {
    final bool initialScale = scale <= widget.minScale;

    if (initialScale) {
      if (!_enablePageView) {
        setState(() {
          _enablePageView = true;
        });
      }
    } else {
      if (_enablePageView) {
        setState(() {
          _enablePageView = false;
        });
      }
    }
  }

  /// When the left boundary has been hit after scaling up the source, the page
  /// view swiping gets enabled if it has a page to swipe to.
  void _onLeftBoundaryHit() {
    if (!_enablePageView && _pageController!.page!.floor() > 0) {
      setState(() {
        _enablePageView = true;
      });
    }
  }

  /// When the right boundary has been hit after scaling up the source, the page
  /// view swiping gets enabled if it has a page to swipe to.
  void _onRightBoundaryHit() {
    if (!_enablePageView &&
        _pageController!.page!.floor() < widget.sources.length - 1) {
      setState(() {
        _enablePageView = true;
      });
    }
  }

  /// When the source has been scaled up and no horizontal boundary has been hit,
  /// the page view swiping gets disabled.
  void _onNoBoundaryHit() {
    if (_enablePageView) {
      setState(() {
        _enablePageView = false;
      });
    }
  }

  void _onPlay(String liveUrl) {
    _player ??= Player();
    _videoController ??= VideoController(_player!);
    _player!.open(Media(liveUrl));
  }

  /// When the page view changed its page, the source will animate back into the
  /// original scale if it was scaled up.
  ///
  /// Additionally the swipe up / down to dismiss gets enabled.
  void _onPageChanged(int page) {
    _player?.pause();
    currentIndex.value = page;
    var item = widget.sources[page];
    if (item.sourceType == SourceType.livePhoto) {
      _onPlay(item.liveUrl!);
    }
    widget.onPageChanged?.call(page);
    if (_transformationController!.value != Matrix4.identity()) {
      // animate the reset for the transformation of the interactive viewer

      _animation =
          Matrix4Tween(
            begin: _transformationController!.value,
            end: Matrix4.identity(),
          ).animate(
            CurveTween(curve: Curves.easeOut).animate(_animationController),
          );

      _animationController.forward(from: 0);
    }
  }

  String _getActualUrl(String url) {
    return _quality != 100
        ? ImageUtils.thumbnailUrl(url, _quality)
        : url.http2https;
  }

  void onClose() {
    if (widget.onClose != null) {
      widget.onClose!(false);
    } else {
      Get.back();
      widget.onDismissed?.call(_pageController!.page!.floor());
    }
  }

  Player? _player;
  VideoController? _videoController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InteractiveViewerBoundary(
          controller: _transformationController,
          boundaryWidth: MediaQuery.widthOf(context),
          onScaleChanged: _onScaleChanged,
          onLeftBoundaryHit: _onLeftBoundaryHit,
          onRightBoundaryHit: _onRightBoundaryHit,
          onNoBoundaryHit: _onNoBoundaryHit,
          maxScale: widget.maxScale,
          minScale: widget.minScale,
          onDismissed: onClose,
          onReset: () {
            if (!_enablePageView) {
              setState(() {
                _enablePageView = true;
              });
            }
          },
          child: PageView.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            physics: _enablePageView
                ? null
                : const NeverScrollableScrollPhysics(),
            itemCount: widget.sources.length,
            itemBuilder: (BuildContext context, int index) {
              final item = widget.sources[index];
              final isFileImg = item.sourceType == SourceType.fileImage;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => EasyThrottle.throttle(
                  'preview',
                  const Duration(milliseconds: 555),
                  onClose,
                ),
                onDoubleTapDown: (TapDownDetails details) {
                  _doubleTapLocalPosition = details.localPosition;
                },
                onDoubleTap: () => EasyThrottle.throttle(
                  'preview',
                  const Duration(milliseconds: 555),
                  onDoubleTap,
                ),
                onLongPress: !isFileImg ? () => onLongPress(item) : null,
                onSecondaryTap: !isFileImg && !Utils.isMobile
                    ? () => onLongPress(item)
                    : null,
                child: widget.itemBuilder != null
                    ? widget.itemBuilder!(
                        context,
                        index,
                        index == currentIndex.value,
                        _enablePageView,
                      )
                    : _itemBuilder(index, item),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding:
                MediaQuery.viewPaddingOf(context) +
                const EdgeInsets.fromLTRB(12, 8, 20, 8),
            decoration: _enablePageView
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  )
                : null,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: onClose,
                  ),
                ),
                if (widget.sources.length > 1)
                  Align(
                    alignment: Alignment.center,
                    child: Obx(
                      () => Text(
                        "${currentIndex.value + 1}/${widget.sources.length}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (widget.sources[currentIndex.value].sourceType !=
                    SourceType.fileImage)
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton(
                      itemBuilder: (context) {
                        final item = widget.sources[currentIndex.value];
                        return [
                          if (Utils.isMobile)
                            PopupMenuItem(
                              onTap: () => ImageUtils.onShareImg(item.url),
                              child: const Text("分享图片"),
                            ),
                          PopupMenuItem(
                            onTap: () => Utils.copyText(item.url),
                            child: const Text("复制链接"),
                          ),
                          PopupMenuItem(
                            onTap: () => ImageUtils.downloadImg(
                              this.context,
                              [item.url],
                            ),
                            child: const Text("保存图片"),
                          ),
                          if (Utils.isDesktop)
                            PopupMenuItem(
                              onTap: () => PageUtils.launchURL(item.url),
                              child: const Text("网页打开"),
                            )
                          else if (widget.sources.length > 1)
                            PopupMenuItem(
                              onTap: () => ImageUtils.downloadImg(
                                this.context,
                                widget.sources.map((item) => item.url).toList(),
                              ),
                              child: const Text("保存全部"),
                            ),
                          if (item.sourceType == SourceType.livePhoto)
                            PopupMenuItem(
                              onTap: () {
                                ImageUtils.downloadLivePhoto(
                                  context: this.context,
                                  url: item.url,
                                  liveUrl: item.liveUrl!,
                                  width: item.width!,
                                  height: item.height!,
                                );
                              },
                              child: const Text("保存 Live Photo"),
                            ),
                        ];
                      },
                      child: const Icon(Icons.more_horiz, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemBuilder(int index, SourceModel item) {
    return Center(
      child: Hero(
        tag: item.url,
        child: switch (item.sourceType) {
          SourceType.fileImage => Image(
            filterQuality: FilterQuality.low,
            image: FileImage(File(item.url)),
          ),
          SourceType.networkImage => CachedNetworkImage(
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            imageUrl: _getActualUrl(item.url),
            placeholderFadeInDuration: Duration.zero,
            placeholder: (context, url) {
              return CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: ImageUtils.thumbnailUrl(item.url, widget.quality),
              );
            },
          ),
          SourceType.livePhoto => Obx(
            () => currentIndex.value == index
                ? IgnorePointer(
                    child: Video(
                      controller: _videoController!,
                      fill: Colors.transparent,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        },
      ),
    );
  }

  void onDoubleTap() {
    Matrix4 matrix = _transformationController!.value.clone();
    double currentScale = matrix.row0.x;

    double targetScale = widget.minScale;

    if (currentScale <= widget.minScale) {
      targetScale = widget.maxScale * 0.4;
    }

    double offSetX = targetScale == 1.0
        ? 0.0
        : -_doubleTapLocalPosition.dx * (targetScale - 1);
    double offSetY = targetScale == 1.0
        ? 0.0
        : -_doubleTapLocalPosition.dy * (targetScale - 1);

    matrix = Matrix4.fromList([
      targetScale,
      matrix.row1.x,
      matrix.row2.x,
      matrix.row3.x,
      matrix.row0.y,
      targetScale,
      matrix.row2.y,
      matrix.row3.y,
      matrix.row0.z,
      matrix.row1.z,
      targetScale,
      matrix.row3.z,
      offSetX,
      offSetY,
      matrix.row2.w,
      matrix.row3.w,
    ]);

    _animation =
        Matrix4Tween(
          begin: _transformationController!.value,
          end: matrix,
        ).animate(
          CurveTween(curve: Curves.easeOut).animate(_animationController),
        );
    _animationController
        .forward(from: 0)
        .whenComplete(() => _onScaleChanged(targetScale));
  }

  void onLongPress(SourceModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Utils.isMobile)
                ListTile(
                  onTap: () {
                    Get.back();
                    ImageUtils.onShareImg(item.url);
                  },
                  dense: true,
                  title: const Text('分享', style: TextStyle(fontSize: 14)),
                ),
              ListTile(
                onTap: () {
                  Get.back();
                  Utils.copyText(item.url);
                },
                dense: true,
                title: const Text('复制链接', style: TextStyle(fontSize: 14)),
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  ImageUtils.downloadImg(
                    this.context,
                    [item.url],
                  );
                },
                dense: true,
                title: const Text('保存图片', style: TextStyle(fontSize: 14)),
              ),
              if (Utils.isDesktop)
                ListTile(
                  onTap: () {
                    Get.back();
                    PageUtils.launchURL(item.url);
                  },
                  dense: true,
                  title: const Text('网页打开', style: TextStyle(fontSize: 14)),
                )
              else if (widget.sources.length > 1)
                ListTile(
                  onTap: () {
                    Get.back();
                    ImageUtils.downloadImg(
                      this.context,
                      widget.sources.map((item) => item.url).toList(),
                    );
                  },
                  dense: true,
                  title: const Text('保存全部图片', style: TextStyle(fontSize: 14)),
                ),
              if (item.sourceType == SourceType.livePhoto)
                ListTile(
                  onTap: () {
                    Get.back();
                    ImageUtils.downloadLivePhoto(
                      context: this.context,
                      url: item.url,
                      liveUrl: item.liveUrl!,
                      width: item.width!,
                      height: item.height!,
                    );
                  },
                  dense: true,
                  title: const Text(
                    '保存 Live Photo',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
