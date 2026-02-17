// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show File;
import 'dart:math' as math;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/gesture/image_horizontal_drag_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image_viewer/viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';

class Image extends StatefulWidget {
  const Image({
    super.key,
    required this.image,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.medium,
    required this.minScale,
    required this.maxScale,
    required this.containerSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.doubleTapGestureRecognizer,
    required this.horizontalDragGestureRecognizer,
    required this.onChangePage,
  });

  Image.network(
    String src, {
    super.key,
    double scale = 1.0,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    Map<String, String>? headers,
    int? cacheWidth,
    int? cacheHeight,
    WebHtmlElementStrategy webHtmlElementStrategy =
        WebHtmlElementStrategy.never,
    required this.minScale,
    required this.maxScale,
    required this.containerSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.doubleTapGestureRecognizer,
    required this.horizontalDragGestureRecognizer,
    required this.onChangePage,
  }) : image = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,
         NetworkImage(
           src,
           scale: scale,
           headers: headers,
           webHtmlElementStrategy: webHtmlElementStrategy,
         ),
       ),
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0);

  Image.file(
    File file, {
    super.key,
    double scale = 1.0,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
    required this.minScale,
    required this.maxScale,
    required this.containerSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.doubleTapGestureRecognizer,
    required this.horizontalDragGestureRecognizer,
    required this.onChangePage,
  }) : assert(
         !kIsWeb,
         'Image.file is not supported on Flutter Web. '
         'Consider using either Image.asset or Image.network instead.',
       ),
       image = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,
         FileImage(file, scale: scale),
       ),
       loadingBuilder = null,
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0);

  Image.asset(
    String name, {
    super.key,
    AssetBundle? bundle,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    double? scale,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    String? package,
    this.filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
    required this.minScale,
    required this.maxScale,
    required this.containerSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.doubleTapGestureRecognizer,
    required this.horizontalDragGestureRecognizer,
    required this.onChangePage,
  }) : image = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,
         scale != null
             ? ExactAssetImage(
                 name,
                 bundle: bundle,
                 scale: scale,
                 package: package,
               )
             : AssetImage(name, bundle: bundle, package: package),
       ),
       loadingBuilder = null,
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0);

  Image.memory(
    Uint8List bytes, {
    super.key,
    double scale = 1.0,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
    required this.minScale,
    required this.maxScale,
    required this.containerSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.doubleTapGestureRecognizer,
    required this.horizontalDragGestureRecognizer,
    required this.onChangePage,
  }) : image = ResizeImage.resizeIfNeeded(
         cacheWidth,
         cacheHeight,
         MemoryImage(bytes, scale: scale),
       ),
       loadingBuilder = null,
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0);

  final ImageProvider image;

  final ImageFrameBuilder? frameBuilder;

  final ImageLoadingBuilder? loadingBuilder;

  final ImageErrorWidgetBuilder? errorBuilder;

  final double? width;

  final double? height;

  final Color? color;

  final Animation<double>? opacity;

  final FilterQuality filterQuality;

  final BlendMode? colorBlendMode;

  final BoxFit? fit;

  final AlignmentGeometry alignment;

  final ImageRepeat repeat;

  final Rect? centerSlice;

  final bool matchTextDirection;

  final bool gaplessPlayback;

  final String? semanticLabel;

  final bool excludeFromSemantics;

  final bool isAntiAlias;

  final double minScale;
  final double maxScale;
  final Size containerSize;

  final ValueChanged<ScaleStartDetails>? onDragStart;
  final ValueChanged<ScaleUpdateDetails>? onDragUpdate;
  final ValueChanged<ScaleEndDetails>? onDragEnd;
  final ValueChanged<int>? onChangePage;

  final DoubleTapGestureRecognizer doubleTapGestureRecognizer;
  final ImageHorizontalDragGestureRecognizer horizontalDragGestureRecognizer;

  @override
  State<Image> createState() => _ImageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ImageProvider>('image', image))
      ..add(DiagnosticsProperty<Function>('frameBuilder', frameBuilder))
      ..add(
        DiagnosticsProperty<Function>('loadingBuilder', loadingBuilder),
      )
      ..add(DoubleProperty('width', width, defaultValue: null))
      ..add(DoubleProperty('height', height, defaultValue: null))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(
        DiagnosticsProperty<Animation<double>?>(
          'opacity',
          opacity,
          defaultValue: null,
        ),
      )
      ..add(
        EnumProperty<BlendMode>(
          'colorBlendMode',
          colorBlendMode,
          defaultValue: null,
        ),
      )
      ..add(EnumProperty<BoxFit>('fit', fit, defaultValue: null))
      ..add(
        DiagnosticsProperty<AlignmentGeometry>(
          'alignment',
          alignment,
          defaultValue: null,
        ),
      )
      ..add(
        EnumProperty<ImageRepeat>(
          'repeat',
          repeat,
          defaultValue: ImageRepeat.noRepeat,
        ),
      )
      ..add(
        DiagnosticsProperty<Rect>(
          'centerSlice',
          centerSlice,
          defaultValue: null,
        ),
      )
      ..add(
        FlagProperty(
          'matchTextDirection',
          value: matchTextDirection,
          ifTrue: 'match text direction',
        ),
      )
      ..add(
        StringProperty('semanticLabel', semanticLabel, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty<bool>(
          'this.excludeFromSemantics',
          excludeFromSemantics,
        ),
      )
      ..add(EnumProperty<FilterQuality>('filterQuality', filterQuality));
  }
}

class _ImageState extends State<Image> with WidgetsBindingObserver {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  ImageChunkEvent? _loadingProgress;
  bool _isListeningToStream = false;
  int? _frameNumber;
  bool _wasSynchronouslyLoaded = false;
  late DisposableBuildContext<State<Image>> _scrollAwareContext;
  Object? _lastException;
  StackTrace? _lastStack;
  ImageStreamCompleterHandle? _completerHandle;

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollAwareContext = DisposableBuildContext<State<Image>>(this);
  }

  @override
  void dispose() {
    assert(_imageStream != null);
    WidgetsBinding.instance.removeObserver(this);
    _stopListeningToStream();
    _completerHandle?.dispose();
    _scrollAwareContext.dispose();
    _replaceImage(info: null);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _resolveImage();

    _isPaused =
        !TickerMode.valuesOf(context).enabled ||
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false);

    if (_isPaused && _frameNumber != null) {
      _stopListeningToStream(keepStreamAlive: true);
    } else {
      _listenToStream();
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Image oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isListeningToStream &&
        (widget.loadingBuilder == null) != (oldWidget.loadingBuilder == null)) {
      final ImageStreamListener oldListener = _getListener();
      _imageStream!.addListener(_getListener(recreateListener: true));
      _imageStream!.removeListener(oldListener);
    }
    if (widget.image != oldWidget.image) {
      _resolveImage();
      _listenToStream();
    }
  }

  @override
  void reassemble() {
    _resolveImage();
    super.reassemble();
  }

  void _resolveImage() {
    final provider = ScrollAwareImageProvider<Object>(
      context: _scrollAwareContext,
      imageProvider: widget.image,
    );
    final ImageStream newStream = provider.resolve(
      createLocalImageConfiguration(
        context,
        size: widget.width != null && widget.height != null
            ? Size(widget.width!, widget.height!)
            : null,
      ),
    );
    _updateSourceStream(newStream);
  }

  ImageStreamListener? _imageStreamListener;
  ImageStreamListener _getListener({bool recreateListener = false}) {
    if (_imageStreamListener == null || recreateListener) {
      _lastException = null;
      _lastStack = null;
      _imageStreamListener = ImageStreamListener(
        _handleImageFrame,
        onChunk: widget.loadingBuilder == null ? null : _handleImageChunk,
        onError: widget.errorBuilder != null || kDebugMode
            ? (Object error, StackTrace? stackTrace) {
                setState(() {
                  _lastException = error;
                  _lastStack = stackTrace;
                });
                assert(() {
                  if (widget.errorBuilder == null) {
                    throw error;
                  }
                  return true;
                }());
              }
            : null,
      );
    }
    return _imageStreamListener!;
  }

  void _handleImageFrame(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _replaceImage(info: imageInfo);
      _loadingProgress = null;
      _lastException = null;
      _lastStack = null;
      _frameNumber = _frameNumber == null ? 0 : _frameNumber! + 1;
      _wasSynchronouslyLoaded = _wasSynchronouslyLoaded | synchronousCall;
    });
    if (_isPaused) {
      _stopListeningToStream(keepStreamAlive: true);
    }
  }

  void _handleImageChunk(ImageChunkEvent event) {
    assert(widget.loadingBuilder != null);
    setState(() {
      _loadingProgress = event;
      _lastException = null;
      _lastStack = null;
    });
  }

  void _replaceImage({required ImageInfo? info}) {
    final ImageInfo? oldImageInfo = _imageInfo;
    if (oldImageInfo != null) {
      SchedulerBinding.instance.addPostFrameCallback(
        (Duration duration) => oldImageInfo.dispose(),
        debugLabel: 'Image.disposeOldInfo',
      );
    }
    _imageInfo = info;
  }

  void _updateSourceStream(ImageStream newStream) {
    if (_imageStream?.key == newStream.key) {
      return;
    }

    if (_isListeningToStream) {
      _imageStream!.removeListener(_getListener());
    }

    if (!widget.gaplessPlayback) {
      setState(() {
        _replaceImage(info: null);
      });
    }

    setState(() {
      _loadingProgress = null;
      _frameNumber = null;
      _wasSynchronouslyLoaded = false;
    });

    _imageStream = newStream;
    if (_isListeningToStream) {
      _imageStream!.addListener(_getListener());
    }
  }

  void _listenToStream() {
    if (_isListeningToStream) {
      return;
    }

    _isListeningToStream = true;
    _imageStream!.addListener(_getListener());
    _completerHandle?.dispose();
    _completerHandle = null;
  }

  void _stopListeningToStream({bool keepStreamAlive = false}) {
    if (!_isListeningToStream) {
      return;
    }

    if (keepStreamAlive &&
        _completerHandle == null &&
        _imageStream?.completer != null) {
      _completerHandle = _imageStream!.completer!.keepAlive();
    }

    if (_imageStream!.completer != null && widget.errorBuilder != null) {
      _imageStream!.completer!.addEphemeralErrorListener(
        (
          Object exception,
          StackTrace? stackTrace,
        ) {},
      );
    }
    _imageStream!.removeListener(_getListener());
    _isListeningToStream = false;
  }

  // Widget _debugBuildErrorWidget(BuildContext context, Object error) {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: <Widget>[
  //       const Positioned.fill(child: Placeholder(color: Color(0xCF8D021F))),
  //       Padding(
  //         padding: const EdgeInsets.all(4.0),
  //         child: FittedBox(
  //           child: Text(
  //             '$error',
  //             textAlign: TextAlign.center,
  //             textDirection: TextDirection.ltr,
  //             style: const TextStyle(
  //               shadows: <Shadow>[Shadow(blurRadius: 1.0)],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (_lastException != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _lastException!, _lastStack);
      }
      // if (kDebugMode) {
      //   return _debugBuildErrorWidget(context, _lastException!);
      // }
    }

    final Size childSize;
    final bool isLongPic;
    double? minScale, maxScale;
    if (_imageInfo != null) {
      final imgWidth = _imageInfo!.image.width.toDouble();
      final imgHeight = _imageInfo!.image.height.toDouble();
      final imgRatio = imgHeight / imgWidth;
      isLongPic =
          imgRatio > StyleString.imgMaxRatio &&
          imgHeight > widget.containerSize.height;
      if (isLongPic) {
        final compatWidth = math.min(650.0, widget.containerSize.width);
        minScale = compatWidth / widget.containerSize.height * imgRatio;
        maxScale = math.max(widget.maxScale, minScale * 3);
      }
      childSize = Size(imgWidth, imgHeight);
    } else {
      childSize = .zero;
      isLongPic = false;
    }
    Widget result = Viewer(
      minScale: minScale ?? widget.minScale,
      maxScale: maxScale ?? widget.maxScale,
      isLongPic: isLongPic,
      containerSize: widget.containerSize,
      childSize: childSize,
      onDragStart: widget.onDragStart,
      onDragUpdate: widget.onDragUpdate,
      onDragEnd: widget.onDragEnd,
      doubleTapGestureRecognizer: widget.doubleTapGestureRecognizer,
      horizontalDragGestureRecognizer: widget.horizontalDragGestureRecognizer,
      onChangePage: widget.onChangePage,
      child: RawImage(image: _imageInfo?.image),
    );

    if (!widget.excludeFromSemantics) {
      result = Semantics(
        container: widget.semanticLabel != null,
        image: true,
        label: widget.semanticLabel ?? '',
        child: result,
      );
    }

    if (widget.frameBuilder != null) {
      result = widget.frameBuilder!(
        context,
        result,
        _frameNumber,
        _wasSynchronouslyLoaded,
      );
    }

    if (widget.loadingBuilder != null) {
      result = widget.loadingBuilder!(context, result, _loadingProgress);
    }

    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description
      ..add(DiagnosticsProperty<ImageStream>('stream', _imageStream))
      ..add(DiagnosticsProperty<ImageInfo>('pixels', _imageInfo))
      ..add(
        DiagnosticsProperty<ImageChunkEvent>(
          'loadingProgress',
          _loadingProgress,
        ),
      )
      ..add(DiagnosticsProperty<int>('frameNumber', _frameNumber))
      ..add(
        DiagnosticsProperty<bool>(
          'wasSynchronouslyLoaded',
          _wasSynchronouslyLoaded,
        ),
      );
  }
}
