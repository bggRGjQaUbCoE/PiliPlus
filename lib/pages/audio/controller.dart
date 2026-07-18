import 'dart:async';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/dialog/simple_dialog_option.dart';
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
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/audio/audio_request_coordinator.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart'
    show FavMixin;
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/main_reply/view.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart'
    show kMaxVolume;
import 'package:PiliPlus/pages/sponsor_block/block_mixin.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/services/audio_session_coordinator.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/identity_key.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';

typedef _AudioPlayRequest = ({
  int? index,
  DetailItem? item,
  int itemType,
  Int64 oid,
  List<Int64> subId,
  bool detachVideoController,
  Duration? start,
});

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

  @override
  Object get actionResourceKey => (
    itemType,
    oid.toInt(),
    subId.map((item) => item.toString()).join(','),
    IdentityKey(Accounts.main),
  );
  Int64? extraId;
  late final PlaylistSource from;
  @override
  late final bool isUgc = itemType == 1;

  final audioItem = Rxn<DetailItem>();

  @override
  Player? player;
  final _playRequestCoordinator = LatestAudioRequestCoordinator();
  final _mediaOpener = SerializedAudioOpener();
  late final _playerInitializer = SharedAsyncInitializer<Player>(
    disposeDiscarded: (player) => player.dispose(),
  );
  late final AudioPlaybackClient _audioSessionClient = AudioPlaybackClient(
    owner: this,
    isPlaying: isPlaying,
    play: _resumeAfterInterruption,
    pause: _pauseForSession,
    getVolume: () => player?.state.volume,
    setVolume: (volume) async {
      await player?.setVolume(volume);
    },
  );
  late int cacheAudioQa;

  late bool isDragging = false;
  final RxInt position = RxInt(0);
  final RxInt duration = RxInt(0);

  late final AnimationController animController;

  List<StreamSubscription>? _subscriptions;

  int? index;
  List<DetailItem>? playlist;

  late double speed = 1.0;

  late final Rx<PlayRepeat> playMode = Pref.audioPlayMode.obs;

  @override
  bool get isLogin => Accounts.main.isLogin;

  Duration? _start;
  VideoDetailController? _videoDetailController;

  String? _prev;
  String? _next;
  bool get reachStart => _prev == null;

  ListOrder order = ListOrder.ORDER_NORMAL;

  double? _lastVolume;
  late final RxDouble desktopVolume = RxDouble(Pref.desktopVolume);

  void toggleVolume() {
    if (_lastVolume == null) {
      _lastVolume = desktopVolume.value;
      setVolume(0, clearLastVolme: false);
    } else {
      setVolume(_lastVolume!);
    }
  }

  void setVolume(double volume, {bool clearLastVolme = true}) {
    if (clearLastVolme) {
      _lastVolume = null;
    }
    desktopVolume.value = volume;
    player?.setVolume(volume * 100);
  }

  void syncVolume([_]) {
    final volume = desktopVolume.value;
    PlPlayerController.instance
      ?..volume.value = volume
      ..videoPlayerController?.setVolume(volume * 100);
    GStorage.setting.put(SettingBoxKey.desktopVolume, volume.toPrecision(3));
  }

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

    final String? audioUrl = (args['audioUrl'] as String?)?.trim();
    final hasAudioUrl = audioUrl?.isNotEmpty ?? false;
    if (hasAudioUrl) {
      final request = _currentPlayRequest(start: _start);
      _playRequestCoordinator.run((isCurrent) async {
        final opened = await openCurrentAudioUrl(
          url: audioUrl!,
          isCurrent: isCurrent,
          open: (url) => _onOpenMedia(
            url,
            isCurrent: isCurrent,
            ua: BrowserUa.pc,
            referer: HttpString.baseUrl,
            start: request.start,
          ),
        );
        if (opened) {
          _querySponsorBlock(request, isCurrent);
        }
        return opened;
      }).ignore();
    }
    ConnectivityUtils.isWiFi.then((isWiFi) {
      if (isClosed) return;
      cacheAudioQa = isWiFi ? Pref.defaultAudioQa : Pref.defaultAudioQaCellular;
      if (!hasAudioUrl) {
        _requestPlayUrl(_currentPlayRequest(start: _start)).ignore();
      }
    });
    videoPlayerServiceHandler?.setPlayerCallbacks(
      owner: this,
      mediaOwnerTag: hashCode.toString(),
      onPlay: onPlay,
      onPause: onPause,
      onSeek: onSeek,
    );

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
    if (player == null) return null;
    return _playWithSession();
  }

  Future<void>? onPause() {
    if (player == null) return null;
    return _pauseForSession(false);
  }

  Future<void>? onSeek(Duration duration) {
    return player?.seek(duration);
  }

  Future<void> _playWithSession() async {
    await startPlaybackWithAudioFocus(
      activate: _activateAudioSession,
      canStart: () => !isClosed && player != null,
      start: () => player!.play(),
      deactivate: () async {
        await audioSessionHandler?.setActive(false, owner: this);
      },
    );
  }

  Future<void> _resumeAfterInterruption() async {
    try {
      await player?.play();
    } catch (_) {
      await audioSessionHandler?.setActive(false, owner: this);
      rethrow;
    }
  }

  Future<void> _pauseForSession(bool interrupted) async {
    try {
      await player?.pause();
    } finally {
      if (!interrupted) {
        await audioSessionHandler?.setActive(false, owner: this);
      }
    }
  }

  Future<bool> _activateAudioSession() async {
    final handler = audioSessionHandler;
    return handler == null ||
        await handler.setActive(
          true,
          owner: this,
          client: _audioSessionClient,
        );
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

  _AudioPlayRequest _currentPlayRequest({required Duration? start}) => (
    index: index,
    item: null,
    itemType: itemType,
    oid: oid,
    subId: List<Int64>.unmodifiable(subId),
    detachVideoController: false,
    start: start,
  );

  @pragma('vm:notify-debugger-on-exception')
  void _querySponsorBlock(
    _AudioPlayRequest request,
    bool Function() isCurrent,
  ) {
    if (request.itemType == 1 && enableSponsorBlock) {
      try {
        final bvid = IdUtils.av2bv(request.oid.toInt());
        final cid = request.subId.first.toInt();
        querySponsorBlock(
          bvid: bvid,
          cid: cid,
          isCurrent: isCurrent,
        ).ignore();
      } catch (_) {}
    }
  }

  Future<bool> _requestPlayUrl(_AudioPlayRequest request) {
    return _playRequestCoordinator.run(
      (isCurrent) => _queryPlayUrl(request, isCurrent),
    );
  }

  Future<bool> _queryPlayUrl(
    _AudioPlayRequest request,
    bool Function() isCurrent,
  ) async {
    final res = await AudioGrpc.audioPlayUrl(
      itemType: request.itemType,
      oid: request.oid,
      subId: request.subId,
    );
    if (!isCurrent()) return false;
    if (res case Success(:final response)) {
      final opened = await openCurrentAudioUrl(
        url: _getAudioUrl(response),
        isCurrent: isCurrent,
        open: (url) => _onOpenMedia(
          url,
          isCurrent: isCurrent,
          start: request.start,
        ),
      );
      if (!opened) {
        _releaseSessionIfStopped(isCurrent);
        return false;
      }
      _commitPlayRequest(request);
      _querySponsorBlock(request, isCurrent);
      return true;
    } else {
      res.toast();
      _releaseSessionIfStopped(isCurrent);
      return false;
    }
  }

  void _releaseSessionIfStopped(bool Function() isCurrent) {
    if (isCurrent() && !isPlaying()) {
      audioSessionHandler?.setActive(false, owner: this).ignore();
    }
  }

  String? _getAudioUrl(PlayURLResp data) {
    final PlayInfo? playInfo = data.playerInfo.values.firstOrNull;
    if (playInfo != null) {
      if (playInfo.hasPlayDash()) {
        final playDash = playInfo.playDash;
        final audios = playDash.audio;
        if (audios.isEmpty) {
          return null;
        }
        final audio = audios.findClosestTarget(
          (e) => e.id <= cacheAudioQa,
          (a, b) => a.id > b.id ? a : b,
        );
        return _getCdnUrl(audio.playUrls);
      } else if (playInfo.hasPlayUrl()) {
        final playUrl = playInfo.playUrl;
        final durls = playUrl.durl;
        if (durls.isEmpty) {
          return null;
        }
        final durl = durls.first;
        return _getCdnUrl(durl.playUrls);
      }
    }
    return null;
  }

  String? _getCdnUrl(Iterable<String> urls) {
    final candidates = urls.where((url) => url.trim().isNotEmpty);
    return candidates.isEmpty ? null : VideoUtils.getCdnUrl(candidates);
  }

  void _commitPlayRequest(_AudioPlayRequest request) {
    oid = request.oid;
    subId = request.subId;
    itemType = request.itemType;
    if (request.index case final index?) {
      this.index = index;
    }
    if (request.detachVideoController) {
      _videoDetailController = null;
    }
    position.value = 0;
    if (request.item case final item?) {
      _updateCurrItem(item);
    }
  }

  Future<bool> _onOpenMedia(
    String url, {
    required bool Function() isCurrent,
    String ua = Constants.userAgentApp,
    String? referer,
    Duration? start,
  }) async {
    try {
      final player = await _initPlayerIfNeeded();
      if (player == null || !isCurrent()) return false;
      return _mediaOpener.run(
        isCurrent: isCurrent,
        open: () async {
          if (!await _activateAudioSession() || !isCurrent()) return false;
          player.setMediaHeader(
            userAgent: ua,
            // mpv cannot clear referer option
            headers: {'Referer': ?referer},
          );
          await player.open(Media(url, start: start), play: false);
          if (!isCurrent()) return false;
          await player.play();
          if (isCurrent()) {
            _start = null;
            return true;
          }
          return false;
        },
        onStale: () => _pauseForSession(false),
      );
    } catch (error, stackTrace) {
      if (isCurrent()) {
        Utils.reportError(error, stackTrace);
      }
      return false;
    }
  }

  Future<Player?> _initPlayerIfNeeded() async {
    final initializedPlayer = await _playerInitializer.getOrCreate(
      () => Player.create(
        configuration: PlayerConfiguration(
          options: {
            'volume': PlatformUtils.isDesktop
                ? (desktopVolume.value * 100).toString()
                : Pref.playerVolume.toString(),
            'volume-max': kMaxVolume.toString(),
            ...Pref.initBuffer(),
          },
        ),
      ),
    );
    if (initializedPlayer == null || isClosed) return null;
    if (player == null) {
      player = initializedPlayer;
      _listenToPlayer(initializedPlayer);
    }
    return initializedPlayer;
  }

  void _listenToPlayer(Player player) {
    final stream = player.stream;
    _subscriptions = [
      stream.position.listen((position) {
        if (isDragging) return;
        final seconds = position.inSeconds;
        if (seconds != this.position.value) {
          this.position.value = seconds;
          _videoDetailController?.playedTime = position;
          videoPlayerServiceHandler?.onPositionChange(
            position,
            mediaOwnerTag: hashCode.toString(),
          );
        }
      }),
      stream.duration.listen((duration) {
        this.duration.value = duration.inSeconds;
      }),
      stream.playing.listen((playing) {
        final PlayerStatus playerStatus;
        if (playing) {
          animController.forward();
          playerStatus = PlayerStatus.playing;
        } else {
          animController.reverse();
          playerStatus = PlayerStatus.paused;
        }
        videoPlayerServiceHandler?.onStatusChange(
          playerStatus,
          false,
          false,
          mediaOwnerTag: hashCode.toString(),
        );
      }),
      stream.completed.listen((completed) {
        _videoDetailController?.playedTime = player.state.duration;
        videoPlayerServiceHandler?.onStatusChange(
          PlayerStatus.completed,
          false,
          false,
          mediaOwnerTag: hashCode.toString(),
        );
        if (completed) {
          var continuesPlayback = false;
          if (shutdownTimerService.isWaiting) {
            shutdownTimerService.handleWaiting();
          } else {
            switch (playMode.value) {
              case PlayRepeat.pause:
                break;
              case PlayRepeat.listOrder:
                continuesPlayback = playNext(nextPart: true);
                break;
              case PlayRepeat.singleCycle:
                continuesPlayback = true;
                onPlay();
                break;
              case PlayRepeat.listCycle:
                continuesPlayback = true;
                if (!playNext(nextPart: true)) {
                  if (index != null && index != 0 && playlist != null) {
                    playIndex(0);
                  } else {
                    onPlay();
                  }
                }
                break;
              case PlayRepeat.autoPlayRelated:
                break;
            }
          }
          if (!continuesPlayback) {
            audioSessionHandler?.setActive(false, owner: this).ignore();
          }
        }
      }),
    ];
  }

  @override
  Future<void> actionLikeVideo(Object resourceKey) async {
    if (resourceKey != actionResourceKey) return;
    final targetOid = oid;
    final targetSubId = List<Int64>.unmodifiable(subId);
    final targetItemType = itemType;
    final targetAccount = Accounts.main;
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final newVal = !hasLike.value;
    final res = await AudioGrpc.audioThumbUp(
      oid: targetOid,
      subId: targetSubId,
      itemType: targetItemType,
      type: newVal
          ? ThumbUpReq_ThumbType.LIKE
          : ThumbUpReq_ThumbType.CANCEL_LIKE,
      account: targetAccount,
    );
    if (resourceKey != actionResourceKey) return;
    if (res case Success(:final response)) {
      final changed = hasLike.value != newVal;
      hasLike.value = newVal;
      if (changed) {
        try {
          audioItem.value!.stat
            ..hasLike_7 = newVal
            ..like += newVal ? 1 : -1;
          audioItem.refresh();
        } catch (_) {}
      }
      SmartDialog.showToast(response.message);
    } else {
      res.toast();
    }
  }

  @override
  Future<void> actionTriple(Object resourceKey) async {
    if (resourceKey != actionResourceKey) return;
    final targetOid = oid;
    final targetSubId = List<Int64>.unmodifiable(subId);
    final targetItemType = itemType;
    final targetAccount = Accounts.main;
    final hadCoin = hasCoin;
    if (!isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final res = await AudioGrpc.audioTripleLike(
      oid: targetOid,
      subId: targetSubId,
      itemType: targetItemType,
      account: targetAccount,
    );
    if (res case Success(:final response)) {
      if (response.coinOk &&
          !hadCoin &&
          identical(Accounts.main, targetAccount)) {
        GlobalData().afterCoin(2);
      }
      if (resourceKey != actionResourceKey) return;
      if (response.thumbOk && !hasLike.value) {
        hasLike.value = true;
        try {
          audioItem.value!.stat
            ..hasLike_7 = true
            ..like += 1;
          audioItem.refresh();
        } catch (_) {}
      }
      if (response.coinOk && !hasCoin) {
        coinNum.value = 2;
        try {
          audioItem.value!.stat
            ..hasCoin_8 = true
            ..coin += 2;
          audioItem.refresh();
        } catch (_) {}
      }
      if (response.favOk && !hasFav.value) {
        hasFav.value = true;
        try {
          audioItem.value!.stat
            ..hasFav = true
            ..favourite += 1;
          audioItem.refresh();
        } catch (_) {}
      }
      if (!hadCoin && !response.coinOk) {
        SmartDialog.showToast('投币失败');
      } else {
        SmartDialog.showToast('三连成功');
      }
    } else {
      if (resourceKey != actionResourceKey) return;
      res.toast();
    }
  }

  @override
  int get copyright => audioItem.value?.arc.copyright ?? 1;

  @override
  Future<void> onPayCoin(
    ActionResourceSnapshot resource,
    int coin,
    bool coinWithLike,
  ) async {
    if (!isCurrentActionResource(resource)) return;
    final targetOid = oid;
    final targetSubId = List<Int64>.unmodifiable(subId);
    final targetItemType = itemType;
    final res = await AudioGrpc.audioCoinAdd(
      oid: targetOid,
      subId: targetSubId,
      itemType: targetItemType,
      num: coin,
      thumbUp: coinWithLike,
      account: resource.account,
    );
    if (res.isSuccess && identical(Accounts.main, resource.account)) {
      GlobalData().afterCoin(coin);
    }
    if (!isCurrentActionResource(resource)) return;
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
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          DialogOption(
            child: const Text('复制链接', style: TextStyle(fontSize: 14)),
            onPressed: () {
              Get.back();
              Utils.copyText(audioUrl);
            },
          ),
          DialogOption(
            child: const Text('其它app打开', style: TextStyle(fontSize: 14)),
            onPressed: () {
              Get.back();
              PageUtils.launchURL(audioUrl);
            },
          ),
          if (PlatformUtils.isMobile)
            DialogOption(
              child: const Text('分享视频', style: TextStyle(fontSize: 14)),
              onPressed: () {
                Get.back();
                if (audioItem.value case DetailItem(
                  :final arc,
                  :final owner,
                )) {
                  ShareUtils.shareText(
                    '${arc.title} '
                    'UP主: ${owner.name}'
                    ' - $audioUrl',
                  );
                }
              },
            ),
          if (isLogin)
            DialogOption(
              child: const Text('分享至动态', style: TextStyle(fontSize: 14)),
              onPressed: () {
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
          if (isUgc && isLogin)
            DialogOption(
              child: const Text('分享至消息', style: TextStyle(fontSize: 14)),
              onPressed: () {
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
    );
  }

  Future<void>? playOrPause() {
    final player = this.player;
    if (player == null) return null;
    return player.state.playing ? onPause() : onPlay();
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
            _start = null;
            _requestPlayUrl((
              index: index,
              item: null,
              itemType: itemType,
              oid: nextPart.oid,
              subId: List<Int64>.unmodifiable([nextPart.subId]),
              detachVideoController: true,
              start: null,
            )).ignore();
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
    final audioItem = playlist![index];
    final item = audioItem.item;
    final targetSubId =
        subId ??
        (item.subId.isNotEmpty ? item.subId : [audioItem.parts.first.subId]);
    _start = null;
    _requestPlayUrl((
      index: index,
      item: audioItem,
      itemType: item.itemType,
      oid: item.oid,
      subId: List<Int64>.unmodifiable(targetSubId),
      detachVideoController: true,
      start: null,
    )).ignore();
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
  int get currPosInMilliseconds => player?.state.position.inMilliseconds ?? 0;

  @override
  int? get timeLength => player?.state.duration.inMilliseconds ?? 0;

  @override
  Future<void>? seekTo(Duration duration, {required bool isSeek}) =>
      onSeek(duration);

  @override
  bool get autoPlay => true;

  @override
  bool get preInitPlayer => true;

  @override
  void onClose() {
    _playRequestCoordinator.close();
    audioSessionHandler?.setActive(false, owner: this).ignore();
    shutdownTimerService
      ..onPause = null
      ..isPlaying = null
      ..reset();
    videoPlayerServiceHandler
      ?..clearPlayerCallbacks(this)
      ..onVideoDetailDispose(hashCode.toString());
    _subscriptions?.forEach((subscription) => subscription.cancel().ignore());
    _subscriptions?.clear();
    _subscriptions = null;
    player = null;
    _playerInitializer.clear().ignore();
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
