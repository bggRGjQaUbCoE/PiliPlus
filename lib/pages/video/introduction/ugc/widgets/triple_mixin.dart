import 'dart:async';
import 'dart:math' show pi;

import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

mixin TripleMixin on GetxController, TickerProvider {
  // 是否点赞
  final RxBool hasLike = false.obs;
  // 投币数量
  final RxNum coinNum = RxNum(0);
  // 是否投币
  bool get hasCoin => coinNum.value != 0;
  // 是否收藏
  final RxBool hasFav = false.obs;

  bool get hasTriple => hasLike.value && hasCoin && hasFav.value;

  void actionTriple();
  Future<void> actionLikeVideo();

  // no need for pugv
  AnimationController? _tripleAnimCtr;
  Animation<double>? _tripleAnimation;

  AnimationController get tripleAnimCtr =>
      _tripleAnimCtr ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
        reverseDuration: const Duration(milliseconds: 400),
      );

  Animation<double> get tripleAnimation => _tripleAnimation ??= Tween<double>(
    begin: 0,
    end: -2 * pi,
  ).animate(CurvedAnimation(parent: tripleAnimCtr, curve: Curves.easeInOut));

  Timer? _timer;

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  static final _duration = Utils.isMobile
      ? const Duration(milliseconds: 200)
      : const Duration(milliseconds: 255);

  void onStartTriple() {
    _timer ??= Timer(_duration, () {
      HapticFeedback.lightImpact();
      if (hasTriple) {
        SmartDialog.showToast('已完成三连');
      } else {
        tripleAnimCtr.forward().whenComplete(() {
          tripleAnimCtr.reset();
          actionTriple();
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
        actionLikeVideo();
      }
    }
  }

  @override
  void onClose() {
    _cancelTimer();
    _tripleAnimCtr?.dispose();
    super.onClose();
  }
}
