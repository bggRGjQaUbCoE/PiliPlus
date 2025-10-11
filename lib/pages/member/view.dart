import 'package:PiliPlus/common/widgets/dialog/report_member.dart';
import 'package:PiliPlus/common/widgets/dynamic_sliver_appbar_medium.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space/data.dart';
import 'package:PiliPlus/pages/coin_log/controller.dart';
import 'package:PiliPlus/pages/exp_log/controller.dart';
import 'package:PiliPlus/pages/log_table/view.dart';
import 'package:PiliPlus/pages/login_devices/view.dart';
import 'package:PiliPlus/pages/login_log/controller.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member/widget/user_info_card.dart';
import 'package:PiliPlus/pages/member_cheese/view.dart';
import 'package:PiliPlus/pages/member_contribute/view.dart';
import 'package:PiliPlus/pages/member_dynamics/view.dart';
import 'package:PiliPlus/pages/member_favorite/view.dart';
import 'package:PiliPlus/pages/member_home/view.dart';
import 'package:PiliPlus/pages/member_pgc/view.dart';
import 'package:PiliPlus/pages/member_shop/view.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  late final int _mid;
  late final String _heroTag;
  late final MemberController _userController;

  @override
  void initState() {
    super.initState();
    _mid = int.tryParse(Get.parameters['mid']!) ?? -1;
    _heroTag = Utils.makeHeroTag(_mid);
    _userController = Get.put(
      MemberController(mid: _mid),
      tag: _heroTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final padding = MediaQuery.viewPaddingOf(context);
    return Material(
      color: theme.surface,
      child: Obx(
        () {
          if (_userController.loadingState.value.isSuccess) {
            return ExtendedNestedScrollView(
              key: _userController.key,
              onlyOneScrollInBody: true,
              pinnedHeaderSliverHeightBuilder: () =>
                  kToolbarHeight + MediaQuery.viewPaddingOf(context).top,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildUserInfo(theme, _userController.loadingState.value),
                ];
              },
              body: _userController.tab2?.isNotEmpty == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: padding.left,
                        right: padding.right,
                      ),
                      child: Column(
                        children: [
                          if ((_userController.tab2?.length ?? 0) > 1)
                            SizedBox(
                              height: 45,
                              child: TabBar(
                                controller: _userController.tabController,
                                tabs: _userController.tabs,
                                onTap: _userController.onTapTab,
                                dividerColor: theme.outline.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                          Expanded(child: _buildBody),
                        ],
                      ),
                    )
                  : const Center(child: Text('EMPTY')),
            );
          }
          return Center(
            child: _buildUserInfo(theme, _userController.loadingState.value),
          );
        },
      ),
    );
  }

  List<Widget> _actions(ColorScheme theme) => [
    IconButton(
      tooltip: '搜索',
      onPressed: () => Get.toNamed(
        '/memberSearch?mid=$_mid&uname=${_userController.username}',
      ),
      icon: const Icon(Icons.search_outlined),
    ),
    PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        if (_userController.accountService.isLogin.value &&
            _userController.accountService.mid != _mid) ...[
          PopupMenuItem(
            onTap: () => _userController.blockUser(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.block, size: 19),
                const SizedBox(width: 10),
                Text(
                  _userController.relation.value != 128 ? '加入黑名单' : '移除黑名单',
                ),
              ],
            ),
          ),
          if (_userController.isFollowed == 1)
            PopupMenuItem(
              onTap: _userController.onRemoveFan,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_circle_outline_outlined, size: 19),
                  SizedBox(width: 10),
                  Text('移除粉丝'),
                ],
              ),
            ),
        ],
        PopupMenuItem(
          onTap: _userController.shareUser,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.share_outlined, size: 19),
              const SizedBox(width: 10),
              Text(
                _userController.accountService.mid != _mid ? '分享UP主' : '分享我的主页',
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => Get.toNamed(
            '/upowerRank',
            parameters: {
              'mid': _userController.mid.toString(),
            },
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.electric_bolt, size: 19),
              SizedBox(width: 10),
              Text('充电排行榜'),
            ],
          ),
        ),
        if (_userController.accountService.isLogin.value)
          if (_userController.mid == _userController.accountService.mid) ...[
            if ((_userController
                        .loadingState
                        .value
                        .dataOrNull
                        ?.card
                        ?.vip
                        ?.status ??
                    0) >
                0)
              PopupMenuItem(
                onTap: _userController.vipExpAdd,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upcoming_outlined, size: 19),
                    SizedBox(width: 10),
                    Text('大会员经验'),
                  ],
                ),
              ),
            PopupMenuItem(
              onTap: () => Get.to(const LoginDevicesPage()),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.devices, size: 18),
                  SizedBox(width: 10),
                  Text('登录设备'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => Get.to(
                const LogPage(),
                arguments: LoginLogController(),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login, size: 18),
                  SizedBox(width: 10),
                  Text('登录记录'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => Get.to(
                const LogPage(),
                arguments: CoinLogController(),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FontAwesomeIcons.b, size: 16),
                  SizedBox(width: 10),
                  Text('硬币记录'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => Get.to(
                const LogPage(),
                arguments: ExpLogController(),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.linear_scale, size: 18),
                  SizedBox(width: 10),
                  Text('经验记录'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => Get.toNamed('/spaceSetting'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.settings_outlined, size: 19),
                  SizedBox(width: 10),
                  Text('空间设置'),
                ],
              ),
            ),
          ] else ...[
            const PopupMenuDivider(),
            PopupMenuItem(
              onTap: () => showMemberReportDialog(
                context,
                name: _userController.username,
                mid: _mid,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 19,
                    color: theme.error,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '举报',
                    style: TextStyle(color: theme.error),
                  ),
                ],
              ),
            ),
          ],
      ],
    ),
    const SizedBox(width: 4),
  ];

  Widget get _buildBody => tabBarView(
    controller: _userController.tabController,
    children: _userController.tab2!.map((item) {
      return switch (item.param!) {
        'home' => MemberHome(heroTag: _heroTag),
        'dynamic' => MemberDynamicsPage(mid: _mid),
        'contribute' => Obx(
          () => MemberContribute(
            heroTag: _heroTag,
            initialIndex: _userController.contributeInitialIndex.value,
            mid: _mid,
          ),
        ),
        'bangumi' => MemberBangumi(
          heroTag: _heroTag,
          mid: _mid,
        ),
        'favorite' => MemberFavorite(
          heroTag: _heroTag,
          mid: _mid,
        ),
        'cheese' => MemberCheese(
          heroTag: _heroTag,
          mid: _mid,
        ),
        'shop' => MemberShop(
          heroTag: _heroTag,
          mid: _mid,
        ),
        _ => Center(child: Text(item.title ?? '')),
      };
    }).toList(),
  );

  Widget _buildUserInfo(
    ColorScheme theme,
    LoadingState<SpaceData?> userState,
  ) {
    switch (userState) {
      case Loading():
        return const CircularProgressIndicator();
      case Success<SpaceData?>(:var response):
        if (response != null) {
          return DynamicSliverAppBarMedium(
            pinned: true,
            actions: _actions(theme),
            title: Text(_userController.username ?? ''),
            flexibleSpace: Obx(
              () => UserInfoCard(
                isOwner:
                    _userController.mid == _userController.accountService.mid,
                relation: _userController.relation.value,
                card: response.card!,
                images: response.images!,
                onFollow: () => _userController.onFollow(context),
                live: _userController.live,
                silence: _userController.silence,
              ),
            ),
          );
        }
        return SliverAppBar(
          pinned: true,
          actions: _actions(theme),
          title: GestureDetector(
            onTap: _userController.onReload,
            behavior: HitTestBehavior.opaque,
            child: Text(_userController.username ?? ''),
          ),
        );
      case Error(:var errMsg):
        return scrollErrorWidget(
          errMsg: errMsg,
          onReload: _userController.onReload,
        );
    }
  }
}
