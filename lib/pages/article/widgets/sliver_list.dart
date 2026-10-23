// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_initializing_formals

import 'package:PiliPlus/pages/article/widgets/sliver_to_box_adapter.dart'
    show ArticleRenderSliverMixin;
import 'package:flutter/rendering.dart' show RenderSliverList;
import 'package:flutter/widgets.dart';

class ArticleSliverList extends SliverList {
  const ArticleSliverList({
    super.key,
    required super.delegate,
    required this.isArticle,
  });

  final bool isArticle;

  ArticleSliverList.builder({
    super.key,
    required super.itemBuilder,
    super.findChildIndexCallback,
    super.itemCount,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.semanticIndexOffset,
    required this.isArticle,
  }) : super.builder();

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    if (isArticle) {
      return RenderArticleSliverList(childManager: element);
    }
    return RenderSliverList(childManager: element);
  }
}

class RenderArticleSliverList extends RenderSliverList
    with ArticleRenderSliverMixin {
  RenderArticleSliverList({required super.childManager});
}
