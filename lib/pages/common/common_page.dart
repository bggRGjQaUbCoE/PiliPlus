import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

abstract class CommonPageState<
  T extends StatefulWidget,
  R extends CommonController
>
    extends State<T> {
  R get controller;
  RxBool? showBottomBar;
  RxBool? showSearchBar;
  // late double _downScrollCount = 0.0; // 向下滚动计数器
  late double _upScrollCount = 0.0; // 向上滚动计数器
  double? _lastScrollPosition; // 记录上次滚动位置
  final _enableScrollThreshold = Pref.enableScrollThreshold;
  late final double _scrollThreshold = Pref.scrollThreshold; // 滚动阈值
  late final scrollController = controller.scrollController;

  @override
  void initState() {
    super.initState();
    try {
      showBottomBar = Get.find<MainController>().bottomBar;
      showSearchBar = Get.find<HomeController>().searchBar;
    } catch (_) {}
    if (_enableScrollThreshold &&
        (showBottomBar != null || showSearchBar != null)) {
      controller.scrollController.addListener(listener);
    }
  }

  Widget onBuild(Widget child) {
    if (!_enableScrollThreshold &&
        (showBottomBar != null || showSearchBar != null)) {
      return NotificationListener<UserScrollNotification>(
        onNotification: onNotification,
        child: child,
      );
    }
    return child;
  }

  bool onNotification(UserScrollNotification notification) {
    if (notification.metrics.axis == Axis.horizontal) return false;
    final direction = notification.direction;
    if (direction == ScrollDirection.forward) {
      showBottomBar?.value = true;
      showSearchBar?.value = true;
    } else if (direction == ScrollDirection.reverse) {
      showBottomBar?.value = false;
      showSearchBar?.value = false;
    }
    return false;
  }

  void listener() {
    final direction = scrollController.position.userScrollDirection;

    final double currentPosition = scrollController.position.pixels;

    // 初始化上次位置
    _lastScrollPosition ??= currentPosition;

    // 计算滚动距离
    final double scrollDelta = currentPosition - _lastScrollPosition!;

    if (direction == ScrollDirection.reverse) {
      showBottomBar?.value = false;
      showSearchBar?.value = false; // // 向下滚动，累加向下滚动距离，重置向上滚动计数器
      _upScrollCount = 0.0; // 重置向上滚动计数器
      // if (scrollDelta > 0) {
      //   _downScrollCount += scrollDelta;
      //   // _upScrollCount = 0.0; // 重置向上滚动计数器

      //   // 当累计向下滚动距离超过阈值时，隐藏顶底栏
      //   if (_downScrollCount >= _scrollThreshold) {
      //     mainStream?.add(false);
      //     searchBarStream?.add(false);
      //   }
      // }
    } else if (direction == ScrollDirection.forward) {
      // 向上滚动，累加向上滚动距离，重置向下滚动计数器
      if (scrollDelta < 0) {
        _upScrollCount += (-scrollDelta); // 使用绝对值
        // _downScrollCount = 0.0; // 重置向下滚动计数器

        // 当累计向上滚动距离超过阈值时，显示顶底栏
        if (_upScrollCount >= _scrollThreshold) {
          showBottomBar?.value = true;
          showSearchBar?.value = true;
        }
      }
    }

    // 更新上次位置
    _lastScrollPosition = currentPosition;
  }

  @override
  void dispose() {
    showSearchBar = null;
    showBottomBar = null;
    controller.scrollController.removeListener(listener);
    super.dispose();
  }
}
