import 'dart:async';
import 'dart:convert';

import 'package:PiliPlus/common/widgets/text_field/controller.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/live_emote.dart';
import 'package:PiliPlus/models_new/live/live_dm_info/data.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/codec.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/pages/danmaku/dnamaku_model.dart';
import 'package:PiliPlus/pages/live_room/send_danmaku/view.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/tcp/live.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart';
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

  // dm
  LiveDmInfoData? dmInfo;
  List<RichTextItem>? savedDanmaku;
  RxList<DanmakuMsg> messages = <DanmakuMsg>[].obs;
  late final Rx<SuperChatItem?> fsSC = Rx<SuperChatItem?>(null);
  late final RxList<SuperChatItem> superChatMsg = <SuperChatItem>[].obs;
  RxBool disableAutoScroll = false.obs;
  LiveMessageStream? _msgStream;
  late final ScrollController scrollController = ScrollController()
    ..addListener(listener);
  late final RxInt pageIndex = 0.obs;
  PageController? pageController;

  int? currentQn = Utils.isMobile ? null : Pref.liveQuality;
  RxString currentQnDesc = ''.obs;
  final RxBool isPortrait = false.obs;
  late List<({int code, String desc})> acceptQnList = [];

  late final bool isLogin;
  late final int mid;

  String? videoUrl;
  bool? isPlaying;
  late bool isFullScreen = false;

  final showSuperChat = Pref.showSuperChat;

  @override
  void onInit() {
    super.onInit();
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
    var res = await LiveHttp.liveRoomInfo(
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
      videoUrl = VideoUtils.getCdnUrl(item);
      await playerInit();
      isLoaded.value = true;
    } else {
      _showDialog(res.toString());
    }
  }

  Future<void> queryLiveInfoH5() async {
    var res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res['status']) {
      RoomInfoH5Data data = res['data'];
      roomInfoH5.value = data;
      videoPlayerServiceHandler?.onVideoDetailChange(data, roomId, heroTag);
    } else {
      if (res['msg'] != null) {
        _showDialog(res['msg']);
      }
    }
  }

  void _showDialog(String title) {
    Get.dialog(
      AlertDialog(
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

  Future<void> prefetch() async {
    final res = await LiveHttp.liveRoomDanmaPrefetch(roomId: roomId);
    if (res['status']) {
      if (res['data'] case List list) {
        try {
          messages.addAll(
            list.cast<Map<String, dynamic>>().map(DanmakuMsg.fromPrefetch),
          );
          WidgetsBinding.instance.addPostFrameCallback(scrollToBottom);
        } catch (e) {
          if (kDebugMode) debugPrint(e.toString());
        }
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
      if (res['status']) {
        dmInfo = res['data'];
        initDm(dmInfo!);
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
          ..addEventListener((obj) {
            try {
              // logger.i(' 原始弹幕消息 ======> ${jsonEncode(obj)}');
              switch (obj['cmd']) {
                case 'DANMU_MSG':
                  final info = obj['info'];
                  final first = info[0];
                  final content = first[15];
                  final Map<String, dynamic> extra = jsonDecode(
                    content['extra'],
                  );
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
                        color: plPlayerController.blockColorful
                            ? Colors.white
                            : DmUtils.decimalToColor(extra['color']),
                        type: DmUtils.getPosition(extra['mode']),
                        selfSend: extra['send_from_me'] ?? false,
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
                    fsSC.value = item;
                  }
                  break;
              }
            } catch (_) {
              if (kDebugMode) rethrow;
            }
          })
          ..init();
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
    var res = await LiveHttp.liveLikeReport(
      clickTime: likeClickTime.value,
      roomId: roomId,
      uid: mid,
      anchorId: roomInfoH5.value?.roomInfo?.uid,
    );
    if (res['status']) {
      SmartDialog.showToast('点赞成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
    likeClickTime.value = 0;
  }

  void onSendDanmaku([bool fromEmote = false]) {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.generalDialog(
      barrierLabel: '',
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return LiveSendDmPanel(
          fromEmote: fromEmote,
          liveRoomController: this,
          items: savedDanmaku,
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
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.linear));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
