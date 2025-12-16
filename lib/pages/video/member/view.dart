import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/member/user_info_type.dart';
import 'package:PiliPlus/models/member/info.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/pages/fan/view.dart';
import 'package:PiliPlus/pages/follow/view.dart';
import 'package:PiliPlus/pages/member_video/widgets/video_card_h_member_video.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/member/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class HorizontalMemberPage extends StatefulWidget {
  const HorizontalMemberPage({
    super.key,
    required this.mid,
    required this.videoDetailController,
    required this.ugcIntroController,
  });

  final dynamic mid;
  final VideoDetailController videoDetailController;
  final UgcIntroController ugcIntroController;

  @override
  State<HorizontalMemberPage> createState() => _HorizontalMemberPageState();
}

class _HorizontalMemberPageState extends State<HorizontalMemberPage> {
  late final HorizontalMemberPageController _controller;
  late final account = Accounts.main;
  late final String _bvid;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      HorizontalMemberPageController(
        mid: widget.mid,
        currAid: widget.videoDetailController.aid.toString(),
      ),
      tag: widget.videoDetailController.heroTag,
    );
    _bvid = widget.videoDetailController.bvid;
    if (_controller.loadingState.value
        case Success<List<SpaceArchiveItem>?> res) {
      final index = res.response?.indexWhere((e) => e.bvid == _bvid) ?? -1;
      if (index != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.scrollController.jumpTo(100.0 * index);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(
      () => _buildUserPage(theme, _controller.userState.value),
    );
  }

  Widget _buildUserPage(ThemeData theme, LoadingState userState) {
    return switch (userState) {
      Loading() => loadingWidget,
      Success(:var response) => Column(
        children: [
          _buildUserInfo(theme, response),
          _buildHeader(theme),
          Expanded(
            child: refreshIndicator(
              onRefresh: _controller.onRefresh,
              child: CustomScrollView(
                controller: _controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
                    ),
                    sliver: Obx(
                      () => _buildVideoList(
                        theme,
                        _controller.loadingState.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Error(:var errMsg) => scrollErrorWidget(
        controller: _controller.scrollController,
        errMsg: errMsg,
        onReload: () {
          _controller.userState.value = LoadingState<MemberInfoModel>.loading();
          _controller.getUserInfo();
        },
      ),
    };
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      height: 40,
      padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () {
              final count = _controller.count.value;
              return Text(
                count != -1 ? '共$count视频' : '',
                style: const TextStyle(fontSize: 13),
              );
            },
          ),
          SizedBox(
            height: 35,
            child: TextButton.icon(
              onPressed: () => _controller
                ..lastAid = widget.videoDetailController.aid.toString()
                ..queryBySort(),
              icon: Icon(
                Icons.sort,
                size: 16,
                color: theme.colorScheme.secondary,
              ),
              label: Obx(
                () => Text(
                  _controller.order.value == 'pubdate' ? '最新发布' : '最多播放',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList(
    ThemeData theme,
    LoadingState<List<SpaceArchiveItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverFixedExtentList.builder(
        itemCount: 10,
        itemBuilder: (_, _) => const VideoCardHSkeleton(),
        itemExtent: 100,
      ),
      Success(:var response) =>
        response != null && response.isNotEmpty
            ? SliverFixedExtentList.builder(
                itemBuilder: (context, index) {
                  if (index == response.length - 1 && _controller.hasNext) {
                    _controller.onLoadMore();
                  }
                  final SpaceArchiveItem videoItem = response[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: VideoCardHMemberVideo(
                      videoItem: videoItem,
                      bvid: _bvid,
                      onTap: () {
                        Get.back();
                        widget.ugcIntroController.onChangeEpisode(
                          BaseEpisodeItem(
                            bvid: videoItem.bvid,
                            cid: videoItem.cid,
                            cover: videoItem.cover,
                          ),
                        );
                      },
                    ),
                  );
                },
                itemCount: response.length,
                itemExtent: 100,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildUserInfo(ThemeData theme, MemberInfoModel memberInfoModel) {
    return Padding(
      padding: const .only(left: 16, top: 10, right: 16, bottom: 3),
      child: Row(
        spacing: 10,
        children: [
          _buildAvatar(memberInfoModel.face!),
          Expanded(child: _buildInfo(theme, memberInfoModel)),
        ],
      ),
    );
  }

  Column _buildInfo(ThemeData theme, MemberInfoModel memberInfoModel) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          GestureDetector(
            onTap: () => Utils.copyText(memberInfoModel.name ?? ''),
            child: Text(
              memberInfoModel.name ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    (memberInfoModel.vip?.status ?? -1) > 0 &&
                        memberInfoModel.vip?.type == 2
                    ? theme.colorScheme.vipColor
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/lv/lv${memberInfoModel.isSeniorMember == 1 ? '6_s' : memberInfoModel.level}.png',
            height: 11,
          ),
        ],
      ),
      const SizedBox(height: 4),
      Obx(
        () => Row(
          children: UserInfoType.values
              .map(
                (e) => _buildChildInfo(
                  theme: theme,
                  type: e,
                  userStat: _controller.userStat,
                  memberInfoModel: memberInfoModel,
                ),
              )
              .expand((child) sync* {
                yield SizedBox(
                  height: 10,
                  width: 20,
                  child: VerticalDivider(
                    width: 1,
                    color: theme.colorScheme.outline,
                  ),
                );
                yield child;
              })
              .skip(1)
              .toList(),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        spacing: 8,
        children: [
          Expanded(
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: memberInfoModel.isFollowed == true
                    ? theme.colorScheme.onInverseSurface
                    : null,
                foregroundColor: memberInfoModel.isFollowed == true
                    ? theme.colorScheme.outline
                    : null,
                padding: EdgeInsets.zero,
                tapTargetSize: .shrinkWrap,
                visualDensity: const VisualDensity(vertical: -2),
              ),
              onPressed: () {
                if (widget.mid == account.mid) {
                  Get.toNamed('/editProfile');
                } else {
                  if (!account.isLogin) {
                    SmartDialog.showToast('账号未登录');
                    return;
                  }
                  RequestUtils.actionRelationMod(
                    context: context,
                    mid: widget.mid,
                    isFollow: memberInfoModel.isFollowed ?? false,
                    callback: (attribute) {
                      _controller
                        ..userState.value.data.isFollowed = attribute != 0
                        ..userState.refresh();
                    },
                  );
                }
              },
              child: Text(
                widget.mid == account.mid
                    ? '编辑资料'
                    : memberInfoModel.isFollowed == true
                    ? '已关注'
                    : '关注',
                maxLines: 1,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: .shrinkWrap,
                visualDensity: const VisualDensity(vertical: -2),
              ),
              onPressed: () => Get.toNamed('/member?mid=${widget.mid}'),
              child: const Text(
                '查看主页',
                maxLines: 1,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildChildInfo({
    required ThemeData theme,
    required UserInfoType type,
    required Map userStat,
    required MemberInfoModel memberInfoModel,
  }) {
    dynamic num;
    VoidCallback? onTap;
    switch (type) {
      case UserInfoType.fan:
        num = userStat['follower'] != null
            ? NumUtils.numFormat(userStat['follower'])
            : '';
        onTap = () => FansPage.toFansPage(
          mid: widget.mid,
          name: memberInfoModel.name,
        );
      case UserInfoType.follow:
        num = userStat['following'] ?? '';
        onTap = () => FollowPage.toFollowPage(
          mid: widget.mid,
          name: memberInfoModel.name,
        );
      case UserInfoType.like:
        num = userStat['likes'] != null
            ? NumUtils.numFormat(userStat['likes'])
            : '';
    }
    return GestureDetector(
      onTap: onTap,
      child: Text(
        '$num${type.title}',
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildAvatar(String face) => GestureDetector(
    onTap: () => PageUtils.imageView(
      imgList: [SourceModel(url: face)],
    ),
    child: NetworkImgLayer(
      src: face,
      type: ImageType.avatar,
      width: 70,
      height: 70,
    ),
  );
}
