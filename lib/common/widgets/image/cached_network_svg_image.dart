// code from cached_network_svg_image;

import 'dart:developer';

import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedNetworkSVGImage extends StatefulWidget {
  CachedNetworkSVGImage(
    this._url, {
    Key? key,
    this._cacheKey,
    this._placeholder,
    this._errorBuilder,
    this._width,
    this._height,
    this._headers,
    this._fit = BoxFit.contain,
    this._alignment = Alignment.center,
    this._matchTextDirection = false,
    this._allowDrawingOutsideViewBox = false,
    this._semanticsLabel,
    this._excludeFromSemantics = false,
    this._theme = const SvgTheme(),
    this._colorFilter,
    this._placeholderBuilder,
  }) : super(key: key ?? ValueKey(_cacheKey ?? _url));

  final String _url;
  final String? _cacheKey;
  final Widget? _placeholder;
  final WidgetBuilder? _errorBuilder;
  final double? _width;
  final double? _height;
  final Map<String, String>? _headers;
  final BoxFit _fit;
  final AlignmentGeometry _alignment;
  final bool _matchTextDirection;
  final bool _allowDrawingOutsideViewBox;
  final String? _semanticsLabel;
  final bool _excludeFromSemantics;
  final SvgTheme _theme;
  final ColorFilter? _colorFilter;
  final WidgetBuilder? _placeholderBuilder;

  @override
  State<CachedNetworkSVGImage> createState() => _CachedNetworkSVGImageState();

  static String _generateKeyFromUrl(String url) => url.split('?').first;
}

class _CachedNetworkSVGImageState extends State<CachedNetworkSVGImage> {
  bool _isLoading = false;
  bool _isError = false;
  String? _svgString;
  late final String _cacheKey;
  double? height;
  late TextScaler textScaler;

  static final _sizeRegExp = RegExp(r'height="([\d\.]+)([c-x]{2})?"');

  @override
  void initState() {
    super.initState();
    _cacheKey =
        widget._cacheKey ??
        CachedNetworkSVGImage._generateKeyFromUrl(widget._url);
    _loadImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textScaler = MediaQuery.textScalerOf(context);
  }

  Future<void> _loadImage() async {
    try {
      final file = await CacheManager.manager.getSingleFile(
        widget._url,
        key: _cacheKey,
        headers: widget._headers ?? const {},
      );
      final svg = await file.readAsString();
      _svgString = svg;
      if (widget._width == null && widget._height == null) {
        final match = _sizeRegExp.firstMatch(svg);
        if (match != null) {
          double h = double.parse(match.group(1)!);
          final suffix = match.group(2);
          if (suffix != null) {
            h *= switch (suffix) {
              'em' => textScaler.scale(widget._theme.fontSize),
              'ex' => textScaler.scale(widget._theme.xHeight),
              'pt' => 1.25,
              'pc' => 15.0,
              'mm' => 3.543307,
              'cm' => 35.43307,
              'in' => 90.0,
              _ => 1.0,
            };
          }
          height = h;
        }
      }

      _isLoading = false;

      _setState();
    } catch (e) {
      if (kDebugMode) log('CachedNetworkSVGImage: $e');

      _isError = true;
      _isLoading = false;

      _setState();
    }
  }

  void _setState() {
    if (mounted) {
      setState(() {});
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._width,
      height: widget._height,
      child: _buildImage(),
    );
  }

  Widget? _buildImage() {
    if (_isLoading) return _buildPlaceholderWidget();

    if (_isError) return _buildErrorWidget();

    return _buildSVGImage();
  }

  Widget _buildPlaceholderWidget() => Center(child: widget._placeholder);

  Widget _buildErrorWidget() =>
      Center(child: widget._errorBuilder?.call(context));

  Widget? _buildSVGImage() {
    if (_svgString == null) {
      return Center(child: widget._placeholderBuilder?.call(context));
    }

    return SvgPicture.string(
      _svgString!,
      fit: widget._fit,
      width: widget._width,
      height: widget._height ?? height,
      alignment: widget._alignment,
      matchTextDirection: widget._matchTextDirection,
      allowDrawingOutsideViewBox: widget._allowDrawingOutsideViewBox,
      semanticsLabel: widget._semanticsLabel,
      excludeFromSemantics: widget._excludeFromSemantics,
      colorFilter: widget._colorFilter,
      placeholderBuilder: widget._placeholderBuilder,
      theme: widget._theme,
    );
  }
}
