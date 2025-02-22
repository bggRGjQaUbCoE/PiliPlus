import 'dart:math';

import 'package:PiliPlus/common/widgets/dynamic_sliver_appbar.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/member/new/content/member_contribute/content/bangumi/member_bangumi.dart';
import 'package:PiliPlus/pages/member/new/content/member_contribute/content/favorite/member_favorite.dart';
import 'package:PiliPlus/pages/member/new/content/member_contribute/member_contribute.dart';
import 'package:PiliPlus/pages/member/new/content/member_home/member_home.dart';
import 'package:PiliPlus/pages/member/new/controller.dart';
import 'package:PiliPlus/pages/member/new/widget/user_info_card.dart';
import 'package:PiliPlus/pages/member/view.dart';
import 'package:PiliPlus/pages/member_dynamics/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/spring_physics.dart';

class MemberPageNew extends StatefulWidget {
  const MemberPageNew({super.key});

  @override
  State<MemberPageNew> createState() => _MemberPageNewState();
}

class _MemberPageNewState extends State<MemberPageNew>
    with TickerProviderStateMixin {
  late final int _mid;
  late final String _heroTag;
  late final MemberControllerNew _userController;
  final _key = GlobalKey<ExtendedNestedScrollViewState>();

  @override
  void initState() {
    super.initState();
    _mid = int.tryParse(Get.parameters['mid']!) ?? -1;
    _heroTag = Utils.makeHeroTag(_mid);
    _userController = Get.put(
      MemberControllerNew(mid: _mid),
      tag: _heroTag,
    );
    _userController.scrollController.addListener(() {
      _userController.scrollRatio.value =
          min(1.0, _userController.scrollController.offset.round() / 120);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userController.top == null || _userController.top == 0) {
      _userController.top = MediaQuery.of(context).padding.top;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => _userController.loadingState.value is Success
            ? LayoutBuilder(
                builder: (context, constraints) {
                  // if (constraints.maxHeight > constraints.maxWidth) {
                  return ExtendedNestedScrollView(
                    key: _key,
                    controller: _userController.scrollController,
                    onlyOneScrollInBody: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverOverlapAbsorber(
                          handle: ExtendedNestedScrollView
                              .sliverOverlapAbsorberHandleFor(context),
                          sliver: _buildAppBar(
                            isV: constraints.maxHeight > constraints.maxWidth,
                          ),
                        ),
                      ];
                    },
                    body: _userController.tab2?.isNotEmpty == true
                        ? LayoutBuilder(
                            builder: (context, _) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: ExtendedNestedScrollView
                                              .sliverOverlapAbsorberHandleFor(
                                                  context)
                                          .layoutExtent ??
                                      0,
                                ),
                                child: _buildBody,
                              );
                            },
                          )
                        : Center(child: const Text('EMPTY')),
                  );
                  // } else {
                  //   return Row(
                  //     children: [
                  //       Expanded(
                  //         child: CustomScrollView(
                  //           slivers: [
                  //             _buildAppBar(false),
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: SafeArea(
                  //           top: false,
                  //           left: false,
                  //           bottom: false,
                  //           child: Column(
                  //             children: [
                  //               SizedBox(height: _userController.top),
                  //               if ((_userController.tab2?.length ?? -1) > 1)
                  //                 _buildTab,
                  //               Expanded(
                  //                 child:
                  //                     _userController.tab2?.isNotEmpty == true
                  //                         ? _buildBody
                  //                         : Center(
                  //                             child: const Text('EMPTY'),
                  //                           ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   );
                  // }
                },
              )
            : Center(
                child: _buildUserInfo(_userController.loadingState.value),
              ),
      ),
    );
  }

  Widget get _buildTab => Material(
        color: Theme.of(context).colorScheme.surface,
        child: TabBar(
          controller: _userController.tabController,
          tabs: _userController.tabs,
          onTap: (value) {
            if (_userController.tabController?.indexIsChanging == false) {
              _key.currentState?.outerController.animToTop();
            }
          },
        ),
      );

  Widget get _buildBody => SafeArea(
        top: false,
        bottom: false,
        child: TabBarView(
          physics: customTabBarViewScrollPhysics,
          controller: _userController.tabController,
          children: _userController.tab2!.map((item) {
            return switch (item.param!) {
              'home' => MemberHome(heroTag: _heroTag),
              // 'dynamic' => MemberDynamic(mid: _mid ?? -1),
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
              _ => Center(child: Text(item.title ?? '')),
            };
          }).toList(),
        ),
      );

  Widget _buildAppBar({bool needTab = true, bool isV = true}) =>
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        // removeRight: true,
        child: DynamicSliverAppBar(
          leading: Padding(
            padding: EdgeInsets.only(top: _userController.top ?? 0),
            child: const BackButton(),
          ),
          title: Obx(() => _userController.scrollRatio.value == 1 &&
                  _userController.username != null
              ? Padding(
                  padding: EdgeInsets.only(top: _userController.top ?? 0),
                  child: Text(_userController.username!),
                )
              : const SizedBox.shrink()),
          pinned: true,
          flexibleSpace:
              _buildUserInfo(_userController.loadingState.value, isV),
          bottom: needTab && (_userController.tab2?.length ?? -1) > 1
              ? PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: _buildTab,
                )
              : null,
          actions: [
            Padding(
              padding: EdgeInsets.only(top: _userController.top ?? 0),
              child: IconButton(
                tooltip: '搜索',
                onPressed: () => Get.toNamed(
                    '/memberSearch?mid=$_mid&uname=${_userController.username}'),
                icon: const Icon(Icons.search_outlined),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: _userController.top ?? 0),
              child: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  if (_userController.ownerMid != _mid) ...[
                    PopupMenuItem(
                      onTap: () => _userController.blockUser(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.block, size: 19),
                          const SizedBox(width: 10),
                          Text(_userController.relation.value != -1
                              ? '加入黑名单'
                              : '移除黑名单'),
                        ],
                      ),
                    )
                  ],
                  PopupMenuItem(
                    onTap: () => _userController.shareUser(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.share_outlined, size: 19),
                        const SizedBox(width: 10),
                        Text(_userController.ownerMid != _mid
                            ? '分享UP主'
                            : '分享我的主页'),
                      ],
                    ),
                  ),
                  if (_userController.ownerMid != null &&
                      _userController.mid != _userController.ownerMid) ...[
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            clipBehavior: Clip.hardEdge,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            content: ReportPanel(
                              name: _userController.username,
                              mid: _mid,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 19,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '举报',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      );

  Widget _errorWidget(msg) {
    return errorWidget(
      errMsg: msg,
      callback: () {
        _userController.loadingState.value = LoadingState.loading();
        _userController.onRefresh();
      },
    );
  }

  Widget _buildUserInfo(LoadingState userState, [bool isV = true]) {
    return switch (userState) {
      Loading() => const CircularProgressIndicator(),
      Success() => Obx(
          () => Padding(
            padding: EdgeInsets.only(
                bottom: (_userController.tab2?.length ?? 0) > 1 ? 48 : 0),
            child: UserInfoCard(
              isV: isV,
              isOwner: _userController.mid == _userController.ownerMid,
              relation: _userController.relation.value,
              isFollow: _userController.isFollow.value,
              card: userState.response.card,
              images: userState.response.images,
              onFollow: () => _userController.onFollow(context),
              live: _userController.live,
              silence: _userController.silence,
              endTime: _userController.endTime,
            ),
          ),
        ),
      Error() => _errorWidget(userState.errMsg),
      LoadingState() => throw UnimplementedError(),
    };
  }
}
