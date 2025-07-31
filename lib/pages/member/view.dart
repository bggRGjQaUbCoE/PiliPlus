import 'package:PiliPlus/common/widgets/dialog/report_member.dart';
import 'package:PiliPlus/common/widgets/dynamic_sliver_appbar.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space/data.dart';
import 'package:PiliPlus/pages/coin_log/controller.dart';
import 'package:PiliPlus/pages/exp_log/controller.dart';
import 'package:PiliPlus/pages/log_table/view.dart';
import 'package:PiliPlus/pages/login_log/controller.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member/widget/user_info_card.dart';
import 'package:PiliPlus/pages/member_cheese/view.dart';
import 'package:PiliPlus/pages/member_contribute/view.dart';
import 'package:PiliPlus/pages/member_dynamics/view.dart';
import 'package:PiliPlus/pages/member_favorite/view.dart';
import 'package:PiliPlus/pages/member_home/view.dart';
import 'package:PiliPlus/pages/member_pgc/view.dart';
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
    _userController.scrollController.addListener(listener);
  }

  void listener() {
    if (_userController.scrollController.hasClients) {
      _userController.showUname.value =
          _userController.scrollController.offset >= _userController.offset;
    }
  }

  @override
  void dispose() {
    _userController.scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: IgnorePointer(
          child: Obx(
            () =>
                _userController.showUname.value &&
                    _userController.username != null
                ? Text(_userController.username!)
                : const SizedBox.shrink(),
          ),
        ),
        actions: [
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
                        _userController.relation.value != 128
                            ? '加入黑名单'
                            : '移除黑名单',
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
                onTap: () => _userController.shareUser(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.share_outlined, size: 19),
                    const SizedBox(width: 10),
                    Text(
                      _userController.accountService.mid != _mid
                          ? '分享UP主'
                          : '分享我的主页',
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
                if (_userController.mid ==
                    _userController.accountService.mid) ...[
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        clipBehavior: Clip.hardEdge,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        content: MemberReportPanel(
                          name: _userController.username,
                          mid: _mid,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 19,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '举报',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ],
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(
        () => _userController.loadingState.value.isSuccess
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return ExtendedNestedScrollView(
                    key: _userController.key,
                    controller: _userController.scrollController,
                    onlyOneScrollInBody: true,
                    pinnedHeaderSliverHeightBuilder: () {
                      return kToolbarHeight +
                          MediaQuery.paddingOf(this.context).top.toInt();
                    },
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        _buildAppBar(
                          isV: constraints.maxHeight > constraints.maxWidth,
                        ),
                      ];
                    },
                    body: _userController.tab2?.isNotEmpty == true
                        ? SafeArea(
                            top: false,
                            bottom: false,
                            child: Column(
                              children: [
                                if ((_userController.tab2?.length ?? 0) > 1)
                                  _buildTab(theme),
                                Expanded(child: _buildBody),
                              ],
                            ),
                          )
                        : const Center(child: Text('EMPTY')),
                  );
                },
              )
            : Center(
                child: _buildUserInfo(_userController.loadingState.value),
              ),
      ),
    );
  }

  Widget _buildTab(ThemeData theme) => Material(
    color: theme.colorScheme.surface,
    child: TabBar(
      controller: _userController.tabController,
      tabs: _userController.tabs,
      onTap: _userController.onTapTab,
    ),
  );

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
        _ => Center(child: Text(item.title ?? '')),
      };
    }).toList(),
  );

  Widget _buildAppBar({bool isV = true}) {
    final top = MediaQuery.paddingOf(context).top;
    return DynamicSliverAppBar(
      pinned: true,
      primary: false,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + top,
      flexibleSpace: _buildUserInfo(_userController.loadingState.value, isV),
      callback: (value) {
        _userController.offset = (value - 56 - top).toInt();
        listener();
      },
    );
  }

  Widget _buildUserInfo(LoadingState<SpaceData?> userState, [bool isV = true]) {
    return switch (userState) {
      Loading() => const CircularProgressIndicator(),
      Success(:var response) =>
        response != null
            ? Obx(
                () => UserInfoCard(
                  isV: isV,
                  isOwner:
                      _userController.mid == _userController.accountService.mid,
                  relation: _userController.relation.value,
                  card: response.card!,
                  images: response.images!,
                  onFollow: () => _userController.onFollow(context),
                  live: _userController.live,
                  silence: _userController.silence,
                ),
              )
            : GestureDetector(
                onTap: _userController.onReload,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox(height: 56, width: double.infinity),
              ),
      Error(:var errMsg) => scrollErrorWidget(
        errMsg: errMsg,
        onReload: _userController.onReload,
      ),
    };
  }
}
