import 'dart:async' show Timer, StreamSubscription;
import 'dart:convert' show jsonDecode;
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/video/base_quality.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/danmaku_msg.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/live_emote.dart';
import 'package:PiliPlus/models_new/live/live_dm_info/data.dart';
import 'package:PiliPlus/models_new/live/live_info_by_user/medal.dart';
import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';
import 'package:PiliPlus/models_new/live/live_room_info_h5/data.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/codec.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/stream.dart';
import 'package:PiliPlus/models_new/live/live_superchat/item.dart';
import 'package:PiliPlus/models_new/live/live_trace/data.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';
import 'package:PiliPlus/pages/fans_medal/controller.dart';
import 'package:PiliPlus/pages/live_room/send_danmaku/view.dart';
import 'package:PiliPlus/pages/video/widgets/header_control.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:PiliPlus/services/logger.dart' show logger;
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/tcp/live.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/rx_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

part 'package:PiliPlus/pages/live_room/controller_mixin/block.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/data.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/dm.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/dm_stream.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/dm_trim.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/like.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/medal.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/sc.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/size.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/time.dart';
part 'package:PiliPlus/pages/live_room/controller_mixin/trace.dart';

const int _kMaxChatCount = 500;
const int _kTrimCount = _kMaxChatCount + 50;
const int _kSafeTrimIndex = 200;

class LiveRoomController extends GetxController
    with
        _LiveDataMixin,
        _LiveSCMixin,
        _LiveTimeMixin,
        _LiveTraceMixin,
        _LiveMedalMixin,
        _LiveBlockMixin,
        _LiveDMMixin,
        _LiveDMTrimMixin,
        _LiveDMStreamMixin,
        _LiveSizeMixin,
        _LiveLikeMixin {
  LiveRoomController(this.heroTag);
  final String heroTag;

  @override
  int roomId = Get.arguments;
  @override
  final plPlayerController = PlPlayerController.getInstance(isLive: true);

  void startService({bool startDM = true}) {
    _startLiveTimeTimer();
    _startLiveTraceTimer();
    if (startDM) startLiveMsgStream();
  }

  void stopService({bool stopDM = true}) {
    _stopLiveTimeTimer();
    _stopLiveTraceTimer();
    if (stopDM) stopLiveMsgStream();
  }

  @override
  void onInit() {
    super.onInit();
    Future.wait(
      [queryLiveUrl(autoFullScreenFlag: true), queryLiveInfoH5()],
    ).whenComplete(_initLiveTraceIfNeeded);
    if (heartbeat.isLogin && !Pref.historyPause) {
      VideoHttp.roomEntryAction(roomId: roomId);
    }
  }

  Future<void>? playerInit({
    bool autoplay = true,
    bool autoFullScreenFlag = false,
  }) {
    if (videoUrl == null) {
      return null;
    }
    return plPlayerController.setDataSource(
      NetworkSource(videoSource: videoUrl!, audioSource: null),
      isLive: true,
      autoplay: autoplay,
      isVertical: isPortrait.value,
      autoFullScreenFlag: autoFullScreenFlag,
    );
  }

  Future<void> queryLiveUrl({bool autoFullScreenFlag = false}) async {
    currentQn.value ??= .fromCode(
      await ConnectivityUtils.isWiFi
          ? Pref.liveQuality
          : Pref.liveQualityCellular,
    );
    final res = await LiveHttp.liveRoomInfo(
      roomId: roomId,
      qn: currentQn.value!.code,
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

      // uid
      ruid = response.uid;

      // roomId
      if (response.roomId case final roomId?) {
        this.roomId = roomId;
      }

      // live time
      liveTime.value = response.liveTime;
      _startLiveTimeTimer();

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
      isLoaded.value = true;
    } else {
      _showDialog(res.toString());
    }
  }

  late List<Stream> stream;
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
        for (var (i, s) in stream.indexed) {
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

    final CodecItem item = stream
        .getOrFirst(streamIndex)
        .format
        .getOrFirst(formatIndex)
        .codec
        .getOrFirst(codecIndex);
    acceptQnList = item.acceptQn;
    // 以服务端返回的码率为准
    currentQn.value = item.currentQn;
    videoUrl = VideoUtils.getLiveCdnUrl(item, index: liveUrlIndex);
    return playerInit()?.whenComplete(_startSizeSub);
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

  @override
  void onClose() {
    stopService();
    super.onClose();
  }

  // 修改画质
  Future<void>? changeQn(LiveQuality qn) {
    if (currentQn.value == qn) {
      return null;
    }
    currentQn.value = qn;
    return queryLiveUrl();
  }

  void toastNotLogin() {
    SmartDialog.showToast('账号未登录');
  }

  void onSendDanmaku([bool fromEmote = false]) {
    if (kReleaseMode && !isMainLogin) {
      toastNotLogin();
      return;
    }
    getUserMedal();
    Get.key.currentState!.push(
      PublishRoute(
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Theme(
            data: ThemeUtils.darkTheme,
            child: LiveSendDmPanel(
              liveRoomController: this,
              items: savedDanmaku,
              autofocus: !fromEmote,
              panelType: fromEmote ? .emoji : .none,
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
    if (!isMainLogin) {
      toastNotLogin();
      return;
    }
    autoWrapReportDialog(
      Get.context!,
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

  void toggleDanmaku() {
    final newVal = !plPlayerController.enableShowLiveDanmaku.rawValue;
    plPlayerController.enableShowLiveDanmaku.value = newVal;
    if (!plPlayerController.tempPlayerConf) {
      GStorage.setting.put(
        SettingBoxKey.enableShowLiveDanmaku,
        newVal,
      );
    }
  }
}
