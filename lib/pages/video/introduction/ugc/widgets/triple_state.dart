import 'dart:async';
import 'dart:math' show pi;

import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract class TripleState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  late final tripleAnimCtr = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 400),
  );

  late final tripleAnimation = Tween<double>(
    begin: 0,
    end: -2 * pi,
  ).animate(CurvedAnimation(parent: tripleAnimCtr, curve: Curves.easeInOut));

  CommonIntroController get introController;

  Timer? _timer;

  // @mustCallSuper
  // void tripleListener(AnimationStatus status) {
  //   if (status == AnimationStatus.completed) {
  //     tripleAnimCtr.reset();
  //     onTriple();
  //   }
  // }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    tripleAnimCtr.dispose();
    super.dispose();
  }

  void onStartTriple() {
    _timer ??= Timer(const Duration(milliseconds: 200), () {
      if (introController.hasTriple) {
        HapticFeedback.lightImpact();
        SmartDialog.showToast('已完成三连');
      } else {
        tripleAnimCtr.forward().whenComplete(() {
          tripleAnimCtr.reset();
          introController.actionTriple();
        });
      }
      _cancelTimer();
    });
  }

  void onCancelTriple([bool isTapUp = false]) {
    if (tripleAnimCtr.status == AnimationStatus.forward) {
      tripleAnimCtr.reverse();
    } else if (_timer != null && _timer!.tick == 0) {
      _cancelTimer();
      if (isTapUp) {
        feedBack();
        introController.actionLikeVideo();
      }
    }
  }
}

class TripleBuilder extends StatefulWidget {
  const TripleBuilder({
    super.key,
    required this.builder,
    required this.introController,
    // this.tripleListener,
  });
  final CommonIntroController introController;
  final Widget Function(
    BuildContext context,
    Animation<double> tripleAnimation,
    void Function() onStartTriple,
    void Function([bool]) onCancelTriple,
  )
  builder;
  // final AnimationStatusListener? tripleListener;

  @override
  State<TripleBuilder> createState() => _TripleBuilderState();
}

class _TripleBuilderState extends TripleState<TripleBuilder> {
  @override
  Widget build(BuildContext context) =>
      widget.builder(context, tripleAnimation, onStartTriple, onCancelTriple);

  @override
  late final CommonIntroController introController = widget.introController;

  // @override
  // void tripleListener(AnimationStatus status) {
  //   super.tripleListener(status);
  //   widget.tripleListener?.call(status);
  // }
}
