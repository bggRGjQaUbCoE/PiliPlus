// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_initializing_formals

import 'package:flutter/widgets.dart';

class SliverListExt extends SliverList {
  final bool reverse;

  SliverListExt.separated({
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
