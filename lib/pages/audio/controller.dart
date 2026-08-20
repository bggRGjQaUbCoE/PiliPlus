import 'dart:async';
import 'dart:io' show Platform;

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
import 'package:PiliPlus/pages/common/common_intro_controller.dart'
    show FavMixin;
import 'package:PiliPlus/pages/audio/exo_audio_event_tracker.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/main_reply/view.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart'
    show kMaxVolume;
import 'package:PiliPlus/pages/sponsor_block/block_mixin.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/player_media_track.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/services/audio_session.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/connectivity_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
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

  final audioItem = Rxn<DetailItem>();

  bool _hasInit = false;
  @override
  Player? player;
  ExoPlayerController? _exoPlayer;
  StreamSubscription<ExoPlayerEvent>? _exoSubscription;
  ExoAudioEventTracker? _exoEventTracker;
  String? _lastExoFailure;
  bool _isDisposed = false;

  late final bool useExoPlayer = Platform.isAndroid && Pref.useExoPlayer;
  bool get playerReady => useExoPlayer ? _exoPlayer != null : player != null;

  List<PlayerInfoEntry> get playerInfoEntries {
    if (useExoPlayer) {
      final state = _exoPlayer?.state;
      if (state == null) return const [];
      final audio = state.tracks
          .where(
            (track) =>
                track.type == PlayerMediaTrackType.audio && track.selected,
          )
          .firstOrNull;
      return [
        const PlayerInfoEntry('Backend', 'Media3 ExoPlayer'),
        PlayerInfoEntry('Media', state.mediaDescription ?? 'N/A'),
        PlayerInfoEntry('AudioTrack', audio?.details ?? 'disabled'),
        PlayerInfoEntry(
          'PlaybackConfig',
          state.playbackConfiguration ?? 'N/A',
        ),
        PlayerInfoEntry('rate', state.speed.toString()),
        PlayerInfoEntry('Volume', (state.volume * 100).toStringAsFixed(0)),
        PlayerInfoEntry('AudioDecoder', state.audioDecoder ?? 'N/A'),
      ];
    }
    final player = this.player;
    if (player == null) return const [];
    final state = player.state;
    return [
      const PlayerInfoEntry('Backend', 'MPV'),
      PlayerInfoEntry('Resolution', '${state.width}x${state.height}'),
      PlayerInfoEntry('VideoParams', state.videoParams.toString()),
      PlayerInfoEntry('AudioParams', state.audioParams.toString()),
      PlayerInfoEntry('Media', state.playlist.toString()),
      PlayerInfoEntry('AudioTrack', state.track.audio.toString()),
      PlayerInfoEntry('VideoTrack', state.track.video.toString()),
      PlayerInfoEntry('SubtitleTrack', state.track.subtitle.toString()),
      PlayerInfoEntry('rate', state.rate.toString()),
      PlayerInfoEntry('Volume', player.getProperty('volume').subLength(3)),
      PlayerInfoEntry('hwdec', player.getProperty('hwdec-current')),
    ];
  }

  String get playerOutputVolumePercent => useExoPlayer
      ? ((_exoPlayer?.state.volume ?? Pref.playerVolume / 100) * 100)
            .toStringAsFixed(0)
      : player?.getProperty('volume').subLength(3) ??
            Pref.playerVolume.toStringAsFixed(0);

  Future<void> applyPlayerVolumePreference(double volume) async {
    await _applyPlayerOutputVolume(volume);
  }

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
  late final isLogin = Accounts.main.isLogin;

  Duration? _start;
  VideoDetailController? _videoDetailController;

  String? _prev;
  String? _next;
  bool get reachStart => _prev == null;

  ListOrder order = ListOrder.ORDER_NORMAL;

  double? _lastVolume;
  double _audioFocusGain = 1;
  late final RxDouble desktopVolume = RxDouble(Pref.desktopVolume);
  late final AudioSessionPlayerCallbacks _audioSessionCallbacks;
  final Set<ValueChanged<Duration>> _blockPositionListeners = {};
  final Set<ValueChanged<bool>> _blockPlayingListeners = {};

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
    unawaited(_applyPlayerOutputVolume(volume * 100));
  }

  void syncVolume([_]) {
    final volume = desktopVolume.value;
    final syncVideoVolume = PlPlayerController.syncDesktopVolumeIfExists(
      volume,
    );
    if (syncVideoVolume != null) {
      unawaited(syncVideoVolume);
    }
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

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    videoPlayerServiceHandler?.registerStandalonePlayer(
      hashCode.toString(),
      onPlay: onPlay,
      onPause: onPause,
      onSeek: onSeek,
    );
    _audioSessionCallbacks = AudioSessionPlayerCallbacks(
      isPlaying: isPlaying,
      play: onPlay,
      pause: onPause,
      setGain: _setAudioFocusGain,
    );
    audioSessionHandler?.registerStandalonePlayer(_audioSessionCallbacks);

    _queryPlayList(isInit: true);

    final String? audioUrl = args['audioUrl'];
    final hasAudioUrl = audioUrl != null;
    if (hasAudioUrl) {
      _querySponsorBlock();
      _onOpenMedia(audioUrl, ua: BrowserUa.pc, referer: HttpString.baseUrl);
    }
    ConnectivityUtils.isWiFi.then((isWiFi) {
      cacheAudioQa = isWiFi ? Pref.defaultAudioQa : Pref.defaultAudioQaCellular;
      if (!hasAudioUrl) {
        _queryPlayUrl();
      }
    });
    if (shutdownTimerService.isActive) {
      shutdownTimerService
        ..onPause = onPause
        ..isPlaying = isPlaying;
    }
  }

  bool isPlaying() {
    return useExoPlayer
        ? _exoPlayer?.state.playing ?? false
        : player?.state.playing ?? false;
  }

  Future<void> onPlay() async {
    if (!playerReady) return;
    final hasAudioFocus = await audioSessionHandler?.setActive(true) ?? true;
    if (!hasAudioFocus) return;
    try {
      if (useExoPlayer) {
        final player = _exoPlayer!;
        if (player.state.completed) {
          await player.seek(Duration.zero);
        }
        await player.play();
      } else {
        await player?.play();
      }
    } catch (_) {
      await audioSessionHandler?.setActive(false);
      rethrow;
    }
  }

  Future<void> onPause({bool isInterrupt = false}) async {
    if (useExoPlayer) {
      await _exoPlayer?.pause();
    } else {
      await player?.pause();
    }
    if (!isInterrupt) {
      await audioSessionHandler?.setActive(false);
    }
  }

  Future<void> onSeek(Duration duration) async {
    if (useExoPlayer) {
      await _exoPlayer?.seek(duration);
    } else {
      await player?.seek(duration);
    }
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
        position.value = 0;
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
        position.value = 0;
        _onOpenMedia(VideoUtils.getCdnUrl(durl.playUrls));
      }
    }
  }

  void _onOpenMedia(
    String url, {
    String ua = Constants.userAgentApp,
    String? referer,
  }) {
    unawaited(
      _openMedia(url, ua: ua, referer: referer).onError((error, stackTrace) {
        SmartDialog.showToast('音频播放失败');
        Utils.reportError(
          'Standalone audio open failed: $error',
          stackTrace,
        );
      }),
    );
  }

  Future<void> _openMedia(
    String url, {
    required String ua,
    String? referer,
  }) async {
    await _initPlayerIfNeeded();
    if (!playerReady) return;
    final hasAudioFocus = await audioSessionHandler?.setActive(true) ?? true;
    if (!hasAudioFocus) return;
    try {
      if (useExoPlayer) {
        final player = _exoPlayer!;
        _lastExoFailure = null;
        await player.open(
          videoUrl: url,
          headers: {
            'User-Agent': ua,
            'Referer': ?referer,
          },
          position: _start ?? Duration.zero,
          playWhenReady: true,
        );
      } else {
        player
          ?..setMediaHeader(
            userAgent: ua,
            // mpv cannot clear referer option
            headers: {'Referer': ?referer},
          )
          ..open(Media(url, start: _start));
      }
    } catch (_) {
      await audioSessionHandler?.setActive(false);
      rethrow;
    }
    _start = null;
  }

  Future<void> _initPlayerIfNeeded() async {
    if (_hasInit) return;
    _hasInit = true;
    assert(player == null, _subscriptions = null);
    if (useExoPlayer) {
      try {
        final targetBuffer = Pref.bufferSize * 0x200000;
        final targetBufferBytes = targetBuffer.isFinite && targetBuffer > 0
            ? targetBuffer.round().clamp(64 * 1024, 0x7fffffff)
            : 4 * 1024 * 1024;
        final bufferDuration = Pref.bufferSec * Duration.millisecondsPerSecond;
        final bufferDurationMs = bufferDuration.isFinite && bufferDuration > 0
            ? bufferDuration.round().clamp(500, 0x7fffffff)
            : 16000;
        final player = await ExoPlayerController.create(
          enableHardwareDecoding: Pref.enableHA,
          targetBufferBytes: targetBufferBytes,
          bufferDurationMs: bufferDurationMs,
        );
        if (isClosed || _isDisposed) {
          await player.dispose();
          return;
        }
        _exoPlayer = player;
        _exoEventTracker = ExoAudioEventTracker();
        _exoSubscription = player.events.listen(_handleExoEvent);
        await player.setPlaybackSpeed(speed);
        await _applyPlayerOutputVolume(Pref.playerVolume);
      } catch (_) {
        _hasInit = false;
        rethrow;
      }
      return;
    }
    player = await Player.create(
      configuration: PlayerConfiguration(
        options: {
          'volume': PlatformUtils.isDesktop
              ? (desktopVolume.value * 100).toString()
              : Pref.playerVolume.toString(),
          'volume-max': kMaxVolume.toString(),
          ...Pref.initBuffer(),
        },
      ),
    );
    if (isClosed) {
      player!.dispose();
      player = null;
      return;
    }
    final stream = player!.stream;
    _subscriptions = [
      stream.position.listen((position) {
        if (isDragging) return;
        final seconds = position.inSeconds;
        if (seconds != this.position.value) {
          this.position.value = seconds;
          _videoDetailController?.playedTime = position;
          videoPlayerServiceHandler?.onPositionChange(position);
        }
        for (final listener in _blockPositionListeners) {
          listener(position);
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
        videoPlayerServiceHandler?.onStatusChange(playerStatus, false, false);
        for (final listener in _blockPlayingListeners) {
          listener(playing);
        }
      }),
      stream.completed.listen((completed) {
        if (completed) {
          _handlePlaybackCompleted(player!.state.duration);
        }
      }),
    ];
  }

  void _handleExoEvent(ExoPlayerEvent event) {
    final transition = _exoEventTracker?.accept(event);
    if (transition == null || transition.ignored) return;

    if (event.failure case final failure?) {
      unawaited(audioSessionHandler?.setActive(false));
      animController.reverse();
      videoPlayerServiceHandler?.onStatusChange(.paused, false, false);
      final diagnostics = failure.diagnostics(
        retryAttempt: 0,
        retryLimit: 0,
      );
      if (_lastExoFailure != diagnostics) {
        _lastExoFailure = diagnostics;
        SmartDialog.showToast(failure.userMessage);
        Utils.reportError(diagnostics, failure.diagnosticStackTrace);
      }
      return;
    }
    if (event.ready) {
      _lastExoFailure = null;
    }

    if (!isDragging) {
      final seconds = event.position.inSeconds;
      if (seconds != position.value) {
        position.value = seconds;
        _videoDetailController?.playedTime = event.position;
        videoPlayerServiceHandler?.onPositionChange(event.position);
      }
    }
    for (final listener in _blockPositionListeners) {
      listener(event.position);
    }
    if (event.duration > Duration.zero) {
      duration.value = event.duration.inSeconds;
    }

    if (transition.completedNow) {
      _handlePlaybackCompleted(event.duration);
      return;
    }
    if (transition.statusChanged) {
      if (event.playing) {
        animController.forward();
      } else {
        animController.reverse();
      }
      final status = event.playing ? PlayerStatus.playing : PlayerStatus.paused;
      videoPlayerServiceHandler?.onStatusChange(
        status,
        event.buffering,
        false,
      );
      for (final listener in _blockPlayingListeners) {
        listener(event.playing);
      }
    }
  }

  void _handlePlaybackCompleted(Duration mediaDuration) {
    _videoDetailController?.playedTime = mediaDuration;
    animController.reverse();
    videoPlayerServiceHandler?.onStatusChange(
      PlayerStatus.completed,
      false,
      false,
    );
    for (final listener in _blockPlayingListeners) {
      listener(false);
    }
    if (shutdownTimerService.isWaiting) {
      unawaited(audioSessionHandler?.setActive(false));
      shutdownTimerService.handleWaiting();
      return;
    }
    switch (playMode.value) {
      case PlayRepeat.pause:
        unawaited(audioSessionHandler?.setActive(false));
        break;
      case PlayRepeat.listOrder:
        if (!playNext(nextPart: true)) {
          unawaited(audioSessionHandler?.setActive(false));
        }
        break;
      case PlayRepeat.singleCycle:
        unawaited(onPlay());
        break;
      case PlayRepeat.listCycle:
        if (!playNext(nextPart: true)) {
          if (index != null && index != 0 && playlist != null) {
            playIndex(0);
          } else {
            unawaited(onPlay());
          }
        }
        break;
      case PlayRepeat.autoPlayRelated:
        unawaited(audioSessionHandler?.setActive(false));
        break;
    }
  }

  Future<void> _setAudioFocusGain(double gain) async {
    _audioFocusGain = gain.clamp(0, 1);
    await _applyPlayerOutputVolume(
      PlatformUtils.isDesktop ? desktopVolume.value * 100 : Pref.playerVolume,
    );
  }

  Future<void> _applyPlayerOutputVolume(double volumePercent) async {
    final adjustedVolume = volumePercent * _audioFocusGain;
    if (useExoPlayer) {
      await _exoPlayer?.setVolume((adjustedVolume / 100).clamp(0, 1));
    } else {
      await player?.setVolume(adjustedVolume);
    }
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

  @override
  int get copyright => audioItem.value?.arc.copyright ?? 1;

  @override
  Future<void> onPayCoin(int coin, bool coinWithLike) async {
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

  Future<void> playOrPause() {
    return isPlaying() ? onPause() : onPlay();
  }

  bool playPrev() {
    if (index != null && playlist != null && playerReady) {
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
    if (index != null && playlist != null && playerReady) {
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
    if (!playerReady) return;
    this.speed = speed;
    if (useExoPlayer) {
      unawaited(_exoPlayer?.setPlaybackSpeed(speed));
    } else {
      unawaited(player?.setRate(speed));
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
  int get currPosInMilliseconds => useExoPlayer
      ? _exoPlayer?.state.position.inMilliseconds ?? 0
      : player?.state.position.inMilliseconds ?? 0;

  @override
  int? get timeLength => useExoPlayer
      ? _exoPlayer?.state.duration.inMilliseconds ?? 0
      : player?.state.duration.inMilliseconds ?? 0;

  @override
  Future<void>? seekTo(Duration duration, {required bool isSeek}) =>
      onSeek(duration);

  @override
  bool get autoPlay => true;

  @override
  bool get preInitPlayer => true;

  @override
  bool get blockPlayerReady => playerReady;

  @override
  bool get blockPlayerPlaying => isPlaying();

  @override
  void addBlockPositionListener(ValueChanged<Duration> listener) {
    _blockPositionListeners.add(listener);
  }

  @override
  void removeBlockPositionListener(ValueChanged<Duration> listener) {
    _blockPositionListeners.remove(listener);
  }

  @override
  void addBlockPlayingListener(ValueChanged<bool> listener) {
    _blockPlayingListeners.add(listener);
  }

  @override
  void removeBlockPlayingListener(ValueChanged<bool> listener) {
    _blockPlayingListeners.remove(listener);
  }

  @override
  void onClose() {
    _isDisposed = true;
    shutdownTimerService
      ..onPause = null
      ..isPlaying = null
      ..reset();
    videoPlayerServiceHandler
      ?..onVideoDetailDispose(hashCode.toString())
      ..unregisterStandalonePlayer(hashCode.toString());
    final releaseAudioFocus =
        audioSessionHandler?.isCurrentStandalonePlayer(
          _audioSessionCallbacks,
        ) ??
        isPlaying();
    audioSessionHandler?.unregisterStandalonePlayer(_audioSessionCallbacks);
    if (releaseAudioFocus) {
      unawaited(audioSessionHandler?.setActive(false));
    }
    _subscriptions?.forEach((e) => e.cancel());
    _subscriptions?.clear();
    _subscriptions = null;
    player?.dispose();
    player = null;
    _exoEventTracker?.dispose();
    _exoEventTracker = null;
    unawaited(_exoSubscription?.cancel());
    _exoSubscription = null;
    unawaited(_exoPlayer?.dispose());
    _exoPlayer = null;
    _blockPositionListeners.clear();
    _blockPlayingListeners.clear();
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
