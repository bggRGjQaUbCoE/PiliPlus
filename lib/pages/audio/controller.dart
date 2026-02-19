import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/audio.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pb.dart'
    show
        DetailItem,
        PlayURLResp,
        PlaylistSource,
        PlayInfo,
        ThumbUpReq_ThumbType,
        ListOrder,
        DashItem,
        ResponseUrl;
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/ua_type.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart'
    show FavMixin;
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/main_reply/view.dart';
import 'package:PiliPlus/pages/sponsor_block/block_mixin.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/pages/video/pay_coins/view.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';

class AudioController extends GetxController
    with
        GetTickerProviderStateMixin,
        TripleMixin,
        FavMixin,
        BlockConfigMixin,
        BlockMixin {
  late Int64 id;
  late Int64 oid;
  late List<Int64> subId;
  late int itemType;
  Int64? extraId;
  late final PlaylistSource from;
  @override
  late final bool isUgc = itemType == 1;

  final Rx<DetailItem?> audioItem = Rx<DetailItem?>(null);

  @override
  Player? player;
  late int cacheAudioQa;

  late bool isDragging = false;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  late final AnimationController animController;

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
  bool get reachStart => _prev == null;

  ListOrder order = ListOrder.ORDER_NORMAL;

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
    final int? extraId = args['extraId'];
    if (extraId != null) {
      this.extraId = Int64(extraId);
    }
    if (args['heroTag'] case String heroTag) {
      try {
        _videoDetailController = Get.find<VideoDetailController>(tag: heroTag);
      } catch (_) {}
    }

    _queryPlayList(isInit: true);

    final String? audioUrl = args['audioUrl'];
    final hasAudioUrl = audioUrl != null;
    if (hasAudioUrl) {
      _querySponsorBlock();
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
    videoPlayerServiceHandler
      ?..onPlay = onPlay
      ..onPause = onPause
      ..onSeek = onSeek;

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    if (shutdownTimerService.isActive) {
      shutdownTimerService
        ..onPause = onPause
        ..isPlaying = isPlaying;
    }
  }

  bool isPlaying() {
    return player?.state.playing ?? false;
  }

  Future<void>? onPlay() {
    return player?.play();
  }

  Future<void>? onPause() {
    return player?.pause();
  }

  Future<void>? onSeek(Duration duration) {
    return player?.seek(duration);
  }

  void _updateCurrItem(DetailItem item) {
    audioItem.value = item;
    hasLike.value = item.stat.hasLike_7;
    coinNum.value = item.stat.hasCoin_8 ? 2 : 0;
    hasFav.value = item.stat.hasFav;
    videoPlayerServiceHandler?.onVideoDetailChange(
      item,
      (subId.firstOrNull ?? oid).toInt(),
      hashCode.toString(),
    );
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
      extraId: extraId,
      order: order,
    );
    if (res case Success(:final response)) {
      if (isInit) {
        late final paginationReply = response.paginationReply;
        _prev = response.reachStart ? null : paginationReply.prev;
        _next = response.reachEnd ? null : paginationReply.next;
        final index = response.list.indexWhere((e) => e.item.oid == oid);
        if (index != -1) {
          this.index = index;
          _updateCurrItem(response.list[index]);
          playlist = response.list;
        }
      } else if (isLoadPrev) {
        _prev = response.reachStart ? null : response.paginationReply.prev;
        if (response.list.isNotEmpty) {
          index += response.list.length;
          playlist?.insertAll(0, response.list);
        }
      } else if (isLoadNext) {
        _next = response.reachEnd ? null : response.paginationReply.next;
        if (response.list.isNotEmpty) {
          playlist?.addAll(response.list);
        }
      }
    } else {
      res.toast();
    }
  }

  @pragma('vm:notify-debugger-on-exception')
  void _querySponsorBlock() {
    if (isUgc && enableSponsorBlock) {
      try {
        final bvid = IdUtils.av2bv(oid.toInt());
        final cid = subId.first.toInt();
        querySponsorBlock(bvid: bvid, cid: cid);
      } catch (_) {}
    }
  }

  Future<bool> _queryPlayUrl() async {
    _querySponsorBlock();
    final res = await AudioGrpc.audioPlayUrl(
      itemType: itemType,
      oid: oid,
      subId: subId,
    );
    if (res case Success(:final response)) {
      _onPlay(response);
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
        _onOpenMedia(VideoUtils.getCdnUrl(audio.playUrls));
      } else if (playInfo.hasPlayUrl()) {
        final playUrl = playInfo.playUrl;
        final durls = playUrl.durl;
        if (durls.isEmpty) {
          return;
        }
        final durl = durls.first;
        position.value = Duration.zero;
        _onOpenMedia(VideoUtils.getCdnUrl(durl.playUrls));
      }
    }
  }

  Future<void> _onOpenMedia(
    String url, {
    String? referer,
    String ua = Constants.userAgentApp,
  }) async {
    await _initPlayerIfNeeded();
    player!.open(Media(url, start: _start));
    _start = null;
  }

  Future<void> _initPlayerIfNeeded() async {
    if (player == null) {
      await (player = Player()).waitForPlayerInitialization;
    }
    _subscriptions ??= {
      player!.stream.position.listen((position) {
        if (isDragging) return;
        if (position.inSeconds != this.position.value.inSeconds) {
          this.position.value = position;
          _videoDetailController?.playedTime = position;
          videoPlayerServiceHandler?.onPositionChange(position);
        }
      }),
      player!.stream.duration.listen((duration) {
        this.duration.value = duration;
      }),
      player!.stream.playing.listen((playing) {
        final PlayerStatus playerStatus;
        if (playing) {
          animController.forward();
          playerStatus = PlayerStatus.playing;
        } else {
          animController.reverse();
          playerStatus = PlayerStatus.paused;
        }
        videoPlayerServiceHandler?.onStatusChange(playerStatus, false, false);
      }),
      player!.stream.completed.listen((completed) {
        _videoDetailController?.playedTime = duration.value;
        videoPlayerServiceHandler?.onStatusChange(
          PlayerStatus.completed,
          false,
          false,
        );
        if (completed) {
          if (shutdownTimerService.isWaiting) {
            shutdownTimerService.handleWaiting();
          } else {
            switch (playMode.value) {
              case PlayRepeat.pause:
                break;
              case PlayRepeat.listOrder:
                playNext(nextPart: true);
                break;
              case PlayRepeat.singleCycle:
                _replay();
                break;
              case PlayRepeat.listCycle:
                if (!playNext(nextPart: true)) {
                  if (index != null && index != 0 && playlist != null) {
                    playIndex(0);
                  } else {
                    _replay();
                  }
                }
                break;
              case PlayRepeat.autoPlayRelated:
                break;
            }
          }
        }
      }),
    };
  }

  void _replay() {
    player?.seek(Duration.zero).whenComplete(player!.play);
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
    if (res case Success(:final response)) {
      hasLike.value = newVal;
      try {
        audioItem.value!.stat
          ..hasLike_7 = newVal
          ..like += newVal ? 1 : -1;
        audioItem.refresh();
      } catch (_) {}
      SmartDialog.showToast(response.message);
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
    if (res case Success(:final response)) {
      hasLike.value = true;
      if (response.coinOk && !hasCoin) {
        coinNum.value = 2;
        GlobalData().afterCoin(2);
        try {
          audioItem.value!.stat
            ..hasCoin_8 = true
            ..coin += 2;
          audioItem.refresh();
        } catch (_) {}
      }
      hasFav.value = true;
      if (!hasCoin) {
        SmartDialog.showToast('投币失败');
      } else {
        SmartDialog.showToast('三连成功');
      }
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
      // return;
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
      final updateLike = !hasLike.value && coinWithLike;
      if (updateLike) {
        hasLike.value = true;
      }
      coinNum.value += coin;
      try {
        final stat = audioItem.value!.stat
          ..hasCoin_8 = true
          ..coin += coin;
        if (updateLike) {
          stat
            ..hasLike_7 = true
            ..like += 1;
        }
        audioItem.refresh();
      } catch (_) {}
      GlobalData().afterCoin(coin);
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
      replyType: isUgc ? 1 : 14,
    );
  }

  void actionShareVideo(BuildContext context) {
    final audioUrl = isUgc
        ? '${HttpString.baseUrl}/video/${IdUtils.av2bv(oid.toInt())}'
        : '${HttpString.baseUrl}/audio/au$oid';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
            if (PlatformUtils.isMobile)
              ListTile(
                dense: true,
                title: const Text(
                  '分享视频',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  if (audioItem.value case DetailItem(
                    :final arc,
                    :final owner,
                  )) {
                    Utils.shareText(
                      '${arc.title} '
                      'UP主: ${owner.name}'
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
                if (audioItem.value case DetailItem(
                  :final arc,
                  :final owner,
                )) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => RepostPanel(
                      rid: oid.toInt(),
                      dynType: isUgc ? 8 : 256,
                      pic: arc.cover,
                      title: arc.title,
                      uname: owner.name,
                    ),
                  );
                }
              },
            ),
            if (isUgc)
              ListTile(
                dense: true,
                title: const Text(
                  '分享至消息',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Get.back();
                  if (audioItem.value case DetailItem(
                    :final arc,
                    :final owner,
                  )) {
                    try {
                      PageUtils.pmShare(
                        context,
                        content: {
                          "id": oid.toString(),
                          "title": arc.title,
                          "headline": arc.title,
                          "source": 5,
                          "thumb": arc.cover,
                          "author": owner.name,
                          "author_id": owner.mid.toString(),
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
      ),
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

  bool playNext({bool nextPart = false}) {
    if (nextPart) {
      if (audioItem.value case DetailItem(:final parts)) {
        if (parts.length > 1) {
          final subId = this.subId.firstOrNull;
          final nextIndex = parts.indexWhere((e) => e.subId == subId) + 1;
          if (nextIndex != 0 && nextIndex < parts.length) {
            final nextPart = parts[nextIndex];
            oid = nextPart.oid;
            this.subId = [nextPart.subId];
            _queryPlayUrl().then((res) {
              if (res) {
                _videoDetailController = null;
              }
            });
            return true;
          }
        }
      }
    }
    if (index != null && playlist != null && player != null) {
      final next = index! + 1;
      if (next < playlist!.length) {
        if (next == playlist!.length - 1 && _next != null) {
          _queryPlayList(isLoadNext: true);
        }
        playIndex(next);
        return true;
      }
    }
    return false;
  }

  void playIndex(int index, {List<Int64>? subId}) {
    if (index == this.index && subId == null) return;
    this.index = index;
    final audioItem = playlist![index];
    final item = audioItem.item;
    oid = item.oid;
    this.subId =
        subId ??
        (item.subId.isNotEmpty ? item.subId : [audioItem.parts.first.subId]);
    itemType = item.itemType;
    _queryPlayUrl().then((res) {
      if (res) {
        _videoDetailController = null;
        _updateCurrItem(audioItem);
      }
    });
  }

  void setSpeed(double speed) {
    if (player case final player?) {
      this.speed = speed;
      player.setRate(speed);
    }
  }

  @override
  (Object, int) get getFavRidType => (oid, isUgc ? 2 : 12);

  @override
  void updateFavCount(int count) {
    try {
      audioItem.value!.stat
        ..hasFav = count > 0
        ..favourite += count;
      audioItem.refresh();
    } catch (_) {}
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

  void onChangeOrder(ListOrder value) {
    if (order != value) {
      order = value;
      _queryPlayList(isInit: true);
    }
  }

  @override
  BlockConfigMixin get blockConfig => this;

  @override
  int get currPosInMilliseconds => position.value.inMilliseconds;

  @override
  Future<void>? seekTo(Duration duration, {required bool isSeek}) =>
      onSeek(duration);

  @override
  int? get timeLength => duration.value.inMilliseconds;

  @override
  bool get autoPlay => true;

  @override
  bool get preInitPlayer => true;

  @override
  void onClose() {
    shutdownTimerService
      ..onPause = null
      ..isPlaying = null
      ..reset();
    videoPlayerServiceHandler
      ?..onPlay = null
      ..onPause = null
      ..onSeek = null
      ..onVideoDetailDispose(hashCode.toString());
    _subscriptions?.forEach((e) => e.cancel());
    _subscriptions = null;
    player?.dispose();
    player = null;
    animController.dispose();
    super.onClose();
  }
}

extension on DashItem {
  Iterable<String> get playUrls sync* {
    yield baseUrl;
    yield* backupUrl;
  }
}

extension on ResponseUrl {
  Iterable<String> get playUrls sync* {
    yield url;
    yield* backupUrl;
  }
}
