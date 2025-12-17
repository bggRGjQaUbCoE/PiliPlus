import 'dart:async';
import 'dart:math' show max;

import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart'
    hide EpisodeItem;
import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/video/pay_coins/view.dart';
import 'package:PiliPlus/pages/video/reply/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PgcIntroController extends CommonIntroController {
  int? seasonId;
  int? epId;

  late final String pgcType = pgcItem.type == 1 || pgcItem.type == 4
      ? '追番'
      : '追剧';

  late final bool isPgc;
  late final PgcInfoModel pgcItem;

  @override
  (Object, int) get getFavRidType => (epId!, 24);

  @override
  StatDetail? getStat() => pgcItem.stat;

  late final RxBool isFollowed = false.obs;
  late final RxInt followStatus = (-1).obs;
  late final RxBool isFav = (pgcItem.userStatus?.favored == 1).obs;

  @override
  void onInit() {
    final args = Get.arguments;
    seasonId = args['seasonId'];
    epId = args['epId'];
    isPgc = args['videoType'] == VideoType.pgc;
    pgcItem = args['pgcItem'];

    super.onInit();

    if (isPgc) {
      if (isLogin) {
        queryIsFollowed();
        if (epId != null) {
          queryPgcLikeCoinFav();
        }
      }
      queryVideoTags();
    }
  }

  // 获取点赞/投币/收藏状态
  Future<void> queryPgcLikeCoinFav() async {
    var result = await VideoHttp.pgcLikeCoinFav(epId: epId!);
    if (result case Success(:final response)) {
      final hasLike = response.like == 1;
      final hasFav = response.favorite == 1;
      late final stat = pgcItem.stat!;
      if (hasLike) {
        stat.like = max(1, stat.like);
      }
      if (hasFav) {
        stat.favorite = max(1, stat.favorite);
      }
      this.hasLike.value = hasLike;
      coinNum.value = response.coinNumber!;
      this.hasFav.value = hasFav;
    } else {
      result.toast();
    }
  }

  // （取消）点赞
  @override
  Future<void> actionLikeVideo() async {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final newVal = !hasLike.value;
    var result = await VideoHttp.likeVideo(bvid: bvid, type: newVal);
    if (result case Success(:final response)) {
      SmartDialog.showToast(newVal ? response : '取消赞');
      pgcItem.stat!.like += newVal ? 1 : -1;
      hasLike.value = newVal;
    } else {
      result.toast();
    }
  }

  // 投币
  @override
  void actionCoinVideo() {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }

    if (coinNum.value >= 2) {
      SmartDialog.showToast('达到投币上限啦~');
      return;
    }

    if (GlobalData().coins != null && GlobalData().coins! < 1) {
      SmartDialog.showToast('硬币不足');
      // return;
    }

    PayCoinsPage.toPayCoinsPage(
      onPayCoin: coinVideo,
      hasCoin: coinNum.value == 1,
    );
  }

  // 分享视频
  @override
  void actionShareVideo(BuildContext context) {
    final videoUrl = '${HttpString.baseUrl}/bangumi/play/ep$epId';
    try {
      EpisodeItem item = pgcItem.episodes!.firstWhere(
        (item) => item.epId == epId,
      );
      final title =
          item.shareCopy ??
          '${pgcItem.title} ${item.showTitle ?? item.longTitle}';
      PageUtils.share(
        context,
        pmContent: {
          "id": epId!.toString(),
          "title": title,
          "url": item.shareUrl,
          "headline": title,
          "source": 16,
          "thumb": item.cover,
          "source_desc": switch (pgcItem.type) {
            1 => '番剧',
            2 => '电影',
            3 => '纪录片',
            4 => '国创',
            5 => '电视剧',
            6 => '漫画',
            7 => '综艺',
            _ => null,
          },
        },
        link: videoUrl,
        repostPanel: RepostPanel(
          rid: epId,
          /**
             *  1：番剧 // 4097
                2：电影 // 4098
                3：纪录片 // 4101
                4：国创 // 4100
                5：电视剧 // 4099
                6：漫画
                7：综艺 // 4099
             */
          dynType: switch (pgcItem.type) {
            1 => 4097,
            2 => 4098,
            3 => 4101,
            4 => 4100,
            5 || 7 => 4099,
            _ => -1,
          },
          pic: pgcItem.cover,
          title:
              '${pgcItem.title}\n$title',
          uname: '',
        ),
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  // 修改分P或番剧分集
  Future<bool> onChangeEpisode(BaseEpisodeItem episode) async {
    try {
      final int epId = episode.epId ?? episode.id!;
      final String bvid = episode.bvid ?? this.bvid;
      final int aid = episode.aid ?? IdUtils.bv2av(bvid);
      final int? cid =
          episode.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
      if (cid == null) {
        return false;
      }
      final String? cover = episode.cover;

      // 重新获取视频资源
      this.epId = epId;
      this.bvid = bvid;

      videoDetailCtr
        ..plPlayerController.pause()
        ..makeHeartBeat()
        ..onReset()
        ..epId = epId
        ..bvid = bvid
        ..aid = aid
        ..cid.value = cid
        ..queryVideoUrl();
      if (cover != null && cover.isNotEmpty) {
        videoDetailCtr.cover.value = cover;
      }

      // 重新请求评论
      if (videoDetailCtr.showReply) {
        try {
          Get.find<VideoReplyController>(tag: heroTag)
            ..aid = aid
            ..onReload();
        } catch (_) {}
      }

      if (isPgc && isLogin) {
        queryPgcLikeCoinFav();
      }

      hasLater.value = videoDetailCtr.sourceType == SourceType.watchLater;
      this.cid.value = cid;
      queryOnlineTotal();
      queryVideoIntro(episode as EpisodeItem);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('pgc onChangeEpisode: $e');
      return false;
    }
  }

  // 追番
  Future<void> pgcAdd() async {
    var result = await VideoHttp.pgcAdd(seasonId: pgcItem.seasonId);
    if (result case Success(:final response)) {
      isFollowed.value = true;
      followStatus.value = 2;
      SmartDialog.showToast(response);
    } else {
      result.toast();
    }
  }

  // 取消追番
  Future<void> pgcDel() async {
    var result = await VideoHttp.pgcDel(seasonId: pgcItem.seasonId);
    if (result case Success(:final response)) {
      isFollowed.value = false;
      SmartDialog.showToast(response);
    } else {
      result.toast();
    }
  }

  Future<void> pgcUpdate(int status) async {
    var result = await VideoHttp.pgcUpdate(
      seasonId: pgcItem.seasonId.toString(),
      status: status,
    );
    if (result case Success(:final response)) {
      followStatus.value = status;
      SmartDialog.showToast(response);
    } else {
      result.toast();
    }
  }

  @override
  bool prevPlay() {
    final episodes = pgcItem.episodes!;
    int currentIndex = episodes.indexWhere(
      (e) => e.cid == videoDetailCtr.cid.value,
    );
    int prevIndex = currentIndex - 1;
    PlayRepeat playRepeat = videoDetailCtr.plPlayerController.playRepeat;
    if (prevIndex < 0) {
      if (playRepeat == PlayRepeat.listCycle) {
        prevIndex = episodes.length - 1;
      } else {
        return false;
      }
    }
    onChangeEpisode(episodes[prevIndex]);
    return true;
  }

  /// 列表循环或者顺序播放时，自动播放下一个；自动连播时，播放相关视频
  @override
  bool nextPlay() {
    try {
      final episodes = pgcItem.episodes!;

      PlayRepeat playRepeat = videoDetailCtr.plPlayerController.playRepeat;

      int currentIndex = episodes.indexWhere(
        (e) => e.cid == videoDetailCtr.cid.value,
      );
      int nextIndex = currentIndex + 1;
      // 列表循环
      if (nextIndex >= episodes.length) {
        if (playRepeat == PlayRepeat.listCycle) {
          nextIndex = 0;
        } else if (playRepeat == PlayRepeat.autoPlayRelated) {
          return false;
        } else {
          return false;
        }
      }
      onChangeEpisode(episodes[nextIndex]);
      return true;
    } catch (_) {
      return false;
    }
  }

  // 一键三连
  @override
  Future<void> actionTriple() async {
    feedBack();
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (hasLike.value && hasCoin && hasFav.value) {
      // 已点赞、投币、收藏
      SmartDialog.showToast('已三连');
      return;
    }
    var result = await VideoHttp.pgcTriple(epId: epId!, seasonId: seasonId);
    if (result case Success(:final response)) {
      late final stat = pgcItem.stat!;
      if (response.like == 1 && !hasLike.value) {
        stat.like++;
        hasLike.value = true;
      }
      if (response.coin == 1 && !hasCoin) {
        stat.coin += 2;
        coinNum.value = 2;
        GlobalData().afterCoin(2);
      }
      if (response.favorite == 1 && !hasFav.value) {
        stat.favorite++;
        hasFav.value = true;
      }
      if (!hasCoin) {
        SmartDialog.showToast('投币失败');
      } else {
        SmartDialog.showToast('三连成功');
      }
    } else {
      result.toast();
    }
  }

  Future<void> queryIsFollowed() async {
    // try {
    //   var result = await Request().get(
    //     'https://www.bilibili.com/bangumi/play/ss$seasonId',
    //   );
    //   dom.Document document = html_parser.parse(result.data);
    //   dom.Element? scriptElement =
    //       document.querySelector('script#__NEXT_DATA__');
    //   if (scriptElement != null) {
    //     dynamic scriptContent = jsonDecode(scriptElement.text);
    //     isFollowed.value =
    //         scriptContent['props']['pageProps']['followState']['isFollowed'];
    //     followStatus.value =
    //         scriptContent['props']['pageProps']['followState']['followStatus'];
    //   }
    // } catch (_) {}

    // ViewGrpc.view(bvid: bvid).then((res) {
    //   if (res.isSuccess) {
    //     ViewPgcAny view = ViewPgcAny.fromBuffer(res.data.supplement.value);
    //     var userStatus = view.ogvData.userStatus;
    //     isFollowed.value = userStatus.follow == 1;
    //     followStatus.value = userStatus.followStatus;
    //   }
    // });

    final res = await PgcHttp.seasonStatus(seasonId!);
    if (res['status']) {
      final Map<String, dynamic> data = res['data'];
      isFollowed.value = data['follow'] == 1;
      followStatus.value = data['follow_status'];
    }
  }

  @override
  void queryVideoIntro([EpisodeItem? episode]) {
    episode ??= pgcItem.episodes!.firstWhere((e) => e.cid == cid.value);
    videoDetail
      ..value.title = episode.showTitle
      ..refresh();
    videoPlayerServiceHandler?.onVideoDetailChange(
      episode,
      cid.value,
      heroTag,
      artist: pgcItem.title,
    );
  }

  Future<void> onFavPugv(bool isFav) async {
    final res = isFav
        ? await FavHttp.delFavPugv(seasonId!)
        : await FavHttp.addFavPugv(seasonId!);
    if (res.isSuccess) {
      this.isFav.value = !isFav;
      SmartDialog.showToast('${isFav ? '取消' : ''}收藏成功');
    } else {
      res.toast();
    }
  }
}
