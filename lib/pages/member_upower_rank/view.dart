import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/list_tile.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/upower_rank/rank_info.dart';
import 'package:PiliPlus/pages/member_upower_rank/controller.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:get/get.dart';

class UpowerRankPage extends StatefulWidget {
  const UpowerRankPage({super.key, this.upMid, this.tag, this.privilegeType});

  final String? upMid;
  final String? tag;
  final int? privilegeType;

  @override
  State<UpowerRankPage> createState() => _UpowerRankPageState();
}

class _UpowerRankPageState extends State<UpowerRankPage>
    with AutomaticKeepAliveClientMixin {
  late final _upMid = Get.parameters['mid']!;
  late final String _tag;
  late final UpowerRankController _controller;

  @override
  void initState() {
    super.initState();
    _tag = widget.privilegeType == null
        ? Utils.generateRandomString(8)
        : '${widget.tag}${widget.privilegeType}';
    _controller = Get.put(
      UpowerRankController(
        privilegeType: widget.privilegeType,
        upMid: widget.upMid ?? _upMid,
      ),
      tag: _tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    final child = refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        controller: _controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(bottom: padding.bottom + 100),
            sliver: Obx(
              () => _bilidBody(theme, _controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
    if (widget.privilegeType == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Obx(() {
            final name = _controller.name.value;
            return name == null
                ? const SizedBox.shrink()
                : Text(
                    '$name 充电排行榜${_controller.memberTotal == 0 ? '' : '(${_controller.memberTotal})'}',
                  );
          }),
          actions: [
            TextButton(
              onPressed: () => Get.toNamed(
                '/webview',
                parameters: {
                  'url':
                      'https://member.bilibili.com/mall/upower-pay?mid=$_upMid&oid=$_upMid',
                },
              ),
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: const Text('充电'),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 625),
              child: Obx(
                () {
                  final tabs = _controller.tabs.value;
                  return tabs != null
                      ? DefaultTabController(
                          length: tabs.length,
                          child: Builder(
                            builder: (context) {
                              return Column(
                                children: [
                                  TabBar(
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    tabs: tabs
                                        .map(
                                          (e) => Tab(
                                            text:
                                                '${e.name!}(${e.memberTotal ?? 0})',
                                          ),
                                        )
                                        .toList(),
                                    onTap: (index) {
                                      if (!DefaultTabController.of(
                                        context,
                                      ).indexIsChanging) {
                                        try {
                                          if (index == 0) {
                                            _controller.animateToTop();
                                          } else {
                                            Get.find<UpowerRankController>(
                                              tag:
                                                  '$_tag${tabs[index].privilegeType}',
                                            ).animateToTop();
                                          }
                                        } catch (_) {}
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: tabBarView(
                                      children: [
                                        KeepAliveWrapper(
                                          builder: (context) => child,
                                        ),
                                        ...tabs
                                            .sublist(1)
                                            .map(
                                              (e) => UpowerRankPage(
                                                upMid: _upMid,
                                                tag: _tag,
                                                privilegeType: e.privilegeType,
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : child;
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return child;
    }
  }

  Widget _bilidBody(
    ThemeData theme,
    LoadingState<List<UpowerRankInfo>?> loadingState,
  ) {
    late final width = MediaQuery.textScalerOf(context).scale(32);
    return switch (loadingState) {
      Loading() => const SliverToBoxAdapter(
        child: SizedBox(
          height: 125,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      Success<List<UpowerRankInfo>?>(:var response) =>
        response?.isNotEmpty == true
            ? SliverList.builder(
                itemCount: response!.length,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _controller.onLoadMore();
                  }
                  final item = response[index];
                  return Material(
                    type: MaterialType.transparency,
                    child: ListTile(
                      onTap: () => Get.toNamed('/member?mid=${item.mid}'),
                      leading: SizedBox(
                        width: width,
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: switch (index) {
                                0 => const Color(0xFFfdad13),
                                1 => const Color(0xFF8aace1),
                                2 => const Color(0xFFdfa777),
                                _ => theme.colorScheme.outline,
                              },
                            ),
                          ),
                        ),
                      ),
                      title: Row(
                        spacing: 12,
                        children: [
                          NetworkImgLayer(
                            width: 38,
                            height: 38,
                            src: item.avatar,
                            type: ImageType.avatar,
                          ),
                          Text(
                            item.nickname!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: item.day!.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: ' 天',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => widget.privilegeType != null;
}
