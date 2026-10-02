import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

abstract final class Screenshot {
  static Future<ui.Image> screenshot(
    BuildContext context,
    Widget widget, {
    BoxConstraints constraints = const BoxConstraints(),
    double pixelRatio = 1,
    Future<void> Function()? future,
  }) async {
    widget = InheritedTheme.captureAll(
      context,
      MediaQuery(
        data: context.getInheritedWidgetOfExactType<MediaQuery>()!.data,
        child: TickerMode(enabled: false, child: widget),
      ),
    );

    final view = View.of(context);

    final renderView = RenderView(
      view: view,
      configuration: ViewConfiguration(
        logicalConstraints: constraints,
        devicePixelRatio: pixelRatio,
      ),
    );

    bool isDirty = true;
    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(
      onBuildScheduled: () => isDirty = true,
      focusManager: FocusManager(),
    );

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter(
      container: renderView,
      debugShortDescription: kDebugMode ? 'screenshot' : null,
      child: Directionality(
        textDirection: Directionality.maybeOf(context) ?? .ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    try {
      buildOwner
        ..buildScope(rootElement)
        ..finalizeTree();
      isDirty = false;

      if (kDebugMode) {
        await future?.call().timeout(const Duration(seconds: 10));
      } else {
        await future?.call();
      }

      if (isDirty) {
        buildOwner
          ..buildScope(rootElement)
          ..finalizeTree();
      }

      pipelineOwner
        ..flushLayout()
        ..flushCompositingBits()
        ..flushPaint();

      // ignore: invalid_use_of_protected_member
      final image = await (renderView.layer as OffsetLayer).toImage(
        renderView.paintBounds,
      );

      return image;
    } finally {
      pipelineOwner
        ..rootNode = null
        ..dispose();
      buildOwner.finalizeTree();
      renderView.dispose();
    }
  }
}
