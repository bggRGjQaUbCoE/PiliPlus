import 'dart:async' show Timer, StreamSubscription;
import 'dart:convert' show jsonDecode;
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/live_emote.dart';
import 'package:PiliPlus/models_new/live/live_dm_info/data.dart';
import 'package:PiliPlus/models_new/live/live_fans_medal/data.dart';
import 'package:PiliPlus/models_new/live/live_fans_medal/item.dart';
import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/codec.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/stream.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/live_room/send_danmaku/view.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/tcp/live.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/rx_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

const int _kMaxChatCount = 500;
const int _kTrimCount = _kMaxChatCount + 50;
const int _kSafeTrimIndex = 200;

class LiveRoomController extends GetxController {
  LiveRoomController(this.heroTag, {this.fromPip = false});
  final String heroTag;
  final bool fromPip;

  late int roomId;
  bool isReturningFromPip = false;
  int? ruid;
  DanmakuController<DanmakuExtra>? danmakuController;
  PlPlayerController plPlayerController = PlPlayerController.getInstance(
    isLive: true,
  );

  final isLoaded = false.obs;
  final roomInfoH5 = Rxn<RoomInfoH5Data>();

  final liveTime = Rxn<int>();

  // PiP 模式标志
  RxBool isInPipMode = false.obs;

  // 三点菜单「应用内画中画」的触发入口，由直播页 State 绑定：
  // 小窗流程依赖页面的路由生命周期（pop 收起），controller 自身无法发起
  VoidCallback? onRequestInAppPip;

  /// 直播页能否被 pop：页面 popScope 的 canPop 与三点菜单小窗入口共用
  bool get canPopPage =>
      !plPlayerController.isFullScreen.value && !plPlayerController.isDesktopPip;

  Timer? liveTimeTimer;

  void startLiveTimer() {
    if (liveTime.value != null) {
      liveTimeTimer ??= Timer.periodic(
        const Duration(minutes: 5),
        (_) => liveTime.refresh(),
      );
    }
  }

  void cancelLiveTimer() {
    liveTimeTimer?.cancel();
    liveTimeTimer = null;
  }

  Widget get timeWidget => Obx(() {
    final liveTime = this.liveTime.value;
    String text = '';
    if (liveTime != null) {
      final duration = DurationUtils.formatDurationBetween(
        liveTime * 1000,
        DateTime.now().millisecondsSinceEpoch,
      );
      text += duration.isEmpty ? '刚刚开播' : '开播$duration';
    }
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
    );
  });

  // dm
  LiveDmInfoData? dmInfo;
  List<RichTextItem>? savedDanmaku;
  int builtLength = 0;
  final messages = <dynamic>[].obs;
  bool get shouldRefresh => builtLength != messages.length;
  late final fsSC = Rxn<SuperChatItem>();
  late final RxList<SuperChatItem> superChatMsg = <SuperChatItem>[].obs;
  final disableAutoScroll = false.obs;
  bool autoScroll = true;
  LiveMessageStream? _msgStream;
  List<String> _keywordList = const [];
  Set<int> _shieldUids = const {};
  late final ScrollController scrollController;
  late final RxInt pageIndex = 0.obs;
  PageController? pageController;

  int? currentQn = PlatformUtils.isMobile ? null : Pref.liveQuality;
  final currentQnDesc = ''.obs;
  final RxBool isPortrait = false.obs;
  late List<({int code, String desc})> acceptQnList = [];

  late final bool isLogin;
  late final int mid;

  // ---------- 粉丝勋章 ----------
  final Rxn<FansMedalPanelData> fansMedalData = Rxn();
  final Rxn<UinfoMedal> wearingMedal = Rxn();
  final RxBool fansMedalLoading = false.obs;
  final Rxn<String> fansMedalError = Rxn();
  bool _fansMedalStale = false;
  Future<void>? _fansMedalReq;
  int _fansMedalPage = 1;
  bool _fansMedalLoadingMore = false;
  final RxBool fansMedalHasMore = false.obs;

  Object? get medalTargetId => ruid ?? roomInfoH5.value?.roomInfo?.uid;

  String? videoUrl;
  bool? isPlaying;
  late bool isFullScreen = false;

  final superChatType = Pref.superChatType;
  late final showSuperChat = superChatType != SuperChatType.disable;
  final superChatTimeType = Pref.superChatTimeType;

  final headerKey = GlobalKey<TimeBatteryMixin>();

  final RxString title = ''.obs;

  final RxnString onlineCount = RxnString();

  final RxnString watchedShow = RxnString();
  Widget get watchedWidget => Obx(() {
    if (watchedShow.value case final watchedShow?) {
      return Text(
        watchedShow,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      );
    }
    return const SizedBox.shrink();
  });

  int chatSimpleIndex = 0;
  int _trimDmIndex = 0;
  int get trimDmIndex => _trimDmIndex;
  void _trimDm() {
    final trimCount = messages.length - _trimDmIndex;
    if (trimCount > _kTrimCount) {
      final endIndex = messages.length - _kMaxChatCount;
      final canTrim = (chatSimpleIndex - endIndex) > _kSafeTrimIndex;
      if (canTrim) {
        messages.fillRangeOnly(_trimDmIndex, endIndex);
        _trimDmIndex = endIndex;
      }
    }
  }

  StreamSubscription? _sizeSub;

  void _onSizeChanged((int, int) value) {
    final isVertical = value.$2 > value.$1;
    isPortrait.value = isVertical;
    plPlayerController.isVertical = isVertical;
  }

  void _startSizeSub() {
    if (isPortrait.value) return;
    _stopSizeSub();
    _sizeSub = plPlayerController.videoPlayerController?.stream.size.listen(
      _onSizeChanged,
    );
  }

  void _stopSizeSub() {
    _sizeSub?.cancel();
    _sizeSub = null;
  }

  @override
  void onInit() {
    super.onInit();
    plPlayerController.onNeedsPlayerInit = () => queryLiveUrl();

    // 从参数中提取 roomId（支持 int 或 Map 格式）
    final args = Get.arguments;
    if (args is Map) {
      roomId = (args['roomId'] as int?) ?? (args['id'] as int? ?? 0);
    } else {
      roomId = args as int;
    }

    scrollController = ScrollController()..addListener(listener);
    final account = Accounts.main;
    isLogin = account.isLogin;
    mid = account.mid;

    // 直接透传构造函数传入的 fromPip 标志，因为它在 view.dart 中已经经过了校验
    isReturningFromPip = fromPip;

    if (isReturningFromPip) {
      isPortrait.value = plPlayerController.isVertical;
      isLoaded.value = true;
      // 播放器无需重建，但 stream/ruid/liveTime 等元数据随旧 controller 丢失，
      // 必须重新拉取；playerInit 会因 isReturningFromPip 跳过数据源初始化
      queryLiveUrl();
    } else {
      queryLiveUrl(autoFullScreenFlag: true);
    }
    queryLiveInfoH5();
    if (Accounts.heartbeat.isLogin && !Pref.historyPause) {
      VideoHttp.roomEntryAction(roomId: roomId);
    }
    if (showSuperChat) {
      pageController = PageController();
    }
  }

  Future<void>? playerInit({
    bool autoplay = true,
    bool autoFullScreenFlag = false,
  }) {
    if (videoUrl == null) {
      return null;
    }
    // 如果是从小窗返回，播放器已在播放，跳过初始化
    if (isReturningFromPip) {
      return null;
    }

    // 如果播放器已被彻底销毁（例如在其他页面关闭了小窗），重新获取单例实例
    if (plPlayerController.videoPlayerController == null) {
      plPlayerController = PlPlayerController.ensureInstance(isLive: true);
    }

    // 确保播放器处于直播模式
    plPlayerController.isLive = true;

    return plPlayerController
        .setDataSource(
          NetworkSource(videoSource: videoUrl!, audioSource: null),
          isLive: true,
          autoplay: autoplay,
          isVertical: isPortrait.value,
          autoFullScreenFlag: autoFullScreenFlag,
          roomId: roomId,
        )
        .then((_) async {
          if (!autoplay) {
            return;
          }
          final isActuallyPlaying =
              plPlayerController.videoPlayerController?.state.playing == true;
          if (!isActuallyPlaying) {
            await plPlayerController.play();
          }
        });
  }

  Future<void> queryLiveUrl({bool autoFullScreenFlag = false}) async {
    currentQn ??= await ConnectivityUtils.isWiFi
        ? Pref.liveQuality
        : Pref.liveQualityCellular;
    final res = await LiveHttp.liveRoomInfo(
      roomId: roomId,
      qn: currentQn,
      onlyAudio: plPlayerController.onlyPlayAudio.value,
    );
    if (res case Success(:final response)) {
      if (response.liveStatus != 1) {
        _showDialog('当前直播间未开播');
        return;
      }
      final playurl = response.playurlInfo?.playurl;
      if (playurl == null) {
        _showDialog('无法获取播放地址');
        return;
      }
      ruid = response.uid;
      if (response.roomId case final roomId?) {
        this.roomId = roomId;
      }
      liveTime.value = response.liveTime;
      startLiveTimer();
      if (Accounts.heartbeat.isLogin) {
        LiveHttp.startLiveHeartbeat(roomId, ruid!);
      }
      isPortrait.value = response.isPortrait ?? false;
      stream = playurl.stream;
      _initStreamIndex();
      await Future.wait([
        ?initLiveUrl(
          streamIndex: streamIndex,
          formatIndex: formatIndex,
          codecIndex: codecIndex,
          liveUrlIndex: liveUrlIndex,
        ),
        if (!isLoaded.value && Accounts.heartbeat.isLogin) _fetchBlockRules(),
      ]);

      // 置于 initLiveUrl 之后：恢复场景的首次拉取靠该标志让 playerInit 跳过
      // 数据源重建，完成后清零，切换路线/画质才会真正重建数据源
      isReturningFromPip = false;
      isLoaded.value = true;
    } else {
      _showDialog(res.toString());
    }
  }

  // 拉取成功前为 null（含小窗恢复后的重拉窗口期），使用处需判空
  List<Stream>? stream;
  int streamIndex = 0;
  int formatIndex = 0;
  int codecIndex = 0;
  int liveUrlIndex = 0;

  void _initStreamIndex() {
    final pref = Pref.liveStream;
    if (pref != null) {
      try {
        final String protocolName = pref[0];
        final String formatName = pref[1];
        final String codecName = pref[2];
        for (var (i, s) in stream!.indexed) {
          if (s.protocolName == protocolName) {
            streamIndex = i;
            for (var (j, f) in s.format.indexed) {
              if (f.formatName == formatName) {
                formatIndex = j;
                for (var (k, c) in f.codec.indexed) {
                  if (c.codecName == codecName) {
                    codecIndex = k;
                    return;
                  }
                }
              }
            }
          }
        }
      } catch (_) {}
    }
  }

  Future<void>? initLiveUrl({
    int streamIndex = 0,
    int formatIndex = 0,
    int codecIndex = 0,
    int liveUrlIndex = 0,
  }) {
    this.streamIndex = streamIndex;
    this.formatIndex = formatIndex;
    this.codecIndex = codecIndex;
    this.liveUrlIndex = liveUrlIndex;

    final CodecItem item = stream!
        .getOrFirst(streamIndex)
        .format
        .getOrFirst(formatIndex)
        .codec
        .getOrFirst(codecIndex);
    // 以服务端返回的码率为准
    currentQn = item.currentQn;
    acceptQnList = item.acceptQn.map((e) {
      return (
        code: e,
        desc: LiveQuality.fromCode(e)?.desc ?? e.toString(),
      );
    }).toList();
    currentQnDesc.value =
        LiveQuality.fromCode(currentQn)?.desc ?? currentQn.toString();
    videoUrl = VideoUtils.getLiveCdnUrl(item, index: liveUrlIndex);
    return playerInit()?.whenComplete(_startSizeSub);
  }

  // 直播投屏时，优先选择 HLS 协议的播放地址，且不使用 AV1 编码
  // 实测发现http_stream协议在投屏时会报版权问题，导致无法播放，HLS协议则没有这个问题
  String? _preferredCastUrl() {
    final stream = this.stream;
    if (stream == null) {
      return null;
    }
    final currentCastUrl = _currentCastUrl();
    if (currentCastUrl != null) {
      return currentCastUrl;
    }

    final candidates = <({String url, int score})>[];
    for (final streamItem in stream) {
      final protocolName = streamItem.protocolName?.toLowerCase() ?? '';
      for (final formatItem in streamItem.format) {
        final formatName = formatItem.formatName?.toLowerCase() ?? '';
        for (final codecItem in formatItem.codec) {
          final codecName = codecItem.codecName?.toLowerCase() ?? '';
          for (final urlInfo in codecItem.urlInfo.indexed) {
            final url = VideoUtils.getLiveCdnUrl(codecItem, index: urlInfo.$1);
            final lowerUrl = url.toLowerCase();
            final isHls =
                protocolName.contains('hls') || lowerUrl.contains('.m3u8');
            if (!isHls) {
              continue;
            }
            var score = 0;
            if (formatName.contains('ts')) {
              score += 40;
            }
            if (formatName.contains('fmp4')) {
              score += 20;
            }
            if (codecName.contains('avc') || codecName.contains('h264')) {
              score += 30;
            }
            if (codecName.contains('hevc') || codecName.contains('h265')) {
              score -= 20;
            }
            if (codecName.contains('av1')) {
              score -= 30;
            }
            if (codecItem.currentQn == currentQn) {
              score += 10;
            }
            if (urlInfo.$1 == liveUrlIndex) {
              score += 5;
            }
            candidates.add((url: url, score: score));
          }
        }
      }
    }
    if (candidates.isEmpty) {
      return null;
    }
    candidates.sort((a, b) => b.score.compareTo(a.score));
    return candidates.first.url;
  }

  String? _currentCastUrl() {
    final streamItem = stream!.getOrFirst(streamIndex);
    final formatItem = streamItem.format.getOrFirst(formatIndex);
    final codecItem = formatItem.codec.getOrFirst(codecIndex);
    final url = VideoUtils.getLiveCdnUrl(codecItem, index: liveUrlIndex);
    final protocolName = streamItem.protocolName?.toLowerCase() ?? '';
    final codecName = codecItem.codecName?.toLowerCase() ?? '';
    final lowerUrl = url.toLowerCase();
    final isHls = protocolName.contains('hls') || lowerUrl.contains('.m3u8');
    if (!isHls || codecName.contains('av1')) {
      return null;
    }
    return url;
  }

  Future<void> queryLiveInfoH5() async {
    final res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res case Success(:final response)) {
      roomInfoH5.value = response;
      title.value = response.roomInfo?.title ?? '';
      watchedShow.value = response.watchedShow?.textLarge;
      videoPlayerServiceHandler?.onVideoDetailChange(response, roomId, heroTag);
    } else {
      res.toast();
    }
  }

  Future<void> onCast() async {
    final currentUrl = videoUrl;
    final url = _preferredCastUrl() ?? currentUrl;
    if (url == null || url.isEmpty) {
      SmartDialog.showToast('播放地址未就绪');
      return;
    }
    final castTitle = title.value.isNotEmpty ? title.value : null;
    await Get.toNamed(
      '/dlna',
      parameters: {
        'url': url,
        'title': ?castTitle,
      },
    );
  }

  void _showDialog(String title) {
    showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '关闭',
              style: TextStyle(color: ThemeUtils.theme.colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () {
              if (plPlayerController.isDesktopPip) {
                plPlayerController.exitDesktopPip();
              }
              Get
                ..back()
                ..back();
            },
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  void scrollToBottom() {
    EasyThrottle.throttle(
      'liveDm',
      const Duration(milliseconds: 500),
      () => WidgetsBinding.instance.addPostFrameCallback(_scrollToBottom),
    );
  }

  void _scrollToBottom([_]) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  void handleJumpToBottom() {
    disableAutoScroll.value = false;
    if (shouldRefresh) {
      messages.refresh();
      WidgetsBinding.instance.addPostFrameCallback(_jumpToBottom);
    } else {
      _jumpToBottom();
    }
  }

  void _jumpToBottom([_]) {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void closeLiveMsg() {
    _msgStream?.close();
    _msgStream = null;
  }

  @pragma('vm:notify-debugger-on-exception')
  Future<void> prefetch() async {
    final res = await LiveHttp.liveRoomDmPrefetch(roomId: roomId);
    if (res case Success(:final response)) {
      if (response != null && response.isNotEmpty) {
        messages.addAll(
          response.where((item) => !isBlocked(item.text, item.extra.mid)),
        );
        scrollToBottom();
      }
    } else {
      if (kDebugMode) {
        Utils.reportError(res.toString());
      }
    }
  }

  Future<void> getSuperChatMsg() async {
    final res = await LiveHttp.superChatMsg(roomId);
    if (res.dataOrNull?.list case final list? when list.isNotEmpty) {
      superChatMsg.addAll(list);
    }
  }

  void clearSC() {
    superChatMsg.removeWhere((e) => e.expired);
  }

  Future<void> _fetchBlockRules() async {
    final res = await LiveHttp.getLiveInfoByUser(roomId);
    if (res case Success(:final response?)) {
      if (response.keywordList case final keywordList?) {
        _keywordList = keywordList;
      }
      if (response.shieldUserList case final shieldUserList?) {
        _shieldUids = shieldUserList.map((e) => e.uid).toSet();
      }
    }
  }

  void updateBlockRules(List<String> keywords, Set<int> uids) {
    _keywordList = keywords;
    _shieldUids = uids;
  }

  bool isBlocked(String text, Object uid) {
    return _keywordList.any(text.contains) || _shieldUids.contains(uid);
  }

  void startLiveMsg() {
    if (messages.isEmpty) {
      prefetch();
      if (showSuperChat) {
        getSuperChatMsg();
      }
    }
    if (_msgStream != null) {
      return;
    }
    if (dmInfo != null) {
      initDm(dmInfo!);
      return;
    }
    LiveHttp.liveRoomGetDanmakuToken(roomId: roomId).then((res) {
      if (res case Success(:final response)) {
        initDm(dmInfo = response);
      }
    });
  }

  void listener() {
    final userScrollDirection = scrollController.position.userScrollDirection;
    if (userScrollDirection == .forward) {
      disableAutoScroll.value = true;
    } else if (userScrollDirection == .reverse) {
      final pos = scrollController.position;
      if (pos.maxScrollExtent - pos.pixels <= 100 && disableAutoScroll.value) {
        disableAutoScroll.value = false;
        refreshMsgIfNeeded();
      }
    }
  }

  void refreshMsgIfNeeded() {
    if (shouldRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        messages.refresh();
      });
    }
  }

  @override
  void onClose() {
    plPlayerController.onNeedsPlayerInit = null;
    _stopSizeSub();
    // 心跳定时器是静态的，无论是否小窗都要取消
    LiveHttp.cancelLiveHeartbeat();
    // 如果在小窗模式，不清理资源
    if (!isInPipMode.value) {
      closeLiveMsg();
      cancelLikeTimer();
      cancelLiveTimer();
      savedDanmaku?.clear();
      savedDanmaku = null;
      messages.clear();
      if (showSuperChat) {
        superChatMsg.clear();
        fsSC.value = null;
      }
      scrollController
        ..removeListener(listener)
        ..dispose();
      pageController?.dispose();
      danmakuController = null;
    }
    super.onClose();
  }

  // 修改画质
  Future<void>? changeQn(int qn) {
    if (currentQn == qn) {
      return null;
    }
    currentQn = qn;
    currentQnDesc.value =
        LiveQuality.fromCode(currentQn)?.desc ?? currentQn.toString();
    return queryLiveUrl();
  }

  void initDm(LiveDmInfoData info) {
    if (info.hostList.isEmpty) {
      return;
    }
    _msgStream =
        LiveMessageStream(
            streamToken: info.token,
            roomId: roomId,
            uid: Accounts.heartbeat.mid,
            servers: info.hostList
                .map((host) => 'wss://${host.host}:${host.wssPort}/sub')
                .toList(),
          )
          ..addEventListener(_danmakuListener)
          ..init();
  }

  void addDm(dynamic msg, [DanmakuContentItem<DanmakuExtra>? item]) {
    _trimDm();

    if (plPlayerController.showDanmaku) {
      if (item != null && plPlayerController.enableShowLiveDanmaku.value) {
        danmakuController?.addDanmaku(item);
      }
      if (autoScroll && !disableAutoScroll.value) {
        messages.add(msg);
        scrollToBottom();
        return;
      }
    }

    messages.addOnly(msg);
  }

  @pragma('vm:notify-debugger-on-exception')
  void _danmakuListener(dynamic obj) {
    try {
      // logger.i(' 原始弹幕消息 ======> ${jsonEncode(obj)}');
      switch (obj['cmd']) {
        case 'DANMU_MSG':
          final info = obj['info'];
          final first = info[0];
          final content = first[15];
          final user = content['user'];
          // final midHash = first[7];
          final uid = user['uid'];
          final msg = info[1];
          if (isBlocked(msg, uid)) {
            return;
          }
          final Map<String, dynamic> extra = jsonDecode(content['extra']);
          final name = user['base']['name'];
          BaseEmote? uemote;
          if (first[13] case Map<String, dynamic> map) {
            uemote = BaseEmote.fromJson(map);
          }
          final checkInfo = info[9];
          final liveExtra = LiveDanmaku(
            id: extra['id_str'],
            mid: uid,
            dmType: extra['dm_type'],
            ts: checkInfo['ts'],
            ct: checkInfo['ct'],
          );
          Owner? reply;
          final replyMid = extra['reply_mid'];
          if (replyMid != null && replyMid != 0) {
            reply = Owner(
              mid: replyMid,
              name: extra['reply_uname'],
            );
          }
          addDm(
            DanmakuMsg(
              name: name,
              text: msg,
              emots: (extra['emots'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, BaseEmote.fromJson(v)),
              ),
              uemote: uemote,
              extra: liveExtra,
              reply: reply,
              medalInfo: !GlobalData().showMedal || user['medal'] == null
                  ? null
                  : UinfoMedal.fromJson(user['medal']),
            ),
            DanmakuContentItem(
              msg,
              color: DanmakuOptions.blockColorful
                  ? Colors.white
                  : DmUtils.decimalToColor(extra['color']),
              type: DmUtils.getPosition(extra['mode']),
              // extra['send_from_me'] is invalid
              selfSend: isLogin && uid == mid,
              extra: liveExtra,
            ),
          );
          break;
        case 'SUPER_CHAT_MESSAGE' when showSuperChat:
          final item = SuperChatItem.fromJson(obj['data'], roomId);
          superChatMsg.insert(0, item);
          addDm(item);
          if (Platform.isAndroid && AndroidHelper.isPipMode) return;
          if (plPlayerController.showDanmaku &&
              (isFullScreen || plPlayerController.isDesktopPip)) {
            fsSC.value = item.copyWith(
              endTime: math.min(
                item.endTime,
                DateTime.now().millisecondsSinceEpoch ~/ 1000 + 10,
              ),
            );
          }
          break;
        // case 'SUPER_CHAT_MESSAGE_DELETE' when showSuperChat:
        //   if (obj['roomid'] == roomId) {
        //     final ids = obj['data']?['ids'] as List?;
        //     if (ids != null && ids.isNotEmpty) {
        //       if (superChatType == .valid) {
        //         superChatMsg.removeWhere((e) => ids.contains(e.id));
        //       } else {
        //         bool? refresh;
        //         for (final id in ids) {
        //           if (superChatMsg.firstWhereOrNull((e) => e.id == id)
        //               case final item?) {
        //             item.deleted = true;
        //             refresh ??= true;
        //           }
        //         }
        //         if (refresh ?? false) {
        //           superChatMsg.refresh();
        //         }
        //       }
        //     }
        //   }
        case 'WATCHED_CHANGE':
          watchedShow.value = obj['data']['text_large'];
          break;
        case 'ONLINE_RANK_COUNT':
          onlineCount.value = NumUtils.numFormat(obj['data']['count']);
          break;
        case 'ROOM_CHANGE':
          title.value = obj['data']['title'];
          break;
      }
    } catch (e, s) {
      if (kDebugMode) {
        Utils.reportError(e, s);
      }
    }
  }

  final RxInt likeClickTime = 0.obs;
  Timer? likeClickTimer;

  void cancelLikeTimer() {
    likeClickTimer?.cancel();
    likeClickTimer = null;
  }

  void onLikeTapDown(_) {
    cancelLikeTimer();
    likeClickTime.value++;
  }

  void onLikeTapUp([_]) {
    likeClickTimer ??= Timer(const Duration(milliseconds: 800), onLike);
  }

  Future<void> onLike() async {
    if (!isLogin) {
      likeClickTime.value = 0;
      return;
    }
    final res = await LiveHttp.liveLikeReport(
      clickTime: likeClickTime.value,
      roomId: roomId,
      uid: mid,
      anchorId: roomInfoH5.value?.roomInfo?.uid,
    );
    if (res.isSuccess) {
      SmartDialog.showToast('点赞成功');
    } else {
      res.toast();
    }
    likeClickTime.value = 0;
  }

  void toastNotLogin() {
    SmartDialog.showToast('账号未登录');
  }

  void onSendDanmaku([bool fromEmote = false]) {
    if (kReleaseMode && !isLogin) {
      toastNotLogin();
      return;
    }
    Get.key.currentState!.push(
      PublishRoute(
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Theme(
            data: ThemeUtils.darkTheme,
            child: LiveSendDmPanel(
              fromEmote: fromEmote,
              liveRoomController: this,
              items: savedDanmaku,
              autofocus: !fromEmote,
              onSave: (msg) {
                if (msg.isEmpty) {
                  savedDanmaku?.clear();
                  savedDanmaku = null;
                } else {
                  savedDanmaku = msg.toList();
                }
              },
            ),
          );
        },
        transitionDuration: fromEmote
            ? const Duration(milliseconds: 400)
            : PlatformUtils.isDesktop
            ? const Duration(milliseconds: 350)
            : const Duration(milliseconds: 400),
      ),
    );
  }

  void onAtUser(DanmakuMsg item) {
    savedDanmaku = [
      RichTextItem.fromStart(
        '@${item.name} ',
        rawText: item.extra.mid.toString(),
        type: .at,
        id: item.extra.id.toString(),
      ),
    ];
    onSendDanmaku();
  }

  void reportSC(SuperChatItem item) {
    if (!isLogin) {
      toastNotLogin();
      return;
    }
    autoWrapReportDialog(
      Get.context!,
      ban: false,
      ReportOptions.liveDanmakuReport,
      withContent: ReportOptions.liveDanmakuReportCheck,
      contentRequired: ReportOptions.liveDanmakuReportCheck,
      (reasonType, reasonDesc, banUid) {
        return LiveHttp.superChatReport(
          id: item.id,
          roomId: roomId,
          uid: item.uid,
          msg: item.message,
          reason: ReportOptions.liveDanmakuReport['']![reasonType]!,
          ts: item.ts,
          token: item.token,
        );
      },
    );
  }

  // ---------- 粉丝勋章 ----------

  Future<void> loadFansMedal({bool force = false}) async {
    if (!isLogin) return;
    if (_fansMedalReq != null) return _fansMedalReq;
    if (!force && !_fansMedalStale && fansMedalData.value != null) return;
    final targetId = medalTargetId;
    if (targetId == null) return;

    fansMedalLoading.value = true;
    _fansMedalReq = _doLoadFansMedal(targetId: targetId);
    try {
      await _fansMedalReq;
    } finally {
      fansMedalLoading.value = false;
      _fansMedalReq = null;
    }
  }

  Future<void> _doLoadFansMedal({
    required Object targetId,
  }) async {
    final res = await LiveHttp.fansMedalPanel(
      roomId: roomId,
      targetId: targetId,
      page: 1,
    );
    if (res case Success(:final response)) {
      fansMedalData.value = response;
      _fansMedalPage = 1;
      _updateFansMedalHasMore(response);
      _updateWearingMedal(response);
      _fansMedalStale = false;
      fansMedalError.value = null;
    } else {
      fansMedalError.value = res.toString();
    }
  }

  void _updateFansMedalHasMore(FansMedalPanelData data) {
    final itemCount = (data.specialList?.length ?? 0) + (data.list?.length ?? 0);
    fansMedalHasMore.value = _calcHasMore(data, itemCount);
  }

  bool _calcHasMore(FansMedalPanelData data, int loadedCount) {
    if (data.hasMore != true) return false;
    if (data.nextPage == null || data.nextPage! <= _fansMedalPage) return false;
    if (data.totalNumber != null && loadedCount >= data.totalNumber!) {
      return false;
    }
    if (_fansMedalPage >= 20) return false;
    return true;
  }

  void _updateWearingMedal(FansMedalPanelData data) {
    final allItems = [
      ...?data.specialList,
      ...?data.list,
    ];
    final wearing = allItems.cast<FansMedalItem?>().firstWhere(
      (item) => item?.medal?.wearingStatus == 1,
      orElse: () => null,
    );
    wearingMedal.value = wearing?.uinfoMedal;
  }

  void markFansMedalStale() {
    _fansMedalStale = true;
  }

  Future<void> loadMoreFansMedal() async {
    if (_fansMedalLoadingMore) return;
    if (_fansMedalReq != null) return;
    if (!fansMedalHasMore.value) return;
    final targetId = medalTargetId;
    if (targetId == null) return;

    _fansMedalLoadingMore = true;
    final nextPage = _fansMedalPage + 1;
    final res = await LiveHttp.fansMedalPanel(
      roomId: roomId,
      targetId: targetId,
      page: nextPage,
    );
    if (res case Success(:final response)) {
      final data = fansMedalData.value;
      if (data != null) {
        final existingIds = <int>{};
        for (final item in [...?data.specialList, ...?data.list]) {
          if (item.medal?.medalId case final id?) existingIds.add(id);
        }
        final newList = <FansMedalItem>[];
        for (final item in (response.list ?? <FansMedalItem>[])) {
          if (item.medal?.medalId case final id?) {
            if (!existingIds.contains(id)) {
              newList.add(item);
              existingIds.add(id);
            }
          } else {
            newList.add(item);
          }
        }
        if (newList.isEmpty) {
          fansMedalHasMore.value = false;
          _fansMedalLoadingMore = false;
          return;
        }
        data
          ..list = [...?data.list, ...newList]
          ..hasMore = response.hasMore
          ..nextPage = response.nextPage;
        _fansMedalPage = nextPage;
        final itemCount = (data.specialList?.length ?? 0) +
            (data.list?.length ?? 0);
        fansMedalHasMore.value = _calcHasMore(data, itemCount);
        fansMedalData.refresh();
      }
    } else {
      res.toast();
    }
    _fansMedalLoadingMore = false;
  }

  Future<bool> wearFansMedal(FansMedalItem item) async {
    final targetId = medalTargetId;
    if (targetId == null) return false;
    final medalId = item.medal?.medalId;
    if (medalId == null) return false;

    final res = await LiveHttp.fansMedalWear(
      medalId: medalId,
      targetId: targetId,
    );
    if (res.isSuccess) {
      _applyWearStatus(medalId, 1);
      wearingMedal.value = item.uinfoMedal;
      _fansMedalStale = true;
      SmartDialog.showToast('已佩戴 ${item.medal?.medalName ?? ''}');
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  Future<bool> takeOffFansMedal(FansMedalItem item) async {
    final targetId = medalTargetId;
    if (targetId == null) return false;
    final medalId = item.medal?.medalId;
    if (medalId == null) return false;

    final res = await LiveHttp.fansMedalTakeOff(
      medalId: medalId,
      targetId: targetId,
    );
    if (res.isSuccess) {
      _applyWearStatus(medalId, 0);
      wearingMedal.value = null;
      _fansMedalStale = true;
      SmartDialog.showToast('已取消佩戴');
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  void _applyWearStatus(int medalId, int status) {
    final data = fansMedalData.value;
    if (data == null) return;
    for (final item in [...?data.specialList, ...?data.list]) {
      if (item.medal?.medalId == medalId) {
        item.medal?.wearingStatus = status;
      } else {
        item.medal?.wearingStatus = 0;
      }
    }
    fansMedalData.refresh();
  }
}
