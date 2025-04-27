import 'package:PiliPlus/common/widgets/dynamic_sliver_appbar.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/radio_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/space/data.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/content/bangumi/member_bangumi.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/content/favorite/member_favorite.dart';
import 'package:PiliPlus/pages/member/content/member_contribute/member_contribute.dart';
import 'package:PiliPlus/pages/member/content/member_home/member_home.dart';
import 'package:PiliPlus/pages/member/controller.dart';
import 'package:PiliPlus/pages/member/widget/user_info_card.dart';
import 'package:PiliPlus/pages/member_dynamics/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';

class MemberPageNew extends StatefulWidget {
  const MemberPageNew({super.key});

  @override
  State<MemberPageNew> createState() => _MemberPageNewState();
}

class _MemberPageNewState extends State<MemberPageNew> {
  late final int _mid;
  late final String _heroTag;
  late final MemberControllerNew _userController;
  final _key = GlobalKey<ExtendedNestedScrollViewState>();
  int _offset = 120;

  @override
  void initState() {
    super.initState();
    _mid = int.tryParse(Get.parameters['mid']!) ?? -1;
    _heroTag = Utils.makeHeroTag(_mid);
    _userController = Get.put(
      MemberControllerNew(mid: _mid),
      tag: _heroTag,
    );
    _userController.scrollController.addListener(listener);
  }

  void listener() {
    if (_userController.scrollController.hasClients) {
      _userController.showUname.value =
          _userController.scrollController.offset >= _offset;
    }
  }

  @override
  void dispose() {
    _userController.scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: IgnorePointer(
          child: Obx(
            () => _userController.showUname.value &&
                    _userController.username != null
                ? Text(_userController.username!)
                : const SizedBox.shrink(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: '搜索',
            onPressed: () => Get.toNamed(
                '/memberSearch?mid=$_mid&uname=${_userController.username}'),
            icon: const Icon(Icons.search_outlined),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              if (_userController.ownerMid != 0 &&
                  _userController.ownerMid != _mid) ...[
                PopupMenuItem(
                  onTap: () => _userController.blockUser(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.block, size: 19),
                      const SizedBox(width: 10),
                      Text(_userController.relation.value != 128
                          ? '加入黑名单'
                          : '移除黑名单'),
                    ],
                  ),
                ),
                if (_userController.isFollowed == 1)
                  PopupMenuItem(
                    onTap: _userController.onRemoveFan,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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
                    Text(_userController.ownerMid != _mid ? '分享UP主' : '分享我的主页'),
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
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(
        () => _userController.loadingState.value is Success
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return ExtendedNestedScrollView(
                    key: _key,
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
                                  _buildTab,
                                Expanded(child: _buildBody),
                              ],
                            ),
                          )
                        : Center(child: const Text('EMPTY')),
                  );
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
            _ => Center(child: Text(item.title ?? '')),
          };
        }).toList(),
      );

  Widget _buildAppBar({bool isV = true}) {
    return DynamicSliverAppBar(
      pinned: true,
      primary: false,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + MediaQuery.paddingOf(context).top,
      flexibleSpace: _buildUserInfo(_userController.loadingState.value, isV),
      callback: (value) {
        _offset = (value - 56 - MediaQuery.paddingOf(context).top).toInt();
        listener();
      },
    );
  }

  Widget _errorWidget(msg) {
    return errorWidget(
      errMsg: msg,
      onReload: _userController.onReload,
    );
  }

  Widget _buildUserInfo(LoadingState userState, [bool isV = true]) {
    return switch (userState) {
      Loading() => const CircularProgressIndicator(),
      Success() => userState.response is Data
          ? Obx(
              () => UserInfoCard(
                isV: isV,
                isOwner: _userController.mid == _userController.ownerMid,
                relation: _userController.relation.value,
                card: userState.response.card,
                images: userState.response.images,
                onFollow: () => _userController.onFollow(context),
                live: _userController.live,
                silence: _userController.silence,
                endTime: _userController.endTime,
              ),
            )
          : GestureDetector(
              onTap: _userController.onReload,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(height: 56, width: double.infinity),
            ),
      Error() => _errorWidget(userState.errMsg),
    };
  }
}

class ReportPanel extends StatefulWidget {
  const ReportPanel({
    super.key,
    required this.name,
    required this.mid,
  });

  final dynamic name;
  final dynamic mid;

  @override
  State<ReportPanel> createState() => _ReportPanelState();
}

class _ReportPanelState extends State<ReportPanel> {
  final List<bool> _reasonList = List.generate(3, (_) => false).toList();
  final Set<int> _reason = {};
  int? _reasonV2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '举报: ${widget.name}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text('uid: ${widget.mid}'),
          const SizedBox(height: 10),
          const Text('举报内容（必选，可多选）'),
          ...List.generate(
            3,
            (index) => _checkBoxWidget(
              _reasonList[index],
              (value) {
                setState(() => _reasonList[index] = value);
                if (value) {
                  _reason.add(index + 1);
                } else {
                  _reason.remove(index + 1);
                }
              },
              ['头像违规', '昵称违规', '签名违规'][index],
            ),
          ),
          const Text('举报理由（单选，非必选）'),
          ...List.generate(
            5,
            (index) => RadioWidget<int>(
              value: index,
              groupValue: _reasonV2,
              onChanged: (value) {
                setState(() => _reasonV2 = value);
              },
              title: const ['色情低俗', '不实信息', '违禁', '人身攻击', '赌博诈骗'][index],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_reason.isEmpty) {
                    SmartDialog.showToast('至少选择一项作为举报内容');
                  } else {
                    Get.back();
                    dynamic result = await MemberHttp.reportMember(
                      widget.mid,
                      reason: _reason.join(','),
                      reasonV2: _reasonV2 != null ? _reasonV2! + 1 : null,
                    );
                    if (result['msg'] is String && result['msg'].isNotEmpty) {
                      SmartDialog.showToast(result['msg']);
                    } else {
                      SmartDialog.showToast('举报失败');
                    }
                  }
                },
                child: const Text('确定'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _checkBoxWidget(
  bool defValue,
  ValueChanged onChanged,
  String title,
) {
  return InkWell(
    onTap: () => onChanged(!defValue),
    child: Row(
      children: [
        Checkbox(
          value: defValue,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(title),
      ],
    ),
  );
}
