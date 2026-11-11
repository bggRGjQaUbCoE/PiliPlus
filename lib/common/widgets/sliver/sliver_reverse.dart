// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_initializing_formals

import 'package:flutter/widgets.dart';

class SliverListReverse extends SliverList {
  final bool reverse;

  SliverListReverse.builder({
    super.key,
    required NullableIndexedWidgetBuilder itemBuilder,
    super.findChildIndexCallback,
    required int super.itemCount,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.semanticIndexOffset,
    required this.reverse,
  }) : super.builder(
         itemBuilder: reverse
             ? (context, index) => itemBuilder(context, itemCount - index - 1)
             : itemBuilder,
       );

  SliverListReverse.separated({
    super.key,
    required NullableIndexedWidgetBuilder itemBuilder,
    super.findChildIndexCallback,
    super.findItemIndexCallback,
    required super.separatorBuilder,
    required int super.itemCount,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    required this.reverse,
  }) : super.separated(
         itemBuilder: reverse
             ? (context, index) => itemBuilder(context, itemCount - index - 1)
             : itemBuilder,
       );
}

class SliverGridReverse extends SliverGrid {
  final bool reverse;

  SliverGridReverse.builder({
    super.key,
    required super.gridDelegate,
    required NullableIndexedWidgetBuilder itemBuilder,
    super.findChildIndexCallback,
    required int super.itemCount,
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.semanticIndexOffset,
    required this.reverse,
  }) : super.builder(
         itemBuilder: reverse
             ? (context, index) => itemBuilder(context, itemCount - index - 1)
             : itemBuilder,
       );
}
