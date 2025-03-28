import 'dart:async';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/pages/dynamics/repost_dyn_panel.dart';
import 'package:PiliPlus/pages/video/detail/introduction/pay_coins_page.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/user/fav_folder.dart';
import 'package:PiliPlus/models/video/ai.dart';
import 'package:PiliPlus/models/video_detail_res.dart';
import 'package:PiliPlus/pages/video/detail/controller.dart';
import 'package:PiliPlus/pages/video/detail/reply/index.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage.dart';

import '../../../../http/search.dart';
import '../../../../models/model_hot_video_item.dart';
import '../related/index.dart';

class VideoIntroController extends GetxController
    with GetTickerProviderStateMixin {
  // 视频bvid
  late String bvid;

  // 是否预渲染 骨架屏
  bool preRender = false;

  // 视频详情 上个页面传入
  Map videoItem = {};
  late final RxMap staffRelations = {}.obs;

  // 请求状态
  RxBool isLoading = false.obs;

  // 视频详情 请求返回
  Rx<VideoDetailData> videoDetail = VideoDetailData().obs;

  // up主粉丝数
  Rx<Map<String, dynamic>> userStat =
      Rx<Map<String, dynamic>>({'follower': '-'});

  dynamic videoTags;

  // 是否点赞
  RxBool hasLike = false.obs;
  // 是否点踩
  RxBool hasDislike = false.obs;
  // 是否投币
  RxBool hasCoin = false.obs;
  // 是否收藏
  RxBool hasFav = false.obs;
  // 是否稍后再看
  RxBool hasLater = false.obs;
  bool isLogin = false;
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  Set? favIds;
  // 关注状态 默认未关注
  RxMap followStatus = {}.obs;

  RxInt lastPlayCid = 0.obs;
  dynamic userInfo;

  // 同时观看
  bool isShowOnlineTotal = false;
  RxString total = '1'.obs;
  Timer? timer;
  String heroTag = '';
  late ModelResult modelResult;
  Rx<Map<String, dynamic>> queryVideoIntroData =
      Rx<Map<String, dynamic>>({"status": true});

  ExpandableController? expandableCtr;

  late final showArgueMsg = GStorage.showArgueMsg;
  late final enableAi =
      GStorage.setting.get(SettingBoxKey.enableAi, defaultValue: false);
  late final enableQuickFav =
      GStorage.setting.get(SettingBoxKey.enableQuickFav, defaultValue: false);

  @override
  void onInit() {
    super.onInit();
    userInfo = GStorage.userInfo.get('userInfoCache');
    try {
      if (heroTag.isEmpty) {
        heroTag = Get.arguments['heroTag'];
      }
      bvid = Get.parameters['bvid']!;
    } catch (_) {}
    if (Get.arguments.isNotEmpty) {
      if (Get.arguments.containsKey('videoItem')) {
        preRender = true;
        var args = Get.arguments['videoItem'];
        var keys = Get.arguments.keys.toList();
        try {
          if (args.pic != null && args.pic != '') {
            videoItem['pic'] = args.pic;
          } else if (args.cover != null && args.cover != '') {
            videoItem['pic'] = args.cover;
          }
        } catch (_) {}
        if (args.title is String) {
          videoItem['title'] = args.title;
        } else {
          String str = '';
          for (Map map in args.title) {
            str += map['text'];
          }
          videoItem['title'] = str;
        }
        videoItem['stat'] = keys.contains('stat') ? args.stat : null;
        videoItem['pubdate'] = keys.contains('pubdate') ? args.pubdate : null;
        videoItem['owner'] = keys.contains('owner') ? args.owner : null;
      }
    }
    isLogin = userInfo != null;
    lastPlayCid.value = int.parse(Get.parameters['cid']!);
    isShowOnlineTotal = GStorage.setting
        .get(SettingBoxKey.enableOnlineTotal, defaultValue: false);
    startTimer();
    queryVideoIntro();
  }

  // 获取视频简介&分p
  Future queryVideoIntro() async {
    queryVideoTags();
    var result = await VideoHttp.videoIntro(bvid: bvid);
    if (result['status']) {
      VideoDetailData data = result['data'];
      if (videoDetail.value.ugcSeason?.id == data.ugcSeason?.id) {
        // keep reversed season
        data.ugcSeason = videoDetail.value.ugcSeason;
        data.isSeasonReversed = videoDetail.value.isSeasonReversed;
      }
      if (videoDetail.value.cid == data.cid) {
        // keep reversed pages
        data.pages = videoDetail.value.pages;
        data.isPageReversed = videoDetail.value.isPageReversed;
      }
      videoDetail.value = data;
      videoItem['staff'] = data.staff;
      try {
        final videoDetailController =
            Get.find<VideoDetailController>(tag: heroTag);
        if (videoDetailController.videoItem['pic'] == null ||
            videoDetailController.videoItem['pic'] == '' ||
            (videoDetailController.videoUrl.isNullOrEmpty &&
                videoDetailController.isQuerying.not)) {
          videoDetailController.videoItem['pic'] = data.pic;
        }
      } catch (_) {}
      if (videoDetail.value.pages != null &&
          videoDetail.value.pages!.isNotEmpty &&
          lastPlayCid.value == 0) {
        lastPlayCid.value = videoDetail.value.pages!.first.cid!;
      }
      // Get.find<VideoDetailController>(tag: heroTag).tabs.value = [
      //   '简介',
      //   '评论 ${result['data']!.stat!.reply}'
      // ];
      // 获取到粉丝数再返回
      queryUserStat();
    } else {
      SmartDialog.showToast(
          "${result['code']} ${result['msg']} ${result['data']}");
    }
    queryVideoIntroData.value = result;
    if (isLogin) {
      queryAllStatus();
      // // 获取点赞状态
      // queryHasLikeVideo();
      // // 获取投币状态
      // queryHasCoinVideo();
      // // 获取收藏状态
      // queryHasFavVideo();
      // //
      queryFollowStatus();
    }
  }

  Future queryVideoTags() async {
    var result = await UserHttp.videoTags(bvid: bvid);
    if (result['status']) {
      videoTags = result['data'];
      // debugPrint('tags: ${result['data']}');
    }
  }

  // 获取up主粉丝数
  Future queryUserStat() async {
    if (videoItem['staff']?.isNotEmpty == true) {
      Request().get(
        Api.relations,
        queryParameters: {
          'fids': (videoItem['staff'] as List<Staff>)
              .map((item) => item.mid)
              .join(',')
        },
      ).then((res) {
        if (res.data['code'] == 0) {
          staffRelations.value = {
            'status': true,
            if (res.data['data'] != null) ...res.data['data'],
          };
        }
      });
    } else {
      if (videoDetail.value.owner == null) {
        return;
      }
      var result =
          await MemberHttp.memberCardInfo(mid: videoDetail.value.owner!.mid!);
      if (result['status']) {
        userStat.value = result['data'];
      }
    }
  }

  Future<void> queryAllStatus() async {
    var result = await VideoHttp.videoRelation(bvid: bvid);
    if (result['status']) {
      var data = result['data'];
      hasLike.value = data['like'];
      hasDislike.value = data['dislike'];
      hasCoin.value = data['coin'] != 0;
      hasFav.value = data['favorite'];
      // followStatus['attritube'] = data['attention'] ? 2 : 0;
    }
  }

  // // 获取点赞状态
  // Future queryHasLikeVideo() async {
  //   var result = await VideoHttp.hasLikeVideo(bvid: bvid);
  //   // data	num	被点赞标志	0：未点赞  1：已点赞  2：已点踩
  //   hasLike.value = result["data"] == 1;
  //   hasDislike.value = result["data"] == 2;
  // }

  // // 获取投币状态
  // Future queryHasCoinVideo() async {
  //   var result = await VideoHttp.hasCoinVideo(bvid: bvid);
  //   if (result['status']) {
  //     hasCoin.value = result["data"]['multiply'] != 0;
  //   }
  // }

  // // 获取收藏状态
  // Future queryHasFavVideo() async {
  //   /// fix 延迟查询
  //   await Future.delayed(const Duration(milliseconds: 200));
  //   var result = await VideoHttp.hasFavVideo(aid: IdUtils.bv2av(bvid));
  //   if (result['status']) {
  //     hasFav.value = result["data"]['favoured'];
  //   } else {
  //     hasFav.value = false;
  //   }
  // }

  // 一键三连
  Future actionOneThree() async {
    feedBack();
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (hasLike.value && hasCoin.value && hasFav.value) {
      // 已点赞、投币、收藏
      SmartDialog.showToast('已三连');
      return false;
    }
    var result = await VideoHttp.oneThree(bvid: bvid);
    if (result['status']) {
      hasLike.value = result["data"]["like"];
      hasCoin.value = result["data"]["coin"];
      hasFav.value = result["data"]["fav"];
      SmartDialog.showToast('三连成功');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // （取消）点赞
  Future actionLikeVideo() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (videoDetail.value.stat?.like == null) {
      // not init
      return;
    }
    var result = await VideoHttp.likeVideo(bvid: bvid, type: !hasLike.value);
    if (result['status']) {
      // hasLike.value = result["data"] == 1 ? true : false;
      if (!hasLike.value) {
        SmartDialog.showToast(result['data']['toast']);
        hasLike.value = true;
        hasDislike.value = false;
        videoDetail.value.stat!.like = videoDetail.value.stat!.like! + 1;
      } else if (hasLike.value) {
        SmartDialog.showToast('取消赞');
        hasLike.value = false;
        videoDetail.value.stat!.like = videoDetail.value.stat!.like! - 1;
      }
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  Future actionDislikeVideo() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    var result =
        await VideoHttp.dislikeVideo(bvid: bvid, type: !hasDislike.value);
    if (result['status']) {
      // hasLike.value = result["data"] == 1 ? true : false;
      if (!hasDislike.value) {
        SmartDialog.showToast('点踩成功');
        hasDislike.value = true;
        hasLike.value = false;
      } else {
        SmartDialog.showToast('取消踩');
        hasDislike.value = false;
      }
      // hasDislike.refresh();
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  Future viewLater() async {
    var res = await (hasLater.value
        ? UserHttp.toViewDel(aids: [IdUtils.bv2av(bvid)])
        : await UserHttp.toViewLater(bvid: bvid));
    if (res['status']) hasLater.value = !hasLater.value;
    SmartDialog.showToast(res['msg']);
  }

  void coinVideo(int coin, [bool selectLike = false]) async {
    if (videoDetail.value.stat?.coin == null) {
      // not init
      return;
    }
    var res = await VideoHttp.coinVideo(
      bvid: bvid,
      multiply: coin,
      selectLike: selectLike ? 1 : 0,
    );
    if (res['status']) {
      SmartDialog.showToast('投币成功');
      hasCoin.value = true;
      videoDetail.value.stat!.coin = videoDetail.value.stat!.coin! + coin;
      if (selectLike && hasLike.value.not) {
        hasLike.value = true;
        videoDetail.value.stat!.like = videoDetail.value.stat!.like! + 1;
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 投币
  Future actionCoinVideo() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }

    Navigator.of(Get.context!).push(
      GetDialogRoute(
        pageBuilder: (buildContext, animation, secondaryAnimation) {
          return PayCoinsPage(
            callback: coinVideo,
            copyright: (queryVideoIntroData.value['data'] as VideoDetailData?)
                    ?.copyright ??
                1,
          );
        },
        transitionDuration: const Duration(milliseconds: 225),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.linear;

          var tween = Tween<double>(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    // showDialog(
    //   context: Get.context!,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: const Text('选择投币个数'),
    //       contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
    //       actions: [
    //         TextButton(
    //             onPressed: () => Get.back(),
    //             child: Text('取消',
    //                 style: TextStyle(
    //                     color: Theme.of(context).colorScheme.outline))),
    //         TextButton(
    //             onPressed: () async {
    //               coinVideo(1);
    //               Get.back();
    //             },
    //             child: const Text('投 1 枚')),
    //         TextButton(
    //             onPressed: () async {
    //               coinVideo(2);
    //               Get.back();
    //             },
    //             child: const Text('投 2 枚'))
    //       ],
    //     );
    //   },
    // );
  }

  // （取消）收藏
  Future actionFavVideo({type = 'choose'}) async {
    // 收藏至默认文件夹
    if (type == 'default') {
      SmartDialog.showLoading(msg: '请求中');
      queryVideoInFolder().then((res) async {
        if (res['status']) {
          int defaultFolderId = favFolderData.value.list!.first.id!;
          bool notInDefFolder = favFolderData.value.list!.first.favState! == 0;
          var result = await VideoHttp.favVideo(
            aid: IdUtils.bv2av(bvid),
            addIds: notInDefFolder ? '$defaultFolderId' : '',
            delIds: !notInDefFolder ? '$defaultFolderId' : '',
          );
          SmartDialog.dismiss();
          if (result['status']) {
            hasFav.value = !hasFav.value || (hasFav.value && notInDefFolder);
            // 重新获取收藏状态
            // await queryHasFavVideo();
            SmartDialog.showToast('✅ 快速收藏/取消收藏成功');
          } else {
            SmartDialog.showToast(result['msg']);
          }
        } else {
          SmartDialog.dismiss();
        }
      });
      return;
    }

    List addMediaIdsNew = [];
    List delMediaIdsNew = [];
    try {
      for (var i in favFolderData.value.list!.toList()) {
        bool isFaved = favIds?.contains(i.id) == true;
        if (i.favState == 1) {
          if (isFaved.not) {
            addMediaIdsNew.add(i.id);
          }
        } else {
          if (isFaved) {
            delMediaIdsNew.add(i.id);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    SmartDialog.showLoading(msg: '请求中');
    var result = await VideoHttp.favVideo(
      aid: IdUtils.bv2av(bvid),
      addIds: addMediaIdsNew.join(','),
      delIds: delMediaIdsNew.join(','),
    );
    SmartDialog.dismiss();
    if (result['status']) {
      Get.back();
      hasFav.value =
          addMediaIdsNew.isNotEmpty || favIds?.length != delMediaIdsNew.length;
      // 重新获取收藏状态
      // await queryHasFavVideo();
      SmartDialog.showToast('操作成功');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // 分享视频
  Future actionShareVideo(context) async {
    showDialog(
        context: context,
        builder: (context) {
          String videoUrl = '${HttpString.baseUrl}/video/$bvid';
          return AlertDialog(
            clipBehavior: Clip.hardEdge,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
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
                  title: const Text(
                    '其它app打开',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.back();
                    Utils.launchURL(videoUrl);
                  },
                ),
                ListTile(
                  title: const Text(
                    '分享视频',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.back();
                    Utils.shareText('${videoDetail.value.title} '
                        'UP主: ${videoDetail.value.owner!.name!}'
                        ' - $videoUrl');
                  },
                ),
                ListTile(
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
                        rid: videoDetail.value.aid,
                        dynType: 8,
                        pic: videoDetail.value.pic,
                        title: videoDetail.value.title,
                        uname: videoDetail.value.owner?.name,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Future queryVideoInFolder() async {
    favIds = null;
    var result = await VideoHttp.videoInFolder(
        mid: userInfo.mid, rid: IdUtils.bv2av(bvid));
    if (result['status']) {
      favFolderData.value = result['data'];
      favIds = favFolderData.value.list
          ?.where((item) => item.favState == 1)
          .map((item) => item.id)
          .toSet();
    }
    return result;
  }

  // 选择文件夹
  onChoose(bool checkValue, int index) {
    feedBack();
    List<FavFolderItemData> datalist = favFolderData.value.list!;
    datalist[index].favState = checkValue ? 1 : 0;
    datalist[index].mediaCount = checkValue
        ? datalist[index].mediaCount! + 1
        : datalist[index].mediaCount! - 1;
    favFolderData.value.list = datalist;
    favFolderData.refresh();
  }

  // 查询关注状态
  Future queryFollowStatus() async {
    if (videoDetail.value.owner == null) {
      return;
    }
    var result = await UserHttp.hasFollow(videoDetail.value.owner!.mid!);
    if (result['status']) {
      followStatus.value = result['data'];
    }
  }

  // 关注/取关up
  Future actionRelationMod(BuildContext context) async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    int attr = followStatus['attribute'] ?? 0;
    if (attr == 128) {
      dynamic res = await VideoHttp.relationMod(
        mid: videoDetail.value.owner?.mid ?? -1,
        act: 6,
        reSrc: 11,
      );
      if (res['status']) {
        followStatus['attribute'] = 0;
      }
      return;
    } else {
      Utils.actionRelationMod(
        context: context,
        mid: videoDetail.value.owner?.mid,
        isFollow: attr != 0,
        followStatus: followStatus,
        callback: (attribute) {
          followStatus['attribute'] = attribute;
        },
      );
    }

    // MemberController _ = Get.put<MemberController>(MemberController(mid: mid),
    //     tag: mid.toString());
    // await _.getInfo();
    // if (context.mounted) await _.actionRelationMod(context);
    // followStatus['attribute'] = _.attribute.value;
    // followStatus.refresh();
    // Get.delete<MemberController>(tag: mid.toString());
  }

  // 修改分P或番剧分集
  Future changeSeasonOrbangu(epid, bvid, cid, aid, cover, [isStein]) async {
    // 重新获取视频资源
    final videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);

    if (videoDetailCtr.isPlayAll) {
      if (videoDetailCtr.mediaList.indexWhere((item) => item.bvid == bvid) ==
          -1) {
        Utils.toViewPage(
          'bvid=$bvid&cid=$cid',
          arguments: {
            if (cover != null) 'pic': cover,
            'heroTag': Utils.makeHeroTag(bvid),
          },
        );
        return;
      }
    }

    videoDetailCtr
      ..plPlayerController.pause()
      ..makeHeartBeat()
      ..updateMediaListHistory(aid)
      ..onReset(isStein)
      ..bvid = bvid
      ..oid.value = aid ?? IdUtils.bv2av(bvid)
      ..cid.value = cid
      ..danmakuCid.value = cid
      ..queryVideoUrl();

    if (this.bvid != bvid) {
      if (cover is String && cover.isNotEmpty) {
        videoDetailCtr.videoItem['pic'] = cover;
      }

      // 重新请求相关视频
      if (videoDetailCtr.showRelatedVideo) {
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

      hasLater.value = false;
      this.bvid = bvid;
      queryVideoIntro();
    }

    lastPlayCid.value = cid;
    queryOnlineTotal();
  }

  void startTimer() {
    if (isShowOnlineTotal) {
      queryOnlineTotal();
      timer ??= Timer.periodic(const Duration(seconds: 10), (Timer timer) {
        queryOnlineTotal();
      });
    }
  }

  void canelTimer() {
    timer?.cancel();
    timer = null;
  }

  // 查看同时在看人数
  Future queryOnlineTotal() async {
    if (isShowOnlineTotal.not) {
      return;
    }
    dynamic result = await VideoHttp.onlineTotal(
      aid: IdUtils.bv2av(bvid),
      bvid: bvid,
      cid: lastPlayCid.value,
    );
    // dynamic result = await GrpcRepo.playerOnline(
    //   aid: IdUtils.bv2av(bvid),
    //   cid: lastPlayCid.value,
    // );
    if (result['status']) {
      total.value = result['data'];
    }
  }

  @override
  void onClose() {
    canelTimer();
    expandableCtr?.dispose();
    expandableCtr = null;
    super.onClose();
  }

  /// 播放上一个
  bool prevPlay([bool skipPages = false]) {
    final List episodes = [];
    bool isPages = false;

    final videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);

    if (skipPages.not && (videoDetail.value.pages?.length ?? 0) > 1) {
      isPages = true;
      final List<Part> pages = videoDetail.value.pages!;
      episodes.addAll(pages);
    } else if (videoDetailCtr.isPlayAll) {
      episodes.addAll(videoDetailCtr.mediaList);
    } else if (videoDetail.value.ugcSeason != null) {
      final UgcSeason ugcSeason = videoDetail.value.ugcSeason!;
      final List<SectionItem> sections = ugcSeason.sections!;
      for (int i = 0; i < sections.length; i++) {
        final List<EpisodeItem> episodesList = sections[i].episodes!;
        episodes.addAll(episodesList);
      }
    }

    final int currentIndex = episodes.indexWhere((e) =>
        e.cid ==
        (skipPages ? videoDetail.value.pages!.first.cid : lastPlayCid.value));
    int prevIndex = currentIndex - 1;
    final PlayRepeat playRepeat = videoDetailCtr.plPlayerController.playRepeat;

    // 列表循环
    if (prevIndex < 0) {
      if (isPages &&
          (videoDetailCtr.isPlayAll || videoDetail.value.ugcSeason != null)) {
        return prevPlay(true);
      }
      if (playRepeat == PlayRepeat.listCycle) {
        prevIndex = episodes.length - 1;
      } else {
        return false;
      }
    }
    final int cid = episodes[prevIndex].cid!;
    final String rBvid = isPages ? bvid : episodes[prevIndex].bvid;
    final int rAid = isPages ? IdUtils.bv2av(bvid) : episodes[prevIndex].aid!;
    changeSeasonOrbangu(null, rBvid, cid, rAid, null);
    return true;
  }

  /// 列表循环或者顺序播放时，自动播放下一个
  bool nextPlay([bool skipPages = false]) {
    try {
      final List episodes = [];
      bool isPages = false;
      final videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);

      // part -> playall -> season
      if (skipPages.not && (videoDetail.value.pages?.length ?? 0) > 1) {
        isPages = true;
        final List<Part> pages = videoDetail.value.pages!;
        episodes.addAll(pages);
      } else if (videoDetailCtr.isPlayAll) {
        episodes.addAll(videoDetailCtr.mediaList);
      } else if (videoDetail.value.ugcSeason != null) {
        final UgcSeason ugcSeason = videoDetail.value.ugcSeason!;
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
            videoDetailCtr.showRelatedVideo) {
          return playRelated();
        }
        return false;
      }

      final int currentIndex = episodes.indexWhere((e) =>
          e.cid ==
          (skipPages
              ? videoDetail.value.pages!.first.cid
              : videoDetailCtr.cid.value));
      int nextIndex = currentIndex + 1;

      if (isPages.not &&
          videoDetailCtr.isPlayAll &&
          currentIndex == episodes.length - 2) {
        videoDetailCtr.getMediaList();
      }

      // 列表循环
      if (nextIndex >= episodes.length) {
        if (isPages &&
            (videoDetailCtr.isPlayAll || videoDetail.value.ugcSeason != null)) {
          return nextPlay(true);
        }

        if (playRepeat == PlayRepeat.listCycle) {
          nextIndex = 0;
        } else if (playRepeat == PlayRepeat.autoPlayRelated &&
            videoDetailCtr.showRelatedVideo) {
          return playRelated();
        } else {
          return false;
        }
      }

      int cid = episodes[nextIndex].cid!;

      while (cid == -1) {
        SmartDialog.showToast('当前视频暂不支持播放，自动跳过');
        nextIndex++;
        if (nextIndex >= episodes.length) {
          return false;
        }
        cid = episodes[nextIndex].cid!;
      }

      final String rBvid = isPages ? bvid : episodes[nextIndex].bvid;
      final int rAid = isPages ? IdUtils.bv2av(bvid) : episodes[nextIndex].aid!;
      changeSeasonOrbangu(null, rBvid, cid, rAid, null);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool playRelated() {
    late RelatedController relatedCtr;
    try {
      relatedCtr = Get.find<RelatedController>(tag: heroTag);
      if (relatedCtr.loadingState.value is! Success) {
        return false;
      }
      if ((relatedCtr.loadingState.value as Success).response.isEmpty == true) {
        SmartDialog.showToast('暂无相关视频，停止连播');
        return false;
      }
    } catch (_) {
      relatedCtr = Get.put(RelatedController(), tag: heroTag);
      relatedCtr.queryData().then((value) {
        if (value['status']) {
          playRelated();
        }
      });
      return false;
    }

    final HotVideoItemModel videoItem =
        (relatedCtr.loadingState.value as Success).response[0];
    try {
      if (videoItem.cid != null) {
        changeSeasonOrbangu(
          null,
          videoItem.bvid,
          videoItem.cid,
          videoItem.aid,
          videoItem.pic,
        );
      } else {
        SearchHttp.ab2c(aid: videoItem.aid, bvid: videoItem.bvid).then(
          (cid) => Utils.toViewPage(
            'bvid=${videoItem.bvid}&cid=${videoItem.cid}',
            arguments: {
              'videoItem': videoItem,
              'heroTag': heroTag,
            },
            off: true,
          ),
        );
      }
    } catch (err) {
      SmartDialog.showToast(err.toString());
    }
    return true;
  }

  // ai总结
  Future aiConclusion() async {
    SmartDialog.showLoading(msg: '正在获取AI总结');
    final res = await VideoHttp.aiConclusion(
      bvid: bvid,
      cid: lastPlayCid.value,
      upMid: videoDetail.value.owner?.mid,
    );
    SmartDialog.dismiss();
    if (res['status']) {
      modelResult = res['data'].modelResult;
    } else {
      SmartDialog.showToast("当前视频可能暂不支持AI视频总结");
    }
    return res;
  }

  // 收藏
  showFavBottomSheet(BuildContext context, {type = 'tap'}) {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    // 快速收藏 &
    // 点按 收藏至默认文件夹
    // 长按选择文件夹
    if (enableQuickFav) {
      if (type == 'tap') {
        actionFavVideo(type: 'default');
      } else {
        Utils.showFavBottomSheet(context: context, ctr: this);
      }
    } else if (type != 'longPress') {
      Utils.showFavBottomSheet(context: context, ctr: this);
    }
  }
}
