import 'package:PiliPlus/common/widgets/advanced_materials.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart' show tabBarView;
import 'package:material_ui/material_ui.dart';

/// Reserve the toolbar inside the scroll extent so the list starts below it
/// and can subsequently paint behind it without changing its scroll offset.
class ToolbarScrollInset extends InheritedWidget {
  const ToolbarScrollInset({
    super.key,
    required this.extent,
    required this.onLeadingExtent,
    required super.child,
  });

  final double extent;
  final ValueChanged<double> onLeadingExtent;

  static ToolbarScrollInset? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ToolbarScrollInset>();

  @override
  bool updateShouldNotify(ToolbarScrollInset oldWidget) =>
      oldWidget.extent != extent ||
      oldWidget.onLeadingExtent != onLeadingExtent;
}

class ScrollUnderToolbar extends StatefulWidget {
  const ScrollUnderToolbar({
    super.key,
    required this.extent,
    required this.controller,
    required this.pages,
    required this.underlaps,
    required this.leadingSpaces,
    required this.toolbar,
    this.backdropGradient,
  });

  final double extent;
  final TabController controller;
  final List<Widget> pages;
  final Set<int> underlaps;
  final Map<int, double> leadingSpaces;
  final Widget toolbar;
  final LinearGradient? backdropGradient;

  @override
  State<ScrollUnderToolbar> createState() => _ScrollUnderToolbarState();
}

class _ScrollUnderToolbarState extends State<ScrollUnderToolbar> {
  final _offsets = <int, ValueNotifier<double>>{};

  final _leadingExtents = <int, double>{};
  final _reportLeading = <int, ValueChanged<double>>{};

  @override
  void dispose() {
    for (final offset in _offsets.values) {
      offset.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = theme.extension<SurfaceMaterialTheme>()?.enabled == true;
    final scheme = theme.colorScheme;
    final extent = widget.extent;
    final backing = scheme.surface;
    final tint = AdvancedMaterials.tint(scheme).withValues(
      alpha: AdvancedMaterials.toolbarOpacity(scheme.brightness),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        tabBarView(
          controller: widget.controller,
          children: [
            for (final (index, page) in widget.pages.indexed)
              _buildPage(index, page, enabled ? extent : 0),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: extent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  final index = widget.controller.index;
                  return ValueListenableBuilder(
                    valueListenable: _offsets.putIfAbsent(
                      index,
                      () => ValueNotifier(0.0),
                    ),
                    builder: (context, offset, _) {
                      final progress =
                          enabled &&
                              extent > 0 &&
                              widget.underlaps.contains(index)
                          ? (offset / extent).clamp(0.0, 1.0)
                          : 0.0;
                      if (progress == 0) return ColoredBox(color: backing);
                      final gradient = widget.backdropGradient;
                      return ClipRect(
                        child: BackdropFilter(
                          filter: AdvancedMaterials.blurAt(progress),
                          child: gradient == null
                              ? ColoredBox(
                                  color: Color.lerp(backing, tint, progress)!,
                                )
                              : DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: gradient.begin,
                                      end: gradient.end,
                                      stops: gradient.stops,
                                      colors: [
                                        for (final color in gradient.colors)
                                          Color.lerp(backing, color, progress)!,
                                      ],
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 0,
                                        color: scheme.outline.withValues(
                                          alpha: .16 * progress,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const SizedBox.expand(),
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
              Material(type: MaterialType.transparency, child: widget.toolbar),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPage(int index, Widget page, double extent) {
    final inset = widget.underlaps.contains(index) ? extent : 0.0;
    void report(ScrollMetrics metrics, int depth) {
      if (inset == 0 ||
          depth != 0 ||
          metrics.axisDirection != AxisDirection.down) {
        return;
      }
      final leading =
          (_leadingExtents[index] ?? 0) + (widget.leadingSpaces[index] ?? 0);
      final overlap = (metrics.extentBefore - leading).clamp(0.0, inset);
      final step = (16 * overlap / inset).ceil();
      _offsets.putIfAbsent(index, () => ValueNotifier(0.0)).value =
          step * inset / 16;
    }

    return Padding(
      padding: EdgeInsets.only(top: widget.extent - inset),
      child: ToolbarScrollInset(
        extent: inset,
        onLeadingExtent: _reportLeading.putIfAbsent(
          index,
          () =>
              (extent) => _leadingExtents[index] = extent,
        ),
        child: NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) {
            report(notification.metrics, notification.depth);
            return false;
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              report(notification.metrics, notification.depth);
              return false;
            },
            child: page,
          ),
        ),
      ),
    );
  }
}
