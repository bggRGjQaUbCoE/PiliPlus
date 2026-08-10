import 'package:PiliPlus/common/widgets/flutter/text/text.dart';
import 'package:PiliPlus/common/widgets/text_more/rich_text_more.dart';
import 'package:flutter/material.dart';

class TextMore extends BaseText {
  const TextMore(
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
    required this.primary,
    this.onShowMore,
  });

  const TextMore.rich(
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
    required this.primary,
    this.onShowMore,
  }) : super.rich();

  final Color primary;

  final VoidCallback? onShowMore;

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
    return RichTextMore(
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
      primary: primary,
      onShowMore: onShowMore,
    );
  }
}
