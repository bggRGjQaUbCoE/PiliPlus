import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/audio.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart'
    show
        DetailItem,
        PlayURLResp,
        PlaylistResp,
        PlaylistSource,
        PlayInfo,
        ThumbUpReq_ThumbType;
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/ua_type.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart'
    show FavMixin;
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/main_reply/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/pages/video/pay_coins/view.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';

class AudioController extends GetxController
    with GetTickerProviderStateMixin, TripleMixin, FavMixin {
  late Int64 id;
  late Int64 oid;
  late List<Int64> subId;
  late int itemType;
  late final PlaylistSource from;
  late final isVideo = itemType == 1;

  final Rx<DetailItem?> audioItem = Rx<DetailItem?>(null);

  Player? player;
  late int cacheAudioQa;

  late bool isDragging = false;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  late final AnimationController animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  Set<StreamSubscription>? _subscriptions;

  int? index;
  List<DetailItem>? playlist;

  late double speed = 1.0;

  late final Rx<PlayRepeat> playMode = Pref.audioPlayMode.obs;

  late final isLogin = Accounts.main.isLogin;

  Duration? _start;
  VideoDetailController? _videoDetailController;

  String? _prev;
  String? _next;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    oid = Int64(args['oid']);
    final id = args['id'];
    this.id = id != null ? Int64(id) : oid;
    subId = (args['subId'] as List<int>?)?.map(Int64.new).toList() ?? [oid];
    itemType = args['itemType'];
    from = args['from'];
    _start = args['start'];
    if (args['heroTag'] case String heroTag) {
      try {
        _videoDetailController = Get.find<VideoDetailController>(tag: heroTag);
      } catch (_) {}
    }

    _queryPlayList(isInit: true);

    final String? audioUrl = args['audioUrl'];
    final hasAudioUrl = audioUrl != null;
    if (hasAudioUrl) {
      _onOpenMedia(
        audioUrl,
        ua: UaType.pc.ua,
        referer: HttpString.baseUrl,
      );
    }
    Utils.isWiFi.then((isWiFi) {
      cacheAudioQa = isWiFi ? Pref.defaultAudioQa : Pref.defaultAudioQaCellular;
      if (!hasAudioUrl) {
        _queryPlayUrl();
      }
    });
  }

  Future<void> _queryPlayList({
    bool isInit = false,
    bool isLoadPrev = false,
    bool isLoadNext = false,
  }) async {
    final res = await AudioGrpc.audioPlayList(
      id: id,
      oid: isInit ? oid : null,
      subId: isInit ? subId : null,
      itemType: isInit ? itemType : null,
      from: isInit ? from : null,
      next: isLoadPrev
          ? _prev
          : isLoadNext
          ? _next
          : null,
    );
    if (res.isSuccess) {
      final PlaylistResp data = res.data;
      if (isInit) {
        late final paginationReply = data.paginationReply;
        _prev = data.reachStart ? null : paginationReply.prev;
        _next = data.reachEnd ? null : paginationReply.next;
        final index = data.list.indexWhere((e) => e.item.oid == oid);
        if (index != -1) {
          this.index = index;
          final item = data.list[index];
          audioItem.value = item;
          hasLike.value = item.stat.hasLike_7;
          coinNum.value = item.stat.hasCoin_8 ? 2 : 0;
          hasFav.value = item.stat.hasFav;
          playlist = data.list;
        }
      } else if (isLoadPrev) {
        _prev = data.reachStart ? null : data.paginationReply.prev;
        if (data.list.isNotEmpty) {
          index += data.list.length;
          playlist?.insertAll(0, data.list);
        }
      } else if (isLoadNext) {
        _next = data.reachEnd ? null : data.paginationReply.next;
        if (data.list.isNotEmpty) {
          playlist?.addAll(data.list);
        }
      }
    } else {
      res.toast();
    }
  }

  Future<bool> _queryPlayUrl() async {
    final res = await AudioGrpc.audioPlayUrl(
      itemType: itemType,
      oid: oid,
      subId: subId,
    );
    if (res.isSuccess) {
      _onPlay(res.data);
      return true;
    } else {
      res.toast();
      return false;
    }
  }

  void _onPlay(PlayURLResp data) {
    final PlayInfo? playInfo = data.playerInfo.values.firstOrNull;
    if (playInfo != null) {
      if (playInfo.hasPlayDash()) {
        final playDash = playInfo.playDash;
        final audios = playDash.audio;
        if (audios.isEmpty) {
          return;
        }
        position.value = Duration.zero;
        final audio = audios.findClosestTarget(
          (e) => e.id <= cacheAudioQa,
          (a, b) => a.id > b.id ? a : b,
        );
        _onOpenMedia(VideoUtils.getCdnUrl(audio.baseUrl));
      } else if (playInfo.hasPlayUrl()) {
        final playUrl = playInfo.playUrl;
        final durls = playUrl.durl;
        if (durls.isEmpty) {
          return;
        }
        final durl = durls.first;
        position.value = Duration.zero;
        _onOpenMedia(VideoUtils.getDurlCdnUrl(durl));
      }
    }
  }

  void _onOpenMedia(
    String url, {
    String? referer,
    String ua = Constants.userAgentApp,
  }) {
    _initPlayerIfNeeded();
    player!.open(
      Media(
        url,
        start: _start,
        httpHeaders: {
          'user-agent': ua,
          'referer': ?referer,
        },
      ),
    );
    _start = null;
  }

  void _initPlayerIfNeeded() {
    player ??= Player();
    _subscriptions ??= {
      player!.stream.position.listen((position) {
        if (isDragging) return;
        if (position.inSeconds != this.position.value.inSeconds) {
          this.position.value = position;
          _videoDetailController?.playedTime = position;
        }
      }),
      player!.stream.duration.listen((duration) {
        this.duration.value = duration;
      }),
      player!.stream.playing.listen((playing) {
        if (playing) {
          animController.forward();
        } else {
          animController.reverse();
        }
      }),
      player!.stream.completed.listen((completed) {
        _videoDetailController?.playedTime = duration.value;
        if (completed) {
          switch (playMode.value) {
            case PlayRepeat.pause:
              break;
            case PlayRepeat.listOrder:
              playNext();
              break;
            case PlayRepeat.singleCycle:
              player?.play();
              break;
            case PlayRepeat.listCycle:
              if (!playNext()) {
                if (index != null && index != 0 && playlist != null) {
                  playIndex(0);
                } else {
                  player?.play();
                }
              }
              break;
            case PlayRepeat.autoPlayRelated:
              break;
          }
        }
      }),
    };
  }

  @override
  Future<void> actionLikeVideo() async {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final newVal = !hasLike.value;
    final res = await AudioGrpc.audioThumbUp(
      oid: oid,
      subId: subId,
      itemType: itemType,
      type: newVal
          ? ThumbUpReq_ThumbType.LIKE
          : ThumbUpReq_ThumbType.CANCEL_LIKE,
    );
    if (res.isSuccess) {
      hasLike.value = newVal;
      SmartDialog.showToast(res.data.message);
    } else {
      res.toast();
    }
  }

  @override
  Future<void> actionTriple() async {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final res = await AudioGrpc.audioTripleLike(
      oid: oid,
      subId: subId,
      itemType: itemType,
    );
    if (res.isSuccess) {
      hasLike.value = true;
      coinNum.value = 2;
      hasFav.value = true;
    } else {
      res.toast();
    }
  }

  void actionCoinVideo() {
    final audioItem = this.audioItem.value;
    if (audioItem == null) {
      return;
    }

    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }

    final int copyright = audioItem.arc.copyright;
    if ((copyright != 1 && coinNum.value >= 1) || coinNum.value >= 2) {
      SmartDialog.showToast('达到投币上限啦~');
      return;
    }

    if (GlobalData().coins != null && GlobalData().coins! < 1) {
      SmartDialog.showToast('硬币不足');
      return;
    }

    PayCoinsPage.toPayCoinsPage(
      onPayCoin: _onPayCoin,
      hasCoin: coinNum.value == 1,
      copyright: copyright,
    );
  }

  Future<void> _onPayCoin(int coin, bool coinWithLike) async {
    final res = await AudioGrpc.audioCoinAdd(
      oid: oid,
      subId: subId,
      itemType: itemType,
      num: coin,
      thumbUp: coinWithLike,
    );
    if (res.isSuccess) {
      if (coinWithLike) {
        hasLike.value = true;
      }
      coinNum.value += coin;
    } else {
      res.toast();
    }
  }

  @override
  void showFavBottomSheet(BuildContext context, {bool isLongPress = false}) {
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (enableQuickFav) {
      if (!isLongPress) {
        actionFavVideo(isQuick: true);
      } else {
        PageUtils.showFavBottomSheet(context: context, ctr: this);
      }
    } else if (!isLongPress) {
      PageUtils.showFavBottomSheet(context: context, ctr: this);
    }
  }

  void showReply() {
    MainReplyPage.toMainReplyPage(
      oid: oid.toInt(),
      replyType: isVideo ? 1 : 14,
    );
  }

  void actionShareVideo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        final audioUrl = isVideo
            ? '${HttpString.baseUrl}/video/${IdUtils.av2bv(oid.toInt())}'
            : '${HttpString.baseUrl}/audio/au$oid';
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                title: const Text(
                  '复制链接',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  Utils.copyText(audioUrl);
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  '其它app打开',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  PageUtils.launchURL(audioUrl);
                },
              ),
              if (Utils.isMobile)
                ListTile(
                  dense: true,
                  title: const Text(
                    '分享视频',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.back();
                    if (audioItem.value case final audioItem?) {
                      Utils.shareText(
                        '${audioItem.arc.title} '
                        'UP主: ${audioItem.owner.name}'
                        ' - $audioUrl',
                      );
                    }
                  },
                ),
              ListTile(
                dense: true,
                title: const Text(
                  '分享至动态',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  if (audioItem.value case final audioItem?) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => RepostPanel(
                        rid: oid.toInt(),
                        dynType: isVideo ? 8 : 256,
                        pic: audioItem.arc.cover,
                        title: audioItem.arc.title,
                        uname: audioItem.owner.name,
                      ),
                    );
                  }
                },
              ),
              if (isVideo)
                ListTile(
                  dense: true,
                  title: const Text(
                    '分享至消息',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.back();
                    if (audioItem.value case final audioItem?) {
                      try {
                        PageUtils.pmShare(
                          context,
                          content: {
                            "id": oid.toString(),
                            "title": audioItem.arc.title,
                            "headline": audioItem.arc.title,
                            "source": 5,
                            "thumb": audioItem.arc.cover,
                            "author": audioItem.owner.name,
                            "author_id": audioItem.owner.mid.toString(),
                          },
                        );
                      } catch (e) {
                        SmartDialog.showToast(e.toString());
                      }
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void playOrPause() {
    if (player case final player?) {
      if ((duration.value - position.value).inMilliseconds < 50) {
        player.seek(Duration.zero).whenComplete(player.play);
      } else {
        player.playOrPause();
      }
    }
  }

  bool playPrev() {
    if (index != null && playlist != null && player != null) {
      final prev = index! - 1;
      if (prev >= 0) {
        playIndex(prev);
        return true;
      }
    }
    return false;
  }

  bool playNext() {
    if (index != null && playlist != null && player != null) {
      final next = index! + 1;
      if (next < playlist!.length) {
        playIndex(next);
        return true;
      }
    }
    return false;
  }

  void playIndex(int index) {
    if (index == this.index) return;
    this.index = index;
    final audioItem = playlist![index];
    final item = audioItem.item;
    oid = item.oid;
    subId = item.subId;
    itemType = item.itemType;
    _queryPlayUrl().then((res) {
      if (res) {
        this.audioItem.value = audioItem;
      }
    });
  }

  void setSpeed(double speed) {
    if (player case final player?) {
      this.speed = speed;
      player.setRate(speed);
    }
  }

  // Timer? _timer;

  // void _cancelTimer() {
  //   _timer?.cancel();
  //   _timer = null;
  // }

  // void showTimerDialog() {
  //   // TODO
  // }

  @override
  (Object, int) get getFavRidType => (oid, isVideo ? 2 : 12);

  @override
  void updateFavCount(int count) {
    audioItem
      ..value?.stat.favourite += count
      ..refresh();
  }

  Future<void> loadPrev(BuildContext context) async {
    if (_prev == null) return;
    final length = playlist!.length;
    await _queryPlayList(isLoadPrev: true);
    if (length != playlist!.length && context.mounted) {
      (context as Element).markNeedsBuild();
    }
  }

  Future<void> loadNext(BuildContext context) async {
    if (_next == null) return;
    final length = playlist!.length;
    await _queryPlayList(isLoadNext: true);
    if (length != playlist!.length && context.mounted) {
      (context as Element).markNeedsBuild();
    }
  }

  @override
  void onClose() {
    // _cancelTimer();
    _subscriptions?.forEach((e) => e.cancel());
    _subscriptions = null;
    player?.dispose();
    player = null;
    animController.dispose();
    super.onClose();
  }
}
