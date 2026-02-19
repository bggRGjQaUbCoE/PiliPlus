part of 'view.dart';

Widget buildDmChart(
  Color color,
  List<double> dmTrend,
  VideoDetailController videoDetailController, [
  double offset = 0,
]) {
  return IgnorePointer(
    child: Container(
      height: 12,
      margin: EdgeInsets.only(
        bottom:
            videoDetailController.viewPointList.isNotEmpty &&
                videoDetailController.showVP.value
            ? 19.25 + offset
            : 4.25 + offset,
      ),
      child: LineChart(
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
        final data = plPlayerController.videoShot!.data;

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

        final int imgXLen = data.imgXLen;
        final int imgYLen = data.imgYLen;
        final int totalPerImage = data.totalPerImage;
        double imgXSize = data.imgXSize;
        double imgYSize = data.imgYSize;

        return Align(
          alignment: Alignment.center,
          child: Obx(
            () {
              final index = plPlayerController.previewIndex.value!;
              int pageIndex = (index ~/ totalPerImage).clamp(
                0,
                data.image.length - 1,
              );
              int align = index % totalPerImage;
              int x = align % imgXLen;
              int y = align ~/ imgYLen;
              final url = data.image[pageIndex];

              return ClipRRect(
                borderRadius: StyleString.mdRadius,
                child: VideoShotImage(
                  url: url,
                  x: x,
                  y: y,
                  imgXSize: imgXSize,
                  imgYSize: imgYSize,
                  height: height,
                  imageCache: plPlayerController.previewCache,
                  onSetSize: (xSize, ySize) => data
                    ..imgXSize = imgXSize = xSize
                    ..imgYSize = imgYSize = ySize,
                  isMounted: isMounted,
                ),
              );
            },
          ),
        );
      } catch (e) {
        if (kDebugMode) rethrow;
        return const SizedBox.shrink();
      }
    },
  );
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
  final cacheManager = DefaultCacheManager();
  final cacheKey = Utils.getFileName(url, fileExt: false);
  try {
    final fileInfo = await cacheManager.getSingleFile(
      ImageUtils.safeThumbnailUrl(url),
      key: cacheKey,
      headers: Constants.baseHeaders,
    );
    return _loadImg(fileInfo.path);
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
  const _DanmakuTip({
    this.offset = 0,
    super.child,
  });

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
    required double offset,
  }) : _offset = offset;

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
    required String position,
    required String duration,
  }) : _position = position,
       _duration = duration;

  String _duration;
  set duration(String value) {
    _duration = value;
    final paragraph = _buildParagraph(const Color(0xFFD0D0D0), _duration);
    if (paragraph.maxIntrinsicWidth != _cache?.maxIntrinsicWidth) {
      markNeedsLayout();
    }
    _cache?.dispose();
    _cache = paragraph;
    markNeedsSemanticsUpdate();
  }

  String _position;
  set position(String value) {
    _position = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  ui.Paragraph? _cache;

  ui.Paragraph _buildParagraph(Color color, String time) {
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
    config.label = 'position:$_position\nduration:$_duration';
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
