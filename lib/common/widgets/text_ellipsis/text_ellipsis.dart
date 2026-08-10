import 'package:PiliPlus/common/widgets/flutter/text/text.dart';
import 'package:PiliPlus/common/widgets/text_ellipsis/rich_text_ellipsis.dart';
import 'package:flutter/material.dart';

class TextEllipsis extends BaseText {
  const TextEllipsis(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.semanticsIdentifier,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  const TextEllipsis.rich(
    super.textSpan, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.semanticsIdentifier,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  }) : super.rich();

  @override
  Widget createRichText({
    required TextAlign textAlign,
    TextDirection? textDirection,
    Locale? locale,
    required bool softWrap,
    required TextOverflow overflow,
    required TextScaler textScaler,
    int? maxLines,
    StrutStyle? strutStyle,
    required TextWidthBasis textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    required Color selectionColor,
    required TextSpan text,
  }) {
    return RichTextEllipsis(
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      text: text,
    );
  }
}
