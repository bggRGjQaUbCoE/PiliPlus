import 'dart:async';
import 'dart:math';

import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/member_card_info/data.dart';
import 'package:PiliPlus/models_new/triple/ugc_triple.dart';
import 'package:PiliPlus/models_new/video/video_ai_conclusion/data.dart';
import 'package:PiliPlus/models_new/video/video_ai_conclusion/model_result.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_detail/section.dart';
import 'package:PiliPlus/models_new/video/video_detail/staff.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/models_new/video/video_relation/data.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/pay_coins/view.dart';
import 'package:PiliPlus/pages/video/related/controller.dart';
import 'package:PiliPlus/pages/video/reply/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class UgcIntroController extends CommonIntroController with ReloadMixin {
  late ExpandableController expandableCtr;

  final RxBool status = true.obs;

  // up主粉丝数
  final Rx<MemberCardInfoData> userStat = MemberCardInfoData().obs;
  // 关注状态 默认未关注
  late final RxMap followStatus = {}.obs;
  late final RxMap staffRelations = {}.obs;

  // 是否点踩
  final RxBool hasDislike = false.obs;

  late final showArgueMsg = Pref.showArgueMsg;
  late final enableAi = Pref.enableAi;
  late final horizontalMemberPage = Pref.horizontalMemberPage;

  AiConclusionResult? aiConclusionResult;

  @override
  void onInit() {
    super.onInit();
    bool alwaysExapndIntroPanel = Pref.alwaysExapndIntroPanel;
    expandableCtr = ExpandableController(
      initialExpanded: alwaysExapndIntroPanel,
    );
    if (!alwaysExapndIntroPanel && Pref.exapndIntroPanelH) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!expandableCtr.expanded && Get.context!.isLandscape) {
          expandableCtr.toggle();
        }
      });
    }

    videoDetail.value.title = Get.arguments['title'] ?? '';
  }

  // 获取视频简介&分p
  @override
  Future<void> queryVideoIntro() async {
    queryVideoTags();
    var res = await VideoHttp.videoIntro(bvid: bvid);
    if (res.isSuccess) {
      VideoDetailData data = res.data;
      videoPlayerServiceHandler.onVideoDetailChange(data, cid.value, heroTag);
      if (videoDetail.value.ugcSeason?.id == data.ugcSeason?.id) {
        // keep reversed season
        data.ugcSeason = videoDetail.value.ugcSeason;
      }
      if (videoDetail.value.cid == data.cid) {
        // keep reversed pages
        data
          ..pages = videoDetail.value.pages
          ..isPageReversed = videoDetail.value.isPageReversed;
      }
      videoDetail.value = data;
      try {
        final videoDetailController = Get.find<VideoDetailController>(
          tag: heroTag,
        );
        if (videoDetailController.cover.value.isEmpty ||
            (videoDetailController.videoUrl.isNullOrEmpty &&
                !videoDetailController.isQuerying)) {
          videoDetailController.cover.value = data.pic ?? '';
        }
        if (videoDetailController.showReply) {
          try {
            Get.find<VideoReplyController>(tag: heroTag).count.value =
                data.stat?.reply ?? 0;
          } catch (_) {}
        }
      } catch (_) {}
      final pages = videoDetail.value.pages;
      if (pages != null && pages.isNotEmpty && cid.value == 0) {
        cid.value = pages.first.cid!;
      }
      queryUserStat(data.staff);
    } else {
      res.toast();
      status.value = false;
    }

    if (accountService.isLogin.value) {
      queryAllStatus();
      queryFollowStatus();
    }
  }

  // 获取up主粉丝数
  Future<void> queryUserStat(List<Staff>? staff) async {
    if (staff?.isNotEmpty == true) {
      Request()
          .get(
            Api.relations,
            queryParameters: {'fids': staff!.map((item) => item.mid).join(',')},
          )
          .then((res) {
            if (res.data['code'] == 0) {
              staffRelations.addAll({
                'status': true,
                if (res.data['data'] != null) ...res.data['data'],
              });
            }
          });
    } else {
      final mid = videoDetail.value.owner?.mid;
      if (mid == null) {
        return;
      }
      var result = await MemberHttp.memberCardInfo(mid: mid);
      if (result['status']) {
        userStat.value = result['data'];
      }
    }
  }

  Future<void> queryAllStatus() async {
    var result = await VideoHttp.videoRelation(bvid: bvid);
    if (result['status']) {
      VideoRelation data = result['data'];
      late final stat = videoDetail.value.stat!;
      if (data.like!) {
        stat.like = max(1, stat.like);
      }
      if (data.favorite!) {
        stat.favorite = max(1, stat.favorite);
      }
      hasLike.value = data.like!;
      hasDislike.value = data.dislike!;
      coinNum.value = data.coin!;
      hasFav.value = data.favorite!;
    }
  }

  // 一键三连
  @override
  Future<void> actionTriple() async {
    feedBack();
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (hasLike.value && hasCoin && hasFav.value) {
      // 已点赞、投币、收藏
      SmartDialog.showToast('已三连');
      return;
    }
    var result = await VideoHttp.ugcTriple(bvid: bvid);
    if (result['status']) {
      UgcTriple data = result['data'];
      late final stat = videoDetail.value.stat!;
      if (data.like == true && !hasLike.value) {
        stat.like++;
        hasLike.value = true;
      }
      if (data.coin == true && !hasCoin) {
        stat.coin += 2;
        coinNum.value = 2;
        GlobalData().afterCoin(2);
      }
      if (data.fav == true && !hasFav.value) {
        stat.favorite++;
        hasFav.value = true;
      }
      hasDislike.value = false;
      if (!hasCoin) {
        SmartDialog.showToast('投币失败');
      } else {
        SmartDialog.showToast('三连成功');
      }
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // （取消）点赞
  @override
  Future<void> actionLikeVideo() async {
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (videoDetail.value.stat == null) {
      return;
    }
    final newVal = !hasLike.value;
    var result = await VideoHttp.likeVideo(bvid: bvid, type: newVal);
    if (result['status']) {
      SmartDialog.showToast(newVal ? result['data']['toast'] : '取消赞');
      videoDetail.value.stat!.like += newVal ? 1 : -1;
      hasLike.value = newVal;
      if (newVal) {
        hasDislike.value = false;
      }
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  Future<void> actionDislikeVideo() async {
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    var result = await VideoHttp.dislikeVideo(
      bvid: bvid,
      type: !hasDislike.value,
    );
    if (result['status']) {
      if (!hasDislike.value) {
        SmartDialog.showToast('点踩成功');
        hasDislike.value = true;
        if (hasLike.value) {
          videoDetail.value.stat!.like--;
          hasLike.value = false;
        }
      } else {
        SmartDialog.showToast('取消踩');
        hasDislike.value = false;
      }
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // 投币
  @override
  Future<void> actionCoinVideo() async {
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }

    int copyright = videoDetail.value.copyright ?? 1;
    if ((copyright != 1 && coinNum.value >= 1) || coinNum.value >= 2) {
      SmartDialog.showToast('达到投币上限啦~');
      return;
    }

    if (GlobalData().coins != null && GlobalData().coins! < 1) {
      SmartDialog.showToast('硬币不足');
      return;
    }

    PayCoinsPage.toPayCoinsPage(
      onPayCoin: coinVideo,
      copyright: copyright,
      hasCoin: coinNum.value == 1,
    );
  }

  @override
  (Object, int) getFavRidType() => (IdUtils.bv2av(bvid), 2);

  @override
  StatDetail? getStat() => videoDetail.value.stat;

  // 分享视频
  @override
  void actionShareVideo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        final videoDetail = this.videoDetail.value;
        String videoUrl = '${HttpString.baseUrl}/video/$bvid';
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                title: const Text(
                  '复制链接',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  Utils.copyText(videoUrl);
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  '其它app打开',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  PageUtils.launchURL(videoUrl);
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  '分享视频',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  Utils.shareText(
                    '${videoDetail.title} '
                    'UP主: ${videoDetail.owner!.name!}'
                    ' - $videoUrl',
                  );
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  '分享至动态',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => RepostPanel(
                      rid: videoDetail.aid,
                      dynType: 8,
                      pic: videoDetail.pic,
                      title: videoDetail.title,
                      uname: videoDetail.owner?.name,
                    ),
                  );
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  '分享至消息',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  try {
                    PageUtils.pmShare(
                      context,
                      content: {
                        "id": videoDetail.aid!.toString(),
                        "title": videoDetail.title!,
                        "headline": videoDetail.title!,
                        "source": 5,
                        "thumb": videoDetail.pic!,
                        "author": videoDetail.owner!.name!,
                        "author_id": videoDetail.owner!.mid!.toString(),
                      },
                    );
                  } catch (e) {
                    SmartDialog.showToast(e.toString());
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 查询关注状态
  Future<void> queryFollowStatus() async {
    final videoDetail = this.videoDetail.value;
    if (videoDetail.owner == null || videoDetail.staff?.isNotEmpty == true) {
      return;
    }
    var result = await UserHttp.hasFollow(videoDetail.owner!.mid!);
    if (result['status']) {
      Map data = result['data'];
      if (data['special'] == 1) data['attribute'] = -10;
      followStatus.value = data;
    }
  }

  // 关注/取关up
  Future<void> actionRelationMod(BuildContext context) async {
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    int? mid = videoDetail.value.owner?.mid;
    if (mid == null) {
      return;
    }
    int attr = followStatus['attribute'] ?? 0;
    if (attr == 128) {
      var res = await VideoHttp.relationMod(
        mid: mid,
        act: 6,
        reSrc: 11,
      );
      if (res['status']) {
        followStatus['attribute'] = 0;
      }
      return;
    } else {
      RequestUtils.actionRelationMod(
        context: context,
        mid: mid,
        isFollow: attr != 0,
        followStatus: followStatus,
        callback: (attribute) {
          followStatus['attribute'] = attribute;
          Future.delayed(const Duration(milliseconds: 500), queryFollowStatus);
        },
      );
    }
  }

  // 修改分P或番剧分集
  Future<void> onChangeEpisode(
    BaseEpisodeItem episode, {
    bool isStein = false,
  }) async {
    try {
      final String bvid = episode.bvid ?? this.bvid;
      final int aid = episode.aid ?? IdUtils.bv2av(bvid);
      final int? cid =
          episode.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
      if (cid == null) {
        return;
      }
      final String? cover = episode.cover;

      // 重新获取视频资源
      final videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);

      if (videoDetailCtr.isPlayAll) {
        if (videoDetailCtr.mediaList.indexWhere((item) => item.bvid == bvid) ==
            -1) {
          PageUtils.toVideoPage(
            bvid: bvid,
            cid: cid,
            cover: cover,
          );
          return;
        }
      }

      videoDetailCtr
        ..plPlayerController.pause()
        ..makeHeartBeat()
        ..updateMediaListHistory(aid)
        ..onReset(isStein: isStein)
        ..bvid = bvid
        ..aid = aid
        ..cid.value = cid
        ..queryVideoUrl();

      if (this.bvid != bvid) {
        reload = true;
        aiConclusionResult = null;

        if (cover != null && cover.isNotEmpty) {
          videoDetailCtr.cover.value = cover;
        }

        // 重新请求相关视频
        if (videoDetailCtr.plPlayerController.showRelatedVideo) {
          try {
            Get.find<RelatedController>(tag: heroTag)
              ..bvid = bvid
              ..queryData();
          } catch (_) {}
        }

        // 重新请求评论
        if (videoDetailCtr.showReply) {
          try {
            Get.find<VideoReplyController>(tag: heroTag)
              ..aid = aid
              ..onReload();
          } catch (_) {}
        }

        hasLater.value = videoDetailCtr.sourceType == SourceType.watchLater;
        this.bvid = bvid;
        queryVideoIntro();
      } else {
        if (episode is Part) {
          final videoDetail = this.videoDetail.value;
          videoPlayerServiceHandler.onVideoDetailChange(
            episode,
            cid,
            heroTag,
            artist: videoDetail.owner?.name,
            cover: videoDetail.pic,
          );
        }
      }

      this.cid.value = cid;
      queryOnlineTotal();
    } catch (e) {
      if (kDebugMode) debugPrint('ugc onChangeEpisode: $e');
    }
  }

  @override
  void onClose() {
    expandableCtr.dispose();
    super.onClose();
  }

  /// 播放上一个
  @override
  bool prevPlay([bool skipPart = false]) {
    final List<BaseEpisodeItem> episodes = <BaseEpisodeItem>[];
    bool isPart = false;

    final videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
    final videoDetail = this.videoDetail.value;

    if (!skipPart && (videoDetail.pages?.length ?? 0) > 1) {
      isPart = true;
      episodes.addAll(videoDetail.pages!);
    } else if (videoDetailCtr.isPlayAll) {
      episodes.addAll(videoDetailCtr.mediaList);
    } else if (videoDetail.ugcSeason != null) {
      final UgcSeason ugcSeason = videoDetail.ugcSeason!;
      final List<SectionItem> sections = ugcSeason.sections!;
      for (int i = 0; i < sections.length; i++) {
        final List<EpisodeItem> episodesList = sections[i].episodes!;
        episodes.addAll(episodesList);
      }
    }

    final int currentIndex = episodes.indexWhere(
      (e) =>
          e.cid ==
          (skipPart
              ? videoDetail.isPageReversed == true
                    ? videoDetail.pages!.last.cid
                    : videoDetail.pages!.first.cid
              : this.cid.value),
    );

    int prevIndex = currentIndex - 1;
    final PlayRepeat playRepeat = videoDetailCtr.plPlayerController.playRepeat;

    // 列表循环
    if (prevIndex < 0) {
      if (isPart &&
          (videoDetailCtr.isPlayAll || videoDetail.ugcSeason != null)) {
        return prevPlay(true);
      }
      if (playRepeat == PlayRepeat.listCycle) {
        prevIndex = episodes.length - 1;
      } else {
        return false;
      }
    }

    int? cid = episodes[prevIndex].cid;
    while (cid == null) {
      prevIndex--;
      if (prevIndex < 0) {
        return false;
      }
      cid = episodes[prevIndex].cid;
    }

    if (cid != this.cid.value) {
      onChangeEpisode(episodes[prevIndex]);
      return true;
    } else {
      return false;
    }
  }

  /// 列表循环或者顺序播放时，自动播放下一个
  @override
  bool nextPlay([bool skipPart = false]) {
    try {
      final List<BaseEpisodeItem> episodes = <BaseEpisodeItem>[];
      bool isPart = false;
      final videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
      final videoDetail = this.videoDetail.value;

      // part -> playall -> season
      if (!skipPart && (videoDetail.pages?.length ?? 0) > 1) {
        isPart = true;
        final List<Part> pages = videoDetail.pages!;
        episodes.addAll(pages);
      } else if (videoDetailCtr.isPlayAll) {
        episodes.addAll(videoDetailCtr.mediaList);
      } else if (videoDetail.ugcSeason != null) {
        final UgcSeason ugcSeason = videoDetail.ugcSeason!;
        final List<SectionItem> sections = ugcSeason.sections!;
        for (int i = 0; i < sections.length; i++) {
          final List<EpisodeItem> episodesList = sections[i].episodes!;
          episodes.addAll(episodesList);
        }
      }

      final PlayRepeat playRepeat =
          videoDetailCtr.plPlayerController.playRepeat;

      if (episodes.isEmpty) {
        if (playRepeat == PlayRepeat.autoPlayRelated &&
            videoDetailCtr.plPlayerController.showRelatedVideo) {
          return playRelated();
        }
        return false;
      }

      final int currentIndex = episodes.indexWhere(
        (e) =>
            e.cid ==
            (skipPart
                ? videoDetail.isPageReversed == true
                      ? videoDetail.pages!.last.cid
                      : videoDetail.pages!.first.cid
                : this.cid.value),
      );

      int nextIndex = currentIndex + 1;

      if (!isPart &&
          videoDetailCtr.isPlayAll &&
          currentIndex == episodes.length - 2) {
        videoDetailCtr.getMediaList();
      }

      // 列表循环
      if (nextIndex >= episodes.length) {
        if (isPart &&
            (videoDetailCtr.isPlayAll || videoDetail.ugcSeason != null)) {
          return nextPlay(true);
        }

        if (playRepeat == PlayRepeat.listCycle) {
          nextIndex = 0;
        } else if (playRepeat == PlayRepeat.autoPlayRelated &&
            videoDetailCtr.plPlayerController.showRelatedVideo) {
          return playRelated();
        } else {
          return false;
        }
      }

      int? cid = episodes[nextIndex].cid;
      while (cid == null) {
        nextIndex++;
        if (nextIndex >= episodes.length) {
          return false;
        }
        cid = episodes[nextIndex].cid;
      }

      if (cid != this.cid.value) {
        onChangeEpisode(episodes[nextIndex]);
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  bool playRelated() {
    RelatedController relatedCtr;
    if (Get.isRegistered<RelatedController>(tag: heroTag)) {
      relatedCtr = Get.find<RelatedController>(tag: heroTag);
    } else {
      relatedCtr = Get.put(RelatedController(autoQuery: false), tag: heroTag)
        ..queryData().whenComplete(playRelated);
      return false;
    }

    if (relatedCtr.loadingState.value is! Success) {
      return false;
    }

    if (relatedCtr.loadingState.value.data.isNullOrEmpty) {
      SmartDialog.showToast('暂无相关视频，停止连播');
      return false;
    }

    final firstItem = relatedCtr.loadingState.value.data!.first;
    onChangeEpisode(
      BaseEpisodeItem(
        aid: firstItem.aid,
        bvid: firstItem.bvid,
        cid: firstItem.cid,
        cover: firstItem.cover,
      ),
    );
    return true;
  }

  // ai总结
  Future aiConclusion() async {
    SmartDialog.showLoading(msg: '正在获取AI总结');
    final res = await VideoHttp.aiConclusion(
      bvid: bvid,
      cid: cid.value,
      upMid: videoDetail.value.owner?.mid,
    );
    SmartDialog.dismiss();
    if (res['status']) {
      AiConclusionData data = res['data'];
      aiConclusionResult = data.modelResult;
    } else if (res['handling']) {
      SmartDialog.showToast("AI处理中，请稍后再试");
    } else {
      SmartDialog.showToast("当前视频暂不支持AI视频总结");
    }
  }
}
