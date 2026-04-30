import 'package:flutter/material.dart';

class TVRow extends StatelessWidget {
  const TVRow({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 220,
    this.itemWidth = 200,
    this.titleStyle,
    this.onMorePressed,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double height;
  final double itemWidth;
  final TextStyle? titleStyle;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                title,
                style: titleStyle ??
                    theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (onMorePressed != null) ...[
                const Spacer(),
                TextButton(
                  onPressed: onMorePressed,
                  child: const Text('查看更多 >'),
                ),
              ],
            ],
          ),
        ),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
