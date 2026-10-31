import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show min;
import 'dart:ui';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pbenum.dart'
    show PlaylistSource;
import 'package:PiliPlus/grpc/dm.dart';
import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart'
    show DanmakuElem;
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/video/base_quality.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/media_list/media_list.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_pbp/data.dart';
import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/pages/audio/view.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/sponsor_block/block_mixin.dart';
import 'package:PiliPlus/pages/video/download_panel/view.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/pages/video/medialist/view.dart';
import 'package:PiliPlus/pages/video/note/view.dart';
import 'package:PiliPlus/pages/video/post_panel/view.dart';
import 'package:PiliPlus/pages/video/send_danmaku/view.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/heart_beat_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:PiliPlus/services/airplay_hls.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/nested_scroll_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/ios/airplay_helper.dart';
import 'package:PiliPlus/utils/ios/airplay_danmaku.dart';
import 'package:PiliPlus/utils/ios/external_display_helper.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/reply_scheme_helper.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart' show Options;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    show ExtendedNestedScrollViewState;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/painting.dart' as painting;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart' hide Subtitle;

class VideoDetailController extends GetxController
    with GetTickerProviderStateMixin, BlockMixin {
  /// 路由传参
  late final Map args;
  late String bvid;
  late int aid;
  late final RxInt cid;
  int? epId;
  int? seasonId;
  int? pgcType;
  late final String heroTag;
  late final RxString cover;

  // 视频类型 默认投稿视频
  late final VideoType videoType;
  @override
  late final isUgc = videoType == VideoType.ugc;
  VideoType? _actualVideoType;
  late final ugcIntroCtr = Get.find<UgcIntroController>(tag: heroTag);
  late final pgcIntroCtr = Get.find<PgcIntroController>(tag: heroTag);

  // 页面来源 稍后再看 收藏夹
  late bool isPlayAll;
  late SourceType sourceType;
  late BiliDownloadEntryInfo entry;
  @override
  late bool isFileSource;
  late bool _mediaDesc = false;
  late final RxList<MediaListItemModel> mediaList = <MediaListItemModel>[].obs;
  late String watchLaterTitle;

  /// tabs相关配置
  late TabController tabCtr;

  // 请求返回的视频信息
  late PlayUrlModel data;
  final RxBool videoState = false.obs;
  final RxBool externalDisplayConnected = false.obs;

  /// 播放器配置 画质 音质 解码格式
  final Rxn<VideoQuality> currentVideoQa = Rxn<VideoQuality>();
  AudioQuality? currentAudioQa;
  late VideoDecodeFormatType currentDecodeFormats;

  // 是否开始自动播放 存在多p的情况下，第二p需要为true
  final RxBool _autoPlay = Pref.autoPlayEnable.obs;

  final videoPlayerKey = GlobalKey();
  final childKey = GlobalKey<MiniScaffoldState>();

  final plPlayerController = PlPlayerController.getInstance()
    ..brightness.value = -1;
  bool get setSystemBrightness => plPlayerController.setSystemBrightness;
  bool get removeSafeArea => plPlayerController.removeSafeArea;
  double get uiScale => plPlayerController.uiScale;

  late VideoItem firstVideo;
  String? videoUrl;
  String? audioUrl;
  Duration? defaultST;
  Duration? playedTime;
  String playedTimePos(bool hasParams) {
    final pos = playedTime?.inMilliseconds;
    if (pos != null && pos > 0) {
      return '${hasParams ? '&' : '?'}t=${pos / 1000}';
    }
    return '';
  }

  // 亮度
  double? brightness;

  int? _rotate = PlatformUtils.isDesktop ? 0 : null;
  int calcRotate(int value) => (_rotate! + value) % 360;
  set rotate(int value) {
    if (_rotate == value) return;
    final player = plPlayerController.videoPlayerController;
    if (player == null) return;
    _rotate = value;
    player.setProperty('video-rotate', _rotate.toString());
  }

  late final headerCtrKey = GlobalKey<TimeBatteryMixin>();

  Box setting = GStorage.setting;

  // 预设的解码格式
  late List<VideoDecodeFormatType> preferCodecs = Pref.preferCodecs;

  bool get showReply => isFileSource
      ? false
      : isUgc
      ? plPlayerController.showVideoReply
      : plPlayerController.showBangumiReply;

  bool get showRelatedVideo =>
      isFileSource ? false : plPlayerController.showRelatedVideo;

  ScrollController? introScrollCtr;
  ScrollController get effectiveIntroScrollCtr =>
      introScrollCtr ??= ScrollController();

  PlayerStatus? playerStatus;

  late final scrollKey = GlobalKey<ExtendedNestedScrollViewState>();
  late final RxBool isVertical;
  late final RxDouble scrollRatio = 0.0.obs;

  ScrollController? _scrollCtr;
  ScrollController get scrollCtr => _scrollCtr ??= ScrollController();

  late bool isExpanding = false;
  late bool isCollapsing = false;

  late double minVideoHeight;
  late double maxVideoHeight;
  late double videoHeight;
  late double animHeight;

  AnimationController? animController;
  AnimationController get animationController =>
      animController ??= (AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      )..addListener(_animListener));

  void refreshPage() {
    scrollKey.currentState?.refresh();
  }

  void _animListener() {
    if (animationController.isForwardOrCompleted) {
      _calcAnimHeight();
      refreshPage();
    }
  }

  void _calcAnimHeight() {
    if (isExpanding) {
      animHeight = clampDouble(
        videoHeight * animationController.value,
        kToolbarHeight,
        videoHeight,
      );
    } else if (isCollapsing) {
      animHeight = clampDouble(
        maxVideoHeight -
            (maxVideoHeight - minVideoHeight) * animationController.value,
        minVideoHeight,
        maxVideoHeight,
      );
    }
  }

  void animToTop() {
    scrollKey.currentState?.animToTop();
  }

  bool _needAnimOnDimensionChanged(bool isVertical) {
    if (isFullScreen) {
      if (PlatformUtils.isMobile) {
        plPlayerController.changeOrientation(isVertical: isVertical);
      }
      return false;
    }
    return true;
  }

  @pragma('vm:notify-debugger-on-exception')
  void _setVideoHeight() {
    try {
      var width = firstVideo.width;
      var height = firstVideo.height;
      if (width == null || height == null) {
        if (isUgc && !isFileSource) {
          final cid = this.cid.value;
          final part = ugcIntroCtr.videoDetail.value.pages?.firstWhereOrNull(
            (e) => e.cid == cid,
          );
          if (part != null) {
            final dimension = part.dimension!;
            width = dimension.width!;
            height = dimension.height!;
          } else {
            return;
          }
        } else {
          return;
        }
      }
      final isVertical = height > width;
      if (_scrollCtr?.hasClients != true) {
        videoHeight = isVertical ? maxVideoHeight : minVideoHeight;
        if (this.isVertical.value != isVertical) {
          this.isVertical.value = isVertical;
          _needAnimOnDimensionChanged(isVertical);
        }
        return;
      }
      if (this.isVertical.value != isVertical) {
        this.isVertical.value = isVertical;
        double videoHeight = isVertical ? maxVideoHeight : minVideoHeight;
        if (this.videoHeight != videoHeight) {
          if (videoHeight > this.videoHeight) {
            // current minVideoHeight
            if (_needAnimOnDimensionChanged(isVertical)) {
              isExpanding = true;
              animationController.forward(
                from: (minVideoHeight - scrollCtr.offset) / maxVideoHeight,
              );
            }
            this.videoHeight = maxVideoHeight;
          } else {
            // current maxVideoHeight
            final currentHeight = (maxVideoHeight - scrollCtr.offset)
                .toPrecision(2);
            double minVideoHeightPrecise = minVideoHeight.toPrecision(2);
            if (currentHeight == minVideoHeightPrecise) {
              this.videoHeight = minVideoHeight;
              if (_needAnimOnDimensionChanged(isVertical)) {
                isExpanding = true;
                animationController.forward(from: 1);
              }
            } else if (currentHeight < minVideoHeightPrecise) {
              // expand
              if (_needAnimOnDimensionChanged(isVertical)) {
                isExpanding = true;
                animationController.forward(
                  from: currentHeight / minVideoHeight,
                );
              }
              this.videoHeight = minVideoHeight;
            } else {
              // collapse
              if (_needAnimOnDimensionChanged(isVertical)) {
                isCollapsing = true;
                animationController.forward(
                  from: scrollCtr.offset / (maxVideoHeight - minVideoHeight),
                );
              }
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
    } catch (_) {}
  }

  final isLoginVideo = Accounts.get(AccountType.video).isLogin;

  late final watchProgress = GStorage.watchProgress;
  void cacheLocalProgress() {
    if (plPlayerController.playerStatus.isCompleted) {
      watchProgress.put(cid.value.toString(), entry.totalTimeMilli);
    } else if (playedTime case final playedTime?) {
      watchProgress.put(cid.value.toString(), playedTime.inMilliseconds);
    }
  }

  void _initLocalSkipIfNeeded() {
    if (plPlayerController.enableBlock) {
      resetBlock();
      if (entry.segments case final list? when list.isNotEmpty) {
        handleSBData(list);
      }
    }
  }

  void initFileSource(BiliDownloadEntryInfo entry) {
    this.entry = entry;
    _initLocalSkipIfNeeded();
    firstVideo = VideoItem(
      id: entry.preferedVideoQuality,
      quality: VideoQuality.fromCode(entry.preferedVideoQuality),
      width: entry.ep?.width ?? entry.pageData?.width ?? 1,
      height: entry.ep?.height ?? entry.pageData?.height ?? 1,
    );
    if (watchProgress.get(cid.value.toString()) case final int progress?) {
      if (progress >= entry.totalTimeMilli - 400) {
        defaultST = Duration.zero;
      } else {
        defaultST = Duration(milliseconds: progress);
      }
    } else {
      defaultST = Duration.zero;
    }
    data = PlayUrlModel(timeLength: entry.totalTimeMilli);
    _setVideoHeight();
  }

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments;
    videoType = args['videoType'];
    if (videoType == VideoType.pgc) {
      if (!isLoginVideo) {
        _actualVideoType = VideoType.ugc;
      }
    }

    bvid = args['bvid'];
    aid = args['aid'];
    cid = RxInt(args['cid']);
    epId = args['epId'];
    seasonId = args['seasonId'];
    pgcType = args['pgcType'];
    heroTag = args['heroTag'];
    cover = RxString(args['cover'] ?? '');
    isVertical = RxBool(args['isVertical'] ?? false);

    sourceType = args['sourceType'] ?? SourceType.normal;
    isFileSource = sourceType == SourceType.file;
    isPlayAll = sourceType != SourceType.normal && !isFileSource;
    if (isFileSource) {
      initFileSource(args['entry']);
    } else if (isPlayAll) {
      watchLaterTitle = args['favTitle'];
      _mediaDesc = args['desc'];
      getMediaList();
    }

    tabCtr = TabController(
      length: 2,
      vsync: this,
      initialIndex: Pref.defaultShowComment || args.containsKey(rootRpIdKey)
          ? 1
          : 0,
    );
  }

  Future<void> getMediaList({
    bool isReverse = false,
    bool isLoadPrevious = false,
  }) async {
    final count = args['count'];
    if (!isReverse && count != null && mediaList.length >= count) {
      return;
    }
    final res = await UserHttp.getMediaList(
      type: args['mediaType'] ?? sourceType.mediaType,
      bizId: args['mediaId'] ?? -1,
      ps: 20,
      direction: isLoadPrevious ? true : false,
      oid: isReverse
          ? null
          : mediaList.isEmpty
          ? args['isContinuePlaying'] == true
                ? args['oid']
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
      sortField: args['sortField'] ?? 1,
      withCurrent: mediaList.isEmpty && args['isContinuePlaying'] == true
          ? true
          : false,
    );
    if (res case Success(:final response)) {
      if (response.mediaList.isNotEmpty) {
        if (isReverse) {
          mediaList.value = response.mediaList;
          for (final item in mediaList) {
            if (item.cid != null) {
              try {
                ugcIntroCtr.onChangeEpisode(item);
              } catch (_) {}
              break;
            }
          }
        } else if (isLoadPrevious) {
          mediaList.insertAll(0, response.mediaList);
        } else {
          mediaList.addAll(response.mediaList);
        }
      }
    } else {
      res.toast();
    }
  }

  void showMediaListPanel(BuildContext context) {
    if (mediaList.isNotEmpty) {
      Widget panel() => MediaListPanel(
        mediaList: mediaList,
        onChangeEpisode: (episode) {
          try {
            ugcIntroCtr.onChangeEpisode(episode);
          } catch (_) {}
        },
        panelTitle: watchLaterTitle,
        bvid: bvid,
        count: args['count'],
        loadMoreMedia: getMediaList,
        desc: _mediaDesc,
        onReverse: () {
          _mediaDesc = !_mediaDesc;
          getMediaList(isReverse: true);
        },
        loadPrevious: args['isContinuePlaying'] == true
            ? () => getMediaList(isLoadPrevious: true)
            : null,
        onDelete:
            sourceType == SourceType.watchLater ||
                (sourceType == SourceType.fav && args['isOwner'] == true)
            ? (item, index) async {
                if (sourceType == SourceType.watchLater) {
                  final res = await UserHttp.toViewDel(aids: item.aid!);
                  if (res.isSuccess) {
                    mediaList.removeAt(index);
                  }
                } else {
                  final res = await FavHttp.favVideo(
                    resources: '${item.aid}:${item.type}',
                    delIds: '${args['mediaId']}',
                  );
                  if (res.isSuccess) {
                    mediaList.removeAt(index);
                    SmartDialog.showToast('取消收藏');
                  } else {
                    res.toast();
                  }
                }
              }
            : null,
      );
      if (plPlayerController.isFullScreen.value || showVideoSheet) {
        PageUtils.showVideoBottomSheet(
          context,
          child: plPlayerController.darkVideoPage
              ? Theme(data: ThemeUtils.darkTheme, child: panel())
              : panel(),
        );
      } else {
        childKey.currentState?.showBottomSheet(
          constraints: const BoxConstraints(),
          (context) => panel(),
        );
      }
    } else {
      getMediaList();
    }
  }

  bool isPortrait = true;

  bool get horizontalScreen => plPlayerController.horizontalScreen;

  bool get showVideoSheet =>
      (!horizontalScreen && !isPortrait) || plPlayerController.isDesktopPip;

  @override
  late final RxString videoLabel = ''.obs;
  @override
  int? get timeLength => data.timeLength;
  @override
  BlockConfigMixin get blockConfig => plPlayerController;
  @override
  Player? get player => plPlayerController.videoPlayerController;
  @override
  bool get isFullScreen => plPlayerController.isFullScreen.value;
  @override
  bool get autoPlay => _autoPlay.value;
  set autoPlay(bool value) => _autoPlay.value = value;
  @override
  bool get preInitPlayer => plPlayerController.preInitPlayer;
  @override
  int get currPosInMilliseconds =>
      defaultST?.inMilliseconds ?? plPlayerController.positionInMilliseconds;
  @override
  Future<void> seekTo(Duration duration, {required bool isSeek}) =>
      plPlayerController.seekTo(duration, isSeek: isSeek);

  @override
  Widget buildItem(Object item, Animation<double> animation) {
    final theme = ThemeUtils.theme;
    return Align(
      alignment: Alignment.centerLeft,
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              if (details.delta.dx < 0) {
                onRemoveItem(listData.indexOf(item), item);
              }
            },
            child: SearchText(
              bgColor: theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.8,
              ),
              textColor: theme.colorScheme.onSecondaryContainer,
              padding: const .symmetric(horizontal: 8, vertical: 4),
              fontSize: 14,
              text: item is SegmentModel
                  ? '跳过: ${item.segmentType.shortTitle}'
                  : '上次看到第${(item as int) + 1}P，点击跳转',
              onTap: (_) {
                if (item is int) {
                  try {
                    final part = ugcIntroCtr.videoDetail.value.pages![item];
                    ugcIntroCtr.onChangeEpisode(part);
                    SmartDialog.showToast('已跳至第${item + 1}P');
                  } catch (e) {
                    if (kDebugMode) debugPrint('$e');
                    SmartDialog.showToast('跳转失败');
                  }
                  onRemoveItem(listData.indexOf(item), item);
                } else if (item is SegmentModel) {
                  onSkip(item, isSeek: false);
                  onRemoveItem(listData.indexOf(item), item);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  ({int mode, int fontSize, Color color})? dmConfig;
  String? savedDanmaku;

  /// 发送弹幕
  Future<void> showShootDanmakuSheet() async {
    if (plPlayerController.dmState.contains(cid.value)) {
      SmartDialog.showToast('UP主已关闭弹幕');
      return;
    }
    final isPlaying =
        _autoPlay.value && plPlayerController.playerStatus.isPlaying;
    if (isPlaying) {
      await plPlayerController.pause();
    }
    await Get.key.currentState!.push(
      PublishRoute(
        pageBuilder: (buildContext, animation, secondaryAnimation) {
          final child = SendDanmakuPanel(
            cid: cid.value,
            bvid: bvid,
            progress: plPlayerController.positionInMilliseconds,
            initialValue: savedDanmaku,
            onSave: (danmaku) => savedDanmaku = danmaku,
            onSuccess: (danmakuModel) {
              savedDanmaku = null;
              plPlayerController.danmakuController?.addDanmaku(danmakuModel);
              IOSExternalDisplayHelper.sendDanmaku(cid.value, [
                {
                  'text': danmakuModel.text,
                  'color': danmakuModel.color.toARGB32(),
                  'mode': switch (danmakuModel.type) {
                    .top => 5,
                    .bottom => 4,
                    _ => 1,
                  },
                  'colorful': danmakuModel.isColorful,
                  'selfSend': true,
                  'count': danmakuModel.count,
                },
              ]);
            },
            dmConfig: dmConfig,
            onSaveDmConfig: (dmConfig) => this.dmConfig = dmConfig,
          );
          if (plPlayerController.darkVideoPage) {
            return Theme(data: ThemeUtils.darkTheme, child: child);
          }
          return child;
        },
      ),
    );
    if (isPlaying) {
      plPlayerController.play();
    }
  }

  VideoItem findVideoByQa(int qa, {bool setCodecs = false}) {
    /// 根据currentVideoQa和currentDecodeFormats 重新设置videoUrl
    final videoList = data.dash!.video!.where((i) => i.id == qa).toList();

    final currentCodes = currentDecodeFormats.codes;
    VideoItem? bestVideo;
    int bestIndex = preferCodecs.length;
    for (final video in videoList) {
      final codecs = video.codecs!;
      if (currentCodes.any(codecs.startsWith)) {
        return video;
      }
      for (int i = 0; i < bestIndex; i++) {
        if (preferCodecs[i].codes.any(codecs.startsWith)) {
          bestIndex = i;
          bestVideo = video;
          break;
        }
      }
    }

    if (setCodecs) {
      if (bestIndex < preferCodecs.length) {
        currentDecodeFormats = preferCodecs[bestIndex];
      } else {
        currentDecodeFormats = VideoDecodeFormatType.fromString(
          videoList.first.codecs!,
        );
      }
    }

    return bestVideo ?? videoList.first;
  }

  /// 更新画质、音质
  void updatePlayer() {
    final currentVideoQa = this.currentVideoQa.value;
    if (currentVideoQa == null) return;
    _autoPlay.value = true;
    playedTime = plPlayerController.videoPlayerController?.state.position;
    plPlayerController
      ..isBuffering.value = false
      ..buffered.value = 0;

    firstVideo = findVideoByQa(currentVideoQa.code, setCodecs: true);
    videoUrl = VideoUtils.getCdnUrl(firstVideo.playUrls);

    /// 根据currentAudioQa 重新设置audioUrl
    if (currentAudioQa != null) {
      final firstAudio = data.dash!.audio!.firstWhere(
        (i) => i.id == currentAudioQa!.code,
        orElse: () => data.dash!.audio!.first,
      );
      audioUrl = VideoUtils.getCdnUrl(firstAudio.playUrls, isAudio: true);
    }

    playerInit();
  }

  Future<void>? initPlayerIfNeeded(bool autoFullScreenFlag) {
    if (_autoPlay.value ||
        (plPlayerController.preInitPlayer && !plPlayerController.processing) &&
            (isFileSource
                ? true
                : videoPlayerKey.currentState?.mounted == true)) {
      return playerInit(
        autoFullScreenFlag: autoFullScreenFlag && _autoPlay.value,
      );
    }
    return null;
  }

  Future<void> playerInit({
    bool? autoplay,
    bool autoFullScreenFlag = false,
  }) async {
    Duration? seek = defaultST ?? playedTime;
    if (seek == .zero) seek = null;
    seek ??= getFirstSegment();
    await plPlayerController.setDataSource(
      isFileSource
          ? FileSource(
              dir: args['dirPath'],
              typeTag: entry.typeTag!,
              isMp4: entry.mediaType == 1,
              hasDashAudio: entry.hasDashAudio,
            )
          : NetworkSource(
              videoSource: videoUrl!,
              audioSource: audioUrl,
            ),
      seekTo: seek,
      duration: data.timeLength == null
          ? null
          : Duration(milliseconds: data.timeLength!),
      isVertical: isVertical.value,
      aid: aid,
      bvid: bvid,
      cid: cid.value,
      autoplay: autoplay ?? _autoPlay.value,
      epid: isUgc ? null : epId,
      seasonId: isUgc ? null : seasonId,
      pgcType: isUgc ? null : pgcType,
      videoType: videoType,
      onInit: () {
        videoState.value = true;
        setSubtitle(vttSubtitlesIndex.value);
      },
      width: firstVideo.width,
      height: firstVideo.height,
      volume: volume,
      autoFullScreenFlag: autoFullScreenFlag,
      rotate: _rotate,
    );

    if (isClosed) return;

    if (plPlayerController.enableBlock) {
      initSkip();
    }

    if (!isFileSource) {
      if (vttSubtitlesIndex.value == -1) {
        _queryPlayInfo();
      }

      if (plPlayerController.showDmChart && dmTrend.value == null) {
        _getDmTrend();
      }
    }

    defaultST = null;
    if (Platform.isIOS && IOSExternalDisplayHelper.continuesToNextVideo) {
      unawaited(_continueExternalDisplay());
    }
  }

  bool isQuerying = false;

  final languages = Rxn<List<LanguageItem>>();
  final currLang = Rxn<String>();
  void setLanguage(String language) {
    if (currLang.value == language) return;
    if (!isLoginVideo) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    currLang.value = language;
    queryVideoUrl(fromReset: true);
  }

  Future<LoadingState<PlayUrlModel>> _getVideoUrl(int quality) {
    return VideoHttp.videoUrl(
      cid: cid.value,
      bvid: bvid,
      qn: quality,
      epid: epId,
      seasonId: seasonId,
      tryLook: plPlayerController.tryLook,
      videoType: _actualVideoType ?? videoType,
      language: currLang.value,
      voiceBalance: plPlayerController.enableAudioNormalization,
    );
  }

  Future<void> _supplementVideoQualities() async {
    final quality = data.missingVideoQualityBelowHighest;
    if (quality == -1) return;
    final result = await _getVideoUrl(quality);
    if (result case Success(:final response)) {
      data.dash!.video!.merge(response.dash?.video);
    }
  }

  Volume? volume;

  // 视频链接
  /// TODO: merge [DownloadHttp.getVideoUrl].
  Future<void> queryVideoUrl({
    bool fromReset = false,
    bool autoFullScreenFlag = false,
  }) async {
    if (isFileSource) {
      return initPlayerIfNeeded(autoFullScreenFlag);
    }
    if (isQuerying) {
      return;
    }
    isQuerying = true;
    try {
      await _queryVideoUrl(fromReset, autoFullScreenFlag);
    } finally {
      isQuerying = false;
    }
  }

  @pragma('vm:prefer-inline')
  Future<void> _queryVideoUrl(bool fromReset, bool autoFullScreenFlag) async {
    if (plPlayerController.enableSponsorBlock && isBlock && !fromReset) {
      querySponsorBlock(bvid: bvid, cid: cid.value);
    }
    if (PlatformUtils.isMobile || Platform.isLinux) {
      final isWiFi = await ConnectivityUtils.isWiFi;
      if (plPlayerController.cacheVideoQa == null) {
        plPlayerController
          ..cacheVideoQa = isWiFi
              ? Pref.defaultVideoQa
              : Pref.defaultVideoQaCellular
          ..cacheAudioQa = isWiFi
              ? Pref.defaultAudioQa
              : Pref.defaultAudioQaCellular;
      }
      preferCodecs = isWiFi ? Pref.preferCodecs : Pref.preferCodecsCellular;
    }

    final result = await _getVideoUrl(VideoQuality.hdrVivid.code);

    if (result case Success(:final response)) {
      data = response;
      if (data.dash != null) await _supplementVideoQualities();

      languages.value = data.language?.items;
      currLang.value = data.curLanguage;

      volume = data.volume;

      if (!fromReset) {
        final progress = args.remove('progress');
        if (progress != null) {
          defaultST = Duration(milliseconds: progress);
        } else {
          defaultST = Duration(milliseconds: data.lastPlayTime);
        }
      }

      if (!isUgc && !fromReset && plPlayerController.enablePgcSkip) {
        if (data.clipInfoList case final clipInfoList?) {
          resetBlock();
          handleSBData(clipInfoList);
        }
      }

      if (data.acceptDesc?.contains('试看') == true) {
        SmartDialog.showToast(
          '该视频为专属视频，仅提供试看',
          displayTime: const Duration(seconds: 3),
        );
      }
      final dash = data.dash;
      if (dash == null) {
        if (data.durl case final durl?) {
          // it will cause all files to be opened simultaneously
          if (durl.length > 1) {
            // TODO: refa
            final sb = StringBuffer('edl://!no_chapters;');
            for (var i in durl) {
              final video = VideoUtils.getCdnUrl(i.playUrls);
              sb.write('%${video.length}%$video,length=${i.length! / 1000};');
            }
            videoUrl = sb.toString();
          } else {
            videoUrl = VideoUtils.getCdnUrl(durl.single.playUrls);
          }

          audioUrl = '';

          // 实际为FLV/MP4格式，但已被淘汰，这里仅做兜底处理
          final videoQuality = VideoQuality.fromFormat(
            data.quality!,
            data.supportFormats,
          );
          firstVideo = VideoItem(
            id: data.quality!,
            baseUrl: videoUrl,
            codecs: 'avc1',
            quality: videoQuality,
          );
          _setVideoHeight();
          currentDecodeFormats = VideoDecodeFormatType.AVC;
          currentVideoQa.value = videoQuality;
          await initPlayerIfNeeded(autoFullScreenFlag);
          return;
        } else {
          SmartDialog.showToast('视频资源不存在');
          _autoPlay.value = false;
          videoState.value = false;
          if (plPlayerController.isFullScreen.value) {
            plPlayerController.triggerFullScreen(status: false);
          }
          return;
        }
      }

      final cacheVideoQa = plPlayerController.cacheVideoQa!;
      final (
        int targetQuality,
        FormatItem targetFormat,
        VideoDecodeFormatType targetDecode,
        VideoItem targetVideo,
      ) = VideoUtils.findTargetVideo(
        dash.video!,
        cacheVideoQa,
        response.acceptQuality,
        response.supportFormats!,
        preferCodecs,
      );
      firstVideo = targetVideo;
      currentDecodeFormats = targetDecode;
      currentVideoQa.value = VideoQuality.fromCode(targetQuality);
      _setVideoHeight();
      videoUrl = VideoUtils.getCdnUrl(firstVideo.playUrls);

      AudioItem? firstAudio;
      final audioList = dash.audio;
      if (audioList != null && audioList.isNotEmpty) {
        firstAudio = VideoUtils.findTargetAudio(
          audioList,
          plPlayerController.cacheAudioQa,
        );
        audioUrl = VideoUtils.getCdnUrl(firstAudio.playUrls, isAudio: true);
        currentAudioQa = AudioQuality.fromCode(firstAudio.id);
      } else {
        audioUrl = '';
      }
      await initPlayerIfNeeded(autoFullScreenFlag);
    } else {
      _autoPlay.value = false;
      videoState.value = false;
      if (plPlayerController.isFullScreen.value) {
        plPlayerController.triggerFullScreen(status: false);
      }
      result.toast();
    }
  }

  late final List<PostSegmentModel> postList = <PostSegmentModel>[];
  void onBlock(BuildContext context) {
    if (postList.isEmpty) {
      postList.add(
        PostSegmentModel(
          segment: Pair(
            first: 0,
            second: plPlayerController.positionInMilliseconds / 1000,
          ),
          category: SegmentType.sponsor,
          actionType: ActionType.skip,
        ),
      );
    }
    if (plPlayerController.isFullScreen.value || showVideoSheet) {
      final child = PostPanel(
        enableSlide: false,
        videoDetailController: this,
        plPlayerController: plPlayerController,
      );
      PageUtils.showVideoBottomSheet(
        context,
        child: plPlayerController.darkVideoPage
            ? Theme(data: ThemeUtils.darkTheme, child: child)
            : child,
      );
    } else {
      childKey.currentState?.showBottomSheet(
        constraints: const BoxConstraints(),
        (context) => PostPanel(
          videoDetailController: this,
          plPlayerController: plPlayerController,
        ),
      );
    }
  }

  RxList<Subtitle> subtitles = RxList<Subtitle>();
  final Map<int, ({bool isData, String id})> vttSubtitles = {};
  late final vttSubtitlesIndex = (-1).obs;
  late final showVP = true.obs;
  late final viewPointList = <ViewPointSegment>[].obs;

  // 设定字幕轨道
  Future<void> setSubtitle(int index) async {
    if (index <= 0) {
      await plPlayerController.videoPlayerController?.setSubtitleTrack(.no());
      vttSubtitlesIndex.value = index;
      return;
    }

    Future<void> setSub(({bool isData, String id}) subtitle) async {
      final sub = subtitles[index - 1];

      String subUri = subtitle.id;
      if (subtitle.isData) {
        subUri = 'memory://$subUri';
      }
      await plPlayerController.videoPlayerController?.setSubtitleTrack(
        SubtitleTrack(subUri, sub.lanDoc, sub.lan, uri: true),
      );
      vttSubtitlesIndex.value = index;
    }

    var subtitle = vttSubtitles[index - 1];
    if (subtitle == null) {
      final result = await VideoHttp.getSubtitles(
        subtitles[index - 1].subtitleUrl!,
      );
      if (!isClosed && result != null) {
        subtitle = (isData: true, id: result);
        vttSubtitles[index - 1] = subtitle;
      } else {
        return;
      }
    }
    await setSub(subtitle);
  }

  // interactive video
  int? graphVersion;
  EdgeInfoData? steinEdgeInfo;
  late final RxBool showSteinEdgeInfo = false.obs;

  Future<void> getSteinEdgeInfo([int? edgeId]) async {
    steinEdgeInfo = null;
    try {
      final res = await Request().get(
        '/x/stein/edgeinfo_v2',
        queryParameters: {
          'bvid': bvid,
          'graph_version': graphVersion,
          'edge_id': ?edgeId,
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

  late bool continuePlayingPart = Pref.continuePlayingPart;

  Future<void> _queryPlayInfo() async {
    vttSubtitles.clear();
    vttSubtitlesIndex.value = 0;
    if (plPlayerController.showViewPoints) {
      viewPointList.clear();
    }
    final res = await VideoHttp.playInfo(
      bvid: bvid,
      cid: cid.value,
      seasonId: seasonId,
      epId: epId,
    );
    if (res case Success(:final response)) {
      // interactive video
      if (isUgc && graphVersion == null) {
        try {
          if (ugcIntroCtr.videoDetail.value.rights?.isSteinGate == 1) {
            graphVersion = response.interaction?.graphVersion;
            getSteinEdgeInfo();
          }
        } catch (e) {
          if (kDebugMode) debugPrint('handle stein: $e');
        }
      }

      if (isUgc && continuePlayingPart) {
        continuePlayingPart = false;
        final lastCid = response.lastPlayCid;
        if (lastCid != null && lastCid != 0 && lastCid != cid.value) {
          try {
            final pages = ugcIntroCtr.videoDetail.value.pages;
            if (pages != null && pages.length > 1) {
              final index = pages.indexWhere((item) => item.cid == lastCid);
              if (index != -1) {
                onAddItem(index);
              }
            }
          } catch (_) {}
        }
      }

      if (plPlayerController.showViewPoints &&
          response.viewPoints?.firstOrNull?.type == 2) {
        try {
          viewPointList.value = response.viewPoints!.map((item) {
            final end = (item.to! / (data.timeLength! / 1000)).clamp(0.0, 1.0);
            return ViewPointSegment(
              end: end,
              title: item.content,
              url: item.imgUrl,
              from: item.from,
              to: item.to,
            );
          }).toList();
        } catch (_) {}
      }

      if (response.subtitle?.subtitles case final sub? when (sub.isNotEmpty)) {
        _setSubtitle(sub);
      } else if (!Accounts.main.isLogin) {
        final res = await DmGrpc.dmView(aid, cid.value);
        if (res case Success(:final response)) {
          if (response.hasSubtitle() &&
              response.subtitle.subtitles.isNotEmpty) {
            _setSubtitle(
              response.subtitle.subtitles
                  .map(
                    (i) => Subtitle(
                      lan: i.lan,
                      lanDoc: i.lanDoc,
                      subtitleUrl: i.subtitleUrl.replaceFirst(
                        RegExp('^https?:'),
                        '',
                      ),
                      isAi: i.type == .AI,
                    ),
                  )
                  .toList()
                ..sort(),
            );
          }
        } else {
          res.toast();
        }
      }
    }
  }

  Future<void> _setSubtitle(List<Subtitle> sub) async {
    subtitles.value = sub;
    final idx = switch (Pref.subtitlePreferenceV2) {
      .off => 0,
      .on => 1,
      .withoutAi => sub.first.lan.startsWith('ai') ? 0 : 1,
      .auto =>
        !sub.first.lan.startsWith('ai') ||
                (PlatformUtils.isMobile &&
                    (await FlutterVolumeController.getVolume() ?? 0.0) <= 0.0)
            ? 1
            : 0,
    };
    await setSubtitle(idx);
  }

  void updateMediaListHistory(int aid) {
    if (args['sortField'] != null) {
      VideoHttp.medialistHistory(
        desc: _mediaDesc ? 1 : 0,
        oid: aid,
        upperMid: args['mediaId'],
      );
    }
  }

  void makeHeartBeat() {
    if (plPlayerController.enableHeart &&
        !plPlayerController.playerStatus.isCompleted &&
        playedTime != null) {
      try {
        plPlayerController.makeHeartBeat(
          data.timeLength != null
              ? (data.timeLength! - playedTime!.inMilliseconds).abs() <= 1000
                    ? -1
                    : playedTime!.inSeconds
              : playedTime!.inSeconds,
          type: HeartBeatType.completed,
          isManual: true,
          aid: aid,
          bvid: bvid,
          cid: cid.value,
          epid: isUgc ? null : epId,
          seasonId: isUgc ? null : seasonId,
          pgcType: isUgc ? null : pgcType,
          videoType: videoType,
        );
      } catch (_) {}
    }
  }

  @override
  void onClose() {
    cid.close();
    if (isFileSource) {
      cacheLocalProgress();
    }
    introScrollCtr?.dispose();
    introScrollCtr = null;
    tabCtr.dispose();
    _scrollCtr?.dispose();
    animController
      ?..removeListener(_animListener)
      ..dispose();
    subtitles.clear();
    vttSubtitles.clear();
    super.onClose();
  }

  void onReset({bool isStein = false}) {
    if (isFileSource) {
      cacheLocalProgress();
    }

    playedTime = null;
    defaultST = null;
    videoUrl = null;
    audioUrl = null;

    // danmaku
    savedDanmaku = null;

    // subtitle
    subtitles.clear();
    vttSubtitlesIndex.value = -1;
    vttSubtitles.clear();

    // sponsor block
    if (blockConfig.enableBlock) {
      resetBlock();
    }

    if (!isFileSource) {
      // language
      languages.value = null;
      currLang.value = null;

      // dm trend
      if (plPlayerController.showDmChart) {
        dmTrend.value = null;
      }

      // view point
      if (plPlayerController.showViewPoints) {
        viewPointList.clear();
      }

      // interactive video
      if (!isStein) {
        graphVersion = null;
      }
      steinEdgeInfo = null;
      showSteinEdgeInfo.value = false;
    }
  }

  late final Rx<LoadingState<List<double>>?> dmTrend =
      Rx<LoadingState<List<double>>?>(null);
  late final RxBool showDmTrendChart = true.obs;

  Future<void> _getDmTrend() async {
    dmTrend.value = LoadingState<List<double>>.loading();
    try {
      final res = await Request().get(
        'https://bvc.bilivideo.com/pbp/data',
        queryParameters: {
          'aid': aid,
          'bvid': bvid,
          'cid': cid.value,
          'r': 'loader',
        },
        options: Options(
          headers: {
            'user-agent': BrowserUa.pc,
            'origin': 'https://www.bilibili.com',
            'referer': 'https://www.bilibili.com/video/$bvid',
          },
        ),
      );
      dynamic json;
      try {
        json = (res.data['modules'] as List).first['params']['data'];
      } catch (_) {
        json = res.data;
      }
      final data = PbpData.fromJson(json);
      final stepSec = data.stepSec ?? 0;
      if (stepSec != 0 && data.events?.eDefault?.isNotEmpty == true) {
        dmTrend.value = Success(data.events!.eDefault!);
        return;
      }
      dmTrend.value = const Error(null);
    } catch (e) {
      dmTrend.value = const Error(null);
      if (kDebugMode) debugPrint('_getDmTrend: $e');
    }
  }

  void showNoteList(BuildContext context) {
    String? title;
    try {
      title = ugcIntroCtr.videoDetail.value.title;
    } catch (_) {}
    if (plPlayerController.isFullScreen.value || showVideoSheet) {
      final child = NoteListPage(
        oid: aid,
        enableSlide: false,
        heroTag: heroTag,
        isStein: graphVersion != null,
        title: title,
      );
      PageUtils.showVideoBottomSheet(
        context,
        child: plPlayerController.darkVideoPage
            ? Theme(data: ThemeUtils.darkTheme, child: child)
            : child,
      );
    } else {
      childKey.currentState?.showBottomSheet(
        constraints: const BoxConstraints(),
        (context) => NoteListPage(
          oid: aid,
          heroTag: heroTag,
          isStein: graphVersion != null,
          title: title,
        ),
      );
    }
  }

  @pragma('vm:notify-debugger-on-exception')
  bool onSkipSegment() {
    try {
      if (plPlayerController.enableBlock) {
        if (listData.lastOrNull case final SegmentModel item) {
          onSkip(item, isSeek: false);
          onRemoveItem(listData.indexOf(item), item);
          return true;
        }
      }
    } catch (e, s) {
      Utils.reportError(e, s);
    }
    return false;
  }

  void toAudioPage() {
    int? id;
    int? extraId;
    PlaylistSource from = PlaylistSource.UP_ARCHIVE;
    if (isPlayAll) {
      id = args['mediaId'];
      extraId = sourceType.extraId;
      from = sourceType.playlistSource!;
    } else if (isUgc) {
      try {
        id = ugcIntroCtr.videoDetail.value.ugcSeason?.id;
        if (id != null) {
          extraId = 8;
          from = PlaylistSource.MEDIA_LIST;
        }
      } catch (_) {}
    }
    AudioPage.toAudioPage(
      itemType: 1,
      id: id,
      oid: aid,
      subId: [cid.value],
      from: from,
      heroTag: _autoPlay.value ? heroTag : null,
      start: playedTime,
      audioUrl: audioUrl,
      extraId: extraId,
    );
  }

  Future<void> onDownload(BuildContext context) async {
    VideoDetailData? videoDetail;
    List<ugc.BaseEpisodeItem>? episodes;
    PgcInfoModel? pgcItem;
    if (isUgc) {
      try {
        videoDetail = ugcIntroCtr.videoDetail.value;
        if (videoDetail.ugcSeason?.sections case final sections?) {
          episodes = <ugc.BaseEpisodeItem>[];
          for (final i in sections) {
            if (i.episodes case final e?) {
              episodes.addAll(e);
            }
          }
        } else {
          episodes = videoDetail.pages;
        }
      } catch (e, s) {
        if (kDebugMode) {
          debugPrint('download ugc: $e\n\n$s');
        }
      }
    } else {
      try {
        pgcItem = pgcIntroCtr.pgcItem;
        episodes = pgcItem.episodes;
      } catch (e, s) {
        if (kDebugMode) {
          debugPrint('download pgc: $e\n\n$s');
        }
      }
    }
    if (episodes != null && episodes.isNotEmpty) {
      final downloadService = Get.find<DownloadService>();
      await downloadService.waitForInitialization;
      if (!context.mounted) {
        return;
      }
      final Set<int> cidSet = downloadService.downloadList
          .followedBy(downloadService.waitDownloadQueue)
          .map((e) => e.cid)
          .toSet();
      final targetCid = isUgc ? ugcIntroCtr.seasonCid ?? cid.value : cid.value;
      final index = episodes.indexWhere((e) => e.cid == targetCid);

      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxWidth: min(640, context.mediaQueryShortestSide),
        ),
        builder: (context) {
          final maxChildSize =
              PlatformUtils.isMobile && !context.mediaQuerySize.isPortrait
              ? 1.0
              : 0.7;
          return DraggableScrollableSheet(
            snap: true,
            expand: false,
            minChildSize: 0,
            snapSizes: [maxChildSize],
            maxChildSize: maxChildSize,
            initialChildSize: maxChildSize,
            builder: (context, scrollController) => DownloadPanel(
              index: index,
              videoDetail: videoDetail,
              pgcItem: pgcItem,
              episodes: episodes!,
              scrollController: scrollController,
              videoDetailController: this,
              heroTag: heroTag,
              ugcIntroController: isUgc ? ugcIntroCtr : null,
              cidSet: cidSet,
            ),
          );
        },
      );
    }
  }

  void editPlayUrl() {
    String videoUrl = this.videoUrl ?? '';
    String audioUrl = this.audioUrl ?? '';
    Widget textField({
      required String label,
      required String initialValue,
      required ValueChanged<String> onChanged,
    }) => TextFormField(
      minLines: 1,
      maxLines: 3,
      onChanged: onChanged,
      initialValue: initialValue,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(),
      ),
    );
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        constraints: Style.dialogFixedConstraints,
        title: const Text('播放地址'),
        content: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textField(
              label: 'Video Url',
              initialValue: videoUrl,
              onChanged: (value) => videoUrl = value,
            ),
            textField(
              label: 'Audio Url',
              initialValue: audioUrl,
              onChanged: (value) => audioUrl = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              this.videoUrl = videoUrl;
              this.audioUrl = audioUrl;
              playerInit();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  bool _casting = false;
  final externalDanmakuScale = DanmakuOptions.danmakuFontScaleFS.obs;

  void setExternalDanmakuScale(double value, {bool save = false}) {
    final scale = value.clamp(0.5, 2.5).toPrecision(2);
    DanmakuOptions.danmakuFontScaleFS = scale;
    externalDanmakuScale.value = scale;
    IOSExternalDisplayHelper.refresh();
    if (save) {
      unawaited(DanmakuOptions.save(plPlayerController.danmakuOpacity.value));
    }
  }

  Completer<void>? _castFinished;
  bool _resumingExternalDisplay = false;

  Future<void> _continueExternalDisplay() async {
    if (_resumingExternalDisplay) return;
    _resumingExternalDisplay = true;
    final nextCid = cid.value;
    final nextPlayer = player;
    final playing = plPlayerController.playerStatus.isPlaying;
    try {
      if (!await IOSExternalDisplayHelper.prepareNextVideo()) return;
      await _castFinished?.future;
      if (isClosed ||
          cid.value != nextCid ||
          player != nextPlayer ||
          !IOSExternalDisplayHelper.continuesToNextVideo) {
        return;
      }
      unawaited(onCast(automatic: true, playWhenConnected: playing));
    } catch (error) {
      if (kDebugMode) {
        debugPrint('External display resume failed: ${error.runtimeType}');
      }
    } finally {
      _resumingExternalDisplay = false;
    }
  }

  Future<void> onCast({bool automatic = false, bool? playWhenConnected}) async {
    if (_casting) {
      if (!automatic && IOSExternalDisplayHelper.isActive) {
        await IOSExternalDisplayHelper.showControls();
      }
      return;
    }
    _casting = true;
    final finished = Completer<void>();
    _castFinished = finished;
    try {
      final mode = Platform.isIOS
          ? await _castExternalDisplay(
              showControls: !automatic,
              playWhenConnected: playWhenConnected,
            )
          : 'dlna';
      if (mode != null && !isClosed) {
        await _castVideo(mode == 'airplay');
      }
    } catch (error) {
      if (kDebugMode) debugPrint('AirPlay start failed: ${error.runtimeType}');
      SmartDialog.showToast('投屏启动失败，请稍后重试');
    } finally {
      _casting = false;
      _castFinished = null;
      finished.complete();
    }
  }

  Future<String?> _castExternalDisplay({
    bool showControls = true,
    bool? playWhenConnected,
  }) async {
    final castCid = cid.value;
    final currentPlayer = player;
    if (currentPlayer == null) throw StateError('Video player is not ready');
    String title = 'PiliPlus';
    try {
      title = isUgc
          ? ugcIntroCtr.videoDetail.value.title ?? title
          : Get.find<PgcIntroController>(tag: heroTag)
                    .videoDetail
                    .value
                    .title ??
                title;
    } catch (_) {}
    var playOnConnect =
        playWhenConnected ?? plPlayerController.playerStatus.isPlaying;
    await plPlayerController.pause();
    await plPlayerController.triggerFullScreen(status: false);
    plPlayerController.showControls.value = false;
    final subtitleSubscription = currentPlayer.stream.subtitle.listen((_) {
      IOSExternalDisplayHelper.refresh();
    });
    try {
      return await IOSExternalDisplayHelper.present(
        title: title,
        artwork: ImageUtils.safeThumbnailUrl(cover.value),
        darkMode: Theme.of(Get.context!).brightness == Brightness.dark,
        cid: castCid,
        showControls: showControls,
        state: () {
          if (isClosed || cid.value != castCid || player != currentPlayer) {
            return null;
          }
          final subtitle = vttSubtitlesIndex.value;
          final state = currentPlayer.state;
          final speed = plPlayerController.playbackSpeed;
          return {
            'textureId': plPlayerController.videoController?.id.value ?? -1,
            'width':
                plPlayerController.videoController?.rect.value?.width ??
                state.width,
            'height':
                plPlayerController.videoController?.rect.value?.height ??
                state.height,
            'speed': speed,
            'fit': plPlayerController.videoFit.value.boxFit.index,
            'flipX': plPlayerController.flipX.value,
            'flipY': plPlayerController.flipY.value,
            'subtitleText': state.subtitle.toString(),
            'subtitleStyle': {
              'fontSize': 16 * plPlayerController.subtitleFontScaleFS,
              'fontWeight': plPlayerController.subtitleFontWeight,
              'backgroundOpacity': plPlayerController.subtitleBgOpacity,
              'strokeWidth': plPlayerController.subtitleStrokeWidth,
              'horizontalPadding': plPlayerController.subtitlePaddingH,
              'bottomPadding': plPlayerController.subtitlePaddingB,
            },
            'danmakuOptions': {
              'fontSize': 15 * DanmakuOptions.danmakuFontScaleFS,
              'fontWeight': DanmakuOptions.danmakuFontWeight,
              'area': DanmakuOptions.danmakuShowArea,
              'duration': DanmakuOptions.danmakuDuration / speed,
              'staticDuration': DanmakuOptions.danmakuStaticDuration / speed,
              'hideBottom': DanmakuOptions.blockTypes.contains(4),
              'hideScroll': DanmakuOptions.blockTypes.contains(2),
              'hideTop': DanmakuOptions.blockTypes.contains(5),
              'hideSpecial': DanmakuOptions.blockTypes.contains(7),
              'strokeWidth': DanmakuOptions.danmakuStrokeWidth,
              'fixedVelocity': DanmakuOptions.danmakuFixedV,
              'massiveMode': DanmakuOptions.danmakuMassiveMode,
              'static2Scroll': DanmakuOptions.danmakuStatic2Scroll,
              'lineHeight': DanmakuOptions.danmakuLineHeight,
            },
            'danmakuOpacity': plPlayerController.danmakuOpacity.value,
            'danmakuScale': DanmakuOptions.danmakuFontScaleFS,
            'playing': plPlayerController.playerStatus.isPlaying,
            'positionMs': plPlayerController.positionInMilliseconds,
            'durationMs': plPlayerController.durationInMilliseconds,
            'danmaku': plPlayerController.enableShowDanmaku.value,
            'subtitle': subtitle > 0 && subtitle <= subtitles.length
                ? subtitles[subtitle - 1].lanDoc ?? subtitles[subtitle - 1].lan
                : '关闭',
            'subtitleIndex': subtitle.clamp(0, subtitles.length),
            'subtitles': [
              '关闭',
              for (final item in subtitles) item.lanDoc ?? item.lan,
            ],
          };
        },
        onCommand: (command, value) async {
          if (isClosed || cid.value != castCid || player != currentPlayer) {
            return;
          }
          switch (command) {
            case 'connected':
              animController?.stop();
              isExpanding = false;
              isCollapsing = false;
              externalDisplayConnected.value = true;
              if (playOnConnect) {
                await plPlayerController.play();
              }
            case 'disconnected':
              externalDisplayConnected.value = false;
              playOnConnect = plPlayerController.playerStatus.isPlaying;
              await plPlayerController.pause();
              plPlayerController.danmakuController?.clear();
              IOSExternalDisplayHelper.clearDanmaku();
            case 'close':
              externalDisplayConnected.value = false;
              await plPlayerController.pause();
              plPlayerController.danmakuController?.clear();
            case 'togglePlayback':
              if (plPlayerController.playerStatus.isPlaying) {
                await plPlayerController.pause();
              } else {
                await plPlayerController.play();
              }
            case 'skip' || 'seek':
              final milliseconds = command == 'skip'
                  ? plPlayerController.positionInMilliseconds + (value ?? 0)
                  : value ?? 0;
              await plPlayerController.seekTo(
                Duration(
                  milliseconds: milliseconds
                      .clamp(0, plPlayerController.durationInMilliseconds)
                      .round(),
                ),
                isSeek: false,
              );
            case 'toggleDanmaku':
              plPlayerController.enableShowDanmaku.toggle();
            case 'danmakuScale' || 'saveDanmakuScale':
              if (value != null) {
                setExternalDanmakuScale(
                  value,
                  save: command == 'saveDanmakuScale',
                );
              }
            case 'selectSubtitle':
              final index = value?.toInt();
              if (index != null && index >= 0 && index <= subtitles.length) {
                await setSubtitle(index);
              }
          }
          plPlayerController.showControls.value = false;
        },
      );
    } finally {
      await subtitleSubscription.cancel();
      if (!isClosed) externalDisplayConnected.value = false;
      if (!isClosed && cid.value == castCid && player == currentPlayer) {
        await plPlayerController.pause();
      }
    }
  }

  Future<void> _castVideo(bool airPlay) async {
    final castCid = cid.value;
    if (airPlay && data.dash != null) {
      await _castDashAirPlay(castCid);
      return;
    }
    SmartDialog.showLoading();
    final LoadingState<PlayUrlModel> res;
    try {
      res = await VideoHttp.tvPlayUrl(
        cid: castCid,
        objectId: epId ?? aid,
        playurlType: epId != null ? 2 : 1,
        qn: currentVideoQa.value?.code,
      );
    } finally {
      SmartDialog.dismiss();
    }
    if (isClosed || cid.value != castCid) return;
    if (res case Success(:final response)) {
      final first = response.durl?.firstOrNull;
      if (first == null || first.playUrls.isEmpty) {
        SmartDialog.showToast('不支持投屏');
        return;
      }
      if (airPlay &&
          (response.durl!.length != 1 ||
              !(response.format?.startsWith('mp4') ?? false))) {
        SmartDialog.showToast('此视频暂不支持 AirPlay，请尝试 DLNA 投屏');
        return;
      }
      final url = VideoUtils.getCdnUrl(first.playUrls);

      String? title;
      try {
        if (isUgc) {
          title = Get.find<UgcIntroController>(tag: heroTag)
              .videoDetail
              .value
              .title;
        } else {
          title = Get.find<PgcIntroController>(tag: heroTag)
              .videoDetail
              .value
              .title;
        }
      } catch (_) {}
      if (kDebugMode) {
        debugPrint(title);
      }
      if (airPlay) {
        final currentPlayer = player;
        final position = Duration(
          milliseconds: plPlayerController.positionInMilliseconds,
        );
        await plPlayerController.pause();
        final result = await IOSAirPlayHelper.present(
          url: url,
          title: title ?? 'PiliPlus',
          position: position,
        );
        if (!isClosed && cid.value == castCid && player == currentPlayer) {
          // Returning from the system player keeps local playback paused.
          await plPlayerController.seekTo(result.position, isSeek: false);
          if (result.error case final error?) SmartDialog.showToast(error);
        }
        return;
      }
      Get.toNamed('/dlna', parameters: {'url': url, 'title': ?title});
    } else {
      res.toast();
    }
  }

  Future<void> _castDashAirPlay(int castCid) async {
    final dash = data.dash!;
    final quality = currentVideoQa.value?.code;
    final video =
        dash.video?.firstWhereOrNull(
          (item) =>
              item.id == quality && (item.codecs?.startsWith('avc1') ?? false),
        ) ??
        dash.video?.firstWhereOrNull(
          (item) =>
              item.id == quality && (item.codecs?.startsWith('hvc1') ?? false),
        );
    final audio =
        dash.audio?.firstWhereOrNull(
          (item) =>
              item.id == currentAudioQa?.code &&
              (item.codecs?.startsWith('mp4a') ?? false),
        ) ??
        dash.audio?.firstWhereOrNull(
          (item) => item.codecs?.startsWith('mp4a') ?? false,
        );
    if (video == null ||
        audio == null ||
        (video.width ?? 0) <= 0 ||
        (video.height ?? 0) <= 0) {
      SmartDialog.showToast('当前画质暂无 AirPlay 支持的音视频编码，请切换画质后重试');
      return;
    }
    final playerAtStart = player;
    final position = Duration(
      milliseconds: plPlayerController.positionInMilliseconds,
    );
    final withDanmaku = plPlayerController.enableShowDanmaku.value;
    final view = PlatformDispatcher.instance.views.first;
    final referenceHeight =
        (view.physicalSize.shortestSide / view.devicePixelRatio).clamp(
          200.0,
          1500.0,
        );
    final fontSize = 15 * DanmakuOptions.danmakuFontScaleFS;
    final fontFamily = Get.context == null
        ? null
        : DefaultTextStyle.of(Get.context!).style.fontFamily;
    final danmakuStyle = AirPlayDanmakuStyle(
      duration: DanmakuOptions.danmakuDuration,
      staticDuration: DanmakuOptions.danmakuStaticDuration,
      area: DanmakuOptions.danmakuShowArea,
      fontSize: fontSize / referenceHeight * 100,
      fontWeight: DanmakuOptions.danmakuFontWeight,
      opacity: plPlayerController.danmakuOpacity.value,
      strokeWidth: DanmakuOptions.danmakuStrokeWidth,
      lineHeight: DanmakuOptions.danmakuLineHeight,
      aspectRatio: video.width! / video.height!,
      hideScroll: DanmakuOptions.blockTypes.contains(2),
      hideTop: DanmakuOptions.blockTypes.contains(5),
      hideBottom: DanmakuOptions.blockTypes.contains(4),
      whiteOnly: DanmakuOptions.blockColorful,
      fixedVelocity: DanmakuOptions.danmakuFixedV,
      static2Scroll: DanmakuOptions.danmakuStatic2Scroll,
      massiveMode: DanmakuOptions.danmakuMassiveMode,
      fontFamily: fontFamily,
    );
    final minimumWeight = DanmakuOptions.danmakuWeight;
    final mergeDanmaku = plPlayerController.mergeDanmaku;
    double measureWidth(String text) {
      final painter = painting.TextPainter(
        text: painting.TextSpan(
          text: text,
          style: painting.TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.values[danmakuStyle.fontWeight.clamp(0, 8)],
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      final width =
          painter.width / (referenceHeight * danmakuStyle.aspectRatio) * 100;
      painter.dispose();
      return width;
    }

    var diagnosticCount = 0;
    void trace(String message) {
      if (kDebugMode && diagnosticCount++ < 48) {
        debugPrint('[AirPlay] $message');
      }
    }

    trace(
      'enabled=$withDanmaku weight=$minimumWeight '
      'hidden=${danmakuStyle.hideScroll}/${danmakuStyle.hideTop}/${danmakuStyle.hideBottom} '
      'opacity=${danmakuStyle.opacity}',
    );
    final dmSegments = <int, Future<List<DanmakuElem>>>{};
    Future<List<DanmakuElem>> loadComments(int index) async {
      final pending = dmSegments.putIfAbsent(index, () async {
        final result = await DmGrpc.dmSegMobile(
          cid: castCid,
          segmentIndex: index + 1,
        );
        if (result case Success(:final response)) {
          trace('source $index count=${response.elems.length}');
          return response.elems;
        }
        trace('source $index failed ${result.runtimeType}');
        throw StateError('投屏弹幕加载失败');
      });
      try {
        final comments = await pending;
        if (dmSegments.length > 3) {
          dmSegments.remove(dmSegments.keys.firstWhere((key) => key != index));
        }
        return comments;
      } catch (_) {
        if (identical(dmSegments[index], pending)) dmSegments.remove(index);
        rethrow;
      }
    }

    final AirPlayHlsSession session;
    SmartDialog.showLoading();
    try {
      session = await AirPlayHlsSession.start(
        onDiagnostic: trace,
        video: AirPlayTrack(
          url: VideoUtils.getCdnUrl(video.playUrls),
          codecs: video.codecs!,
          bandwidth: video.bandWidth ?? 5000000,
          width: video.width!,
          height: video.height!,
        ),
        audio: AirPlayTrack(
          url: VideoUtils.getCdnUrl(audio.playUrls, isAudio: true),
          codecs: audio.codecs!,
          bandwidth: audio.bandWidth ?? 192000,
        ),
        subtitles: withDanmaku
            ? (segment) async {
                final comments = <AirPlayComment>[];
                // DM API data arrives in six-minute blocks; native subtitle
                // files use short intervals to bound parsing/memory on receivers.
                final dmIndex = segment * airPlaySubtitleSegmentSeconds ~/ 360;
                for (final index in [if (dmIndex > 0) dmIndex - 1, dmIndex]) {
                  final source = await loadComments(index);
                  final entries = <({DanmakuElem item, int count})>[];
                  final merged = <String, int>{};
                  for (final item in source) {
                    final self = item.midHash == plPlayerController.midHash;
                    if (item.weight < minimumWeight ||
                        (!self &&
                            plPlayerController.filters.count != 0 &&
                            plPlayerController.filters.remove(item))) {
                      continue;
                    }
                    if (mergeDanmaku && !self) {
                      final previous = merged[item.content];
                      if (previous != null) {
                        final entry = entries[previous];
                        entries[previous] = (
                          item: entry.item,
                          count: entry.count + 1,
                        );
                        continue;
                      }
                      merged[item.content] = entries.length;
                    }
                    entries.add((item: item, count: 1));
                  }
                  for (final entry in entries) {
                    final item = entry.item;
                    comments.add(
                      AirPlayComment(
                        item.progress,
                        item.mode,
                        entry.count > 1
                            ? '(${entry.count})${item.content}'
                            : item.content,
                        item.color,
                      ),
                    );
                  }
                }
                trace('segment $segment filtered=${comments.length}');
                return airPlayDanmakuVtt(
                  comments,
                  segment,
                  style: danmakuStyle,
                  measureWidth: measureWidth,
                  segmentDurationMs: airPlaySubtitleSegmentSeconds * 1000,
                );
              }
            : null,
      );
    } finally {
      SmartDialog.dismiss();
    }
    try {
      if (isClosed || cid.value != castCid || player != playerAtStart) return;
      String title = 'PiliPlus';
      try {
        title = isUgc
            ? ugcIntroCtr.videoDetail.value.title ?? title
            : Get.find<PgcIntroController>(tag: heroTag)
                      .videoDetail
                      .value
                      .title ??
                  title;
      } catch (_) {}
      await plPlayerController.pause();
      final result = await IOSAirPlayHelper.present(
        url: session.url,
        title: title,
        position: position,
        localNetwork: true,
        subtitles: withDanmaku,
        subtitleStyle: withDanmaku ? danmakuStyle.nativeStyle : null,
      );
      if (!isClosed && cid.value == castCid && player == playerAtStart) {
        // mpv is paused throughout AirPlay, so no new buffer event is
        // guaranteed. A gesture seek would wait for that event indefinitely.
        await plPlayerController.seekTo(result.position, isSeek: false);
        if (result.error case final error?) SmartDialog.showToast(error);
      }
    } finally {
      await session.close();
    }
  }
}
