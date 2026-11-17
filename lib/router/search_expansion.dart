import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:material_ui/material_ui.dart';

enum SearchOpening { immediate }

final class SearchExpansion {
  SearchExpansion({
    required this.source,
    required this.viewport,
    required this.color,
    required this.prompt,
    required this.icon,
    required this.iconColor,
  });

  final RRect source;
  final Size viewport;
  final Color color;
  final ({InlineSpan span, Offset baseline, double width, TextScaler scaler})
  prompt;
  final Rect icon;
  final Color iconColor;

  final hintKey = GlobalKey();
  final fieldKey = GlobalKey();
  final submitIconKey = GlobalKey();
}

class SearchExpansionTransitionsBuilder extends PageTransitionsBuilder {
  const SearchExpansionTransitionsBuilder({this.immediate = false});

  final bool immediate;
  static const double _maxSigma = 4;

  @override
  Duration get transitionDuration =>
      immediate ? Duration.zero : const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => transitionDuration;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (immediate) return child;
    // GetX also calls this builder for the route underneath the search page.
    if (route.settings.arguments is! SearchExpansion) {
      if (MediaQuery.disableAnimationsOf(context)) return child;
      final blur = Pref.advancedMaterials && _maxSigma > 0;
      return AnimatedBuilder(
        animation: secondaryAnimation,
        child: child,
        builder: (context, child) {
          final t = secondaryAnimation.value;
          final active = t > 0 && t < 1;
          final progress = t * t * (3 - 2 * t);
          return Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                enabled: blur && active,
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: _maxSigma * progress,
                  sigmaY: _maxSigma * progress,
                  tileMode: ui.TileMode.clamp,
                ),
                child: child!,
              ),
              if (active)
                IgnorePointer(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: .08 * progress),
                  ),
                ),
            ],
          );
        },
      );
    }
    final expansion = route.settings.arguments as SearchExpansion;
    final surface = Theme.of(context).canvasColor;
    final viewport = route.navigator!.overlay!.context.findRenderObject()!;
    final direction = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        // The portrait source no longer exists if the viewport has rotated.
        if (constraints.biggest != expansion.viewport) {
          return FadeTransition(
            opacity: animation,
            child: ColoredBox(color: surface, child: child),
          );
        }
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final t = animation.value;
            final progress = Curves.easeInOutCubic.transform(t);
            final clipper = _SearchPanelClipper(expansion.source, t);
            return ClipRRect(
              clipper: clipper,
              child: ColoredBox(
                color: Color.lerp(expansion.color, surface, progress)!,
                child: IgnorePointer(
                  ignoring: !animation.isCompleted,
                  child: ExcludeSemantics(
                    excluding: !animation.isCompleted,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        child!,
                        if (!animation.isCompleted)
                          IgnorePointer(
                            child: CustomPaint(
                              painter: _SearchHeaderPainter(
                                expansion,
                                viewport,
                                direction,
                                t,
                                progress,
                                clipper,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SearchHeaderPainter extends CustomPainter {
  const _SearchHeaderPainter(
    this.expansion,
    this.viewport,
    this.direction,
    this.time,
    this.progress,
    this.clipper,
  );

  final SearchExpansion expansion;
  final RenderObject viewport;
  final TextDirection direction;
  final double time;
  final double progress;
  final _SearchPanelClipper clipper;

  @override
  void paint(Canvas canvas, Size size) {
    final source = expansion.prompt;
    final hint = expansion.hintKey.currentContext?.findRenderObject();
    final original = source.span.toPlainText();
    var baseline = source.baseline;
    var width = source.width;
    var span = source.span;
    if (hint is RenderParagraph && hint.hasSize) {
      final targetBaseline = hint.localToGlobal(
        Offset(
          0,
          hint.getDryBaseline(hint.constraints, TextBaseline.alphabetic)!,
        ),
        ancestor: viewport,
      );
      baseline = Offset.lerp(baseline, targetBaseline, progress)!;
      width += (hint.size.width - width) * progress;
      final fieldContext = expansion.fieldKey.currentContext!;
      final field = fieldContext.widget as TextField;
      final input = field.controller!.text;
      final destination = input.isEmpty ? hint.text.toPlainText() : input;
      final changed = original != destination;
      final showDestination = original.isEmpty || (changed && time >= .5);
      final targetStyle = showDestination && input.isNotEmpty
          ? hint.text.style!.copyWith(
              color: Theme.of(fieldContext).colorScheme.onSurface,
            )
          : hint.text.style;
      var style = TextStyle.lerp(span.style, targetStyle, progress)!;
      if (changed) {
        // An empty source gains the target prompt early. A typed query swaps
        // back to the home prompt at one shared baseline on the way out.
        final alpha = original.isEmpty
            ? const Interval(.03, .4).transform(time)
            : .28 + .72 * ((time - .5).abs() * 7).clamp(0.0, 1.0);
        style = style.copyWith(color: style.color!.withValues(alpha: alpha));
      }
      span = TextSpan(
        text: showDestination ? destination : original,
        style: style,
      );
    }
    final text = TextPainter(
      text: span,
      textDirection: direction,
      textScaler: source.scaler,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: width);
    text.paint(
      canvas,
      baseline -
          Offset(
            0,
            text.computeDistanceToActualBaseline(TextBaseline.alphabetic),
          ),
    );
    text.dispose();

    final iconContext = expansion.submitIconKey.currentContext;
    final iconBox = iconContext?.findRenderObject();
    var icon = expansion.icon;
    var color = expansion.iconColor;
    if (iconBox is RenderBox && iconBox.hasSize) {
      final travel = const Interval(
        .25,
        .9,
        curve: Curves.easeInOutCubic,
      ).transform(time);
      final dip =
          const Interval(.18, .34, curve: Curves.easeInOut).transform(time) *
          (1 - const Interval(.81, 1, curve: Curves.easeInOut).transform(time));
      icon = Rect.lerp(
        icon,
        iconBox.localToGlobal(Offset.zero, ancestor: viewport) & iconBox.size,
        travel,
      )!;
      final room = math.max(
        0.0,
        clipper.getClip(size).bottom - icon.bottom - 4,
      );
      icon = icon.shift(Offset(0, math.min(icon.height * dip, room)));
      color = Color.lerp(color, IconTheme.of(iconContext!).color, progress)!;
    }
    final handoff = const Interval(.62, .9).transform(time);
    void paintIcon(IconData glyph, double opacity) {
      if (opacity == 0) return;
      final text = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(glyph.codePoint),
          style: TextStyle(
            fontFamily: glyph.fontFamily,
            package: glyph.fontPackage,
            fontSize: icon.width,
            color: color.withValues(alpha: color.a * opacity),
            height: 1,
          ),
        ),
        textDirection: direction,
      )..layout();
      text.paint(canvas, icon.center - text.size.center(Offset.zero));
      text.dispose();
    }

    paintIcon(Icons.search_outlined, 1 - handoff);
    paintIcon(Icons.search, handoff);
  }

  @override
  bool shouldRepaint(_SearchHeaderPainter oldDelegate) =>
      time != oldDelegate.time || expansion != oldDelegate.expansion;
}

class _SearchPanelClipper extends CustomClipper<RRect> {
  const _SearchPanelClipper(this.source, this.time);

  final RRect source;
  final double time;

  @override
  RRect getClip(Size size) {
    if (time == 0) return source;
    const curve = Curves.easeInOutCubic;
    final center = const Interval(0, 70 / 300, curve: curve).transform(time);
    final width = const Interval(.12, .52, curve: curve).transform(time);
    final top = const Interval(.24, 1, curve: curve).transform(time);
    final bottom = const Interval(.15, 1, curve: curve).transform(time);
    // Equal side insets center the panel while keeping the entire source
    // covered, even when its original search bar is off-center.
    final rightInset = size.width - source.right;
    final centeredInset = math.min(source.left, rightInset);
    final left =
        ui.lerpDouble(source.left, centeredInset, center)! * (1 - width);
    final right =
        ui.lerpDouble(rightInset, centeredInset, center)! * (1 - width);
    final remainingRadius = 1 - curve.transform(time);
    return RRect.fromRectAndCorners(
      Rect.fromLTRB(
        left,
        source.top * (1 - top),
        size.width - right,
        ui.lerpDouble(source.bottom, size.height, bottom)!,
      ),
      topLeft: source.tlRadius * remainingRadius,
      topRight: source.trRadius * remainingRadius,
      bottomLeft: source.blRadius * remainingRadius,
      bottomRight: source.brRadius * remainingRadius,
    );
  }

  @override
  bool shouldReclip(_SearchPanelClipper oldClipper) =>
      source != oldClipper.source || time != oldClipper.time;
}
