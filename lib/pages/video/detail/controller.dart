import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/segment_progress_bar.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models/video/later.dart';
import 'package:PiliPlus/models/video/play/subtitle.dart';
import 'package:PiliPlus/models/video_detail_res.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/video/detail/introduction/controller.dart';
import 'package:PiliPlus/pages/video/detail/related/controller.dart';
import 'package:PiliPlus/pages/video/detail/reply/controller.dart';
import 'package:PiliPlus/pages/video/detail/widgets/send_danmaku_panel.dart';
import 'package:PiliPlus/pages/video/detail/widgets/watch_later_list.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/id_utils.dart';
import 'widgets/header_control.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
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
  RxString hwdec = 'auto-safe'.obs;

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
  dynamic userInfo;
  Floating? floating;
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

  PersistentBottomSheetController? bsController;

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
    userInfo = GStorage.userInfo.get('userInfoCache');
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
    hwdec.value = setting.get(SettingBoxKey.hardwareDecoding,
        defaultValue: Platform.isAndroid ? 'auto-safe' : 'auto');
    if (userInfo == null ||
        GStorage.localCache.get(LocalCacheKey.historyPause) == true) {
      enableHeart = false;
    }
    danmakuCid.value = cid.value;

    ///
    if (Platform.isAndroid) {
      floating = Floating();
    }
    headerControl = HeaderControl(
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
              ? _mediaType == 1 &&
                      Get.arguments['mediaType'] == null // member archive
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
      withCurrent: mediaList.isEmpty &&
              _mediaType == 1 &&
              Get.arguments['mediaType'] == null
          ? true // init && member archive
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
  showMediaListPanel() {
    if (mediaList.isNotEmpty) {
      childKey.currentState?.showBottomSheet(
        (context) => MediaListPanel(
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
        ),
      );
    }
  }

  // 切换稍后再看
  Future changeMediaList(bvid, cid, aid, cover) async {
    try {
      this.bvid = bvid;
      oid.value = aid ?? IdUtils.bv2av(bvid);
      this.cid.value = cid;
      danmakuCid.value = cid;
      videoItem['pic'] = cover;
      queryVideoUrl();

      if (showReply) {
        Get.find<VideoReplyController>(tag: heroTag)
          ..aid = aid
          ..onRefresh();
      }

      Get.find<VideoIntroController>(tag: heroTag)
        ..lastPlayCid.value = cid
        ..bvid = bvid
        ..queryVideoIntro();

      if (showRelatedVideo) {
        Get.find<RelatedController>(tag: heroTag)
          ..bvid = bvid
          ..onRefresh();
      }
    } catch (_) {}
  }

  int? _lastPos;
  double? _blockLimit;
  List<Pair<SegmentType, SkipType>>? _blockSettings;
  List<Color>? _blockColor;
  RxList<SegmentModel> segmentList = <SegmentModel>[].obs;
  List<Segment> viewPointList = <Segment>[];
  List<Segment>? _segmentProgressList;
  Color _getColor(SegmentType segment) =>
      _blockColor?[segment.index] ?? segment.color;
  late RxString videoLabel = ''.obs;

  Timer? skipTimer;
  late final listKey = GlobalKey<AnimatedListState>();
  late final List listData = [];

  Future _vote(String uuid, int type) async {
    Request()
        .post(
      '${GStorage.blockServer}/api/voteOnSponsorTime',
      queryParameters: {
        'UUID': uuid,
        'userID': GStorage.blockUserID,
        'type': type,
      },
      options: _options,
    )
        .then((res) {
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
                        Request()
                            .post(
                          '${GStorage.blockServer}/api/voteOnSponsorTime',
                          queryParameters: {
                            'UUID': segment.UUID,
                            'userID': GStorage.blockUserID,
                            'category': item.name,
                          },
                          options: _options,
                        )
                            .then((res) {
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
                                height:
                                    MediaQuery.textScalerOf(context).scale(14),
                                width: 10,
                                alignment: Alignment.center,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getColor(item),
                                  ),
                                ),
                              ),
                              style: TextStyle(fontSize: 14),
                            ),
                            TextSpan(
                              text: ' ${item.title}',
                              style: TextStyle(fontSize: 14),
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
                              height:
                                  MediaQuery.textScalerOf(context).scale(14),
                              width: 10,
                              alignment: Alignment.center,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getColor(item.segmentType),
                                ),
                              ),
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          TextSpan(
                            text: ' ${item.segmentType.title}',
                            style: TextStyle(fontSize: 14),
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

  Options get _options => Options(
        headers: {
          'env': '',
          'app-key': '',
          'x-bili-mid': '',
          'x-bili-aurora-eid': '',
          'x-bili-aurora-zone': '',
          HttpHeaders.cookieHeader:
              'buvid3= ; SESSDATA= ; bili_jct= ; DedeUserID= ; DedeUserID__ckMd5= ; sid= ',
        },
      );

  Future _querySponsorBlock() async {
    positionSubscription?.cancel();
    videoLabel.value = '';
    segmentList.clear();
    _segmentProgressList = null;
    dynamic result = await Request().get(
      '${GStorage.blockServer}/api/skipSegments',
      queryParameters: {
        'videoID': bvid,
        'cid': cid.value,
      },
      options: _options,
    );
    _handleSBData(result);
  }

  void _handleSBData(result) {
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
            return SegmentModel(
              UUID: item['UUID'],
              segmentType: segmentType,
              segment: Pair(
                first: _convert(item['segment'][0]),
                second: _convert(item['segment'][1]),
              ),
              skipType: skipType,
            );
          },
        ).toList());

        // _segmentProgressList
        _segmentProgressList ??= <Segment>[];
        _segmentProgressList!.addAll(segmentList.map((item) {
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

  int _convert(value) {
    return value is double
        ? value.round()
        : value is int
            ? value
            : -1;
  }

  void _initSkip() {
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
          options: _options,
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
        videoSource: video ?? videoUrl,
        audioSource: audio ?? audioUrl,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
          'referer': HttpString.baseUrl
        },
      ),
      segmentList: _segmentProgressList,
      viewPointList: viewPointList,
      vttSubtitles: _vttSubtitles,
      vttSubtitlesIndex: vttSubtitlesIndex,
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
      direction: firstVideo.width != null && firstVideo.height != null
          ? ((firstVideo.width! - firstVideo.height!) > 0
              ? 'horizontal'
              : 'vertical')
          : null,
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
      },
    );

    _initSkip();

    if (vttSubtitlesIndex == null) {
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
  Future queryVideoUrl() async {
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
        defaultST = Duration.zero;
        // 实际为FLV/MP4格式，但已被淘汰，这里仅做兜底处理
        firstVideo = VideoItem(
            id: data.quality!,
            baseUrl: videoUrl,
            codecs: 'avc1',
            quality: VideoQualityCode.fromCode(data.quality!)!);
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
      defaultST = Duration(milliseconds: data.lastPlayTime!);
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
            second: plPlayerController.positionSeconds.value,
          ),
          category: SegmentType.sponsor,
          actionType: ActionType.skip,
        ),
      );
    }
    if (plPlayerController.isFullScreen.value) {
      bsController = scaffoldKey.currentState?.showBottomSheet(
        enableDrag: false,
        (context) => _postPanel(false),
      );
    } else {
      childKey.currentState?.showBottomSheet(
        enableDrag: false,
        (context) => _postPanel(),
      );
    }
  }

  Widget _postPanel([bool isChild = true]) => StatefulBuilder(
        builder: (context, setState) {
          void updateSegment({
            required bool isFirst,
            required int index,
            required int value,
          }) {
            if (isFirst) {
              list![index].segment.first = value;
            } else {
              list![index].segment.second = value;
            }
            if (list![index].category == SegmentType.poi_highlight ||
                list![index].actionType == ActionType.full) {
              list![index].segment.second = value;
            }
          }

          List<Widget> segmentWidget({
            required int index,
            required bool isFirst,
          }) {
            String value = Utils.timeFormat(isFirst
                ? list![index].segment.first
                : list![index].segment.second);
            return [
              Text(
                '${isFirst ? '开始' : '结束'}: $value',
              ),
              const SizedBox(width: 5),
              iconButton(
                context: context,
                size: 26,
                tooltip: '使用当前位置时间',
                icon: Icons.my_location,
                onPressed: () {
                  setState(() {
                    updateSegment(
                      isFirst: isFirst,
                      index: index,
                      value: plPlayerController.positionSeconds.value,
                    );
                  });
                },
              ),
              const SizedBox(width: 5),
              iconButton(
                context: context,
                size: 26,
                tooltip: '编辑',
                icon: Icons.edit,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String initV = value;
                      return AlertDialog(
                        content: TextFormField(
                          initialValue: value,
                          autofocus: true,
                          onChanged: (value) {
                            initV = value;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[\d:]+'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: Get.back,
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(result: initV),
                            child: Text('确定'),
                          ),
                        ],
                      );
                    },
                  ).then((res) {
                    if (res != null) {
                      try {
                        List<int> split = (res as String)
                            .split(':')
                            .toList()
                            .reversed
                            .toList()
                            .map((e) => int.parse(e))
                            .toList();
                        int duration = 0;
                        for (int i = 0; i < split.length; i++) {
                          duration += split[i] * pow(60, i).toInt();
                        }
                        if (duration <=
                            plPlayerController
                                .durationSeconds.value.inSeconds) {
                          setState(() {
                            updateSegment(
                              isFirst: isFirst,
                              index: index,
                              value: duration,
                            );
                          });
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    }
                  });
                },
              ),
            ];
          }

          return SizedBox(
            height: isChild ? null : Utils.getSheetHeight(context),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 16,
                title: const Text('提交片段'),
                actions: [
                  iconButton(
                    context: context,
                    tooltip: '添加片段',
                    onPressed: () {
                      setState(() {
                        list?.insert(
                          0,
                          PostSegmentModel(
                            segment: Pair(
                              first: 0,
                              second: plPlayerController.positionSeconds.value,
                            ),
                            category: SegmentType.sponsor,
                            actionType: ActionType.skip,
                          ),
                        );
                      });
                    },
                    icon: Icons.add,
                  ),
                  const SizedBox(width: 10),
                  iconButton(
                    context: context,
                    tooltip: '关闭',
                    onPressed: () {
                      if (bsController != null) {
                        bsController!.close();
                        bsController = null;
                      } else {
                        Get.back();
                      }
                    },
                    icon: Icons.close,
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: list?.isNotEmpty == true
                  ? Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                list!.length,
                                (index) => Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 5,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onInverseSurface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (list![index].actionType !=
                                              ActionType.full) ...[
                                            Row(
                                              children: [
                                                ...segmentWidget(
                                                  isFirst: true,
                                                  index: index,
                                                ),
                                                if (list![index].category !=
                                                    SegmentType
                                                        .poi_highlight) ...[
                                                  const SizedBox(width: 16),
                                                  ...segmentWidget(
                                                    isFirst: false,
                                                    index: index,
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                          Row(
                                            children: [
                                              const Text('分类: '),
                                              PopupMenuButton(
                                                initialValue:
                                                    list![index].category,
                                                onSelected: (item) async {
                                                  list![index].category = item;
                                                  List<ActionType>
                                                      constraintList =
                                                      _segmentType2ActionType(
                                                          item);
                                                  if (constraintList
                                                      .contains(list![index]
                                                          .actionType)
                                                      .not) {
                                                    list![index].actionType =
                                                        constraintList.first;
                                                  }
                                                  switch (item) {
                                                    case SegmentType
                                                          .poi_highlight:
                                                      updateSegment(
                                                        isFirst: false,
                                                        index: index,
                                                        value: list![index]
                                                            .segment
                                                            .first,
                                                      );
                                                      break;
                                                    case SegmentType
                                                          .exclusive_access:
                                                      updateSegment(
                                                        isFirst: true,
                                                        index: index,
                                                        value: 0,
                                                      );
                                                      break;
                                                    case _:
                                                  }
                                                  setState(() {});
                                                },
                                                itemBuilder: (context) =>
                                                    SegmentType.values
                                                        .map((item) =>
                                                            PopupMenuItem<
                                                                SegmentType>(
                                                              value: item,
                                                              child: Text(
                                                                  item.title),
                                                            ))
                                                        .toList(),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      list![index]
                                                          .category
                                                          .title,
                                                      style: TextStyle(
                                                        height: 1,
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        leading: 0,
                                                      ),
                                                    ),
                                                    Icon(
                                                      MdiIcons
                                                          .unfoldMoreHorizontal,
                                                      size: MediaQuery
                                                              .textScalerOf(
                                                                  context)
                                                          .scale(14),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Text('行为类别: '),
                                              PopupMenuButton(
                                                initialValue:
                                                    list![index].actionType,
                                                onSelected: (item) async {
                                                  list![index].actionType =
                                                      item;
                                                  if (item == ActionType.full) {
                                                    updateSegment(
                                                      isFirst: true,
                                                      index: index,
                                                      value: 0,
                                                    );
                                                  }
                                                  setState(() {});
                                                },
                                                itemBuilder: (context) =>
                                                    ActionType.values
                                                        .map(
                                                          (item) =>
                                                              PopupMenuItem<
                                                                  ActionType>(
                                                            enabled: _segmentType2ActionType(
                                                                    list![index]
                                                                        .category)
                                                                .contains(item),
                                                            value: item,
                                                            child: Text(
                                                                item.title),
                                                          ),
                                                        )
                                                        .toList(),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      list![index]
                                                          .actionType
                                                          .title,
                                                      style: TextStyle(
                                                        height: 1,
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        leading: 0,
                                                      ),
                                                    ),
                                                    Icon(
                                                      MdiIcons
                                                          .unfoldMoreHorizontal,
                                                      size: MediaQuery
                                                              .textScalerOf(
                                                                  context)
                                                          .scale(14),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 21,
                                      child: iconButton(
                                        context: context,
                                        size: 26,
                                        tooltip: '移除',
                                        icon: Icons.clear,
                                        onPressed: () {
                                          setState(() {
                                            list!.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    88 + MediaQuery.paddingOf(context).bottom,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 16,
                          bottom: 16 + MediaQuery.paddingOf(context).bottom,
                          child: FloatingActionButton(
                            tooltip: '提交',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('确定无误再提交'),
                                  actions: [
                                    TextButton(
                                      onPressed: Get.back,
                                      child: Text(
                                        '取消',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        Request()
                                            .post(
                                          '${GStorage.blockServer}/api/skipSegments',
                                          queryParameters: {
                                            'videoID': bvid,
                                            'cid': cid.value,
                                            'userID': GStorage.blockUserID,
                                            'userAgent': Constants.userAgent,
                                            'videoDuration': plPlayerController
                                                .durationSeconds
                                                .value
                                                .inSeconds,
                                          },
                                          data: {
                                            'segments': list!
                                                .map(
                                                  (item) => {
                                                    'segment': [
                                                      item.segment.first,
                                                      item.segment.second,
                                                    ],
                                                    'category':
                                                        item.category.name,
                                                    'actionType':
                                                        item.actionType.name,
                                                  },
                                                )
                                                .toList(),
                                          },
                                          options: _options,
                                        )
                                            .then(
                                          (res) {
                                            if (res.statusCode == 200) {
                                              Get.back();
                                              SmartDialog.showToast('提交成功');
                                              list?.clear();
                                              _handleSBData(res);
                                              plPlayerController
                                                      .segmentList.value =
                                                  _segmentProgressList ??
                                                      <Segment>[];
                                              if (positionSubscription ==
                                                  null) {
                                                _initSkip();
                                              }
                                            } else {
                                              SmartDialog.showToast(
                                                '提交失败: ${{
                                                  400: '参数错误',
                                                  403: '被自动审核机制拒绝',
                                                  429: '重复提交太快',
                                                  409: '重复提交'
                                                }[res.statusCode]}',
                                              );
                                            }
                                          },
                                        );
                                      },
                                      child: const Text('确定提交'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(Icons.check),
                          ),
                        )
                      ],
                    )
                  : errorWidget(),
            ),
          );
        },
      );

  // List<SegmentType> _actionType2SegmentType(ActionType actionType) {
  //   return switch (actionType) {
  //     ActionType.skip => [
  //         SegmentType.sponsor,
  //         SegmentType.selfpromo,
  //         SegmentType.interaction,
  //         SegmentType.intro,
  //         SegmentType.outro,
  //         SegmentType.preview,
  //         SegmentType.filler,
  //       ],
  //     ActionType.mute => [
  //         SegmentType.sponsor,
  //         SegmentType.selfpromo,
  //         SegmentType.interaction,
  //         SegmentType.intro,
  //         SegmentType.outro,
  //         SegmentType.preview,
  //         SegmentType.music_offtopic,
  //         SegmentType.filler,
  //       ],
  //     ActionType.full => [
  //         SegmentType.sponsor,
  //         SegmentType.selfpromo,
  //         SegmentType.exclusive_access,
  //       ],
  //     ActionType.poi => [
  //         SegmentType.poi_highlight,
  //       ],
  //   };
  // }

  List<ActionType> _segmentType2ActionType(SegmentType segmentType) {
    return switch (segmentType) {
      SegmentType.sponsor => [
          ActionType.skip,
          ActionType.mute,
          ActionType.full
        ],
      SegmentType.selfpromo => [
          ActionType.skip,
          ActionType.mute,
          ActionType.full
        ],
      SegmentType.interaction => [
          ActionType.skip,
          ActionType.mute,
        ],
      SegmentType.intro => [
          ActionType.skip,
          ActionType.mute,
        ],
      SegmentType.outro => [
          ActionType.skip,
          ActionType.mute,
        ],
      SegmentType.preview => [
          ActionType.skip,
          ActionType.mute,
        ],
      SegmentType.music_offtopic => [
          ActionType.skip,
        ],
      SegmentType.poi_highlight => [ActionType.poi],
      SegmentType.filler => [
          ActionType.skip,
          ActionType.mute,
        ],
      SegmentType.exclusive_access => [ActionType.full],
    };
  }

  late List<Map<String, String>> _vttSubtitles = <Map<String, String>>[];
  int? vttSubtitlesIndex;
  late bool showVP = true;

  void _getSubtitle() {
    _vttSubtitles.clear();
    viewPointList.clear();
    _querySubtitles().then((value) {
      if (_vttSubtitles.isNotEmpty) {
        String preference = setting.get(
          SettingBoxKey.subtitlePreference,
          defaultValue: SubtitlePreference.values.first.code,
        );
        vttSubtitlesIndex = 0;
        if (preference == 'on') {
          vttSubtitlesIndex = 1;
        } else if (preference == 'withoutAi') {
          for (int i = 1; i < _vttSubtitles.length; i++) {
            if (_vttSubtitles[i]['language']!.startsWith('ai')) {
              continue;
            }
            vttSubtitlesIndex = i;
            break;
          }
        }
        if (plPlayerController.vttSubtitles.isEmpty) {
          plPlayerController.vttSubtitles.value = _vttSubtitles;
          if (vttSubtitlesIndex != null) {
            plPlayerController.vttSubtitlesIndex.value = vttSubtitlesIndex!;
            if (vttSubtitlesIndex != 0) {
              plPlayerController.setSubtitle(vttSubtitlesIndex!);
            }
          }
        }
      }
    });
  }

  late bool continuePlayingPart = GStorage.continuePlayingPart;

  Future _querySubtitles() async {
    Map res = await VideoHttp.subtitlesJson(bvid: bvid, cid: cid.value);
    // if (!res["status"]) {
    //   SmartDialog.showToast('查询字幕错误，${res["msg"]}');
    // }
    if (res['status']) {
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

      if (res["data"] is List && res["data"].isNotEmpty) {
        var result = await VideoHttp.vttSubtitles(res["data"]);
        if (result != null) {
          _vttSubtitles = result;
        }
        // if (_vttSubtitles.isEmpty) {
        //   SmartDialog.showToast('字幕均加载失败');
        // }
      }
    }
  }

  void updateMediaListHistory(aid) {
    if (Get.arguments['sortField'] != null) {
      VideoHttp.medialistHistory(
        desc: _mediaDesc ? 1 : 0,
        oid: aid,
        upperMid: Get.arguments['mediaId'],
      );
    }
  }

  void makeHeartBeat() {
    if (enableHeart &&
        plPlayerController.playerStatus.status.value !=
            PlayerStatus.completed &&
        playedTime != null) {
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
    }
  }

  @override
  void onClose() {
    tabCtr.dispose();
    super.onClose();
  }

  onReset() {
    playedTime = null;
    videoUrl = null;
    audioUrl = null;

    // danmaku
    dmTrend = null;
    savedDanmaku = null;

    // subtitle
    vttSubtitlesIndex = null;
    _vttSubtitles.clear();

    // view point
    viewPointList.clear();

    // sponsor block
    positionSubscription?.cancel();
    videoLabel.value = '';
    segmentList.clear();
    _segmentProgressList = null;
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
}
