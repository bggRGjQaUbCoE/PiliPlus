// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart' hide PopScope;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

abstract class PopScopeState<T extends StatefulWidget> extends State<T>
    implements PopEntry<Object> {
  ModalRoute<dynamic>? _route;

  @override
  void onPopInvoked(bool didPop) {}

  @override
  late final ValueNotifier<bool> canPopNotifier;

  bool get initCanPop => true;

  @override
  void initState() {
    super.initState();
    canPopNotifier = ValueNotifier<bool>(initCanPop);
    _route = (Get.routing.route as ModalRoute)..registerPopEntry(this);
  }

  @override
  void dispose() {
    _route?.unregisterPopEntry(this);
    _route = null;
    canPopNotifier.dispose();
    super.dispose();
  }
}

// ignore: camel_case_types
typedef popScope = PopScope;

class PopScope extends StatefulWidget {
  const PopScope({
    super.key,
    required this.child,
    this.canPop = true,
    required this.onPopInvokedWithResult,
  });

  final Widget child;

  final PopInvokedWithResultCallback<Object> onPopInvokedWithResult;

  final bool canPop;

  @override
  State<PopScope> createState() => _PopScopeState();
}

class _PopScopeState<T extends PopScope> extends PopScopeState<T> {
  @override
  bool get initCanPop => widget.canPop;

  @override
  void onPopInvokedWithResult(bool didPop, Object? result) {
    widget.onPopInvokedWithResult(didPop, result);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    canPopNotifier.value = widget.canPop;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
