import 'dart:async' show unawaited;

import 'package:PiliPlus/common/widgets/scroll_physics.dart' show dynPageView;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics_up/feed_controller.dart';
import 'package:PiliPlus/pages/dynamics_up/feed_view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// 「逐个浏览 UP」：横向分页，每页一位 UP 的动态流
///
/// 对应 issue #3434 的诉求：不想来回点进点出主页，横划一下到下一位关注 UP。
class DynUpPageView extends StatefulWidget {
  const DynUpPageView({super.key});

  @override
  State<DynUpPageView> createState() => _DynUpPageViewState();
}

class _DynUpPageViewState extends State<DynUpPageView>
    with AutomaticKeepAliveClientMixin {
  final dynamicsController = Get.find<DynamicsController>();
  late final sensitivity = Pref.dynSwipeSensitivity;
  late final PageController pageController;

  /// 当前参与分页的 UP：第 0 项固定是「全部动态」
  List<int> mids = const [-1];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _indexOf(dynamicsController.currentMid));
    _register();
    syncUpList();
  }

  @override
  void dispose() {
    // 同一时刻只存在一个分页容器，直接清空钩子；
    // 不要用 identical() 比较方法 tear-off，那个比较不可靠。
    dynamicsController
      ..upPageSync = null
      ..upPageJump = null
      ..upPageRefresh = null
      ..upPageScrollToTop = null
      ..upPageToTopOrRefresh = null;
    pageController.dispose();
    super.dispose();
  }

  /// 把自身注册到动态控制器，供 UP 面板联动与刷新
  void _register() {
    dynamicsController
      ..upPageSync = syncUpList
      ..upPageJump = jumpToMid
      ..upPageRefresh = refreshCurrent
      ..upPageScrollToTop = toTop
      ..upPageToTopOrRefresh = toTopOrRefresh;
  }

  /// 当前可见页对应的动态流
  DynUpFeedController? get _currentFeed {
    try {
      final mid = mids.elementAtOrNull(_currentIndex);
      if (mid == null) return null;
      return Get.find<DynUpFeedController>(tag: 'dynUpFeed$mid');
    } catch (_) {
      return null;
    }
  }

  /// 下拉刷新：先刷新 UP 列表（更新未读红点），再刷新当前 UP 的动态
  Future<void> refreshCurrent() async {
    await dynamicsController.singleRefresh();
    await _currentFeed?.onRefresh();
  }

  void toTop() => _currentFeed?.animateToTop();

  /// 横滑换 UP 后，把头像栏滚到该 UP 附近，保证高亮可见
  void _scrollUpBarTo(int? mid) {
    if (mid == null) return;
    final index = mids.indexOf(mid);
    if (index < 0) return;
    final sc = dynamicsController.scrollController;
    if (!sc.hasClients) return;
    // 头像条目宽 70，留出左侧边距
    final target = ((index - 1) * 70.0).clamp(0.0, sc.position.maxScrollExtent);
    if ((sc.offset - target).abs() < 40) return;
    unawaited(
      sc.animateTo(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void toTopOrRefresh() => _currentFeed?.toTopOrRefresh();

  int _indexOf(int mid, [List<int>? list]) {
    final index = (list ?? mids).indexOf(mid);
    return index == -1 ? 0 : index;
  }

  int get _currentIndex {
    final page = pageController.hasClients ? pageController.page : null;
    return (page ?? pageController.initialPage.toDouble()).round();
  }

  /// 关注 UP 列表更新后重建分页，并尽量停在原来那位 UP 上
  void syncUpList() {
    if (!mounted) return;
    final upList = dynamicsController.loadingState.value.dataOrNull?.upList;
    final seen = <int>{-1};
    final newMids = <int>[
      -1,
      if (Accounts.main.isLogin) Accounts.main.mid,
      if (upList != null)
        for (final item in upList)
          if (item is! LiveUserItem && seen.add(item.mid)) item.mid,
    ];
    if (newMids.length == mids.length) {
      var same = true;
      for (int i = 0; i < mids.length; i++) {
        if (mids[i] != newMids[i]) {
          same = false;
          break;
        }
      }
      if (same) return;
    }

    final anchor = mids.elementAtOrNull(_currentIndex);
    final target = _indexOf(anchor ?? -1, newMids);
    final hadClients = pageController.hasClients;
    setState(() {
      mids = newMids;
    });
    if (hadClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !pageController.hasClients) return;
        final current = _currentIndex;
        if (current != target && target < mids.length) {
          pageController.jumpToPage(target);
        }
      });
    }
  }

  /// 点击 UP 面板头像时跳到对应分页
  void jumpToMid(int mid) {
    if (!mounted) return;
    final target = _indexOf(mid);
    if (!pageController.hasClients) return;
    if (_currentIndex == target) return;
    if ((target - _currentIndex).abs() > 3) {
      pageController.jumpToPage(target);
    } else {
      pageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      // UP 列表刚加载完成时同步一次分页数据
      if (dynamicsController.loadingState.value is Success) {
        WidgetsBinding.instance.addPostFrameCallback((_) => syncUpList());
      }
      return dynPageView(
        controller: pageController,
        sensitivity: sensitivity,
        itemCount: mids.length,
        itemBuilder: (context, index) {
          final mid = mids[index];
          return DynUpFeedPage(key: ValueKey(mid), mid: mid);
        },
        onPageChanged: (index) {
          feedBack();
          final mid = mids.elementAtOrNull(index);
          if (mid != null) dynamicsController.onSwipeToUp(mid);
          _scrollUpBarTo(mid);
        },
      );
    });
  }
}
