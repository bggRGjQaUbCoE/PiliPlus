import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:flutter/material.dart';

class TVCard extends StatelessWidget {
  const TVCard({
    super.key,
    required this.title,
    this.subtitle,
    this.coverUrl,
    this.badge,
    this.onSelect,
    this.onLongPress,
    this.width = 200,
    this.height,
    this.isVertical = false,
    this.autoFocus = false,
  });

  final String title;
  final String? subtitle;
  final String? coverUrl;
  final String? badge;
  final VoidCallback? onSelect;
  final VoidCallback? onLongPress;
  final double width;
  final double? height;
  final bool isVertical;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverHeight = isVertical ? width * 1.4 : width * 9 / 16;
    final cardHeight = height ?? coverHeight + 60;

    return TVFocusWrapper(
      onSelect: onSelect,
      onLongPress: onLongPress,
      autoFocus: autoFocus,
      child: SizedBox(
        width: width,
        height: cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NetworkImgLayer(
                  src: coverUrl,
                  width: width,
                  height: coverHeight,
                ),
                if (badge != null)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
