import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/keep_alive_wrapper.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/upower_rank/rank_info.dart';
import 'package:PiliPlus/pages/member_upower_rank/controller.dart';
import 'package:PiliPlus/utils/extension/widget_ext.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:get/get.dart';

class UpowerRankPage extends StatefulWidget {
  const UpowerRankPage({
    super.key,
    this.privilegeType,
  });

  final int? privilegeType;

  @override
  State<UpowerRankPage> createState() => _UpowerRankPageState();

  static Future<void>? toUpowerRank({
    required Object mid,
    required String name,
    required Object? count,
  }) {
    return Get.toNamed(
      '/upowerRank',
      arguments: {
        'mid': mid,
        'name': name,
        'count': count,
      },
    );
  }
}

class _UpowerRankPageState extends State<UpowerRankPage>
    with AutomaticKeepAliveClientMixin {
  String? _name;
  Object? _count;
  late final String _upMid;
  late final UpowerRankController _controller;

  @override
  void initState() {
    super.initState();
    final params = Get.arguments;
    _upMid = params['mid']!.toString();
    if (widget.privilegeType == null) {
      _name = params['name'];
      _count = params['count'];
    }
    _controller = Get.put(
      UpowerRankController(
        privilegeType: widget.privilegeType,
        upMid: _upMid,
      ),
      tag: '$_upMid${widget.privilegeType}',
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
              () => _buildBody(theme, _controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
    if (widget.privilegeType == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('$_name的充电排行榜${_count == null ? '' : '($_count)'}'),
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
                                              '$_upMid${tabs[index].privilegeType}',
                                        ).animateToTop();
                                      }
                                    } catch (_) {}
                                  }
                                },
                              ),
                              Expanded(
                                child: tabBarView(
                                  children: [
                                    KeepAliveWrapper(child: child),
                                    ...tabs
                                        .skip(1)
                                        .map(
                                          (e) => UpowerRankPage(
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
        ).constraintWidth(),
      );
    } else {
      return child;
    }
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<List<UpowerRankInfo>?> loadingState,
  ) {
    late final width = MediaQuery.textScalerOf(context).scale(32);
    return switch (loadingState) {
      Loading() => const SliverFillRemaining(child: m3eLoading),
      Success<List<UpowerRankInfo>?>(:final response) =>
        response != null && response.isNotEmpty
            ? SliverList.builder(
                itemCount: response.length,
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
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => widget.privilegeType != null;
}
