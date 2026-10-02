part of 'view.dart';

const double desktopProgressHorizontalInset = 20.0;
const double desktopProgressBarHeight = 3.5;
const double desktopProgressHoverPadding = 10.0;
const double desktopProgressThumbRadius = 7.0;
const double desktopProgressInteractiveHeight =
    desktopProgressHoverPadding * 2 + desktopProgressBarHeight;
const double desktopProgressBarTopInset =
    desktopProgressHoverPadding + desktopProgressBarHeight;
const double desktopProgressDmChartOffset =
    desktopProgressBarTopInset - 4.25;
// 底部控制栏和进度条之间的基础留白。
const double desktopProgressBottomPadding = 12.0;
// 底部控制栏本身的高度。
const double desktopProgressControlHeight = 30.0;
// 控制栏和进度条之间的内层间距。
const double desktopProgressInnerBottomPadding = 7.0;
// 进度条和 Hover 浮层（时间指示器和预览窗口）整体之间的额外间距。
const double desktopProgressOverlayGap = 9.0;
// 时间指示器距离底部的总偏移基准。
const double desktopProgressTimeIndicatorBottom =
    desktopProgressBottomPadding +
    desktopProgressControlHeight +
    desktopProgressInnerBottomPadding +
    desktopProgressInteractiveHeight +
    desktopProgressOverlayGap;
// 预览窗在时间指示器基准上再往上抬的距离。
const double desktopProgressSeekPreviewBottom =
    desktopProgressTimeIndicatorBottom + 40.0;

Widget buildDmChart(
  Color color,
  List<double> dmTrend,
  VideoDetailController videoDetailController, [
  double offset = 0,
  bool fixedLayoutHeight = false,
]) {
  final bottomMargin =
      videoDetailController.viewPointList.isNotEmpty &&
          videoDetailController.showVP.value
      ? 19.25 + offset
      : 4.25 + offset;
  final chart = LineChart(
    LineChartData(
      titlesData: const FlTitlesData(show: false),
      lineTouchData: const LineTouchData(enabled: false),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (dmTrend.length - 1).toDouble(),
      minY: 0,
      maxY: dmTrend.max,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            dmTrend.length,
            (index) => FlSpot(
              index.toDouble(),
              dmTrend[index],
            ),
          ),
          isCurved: true,
          barWidth: 1,
          color: color,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: color.withValues(alpha: 0.4),
          ),
        ),
      ],
    ),
  );
  if (!fixedLayoutHeight) {
    return IgnorePointer(
      child: Container(
        height: 12,
        margin: EdgeInsets.only(bottom: bottomMargin),
        child: chart,
      ),
    );
  }
  return IgnorePointer(
    child: SizedBox(
      height: 12,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomMargin,
            child: SizedBox(
              height: 12,
              child: chart,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildSeekPreviewWidget(
  PlPlayerController plPlayerController,
  double maxWidth,
  double maxHeight,
  ValueGetter<bool> isMounted,
) {
  return Obx(
    () {
      if (!plPlayerController.showPreview.value) {
        return const SizedBox.shrink();
      }

      try {
        final height = desktopSeekPreviewHeight(
          plPlayerController,
          maxHeight,
        );

        Widget positionPreview(Widget child, double width) {
          final previewValue =
              plPlayerController.desktopProgressPreviewValue.value;
          if (PlatformUtils.isDesktop &&
              plPlayerController.showDesktopProgressFeedback.value &&
              previewValue != null) {
            return _DesktopProgressPreviewLayout(
              maxWidth: maxWidth,
              previewValue: previewValue,
              anchorWidth: width,
              bottom: desktopProgressSeekPreviewBottom,
              child: child,
            );
          }
          return Align(
            alignment: Alignment.center,
            child: child,
          );
        }

        final videoShot = plPlayerController.videoShot;
        final data = videoShot?.dataOrNull;
        if (data == null) {
          final width = desktopSeekPreviewWidth(
            plPlayerController,
            maxHeight,
          );
          return positionPreview(
            _SeekPreviewPlaceholder(
              width: width,
              height: height,
            ),
            width,
          );
        }

        if (data.image.isEmpty) {
          return const SizedBox.shrink();
        }
        final int imgXLen = data.imgXLen;
        final int imgYLen = data.imgYLen;
        final int totalPerImage = data.totalPerImage;
        double imgXSize = data.imgXSize;
        double imgYSize = data.imgYSize;
        final width = desktopSeekPreviewWidth(
          plPlayerController,
          maxHeight,
        );

        return positionPreview(
          Obx(
            () {
              final index = plPlayerController.previewIndex.value;
              if (index == null) {
                return _SeekPreviewPlaceholder(
                  width: width,
                  height: height,
                );
              }
              int pageIndex = (index ~/ totalPerImage).clamp(
                0,
                data.image.length - 1,
              );
              int align = index % totalPerImage;
              int x = align % imgXLen;
              int y = align ~/ imgYLen;
              final url = data.image[pageIndex];

              return ClipRRect(
                borderRadius: Style.mdRadius,
                child: VideoShotImage(
                  url: url,
                  x: x,
                  y: y,
                  imgXSize: imgXSize,
                  imgYSize: imgYSize,
                  height: height,
                  imageCache: plPlayerController.previewCache,
                  onSetSize: (xSize, ySize) {
                    if (imgXSize == xSize && imgYSize == ySize) {
                      return;
                    }
                    data
                      ..imgXSize = imgXSize = xSize
                      ..imgYSize = imgYSize = ySize;
                    plPlayerController.refreshDesktopProgressPreviewLayout();
                  },
                  isMounted: isMounted,
                ),
              );
            },
          ),
          width,
        );
      } catch (e) {
        if (kDebugMode) rethrow;
        return const SizedBox.shrink();
      }
    },
  );
}

double desktopSeekPreviewHeight(
  PlPlayerController plPlayerController,
  double maxHeight,
) {
  final double scale =
      plPlayerController.isFullScreen.value &&
          (PlatformUtils.isDesktop || !plPlayerController.isVertical)
      ? 4
      : 3;
  double height = 27 * scale;
  final compatHeight = maxHeight - 140;
  if (compatHeight > 50) {
    height = math.min(height, compatHeight);
  }
  return height;
}

double desktopSeekPreviewWidth(
  PlPlayerController plPlayerController,
  double maxHeight,
) {
  plPlayerController.desktopProgressPreviewLayoutVersion.value;
  final data = plPlayerController.videoShot?.dataOrNull;
  if (data == null) {
    return desktopSeekPreviewHeight(plPlayerController, maxHeight) * 16 / 9;
  }
  return desktopSeekPreviewWidthFromSize(
    height: desktopSeekPreviewHeight(plPlayerController, maxHeight),
    imgXSize: data.imgXSize,
    imgYSize: data.imgYSize,
  );
}

double desktopSeekPreviewWidthFromSize({
  required double height,
  required double imgXSize,
  required double imgYSize,
}) {
  if (imgXSize <= 0 || imgYSize <= 0) {
    return height * 16 / 9;
  }
  return height * imgXSize / imgYSize;
}

class _DesktopProgressPreviewLayout extends StatelessWidget {
  const _DesktopProgressPreviewLayout({
    required this.maxWidth,
    required this.previewValue,
    required this.anchorWidth,
    required this.bottom,
    required this.child,
  });

  static const double _margin = 12.0;

  final double maxWidth;
  final double previewValue;
  final double anchorWidth;
  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _DesktopProgressPreviewLayoutDelegate(
        maxWidth: maxWidth,
        previewValue: previewValue,
        anchorWidth: anchorWidth,
        bottom: bottom,
        margin: _margin,
      ),
      child: child,
    );
  }
}

class _DesktopProgressPreviewLayoutDelegate extends SingleChildLayoutDelegate {
  const _DesktopProgressPreviewLayoutDelegate({
    required this.maxWidth,
    required this.previewValue,
    required this.anchorWidth,
    required this.bottom,
    required this.margin,
  });

  final double maxWidth;
  final double previewValue;
  final double anchorWidth;
  final double bottom;
  final double margin;

  @override
  Size getSize(BoxConstraints constraints) {
    final width = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : maxWidth;
    final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 0.0;
    return Size(width, height);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final anchorCenter = _desktopPreviewAnchorCenter(
      maxWidth: size.width,
      previewValue: previewValue,
      anchorWidth: anchorWidth,
      margin: margin,
    );
    final maxLeft = math.max(margin, size.width - childSize.width - margin);
    final left = (anchorCenter - childSize.width / 2)
        .clamp(margin, maxLeft)
        .toDouble();
    final maxTop = math.max(margin, size.height - childSize.height - margin);
    final top = (size.height - bottom - childSize.height)
        .clamp(margin, maxTop)
        .toDouble();
    return Offset(left, top);
  }

  @override
  bool shouldRelayout(
    covariant _DesktopProgressPreviewLayoutDelegate oldDelegate,
  ) {
    return oldDelegate.maxWidth != maxWidth ||
        oldDelegate.previewValue != previewValue ||
        oldDelegate.anchorWidth != anchorWidth ||
        oldDelegate.bottom != bottom ||
        oldDelegate.margin != margin;
  }
}

double _desktopPreviewAnchorCenter({
  required double maxWidth,
  required double previewValue,
  required double anchorWidth,
  required double margin,
}) {
  final availableWidth = math.max(0.0, maxWidth - margin * 2);
  final width = anchorWidth.clamp(0.0, availableWidth).toDouble();
  final maxLeft = math.max(margin, maxWidth - width - margin);
  final anchorCenter = _desktopProgressHoverCenter(
    maxWidth: maxWidth,
    previewValue: previewValue,
  );
  final left = (anchorCenter - width / 2)
      .clamp(margin, maxLeft)
      .toDouble();
  return left + width / 2;
}

double _desktopProgressHoverCenter({
  required double maxWidth,
  required double previewValue,
}) {
  final trackWidth = math.max(
    0.0,
    maxWidth - desktopProgressHorizontalInset * 2,
  );
  final availableWidth = math.max(
    0.0,
    trackWidth - desktopProgressBarHeight,
  );
  final value = previewValue.clamp(0.0, 1.0).toDouble();
  return desktopProgressHorizontalInset +
      desktopProgressBarHeight / 2 +
      value * availableWidth;
}

class _SeekPreviewPlaceholder extends StatelessWidget {
  const _SeekPreviewPlaceholder({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return ClipRRect(
      borderRadius: Style.mdRadius,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.58),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        child: SizedBox.square(
          dimension: math.min(24, height * 0.28),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class VideoShotImage extends StatefulWidget {
  const VideoShotImage({
    super.key,
    required this.imageCache,
    required this.url,
    required this.x,
    required this.y,
    required this.imgXSize,
    required this.imgYSize,
    required this.height,
    required this.onSetSize,
    required this.isMounted,
  });

  final Map<String, ui.Image?> imageCache;
  final String url;
  final int x;
  final int y;
  final double imgXSize;
  final double imgYSize;
  final double height;
  final Function(double imgXSize, double imgYSize) onSetSize;
  final ValueGetter<bool> isMounted;

  @override
  State<VideoShotImage> createState() => _VideoShotImageState();
}

Future<ui.Image?> _getImg(String url) async {
  final cacheKey = Utils.getFileName(url, fileExt: false);
  try {
    final fileInfo = await CacheManager.manager.getSingleFile(
      ImageUtils.safeThumbnailUrl(url),
      key: cacheKey,
      headers: Constants.baseHeaders,
    );
    return await _loadImg(fileInfo.path);
  } catch (_) {
    return null;
  }
}

Future<ui.Image?> _loadImg(String path) async {
  final codec = await ui.instantiateImageCodecFromBuffer(
    await ImmutableBuffer.fromFilePath(path),
  );
  final frame = await codec.getNextFrame();
  codec.dispose();
  return frame.image;
}

class _VideoShotImageState extends State<VideoShotImage> {
  late Size _size;
  late Rect _srcRect;
  late Rect _dstRect;
  late RRect _rrect;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _initSize();
    _loadImg();
  }

  void _initSizeIfNeeded() {
    if (_size.width.isNaN) {
      _initSize();
    }
  }

  void _initSize() {
    if (widget.imgXSize == 0) {
      if (_image != null) {
        final imgXSize = _image!.width / 10;
        final imgYSize = _image!.height / 10;
        final height = widget.height;
        final width = height * imgXSize / imgYSize;
        _setRect(width, height);
        _setSrcRect(imgXSize, imgYSize);
        widget.onSetSize(imgXSize, imgYSize);
      } else {
        _setRect(double.nan, double.nan);
        _setSrcRect(widget.imgXSize, widget.imgYSize);
      }
    } else {
      final height = widget.height;
      final width = height * widget.imgXSize / widget.imgYSize;
      _setRect(width, height);
      _setSrcRect(widget.imgXSize, widget.imgYSize);
    }
  }

  void _setRect(double width, double height) {
    _size = Size(width, height);
    _dstRect = Rect.fromLTRB(0, 0, width, height);
    _rrect = RRect.fromRectAndRadius(_dstRect, const Radius.circular(10));
  }

  void _setSrcRect(double imgXSize, double imgYSize) {
    _srcRect = Rect.fromLTWH(
      widget.x * imgXSize,
      widget.y * imgYSize,
      imgXSize,
      imgYSize,
    );
  }

  void _loadImg() {
    final url = widget.url;
    _image = widget.imageCache[url];
    if (_image != null) {
      _initSizeIfNeeded();
    } else if (!widget.imageCache.containsKey(url)) {
      widget.imageCache[url] = null;
      _getImg(url).then((image) {
        if (image != null) {
          if (widget.isMounted()) {
            widget.imageCache[url] = image;
          }
          if (mounted) {
            _image = image;
            _initSizeIfNeeded();
            setState(() {});
          }
        } else {
          widget.imageCache.remove(url);
        }
      });
    }
  }

  @override
  void didUpdateWidget(VideoShotImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadImg();
    }
    if (oldWidget.x != widget.x || oldWidget.y != widget.y) {
      _setSrcRect(widget.imgXSize, widget.imgYSize);
    }
  }

  late final _imgPaint = Paint()..filterQuality = FilterQuality.medium;
  late final _borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return CroppedImage(
        size: _size,
        image: _image!,
        srcRect: _srcRect,
        dstRect: _dstRect,
        rrect: _rrect,
        imgPaint: _imgPaint,
        borderPaint: _borderPaint,
      );
    }
    return const SizedBox.shrink();
  }
}

const double _triangleHeight = 5.6;

class _DanmakuTip extends SingleChildRenderObjectWidget {
  const _DanmakuTip({this.offset = 0, super.child});

  final double offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderDanmakuTip(offset: offset);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderDanmakuTip renderObject,
  ) {
    renderObject.offset = offset;
  }
}

class _RenderDanmakuTip extends RenderProxyBox {
  _RenderDanmakuTip({
    required this._offset,
  });

  double _offset;
  double get offset => _offset;
  set offset(double value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()
      ..color = const Color(0xB3000000)
      ..style = .fill;

    final radius = size.height / 2;
    const triangleBase = _triangleHeight * 2 / 3;

    final triangleCenterX = (size.width / 2 + _offset).clamp(
      radius + triangleBase,
      size.width - radius - triangleBase,
    );
    final path = Path()
      // triangle (exceed)
      ..moveTo(triangleCenterX - triangleBase, 0)
      ..lineTo(triangleCenterX, -_triangleHeight)
      ..lineTo(triangleCenterX + triangleBase, 0)
      // top
      ..lineTo(size.width - radius, 0)
      // right
      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: Radius.circular(radius),
      )
      // bottom
      ..lineTo(radius, size.height)
      // left
      ..arcToPoint(
        Offset(radius, 0),
        radius: Radius.circular(radius),
      )
      ..close();

    context.canvas
      ..save()
      ..translate(offset.dx, offset.dy)
      ..drawPath(path, paint)
      ..drawPath(
        path,
        paint
          ..color = const Color(0x7EFFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.25,
      )
      ..restore();

    super.paint(context, offset);
  }
}

class _VideoTime extends LeafRenderObjectWidget {
  const _VideoTime({
    required this.position,
    required this.duration,
  });

  final String position;
  final String duration;

  @override
  _RenderVideoTime createRenderObject(BuildContext context) => _RenderVideoTime(
    position: position,
    duration: duration,
  );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderVideoTime renderObject,
  ) {
    renderObject
      ..position = position
      ..duration = duration;
  }
}

class _RenderVideoTime extends RenderBox {
  _RenderVideoTime({
    required this._position,
    required this._duration,
  });

  String _duration;
  set duration(String value) {
    if (_duration == value) return;
    _duration = value;
    final paragraph = _buildParagraph(const Color(0xFFD0D0D0), _duration);
    if (paragraph.maxIntrinsicWidth != _cache?.maxIntrinsicWidth) {
      markNeedsLayout();
    } else {
      markNeedsSemanticsUpdate();
    }
    _cache?.dispose();
    _cache = paragraph;
  }

  String _position;
  set position(String value) {
    _position = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  ui.Paragraph? _cache;

  static ui.Paragraph _buildParagraph(Color color, String time) {
    final builder =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: 10,
              height: 1.4,
              fontFamily: 'Monospace',
            ),
          )
          ..pushStyle(
            ui.TextStyle(
              color: color,
              fontSize: 10,
              height: 1.4,
              fontFamily: 'Monospace',
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          )
          ..addText(time);
    return builder.build()
      ..layout(const ui.ParagraphConstraints(width: .infinity));
  }

  @override
  ui.Size computeDryLayout(covariant BoxConstraints constraints) {
    final paragraph = _cache ??= _buildParagraph(
      const Color(0xFFD0D0D0),
      _duration,
    );
    return Size(paragraph.maxIntrinsicWidth, paragraph.height * 2);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config
      ..textDirection = .ltr
      ..label = 'position:$_position\nduration:$_duration';
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    final para = _buildParagraph(Colors.white, _position);
    context.canvas
      ..drawParagraph(
        para,
        Offset(
          offset.dx + _cache!.maxIntrinsicWidth - para.maxIntrinsicWidth,
          offset.dy,
        ),
      )
      ..drawParagraph(_cache!, Offset(offset.dx, offset.dy + para.height));
    para.dispose();
  }

  @override
  void dispose() {
    _cache?.dispose();
    _cache = null;
    super.dispose();
  }

  @override
  bool get isRepaintBoundary => true;
}
