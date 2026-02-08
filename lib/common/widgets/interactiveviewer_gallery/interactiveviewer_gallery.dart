import 'dart:io';

import 'package:PiliPlus/common/widgets/flutter/page/page_view.dart';
import 'package:PiliPlus/common/widgets/gesture/image_horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactive_viewer_boundary.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show CustomTabBarViewScrollPhysics;
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart' hide PageView;
import 'package:flutter/services.dart' show HapticFeedback;
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
    required this.quality,
    this.onClose,
  });

  final int quality;

  /// The sources to show.
  final List<SourceModel> sources;

  /// The index of the first source in [sources] to show.
  final int initIndex;

  /// The item content
  final IndexedFocusedWidgetBuilder? itemBuilder;

  final double maxScale;

  final double minScale;

  final VoidCallback? onClose;

  @override
  State<InteractiveviewerGallery> createState() =>
      _InteractiveviewerGalleryState();
}

class _InteractiveviewerGalleryState extends State<InteractiveviewerGallery>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final TransformationController _transformationController;

  /// The controller to animate the transformation value of the
  /// [InteractiveViewer] when it should reset.
  late AnimationController _animationController;

  late final _tween = Matrix4Tween();
  late final _animatable = _tween.chain(CurveTween(curve: Curves.easeOut));

  late final _horizontalDragGestureRecognizer =
      ImageHorizontalDragGestureRecognizer(
        width: 0,
        transformationController: _transformationController,
      );

  late Offset _doubleTapLocalPosition;

  late double _width;

  late final RxInt currentIndex = widget.initIndex.obs;

  late final int _quality = Pref.previewQ;

  late final RxBool _hasScaled = false.obs;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.initIndex);

    _transformationController = TransformationController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(listener);

    final item = widget.sources[currentIndex.value];
    if (item.sourceType == SourceType.livePhoto) {
      _onPlay(item.liveUrl!);
    }
  }

  void listener() {
    _transformationController.value = _animatable.evaluate(
      _animationController,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _width = MediaQuery.widthOf(context);
    _horizontalDragGestureRecognizer.width = _width;
  }

  @override
  void dispose() {
    widget.onClose?.call();
    _player?.dispose();
    _pageController.dispose();
    _animationController
      ..removeListener(listener)
      ..dispose();
    _transformationController.dispose();
    _horizontalDragGestureRecognizer.dispose();
    if (widget.quality != _quality) {
      for (final item in widget.sources) {
        if (item.sourceType == SourceType.networkImage) {
          CachedNetworkImageProvider(_getActualUrl(item.url)).evict();
        }
      }
    }
    super.dispose();
  }

  void _onScaleChanged(double scale) {
    _hasScaled.value = scale > 1.0;
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
    final item = widget.sources[page];
    if (item.sourceType == SourceType.livePhoto) {
      _onPlay(item.liveUrl!);
    }
    if (_transformationController.value != Matrix4.identity()) {
      // animate the reset for the transformation of the interactive viewer

      _tween
        ..begin = _transformationController.value.clone()
        ..end = Matrix4.identity();
      _animationController.forward(from: 0);
    }
  }

  String _getActualUrl(String url) {
    return _quality != 100
        ? ImageUtils.thumbnailUrl(url, _quality)
        : url.http2https;
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
          boundaryWidth: _width,
          maxScale: widget.maxScale,
          minScale: widget.minScale,
          onDismissed: Get.back,
          onInteractionEnd: (_) =>
              _onScaleChanged(_transformationController.value.storage[0]),
          child: PageView<ImageHorizontalDragGestureRecognizer>.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemCount: widget.sources.length,
            physics: const CustomTabBarViewScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemBuilder: (BuildContext context, int index) {
              final item = widget.sources[index];
              final isFileImg = item.sourceType == SourceType.fileImage;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => EasyThrottle.throttle(
                  'preview',
                  const Duration(milliseconds: 555),
                  Get.back,
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
                onSecondaryTapUp: PlatformUtils.isDesktop && !isFileImg
                    ? (e) => _showDesktopMenu(e.globalPosition, item)
                    : null,
                child: widget.itemBuilder != null
                    ? widget.itemBuilder!(
                        context,
                        index,
                        index == currentIndex.value,
                      )
                    : _itemBuilder(index, item),
              );
            },
            horizontalDragGestureRecognizer: _horizontalDragGestureRecognizer,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Obx(
            () => Container(
              padding:
                  MediaQuery.viewPaddingOf(context) +
                  const EdgeInsets.fromLTRB(12, 8, 20, 8),
              decoration: _hasScaled.value
                  ? null
                  : BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
              alignment: Alignment.center,
              child: Obx(
                () => Text(
                  "${currentIndex.value + 1}/${widget.sources.length}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
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
          SourceType.fileImage => Image.file(
            File(item.url),
            filterQuality: FilterQuality.low,
          ),
          SourceType.networkImage => CachedNetworkImage(
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            imageUrl: _getActualUrl(item.url),
            placeholderFadeInDuration: Duration.zero,
            placeholder: (context, url) {
              if (widget.quality == _quality) {
                return const SizedBox.expand();
              }
              return CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: ImageUtils.thumbnailUrl(item.url, widget.quality),
                placeholder: (_, _) => const SizedBox.expand(),
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
    final matrix = _transformationController.value.clone();
    final currentScale = matrix.storage[0];

    double targetScale = widget.minScale;

    if (currentScale <= widget.minScale) {
      targetScale = widget.maxScale * 0.4;
    }

    final double dx, dy;
    if (targetScale == 1.0) {
      dx = dy = 0;
    } else {
      final tmp = 1 - targetScale;
      dx = _doubleTapLocalPosition.dx * tmp;
      dy = _doubleTapLocalPosition.dy * tmp;
    }

    matrix
      ..[0] = targetScale
      ..[5] = targetScale
      ..[10] = targetScale
      ..[12] = dx
      ..[13] = dy;

    _tween
      ..begin = _transformationController.value.clone()
      ..end = matrix;

    _animationController
        .forward(from: 0)
        .whenComplete(() => _onScaleChanged(targetScale));
  }

  void onLongPress(SourceModel item) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (PlatformUtils.isMobile)
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
                ImageUtils.downloadImg([item.url]);
              },
              dense: true,
              title: const Text('保存图片', style: TextStyle(fontSize: 14)),
            ),
            if (PlatformUtils.isDesktop)
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
                    url: item.url,
                    liveUrl: item.liveUrl!,
                    width: item.width!,
                    height: item.height!,
                  );
                },
                dense: true,
                title: Text(
                  '保存${Platform.isIOS ? ' Live Photo' : '视频'}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDesktopMenu(Offset offset, SourceModel item) {
    showMenu(
      context: context,
      position: PageUtils.menuPosition(offset),
      items: [
        PopupMenuItem(
          height: 42,
          onTap: () => Utils.copyText(item.url),
          child: const Text('复制链接', style: TextStyle(fontSize: 14)),
        ),
        PopupMenuItem(
          height: 42,
          onTap: () => ImageUtils.downloadImg([item.url]),
          child: const Text('保存图片', style: TextStyle(fontSize: 14)),
        ),
        PopupMenuItem(
          height: 42,
          onTap: () => PageUtils.launchURL(item.url),
          child: const Text('网页打开', style: TextStyle(fontSize: 14)),
        ),
        if (item.sourceType == SourceType.livePhoto)
          PopupMenuItem(
            height: 42,
            onTap: () => ImageUtils.downloadLivePhoto(
              url: item.url,
              liveUrl: item.liveUrl!,
              width: item.width!,
              height: item.height!,
            ),
            child: const Text('保存视频', style: TextStyle(fontSize: 14)),
          ),
      ],
    );
  }
}
