import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:io';
import 'dart:math' show Random, min;
import 'dart:ui';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pbenum.dart'
    show PlaylistSource;
import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart'
    show DanmakuElem;
import 'package:PiliPlus/grpc/dm.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/list_order.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/models_new/download/playback_meta.dart';
import 'package:PiliPlus/models_new/media_list/media_list.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/models_new/video/video_pbp/data.dart';
import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/pages/ai_chat/controller.dart';
import 'package:PiliPlus/pages/audio/view.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/danmaku/mask/controller.dart';
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
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/services/pip_overlay_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/danmaku_density_trend.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/nested_scroll_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart' show Options;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    show ExtendedNestedScrollViewState;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart' hide Subtitle;
import 'package:path/path.dart' as path;

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

  // 页面来源 稍后再看 收藏夹
  late bool isPlayAll;
  late SourceType sourceType;
  late BiliDownloadEntryInfo entry;
  late bool isFileSource;
  late ListOrder _listOrder = ListOrder.asc;
  ListOrder get listOrder => _listOrder;
  static final _random = Random();
  List<int> _shuffledPages = [];
  int _shufflePageIdx = 0;
  late final RxList<MediaListItemModel> mediaList = <MediaListItemModel>[].obs;
  late String watchLaterTitle;

  // 是否正在进入应用内小窗
  bool isEnteringPip = false;

  // 三点菜单「应用内画中画」的触发入口，由视频页 State 绑定：
  // 小窗流程依赖页面的路由生命周期（pop 收起），controller 自身无法发起
  VoidCallback? onRequestInAppPip;

  /// 视频页能否被 pop：页面 popScope 的 canPop 与三点菜单小窗入口共用。
  /// 横屏模式下竖屏才可 pop（横屏由播放器自己接管返回）
  bool canPopPage({required bool isPortrait}) =>
      !plPlayerController.isFullScreen.value &&
      !plPlayerController.isDesktopPip &&
      (horizontalScreen || isPortrait);

  /// tabs相关配置
  late TabController tabCtr;

  // 请求返回的视频信息
  late PlayUrlModel data;
  final RxBool videoState = false.obs;

  /// 播放器配置 画质 音质 解码格式
  final Rxn<VideoQuality> currentVideoQa = Rxn<VideoQuality>();
  AudioQuality? currentAudioQa;
  late VideoDecodeFormatType currentDecodeFormats;

  // 是否开始自动播放 存在多p的情况下，第二p需要为true
  final RxBool _autoPlay = Pref.autoPlayEnable.obs;

  final videoPlayerKey = GlobalKey();
  final childKey = GlobalKey<MiniScaffoldState>();

  PlPlayerController plPlayerController = PlPlayerController.getInstance()
    ..brightness.value = -1;
  bool get setSystemBrightness => plPlayerController.setSystemBrightness;
  bool get removeSafeArea => plPlayerController.removeSafeArea;
  double get uiScale => plPlayerController.uiScale;

  /// 上次 force 应用作者倍速的内容键（bvid-cid）；同集 reinits 不强制 setRate。
  String? _authorSpeedContentKey;

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

  int? seasonCid;
  late final RxInt seasonIndex = 0.obs;

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
          final ugcIntroCtr = Get.find<UgcIntroController>(tag: heroTag);
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
    final collectionService = Get.find<DownloadCollectionService>();
    if (plPlayerController.playerStatus.isCompleted) {
      unawaited(watchProgress.put(cid.value.toString(), entry.totalTimeMilli));
      unawaited(collectionService.clearLastLocalPlayedIfCid(cid.value));
    } else if (playedTime case final playedTime?) {
      final progressMs = playedTime.inMilliseconds;
      unawaited(watchProgress.put(cid.value.toString(), progressMs));
      unawaited(
        collectionService.updateLastLocalPlayed(
          entry: entry,
          progressMs: progressMs,
          playContext:
              DownloadVideoPlayContext.fromArguments(args) ??
              const DownloadVideoPlayContext.all(),
        ),
      );
    }
  }

  void initFileSource(BiliDownloadEntryInfo entry, {bool isInit = true}) {
    this.entry = entry;
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

  /// 注册全屏画质切换回调。
  /// 必须在 onInit 和 didPopNext 中调用，因为 PlPlayerController 是单例，
  /// 新视频页面的 onInit 会覆盖回调为新 controller 的闭包，返回后需重新注册。
  void setupFullScreenQualitySwitch() {
    plPlayerController.onFullScreenChanged = (bool fs) async {
      if (!fs || plPlayerController.isLive) return;
      if (isQuerying) return;
      PlayUrlModel data;
      try {
        data = this.data;
      } catch (_) {
        return;
      }
      if (data.dash == null) return;
      final halfScreenQa = Pref.defaultVideoQaHalfScreen;
      if (halfScreenQa == null) return;
      final isWiFi = await ConnectivityUtils.isWiFi;
      final fsQa = isWiFi ? Pref.defaultVideoQa : Pref.defaultVideoQaCellular;
      final curHighestVideoQa = data.dash!.video!.first.quality.code;
      int targetQa = curHighestVideoQa;
      if (data.acceptQuality?.isNotEmpty == true &&
          fsQa <= curHighestVideoQa) {
        targetQa = data.acceptQuality!.findClosestTarget(
          (e) => e <= fsQa,
          (a, b) => a > b ? a : b,
        );
      }
      // 只升不降：目标 ≤ 当前则跳过切换，保留（可能是手动选择的）当前画质，
      // 避免进全屏降档重载闪屏。半屏/全屏预设回落到同一可用画质时也走此分支。
      final curQa = currentVideoQa.value?.code;
      if (curQa != null && targetQa <= curQa) {
        plPlayerController.cacheVideoQa = curQa;
        return;
      }
      plPlayerController.cacheVideoQa = targetQa;
      currentVideoQa.value = VideoQuality.fromCode(targetQa);
      updatePlayer();
    };
  }

  /// 播放器内手动切换画质的持久化路由：在哪个场景改就写哪个场景的设置
  /// （docs/adr/0002）。桌面端无半屏/蜂窝概念，固定写全屏默认画质；
  /// 半屏为「跟随」时与全屏同值，写当前网络的全屏画质。
  Future<void> persistVideoQa(int quality) async {
    if (plPlayerController.tempPlayerConf) {
      return;
    }
    final String key;
    if (!PlatformUtils.isMobile) {
      key = SettingBoxKey.defaultVideoQa;
    } else if (!plPlayerController.isFullScreen.value &&
        Pref.defaultVideoQaHalfScreen != null) {
      key = SettingBoxKey.defaultVideoQaHalfScreen;
    } else {
      key = await ConnectivityUtils.isWiFi
          ? SettingBoxKey.defaultVideoQa
          : SettingBoxKey.defaultVideoQaCellular;
    }
    GStorage.setting.put(key, quality);
  }

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments;
    plPlayerController.onNeedsPlayerInit = () async {
      playedTime = plPlayerController.videoPlayerController?.state.position;
      await playerInit();
    };

    // 开启新视频时，如果存在前代播放器的应用内小窗，则按播放上下文决定是否重置旧状态
    // 避免不同视频/分P之间 SponsorBlock 片段状态污染，同时保留同上下文无缝恢复能力
    if (PipOverlayService.isInPipMode) {
      if (kDebugMode) {
        debugPrint(
          '[VideoDetailController] Active PiP detected, closing before new video initialization with context-aware reset',
        );
      }
      PipOverlayService.stopPip(
        immediate: true,
        targetContextKey: PipOverlayService.contextKeyFromArgs(args),
      );
      // 同步清理旧视频的 SponsorBlock 状态，避免污染新视频
      // 不能放在 stopPip 里异步执行，否则会与新视频初始化竞态
      resetBlock();
    }

    videoType = args['videoType'];
    if (videoType == VideoType.pgc) {
      if (!isLoginVideo) {
        _actualVideoType = VideoType.ugc;
      }
    } else if (args['pgcApi'] == true) {
      _actualVideoType = VideoType.pgc;
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
      _listOrder = args['desc'] == true ? ListOrder.desc : ListOrder.asc;
      getMediaList();
    }

    tabCtr = TabController(
      length: 2,
      vsync: this,
      initialIndex: Pref.defaultShowComment ? 1 : 0,
    );

    // 进入全屏时切换到全屏默认画质
    if (PlatformUtils.isMobile) {
      setupFullScreenQualitySwitch();
    }
  }

  Future<void> getMediaList({
    bool isReverse = false,
    bool isLoadPrevious = false,
    int? pn,
  }) async {
    final count = args['count'];
    if (!isReverse && !isLoadPrevious) {
      if (_listOrder.isShuffle && pn == null) {
        // shuffle mode load-more: use next page from shuffled sequence
        pn = _nextShufflePage();
        if (pn == null) return;
      } else if (count != null && mediaList.length >= count) {
        return;
      }
    }
    final isShufflePn = pn != null;
    final res = await UserHttp.getMediaList(
      type: args['mediaType'] ?? sourceType.mediaType,
      bizId: args['mediaId'] ?? -1,
      ps: 20,
      direction: isLoadPrevious ? true : false,
      pn: pn,
      oid: isShufflePn
          ? null
          : isReverse
          ? null
          : mediaList.isEmpty
          ? args['isContinuePlaying'] == true
                ? args['oid']
                : null
          : isLoadPrevious
          ? mediaList.first.aid
          : mediaList.last.aid,
      otype: isShufflePn
          ? null
          : isReverse
          ? null
          : mediaList.isEmpty
          ? null
          : isLoadPrevious
          ? mediaList.first.type
          : mediaList.last.type,
      desc: _listOrder.isDesc,
      sortField: args['sortField'] ?? 1,
      withCurrent: mediaList.isEmpty && args['isContinuePlaying'] == true
          ? true
          : false,
    );
    if (res case Success(:final response)) {
      if (response.mediaList.isNotEmpty) {
        if (isReverse) {
          mediaList.value = response.mediaList;
          if (_listOrder.isShuffle) {
            mediaList.shuffle();
          }
          for (final item in mediaList) {
            if (item.cid != null) {
              try {
                Get.find<UgcIntroController>(
                  tag: heroTag,
                ).onChangeEpisode(item);
              } catch (_) {}
              break;
            }
          }
        } else if (isLoadPrevious) {
          mediaList.insertAll(0, response.mediaList);
        } else if (_listOrder.isShuffle) {
          _shuffleInsert(response.mediaList);
        } else {
          mediaList.addAll(response.mediaList);
        }
      }
    } else {
      res.toast();
    }
  }

  void _shuffleInsert(List<MediaListItemModel> newItems) {
    if (newItems.isEmpty) return;
    final currentIdx = mediaList.indexWhere((e) => e.bvid == bvid);
    final insertStart = currentIdx < 0 ? 0 : currentIdx + 1;
    // Positions: insertStart..mediaList.length (inclusive, "append" is valid)
    final available = mediaList.length - insertStart + 1;
    final pickCount = newItems.length.clamp(0, available);
    final range = List.generate(available, (i) => insertStart + i);
    // Fisher-Yates partial shuffle for unique positions
    for (int i = 0; i < pickCount; i++) {
      final j = i + _random.nextInt(range.length - i);
      final temp = range[i];
      range[i] = range[j];
      range[j] = temp;
    }
    final positions = range.sublist(0, pickCount)..sort();
    // Insert back-to-front to preserve earlier indices
    for (int i = pickCount - 1; i >= 0; i--) {
      mediaList.insert(positions[i], newItems[i]);
    }
  }

  void _initShufflePages() {
    final count = args['count'];
    if (count == null || count <= 0) {
      _shuffledPages = [1];
      _shufflePageIdx = 0;
      return;
    }
    final totalPages = (count / 20).ceil();
    _shuffledPages = List.generate(totalPages, (i) => i + 1);
    _shuffledPages.shuffle(_random);
    // Ensure first page has enough items to trigger load-more
    final firstPageLastItem = count - (totalPages - 1) * 20;
    if (_shuffledPages[0] == totalPages && firstPageLastItem < 2) {
      for (int i = 1; i < _shuffledPages.length; i++) {
        if (_shuffledPages[i] != totalPages) {
          final temp = _shuffledPages[0];
          _shuffledPages[0] = _shuffledPages[i];
          _shuffledPages[i] = temp;
          break;
        }
      }
    }
    _shufflePageIdx = 0;
  }

  int? _nextShufflePage() {
    if (_shufflePageIdx >= _shuffledPages.length) return null;
    return _shuffledPages[_shufflePageIdx++];
  }

  // 稍后再看面板展开
  void showMediaListPanel(BuildContext context) {
    if (mediaList.isNotEmpty) {
      Widget panel() => MediaListPanel(
        mediaList: mediaList,
        onChangeEpisode: (episode, {bool manual = false}) async {
          try {
            return Get.find<UgcIntroController>(
              tag: heroTag,
            ).onChangeEpisode(episode, manual: manual);
          } catch (_) {}
          return false;
        },
        panelTitle: watchLaterTitle,
        bvid: bvid,
        count: args['count'],
        loadMoreMedia: getMediaList,
        listOrder: _listOrder,
        onReverse: () {
          _listOrder = _listOrder.next;
          if (_listOrder.isShuffle) {
            _initShufflePages();
            final pn = _nextShufflePage();
            getMediaList(isReverse: true, pn: pn);
          } else {
            _shuffledPages = [];
            _shufflePageIdx = 0;
            getMediaList(isReverse: true);
          }
        },
        loadPrevious: args['isContinuePlaying'] == true
            ? () => getMediaList(isLoadPrevious: true)
            : null,
        onDelete:
            sourceType == SourceType.watchLater ||
                (sourceType == SourceType.fav && args['isOwner'] == true)
            ? (item, index) async {
                if (sourceType == SourceType.watchLater) {
                  final res = await UserHttp.toViewDel(
                    aids: item.aid.toString(),
                  );
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
                    UgcIntroController ugcIntroController =
                        Get.find<UgcIntroController>(tag: heroTag);
                    Part part =
                        ugcIntroController.videoDetail.value.pages![item];
                    ugcIntroController.onChangeEpisode(part);
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
    final allVideos = data.dash!.video!;
    final videoList = allVideos.where((i) => i.id == qa).toList();

    if (videoList.isEmpty) {
      final fallback = allVideos.first;
      currentVideoQa.value = VideoQuality.fromCode(fallback.id!);
      return fallback;
    }

    final currentCodes = currentDecodeFormats.codes;
    VideoItem? bestVideo;
    int bestIndex = preferCodecs.length;
    for (final video in videoList) {
      final c = video.codecs!;
      if (currentCodes.any(c.startsWith)) {
        return video;
      }
      for (int i = 0; i < bestIndex; i++) {
        if (preferCodecs[i].codes.any(c.startsWith)) {
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

  Future<void>? _initPlayerIfNeeded(bool autoFullScreenFlag) {
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
    // 如果播放器单例已被外部销毁（例如在二级页面关闭了小窗），重新获取一个新实例
    if (plPlayerController.videoPlayerController == null) {
      plPlayerController = PlPlayerController.ensureInstance();
    }
    if (isFileSource) {
      await _loadLocalPlaybackMeta();
    }
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
    );

    // 检查 controller 是否已关闭，如果已关闭则跳过后续的资源加载操作
    // （播放信息、弹幕趋势、SponsorBlock 等），避免已销毁的 controller
    // 触发不必要的异步操作和 UI 更新
    if (isClosed) {
      if (kDebugMode) {
        debugPrint('[VideoDetail] playerInit: controller is closed, skipping resource loading');
      }
      return;
    }

    // 需要活跃资源的操作
    if (!isFileSource) {
      if (vttSubtitlesIndex.value == -1) {
        _queryPlayInfo();
      }

      if (plPlayerController.showDmChart && dmTrend.value == null) {
        _getDmTrend();
      }

      if (Pref.enableDmCount && dmCount.value == null) {
        _getDmCount();
      }

      if (plPlayerController.enableBlock) {
        initSkip();
      }
    } else {
      if (vttSubtitlesIndex.value == -1) {
        unawaited(_loadFileSubtitles());
      }
    }

    // 切集 / 开播：UGC 仅在 bvid/cid 变化时 force 重套；同集 reinits（画质/音轨/didPopNext）只更基准
    if (isUgc) {
      try {
        final mid = Get.find<UgcIntroController>(tag: heroTag)
            .videoDetail
            .value
            .owner
            ?.mid;
        final contentKey = '$bvid-${cid.value}';
        final contentChanged = _authorSpeedContentKey != contentKey;
        _authorSpeedContentKey = contentKey;
        await plPlayerController.applyAuthorDefaultSpeed(
          mid,
          force: contentChanged,
        );
      } catch (_) {
        // intro 尚未就绪时忽略；queryVideoIntro 成功后会再套一次
      }
    } else {
      plPlayerController.resetAuthorDefaultSpeedToGlobal(force: false);
    }

    defaultST = null;
  }

  bool isQuerying = false;

  String? _lastQueryBvid;
  int? _lastQueryCid;

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
    bool reinitializePlayer = true,
    bool autoFullScreenFlag = false,
  }) async {
    if (isFileSource) {
      return _initPlayerIfNeeded(autoFullScreenFlag);
    }
    if (isQuerying) {
      return;
    }
    isQuerying = true;
    try {
    if (_lastQueryBvid != bvid || _lastQueryCid != cid.value) {
      // 跨视频/分P时重置画质缓存，确保根据半屏/全屏设置重新选择默认画质。
      // resetTempSettings 在 setDataSource 中执行（HTTP 请求之后），
      // 此处提前重置使得 cacheVideoQa == null 分支能正确初始化。
      if (PlatformUtils.isMobile) {
        plPlayerController.cacheVideoQa = null;
      }
      _lastQueryBvid = bvid;
      _lastQueryCid = cid.value;
    }
    await _queryVideoUrl(fromReset, autoFullScreenFlag, reinitializePlayer);
    } finally {
      isQuerying = false;
    }
  }

  @pragma('vm:prefer-inline')
  Future<void> _queryVideoUrl(
    bool fromReset,
    bool autoFullScreenFlag,
    bool reinitializePlayer,
  ) async {
    if (plPlayerController.enableSponsorBlock && isBlock && !fromReset) {
      querySponsorBlock(bvid: bvid, cid: cid.value);
    }
    if (plPlayerController.cacheVideoQa == null) {
      final isWiFi = await ConnectivityUtils.isWiFi;
      final fsQa = isWiFi ? Pref.defaultVideoQa : Pref.defaultVideoQaCellular;
      final halfScreenQa = Pref.defaultVideoQaHalfScreen;
      plPlayerController
        // 半屏与蜂窝是两个正交的画质上限，同时命中取较低者（docs/adr/0002）
        ..cacheVideoQa = !plPlayerController.isFullScreen.value &&
                halfScreenQa != null
            ? min(halfScreenQa, fsQa)
            : fsQa
        ..cacheAudioQa = isWiFi
            ? Pref.defaultAudioQa
            : Pref.defaultAudioQaCellular;
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
        final playUrlStartTime = defaultST == null
            ? _resolvePlayUrlStartTime(
                lastPlayTime: data.lastPlayTime,
                lastPlayCid: data.lastPlayCid,
              )
            : null;
        if (progress != null) {
          defaultST = Duration(milliseconds: progress);
        } else if (playUrlStartTime != null) {
          defaultST = playUrlStartTime;
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
      if (data.dash == null) {
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
          final videoQuality = VideoQuality.fromCode(data.quality!);
          firstVideo = VideoItem(
            id: data.quality!,
            baseUrl: videoUrl,
            codecs: 'avc1',
            quality: videoQuality,
          );
          _setVideoHeight();
          currentDecodeFormats = VideoDecodeFormatType.AVC;
          currentVideoQa.value = videoQuality;
          if (reinitializePlayer) {
            await _initPlayerIfNeeded(autoFullScreenFlag);
          } else {
            // 从 PiP 返回时，重新初始化 SponsorBlock
            if (plPlayerController.enableSponsorBlock &&
                segmentList.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                initSkip();
              });
            }
          }
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

      // if (kDebugMode) debugPrint("allVideosList:${allVideosList}");
      final cacheVideoQa = plPlayerController.cacheVideoQa!;
      final targetVideoQa = data.findAvailableVideoQuality(cacheVideoQa);
      currentVideoQa.value = VideoQuality.fromCode(targetVideoQa);

      /// 优先顺序 设置中指定解码格式 -> 当前可选的首个解码格式
      final supportFormats = data.supportFormats!;

      // 根据画质选编码格式
      currentDecodeFormats = VideoUtils.selectCodec(
        supportFormats
            .firstWhere(
              (e) => e.quality == targetVideoQa,
              orElse: () => supportFormats.first,
            )
            .codecs!,
        preferCodecs,
      );

      /// 取出符合当前画质的videoList
      final videosList = data.dash!.video!
          .where((e) => e.quality.code == targetVideoQa)
          .toList();

      /// 取出符合当前解码格式的videoItem
      firstVideo = videosList.firstWhere(
        (e) => currentDecodeFormats.codes.any(e.codecs!.startsWith),
        orElse: () => videosList.first,
      );
      _setVideoHeight();

      videoUrl = VideoUtils.getCdnUrl(firstVideo.playUrls);

      /// 优先顺序 设置中指定质量 -> 当前可选的最高质量
      AudioItem? firstAudio;
      final audioList = data.dash?.audio;
      if (audioList != null && audioList.isNotEmpty) {
        final audioIds = audioList.map((map) => map.id).toList();
        int closestNumber = audioIds.findClosestTarget(
          (e) => e <= plPlayerController.cacheAudioQa,
          (a, b) => a > b ? a : b,
        );
        if (!audioIds.contains(plPlayerController.cacheAudioQa) &&
            audioIds.any((e) => e > plPlayerController.cacheAudioQa)) {
          closestNumber = AudioQuality.k192.code;
        }
        firstAudio = audioList.firstWhere(
          (e) => e.id == closestNumber,
          orElse: () => audioList.first,
        );
        audioUrl = VideoUtils.getCdnUrl(firstAudio.playUrls, isAudio: true);
        currentAudioQa = AudioQuality.fromCode(firstAudio.id);
      } else {
        audioUrl = '';
      }
      if (reinitializePlayer) {
        await _initPlayerIfNeeded(autoFullScreenFlag);
      } else {
        // 从 PiP 返回时，播放器已在运行，但需要重新初始化 SponsorBlock 的跳过监听器
        if (plPlayerController.enableSponsorBlock && segmentList.isNotEmpty) {
          // 等待播放器就绪
          WidgetsBinding.instance.addPostFrameCallback((_) {
            initSkip();
          });
        }
      }
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
  final danmakuMaskController = DanmakuMaskController();
  final Map<int, ({bool isData, String id})> vttSubtitles = {};
  late final RxInt vttSubtitlesIndex = (-1).obs;
  late final RxBool showVP = Pref.showViewPointsOverlay.obs;
  late final RxList<ViewPointSegment> viewPointList = <ViewPointSegment>[].obs;

  ({
    List<SegmentItemModel> items,
    bool useBlockConfig,
    bool isBlockSource,
  })?
  _resolveLocalSkipSegments(DownloadPlaybackMeta meta) {
    final clipInfo = meta.clipInfo;
    if (entry.ep != null &&
        plPlayerController.enablePgcSkip &&
        clipInfo != null &&
        clipInfo.items.isNotEmpty) {
      return (
        items: clipInfo.toSegmentItemModels(),
        useBlockConfig: false,
        isBlockSource: false,
      );
    }
    final sponsorBlock = meta.sponsorBlock;
    if (plPlayerController.enableSponsorBlock &&
        sponsorBlock != null &&
        sponsorBlock.items.isNotEmpty) {
      return (
        items: sponsorBlock.toSegmentItemModels(),
        useBlockConfig: true,
        isBlockSource: true,
      );
    }
    return null;
  }

  Future<void> _loadLocalPlaybackMeta() async {
    viewPointList.clear();
    resetBlock();
    final metaFile = File(
      path.join(entry.entryDirPath, PathUtils.playbackMetaName),
    );
    if (!metaFile.existsSync()) {
      return;
    }
    try {
      final meta = DownloadPlaybackMeta.fromJson(
        (jsonDecode(await metaFile.readAsString()) as Map)
            .cast<String, dynamic>(),
      );
      final durationMs = data.timeLength ?? entry.totalTimeMilli;
      final chapters = meta.chapters;
      if (plPlayerController.showViewPoints &&
          durationMs > 0 &&
          chapters != null) {
        viewPointList.assignAll(
          chapters.items.where((item) => item.toMs != null).map((item) {
            final toMs = item.toMs!;
            return ViewPointSegment(
              end: (toMs / durationMs).clamp(0.0, 1.0),
              title: item.content,
              url: item.imgUrl,
              from: item.fromMs == null ? null : item.fromMs! ~/ 1000,
              to: toMs ~/ 1000,
            );
          }).toList(),
        );
      }
      if (_resolveLocalSkipSegments(meta) case final resolved?) {
        await handleSBData(
          resolved.items,
          useBlockConfig: resolved.useBlockConfig,
          isBlockSource: resolved.isBlockSource,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('load local playback meta failed: $e');
      }
    }
  }

  Future<void> _loadFileSubtitles() async {
    // 与 _queryPlayInfo 一致:清理副字幕状态及 mpv secondary-sid 残留
    await setSecondarySubtitle(0);
    final indexFile = File(
      path.join(
        entry.entryDirPath,
        PathUtils.subtitlesDirName,
        PathUtils.subtitleIndexName,
      ),
    );
    if (!indexFile.existsSync()) return;

    List<Subtitle> loaded;
    try {
      final jsonList = (jsonDecode(await indexFile.readAsString()) as List)
          .cast<Map<String, dynamic>>();
      loaded = jsonList.map(Subtitle.fromJson).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('_loadFileSubtitles parse failed: $e');
      return;
    }

    final validSubs = <Subtitle>[];
    for (final sub in loaded) {
      final vttPath = path.join(
        entry.entryDirPath,
        PathUtils.subtitlesDirName,
        PathUtils.subtitleVttName(sub.lan),
      );
      if (File(vttPath).existsSync()) {
        vttSubtitles[validSubs.length] = (isData: false, id: vttPath);
        validSubs.add(sub);
      }
    }
    if (validSubs.isEmpty) return;
    if (isClosed) return;

    subtitles.value = validSubs;

    final idx = switch (Pref.subtitlePreferenceV2) {
      SubtitlePrefType.off => 0,
      SubtitlePrefType.on => 1,
      SubtitlePrefType.withoutAi =>
        subtitles.first.lan.startsWith('ai') ? 0 : 1,
      SubtitlePrefType.auto =>
        !subtitles.first.lan.startsWith('ai') ||
                (PlatformUtils.isMobile &&
                    (await FlutterVolumeController.getVolume() ?? 0.0) <= 0.0)
            ? 1
            : 0,
    };
    if (!isClosed) await setSubtitle(idx);
  }

  // 设定字幕轨道
  Future<void> setSubtitle(int index) async {
    if (index <= 0) {
      await plPlayerController.videoPlayerController?.setSubtitleTrack(.no());
      vttSubtitlesIndex.value = index;
      return;
    }

    // 防御性兜底:主副不能同轨。正常路径下选择器已将副字幕所在轨置灰,
    // 此处仅防绕过 UI 的调用或面板打开期间的状态竞态;冲突时副字幕让位。
    if (index == vttSecondarySubtitlesIndex.value) {
      await setSecondarySubtitle(0);
    }

    final subUri = await _resolveVttUri(index - 1);
    if (isClosed || subUri == null) return;
    final sub = subtitles[index - 1];
    await plPlayerController.videoPlayerController?.setSubtitleTrack(
      SubtitleTrack(subUri, sub.lanDoc, sub.lan, uri: true),
    );
    vttSubtitlesIndex.value = index;
  }

  // 副字幕(双语字幕):0 表示关闭,>0 对应 subtitles[index - 1]
  late final RxInt vttSecondarySubtitlesIndex = 0.obs;

  Future<void> setSecondarySubtitle(int index) async {
    final player = plPlayerController.videoPlayerController;

    // index == 主字幕轨为防御性兜底(UI 已置灰该项),与 setSubtitle 的
    // 守卫同规则:冲突时副字幕让位,即视为关闭副字幕。
    if (index <= 0 || index == vttSubtitlesIndex.value) {
      vttSecondarySubtitlesIndex.value = 0;
      await player?.setSecondarySubtitleTrack(.no());
      return;
    }

    if (player == null) return;

    final subUri = await _resolveVttUri(index - 1);
    if (isClosed || subUri == null) return;
    final sub = subtitles[index - 1];
    await player.setSecondarySubtitleTrack(
      SubtitleTrack(subUri, sub.lanDoc, sub.lan, uri: true),
    );
    vttSecondarySubtitlesIndex.value = index;
  }

  /// 取 subtitles[subIdx] 的 VTT 播放地址(本地文件路径或 memory:// 数据),
  /// 网络字幕转换结果缓存于 [vttSubtitles]。
  Future<String?> _resolveVttUri(int subIdx) async {
    ({bool isData, String id})? subtitle = vttSubtitles[subIdx];
    if (subtitle == null) {
      final result = await VideoHttp.getSubtitles(
        subtitles[subIdx].subtitleUrl!,
      );
      if (result == null) return null;
      subtitle = (isData: true, id: result);
      vttSubtitles[subIdx] = subtitle;
    }
    return subtitle.isData ? 'memory://${subtitle.id}' : subtitle.id;
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

  Duration? _resolvePlayUrlStartTime({
    required int lastPlayTime,
    required int? lastPlayCid,
  }) {
    if (lastPlayTime <= 0) {
      return Duration.zero;
    }
    return _canUseLastPlayTime(lastPlayCid)
        ? Duration(milliseconds: lastPlayTime)
        : Duration.zero;
  }

  bool _canUseLastPlayTime(int? lastPlayCid) {
    if (lastPlayCid != null && lastPlayCid != 0) {
      return lastPlayCid == cid.value;
    }
    // PGC/PUGV progress can come from watch_progress without last_play_cid.
    return (_actualVideoType ?? videoType) != VideoType.ugc;
  }

  Future<void> _queryPlayInfo() async {
    final requestedCid = cid.value;
    vttSubtitles.clear();
    vttSubtitlesIndex.value = 0;
    // 副字幕不跨 P/视频保留;同时清掉 mpv 的 secondary-sid 选项,
    // 避免残留选项与下个视频 sub-add 产生的轨道 id 冲突
    await setSecondarySubtitle(0);
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
      if (requestedCid == cid.value) {
        final dmMask = response.dmMask;
        danmakuMaskController.setSource(
          dmMask?.cid == requestedCid ? dmMask : null,
        );
      }
      if (response.lastPlayTime != null &&
          response.lastPlayTime! > 0 &&
          _canUseLastPlayTime(response.lastPlayCid)) {
        if (Accounts.get(AccountType.video).mid !=
            Accounts.get(AccountType.heartbeat).mid) {
          if (plPlayerController.position.value <= 3) {
            plPlayerController.seekTo(
              Duration(milliseconds: response.lastPlayTime!),
            );
            SmartDialog.showToast('已跳转至上次观看位置');
          }
        }
      }

      // interactive video
      late final introCtr = Get.find<UgcIntroController>(tag: heroTag);
      if (isUgc && graphVersion == null) {
        try {
          if (introCtr.videoDetail.value.rights?.isSteinGate == 1) {
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
            final pages = introCtr.videoDetail.value.pages;
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
      } else if (!Accounts.heartbeat.isLogin) {
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
        desc: _listOrder.isDesc ? 1 : 0,
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
    plPlayerController.onNeedsPlayerInit = null;
    if (isEnteringPip) {
      // 正在进入小窗，保留资源
      return;
    }
    // 页面 pop 后 GetX 才延迟触发 onClose，此时播放器单例可能已被下层视频页
    // 重新接管（didPopNext -> playerInit 恢复播放）；仅当单例仍持有本页内容时
    // 才暂停，否则会与下层页面的恢复播放竞速
    if (plPlayerController.isCurrentVideoSource(bvid: bvid, cid: cid.value)) {
      plPlayerController.pause();
    }
    cancelBlockListener();
    _dmTrendTaskId++;
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
    danmakuMaskController.dispose();
    Get.delete<AiChatController>(tag: heroTag);
    super.onClose();
  }

  void onReset({bool isStein = false}) {
    if (isFileSource) {
      cacheLocalProgress();
    }

    playedTime = null;
    _dmTrendTaskId++;
    // 切分P/视频时作废全量弹幕任务并清空弹幕数
    _dmFetchTaskId++;
    _dmElemsFuture = null;
    _dmElemsCid = null;
    dmCount.value = null;
    defaultST = null;
    videoUrl = null;
    audioUrl = null;

    // danmaku
    savedDanmaku = null;
    danmakuMaskController.setSource(null);

    // subtitle
    subtitles.clear();
    vttSubtitlesIndex.value = -1;
    vttSubtitles.clear();

    if (plPlayerController.showViewPoints) {
      viewPointList.clear();
    }
    if (!PipOverlayService.isInPipMode) {
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
  int _dmTrendTaskId = 0;

  /// 当前分P弹幕数（null 表示尚未就绪）
  late final Rx<int?> dmCount = Rx<int?>(null);
  int _dmFetchTaskId = 0;
  int? _dmElemsCid;
  Future<List<DanmakuElem>?>? _dmElemsFuture;

  /// 拉取当前分P的全量弹幕；同一分P内复用结果，避免与高能进度条重复请求
  Future<List<DanmakuElem>?> _fetchAllDanmaku() {
    final cached = _dmElemsFuture;
    if (_dmElemsCid == cid.value && cached != null) {
      return cached;
    }
    final taskId = ++_dmFetchTaskId;
    bool shouldCancel() => taskId != _dmFetchTaskId || isClosed;
    final durationMs =
        data.timeLength ?? plPlayerController.durationInMilliseconds;
    return _dmElemsFuture = DanmakuDensityTrend.fetchAll(
      cid: cid.value,
      durationMs: durationMs,
      shouldCancel: shouldCancel,
    );
  }

  Future<void> _getDmCount() async {
    if (isFileSource) return;
    final elems = await _fetchAllDanmaku();
    if (elems == null || isClosed) return;
    dmCount.value = elems.length;
  }

  Future<void> _getDmTrend() async {
    final source = plPlayerController.dmChartSource;
    if (!source.isEnabled) {
      dmTrend.value = null;
      return;
    }

    final taskId = ++_dmTrendTaskId;
    bool shouldCancel() => taskId != _dmTrendTaskId || isClosed;

    dmTrend.value = LoadingState<List<double>>.loading();

    if (source.enableOfficial) {
      final official = await _tryGetOfficialDmTrend();
      if (shouldCancel()) return;
      if (official?.isNotEmpty == true) {
        dmTrend.value = Success(official!);
        return;
      }
      if (!source.enableLocalDensity) {
        dmTrend.value = const Error(null);
        return;
      }
    }

    if (source.enableLocalDensity) {
      final local = await _tryBuildLocalDmTrend(shouldCancel);
      if (shouldCancel()) return;
      if (local?.isNotEmpty == true) {
        dmTrend.value = Success(local!);
        return;
      }
    }

    dmTrend.value = const Error(null);
  }

  Future<List<double>?> _tryGetOfficialDmTrend() async {
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
        return data.events!.eDefault!;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('_tryGetOfficialDmTrend: $e');
    }
    return null;
  }

  Future<List<double>?> _tryBuildLocalDmTrend(
    bool Function() shouldCancel,
  ) async {
    try {
      final durationMs =
          data.timeLength ?? plPlayerController.durationInMilliseconds;
      final elems = await _fetchAllDanmaku();
      if (shouldCancel() || elems == null) return null;
      return await DanmakuDensityTrend.build(
        cid: cid.value,
        durationMs: durationMs,
        elems: elems,
      );
    } catch (e, s) {
      if (kDebugMode) debugPrint('_tryBuildLocalDmTrend: $e');
      Utils.reportError(e, s);
      return null;
    }
  }

  void showNoteList(BuildContext context) {
    String? title;
    try {
      title = Get.find<UgcIntroController>(
        tag: heroTag,
      ).videoDetail.value.title;
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
        final ctr = Get.find<UgcIntroController>(tag: heroTag);
        id = ctr.videoDetail.value.ugcSeason?.id;
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
    UgcIntroController? ugcIntroController;
    PgcInfoModel? pgcItem;
    if (isUgc) {
      try {
        ugcIntroController = Get.find<UgcIntroController>(tag: heroTag);
        videoDetail = ugcIntroController.videoDetail.value;
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
        pgcItem = Get.find<PgcIntroController>(tag: heroTag).pgcItem;
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
      final index = episodes.indexWhere(
        (e) => e.cid == (seasonCid ?? cid.value),
      );

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
              ugcIntroController: ugcIntroController,
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

  ThemeData get theme => ThemeUtils.theme;

  @pragma('vm:notify-debugger-on-exception')
  Future<void> onCast() async {
    SmartDialog.showLoading();
    final res = await VideoHttp.tvPlayUrl(
      cid: cid.value,
      objectId: epId ?? aid,
      playurlType: epId != null ? 2 : 1,
      qn: currentVideoQa.value?.code,
    );
    SmartDialog.dismiss();
    if (res case Success(:final response)) {
      final first = response.durl?.firstOrNull;
      if (first == null || first.playUrls.isEmpty) {
        SmartDialog.showToast('不支持投屏');
        return;
      }
      final url = VideoUtils.getCdnUrl(first.playUrls);

      String? title;
      try {
        if (isUgc) {
          title = Get.find<UgcIntroController>(
            tag: heroTag,
          ).videoDetail.value.title;
        } else {
          title = Get.find<PgcIntroController>(
            tag: heroTag,
          ).videoDetail.value.title;
        }
      } catch (_) {}
      if (kDebugMode) {
        debugPrint(title);
      }
      Get.toNamed(
        '/dlna',
        parameters: {
          'url': url,
          'title': ?title,
        },
      );
    } else {
      res.toast();
    }
  }
}
