import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
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
import 'package:PiliPlus/utils/extension.dart';
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
          _controller.scrollController.jumpTo(100.0 * index + 40);
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
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              iconButton(
                context: context,
                onPressed: Get.back,
                tooltip: '关闭',
                icon: const Icon(Icons.clear),
                size: 32,
              ),
              const SizedBox(width: 16),
            ],
          ),
          _buildUserInfo(theme, response),
          Expanded(
            child: refreshIndicator(
              onRefresh: _controller.onRefresh,
              child: CustomScrollView(
                controller: _controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildSliverHeader(theme),
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

  Widget _buildSliverHeader(ThemeData theme) {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        extent: 40,
        bgColor: theme.colorScheme.surface,
        child: Container(
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
        ),
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
        response?.isNotEmpty == true
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
                itemCount: response!.length,
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
    return Row(
      children: [
        const SizedBox(width: 16),
        _buildAvatar(memberInfoModel.face!),
        const SizedBox(width: 10),
        Expanded(child: _buildInfo(theme, memberInfoModel)),
        const SizedBox(width: 16),
      ],
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
      const SizedBox(height: 2),
      Obx(
        () => Row(
          children: List.generate(5, (index) {
            if (index.isEven) {
              return _buildChildInfo(
                theme: theme,
                title: const ['粉丝', '关注', '获赞'][index ~/ 2],
                num: index == 0
                    ? _controller.userStat['follower'] != null
                          ? NumUtils.numFormat(_controller.userStat['follower'])
                          : ''
                    : index == 2
                    ? _controller.userStat['following'] ?? ''
                    : _controller.userStat['likes'] != null
                    ? NumUtils.numFormat(_controller.userStat['likes'])
                    : '',
                onTap: () {
                  if (index == 0) {
                    FansPage.toFansPage(
                      mid: widget.mid,
                      name: memberInfoModel.name,
                    );
                  } else if (index == 2) {
                    FollowPage.toFollowPage(
                      mid: widget.mid,
                      name: memberInfoModel.name,
                    );
                  }
                },
              );
            } else {
              return SizedBox(
                height: 10,
                width: 20,
                child: VerticalDivider(
                  width: 1,
                  color: theme.colorScheme.outline,
                ),
              );
            }
          }),
        ),
      ),
      const SizedBox(height: 2),
      Row(
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
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
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
    required String title,
    required dynamic num,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        '$num$title',
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
