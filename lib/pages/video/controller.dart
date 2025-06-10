import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/common/search_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/media_list/data.dart';
import 'package:PiliPlus/models_new/media_list/media_list.dart';
import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_pbp/data.dart';
import 'package:PiliPlus/models_new/video/video_play_info/data.dart';
import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/medialist/view.dart';
import 'package:PiliPlus/pages/video/note/view.dart';
import 'package:PiliPlus/pages/video/post_panel/view.dart';
import 'package:PiliPlus/pages/video/send_danmaku/view.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:media_kit/media_kit.dart';

class VideoDetailController extends GetxController
    with GetTickerProviderStateMixin {
  /// 路由传参
  String bvid = Get.parameters['bvid']!;
  RxInt cid = int.parse(Get.parameters['cid']!).obs;
  RxInt danmakuCid = 0.obs;
  String heroTag = Get.arguments['heroTag'];
  // 视频详情
  RxMap videoItem = {}.obs;
  // 视频类型 默认投稿视频
  SearchType videoType = Get.arguments['videoType'] ?? SearchType.video;

  /// tabs相关配置
  late TabController tabCtr;

  // 请求返回的视频信息
  late PlayUrlModel data;
  Rx<LoadingState> videoState = LoadingState.loading().obs;

  /// 播放器配置 画质 音质 解码格式
  late VideoQuality currentVideoQa;
  AudioQuality? currentAudioQa;
  late VideoDecodeFormatType currentDecodeFormats;
  // 是否开始自动播放 存在多p的情况下，第二p需要为true
  RxBool autoPlay = true.obs;
  // 封面图的展示
  RxBool isShowCover = true.obs;

  RxInt oid = 0.obs;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final childKey = GlobalKey<ScaffoldState>();

  PlPlayerController plPlayerController = PlPlayerController.getInstance()
    ..setCurrBrightness(-1.0);

  late VideoItem firstVideo;
  late AudioItem firstAudio;
  String? videoUrl;
  String? audioUrl;
  Duration? defaultST;
  Duration? playedTime;
  // 亮度
  double? brightness;

  late final headerCtrKey = GlobalKey<HeaderControlState>();

  Box get setting => GStorage.setting;

  late String cacheDecode;
  late String cacheSecondDecode;

  bool get showReply => videoType == SearchType.video
      ? plPlayerController.showVideoReply
      : plPlayerController.showBangumiReply;

  int? seasonCid;
  late RxInt seasonIndex = 0.obs;

  PlayerStatus? playerStatus;
  StreamSubscription<Duration>? positionSubscription;

  late final scrollKey = GlobalKey<ExtendedNestedScrollViewState>();
  late RxString direction = 'horizontal'.obs;
  late final RxDouble scrollRatio = 0.0.obs;
  late final ScrollController scrollCtr = ScrollController()
    ..addListener(scrollListener);
  late bool isExpanding = false;
  late bool isCollapsing = false;
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final double minVideoHeight = Get.mediaQuery.size.shortestSide * 9 / 16;
  late final double maxVideoHeight = max(
    Get.mediaQuery.size.longestSide * 0.65,
    Get.mediaQuery.size.shortestSide,
  );
  late double videoHeight = minVideoHeight;

  void animToTop() {
    if (scrollKey.currentState?.outerController.hasClients == true) {
      scrollKey.currentState!.outerController.animateTo(
        scrollKey.currentState!.outerController.offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void setVideoHeight() {
    String direction = firstVideo.width != null && firstVideo.height != null
        ? firstVideo.width! > firstVideo.height!
            ? 'horizontal'
            : 'vertical'
        : 'horizontal';
    if (!scrollCtr.hasClients) {
      videoHeight = direction == 'vertical' ? maxVideoHeight : minVideoHeight;
      this.direction.value = direction;
      return;
    }
    if (this.direction.value != direction) {
      this.direction.value = direction;
      double videoHeight =
          direction == 'vertical' ? maxVideoHeight : minVideoHeight;
      if (this.videoHeight != videoHeight) {
        if (videoHeight > this.videoHeight) {
          // current minVideoHeight
          isExpanding = true;
          animationController.forward(
              from: (minVideoHeight - scrollCtr.offset) / maxVideoHeight);
          this.videoHeight = maxVideoHeight;
        } else {
          // current maxVideoHeight
          final currentHeight =
              (maxVideoHeight - scrollCtr.offset).toPrecision(2);
          double minVideoHeightPrecise = minVideoHeight.toPrecision(2);
          if (currentHeight == minVideoHeightPrecise) {
            isExpanding = true;
            this.videoHeight = minVideoHeight;
            animationController.forward(from: 1);
          } else if (currentHeight < minVideoHeightPrecise) {
            // expande
            isExpanding = true;
            animationController.forward(from: currentHeight / minVideoHeight);
            this.videoHeight = minVideoHeight;
          } else {
            // collapse
            isCollapsing = true;
            animationController.forward(
                from: scrollCtr.offset / (maxVideoHeight - minVideoHeight));
            this.videoHeight = minVideoHeight;
          }
        }
      }
    } else {
      if (scrollCtr.offset != 0) {
        isExpanding = true;
        animationController.forward(from: 1 - scrollCtr.offset / videoHeight);
      }
    }
  }

  void scrollListener() {
    if (scrollCtr.hasClients) {
      if (scrollCtr.offset == 0) {
        scrollRatio.value = 0;
      } else {
        double offset = scrollCtr.offset - (videoHeight - minVideoHeight);
        if (offset > 0) {
          scrollRatio.value = clampDouble(
            offset.toPrecision(2) /
                (minVideoHeight - kToolbarHeight).toPrecision(2),
            0.0,
            1.0,
          );
        } else {
          scrollRatio.value = 0;
        }
      }
    }
  }

  bool imageStatus = false;

  void onViewImage() {
    imageStatus = true;
  }

  void onDismissed(int _) {
    imageStatus = false;
  }

// 页面来源 稍后再看 收藏夹
  String sourceType = 'normal';
  late bool _mediaDesc = false;
  late RxList<MediaListItemModel> mediaList = <MediaListItemModel>[].obs;
  late String watchLaterTitle = '';
  bool get isPlayAll =>
      const ['watchLater', 'fav', 'archive', 'playlist'].contains(sourceType);
  int get _mediaType => switch (sourceType) {
        'archive' => 1,
        'watchLater' => 2,
        'fav' || 'playlist' => 3,
        _ => -1,
      };

  late dynamic epId = Get.parameters['epId'];
  late dynamic seasonId = Get.parameters['seasonId'];
  late dynamic subType = Get.parameters['type'];

  @override
  void onInit() {
    super.onInit();
    var keys = Get.arguments.keys.toList();
    if (keys.isNotEmpty) {
      if (keys.contains('videoItem')) {
        var args = Get.arguments['videoItem'];
        try {
          if (args.pic != null && args.pic != '') {
            videoItem['pic'] = args.pic;
          } else if (args.cover != null && args.cover != '') {
            videoItem['pic'] = args.cover;
          }
        } catch (_) {}
      }
      if (keys.contains('pic')) {
        videoItem['pic'] = Get.arguments['pic'];
      }
    }

    sourceType = Get.arguments['sourceType'] ?? 'normal';

    if (sourceType != 'normal') {
      watchLaterTitle = Get.arguments['favTitle'];
      _mediaDesc = Get.arguments['desc'];
      getMediaList();
    }

    bool defaultShowComment =
        setting.get(SettingBoxKey.defaultShowComment, defaultValue: false);
    tabCtr = TabController(
        length: 2, vsync: this, initialIndex: defaultShowComment ? 1 : 0);
    autoPlay.value =
        setting.get(SettingBoxKey.autoPlayEnable, defaultValue: false);
    if (autoPlay.value) isShowCover.value = false;
    danmakuCid.value = cid.value;

    // 预设的解码格式
    cacheDecode = setting.get(SettingBoxKey.defaultDecode,
        defaultValue: VideoDecodeFormatType.values.last.code);
    cacheSecondDecode = setting.get(SettingBoxKey.secondDecode,
        defaultValue: VideoDecodeFormatType.values[1].code);
    oid.value = IdUtils.bv2av(Get.parameters['bvid']!);
  }

  Future<void> getMediaList({
    bool isReverse = false,
    bool isLoadPrevious = false,
  }) async {
    if (!isReverse &&
        Get.arguments['count'] != null &&
        mediaList.length >= Get.arguments['count']) {
      return;
    }
    var res = await UserHttp.getMediaList(
      type: Get.arguments['mediaType'] ?? _mediaType,
      bizId: Get.arguments['mediaId'] ?? -1,
      ps: 20,
      direction: isLoadPrevious ? true : false,
      oid: isReverse
          ? null
          : mediaList.isEmpty
              ? Get.arguments['isContinuePlaying'] == true
                  ? Get.arguments['oid']
                  : null
              : isLoadPrevious
                  ? mediaList.first.aid
                  : mediaList.last.aid,
      otype: isReverse
          ? null
          : mediaList.isEmpty
              ? null
              : isLoadPrevious
                  ? mediaList.first.type
                  : mediaList.last.type,
      desc: _mediaDesc,
      sortField: Get.arguments['sortField'] ?? 1,
      withCurrent:
          mediaList.isEmpty && Get.arguments['isContinuePlaying'] == true
              ? true
              : false,
    );
    if (res['status']) {
      MediaListData data = res['data'];
      if (data.mediaList?.isNotEmpty == true) {
        if (isReverse) {
          mediaList.value = data.mediaList!;
          try {
            for (var item in mediaList) {
              if (item.cid != null) {
                Get.find<VideoIntroController>(tag: heroTag)
                    .changeSeasonOrbangu(
                  null,
                  item.bvid,
                  item.cid,
                  item.aid,
                  item.cover,
                );
                break;
              }
            }
          } catch (_) {}
        } else if (isLoadPrevious) {
          mediaList.insertAll(0, data.mediaList!);
        } else {
          mediaList.addAll(data.mediaList!);
        }
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 稍后再看面板展开
  void showMediaListPanel(BuildContext context) {
    if (mediaList.isNotEmpty) {
      Widget panel() => MediaListPanel(
            mediaList: mediaList,
            changeMediaList: (bvid, cid, aid, cover) {
              try {
                Get.find<VideoIntroController>(tag: heroTag)
                    .changeSeasonOrbangu(null, bvid, cid, aid, cover);
              } catch (_) {}
            },
            panelTitle: watchLaterTitle,
            getBvId: () => bvid,
            count: Get.arguments['count'],
            loadMoreMedia: getMediaList,
            desc: _mediaDesc,
            onReverse: () {
              _mediaDesc = !_mediaDesc;
              getMediaList(isReverse: true);
            },
            loadPrevious: Get.arguments['isContinuePlaying'] == true
                ? () => getMediaList(isLoadPrevious: true)
                : null,
            onDelete: sourceType == 'watchLater' ||
                    (sourceType == 'fav' && Get.arguments?['isOwner'] == true)
                ? (index) async {
                    if (sourceType == 'watchLater') {
                      var res = await UserHttp.toViewDel(
                        aids: [mediaList[index].aid],
                      );
                      if (res['status']) {
                        mediaList.removeAt(index);
                      }
                      SmartDialog.showToast(res['msg']);
                    } else {
                      final item = mediaList[index];
                      var res = await FavHttp.delFav(
                        ids: ['${item.aid}:${item.type}'],
                        delIds: '${Get.arguments?['mediaId']}',
                      );
                      if (res['status']) {
                        mediaList.removeAt(index);
                        SmartDialog.showToast('取消收藏');
                      } else {
                        SmartDialog.showToast(res['msg']);
                      }
                    }
                  }
                : null,
          );
      if (plPlayerController.isFullScreen.value || showVideoSheet) {
        PageUtils.showVideoBottomSheet(
          context,
          child: plPlayerController.darkVideoPage && MyApp.darkThemeData != null
              ? Theme(
                  data: MyApp.darkThemeData!,
                  child: panel(),
                )
              : panel(),
          isFullScreen: () => plPlayerController.isFullScreen.value,
        );
      } else {
        childKey.currentState?.showBottomSheet(
          backgroundColor: Colors.transparent,
          (context) => panel(),
        );
      }
    } else {
      getMediaList();
    }
  }

  bool get horizontalScreen => plPlayerController.horizontalScreen;
  bool get showVideoSheet =>
      !horizontalScreen && Get.context!.orientation == Orientation.landscape;

  int? _lastPos;
  List<PostSegmentModel>? postList;
  RxList<SegmentModel> segmentList = <SegmentModel>[].obs;
  List<Segment> viewPointList = <Segment>[];
  List<Segment>? segmentProgressList;
  Color _getColor(SegmentType segment) =>
      plPlayerController.blockColor[segment.index];
  late RxString videoLabel = ''.obs;
  String get blockServer => plPlayerController.blockServer;

  Timer? skipTimer;
  late final listKey = GlobalKey<AnimatedListState>();
  late final List listData = [];

  void _vote(String uuid, int type) {
    Request().post(
      '$blockServer/api/voteOnSponsorTime',
      queryParameters: {
        'UUID': uuid,
        'userID': GStorage.blockUserID,
        'type': type,
      },
    ).then((res) {
      SmartDialog.showToast(res.statusCode == 200 ? '投票成功' : '投票失败');
    });
  }

  void _showCategoryDialog(BuildContext context, SegmentModel segment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: SegmentType.values
                .map((item) => ListTile(
                      dense: true,
                      onTap: () {
                        Get.back();
                        Request().post(
                          '$blockServer/api/voteOnSponsorTime',
                          queryParameters: {
                            'UUID': segment.UUID,
                            'userID': GStorage.blockUserID,
                            'category': item.name,
                          },
                        ).then((res) {
                          SmartDialog.showToast(
                              '类别更改${res.statusCode == 200 ? '成功' : '失败'}');
                        });
                      },
                      title: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getColor(item),
                                ),
                              ),
                              style: const TextStyle(fontSize: 14, height: 1),
                            ),
                            TextSpan(
                              text: ' ${item.title}',
                              style: const TextStyle(fontSize: 14, height: 1),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showVoteDialog(BuildContext context, SegmentModel segment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                title: const Text(
                  '赞成票',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  _vote(segment.UUID, 1);
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  '反对票',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  _vote(segment.UUID, 0);
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  '更改类别',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  _showCategoryDialog(context, segment);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSBDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: segmentList
                .map(
                  (item) => ListTile(
                    onTap: () {
                      Get.back();
                      _showVoteDialog(context, item);
                    },
                    dense: true,
                    title: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getColor(item.segmentType),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14, height: 1),
                          ),
                          TextSpan(
                            text: ' ${item.segmentType.title}',
                            style: const TextStyle(fontSize: 14, height: 1),
                          ),
                        ],
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 16, right: 8),
                    subtitle: Text(
                      '${Utils.formatDuration(item.segment.first / 1000)} 至 ${Utils.formatDuration(item.segment.second / 1000)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.skipType.title,
                          style: const TextStyle(fontSize: 13),
                        ),
                        if (item.segment.second != 0)
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              tooltip: item.skipType == SkipType.showOnly
                                  ? '跳至此片段'
                                  : '跳过此片段',
                              onPressed: () {
                                Get.back();
                                onSkip(
                                  item,
                                  item.skipType != SkipType.showOnly,
                                );
                              },
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                item.skipType == SkipType.showOnly
                                    ? Icons.my_location
                                    : MdiIcons.debugStepOver,
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 10),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showBlockToast(String msg) {
    SmartDialog.showToast(
      msg,
      alignment: plPlayerController.isFullScreen.value
          ? const Alignment(0, 0.7)
          : null,
    );
  }

  Future<void> _querySponsorBlock() async {
    positionSubscription?.cancel();
    videoLabel.value = '';
    segmentList.clear();
    segmentProgressList = null;
    final result = await Request().get(
      '$blockServer/api/skipSegments',
      queryParameters: {
        'videoID': bvid,
        'cid': cid.value,
      },
    );
    if (result.statusCode == 200) {
      if (result.data case List list) {
        handleSBData(list.map((e) => SegmentItemModel.fromJson(e)).toList());
      }
    }
  }

  void handleSBData(List<SegmentItemModel> list) {
    if (list.isNotEmpty) {
      try {
        final duration = list.first.videoDuration ??
            plPlayerController.duration.value.inMilliseconds;
        // segmentList
        segmentList.addAll(list
            .where((item) =>
                plPlayerController.enableList.contains(item.category) &&
                item.segment[1] >= item.segment[0])
            .map(
          (item) {
            final segmentType = SegmentType.values.byName(item.category);
            if (item.segment[0] == 0 && item.segment[1] == 0) {
              videoLabel.value +=
                  '${videoLabel.value.isNotEmpty ? '/' : ''}${segmentType.title}';
            }
            var skipType =
                plPlayerController.blockSettings[segmentType.index].second;
            if (skipType != SkipType.showOnly) {
              if (item.segment[1] == item.segment[0] ||
                  item.segment[1] - item.segment[0] <
                      plPlayerController.blockLimit) {
                skipType = SkipType.showOnly;
              }
            }

            final segmentModel = SegmentModel(
              UUID: item.uuid,
              segmentType: segmentType,
              segment: Pair(
                first: item.segment[0],
                second: item.segment[1],
              ),
              skipType: skipType,
            );

            if (positionSubscription == null &&
                !isShowCover.value &&
                plPlayerController.videoPlayerController != null) {
              final currPost = plPlayerController.position.value.inMilliseconds;
              if (currPost > segmentModel.segment.first &&
                  currPost < segmentModel.segment.second) {
                if (segmentModel.skipType == SkipType.alwaysSkip) {
                  _lastPos = 0;
                  plPlayerController.videoPlayerController!.stream.buffer.first
                      .whenComplete(() {
                    onSkip(segmentModel);
                  });
                } else if (segmentModel.skipType == SkipType.skipOnce) {
                  _lastPos = 0;
                  segmentModel.hasSkipped = true;
                  plPlayerController.videoPlayerController!.stream.buffer.first
                      .whenComplete(() {
                    onSkip(segmentModel);
                  });
                } else if (segmentModel.skipType == SkipType.skipManually) {
                  onAddItem(segmentModel);
                }
              }
            }

            return segmentModel;
          },
        ).toList());

        // _segmentProgressList
        (segmentProgressList ??= <Segment>[]).addAll(segmentList.map((e) {
          double start = (e.segment.first / duration).clamp(0.0, 1.0);
          double end = (e.segment.second / duration).clamp(0.0, 1.0);
          return Segment(start, end, _getColor(e.segmentType));
        }).toList());

        if (positionSubscription == null &&
            (!isShowCover.value || plPlayerController.preInitPlayer)) {
          initSkip();
          plPlayerController.segmentList.value = segmentProgressList!;
        }
      } catch (e) {
        if (kDebugMode) debugPrint('failed to parse sponsorblock: $e');
      }
    }
  }

  void initSkip() {
    if (segmentList.isNotEmpty) {
      positionSubscription?.cancel();
      positionSubscription = plPlayerController
          .videoPlayerController?.stream.position
          .listen((position) {
        if (isShowCover.value) {
          return;
        }
        int currentPos = position.inSeconds;
        if (currentPos != _lastPos) {
          _lastPos = currentPos;
          final msPos = currentPos * 1000;
          for (SegmentModel item in segmentList) {
            // if (kDebugMode) {
            //   debugPrint(
            //       '${position.inSeconds},,${item.segment.first},,${item.segment.second},,${item.skipType.name},,${item.hasSkipped}');
            // }
            if (msPos <= item.segment.first &&
                item.segment.first <= msPos + 1000) {
              if (item.skipType == SkipType.alwaysSkip) {
                onSkip(item);
              } else if (item.skipType == SkipType.skipOnce &&
                  item.hasSkipped) {
                item.hasSkipped = true;
                onSkip(item);
              } else if (item.skipType == SkipType.skipManually) {
                onAddItem(item);
              }
              break;
            }
          }
        }
      });
    }
  }

  void onAddItem(dynamic item) {
    if (listData.contains(item)) return;
    listData.insert(0, item);
    listKey.currentState?.insertItem(0);
    skipTimer ??= Timer.periodic(const Duration(seconds: 4), (_) {
      if (listData.isNotEmpty) {
        onRemoveItem(listData.length - 1, listData.last);
      }
    });
  }

  void onRemoveItem(int index, item) {
    EasyThrottle.throttle('onRemoveItem', const Duration(milliseconds: 500),
        () {
      try {
        listData.removeAt(index);
        if (listData.isEmpty) {
          skipTimer?.cancel();
          skipTimer = null;
        }
        listKey.currentState?.removeItem(
          index,
          (context, animation) => buildItem(item, animation),
        );
      } catch (_) {}
    });
  }

  Widget buildItem(dynamic item, Animation<double> animation) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              if (details.delta.dx < 0) {
                onRemoveItem(listData.indexOf(item), item);
              }
            },
            child: SearchText(
              bgColor: Theme.of(Get.context!)
                  .colorScheme
                  .secondaryContainer
                  .withValues(alpha: 0.8),
              textColor:
                  Theme.of(Get.context!).colorScheme.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              fontSize: 14,
              text: item is SegmentModel
                  ? '跳过: ${item.segmentType.shortTitle}'
                  : '上次看到第${item + 1}P，点击跳转',
              onTap: (_) {
                if (item is int) {
                  try {
                    VideoIntroController videoIntroController =
                        Get.find<VideoIntroController>(tag: heroTag);
                    Part part =
                        videoIntroController.videoDetail.value.pages![item];
                    videoIntroController.changeSeasonOrbangu(
                      null,
                      bvid,
                      part.cid,
                      IdUtils.bv2av(bvid),
                      null,
                    );
                    SmartDialog.showToast('已跳至第${item + 1}P');
                  } catch (e) {
                    if (kDebugMode) debugPrint('$e');
                    SmartDialog.showToast('跳转失败');
                  }
                  onRemoveItem(listData.indexOf(item), item);
                } else if (item is SegmentModel) {
                  onSkip(item);
                  onRemoveItem(listData.indexOf(item), item);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSkip(SegmentModel item, [bool isSkip = true]) async {
    try {
      plPlayerController.danmakuController?.clear();
      await plPlayerController.videoPlayerController
          ?.seek(Duration(milliseconds: item.segment.second));
      if (isSkip) {
        if (GStorage.blockToast) {
          _showBlockToast('已跳过${item.segmentType.shortTitle}片段');
        }
        if (GStorage.blockTrack) {
          Request().post(
            '$blockServer/api/viewedVideoSponsorTime',
            queryParameters: {'UUID': item.UUID},
          );
        }
      } else {
        _showBlockToast('已跳至${item.segmentType.shortTitle}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('failed to skip: $e');
      if (isSkip) {
        _showBlockToast('${item.segmentType.shortTitle}片段跳过失败');
      } else {
        _showBlockToast('跳转失败');
      }
    }
  }

  ({int mode, int fontsize, Color color})? dmConfig;
  String? savedDanmaku;

  /// 发送弹幕
  Future<void> showShootDanmakuSheet() async {
    if (plPlayerController.dmState.contains(cid.value)) {
      SmartDialog.showToast('UP主已关闭弹幕');
      return;
    }
    bool isPlaying =
        plPlayerController.playerStatus.status.value == PlayerStatus.playing;
    if (isPlaying) {
      await plPlayerController.pause();
    }
    await Navigator.of(Get.context!).push(
      GetDialogRoute(
        pageBuilder: (buildContext, animation, secondaryAnimation) {
          return SendDanmakuPanel(
            cid: cid.value,
            bvid: bvid,
            progress: plPlayerController.position.value.inMilliseconds,
            initialValue: savedDanmaku,
            onSave: (danmaku) => savedDanmaku = danmaku,
            callback: (danmakuModel) {
              savedDanmaku = null;
              plPlayerController.danmakuController?.addDanmaku(danmakuModel);
            },
            darkVideoPage: plPlayerController.darkVideoPage,
            dmConfig: dmConfig,
            onSaveDmConfig: (dmConfig) => this.dmConfig = dmConfig,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.linear;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    if (isPlaying) {
      plPlayerController.play();
    }
  }

  /// 更新画质、音质
  void updatePlayer() {
    isShowCover.value = false;
    playedTime = plPlayerController.position.value;
    plPlayerController.removeListeners();
    plPlayerController.isBuffering.value = false;
    plPlayerController.buffered.value = Duration.zero;

    /// 根据currentVideoQa和currentDecodeFormats 重新设置videoUrl
    List<VideoItem> videoList =
        data.dash!.video!.where((i) => i.id == currentVideoQa.code).toList();

    final List supportDecodeFormats = videoList.map((e) => e.codecs!).toList();
    VideoDecodeFormatType defaultDecodeFormats =
        VideoDecodeFormatTypeExt.fromString(cacheDecode)!;
    VideoDecodeFormatType secondDecodeFormats =
        VideoDecodeFormatTypeExt.fromString(cacheSecondDecode)!;
    try {
      // 当前视频没有对应格式返回第一个
      int flag = 0;
      for (var i in supportDecodeFormats) {
        if (i.startsWith(currentDecodeFormats.code)) {
          flag = 1;
          break;
        } else if (i.startsWith(defaultDecodeFormats.code)) {
          flag = 2;
        } else if (i.startsWith(secondDecodeFormats.code)) {
          if (flag == 0) {
            flag = 4;
          }
        }
      }
      if (flag == 1) {
        //currentDecodeFormats
        firstVideo = videoList.firstWhere(
            (i) => i.codecs!.startsWith(currentDecodeFormats.code),
            orElse: () => videoList.first);
      } else {
        if (currentVideoQa == VideoQuality.dolbyVision) {
          currentDecodeFormats =
              VideoDecodeFormatTypeExt.fromString(videoList.first.codecs!)!;
          firstVideo = videoList.first;
        } else if (flag == 2) {
          //defaultDecodeFormats
          currentDecodeFormats = defaultDecodeFormats;
          firstVideo = videoList.firstWhere(
            (i) => i.codecs!.startsWith(defaultDecodeFormats.code),
            orElse: () => videoList.first,
          );
        } else if (flag == 4) {
          //secondDecodeFormats
          currentDecodeFormats = secondDecodeFormats;
          firstVideo = videoList.firstWhere(
            (i) => i.codecs!.startsWith(secondDecodeFormats.code),
            orElse: () => videoList.first,
          );
        } else if (flag == 0) {
          currentDecodeFormats =
              VideoDecodeFormatTypeExt.fromString(supportDecodeFormats.first)!;
          firstVideo = videoList.first;
        }
      }
    } catch (err) {
      SmartDialog.showToast('DecodeFormats error: $err');
    }

    videoUrl = firstVideo.baseUrl!;

    /// 根据currentAudioQa 重新设置audioUrl
    if (currentAudioQa != null) {
      final AudioItem firstAudio = data.dash!.audio!.firstWhere(
        (AudioItem i) => i.id == currentAudioQa!.code,
        orElse: () => data.dash!.audio!.first,
      );
      audioUrl = firstAudio.baseUrl ?? '';
    }

    playerInit();
  }

  Future<void> playerInit({
    String? video,
    String? audio,
    Duration? seekToTime,
    Duration? duration,
    bool? autoplay,
  }) async {
    await plPlayerController.setDataSource(
      DataSource(
        videoSource: plPlayerController.onlyPlayAudio.value
            ? audio ?? audioUrl
            : video ?? videoUrl,
        audioSource:
            plPlayerController.onlyPlayAudio.value ? '' : audio ?? audioUrl,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
          'referer': HttpString.baseUrl
        },
      ),
      segmentList: segmentProgressList,
      viewPointList: viewPointList,
      showVP: showVP,
      dmTrend: dmTrend,
      seekTo: seekToTime ?? defaultST ?? playedTime,
      duration: duration ??
          (data.timeLength == null
              ? null
              : Duration(milliseconds: data.timeLength!)),
      // 宽>高 水平 否则 垂直
      direction: direction.value,
      bvid: bvid,
      cid: cid.value,
      autoplay: autoplay ?? autoPlay.value,
      epid: videoType == SearchType.media_bangumi ? epId : null,
      seasonId: videoType == SearchType.media_bangumi ? seasonId : null,
      subType: videoType == SearchType.media_bangumi ? subType : null,
      callback: () {
        if (videoState.value is! Success) {
          videoState.value = const Success(null);
        }
        setSubtitle(vttSubtitlesIndex.value);
      },
      width: firstVideo.width,
      height: firstVideo.height,
    );

    initSkip();

    if (vttSubtitlesIndex.value == -1) {
      _getSubtitle();
    }

    if (plPlayerController.showDmChart && dmTrend == null) {
      _getDmTrend();
    }

    defaultST = null;
  }

  bool isQuerying = false;
  // 视频链接
  Future<void> queryVideoUrl([Duration? defaultST]) async {
    if (isQuerying) {
      return;
    }
    isQuerying = true;
    if (plPlayerController.enableSponsorBlock) {
      _querySponsorBlock();
    }
    if (plPlayerController.cacheVideoQa == null) {
      await Connectivity().checkConnectivity().then((res) {
        plPlayerController
          ..cacheVideoQa = res.contains(ConnectivityResult.wifi)
              ? setting.get(SettingBoxKey.defaultVideoQa,
                  defaultValue: VideoQuality.values.last.code)
              : setting.get(SettingBoxKey.defaultVideoQaCellular,
                  defaultValue: VideoQuality.high1080.code)
          ..cacheAudioQa = res.contains(ConnectivityResult.wifi)
              ? setting.get(SettingBoxKey.defaultAudioQa,
                  defaultValue: AudioQuality.hiRes.code)
              : setting.get(SettingBoxKey.defaultAudioQaCellular,
                  defaultValue: AudioQuality.k192.code);
      });
    }
    var result = await VideoHttp.videoUrl(
      cid: cid.value,
      bvid: bvid,
      epid: epId,
      seasonId: seasonId,
      forcePgcApi: Get.arguments?['pgcApi'] ?? false,
    );

    if (result['status']) {
      data = result['data'];

      if (data.acceptDesc?.contains('试看') == true) {
        SmartDialog.showToast(
          '该视频为专属视频，仅提供试看',
          displayTime: const Duration(seconds: 3),
        );
      }
      if (data.dash == null && data.durl != null) {
        videoUrl = data.durl!.first.url!;
        audioUrl = '';
        if (Get.arguments?['progress'] != null) {
          this.defaultST = Duration(milliseconds: Get.arguments['progress']);
          Get.arguments['progress'] = null;
        } else {
          this.defaultST = defaultST ?? Duration.zero;
        }
        // 实际为FLV/MP4格式，但已被淘汰，这里仅做兜底处理
        firstVideo = VideoItem(
            id: data.quality!,
            baseUrl: videoUrl,
            codecs: 'avc1',
            quality: VideoQuality.fromCode(data.quality!));
        setVideoHeight();
        currentDecodeFormats = VideoDecodeFormatTypeExt.fromString('avc1')!;
        currentVideoQa = VideoQuality.fromCode(data.quality!);
        if (autoPlay.value) {
          isShowCover.value = false;
          await playerInit();
        } else if (plPlayerController.preInitPlayer) {
          await playerInit();
        }
        isQuerying = false;
        return;
      }
      if (data.dash == null) {
        SmartDialog.showToast('视频资源不存在');
        autoPlay.value = false;
        isShowCover.value = true;
        videoState.value = const Error('视频资源不存在');
        if (plPlayerController.isFullScreen.value) {
          plPlayerController.toggleFullScreen(false);
        }
        isQuerying = false;
        return;
      }
      final List<VideoItem> allVideosList = data.dash!.video!;
      // if (kDebugMode) debugPrint("allVideosList:${allVideosList}");
      // 当前可播放的最高质量视频
      int currentHighVideoQa = allVideosList.first.quality.code;
      // 预设的画质为null，则当前可用的最高质量
      int resVideoQa = currentHighVideoQa;
      if (plPlayerController.cacheVideoQa! <= currentHighVideoQa) {
        // 如果预设的画质低于当前最高
        final List<int> numbers =
            data.acceptQuality!.where((e) => e <= currentHighVideoQa).toList();
        resVideoQa =
            Utils.findClosestNumber(plPlayerController.cacheVideoQa!, numbers);
      }
      currentVideoQa = VideoQuality.fromCode(resVideoQa);

      /// 取出符合当前画质的videoList
      final List<VideoItem> videosList =
          allVideosList.where((e) => e.quality.code == resVideoQa).toList();

      /// 优先顺序 设置中指定解码格式 -> 当前可选的首个解码格式
      final List<FormatItem> supportFormats = data.supportFormats!;
      // 根据画质选编码格式
      final List supportDecodeFormats = supportFormats
          .firstWhere((e) => e.quality == resVideoQa,
              orElse: () => supportFormats.first)
          .codecs!;
      // 默认从设置中取AV1
      currentDecodeFormats = VideoDecodeFormatTypeExt.fromString(cacheDecode)!;
      VideoDecodeFormatType secondDecodeFormats =
          VideoDecodeFormatTypeExt.fromString(cacheSecondDecode)!;
      // 当前视频没有对应格式返回第一个
      int flag = 0;
      for (var i in supportDecodeFormats) {
        if (i.startsWith(currentDecodeFormats.code)) {
          flag = 1;
          break;
        } else if (i.startsWith(secondDecodeFormats.code)) {
          flag = 2;
        }
      }
      if (flag == 2) {
        currentDecodeFormats = secondDecodeFormats;
      } else if (flag == 0) {
        currentDecodeFormats =
            VideoDecodeFormatTypeExt.fromString(supportDecodeFormats.first)!;
      }

      /// 取出符合当前解码格式的videoItem
      firstVideo = videosList.firstWhere(
          (e) => e.codecs!.startsWith(currentDecodeFormats.code),
          orElse: () => videosList.first);
      setVideoHeight();

      videoUrl = VideoUtils.getCdnUrl(firstVideo);

      /// 优先顺序 设置中指定质量 -> 当前可选的最高质量
      late AudioItem? firstAudio;
      final List<AudioItem> audiosList = data.dash!.audio ?? <AudioItem>[];
      if (data.dash!.dolby?.audio != null &&
          data.dash!.dolby!.audio!.isNotEmpty) {
        // 杜比
        audiosList.insert(0, data.dash!.dolby!.audio!.first);
      }

      if (data.dash!.flac?.audio != null) {
        // 无损
        audiosList.insert(0, data.dash!.flac!.audio!);
      }

      if (audiosList.isNotEmpty) {
        final List<int> numbers = audiosList.map((map) => map.id!).toList();
        int closestNumber =
            Utils.findClosestNumber(plPlayerController.cacheAudioQa, numbers);
        if (!numbers.contains(plPlayerController.cacheAudioQa) &&
            numbers.any((e) => e > plPlayerController.cacheAudioQa)) {
          closestNumber = 30280;
        }
        firstAudio = audiosList.firstWhere((e) => e.id == closestNumber,
            orElse: () => audiosList.first);
        audioUrl = VideoUtils.getCdnUrl(firstAudio);
        if (firstAudio.id != null) {
          currentAudioQa = AudioQuality.fromCode(firstAudio.id!);
        }
      } else {
        firstAudio = AudioItem();
        audioUrl = '';
      }
      //
      if (Get.arguments?['progress'] != null) {
        this.defaultST = Duration(milliseconds: Get.arguments['progress']);
        Get.arguments['progress'] = null;
      } else {
        this.defaultST =
            defaultST ?? Duration(milliseconds: data.lastPlayTime!);
      }
      if (autoPlay.value) {
        isShowCover.value = false;
        await playerInit();
      } else if (plPlayerController.preInitPlayer) {
        await playerInit();
      }
    } else {
      autoPlay.value = false;
      isShowCover.value = true;
      videoState.value = Error(result['msg']);
      if (plPlayerController.isFullScreen.value) {
        plPlayerController.toggleFullScreen(false);
      }
      if (result['code'] == -404) {
        SmartDialog.showToast('视频不存在或已被删除');
      }
      if (result['code'] == 87008) {
        SmartDialog.showToast("当前视频可能是专属视频，可能需包月充电观看(${result['msg']})");
      } else {
        SmartDialog.showToast("错误（${result['code']}）：${result['msg']}");
      }
    }
    isQuerying = false;
  }

  void onBlock(BuildContext context) {
    postList ??= <PostSegmentModel>[];
    if (postList!.isEmpty) {
      postList!.add(
        PostSegmentModel(
          segment: Pair(
            first: 0,
            second: plPlayerController.position.value.inMilliseconds / 1000,
          ),
          category: SegmentType.sponsor,
          actionType: ActionType.skip,
        ),
      );
    }
    if (plPlayerController.isFullScreen.value || showVideoSheet) {
      PageUtils.showVideoBottomSheet(
        context,
        child: plPlayerController.darkVideoPage && MyApp.darkThemeData != null
            ? Theme(
                data: MyApp.darkThemeData!,
                child: PostPanel(
                  enableSlide: false,
                  videoDetailController: this,
                  plPlayerController: plPlayerController,
                ),
              )
            : PostPanel(
                enableSlide: false,
                videoDetailController: this,
                plPlayerController: plPlayerController,
              ),
        isFullScreen: () => plPlayerController.isFullScreen.value,
      );
    } else {
      childKey.currentState?.showBottomSheet(
        backgroundColor: Colors.transparent,
        (context) => PostPanel(
          videoDetailController: this,
          plPlayerController: plPlayerController,
        ),
      );
    }
  }

  RxList<Subtitle> subtitles = RxList<Subtitle>();
  late final Map<int, String> _vttSubtitles = {};
  late final RxInt vttSubtitlesIndex = (-1).obs;
  late bool showVP = true;

  void _getSubtitle() {
    _vttSubtitles.clear();
    viewPointList.clear();
    _queryPlayInfo();
  }

  // 设定字幕轨道
  Future<void> setSubtitle(int index) async {
    if (index <= 0) {
      plPlayerController.videoPlayerController
          ?.setSubtitleTrack(SubtitleTrack.no());
      vttSubtitlesIndex.value = index;
      return;
    }

    void setSub(subtitle) {
      plPlayerController.videoPlayerController?.setSubtitleTrack(
        SubtitleTrack.data(
          subtitle,
          title: subtitles[index - 1].lanDoc,
          language: subtitles[index - 1].lan,
        ),
      );
      vttSubtitlesIndex.value = index;
    }

    String? subtitle = _vttSubtitles[index - 1];
    if (subtitle != null) {
      setSub(subtitle);
    } else {
      var result =
          await VideoHttp.vttSubtitles(subtitles[index - 1].subtitleUrl!);
      if (result != null) {
        _vttSubtitles[index - 1] = result;
        setSub(result);
      }
    }
  }

  // interactive video
  int? graphVersion;
  EdgeInfoData? steinEdgeInfo;
  late final RxBool showSteinEdgeInfo = false.obs;
  Future<void> getSteinEdgeInfo([int? edgeId]) async {
    steinEdgeInfo = null;
    try {
      var res = await Request().get(
        '/x/stein/edgeinfo_v2',
        queryParameters: {
          'bvid': bvid,
          'graph_version': graphVersion,
          if (edgeId != null) 'edge_id': edgeId,
        },
      );
      if (res.data['code'] == 0) {
        steinEdgeInfo = EdgeInfoData.fromJson(res.data['data']);
      } else {
        if (kDebugMode) {
          debugPrint('getSteinEdgeInfo error: ${res.data['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('getSteinEdgeInfo: $e');
    }
  }

  late bool continuePlayingPart = GStorage.continuePlayingPart;

  Future<void> _queryPlayInfo() async {
    var res = await VideoHttp.playInfo(bvid: bvid, cid: cid.value);
    if (res['status']) {
      PlayInfoData playInfo = res['data'];
      // interactive video
      if (graphVersion == null) {
        try {
          final introCtr = Get.find<VideoIntroController>(tag: heroTag);
          if (introCtr.videoDetail.value.rights?.isSteinGate == 1) {
            graphVersion = playInfo.interaction?.graphVersion;
            getSteinEdgeInfo();
          }
        } catch (e) {
          if (kDebugMode) debugPrint('handle stein: $e');
        }
      }

      if (continuePlayingPart) {
        continuePlayingPart = false;
        try {
          VideoIntroController videoIntroController =
              Get.find<VideoIntroController>(tag: heroTag);
          if ((videoIntroController.videoDetail.value.pages?.length ?? 0) > 1 &&
              playInfo.lastPlayCid != null &&
              playInfo.lastPlayCid != 0) {
            if (playInfo.lastPlayCid != cid.value) {
              int index = videoIntroController.videoDetail.value.pages!
                  .indexWhere((item) => item.cid == playInfo.lastPlayCid);
              if (index != -1) {
                onAddItem(index);
              }
            }
          }
        } catch (_) {}
      }

      if (playInfo.viewPoints?.isNotEmpty == true && GStorage.showViewPoints) {
        try {
          viewPointList = playInfo.viewPoints!.map((item) {
            double start =
                (item.to! / (data.timeLength! / 1000)).clamp(0.0, 1.0);
            return Segment(
              start,
              start,
              Colors.black.withValues(alpha: 0.5),
              item.content,
              item.imgUrl,
              item.from,
              item.to,
            );
          }).toList();
          if (plPlayerController.viewPointList.isEmpty) {
            plPlayerController.viewPointList.value = viewPointList;
            plPlayerController.showVP.value = showVP = true;
          }
        } catch (_) {}
      }

      if (playInfo.subtitle?.subtitles?.isNotEmpty == true) {
        int idx = 0;
        subtitles.value = playInfo.subtitle!.subtitles!;

        String preference = GStorage.defaultSubtitlePreference;
        if (preference != 'off') {
          idx = subtitles.indexWhere((i) => !i.lan!.startsWith('ai')) + 1;
          if (idx == 0) {
            if (preference == 'on' ||
                (preference == 'auto' &&
                    (await FlutterVolumeController.getVolume() ?? 0) <= 0)) {
              idx = 1;
            }
          }
        }
        setSubtitle(idx);
      }
    }
  }

  void updateMediaListHistory(int aid) {
    if (Get.arguments?['sortField'] != null) {
      VideoHttp.medialistHistory(
        desc: _mediaDesc ? 1 : 0,
        oid: aid,
        upperMid: Get.arguments?['mediaId'],
      );
    }
  }

  void makeHeartBeat() {
    if (plPlayerController.enableHeart &&
        plPlayerController.playerStatus.status.value !=
            PlayerStatus.completed &&
        playedTime != null) {
      try {
        plPlayerController.makeHeartBeat(
          data.timeLength != null
              ? (data.timeLength! - playedTime!.inMilliseconds).abs() <= 1000
                  ? -1
                  : playedTime!.inSeconds
              : playedTime!.inSeconds,
          type: 'status',
          isManual: true,
          bvid: bvid,
          cid: cid.value,
          epid: videoType == SearchType.media_bangumi ? epId : null,
          seasonId: videoType == SearchType.media_bangumi ? seasonId : null,
          subType: videoType == SearchType.media_bangumi ? subType : null,
        );
      } catch (_) {}
    }
  }

  @override
  void onClose() {
    tabCtr.dispose();
    scrollCtr
      ..removeListener(scrollListener)
      ..dispose();
    animationController.dispose();
    super.onClose();
  }

  void onReset([bool? isStein]) {
    playedTime = null;
    videoUrl = null;
    audioUrl = null;

    if (scrollRatio.value != 0) {
      scrollRatio.refresh();
    }

    // danmaku
    dmTrend = null;
    savedDanmaku = null;

    // subtitle
    subtitles.clear();
    vttSubtitlesIndex.value = -1;
    _vttSubtitles.clear();

    // view point
    viewPointList.clear();

    // sponsor block
    if (plPlayerController.enableSponsorBlock) {
      positionSubscription?.cancel();
      positionSubscription = null;
      videoLabel.value = '';
      segmentList.clear();
      segmentProgressList = null;
    }

    // interactive video
    if (isStein != true) {
      graphVersion = null;
    }
    steinEdgeInfo = null;
    showSteinEdgeInfo.value = false;
  }

  List<double>? dmTrend;

  Future<void> _getDmTrend() async {
    dmTrend = null;
    try {
      var res = await Request().get(
        'https://bvc.bilivideo.com/pbp/data',
        queryParameters: {
          'bvid': bvid,
          'cid': cid.value,
        },
      );

      PbpData data = PbpData.fromJson(res.data);
      int stepSec = data.stepSec ?? 0;
      if (stepSec != 0 && data.events?.eDefault?.isNotEmpty == true) {
        dmTrend = data.events?.eDefault;
        if (plPlayerController.dmTrend.isEmpty) {
          plPlayerController.dmTrend.value = dmTrend!;
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('_getDmTrend: $e');
    }
  }

  void showNoteList(BuildContext context) {
    String? title;
    try {
      title =
          Get.find<VideoIntroController>(tag: heroTag).videoDetail.value.title;
    } catch (_) {}
    if (plPlayerController.isFullScreen.value || showVideoSheet) {
      PageUtils.showVideoBottomSheet(
        context,
        child: plPlayerController.darkVideoPage && MyApp.darkThemeData != null
            ? Theme(
                data: MyApp.darkThemeData!,
                child: NoteListPage(
                  oid: oid.value,
                  enableSlide: false,
                  heroTag: heroTag,
                  isStein: graphVersion != null,
                  title: title,
                ),
              )
            : NoteListPage(
                oid: oid.value,
                enableSlide: false,
                heroTag: heroTag,
                isStein: graphVersion != null,
                title: title,
              ),
        isFullScreen: () => plPlayerController.isFullScreen.value,
      );
    } else {
      childKey.currentState?.showBottomSheet(
        backgroundColor: Colors.transparent,
        (context) => NoteListPage(
          oid: oid.value,
          heroTag: heroTag,
          isStein: graphVersion != null,
          title: title,
        ),
      );
    }
  }
}
