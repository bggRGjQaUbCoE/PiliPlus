import 'dart:async';

import 'package:PiliPlus/pages/video/pay_coins/view.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

mixin TripleMixin on GetxController, TickerProvider {
  final _likeGuard = AsyncKeyedOperationGuard<Object>();

  // 是否点赞
  final RxBool hasLike = false.obs;
  // 投币数量
  final RxNum coinNum = RxNum(0);
  // 是否投币
  bool get hasCoin => coinNum.value != 0;
  // 是否收藏
  final RxBool hasFav = false.obs;

  bool get hasTriple => hasLike.value && hasCoin && hasFav.value;

  bool get isLogin;

  bool isHasCopyright(int copyright) {
    return copyright != 2;
  }

  bool reachCoinLimit(bool hasCopyRight, num coinNum) {
    return (!hasCopyRight && coinNum >= 1) || coinNum >= 2;
  }

  int get copyright;

  void onPayCoin(int coin, bool coinWithLike);

  void actionCoinVideo() {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }

    final coinNum = this.coinNum.value;
    final copyright = this.copyright;
    final hasCopyright = isHasCopyright(copyright);
    if (reachCoinLimit(hasCopyright, coinNum)) {
      SmartDialog.showToast('达到投币上限啦~');
      return;
    }

    if (GlobalData().coins != null && GlobalData().coins! < 1) {
      SmartDialog.showToast('硬币不足');
      // return;
    }

    PayCoinsPage.toPayCoinsPage(
      onPayCoin: onPayCoin,
      hasCoin: coinNum == 1,
      hasCopyright: hasCopyright,
    );
  }

  Object get actionResourceKey;
  Future<void> actionTriple(Object resourceKey);
  Future<void> actionLikeVideo(Object resourceKey);

  // no need for pugv
  AnimationController? _tripleAnimCtr;
  Animation<double>? _tripleAnimation;

  AnimationController get tripleAnimCtr =>
      _tripleAnimCtr ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
        reverseDuration: const Duration(milliseconds: 400),
      );

  Animation<double> get tripleAnimation => _tripleAnimation ??= tripleAnimCtr
      .drive(CurveTween(curve: Curves.easeInOut));

  Timer? _timer;
  Object? _timerResourceKey;

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
    _timerResourceKey = null;
  }

  bool get isTripling => _tripleAnimCtr?.status == .forward;

  static final _duration = PlatformUtils.isMobile
      ? const Duration(milliseconds: 200)
      : const Duration(milliseconds: 255);

  void onStartTriple() {
    if (_timer != null) return;
    final resourceKey = actionResourceKey;
    _timerResourceKey = resourceKey;
    _timer = Timer(_duration, () {
      if (resourceKey != actionResourceKey) {
        _cancelTimer();
        return;
      }
      HapticFeedback.lightImpact();
      if (hasTriple) {
        SmartDialog.showToast('已完成三连');
      } else {
        tripleAnimCtr.forward().whenComplete(() {
          tripleAnimCtr.reset();
          _likeGuard.run(resourceKey, () => actionTriple(resourceKey)).ignore();
        });
      }
      _cancelTimer();
    });
  }

  void onCancelTriple([bool isTapUp = false]) {
    if (tripleAnimCtr.status == .forward) {
      tripleAnimCtr.reverse();
    } else if (_timer != null && _timer!.tick == 0) {
      final resourceKey = _timerResourceKey;
      _cancelTimer();
      if (isTapUp && resourceKey != null && resourceKey == actionResourceKey) {
        _likeGuard
            .run(resourceKey, () => actionLikeVideo(resourceKey))
            .ignore();
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
