import 'package:flutter/rendering.dart' show RenderSliverToBoxAdapter;
import 'package:flutter/widgets.dart';

class SliverToBoxWithOffsetAdapter extends SliverToBoxAdapter {
  const SliverToBoxWithOffsetAdapter({
    super.key,
    required this.offset,
    required this.onVisibilityChanged,
    super.child,
  });

  final double offset;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  RenderSliverToBoxWithOffsetAdapter createRenderObject(BuildContext context) =>
      RenderSliverToBoxWithOffsetAdapter(
        offset: offset,
        onVisibilityChanged: onVisibilityChanged,
      );
}

class RenderSliverToBoxWithOffsetAdapter extends RenderSliverToBoxAdapter {
  RenderSliverToBoxWithOffsetAdapter({
    required this.offset,
    required this.onVisibilityChanged,
    super.child,
  });

  bool? _visible;
  final double offset;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  void performLayout() {
    final visible = constraints.scrollOffset > offset;
    if (_visible != visible) {
      _visible = visible;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onVisibilityChanged(visible),
      );
    }
    super.performLayout();
  }
}

class SliverToBoxWithVisibilityAdapter extends SliverToBoxAdapter {
  const SliverToBoxWithVisibilityAdapter({
    super.key,
    required this.onVisibilityChanged,
    super.child,
  });

  final ValueChanged<bool> onVisibilityChanged;

  @override
  RenderSliverToBoxWithVisibilityAdapter createRenderObject(
    BuildContext context,
  ) => RenderSliverToBoxWithVisibilityAdapter(
    onVisibilityChanged: onVisibilityChanged,
  );
}

class RenderSliverToBoxWithVisibilityAdapter extends RenderSliverToBoxAdapter {
  RenderSliverToBoxWithVisibilityAdapter({
    required this.onVisibilityChanged,
    super.child,
  });

  final ValueChanged<bool> onVisibilityChanged;

  bool? _visible;

  @override
  void performLayout() {
    super.performLayout();
    final visible = geometry!.visible;
    if (_visible != visible) {
      _visible = visible;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onVisibilityChanged(visible),
      );
    }
  }
}
