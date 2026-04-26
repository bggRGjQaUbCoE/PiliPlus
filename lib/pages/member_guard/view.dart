import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/member_guard/guard_top_list.dart';
import 'package:PiliPlus/pages/member_guard/controller.dart';
import 'package:PiliPlus/utils/extension/widget_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:get/get.dart';

class MemberGuard extends StatefulWidget {
  const MemberGuard({super.key});

  @override
  State<MemberGuard> createState() => _MemberGuardState();

  static Future<void>? toMemberGuard({
    required Object mid,
    required String name,
    required Object? count,
  }) {
    return Get.toNamed(
      '/memberGuard',
      arguments: {
        'ruid': mid,
        'name': name,
        'count': count,
      },
    );
  }
}

class _MemberGuardState extends State<MemberGuard> {
  late final String _userName;
  late final Object? _count;
  late final MemberGuardController _controller;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _userName = args['name'];
    _count = args['count'];
    _controller = Get.put(
      MemberGuardController(),
      tag: args['ruid'].toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('$_userName的舰队${_count == null ? '' : '($_count)'}'),
      ),
      body: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          slivers: [
            ViewSliverSafeArea(
              sliver: Obx(() => _buildBody(_controller.loadingState.value)),
            ),
          ],
        ),
      ).constraintWidth(),
    );
  }

  Widget _buildBody(LoadingState<List<GuardItem>?> state) {
    switch (state) {
      case Loading():
        return linearLoading;
      case Success<List<GuardItem>?>(:final response):
        return SliverMainAxisGroup(
          slivers: [
            _buildTopItems(),
            if (response!.isNotEmpty)
              SliverPadding(
                padding: const .only(top: 10),
                sliver: SliverList.separated(
                  itemCount: response.length,
                  itemBuilder: (context, index) {
                    if (index == response.length - 1) {
                      _controller.onLoadMore();
                    }

                    final item = response[index];
                    return ListTile(
                      safeArea: false,
                      visualDensity: .comfortable,
                      onTap: () => Get.toNamed('/member?mid=${item.uid}'),
                      leading: _avatar(item.face, 32, item.guardLevel),
                      title: Text(
                        item.username,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                ),
              ),
          ],
        );
      case Error(:final errMsg):
        return HttpError(errMsg: errMsg, onReload: _controller.onReload);
    }
  }

  Widget _buildTopItem(GuardItem item, double size) {
    final child = GestureDetector(
      behavior: .opaque,
      onTap: () => Get.toNamed('/member?mid=${item.uid}'),
      child: Padding(
        padding: const .symmetric(vertical: 10.0),
        child: Column(
          spacing: 5,
          mainAxisSize: .min,
          children: [
            SizedBox(
              height: 67.5, // 50 * 1.35
              child: Align(
                alignment: .bottomCenter,
                child: _avatar(item.face, size, item.guardLevel),
              ),
            ),
            Text(item.username, maxLines: 1, overflow: .ellipsis),
          ],
        ),
      ),
    );
    if (PlatformUtils.isDesktop) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: child,
      );
    }
    return child;
  }

  Widget _buildTopItems() {
    final Widget first;
    final Widget second;
    final Widget third;
    if (_controller.tops.firstOrNull case final item?) {
      first = _buildTopItem(item, 50);
    } else {
      first = const SizedBox.shrink();
    }
    if (_controller.tops.elementAtOrNull(1) case final item?) {
      second = _buildTopItem(item, 42);
    } else {
      second = const SizedBox.shrink();
    }
    if (_controller.tops.elementAtOrNull(2) case final item?) {
      third = _buildTopItem(item, 42);
    } else {
      third = const SizedBox.shrink();
    }
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(child: second),
          Expanded(child: first),
          Expanded(child: third),
        ],
      ),
    );
  }

  static String? _pendantUrl(int guardLevel) => switch (guardLevel) {
    1 =>
      'https://i0.hdslb.com/bfs/live/a454275dea465ac15a03f121f0d7edaf96e30bcf.png',
    2 =>
      'https://i0.hdslb.com/bfs/live/3b46129e796df42ec7356fcba77c8a79d47db682.png',
    3 =>
      'https://i0.hdslb.com/bfs/live/80f732943cc3367029df65e267960d56736a82ee.png',
    _ => null,
  };

  static Widget _avatar(String url, double size, int guardLevel) {
    final pendentSize = 1.35 * size;
    return Stack(
      clipBehavior: .none,
      alignment: .center,
      children: [
        NetworkImgLayer(
          src: url,
          width: size,
          height: size,
          type: .avatar,
        ),
        NetworkImgLayer(
          type: .emote,
          width: pendentSize,
          height: pendentSize,
          src: _pendantUrl(guardLevel),
          getPlaceHolder: () => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
