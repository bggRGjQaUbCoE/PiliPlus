import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HttpError extends StatelessWidget {
  const HttpError({
    super.key,
    this.isSliver = true,
    this.errMsg,
    this.onReload,
    this.btnText,
    this.safeArea = true,
  });

  final bool isSliver;
  final String? errMsg;
  final VoidCallback? onReload;
  final String? btnText;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        SvgPicture.asset(
          "assets/images/error.svg",
          height: 200,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: SelectableText(
            errMsg ?? '没有数据',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
            scrollPhysics: const NeverScrollableScrollPhysics(),
          ),
        ),
        if (onReload != null)
          FilledButton.tonal(
            onPressed: onReload,
            style: FilledButton.styleFrom(
              tapTargetSize: .padded,
              backgroundColor: theme.colorScheme.primary.withAlpha(20),
              shadowColor: Colors.transparent,
            ),
            child: Text(
              btnText ?? '点击重试',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        if (safeArea)
          SizedBox(height: 40 + MediaQuery.viewPaddingOf(context).bottom),
      ],
    );

    return isSliver
        ? SliverToBoxAdapter(child: child)
        : SizedBox(width: double.infinity, child: child);
  }
}
