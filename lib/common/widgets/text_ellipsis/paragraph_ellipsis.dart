import 'package:flutter/rendering.dart'
    show
        Offset,
        TextSpan,
        TextScaler,
        InlineSpan,
        TextPainter,
        PaintingContext,
        RenderParagraph,
        TextStyle;

const String _kEllipsis = '\u2026';

class RenderParagraphEllipsis extends RenderParagraph {
  RenderParagraphEllipsis(
    super.text, {
    super.textAlign,
    required super.textDirection,
    super.softWrap,
    super.overflow,
    // ignore: deprecated_member_use
    super.textScaleFactor,
    super.textScaler,
    super.maxLines,
    super.locale,
    super.strutStyle,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.children,
    super.selectionColor,
    super.registrar,
  });

  TextPainter? _ellipsisPainter;

  TextSpan _getTextSpan([TextStyle? style]) {
    return TextSpan(
      text: _kEllipsis,
      style: style ?? textPainter.text?.style,
    );
  }

  void _initEllipsisPainterIfNeeded() {
    if (_ellipsisPainter != null) return;
    _ellipsisPainter = TextPainter(
      text: _getTextSpan(),
      locale: locale,
      textScaler: textScaler,
      textDirection: textDirection,
    )..layout();
  }

  void _disposeEllipsis() {
    if (_ellipsisPainter != null) {
      _ellipsisPainter!.dispose();
      _ellipsisPainter = null;
    }
  }

  @override
  set textScaler(TextScaler value) {
    if (textPainter.textScaler == value) {
      return;
    }
    _ellipsisPainter
      ?..textScaler = value
      ..layout();
    super.textScaler = value;
  }

  @override
  set text(InlineSpan value) {
    if (_ellipsisPainter != null) {
      final text = _getTextSpan(value.style);
      switch (_ellipsisPainter!.text!.compareTo(text)) {
        case .paint:
          _ellipsisPainter!.text = text;
        case .layout:
          _ellipsisPainter!
            ..text = text
            ..layout();
        default:
      }
    }
    super.text = value;
  }

  @override
  void performLayout() {
    super.performLayout();
    if (textPainter.didExceedMaxLines &&
        textPainter.layoutCache?.lineMetrics.last.width == 0.0) {
      _initEllipsisPainterIfNeeded();
    } else {
      _disposeEllipsis();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (_ellipsisPainter != null) {
      _ellipsisPainter!.paint(
        context.canvas,
        offset + Offset(0, textPainter.height - _ellipsisPainter!.height),
      );
    }
  }

  @override
  void dispose() {
    _disposeEllipsis();
    super.dispose();
  }
}
