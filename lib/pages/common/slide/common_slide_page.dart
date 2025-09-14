import 'dart:math' show max;

import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/gestures.dart' show PositionedGestureDetails;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CommonSlidePage extends StatefulWidget {
  const CommonSlidePage({super.key, this.enableSlide = true});

  final bool enableSlide;
}

abstract class CommonSlidePageState<T extends CommonSlidePage> extends State<T>
    with TickerProviderStateMixin {
  Offset? downPos;
  bool? isSliding;
  late double maxWidth;
  late bool _isRTL = false;
  late final bool enableSlide;
  AnimationController? _animController;
  Animation<Offset>? _anim;

  static bool slideDismissReplyPage = Pref.slideDismissReplyPage;

  @override
  void initState() {
    super.initState();
    enableSlide = widget.enableSlide && slideDismissReplyPage;
    if (enableSlide) {
      _animController = AnimationController(
        vsync: this,
        reverseDuration: const Duration(milliseconds: 500),
      );
      _anim = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 1),
      ).animate(_animController!);
    }
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return enableSlide
        ? LayoutBuilder(
            builder: (context, constraints) {
              maxWidth = constraints.maxWidth;
              return SlideTransition(
                position: _anim!,
                child: buildPage(theme),
              );
            },
          )
        : buildPage(theme);
  }

  Widget buildPage(ThemeData theme);

  Widget buildList(ThemeData theme) => throw UnimplementedError();

  void onDismiss([_]) {
    if (isSliding == true) {
      final dx = downPos!.dx;
      if (_animController!.value * maxWidth + (_isRTL ? (maxWidth - dx) : dx) >=
          100) {
        Get.back();
      } else {
        _animController!.reverse();
      }
    }
    downPos = null;
    isSliding = null;
  }

  void onPan(PositionedGestureDetails details) {
    final localPosition = details.localPosition;
    if (isSliding == false) {
      return;
    } else if (isSliding == null) {
      if (downPos != null) {
        Offset cumulativeDelta = localPosition - downPos!;
        if (cumulativeDelta.dx.abs() >= cumulativeDelta.dy.abs()) {
          downPos = localPosition;
          isSliding = true;
        } else {
          isSliding = false;
        }
      } else {
        isSliding = false;
      }
    } else if (isSliding == true) {
      final from = downPos!.dx;
      final to = details.localPosition.dx;
      _animController!.value =
          max(0, _isRTL ? from - to : to - from) / maxWidth;
    }
  }

  void onPanDown(DragDownDetails details) {
    final dx = details.localPosition.dx;
    const offset = 30;
    final isLTR = dx <= offset;
    final isRTL = dx >= maxWidth - offset;
    if (isLTR || isRTL) {
      _isRTL = isRTL;
      downPos = details.localPosition;
    } else {
      isSliding = false;
    }
  }

  Widget slideList(ThemeData theme) => GestureDetector(
    onPanDown: onPanDown,
    onPanStart: onPan,
    onPanUpdate: onPan,
    onPanCancel: onDismiss,
    onPanEnd: onDismiss,
    child: buildList(theme),
  );
}
