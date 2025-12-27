import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/live_emote.dart';
import 'package:PiliPlus/models_new/live/live_dm_info/data.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/codec.dart';
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
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LiveRoomController extends GetxController {
  LiveRoomController(this.heroTag);
  final String heroTag;

  int roomId = Get.arguments;
  DanmakuController<DanmakuExtra>? danmakuController;
  PlPlayerController plPlayerController = PlPlayerController.getInstance(
    isLive: true,
  );

  RxBool isLoaded = false.obs;
  Rx<RoomInfoH5Data?> roomInfoH5 = Rx<RoomInfoH5Data?>(null);

  Rx<int?> liveTime = Rx<int?>(null);
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
  RxList<DanmakuMsg> messages = <DanmakuMsg>[].obs;
  late final Rx<SuperChatItem?> fsSC = Rx<SuperChatItem?>(null);
  late final RxList<SuperChatItem> superChatMsg = <SuperChatItem>[].obs;
  RxBool disableAutoScroll = false.obs;
  LiveMessageStream? _msgStream;
  late final ScrollController scrollController;
  late final RxInt pageIndex = 0.obs;
  PageController? pageController;

  int? currentQn = PlatformUtils.isMobile ? null : Pref.liveQuality;
  RxString currentQnDesc = ''.obs;
  final RxBool isPortrait = false.obs;
  late List<({int code, String desc})> acceptQnList = [];

  late final bool isLogin;
  late final int mid;
  late final int mainMid = Accounts.main.mid;

  String? videoUrl;
  bool? isPlaying;
  late bool isFullScreen = false;

  final superChatType = Pref.superChatType;
  late final showSuperChat = superChatType != SuperChatType.disable;

  final headerKey = GlobalKey<TimeBatteryMixin>();

  final RxString title = ''.obs;

  final RxnString onlineCount = RxnString();
  Widget get onlineWidget => Obx(() {
    if (onlineCount.value case final onlineCount?) {
      return Text(
        '高能观众($onlineCount)',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      );
    }
    return const SizedBox.shrink();
  });

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

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(listener);
    final account = Accounts.heartbeat;
    isLogin = account.isLogin;
    mid = account.mid;
    queryLiveUrl();
    queryLiveInfoH5();
    if (isLogin && !Pref.historyPause) {
      VideoHttp.roomEntryAction(roomId: roomId);
    }
    if (showSuperChat) {
      pageController = PageController();
    }
  }

  Future<void>? playerInit({bool autoplay = true}) {
    if (videoUrl == null) {
      return null;
    }
    return plPlayerController.setDataSource(
      DataSource(
        videoSource: videoUrl,
        audioSource: null,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl,
        },
      ),
      isLive: true,
      autoplay: autoplay,
      isVertical: isPortrait.value,
    );
  }

  Future<void> queryLiveUrl() async {
    currentQn ??= await Utils.isWiFi
        ? Pref.liveQuality
        : Pref.liveQualityCellular;
    final res = await LiveHttp.liveRoomInfo(
      roomId: roomId,
      qn: currentQn,
      onlyAudio: plPlayerController.onlyPlayAudio.value,
    );
    if (res.isSuccess) {
      final data = res.data;
      if (data.liveStatus != 1) {
        _showDialog('当前直播间未开播');
        return;
      }
      if (data.playurlInfo?.playurl == null) {
        _showDialog('无法获取播放地址');
        return;
      }
      if (data.roomId != null) {
        roomId = data.roomId!;
      }
      liveTime.value = data.liveTime;
      startLiveTimer();
      isPortrait.value = data.isPortrait ?? false;
      List<CodecItem> codec =
          data.playurlInfo!.playurl!.stream!.first.format!.first.codec!;
      CodecItem item = codec.first;
      // 以服务端返回的码率为准
      currentQn = item.currentQn!;
      acceptQnList = item.acceptQn!.map((e) {
        return (
          code: e,
          desc: LiveQuality.fromCode(e)?.desc ?? e.toString(),
        );
      }).toList();
      currentQnDesc.value =
          LiveQuality.fromCode(currentQn)?.desc ?? currentQn.toString();
      videoUrl = VideoUtils.getLiveCdnUrl(item);
      await playerInit();
      isLoaded.value = true;
    } else {
      _showDialog(res.toString());
    }
  }

  Future<void> queryLiveInfoH5() async {
    final res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res.isSuccess) {
      final data = res.data;
      roomInfoH5.value = data;
      title.value = data.roomInfo?.title ?? '';
      watchedShow.value = data.watchedShow?.textLarge;
      videoPlayerServiceHandler?.onVideoDetailChange(data, roomId, heroTag);
    } else {
      res.toast();
    }
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
              style: TextStyle(color: Get.theme.colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () => Get
              ..back()
              ..back(),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  void scrollToBottom([_]) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  void jumpToBottom() {
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
    final res = await LiveHttp.liveRoomDanmaPrefetch(roomId: roomId);
    if (res['status']) {
      if (res['data'] case List list) {
        try {
          messages.addAll(
            list.cast<Map<String, dynamic>>().map(DanmakuMsg.fromPrefetch),
          );
          WidgetsBinding.instance.addPostFrameCallback(scrollToBottom);
        } catch (_) {}
      }
    }
  }

  Future<void> getSuperChatMsg() async {
    final res = await LiveHttp.superChatMsg(roomId);
    if (res.dataOrNull?.list case final list?) {
      superChatMsg.addAll(list);
    }
  }

  void clearSC() {
    superChatMsg.removeWhere((e) => e.expired);
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
      if (res.isSuccess) {
        initDm(dmInfo = res.data);
      }
    });
  }

  void listener() {
    final userScrollDirection = scrollController.position.userScrollDirection;
    if (userScrollDirection == ScrollDirection.forward) {
      disableAutoScroll.value = true;
    } else if (userScrollDirection == ScrollDirection.reverse) {
      final pos = scrollController.position;
      if (pos.maxScrollExtent - pos.pixels <= 100) {
        disableAutoScroll.value = false;
      }
    }
  }

  @override
  void onClose() {
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
    super.onClose();
  }

  // 修改画质
  FutureOr<void> changeQn(int qn) {
    if (currentQn == qn) {
      return null;
    }
    currentQn = qn;
    currentQnDesc.value =
        LiveQuality.fromCode(currentQn)?.desc ?? currentQn.toString();
    return queryLiveUrl();
  }

  void initDm(LiveDmInfoData info) {
    if (info.hostList.isNullOrEmpty) {
      return;
    }
    _msgStream =
        LiveMessageStream(
            streamToken: info.token!,
            roomId: roomId,
            uid: mid,
            servers: info.hostList!
                .map((host) => 'wss://${host.host}:${host.wssPort}/sub')
                .toList(),
          )
          ..addEventListener(_danmakuListener)
          ..init();
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
          final Map<String, dynamic> extra = jsonDecode(content['extra']);
          final user = content['user'];
          // final midHash = first[7];
          final uid = user['uid'];
          final name = user['base']['name'];
          final msg = info[1];
          BaseEmote? uemote;
          if (first[13] case Map<String, dynamic> map) {
            uemote = BaseEmote.fromJson(map);
          }
          messages.add(
            DanmakuMsg(
              name: name,
              uid: uid,
              text: msg,
              emots: (extra['emots'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, BaseEmote.fromJson(v)),
              ),
              uemote: uemote,
            ),
          );

          if (plPlayerController.showDanmaku) {
            final checkInfo = info[9];
            danmakuController?.addDanmaku(
              DanmakuContentItem(
                msg,
                color: DanmakuOptions.blockColorful
                    ? Colors.white
                    : DmUtils.decimalToColor(extra['color']),
                type: DmUtils.getPosition(extra['mode']),
                // extra['send_from_me'] is invalid
                selfSend: uid == mainMid,
                extra: LiveDanmaku(
                  id: extra['id_str'],
                  mid: uid,
                  dmType: extra['dm_type'],
                  ts: checkInfo['ts'],
                  ct: checkInfo['ct'],
                ),
              ),
            );
            if (!disableAutoScroll.value) {
              EasyThrottle.throttle(
                'liveDm',
                const Duration(milliseconds: 500),
                () => WidgetsBinding.instance.addPostFrameCallback(
                  scrollToBottom,
                ),
              );
            }
          }
          break;
        case 'SUPER_CHAT_MESSAGE' when showSuperChat:
          final item = SuperChatItem.fromJson(obj['data']);
          superChatMsg.insert(0, item);
          if (isFullScreen || plPlayerController.isDesktopPip) {
            fsSC.value = item.copyWith(
              endTime: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 10,
            );
          }
          break;
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
    } catch (_) {}
  }

  final RxInt likeClickTime = 0.obs;
  Timer? likeClickTimer;

  void cancelLikeTimer() {
    likeClickTimer?.cancel();
    likeClickTimer = null;
  }

  void onLikeTapDown([_]) {
    cancelLikeTimer();
    likeClickTime.value++;
  }

  void onLikeTapUp([_]) {
    likeClickTimer ??= Timer(
      const Duration(milliseconds: 800),
      onLike,
    );
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

  void onSendDanmaku([bool fromEmote = false]) {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.key.currentState!.push(
      PublishRoute(
        pageBuilder: (context, animation, secondaryAnimation) {
          return LiveSendDmPanel(
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
          );
        },
        transitionDuration: fromEmote
            ? const Duration(milliseconds: 400)
            : const Duration(milliseconds: 500),
      ),
    );
  }
}
