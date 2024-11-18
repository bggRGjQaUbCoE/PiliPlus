import 'dart:convert';

import 'package:PiliPalaX/models/live/danmu_info.dart';
import 'package:PiliPalaX/tcp/live.dart';
import 'package:PiliPalaX/utils/danmaku.dart';
import 'package:PiliPalaX/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:PiliPalaX/http/constants.dart';
import 'package:PiliPalaX/http/live.dart';
import 'package:PiliPalaX/models/live/room_info.dart';
import 'package:PiliPalaX/plugin/pl_player/index.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';
import '../../models/live/room_info_h5.dart';
import '../../utils/video_utils.dart';

class LiveRoomController extends GetxController {
  String cover = '';
  late int roomId;
  dynamic liveItem;
  late String heroTag;
  double volume = 0.0;
  // 静音状态
  RxBool volumeOff = false.obs;
  PlPlayerController plPlayerController =
      PlPlayerController.getInstance(videoType: 'live');
  Rx<RoomInfoH5Model> roomInfoH5 = RoomInfoH5Model().obs;
  // late bool enableCDN;

  RxList<dynamic> messages = [].obs;
  RxBool disableAutoScroll = false.obs;
  double? brightness;
  DanmakuController? controller;
  bool showDanmaku = true;

  @override
  void onInit() {
    super.onInit();
    roomId = int.parse(Get.parameters['roomid']!);
    if (Get.arguments != null) {
      liveItem = Get.arguments['liveItem'];
      heroTag = Get.arguments['heroTag'] ?? '';
      if (liveItem != null && liveItem.pic != null && liveItem.pic != '') {
        cover = liveItem.pic;
      }
      if (liveItem != null && liveItem.cover != null && liveItem.cover != '') {
        cover = liveItem.cover;
      }
    }
    // CDN优化
    // enableCDN = setting.get(SettingBoxKey.enableCDN, defaultValue: true);
  }

  playerInit(source) async {
    await plPlayerController.setDataSource(
      DataSource(
        videoSource: source,
        audioSource: null,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      // 硬解
      enableHA: true,
      autoplay: true,
    );
  }

  bool? isPortrait;

  Future queryLiveInfo() async {
    var res = await LiveHttp.liveRoomInfo(roomId: roomId, qn: 10000);
    if (res['status']) {
      isPortrait = res['data'].isPortrait;
      List<CodecItem> codec =
          res['data'].playurlInfo.playurl.stream.first.format.first.codec;
      CodecItem item = codec.first;
      String videoUrl = VideoUtils.getCdnUrl(item);
      await playerInit(videoUrl);
      return res;
    }
  }

  void setVolume(value) {
    if (value == 0) {
      // 设置音量
      volumeOff.value = false;
    } else {
      // 取消音量
      volume = value;
      volumeOff.value = true;
    }
  }

  Future queryLiveInfoH5() async {
    var res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res['status']) {
      roomInfoH5.value = res['data'];
    }
    return res;
  }

  LiveMessageStream? msgStream;
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    if (disableAutoScroll.value) return;
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  void liveMsg() {
    LiveHttp.liveRoomDanmaPrefetch(roomId: roomId).then((v) {
      if (v['status']) {
        for (var obj in v['data'] as List) {
          messages.add({
            'name': obj['user']['base']['name'],
            'uid': obj['user']['uid'],
            'text': obj['text'],
            'emots': obj['emots'],
            'uemote': obj['emoticon']['emoticon_unique'] != ""
                ? obj['emoticon']
                : null,
          });
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => scrollToBottom(),
          );
        }
      }
    });
    LiveHttp.liveRoomGetDanmakuToken(roomId: roomId).then((v) {
      if (v['status']) {
        LiveDanmakuInfo info = v['data'];
        // logger.d("info => $info");
        msgStream = LiveMessageStream(
          streamToken: info.data.token,
          roomId: roomId,
          uid: GStorage.userInfo.get('userInfoCache')?.mid ?? 0,
          host: info.data.hostList[0].host,
          port: info.data.hostList[0].port,
        );
        msgStream?.addEventListener((obj) {
          if (obj['cmd'] == 'DANMU_MSG') {
            // logger.i(' 原始弹幕消息 ======> ${jsonEncode(obj)}');
            messages.add({
              'name': obj['info'][0][15]['user']['base']['name'],
              'uid': obj['info'][0][15]['user']['uid'],
              'text': obj['info'][1],
              'emots': jsonDecode(obj['info'][0][15]['extra'])['emots'],
              'uemote': obj['info'][0][13],
            });
            Map json = jsonDecode(obj['info'][0][15]['extra']);
            if (showDanmaku) {
              controller?.addItems([
                DanmakuItem(
                  json['content'],
                  color: DmUtils.decimalToColor(json['color']),
                  // time: e.progress,
                  type: DmUtils.getPosition(json['mode']),
                )
              ]);
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => scrollToBottom(),
              );
            }
          }
        });
        msgStream?.init();
        scrollController.addListener(() {
          if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
            disableAutoScroll.value = true;
          } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            final pos = scrollController.position;
            if (pos.maxScrollExtent - pos.pixels <= 100) {
              disableAutoScroll.value = false;
            }
          }
        });
      }
    });
  }
}
