/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/advanced_materials.dart';
import 'package:PiliPlus/common/widgets/scroll_intent.dart';
import 'package:PiliPlus/common/widgets/scroll_under_toolbar.dart';

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/rendering.dart'
    show
        BackdropFilterLayer,
        ClipRectLayer,
        LayerHandle,
        RenderSliverSingleBoxAdapter,
        SliverGeometry;
import 'package:material_ui/material_ui.dart';

/// ref [SliverFloatingHeader]

class SliverFloatingHeaderWidget extends StatelessWidget {
  const SliverFloatingHeaderWidget({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.glassOnOverlap = false,
  });

  final Widget child;
  final Color backgroundColor;
  final bool glassOnOverlap;

  @override
  Widget build(BuildContext context) {
    final glass =
        Theme.of(context).extension<SurfaceMaterialTheme>()?.enabled ?? false;
    final scheme = ColorScheme.of(context);
    final toolbar = glassOnOverlap ? ToolbarScrollInset.of(context) : null;
    return _SliverFloatingHeaderWidget(
      toolbar: toolbar,
      backgroundColor: glass && !glassOnOverlap
          ? Colors.transparent
          : backgroundColor,
      glassTint: glass && glassOnOverlap
          ? AdvancedMaterials.tint(scheme).withValues(
              alpha: AdvancedMaterials.toolbarOpacity(scheme.brightness),
            )
          : null,
      child: _SliverFloatingHeaderScroll(
        child: glassOnOverlap
            ? Material(type: MaterialType.transparency, child: child)
            : SurfaceMaterial(
                kind: SurfaceMaterialKind.appBar,
                material: Material(
                  color: backgroundColor,
                  shape: const RoundedRectangleBorder(),
                  child: child,
                ),
              ),
      ),
    );
  }
}

class _SliverFloatingHeaderScroll extends StatefulWidget {
  const _SliverFloatingHeaderScroll({required this.child});

  final Widget child;

  @override
  State<_SliverFloatingHeaderScroll> createState() =>
      _SliverFloatingHeaderScrollState();
}

class _SliverFloatingHeaderScrollState
    extends State<_SliverFloatingHeaderScroll> {
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position != null) {
      _position!.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    _position = Scrollable.maybeOf(context)?.position;
    if (_position != null) {
      _position!.isScrollingNotifier.addListener(_isScrollingListener);
    }
  }

  @override
  void dispose() {
    if (_position != null) {
      _position!.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    super.dispose();
  }

  void _isScrollingListener() {
    assert(_position != null);
    if (_position!.isScrollingNotifier.value) {
      final RenderSliverFloatingHeader? renderer = context
          .findAncestorRenderObjectOfType<RenderSliverFloatingHeader>();
      renderer?.resetScrollIntent();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SliverFloatingHeaderWidget extends SingleChildRenderObjectWidget {
  const _SliverFloatingHeaderWidget({
    required Widget super.child,
    required this.backgroundColor,
    required this.glassTint,
    required this.toolbar,
  });

  final Color backgroundColor;
  final Color? glassTint;
  final ToolbarScrollInset? toolbar;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSliverFloatingHeader(
        backgroundColor: backgroundColor,
        glassTint: glassTint,
        toolbar: toolbar,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverFloatingHeader renderObject,
  ) {
    renderObject
      ..backgroundColor = backgroundColor
      ..glassTint = glassTint
      ..toolbar = toolbar;
  }
}

class RenderSliverFloatingHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverFloatingHeader({
    required this._backgroundColor,
    this._glassTint,
    this._toolbar,
  });

  Color? _glassTint;
  ToolbarScrollInset? _toolbar;
  double _visibleExtent = 0;
  double _overlap = 0;
  final _blurLayer = LayerHandle<BackdropFilterLayer>();

  set toolbar(ToolbarScrollInset? value) {
    if (_toolbar?.extent == value?.extent &&
        _toolbar?.onLeadingExtent == value?.onLeadingExtent) {
      return;
    }
    _toolbar = value;
    markNeedsLayout();
  }

  set glassTint(Color? value) {
    if (_glassTint == value) return;
    _glassTint = value;
    markNeedsCompositingBitsUpdate();
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => _glassTint != null;

  @override
  void dispose() {
    _blurLayer.layer = null;
    super.dispose();
  }

  Color _backgroundColor;
  set backgroundColor(Color value) {
    if (_backgroundColor == value) return;
    _backgroundColor = value;
    markNeedsPaint();
  }

  double? _childPosition;

  double? lastScrollOffset;

  late double effectiveScrollOffset;

  final _scrollIntent = ScrollVisibility();

  void resetScrollIntent() => _scrollIntent.reset();

  @override
  void performLayout() {
    final scrollOffset = constraints.scrollOffset;
    if (lastScrollOffset == null ||
        (scrollOffset >= lastScrollOffset! &&
            effectiveScrollOffset >= child!.size.height)) {
      effectiveScrollOffset = scrollOffset;
      _scrollIntent.reset();
    } else {
      double delta =
          lastScrollOffset! - scrollOffset; // > 0 when the header is growing
      final intent = _scrollIntent.updateDelta(-delta);
      if (intent == .forward) {
        final childExtent = child!.size.height;
        if (effectiveScrollOffset > childExtent) {
          effectiveScrollOffset = childExtent; // The header is now just above the start edge of viewport.
        }
      } else {
        // delta > 0 and scrolling forward is a contradiction. Assume that it's noise (set delta to 0).
        delta = intent == .reverse ? math.min(delta, 0) : 0;
      }
      effectiveScrollOffset = clampDouble(
        effectiveScrollOffset - delta,
        0.0,
        scrollOffset,
      );
    }

    child?.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final childExtent = child!.size.height;
    final toolbar = _toolbar;
    final inset = toolbar?.extent ?? 0.0;
    toolbar?.onLeadingExtent(childExtent);
    final remaining = constraints.remainingPaintExtent;
    final available = math.max(0.0, remaining - inset);
    final visible = childExtent - effectiveScrollOffset;
    _visibleExtent = clampDouble(visible, 0.0, available);
    _overlap =
        _visibleExtent -
        clampDouble(childExtent - scrollOffset, 0.0, available);
    final layoutExtent = clampDouble(
      inset + childExtent - scrollOffset,
      0.0,
      remaining,
    );
    geometry = SliverGeometry(
      paintOrigin: math.min(constraints.overlap, 0.0),
      scrollExtent: inset + childExtent,
      paintExtent: math.max(
        layoutExtent,
        _visibleExtent > 0 ? inset + _visibleExtent : 0.0,
      ),
      layoutExtent: layoutExtent,
      maxPaintExtent: inset + childExtent,
      hasVisualOverflow: false,
    );

    _childPosition = inset + math.min(0.0, visible - childExtent);
    lastScrollOffset = scrollOffset;
  }

  @override
  double childMainAxisPosition(covariant RenderObject child) {
    return _childPosition ?? 0;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && _visibleExtent > 0) {
      offset += Offset(0.0, childMainAxisPosition(child!));
      final size = child!.size;
      final tint = _glassTint;
      final rect = Rect.fromLTWH(
        0,
        (_toolbar?.extent ?? 0.0) - _childPosition!,
        size.width,
        _visibleExtent,
      );
      final progress = tint == null
          ? 0.0
          : (_overlap / size.height).clamp(0.0, 1.0);
      void paintHeader(PaintingContext context, Offset offset) {
        if (progress > 0) {
          final backdrop = (_blurLayer.layer ??= BackdropFilterLayer())
            ..filter = AdvancedMaterials.blurAt(progress);
          context.pushLayer(backdrop, (context, offset) {
            context.canvas.drawRect(
              rect.shift(offset),
              Paint()..color = Color.lerp(_backgroundColor, tint, progress)!,
            );
          }, offset);
        } else {
          _blurLayer.layer = null;
          context.canvas.drawRect(
            Rect.fromLTWH(
              offset.dx,
              offset.dy - 2,
              size.width,
              size.height + 2,
            ),
            Paint()..color = _backgroundColor,
          );
        }
        context.paintChild(child!, offset);
      }

      if (progress > 0 || (_toolbar?.extent ?? 0) > 0) {
        layer = context.pushClipRect(
          needsCompositing,
          offset,
          rect,
          paintHeader,
          oldLayer: layer as ClipRectLayer?,
        );
      } else {
        layer = null;
        paintHeader(context, offset);
      }
    } else {
      layer = null;
      _blurLayer.layer = null;
    }
  }

  @override
  bool hitTestSelf({
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) => _visibleExtent > 0 && mainAxisPosition >= (_toolbar?.extent ?? 0);
}
