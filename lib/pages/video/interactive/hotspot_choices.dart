import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/skin.dart';
import 'package:flutter/material.dart';

/// 坐标热点模式（question.type == 2）的选项浮层。
///
/// 坐标：接口 [Choice.x]/[Choice.y] 为「原始视频像素」坐标，其中 y 以视频
/// **底边**为原点（自下而上），与网页端一致；x 以左边为原点。
///
/// 外观：对齐网页端的「无底板、无边框透明白字」，颜色取自服务端
/// [Skin.titleTextColor]/[Skin.titleShadowColor]，不再用深色盒子遮挡画面。
class InteractiveHotspotChoices extends StatelessWidget {
  const InteractiveHotspotChoices({
    super.key,
    required this.choices,
    required this.videoRect,
    required this.sourceSize,
    required this.onSelected,
    required this.fallback,
    this.skin,
  });

  final List<Choice> choices;
  final Rect videoRect;
  final Size sourceSize;
  final ValueChanged<Choice> onSelected;
  final Widget fallback;

  /// 当前模块的服务端外观（`data.edges.skin`），可为空。
  final Skin? skin;

  /// 命中区域最小值，保证触屏可点；因为无底板，不会遮挡画面。
  static const double _minHitWidth = 40;
  static const double _minHitHeight = 28;

  static const EdgeInsets _hitPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 4,
  );

  @override
  Widget build(BuildContext context) {
    if (videoRect.isEmpty ||
        sourceSize.isEmpty ||
        !videoRect.isFinite ||
        !sourceSize.width.isFinite ||
        !sourceSize.height.isFinite ||
        choices.any(
          (choice) =>
              choice.x == null ||
              choice.y == null ||
              !choice.x!.isFinite ||
              !choice.y!.isFinite ||
              choice.x! < 0 ||
              choice.x! > sourceSize.width ||
              choice.y! < 0 ||
              choice.y! > sourceSize.height,
        )) {
      // Never stack choices at a fabricated shared coordinate.
      return fallback;
    }

    final Color textColor = _visibleColor(skin?.titleTextColor) ?? Colors.white;
    final Color? shadowColor = _visibleColor(skin?.titleShadowColor);
    // 与 DefaultTextStyle 合并，保证「测量」和「渲染」使用同一字体族，
    // 否则中文会在测量后换行或被省略。
    final TextStyle style = DefaultTextStyle.of(context).style.merge(
      TextStyle(
        color: textColor,
        fontSize: 15,
        height: 1.25,
        shadows: shadowColor == null
            ? null
            : <Shadow>[
                Shadow(
                  color: shadowColor,
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
      ),
    );

    final double maxTextWidth = (videoRect.width * 0.45)
        .clamp(140.0, 420.0)
        .clamp(0.0, videoRect.width);
    final double minHitWidth = videoRect.width < _minHitWidth
        ? videoRect.width
        : _minHitWidth;
    final double minHitHeight = videoRect.height < _minHitHeight
        ? videoRect.height
        : _minHitHeight;
    final layouts =
        <({Choice choice, String text, Rect rect, TextAlign align})>[];

    for (final choice in choices) {
      final String text = choice.option ?? choice.title ?? '选项';
      final TextPainter painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 2,
        ellipsis: '...',
      )..layout(maxWidth: maxTextWidth);
      final double width = (painter.width + _hitPadding.horizontal).clamp(
        minHitWidth,
        videoRect.width,
      );
      final double height = (painter.height + _hitPadding.vertical).clamp(
        minHitHeight,
        videoRect.height,
      );
      painter.dispose();

      final double anchorX =
          videoRect.left + choice.x! / sourceSize.width * videoRect.width;
      // 接口 y 以视频底边为原点：y = 0 对应画面底部，y = 视频高度对应顶部。
      final double anchorY =
          videoRect.bottom - choice.y! / sourceSize.height * videoRect.height;

      final int textAlign = choice.textAlign ?? 2;
      final double anchorLeft = switch (textAlign) {
        1 => anchorX,
        3 => anchorX - width,
        _ => anchorX - width / 2,
      };
      final double left = anchorLeft.clamp(
        videoRect.left,
        videoRect.right - width,
      );
      final double top = (anchorY - height / 2).clamp(
        videoRect.top,
        videoRect.bottom - height,
      );
      layouts.add((
        choice: choice,
        text: text,
        rect: Rect.fromLTWH(left, top, width, height),
        align: switch (textAlign) {
          1 => TextAlign.left,
          3 => TextAlign.right,
          _ => TextAlign.center,
        },
      ));
    }

    for (int i = 0; i < layouts.length; i++) {
      for (int j = i + 1; j < layouts.length; j++) {
        if (layouts[i].rect.overlaps(layouts[j].rect)) {
          // Preserve every choice as a usable target instead of letting the
          // last painted label intercept the earlier choices.
          return fallback;
        }
      }
    }

    return Stack(
      children: layouts.map((layout) {
        return Positioned.fromRect(
          rect: layout.rect,
          child: Tooltip(
            message: layout.text,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => onSelected(layout.choice),
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                child: Padding(
                  padding: _hitPadding,
                  child: Align(
                    alignment: switch (layout.align) {
                      TextAlign.left => Alignment.centerLeft,
                      TextAlign.right => Alignment.centerRight,
                      _ => Alignment.center,
                    },
                    child: Text(
                      layout.text,
                      textAlign: layout.align,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: style,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 解析服务端颜色；未配置或全透明（alpha = 0）时返回 null。
  static Color? _visibleColor(String? hex) {
    final int? value = Skin.argbToValue(hex);
    if (value == null || (value >> 24) & 0xFF == 0) {
      return null;
    }
    return Color(value);
  }
}
