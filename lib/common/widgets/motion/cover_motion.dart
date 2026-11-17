import 'dart:ui' as ui;

import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:material_ui/material_ui.dart';

class CoverTransitionData {
  static const Curve motionCurve = Cubic(0.25, 0.1, 0.25, 1);

  const CoverTransitionData({
    required this.tag,
    required this.image,
    required this.radius,
    this.contentAspectRatio,
  });
  final Object tag;
  final ImageProvider image;
  final BorderRadius radius;
  final double? contentAspectRatio;

  static double? portraitAspectRatio(int? width, int? height) {
    if (width == null || height == null || width <= 0 || height <= width) {
      return null;
    }
    final fit = VideoFitType.values[Pref.cacheVideoFit];
    if (fit != VideoFitType.fill && fit != VideoFitType.contain) return null;
    return width / height;
  }

  Rect? contentRectFor(Size viewport, {Matrix4? transform}) {
    if (contentAspectRatio == null) return null;
    final viewportAspectRatio = viewport.width / viewport.height;
    final width = contentAspectRatio! < viewportAspectRatio
        ? contentAspectRatio! / viewportAspectRatio
        : 1.0;
    final height = contentAspectRatio! < viewportAspectRatio
        ? 1.0
        : viewportAspectRatio / contentAspectRatio!;
    final rect = Rect.fromLTRB(
      (1 - width) / 2,
      (1 - height) / 2,
      (1 + width) / 2,
      (1 + height) / 2,
    );
    if (transform == null) return rect;
    final transformed = MatrixUtils.transformRect(
      transform,
      Rect.fromLTRB(
        rect.left * viewport.width,
        rect.top * viewport.height,
        rect.right * viewport.width,
        rect.bottom * viewport.height,
      ),
    );
    return Rect.fromLTRB(
      transformed.left / viewport.width,
      transformed.top / viewport.height,
      transformed.right / viewport.width,
      transformed.bottom / viewport.height,
    );
  }

  static Widget flight(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext from,
    BuildContext to,
  ) {
    final source = (from.widget as Hero).child;
    final target = (to.widget as Hero).child;
    final visual = (target is CoverVisual ? target : source) as CoverVisual;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // Hero supplies the route animation (1 -> 0 on pop), not its
        // forward-running internal rectangle proxy.
        final p = animation.value;
        return CoverVisual(
          data: visual.data,
          radius: BorderRadius.lerp(visual.data.radius, BorderRadius.zero, p)!,
          targetContentRect: visual.targetContentRect,
          progress: p,
        );
      },
    );
  }
}

class CoverVisual extends StatelessWidget {
  const CoverVisual({
    super.key,
    required this.data,
    this.radius = BorderRadius.zero,
    this.targetContentRect,
    this.progress = 1,
  });
  final CoverTransitionData data;
  final BorderRadius radius;
  final Rect? targetContentRect;
  final double progress;

  Widget _image() => Image(
    image: data.image,
    fit: BoxFit.cover,
    gaplessPlayback: true,
  );

  @override
  Widget build(BuildContext context) {
    final contentRect = targetContentRect;
    return ClipRRect(
      borderRadius: radius,
      child: contentRect == null
          ? _image()
          : LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                final fullRect = Offset.zero & size;
                final targetRect = Rect.fromLTRB(
                  contentRect.left * size.width,
                  contentRect.top * size.height,
                  contentRect.right * size.width,
                  contentRect.bottom * size.height,
                );
                final imageRect = Rect.lerp(
                  fullRect,
                  targetRect,
                  progress,
                )!;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: Colors.black),
                    Positioned.fromRect(rect: imageRect, child: _image()),
                  ],
                );
              },
            ),
    );
  }
}

/// Keeps the Hero endpoint mounted for reverse flight, without intercepting taps.
class CoverHandoff extends StatefulWidget {
  const CoverHandoff({
    super.key,
    required this.data,
    this.viewport,
    this.transform,
    this.firstFrame,
    this.child,
  });
  final CoverTransitionData data;
  final Size? viewport;
  final ValueListenable<Matrix4>? transform;
  final Future<void>? firstFrame;
  final Widget? child;
  @override
  State<CoverHandoff> createState() => _CoverHandoffState();
}

class _CoverHandoffState extends State<CoverHandoff> {
  bool _frameReady = false;
  @override
  void initState() {
    super.initState();
    _observe();
  }

  void _observe() {
    final signal = widget.firstFrame;
    if (signal == null) return;
    signal.then((_) async {
      // Allow Flutter to present the texture after the SDK's native notification.
      await WidgetsBinding.instance.endOfFrame;
      if (mounted && signal == widget.firstFrame) {
        setState(() => _frameReady = true);
      }
    });
  }

  @override
  void didUpdateWidget(CoverHandoff oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstFrame != widget.firstFrame) {
      _frameReady = false;
      _observe();
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!;
    return AnimatedBuilder(
      animation: Listenable.merge([
        route.animation!,
        if (widget.transform != null) widget.transform!,
      ]),
      child: widget.child,
      builder: (context, player) => Stack(
        fit: StackFit.expand,
        children: [
          if (player != null)
            Offstage(
              // Keep decoding/layout alive without painting the fixed target
              // rectangle beneath the moving Hero. No texture fade or timer.
              offstage:
                  !MediaQuery.disableAnimationsOf(context) &&
                  route.animation!.status != AnimationStatus.completed,
              child: player,
            ),
          IgnorePointer(
            child: ExcludeSemantics(
              child: Opacity(
                opacity:
                    !_frameReady &&
                        (MediaQuery.disableAnimationsOf(context) ||
                            route.animation!.status ==
                                AnimationStatus.completed)
                    ? 1
                    : 0,
                child: HeroMode(
                  enabled: !MediaQuery.disableAnimationsOf(context),
                  child: Hero(
                    tag: widget.data.tag,
                    curve: CoverTransitionData.motionCurve,
                    reverseCurve: CoverTransitionData.motionCurve,
                    flightShuttleBuilder: CoverTransitionData.flight,
                    child: CoverVisual(
                      data: widget.data,
                      targetContentRect: widget.viewport == null
                          ? null
                          : widget.data.contentRectFor(
                              widget.viewport!,
                              transform: widget.transform?.value,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoverPageTransitionsBuilder extends PageTransitionsBuilder {
  const CoverPageTransitionsBuilder();
  @override
  Duration get transitionDuration => const Duration(milliseconds: 320);
  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 280);
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final hasCoverTransition =
        route.settings.arguments is Map &&
        (route.settings.arguments as Map)['coverTransition']
            is CoverTransitionData;
    final progress = animation.drive(
      CurveTween(curve: CoverTransitionData.motionCurve),
    );
    return AnimatedBuilder(
      animation: Listenable.merge([progress, secondaryAnimation]),
      child: child,
      builder: (context, page) {
        Widget result = page!;
        if (hasCoverTransition) {
          result = Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor.withValues(
                  alpha: progress.value,
                ),
              ),
              result,
            ],
          );
        }
        final t = secondaryAnimation.value;
        if (!hasCoverTransition || t > 0) {
          if (hasCoverTransition && t == 0) return result;
          final blurProgress = t * t * (3 - 2 * t);
          return Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                enabled: Pref.advancedMaterials && blurProgress > 0,
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: 6 * blurProgress,
                  sigmaY: 6 * blurProgress,
                  tileMode: ui.TileMode.clamp,
                ),
                child: result,
              ),
              IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: .12 * blurProgress),
                ),
              ),
            ],
          );
        }
        return result;
      },
    );
  }
}
