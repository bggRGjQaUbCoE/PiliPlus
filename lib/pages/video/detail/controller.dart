import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/segment_progress_bar.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/video/later.dart';
import 'package:PiliPlus/models/video_detail_res.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/video/detail/introduction/controller.dart';
import 'package:PiliPlus/pages/video/detail/note/note_list_page.dart';
import 'package:PiliPlus/pages/video/detail/post_panel/post_panel.dart';
import 'package:PiliPlus/pages/video/detail/widgets/send_danmaku_panel.dart';
import 'package:PiliPlus/pages/video/detail/widgets/media_list_panel.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/search_type.dart';
import 'package:PiliPlus/models/video/play/quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/plugin/pl_player/index.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';

import '../../../utils/id_utils.dart';
import 'widgets/header_control.dart';

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
  late VideoDecodeFormats currentDecodeFormats;
  // 是否开始自动播放 存在多p的情况下，第二p需要为true
  RxBool autoPlay = true.obs;
  // 封面图的展示
  RxBool isShowCover = true.obs;
  // 硬解
  RxBool enableHA = true.obs;
  RxString hwdec = GStorage.hardwareDecoding.obs;

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
  // 默认记录历史记录
  bool enableHeart = true;
  Floating? floating;
  late final headerCtrKey = GlobalKey<HeaderControlState>();
  late PreferredSizeWidget headerControl;

  Box get setting => GStorage.setting;

  // late bool enableCDN;
  int? cacheVideoQa;
  late String cacheDecode;
  late String cacheSecondDecode;
  late int cacheAudioQa;

  late final showRelatedVideo = GStorage.showRelatedVideo;

  late final _showVideoReply = GStorage.showVideoReply;
  late final _showBangumiReply = GStorage.showBangumiReply;
  bool get showReply =>
      videoType == SearchType.video ? _showVideoReply : _showBangumiReply;

  late final preInitPlayer = GStorage.preInitPlayer;
  late final horizontalSeasonPanel = GStorage.horizontalSeasonPanel;
  int? seasonCid;
  late RxInt seasonIndex = 0.obs;
  late final reverseFromFirst = GStorage.reverseFromFirst;

  late final bool enableSponsorBlock;
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
  late final double minVideoHeight = min(Get.height, Get.width) * 9 / 16;
  late final double maxVideoHeight =
      max(max(Get.height, Get.width) * 0.65, min(Get.height, Get.width));
  late double videoHeight = minVideoHeight;

  void setVideoHeight() {
    String direction = firstVideo.width != null && firstVideo.height != null
        ? firstVideo.width! > firstVideo.height!
            ? 'horizontal'
            : 'vertical'
        : 'horizontal';
    if (GStorage.collapsibleVideoPage.not) {
      this.direction.value = direction;
      return;
    }
    if (scrollCtr.hasClients.not) {
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

  void onDismissed(value) {
    imageStatus = false;
  }

  late final horizontalPreview = GStorage.horizontalPreview;

// 页面来源 稍后再看 收藏夹
  String sourceType = 'normal';
  late bool _mediaDesc = false;
  late RxList<MediaVideoItemModel> mediaList = <MediaVideoItemModel>[].obs;
  late String watchLaterTitle = '';
  bool get isPlayAll => ['watchLater', 'fav', 'archive'].contains(sourceType);
  int get _mediaType => switch (sourceType) {
        'archive' => 1,
        'watchLater' => 2,
        'fav' => 3,
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
    enableHA.value = setting.get(SettingBoxKey.enableHA, defaultValue: true);
    if (!Accounts.get(AccountType.heartbeat).isLogin ||
        GStorage.localCache.get(LocalCacheKey.historyPause) == true) {
      enableHeart = false;
    }
    danmakuCid.value = cid.value;

    ///
    if (Platform.isAndroid) {
      floating = Floating();
    }
    headerControl = HeaderControl(
      key: headerCtrKey,
      controller: plPlayerController,
      videoDetailCtr: this,
      floating: floating,
      heroTag: heroTag,
    );

    // CDN优化
    // enableCDN = setting.get(SettingBoxKey.enableCDN, defaultValue: true);

    // 预设的解码格式
    cacheDecode = setting.get(SettingBoxKey.defaultDecode,
        defaultValue: VideoDecodeFormats.values.last.code);
    cacheSecondDecode = setting.get(SettingBoxKey.secondDecode,
        defaultValue: VideoDecodeFormats.values[1].code);
    oid.value = IdUtils.bv2av(Get.parameters['bvid']!);
    enableSponsorBlock =
        setting.get(SettingBoxKey.enableSponsorBlock, defaultValue: false);
    if (enableSponsorBlock) {
      _blockLimit = GStorage.blockLimit;
      _blockSettings = GStorage.blockSettings;
      _blockColor = GStorage.blockColor;
    }
  }

  void getMediaList({
    bool isReverse = false,
    bool isLoadPrevious = false,
  }) async {
    if (isReverse.not &&
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
                  ? mediaList.first.id
                  : mediaList.last.id,
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
      if (res['data'].isNotEmpty) {
        if (isReverse) {
          mediaList.value = res['data'];
          try {
            for (MediaVideoItemModel item in mediaList) {
              if (item.cid == null) {
                continue;
              } else {
                Get.find<VideoIntroController>(tag: heroTag)
                    .changeSeasonOrbangu(
                  null,
                  mediaList.first.bvid,
                  mediaList.first.cid,
                  mediaList.first.aid,
                  mediaList.first.cover,
                );
              }
            }
          } catch (_) {}
        } else if (isLoadPrevious) {
          mediaList.insertAll(0, res['data']);
        } else {
          mediaList.addAll(res['data']);
        }
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 稍后再看面板展开
  showMediaListPanel(context) {
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
                ? () {
                    getMediaList(isLoadPrevious: true);
                  }
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
                      var res = await VideoHttp.delFav(
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
      if (plPlayerController.isFullScreen.value) {
        Utils.showFSSheet(
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

  int? _lastPos;
  double? _blockLimit;
  List<Pair<SegmentType, SkipType>>? _blockSettings;
  List<Color>? _blockColor;
  RxList<SegmentModel> segmentList = <SegmentModel>[].obs;
  List<Segment> viewPointList = <Segment>[];
  List<Segment>? segmentProgressList;
  Color _getColor(SegmentType segment) =>
      _blockColor?[segment.index] ?? segment.color;
  late RxString videoLabel = ''.obs;

  Timer? skipTimer;
  late final listKey = GlobalKey<AnimatedListState>();
  late final List listData = [];

  Future _vote(String uuid, int type) async {
    Request().post(
      '${GStorage.blockServer}/api/voteOnSponsorTime',
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
                          '${GStorage.blockServer}/api/voteOnSponsorTime',
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
                              style: TextStyle(fontSize: 14, height: 1),
                            ),
                            TextSpan(
                              text: ' ${item.title}',
                              style: TextStyle(fontSize: 14, height: 1),
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
                title: Text(
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
                title: Text(
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
                title: Text(
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
                            style: TextStyle(fontSize: 14, height: 1),
                          ),
                          TextSpan(
                            text: ' ${item.segmentType.title}',
                            style: TextStyle(fontSize: 14, height: 1),
                          ),
                        ],
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 16, right: 8),
                    subtitle: Text(
                      '${Utils.formatDuration(item.segment.first)} 至 ${Utils.formatDuration(item.segment.second)}',
                      style: TextStyle(fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.skipType.title,
                          style: TextStyle(fontSize: 13),
                        ),
                        if (item.skipType == SkipType.showOnly &&
                            item.segment.second != 0)
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              tooltip: '跳转至此片段',
                              onPressed: () async {
                                Get.back();
                                try {
                                  plPlayerController.danmakuController?.clear();
                                  await plPlayerController.videoPlayerController
                                      ?.seek(Duration(
                                          seconds: item.segment.first));
                                  if (GStorage.blockToast) {
                                    _showBlockToast(
                                        '已跳至${item.segmentType.shortTitle}');
                                  }
                                } catch (e) {
                                  _showBlockToast('跳转失败: $e');
                                }
                              },
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                Icons.my_location,
                                size: 18,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.7),
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
      alignment:
          plPlayerController.isFullScreen.value ? Alignment(0, 0.7) : null,
    );
  }

  Future _querySponsorBlock() async {
    positionSubscription?.cancel();
    videoLabel.value = '';
    segmentList.clear();
    segmentProgressList = null;
    dynamic result = await Request().get(
      '${GStorage.blockServer}/api/skipSegments',
      queryParameters: {
        'videoID': bvid,
        'cid': cid.value,
      },
    );
    handleSBData(result);
  }

  void handleSBData(result) {
    if (result.data is List && result.data.isNotEmpty) {
      try {
        List<String> list =
            SegmentType.values.map((item) => item.name).toList();
        List<String> enableList = _blockSettings!
            .where((item) => item.second != SkipType.disable)
            .toList()
            .map((item) => item.first.name)
            .toList();

        // segmentList
        segmentList.addAll((result.data as List)
            .where((item) =>
                enableList.contains(item['category']) &&
                item['segment'][1] >= item['segment'][0])
            .map(
          (item) {
            SegmentType segmentType =
                SegmentType.values[list.indexOf(item['category'])];
            if (item['segment'][0] == 0 && item['segment'][1] == 0) {
              videoLabel.value +=
                  '${videoLabel.value.isNotEmpty ? '/' : ''}${segmentType.title}';
            }
            SkipType skipType = _blockSettings![segmentType.index].second;
            if (skipType != SkipType.showOnly) {
              if (item['segment'][1] == item['segment'][0] ||
                  item['segment'][1] - item['segment'][0] < _blockLimit) {
                skipType = SkipType.showOnly;
              }
            }
            int convert(value) {
              return switch (value) {
                int() => value,
                double() => value.round(),
                _ => -1,
              };
            }

            return SegmentModel(
              UUID: item['UUID'],
              segmentType: segmentType,
              segment: Pair(
                first: convert(item['segment'][0]),
                second: convert(item['segment'][1]),
              ),
              skipType: skipType,
            );
          },
        ).toList());

        // _segmentProgressList
        segmentProgressList ??= <Segment>[];
        segmentProgressList!.addAll(segmentList.map((item) {
          double start = (item.segment.first / ((data.timeLength ?? 0) / 1000))
              .clamp(0.0, 1.0);
          double end = (item.segment.second / ((data.timeLength ?? 0) / 1000))
              .clamp(0.0, 1.0);
          return Segment(start, end, _getColor(item.segmentType));
        }).toList());
      } catch (e) {
        debugPrint('failed to parse sponsorblock: $e');
      }
    }
  }

  void initSkip() {
    if (segmentList.isNotEmpty) {
      positionSubscription = plPlayerController
          .videoPlayerController?.stream.position
          .listen((position) async {
        if (isShowCover.value) {
          return;
        }
        int currentPos = position.inSeconds;
        if (currentPos != _lastPos) {
          _lastPos = currentPos;
          for (SegmentModel item in segmentList) {
            // debugPrint(
            //     '${position.inSeconds},,${item.segment.first},,${item.segment.second},,${item.skipType.name},,${item.hasSkipped}');
            if (item.segment.first == position.inSeconds) {
              if (item.skipType == SkipType.alwaysSkip) {
                onSkip(item);
              } else if (item.skipType == SkipType.skipOnce &&
                  item.hasSkipped != true) {
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

  void onAddItem(item) {
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

  Widget buildItem(item, Animation<double> animation) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(-1, 0),
          end: Offset(0, 0),
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
                  .withOpacity(0.8),
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
                    debugPrint('$e');
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

  void onSkip(SegmentModel item) async {
    try {
      plPlayerController.danmakuController?.clear();
      await plPlayerController.videoPlayerController
          ?.seek(Duration(seconds: item.segment.second));
      if (GStorage.blockToast) {
        _showBlockToast('已跳过${item.segmentType.shortTitle}片段');
      }
      if (GStorage.blockTrack) {
        Request().post(
          '${GStorage.blockServer}/api/viewedVideoSponsorTime',
          queryParameters: {'UUID': item.UUID},
        );
      }
    } catch (e) {
      debugPrint('failed to skip: $e');
      _showBlockToast('${item.segmentType.shortTitle}片段跳过失败');
    }
  }

  String? savedDanmaku;

  /// 发送弹幕
  void showShootDanmakuSheet() async {
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
            callback: (danmakuModel) async {
              savedDanmaku = null;
              plPlayerController.danmakuController?.addDanmaku(danmakuModel);
            },
            darkVideoPage: plPlayerController.darkVideoPage,
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
  /// TODO 继续进度播放
  updatePlayer() {
    isShowCover.value = false;
    playedTime = plPlayerController.position.value;
    plPlayerController.removeListeners();
    plPlayerController.isBuffering.value = false;
    plPlayerController.buffered.value = Duration.zero;

    /// 根据currentVideoQa和currentDecodeFormats 重新设置videoUrl
    List<VideoItem> videoList =
        data.dash!.video!.where((i) => i.id == currentVideoQa.code).toList();

    final List supportDecodeFormats = videoList.map((e) => e.codecs!).toList();
    VideoDecodeFormats defaultDecodeFormats =
        VideoDecodeFormatsCode.fromString(cacheDecode)!;
    VideoDecodeFormats secondDecodeFormats =
        VideoDecodeFormatsCode.fromString(cacheSecondDecode)!;
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
              VideoDecodeFormatsCode.fromString(videoList.first.codecs!)!;
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
              VideoDecodeFormatsCode.fromString(supportDecodeFormats.first)!;
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

  Future playerInit({
    video,
    audio,
    seekToTime,
    duration,
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
      // 硬解
      enableHA: enableHA.value,
      hwdec: hwdec.value,
      seekTo: seekToTime ?? defaultST ?? playedTime,
      duration: duration ?? data.timeLength == null
          ? null
          : Duration(milliseconds: data.timeLength!),
      // 宽>高 水平 否则 垂直
      direction: direction.value,
      bvid: bvid,
      cid: cid.value,
      enableHeart: enableHeart,
      autoplay: autoplay ?? autoPlay.value,
      epid: videoType == SearchType.media_bangumi ? epId : null,
      seasonId: videoType == SearchType.media_bangumi ? seasonId : null,
      subType: videoType == SearchType.media_bangumi ? subType : null,
      callback: () {
        if (videoState.value is! Success) {
          videoState.value = LoadingState.success(null);
        }
        setSubtitle(vttSubtitlesIndex.value);
      },
    );

    initSkip();

    if (vttSubtitlesIndex.value == -1) {
      _getSubtitle();
    }

    if (showDmChart && dmTrend == null) {
      _getDmTrend();
    }

    /// 开启自动全屏时，在player初始化完成后立即传入headerControl
    plPlayerController.headerControl = headerControl;

    if (defaultST != null) {
      defaultST = null;
    }
  }

  bool isQuerying = false;
  // 视频链接
  Future queryVideoUrl([Duration? defaultST]) async {
    if (isQuerying) {
      return;
    }
    isQuerying = true;
    if (cacheVideoQa == null) {
      await Connectivity().checkConnectivity().then((res) {
        cacheVideoQa = res.contains(ConnectivityResult.wifi)
            ? setting.get(SettingBoxKey.defaultVideoQa,
                defaultValue: VideoQuality.values.last.code)
            : setting.get(SettingBoxKey.defaultVideoQaCellular,
                defaultValue: VideoQuality.high1080.code);

        cacheAudioQa = res.contains(ConnectivityResult.wifi)
            ? setting.get(SettingBoxKey.defaultAudioQa,
                defaultValue: AudioQuality.hiRes.code)
            : setting.get(SettingBoxKey.defaultAudioQaCellular,
                defaultValue: AudioQuality.k192.code);
      });
    }
    dynamic result = await VideoHttp.videoUrl(
      cid: cid.value,
      bvid: bvid,
      epid: epId,
      seasonId: seasonId,
      forcePgcApi: Get.arguments?['pgcApi'] ?? false,
    );
    if (result['status']) {
      data = result['data'];

      if (enableSponsorBlock) {
        await _querySponsorBlock();
      }

      if (data.acceptDesc!.isNotEmpty && data.acceptDesc!.contains('试看')) {
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
            quality: VideoQualityCode.fromCode(data.quality!)!);
        setVideoHeight();
        currentDecodeFormats = VideoDecodeFormatsCode.fromString('avc1')!;
        currentVideoQa = VideoQualityCode.fromCode(data.quality!)!;
        if (autoPlay.value) {
          isShowCover.value = false;
          await playerInit();
        } else if (preInitPlayer) {
          await playerInit();
        }
        isQuerying = false;
        return;
      }
      if (data.dash == null) {
        SmartDialog.showToast('视频资源不存在');
        autoPlay.value = false;
        isShowCover.value = true;
        videoState.value = LoadingState.error('视频资源不存在');
        isQuerying = false;
        return;
      }
      final List<VideoItem> allVideosList = data.dash!.video!;
      // debugPrint("allVideosList:${allVideosList}");
      // 当前可播放的最高质量视频
      int currentHighVideoQa = allVideosList.first.quality!.code;
      // 预设的画质为null，则当前可用的最高质量
      cacheVideoQa ??= currentHighVideoQa;
      int resVideoQa = currentHighVideoQa;
      if (cacheVideoQa! <= currentHighVideoQa) {
        // 如果预设的画质低于当前最高
        final List<int> numbers =
            data.acceptQuality!.where((e) => e <= currentHighVideoQa).toList();
        resVideoQa = Utils.findClosestNumber(cacheVideoQa!, numbers);
      }
      currentVideoQa = VideoQualityCode.fromCode(resVideoQa)!;

      /// 取出符合当前画质的videoList
      final List<VideoItem> videosList =
          allVideosList.where((e) => e.quality!.code == resVideoQa).toList();

      /// 优先顺序 设置中指定解码格式 -> 当前可选的首个解码格式
      final List<FormatItem> supportFormats = data.supportFormats!;
      // 根据画质选编码格式
      final List supportDecodeFormats = supportFormats
          .firstWhere((e) => e.quality == resVideoQa,
              orElse: () => supportFormats.first)
          .codecs!;
      // 默认从设置中取AV1
      currentDecodeFormats = VideoDecodeFormatsCode.fromString(cacheDecode)!;
      VideoDecodeFormats secondDecodeFormats =
          VideoDecodeFormatsCode.fromString(cacheSecondDecode)!;
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
            VideoDecodeFormatsCode.fromString(supportDecodeFormats.first)!;
      }

      /// 取出符合当前解码格式的videoItem
      firstVideo = videosList.firstWhere(
          (e) => e.codecs!.startsWith(currentDecodeFormats.code),
          orElse: () => videosList.first);
      setVideoHeight();

      // videoUrl = enableCDN
      //     ? VideoUtils.getCdnUrl(firstVideo)
      //     : (firstVideo.backupUrl ?? firstVideo.baseUrl!);
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
        int closestNumber = Utils.findClosestNumber(cacheAudioQa, numbers);
        if (!numbers.contains(cacheAudioQa) &&
            numbers.any((e) => e > cacheAudioQa)) {
          closestNumber = 30280;
        }
        firstAudio = audiosList.firstWhere((e) => e.id == closestNumber,
            orElse: () => audiosList.first);
        // audioUrl = enableCDN
        //     ? VideoUtils.getCdnUrl(firstAudio)
        //     : (firstAudio.backupUrl ?? firstAudio.baseUrl!);
        audioUrl = VideoUtils.getCdnUrl(firstAudio);
        if (firstAudio.id != null) {
          currentAudioQa = AudioQualityCode.fromCode(firstAudio.id!)!;
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
      } else if (preInitPlayer) {
        await playerInit();
      }
    } else {
      autoPlay.value = false;
      isShowCover.value = true;
      videoState.value = LoadingState.error(result['msg']);
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

  List<PostSegmentModel>? list;

  void onBlock(BuildContext context) {
    list ??= <PostSegmentModel>[];
    if (list!.isEmpty) {
      list!.add(
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
    if (plPlayerController.isFullScreen.value) {
      Utils.showFSSheet(
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

  RxList subtitles = RxList();
  late final Map<int, String> _vttSubtitles = {};
  late final RxInt vttSubtitlesIndex = (-1).obs;
  late bool showVP = true;

  void _getSubtitle() {
    _vttSubtitles.clear();
    viewPointList.clear();
    _querySubtitles();
  }

  // 设定字幕轨道
  setSubtitle(int index) async {
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
          title: subtitles[index - 1]['lan_doc'],
          language: subtitles[index - 1]['lan'],
        ),
      );
      vttSubtitlesIndex.value = index;
    }

    String? subtitle = _vttSubtitles[index - 1];
    if (subtitle != null) {
      setSub(subtitle);
    } else {
      var result = await VideoHttp.vttSubtitles(subtitles[index - 1]);
      if (result != null) {
        _vttSubtitles[index - 1] = result;
        setSub(result);
      }
    }
  }

  // interactive video
  dynamic graphVersion;
  Map? steinEdgeInfo;
  late final RxBool showSteinEdgeInfo = false.obs;
  void getSteinEdgeInfo([edgeId]) async {
    steinEdgeInfo = null;
    try {
      dynamic res = await Request().get(
        '/x/stein/edgeinfo_v2',
        queryParameters: {
          'bvid': bvid,
          'graph_version': graphVersion,
          if (edgeId != null) 'edge_id': edgeId,
        },
      );
      if (res.data['code'] == 0) {
        steinEdgeInfo = res.data['data'];
      } else {
        debugPrint('getSteinEdgeInfo error: ${res.data['message']}');
      }
    } catch (e) {
      debugPrint('getSteinEdgeInfo: $e');
    }
  }

  late bool continuePlayingPart = GStorage.continuePlayingPart;

  Future _querySubtitles() async {
    var res = await VideoHttp.subtitlesJson(bvid: bvid, cid: cid.value);
    // if (!res["status"]) {
    //   SmartDialog.showToast('查询字幕错误，${res["msg"]}');
    // }
    if (res['status']) {
      // interactive video
      if (graphVersion == null) {
        try {
          final introCtr = Get.find<VideoIntroController>(tag: heroTag);
          if (introCtr.videoDetail.value.rights?['is_stein_gate'] == 1) {
            graphVersion = res['interaction']?['graph_version'];
            getSteinEdgeInfo();
          }
        } catch (e) {
          debugPrint('handle stein: $e');
        }
      }

      if (continuePlayingPart) {
        continuePlayingPart = false;
        try {
          VideoIntroController videoIntroController =
              Get.find<VideoIntroController>(tag: heroTag);
          if ((videoIntroController.videoDetail.value.pages?.length ?? 0) > 1 &&
              res['last_play_cid'] != null &&
              res['last_play_cid'] != 0) {
            if (res['last_play_cid'] != cid.value) {
              int index = videoIntroController.videoDetail.value.pages!
                  .indexWhere((item) => item.cid == res['last_play_cid']);
              if (index != -1) {
                onAddItem(index);
              }
            }
          }
        } catch (_) {}
      }

      if (GStorage.showViewPoints &&
          res["view_points"] is List &&
          res["view_points"].isNotEmpty) {
        viewPointList = (res["view_points"] as List).map((item) {
          double start =
              (item['to'] / ((data.timeLength ?? 0) / 1000)).clamp(0.0, 1.0);
          return Segment(
            start,
            start,
            Colors.black.withOpacity(0.5),
            item?['content'],
            item?['imgUrl'],
            item?['from'],
            item?['to'],
          );
        }).toList();
        if (plPlayerController.viewPointList.isEmpty) {
          plPlayerController.viewPointList.value = viewPointList;
          plPlayerController.showVP.value = showVP = true;
        }
      }

      if (res["subtitles"] is List && res["subtitles"].isNotEmpty) {
        int idx = 0;
        subtitles.value = res["subtitles"];

        String preference = GStorage.defaultSubtitlePreference;
        if (preference != 'off') {
          idx = subtitles.indexWhere((i) => !i['lan']!.startsWith('ai')) + 1;
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

  void updateMediaListHistory(aid) {
    if (Get.arguments?['sortField'] != null) {
      VideoHttp.medialistHistory(
        desc: _mediaDesc ? 1 : 0,
        oid: aid,
        upperMid: Get.arguments?['mediaId'],
      );
    }
  }

  void makeHeartBeat() {
    if (enableHeart &&
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
    if (GStorage.collapsibleVideoPage) {
      scrollCtr.removeListener(scrollListener);
      scrollCtr.dispose;
      animationController.dispose();
    }
    super.onClose();
  }

  onReset([isStein]) {
    playedTime = null;
    videoUrl = null;
    audioUrl = null;

    if (GStorage.collapsibleVideoPage && scrollRatio.value != 0) {
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
    if (enableSponsorBlock) {
      positionSubscription?.cancel();
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

  late final showDmChart = GStorage.showDmChart;
  List? dmTrend;

  void _getDmTrend() async {
    dmTrend = [];
    try {
      dynamic res = await Request().get(
        'https://bvc.bilivideo.com/pbp/data',
        queryParameters: {
          'bvid': bvid,
          'cid': cid.value,
        },
      );

      int stepSec = (res.data['step_sec'] as num?)?.toInt() ?? 0;
      late List events = (res.data['events']['default'] as List?) ?? [];
      if (stepSec != 0 && events.isNotEmpty) {
        dmTrend = events;
        if (plPlayerController.dmTrend.isEmpty) {
          plPlayerController.dmTrend.value = events;
        }
      }
    } catch (e) {
      debugPrint('_getDmTrend: $e');
    }
  }

  void showNoteList(BuildContext context) async {
    String? title;
    try {
      title =
          Get.find<VideoIntroController>(tag: heroTag).videoDetail.value.title;
    } catch (_) {}
    if (plPlayerController.isFullScreen.value) {
      Utils.showFSSheet(
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
