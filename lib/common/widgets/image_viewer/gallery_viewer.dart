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
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/colored_box_transition.dart';
import 'package:PiliPlus/common/widgets/flutter/page/page_view.dart';
import 'package:PiliPlus/common/widgets/gesture/image_horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image_viewer/image.dart';
import 'package:PiliPlus/common/widgets/image_viewer/loading_indicator.dart';
import 'package:PiliPlus/common/widgets/image_viewer/viewer.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/plugin/pl_player/view/simple_video_texture.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
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
    required this.thumbQ,
    required this.sources,
    this.initIndex = 0,
    this.onPageChanged,
    this.tag = '',
  });

  final double minScale;
  final double maxScale;
  final int thumbQ;
  final List<SourceModel> sources;
  final int initIndex;
  final ValueChanged<int>? onPageChanged;
  final String tag;

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer>
    with SingleTickerProviderStateMixin {
  late final sources = widget.sources;
  late Size _containerSize;
  late final int _previewQ;
  late final bool _isOrigin;
  List<bool>? _isOrigPic;
  late final RxInt _currIndex;
  GlobalKey? _key;
  late EdgeInsets _padding;

  late bool _hasInit = false;
  Player? _player;
  VideoController? _videoController;

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

  String _getActualUrl(String url, {required int index}) {
    return _isOrigin || _isOrigPic![index]
        ? url.http2https
        : ImageUtils.thumbnailUrl(url, maxQuality: _previewQ);
  }

  Future<void> _initPlayer() async {
    assert(_player == null);
    final player = await Player.create();
    _videoController = await VideoController.create(player);
    if (!mounted) {
      player.dispose();
      _videoController = null;
      return;
    }
    _player = player;
    final currItem = sources[_currIndex.value];
    if (currItem.sourceType == .livePhoto) {
      player.open(Media(currItem.liveUrl!));
      _currIndex.refresh();
    }
  }

  @override
  void initState() {
    super.initState();
    _previewQ = Pref.previewQ;
    _isOrigin = _previewQ == 100;
    if (!_isOrigin) {
      _isOrigPic = List.filled(sources.length, false);
    }
    _currIndex = widget.initIndex.obs;
    final item = sources[widget.initIndex];
    _playIfNeeded(item);

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _padding = MediaQuery.viewPaddingOf(context);
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
    _player?.dispose();
    _player = null;
    _videoController = null;
    _pageController.dispose();
    _animateController.dispose();
    _tapGestureRecognizer.dispose();
    _doubleTapGestureRecognizer
      ..onDoubleTapDown = null
      ..onDoubleTap = null
      ..dispose();
    _longPressGestureRecognizer.dispose();
    if (_isOrigPic != null) {
      for (int i = 0; i < _isOrigPic!.length; i++) {
        if (_isOrigPic![i]) {
          final item = sources[i];
          if (item.sourceType == .networkImage) {
            CachedNetworkImageProvider(
              _getActualUrl(item.url, index: i),
            ).evict();
          }
        }
      }
    }
    if (widget.thumbQ != _previewQ) {
      for (int i = 0; i < sources.length; i++) {
        final item = sources[i];
        if (item.sourceType == .networkImage) {
          CachedNetworkImageProvider(_getActualUrl(item.url, index: i)).evict();
        }
      }
    }

    Future.delayed(const Duration(milliseconds: 200), _currIndex.close);
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
                  itemCount: sources.length,
                  itemBuilder: _itemBuilder,
                  horizontalDragGestureRecognizer: () =>
                      _horizontalDragGestureRecognizer,
                ),
              );
            },
          ),
          _buildIndicator,
          if (!_isOrigin) _originButton,
        ],
      ),
    );
  }

  Widget get _originButton {
    return Positioned(
      top: 18 + _padding.top,
      child: Center(
        child: Obx(() {
          final index = _currIndex.value;
          if (!_isOrigPic![index]) {
            final item = sources[index];
            if (item.sourceType == .networkImage) {
              return FilledButton.tonal(
                style: FilledButton.styleFrom(
                  minimumSize: .zero,
                  visualDensity: .standard,
                  tapTargetSize: .shrinkWrap,
                  padding: const .symmetric(horizontal: 8, vertical: 5.5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: .all(.circular(4)),
                  ),
                  backgroundColor:
                      ThemeUtils.darkTheme.colorScheme.secondaryContainer,
                  foregroundColor:
                      ThemeUtils.darkTheme.colorScheme.onSecondaryContainer,
                ),
                onPressed: () {
                  _isOrigPic![index] = true;
                  setState(() {});
                },
                child: Text(
                  '查看原图${item.size == null ? '' : '(${item.size!.formatSize})'}',
                  style: const TextStyle(height: 1, fontSize: 13),
                  strutStyle: const StrutStyle(
                    height: 1,
                    leading: 0,
                    fontSize: 13,
                  ),
                ),
              );
            }
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget get _buildIndicator {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          padding: _padding + const .fromLTRB(12, 8, 20, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
              ],
            ),
          ),
          alignment: .center,
          child: Obx(
            () => Text(
              "${_currIndex.value + 1}/${sources.length}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _playIfNeeded(SourceModel item) {
    if (item.sourceType == .livePhoto) {
      if (_player != null) {
        _player!.open(Media(item.liveUrl!));
      } else if (!_hasInit) {
        _hasInit = true;
        _initPlayer();
      }
    }
  }

  void _onPageChanged(int index) {
    _player?.pause();
    _playIfNeeded(sources[index]);
    _currIndex.value = index;
    widget.onPageChanged?.call(index);
  }

  late final ValueChanged<int>? _onChangePage = sources.length == 1
      ? null
      : (int offset) {
          final currPage = _pageController.page?.round() ?? 0;
          final nextPage = (currPage + offset).clamp(
            0,
            sources.length - 1,
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
    final item = sources[index];
    final Widget child;
    switch (item.sourceType) {
      case .fileImage:
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
      case .networkImage:
        final isLongPic = item.isLongPic;
        double? cacheWidth, cacheHeight;
        if (item.isLongPic) {
          cacheWidth = math.min(650.0, _containerSize.width);
        } else if (_containerSize.width < _containerSize.height) {
          cacheWidth = _containerSize.width;
        } else {
          cacheHeight = _containerSize.height;
        }
        child = Image(
          key: _key,
          image: ResizeImage.resizeIfNeeded(
            cacheWidth,
            cacheHeight,
            CachedNetworkImageProvider(_getActualUrl(item.url, index: index)),
          ),
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
              if (widget.thumbQ == _previewQ && _isOrigPic?[index] != true) {
                return child;
              } else {
                return Image(
                  image: ResizeImage.resizeIfNeeded(
                    cacheWidth,
                    cacheHeight,
                    CachedNetworkImageProvider(
                      ImageUtils.thumbnailUrl(
                        item.url,
                        maxQuality: widget.thumbQ,
                      ),
                    ),
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
      case .livePhoto:
        child = Obx(
          key: _key,
          () => _currIndex.value == index && _videoController != null
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
                    child: SimpleVideoTexture(
                      controller: _videoController!,
                      fill: Colors.transparent,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
    }
    return Hero(tag: '${item.url}${widget.tag}', child: child);
  }

  void _onTap() {
    EasyThrottle.throttle(
      'VIEWER_TAP',
      const Duration(milliseconds: 555),
      Get.back,
    );
  }

  void _onLongPress() {
    final item = sources[_currIndex.value];
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
              title: item.size == null
                  ? const Text('保存图片', style: TextStyle(fontSize: 14))
                  : Text.rich(
                      TextSpan(
                        text: '保存图片',
                        children: [
                          TextSpan(
                            text: '(${item.size!.formatSize})',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
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
            else if (sources.length > 1)
              ListTile(
                onTap: () {
                  Get.back();
                  ImageUtils.downloadImg(
                    sources.map((item) => item.url).toList(),
                  );
                },
                dense: true,
                title: const Text('保存全部图片', style: TextStyle(fontSize: 14)),
              ),
            if (item.sourceType == .livePhoto)
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
    final item = sources[_currIndex.value];
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
          child: item.size == null
              ? const Text('保存图片', style: TextStyle(fontSize: 14))
              : Text.rich(
                  TextSpan(
                    text: '保存图片',
                    children: [
                      TextSpan(
                        text: '(${item.size!.formatSize})',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
        ),
        PopupMenuItem(
          height: 42,
          onTap: () => PageUtils.launchURL(item.url),
          child: const Text('网页打开', style: TextStyle(fontSize: 14)),
        ),
        if (item.sourceType == .livePhoto)
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
