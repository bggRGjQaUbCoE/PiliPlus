import 'package:PiliPlus/common/widgets/more_text/paragraph_more.dart';
import 'package:flutter/material.dart';

class RichTextMore extends RichText {
  RichTextMore({
    super.key,
    required super.text,
    super.textAlign,
    super.textDirection,
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
    super.selectionRegistrar,
    super.selectionColor,
    required this.primary,
    this.onShowMore,
  });

  final Color primary;

  final VoidCallback? onShowMore;

  @override
  RenderParagraphMore createRenderObject(BuildContext context) {
    return RenderParagraphMore(
      text,
      textAlign: textAlign,
      textDirection: textDirection ?? Directionality.of(context),
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      locale: locale ?? Localizations.maybeLocaleOf(context),
      registrar: selectionRegistrar,
      selectionColor: selectionColor,
      primary: primary,
      onShowMore: onShowMore,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderParagraphMore renderObject,
  ) {
    renderObject
      ..setText((text: text, primary: primary))
      ..textAlign = textAlign
      ..textDirection = textDirection ?? Directionality.of(context)
      ..softWrap = softWrap
      ..overflow = overflow
      ..textScaler = textScaler
      ..maxLines = maxLines
      ..strutStyle = strutStyle
      ..textWidthBasis = textWidthBasis
      ..textHeightBehavior = textHeightBehavior
      ..locale = locale ?? Localizations.maybeLocaleOf(context)
      ..registrar = selectionRegistrar
      ..selectionColor = selectionColor
      ..onShowMore = onShowMore;
  }
}
