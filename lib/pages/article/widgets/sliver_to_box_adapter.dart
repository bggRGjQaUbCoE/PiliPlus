import 'package:flutter/rendering.dart'
    show RenderSliverToBoxAdapter, RenderSliver;
import 'package:flutter/widgets.dart';

mixin ArticleRenderSliverMixin on RenderSliver {
  @override
  void performLayout() {
    super.performLayout();
    if (constraints.viewportMainAxisExtent > geometry!.scrollExtent) {
      geometry = geometry!.copyWith(
        scrollExtent: constraints.viewportMainAxisExtent,
        paintOrigin: constraints.overlap,
      );
    }
  }
}

class ArticleSliverToBoxAdapter extends SingleChildRenderObjectWidget {
  const ArticleSliverToBoxAdapter({super.key, super.child});

  @override
  RenderSliverToBoxAdapter createRenderObject(BuildContext context) =>
      RenderArticleSliverToBoxAdapter();
}

class RenderArticleSliverToBoxAdapter extends RenderSliverToBoxAdapter
    with ArticleRenderSliverMixin {
  RenderArticleSliverToBoxAdapter({super.child});
}
