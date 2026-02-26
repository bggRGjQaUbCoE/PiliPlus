/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:io' show File, Platform;

import 'package:PiliPlus/common/widgets/colored_box_transition.dart';
import 'package:PiliPlus/common/widgets/flutter/page/page_view.dart';
import 'package:PiliPlus/common/widgets/gesture/image_horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image_viewer/image.dart';
import 'package:PiliPlus/common/widgets/image_viewer/loading_indicator.dart';
import 'package:PiliPlus/common/widgets/image_viewer/viewer.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Image, PageView;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

///
/// created by dom on 2026/02/14
///

class GalleryViewer extends StatefulWidget {
  const GalleryViewer({
    super.key,
    this.minScale = 1.0,
    this.maxScale = 8.0,
    required this.quality,
    required this.sources,
    this.initIndex = 0,
  });

  final double minScale;
  final double maxScale;
  final int quality;
  final List<SourceModel> sources;
  final int initIndex;

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer>
    with SingleTickerProviderStateMixin {
  late Size _containerSize;
  late final int _quality;
  late final RxInt _currIndex;
  GlobalKey? _key;

  late final _controller = Rxn<VideoController>();
  Player? _player;
  String? _initUri;

  late final PageController _pageController;

  late final TapGestureRecognizer _tapGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late final ImageHorizontalDragGestureRecognizer
  _horizontalDragGestureRecognizer;
  late final LongPressGestureRecognizer _longPressGestureRecognizer;

  late final AnimationController _animateController;
  late final Animation<Color?> _opacityAnimation;
  double dx = 0, dy = 0;

  Offset _offset = Offset.zero;
  bool _dragging = false;

  String _getActualUrl(String url) {
    return _quality != 100
        ? ImageUtils.thumbnailUrl(url, _quality)
        : url.http2https;
  }

  Future<void> _initPlayer() async {
    final player = await Player.create();
    _controller.value = await VideoController.create(player);
    if (_initUri == null) {
      player.dispose();
    } else {
      _player = player;
      await player.open(Media(_initUri!));
    }
  }

  @override
  void initState() {
    super.initState();
    _quality = Pref.previewQ;
    _currIndex = widget.initIndex.obs;
    final item = widget.sources[widget.initIndex];
    if (item.sourceType == .livePhoto) {
      _playIfNeeded(item);
    }

    if (!item.isLongPic) {
      _key = GlobalKey();
      WidgetsBinding.instance.addPostFrameCallback((_) => _key = null);
    }

    _pageController = PageController(initialPage: widget.initIndex);

    final gestureSettings = MediaQuery.maybeGestureSettingsOf(Get.context!);
    _tapGestureRecognizer = TapGestureRecognizer()
      // ..onTap = _onTap
      ..gestureSettings = gestureSettings;
    if (PlatformUtils.isDesktop) {
      _tapGestureRecognizer.onSecondaryTapUp = _showDesktopMenu;
    }
    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer()
      ..onDoubleTap = () {}
      ..gestureSettings = gestureSettings;
    _horizontalDragGestureRecognizer = ImageHorizontalDragGestureRecognizer();
    _longPressGestureRecognizer = LongPressGestureRecognizer()
      ..onLongPress = _onLongPress
      ..gestureSettings = gestureSettings;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _tapGestureRecognizer.onTap = _onTap;
      }
    });

    _animateController = AnimationController(
      duration: const Duration(
        milliseconds: 750,
      ), // reverse only if value <= 0.2
      vsync: this,
    );

    _opacityAnimation = _animateController.drive(
      ColorTween(
        begin: Colors.black,
        end: Colors.transparent,
      ),
    );
  }

  Matrix4 _onTransform(double val) {
    final scale = val.lerp(1.0, 0.25);

    // Matrix4.identity()
    //   ..translateByDouble(size.width / 2, size.height / 2, 0, 1)
    //   ..translateByDouble(size.width * val * dx, size.height * val * dy, 0, 1)
    //   ..scaleByDouble(scale, scale, scale, 1)
    //   ..translateByDouble(-size.width / 2, -size.height / 2, 0, 1);

    final tmp = (1.0 - scale) / 2.0;
    return Matrix4.diagonal3Values(scale, scale, scale)..setTranslationRaw(
      _containerSize.width * (val * dx + tmp),
      _containerSize.height * (val * dy + tmp),
      0,
    );
  }

  void _updateMoveAnimation() {
    dy = _offset.dy.sign;
    if (dy == 0) {
      dx = 0;
    } else {
      dx = _offset.dx / _offset.dy.abs();
    }
  }

  void _onDragStart(ScaleStartDetails details) {
    _dragging = true;

    if (_animateController.isAnimating) {
      _animateController.stop();
    } else {
      _offset = Offset.zero;
      _animateController.value = 0.0;
    }
    _updateMoveAnimation();
  }

  void _onDragUpdate(ScaleUpdateDetails details) {
    if (!_dragging || _animateController.isAnimating) {
      return;
    }

    _offset += details.focalPointDelta;
    _updateMoveAnimation();

    if (!_animateController.isAnimating) {
      _animateController.value = _offset.dy.abs() / _containerSize.height;
    }
  }

  void _onDragEnd(ScaleEndDetails details) {
    if (!_dragging || _animateController.isAnimating) {
      return;
    }

    _dragging = false;

    if (!_animateController.isDismissed) {
      if (_animateController.value > 0.2) {
        Get.back();
      } else {
        _animateController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _initUri = null;
    _player?.dispose();
    _player = null;
    _pageController.dispose();
    _animateController.dispose();
    _tapGestureRecognizer.dispose();
    _doubleTapGestureRecognizer
      ..onDoubleTapDown = null
      ..onDoubleTap = null
      ..dispose();
    _longPressGestureRecognizer.dispose();
    _currIndex.close();
    if (widget.quality != _quality) {
      for (final item in widget.sources) {
        if (item.sourceType == SourceType.networkImage) {
          CachedNetworkImageProvider(_getActualUrl(item.url)).evict();
        }
      }
    }
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _tapGestureRecognizer.addPointer(event);
    _doubleTapGestureRecognizer.addPointer(event);
    _longPressGestureRecognizer.addPointer(event);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: .opaque,
      onPointerDown: _onPointerDown,
      child: Stack(
        fit: .expand,
        alignment: .center,
        clipBehavior: .none,
        children: [
          ColoredBoxTransition(color: _opacityAnimation),
          LayoutBuilder(
            builder: (context, constraints) {
              _containerSize = constraints.biggest;
              return MatrixTransition(
                alignment: .topLeft,
                animation: _animateController,
                onTransform: _onTransform,
                child: PageView<ImageHorizontalDragGestureRecognizer>.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const CustomTabBarViewScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: widget.sources.length,
                  itemBuilder: _itemBuilder,
                  horizontalDragGestureRecognizer: () =>
                      _horizontalDragGestureRecognizer,
                ),
              );
            },
          ),
          _buildIndicator,
        ],
      ),
    );
  }

  Widget get _buildIndicator => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: IgnorePointer(
      child: Container(
        padding:
            MediaQuery.viewPaddingOf(context) +
            const EdgeInsets.fromLTRB(12, 8, 20, 8),
        decoration: BoxDecoration(
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
            "${_currIndex.value + 1}/${widget.sources.length}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  void _playIfNeeded(SourceModel item) {
    if (item.sourceType == .livePhoto) {
      if (_player != null) {
        _player!.open(Media(item.liveUrl!));
      } else {
        if (_initUri == null) {
          _initPlayer();
        }
        _initUri = item.liveUrl;
      }
    }
  }

  void _onPageChanged(int index) {
    _player?.pause();
    _playIfNeeded(widget.sources[index]);
    _currIndex.value = index;
  }

  late final ValueChanged<int>? _onChangePage = widget.sources.length == 1
      ? null
      : (int offset) {
          final currPage = _pageController.page?.round() ?? 0;
          final nextPage = (currPage + offset).clamp(
            0,
            widget.sources.length - 1,
          );
          if (nextPage != currPage) {
            _pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          }
        };

  Widget _itemBuilder(BuildContext context, int index) {
    final item = widget.sources[index];
    final Widget child;
    switch (item.sourceType) {
      case SourceType.fileImage:
        child = Image.file(
          key: _key,
          File(item.url),
          filterQuality: .low,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          containerSize: _containerSize,
          onDragStart: _onDragStart,
          onDragUpdate: _onDragUpdate,
          onDragEnd: _onDragEnd,
          doubleTapGestureRecognizer: _doubleTapGestureRecognizer,
          horizontalDragGestureRecognizer: _horizontalDragGestureRecognizer,
          onChangePage: _onChangePage,
        );
      case SourceType.networkImage:
        final isLongPic = item.isLongPic;
        child = Image(
          key: _key,
          image: CachedNetworkImageProvider(_getActualUrl(item.url)),
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          containerSize: _containerSize,
          doubleTapGestureRecognizer: _doubleTapGestureRecognizer,
          horizontalDragGestureRecognizer: _horizontalDragGestureRecognizer,
          onChangePage: _onChangePage,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            if (frame == null) {
              if (widget.quality == _quality) {
                return child;
              } else {
                return Image(
                  image: CachedNetworkImageProvider(
                    ImageUtils.thumbnailUrl(item.url, widget.quality),
                  ),
                  minScale: widget.minScale,
                  maxScale: widget.maxScale,
                  containerSize: _containerSize,
                  onDragStart: null,
                  onDragUpdate: null,
                  onDragEnd: null,
                  doubleTapGestureRecognizer: _doubleTapGestureRecognizer,
                  horizontalDragGestureRecognizer:
                      _horizontalDragGestureRecognizer,
                  onChangePage: _onChangePage,
                );
                // final isLongPic = item.isLongPic;
                // return CachedNetworkImage(
                //   fadeInDuration: Duration.zero,
                //   fadeOutDuration: Duration.zero,
                //   // fit: isLongPic ? .fitWidth : null,
                //   // alignment: isLongPic ? .topCenter : .center,
                //   imageUrl: ImageUtils.thumbnailUrl(item.url, widget.quality),
                //   placeholder: (_, _) => const SizedBox.expand(),
                // );
              }
            }
            return child;
          },
          loadingBuilder: loadingBuilder,
          onDragStart: _onDragStart,
          onDragUpdate: _onDragUpdate,
          onDragEnd: _onDragEnd,
        );
        if (isLongPic) {
          return child;
        }
      case SourceType.livePhoto:
        child = Obx(key: _key, () {
          final ctr = _controller.value;
          return _currIndex.value == index && ctr != null
              ? Viewer(
                  minScale: widget.minScale,
                  maxScale: widget.maxScale,
                  containerSize: _containerSize,
                  childSize: _containerSize,
                  onDragStart: _onDragStart,
                  onDragUpdate: _onDragUpdate,
                  onDragEnd: _onDragEnd,
                  doubleTapGestureRecognizer: _doubleTapGestureRecognizer,
                  horizontalDragGestureRecognizer:
                      _horizontalDragGestureRecognizer,
                  onChangePage: _onChangePage,
                  child: FittedBox(
                    child: SimpleVideo(
                      controller: ctr,
                      fill: Colors.transparent,
                    ),
                  ),
                )
              : const SizedBox.shrink();
        });
    }
    return Hero(tag: item.url, child: child);
  }

  void _onTap() {
    EasyThrottle.throttle(
      'VIEWER_TAP',
      const Duration(milliseconds: 555),
      Get.back,
    );
  }

  void _onLongPress() {
    final item = widget.sources[_currIndex.value];
    if (item.sourceType == .fileImage) return;
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

  void _showDesktopMenu(TapUpDetails details) {
    final item = widget.sources[_currIndex.value];
    if (item.sourceType == .fileImage) return;
    showMenu(
      context: context,
      position: PageUtils.menuPosition(details.globalPosition),
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

  Widget loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    return Stack(
      fit: .expand,
      alignment: .center,
      clipBehavior: .none,
      children: [
        child,
        if (loadingProgress != null &&
            loadingProgress.expectedTotalBytes != null &&
            loadingProgress.cumulativeBytesLoaded !=
                loadingProgress.expectedTotalBytes)
          Center(
            child: LoadingIndicator(
              size: 39.4,
              progress:
                  loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!,
            ),
          ),
      ],
    );
  }
}
