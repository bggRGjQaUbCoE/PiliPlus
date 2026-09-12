import 'package:PiliPlus/utils/translate_service.dart';
import 'package:flutter/material.dart';

/// 标题翻译文本组件：
/// 未启用翻译时直接显示原文；启用后先显示原文再异步替换为译文。
class TranslateText extends StatelessWidget {
  const TranslateText(
    this.text, {
    super.key,
    this.maxLines,
    this.overflow,
    this.style,
    this.textAlign,
    this.enabled = true,
  });

  final String text;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final TextAlign? textAlign;

  /// 是否启用翻译（用于按场景门控）
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: TranslateService.version,
      builder: (context, _, _) => Text(
        TranslateService.display(text, enabled: enabled),
        maxLines: maxLines,
        overflow: overflow,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}