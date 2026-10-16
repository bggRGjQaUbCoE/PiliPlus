import 'dart:async';

import 'package:PiliPlus/services/video_together/client.dart';
import 'package:PiliPlus/services/video_together/models.dart';
import 'package:PiliPlus/services/video_together/navigation.dart';
import 'package:PiliPlus/services/video_together/playback.dart';
import 'package:PiliPlus/services/video_together/preferences.dart';
import 'package:PiliPlus/services/video_together/protocol.dart';
import 'package:PiliPlus/services/video_together/recovery.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/v4.dart';

final class VideoTogetherSession with WidgetsBindingObserver {
  VideoTogetherSession._();

  static final instance = VideoTogetherSession._();

  final role = VideoTogetherRole.none.obs;
  final connectionState = VideoTogetherConnectionState.disconnected.obs;
  final room = Rxn<VideoTogetherRoom>();
  final errorMessage = RxnString();
  final isBusy = false.obs;
  final isControlling = false.obs;
  final messages = <VideoTogetherTextMessage>[].obs;
  final preferenceRevision = 0.obs;

  VideoTogetherClient? _client;
  VideoTogetherPlayback? _playback;
  VideoTogetherMedia? _media;
  VideoTogetherMedia? _lastMedia;
  VideoTogetherOpenVideo? _openVideo;
  VoidCallback? _cancelNavigation;
  VideoTogetherPlaybackSnapshot? _lastPlaybackSnapshot;
  Timer? _timer;
  // ignore: cancel_subscriptions
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  String _roomName = '';
  String _password = '';
  String _server = '';
  String _memberUserId = '';
  String _controlUserId = '';
  String? _expectedRemoteUrl;
  String? _deferredRemoteUrl;
  String _messageSender = '';
  double _expectedRemoteAt = 0;
  double? _pendingRoomUpdateTime;
  double _lastRoomUpdateAt = 0;
  double _lastMemberUpdateAt = 0;
  double _ignoreLocalChangesUntil = 0;
  int _startAttempt = 0;
  int _generation = 0;
  int _navigationRequestRevision = 0;
  int _roomRevision = 0;
  int _localMediaChangeRevision = 0;
  int? _tickGeneration;
  int? _reconnectGeneration;
  int? _syncGeneration;
  int? _applyingGeneration;
  bool _running = false;
  bool _sessionReady = false;
  bool _pendingLocalMediaChange = false;
  bool _memberLoadingStateChanged = false;
  bool _resumeAfterLoading = false;
  bool _hasHeldControl = false;
  bool _runtimeObserversStarted = false;
  bool _appInBackground = false;
  bool _appSuspended = false;
  bool _lifecycleInactive = false;
  bool _networkAvailable = true;
  String? _networkSignature;
  _FollowerSyncRequest? _pendingFollowerSync;
  _FollowerSyncRequest? _activeFollowerSync;
  Completer<void>? _syncCompleter;
  Future<void> _remoteApplyTail = Future<void>.value();
  final _recentRoomUpdateTimes = <double>[];
  int _remoteCommandEpoch = 0;
  final _remotePlaybackSynchronizer = VideoTogetherRemotePlaybackSynchronizer();
  final _reconnectBackoff = VideoTogetherReconnectBackoff();
  final _reconnectQueue = VideoTogetherReconnectQueue();
  final _uptime = Stopwatch()..start();

  bool get inRoom => role.value != VideoTogetherRole.none;
  bool get _tickRunning => _tickGeneration == _generation;
  bool get _reconnectRunning => _reconnectGeneration == _generation;
  bool get _syncRunning => _syncGeneration == _generation;
  bool get _applyingRemoteState => _applyingGeneration == _generation;
  bool get _prioritizesLocalMediaChange =>
      VideoTogetherSyncPolicy.shouldPrioritizeLocalMediaChange(
        pendingMediaChange: _pendingLocalMediaChange,
        hasHeldControl: _hasHeldControl,
        bidirectionalSync: VideoTogetherPreferences.bidirectionalSync,
      );

  String get roomName => _roomName;
  String get server => _server;
  String get currentPassword => _password;
  VideoTogetherMedia? get media => _media ?? _lastMedia;

  double get _monotonicNow => _uptime.elapsedMicroseconds / 1000000;

  bool _isCurrent(int generation) => _running && generation == _generation;

  bool _canRun(int generation) =>
      _isCurrent(generation) &&
      !_appSuspended &&
      !_lifecycleInactive &&
      _networkAvailable;

  bool _ownsClient(int generation, VideoTogetherClient client) =>
      _isCurrent(generation) && identical(_client, client);

  void suppressLocalChanges([
    Duration duration = const Duration(milliseconds: 1200),
  ]) {
    final until = _monotonicNow + duration.inMilliseconds / 1000;
    if (until > _ignoreLocalChangesUntil) {
      _ignoreLocalChangesUntil = until;
    }
  }

  void configureNavigation(
    VideoTogetherOpenVideo callback, {
    VoidCallback? onCancel,
  }) {
    _openVideo = callback;
    _cancelNavigation = onCancel;
  }

  void refreshPreferences() {
    _cancelPendingNavigation();
    preferenceRevision.value += 1;
    if (_running) {
      _messageSender = _buildMessageSender();
      unawaited(_tick(_generation));
    }
  }

  void _cancelPendingNavigation({bool clearDeferred = true}) {
    _navigationRequestRevision += 1;
    _expectedRemoteUrl = null;
    _expectedRemoteAt = 0;
    if (clearDeferred) _deferredRemoteUrl = null;
    _cancelNavigation?.call();
  }

  Future<void> setBidirectionalSync(bool enabled) async {
    await VideoTogetherPreferences.setBidirectionalSync(enabled);
    refreshPreferences();
  }

  void beginLocalMediaChange() {
    if (!_running || !_sessionReady) return;
    _pendingLocalMediaChange = true;
    _localMediaChangeRevision += 1;

    if (!_prioritizesLocalMediaChange) {
      _pendingLocalMediaChange = false;
      return;
    }

    _remoteCommandEpoch += 1;
    _roomRevision += 1;
    _pendingFollowerSync = null;
    _cancelPendingNavigation();
    _remotePlaybackSynchronizer.reset();
    if (!isControlling.value) {
      _controlUserId = _newUserId();
      role.value = VideoTogetherRole.host;
      isControlling.value = true;
      _hasHeldControl = true;
    }
    unawaited(_tick(_generation));
  }

  String _buildMessageSender() {
    final nickname = VideoTogetherPreferences.nickname.trim();
    return nickname.isEmpty ? 'PiliPlus 用户' : nickname;
  }

  void bindPlayback(VideoTogetherPlayback playback, VideoTogetherMedia media) {
    final previousMedia = _media ?? _lastMedia;
    final expectedRemote = _expectedRemoteUrl;
    final openedExpectedRemote =
        expectedRemote != null && _isSameMedia(media.url, expectedRemote);
    final mediaChanged =
        previousMedia != null && !_isSameMedia(previousMedia.url, media.url);

    _playback = playback;
    _media = media;
    _lastMedia = media;
    _remotePlaybackSynchronizer.reset();
    if (openedExpectedRemote) {
      _expectedRemoteUrl = null;
      _expectedRemoteAt = 0;
      _deferredRemoteUrl = null;
      _pendingLocalMediaChange = false;
      suppressLocalChanges();
    } else if (_running && _sessionReady && mediaChanged) {
      beginLocalMediaChange();
    }
    _capturePlaybackSnapshot();
    if (_running) unawaited(_tick(_generation));
  }

  void unbindPlayback(VideoTogetherPlayback playback) {
    if (identical(_playback, playback)) {
      _playback = null;
      _media = null;
      _lastPlaybackSnapshot = null;
      _remotePlaybackSynchronizer.reset();
    }
  }

  Future<void> createRoom({
    required String roomName,
    required String password,
  }) async {
    await _start(
      targetRole: VideoTogetherRole.host,
      roomName: roomName,
      password: password,
    );
  }

  Future<void> joinRoom({
    required String roomName,
    required String password,
  }) async {
    await _start(
      targetRole: VideoTogetherRole.member,
      roomName: roomName,
      password: password,
    );
  }

  Future<void> _start({
    required VideoTogetherRole targetRole,
    required String roomName,
    required String password,
  }) async {
    final normalizedRoomName = roomName.trim();
    if (normalizedRoomName.isEmpty) {
      throw const FormatException('请输入房间名');
    }

    final startAttempt = ++_startAttempt;
    isBusy.value = true;
    errorMessage.value = null;
    await _leave(clearError: false);
    if (startAttempt != _startAttempt) return;
    _roomName = normalizedRoomName;
    _password = password;
    _server = VideoTogetherPreferences.server;
    _memberUserId = _newUserId();
    _messageSender = _buildMessageSender();
    _controlUserId = _newUserId();
    role.value = targetRole;
    isControlling.value = targetRole == VideoTogetherRole.host;
    _hasHeldControl = targetRole == VideoTogetherRole.host;
    _running = true;
    final generation = _generation;
    connectionState.value = VideoTogetherConnectionState.connecting;

    try {
      await _connectClient(generation);
      if (!_canRun(generation)) return;
      if (targetRole == VideoTogetherRole.host) {
        await _sendRoomUpdate(generation);
      } else {
        await _joinAsFollower(generation, forceMemberUpdate: true);
      }
      if (!_canRun(generation)) return;
      _sessionReady = true;
      connectionState.value = VideoTogetherConnectionState.connected;
      _capturePlaybackSnapshot();
      _timer = Timer.periodic(
        const Duration(milliseconds: 400),
        (_) => _tick(generation),
      );
      _startRuntimeObservers();
    } catch (error) {
      if (!_isCurrent(generation)) return;
      errorMessage.value = _friendlyError(error);
      connectionState.value = VideoTogetherConnectionState.error;
      isBusy.value = false;
      await _leave(clearError: false);
      rethrow;
    } finally {
      if (startAttempt == _startAttempt && generation == _generation) {
        isBusy.value = false;
      }
    }
  }

  Future<void> leave({bool clearError = true}) async {
    _startAttempt += 1;
    isBusy.value = false;
    await _leave(clearError: clearError);
  }

  Future<void> _leave({required bool clearError}) async {
    _running = false;
    _sessionReady = false;
    _cancelPendingNavigation();
    _generation += 1;
    _roomRevision += 1;
    _timer?.cancel();
    _timer = null;
    _tickGeneration = null;
    _reconnectGeneration = null;
    _syncGeneration = null;
    _applyingGeneration = null;
    _remoteCommandEpoch += 1;
    _reconnectQueue.clear();
    _pendingFollowerSync = null;
    _activeFollowerSync = null;
    final syncCompleter = _syncCompleter;
    _syncCompleter = null;
    if (syncCompleter != null && !syncCompleter.isCompleted) {
      syncCompleter.complete();
    }
    final client = _client;
    _client = null;
    await _stopRuntimeObservers();
    await client?.disconnect();
    role.value = VideoTogetherRole.none;
    isControlling.value = false;
    connectionState.value = VideoTogetherConnectionState.disconnected;
    room.value = null;
    messages.clear();
    _roomName = '';
    _password = '';
    _server = '';
    _memberUserId = '';
    _controlUserId = '';
    _messageSender = '';
    _expectedRemoteUrl = null;
    _expectedRemoteAt = 0;
    _pendingRoomUpdateTime = null;
    _recentRoomUpdateTimes.clear();
    _lastRoomUpdateAt = 0;
    _lastMemberUpdateAt = 0;
    _ignoreLocalChangesUntil = 0;
    _pendingLocalMediaChange = false;
    _localMediaChangeRevision = 0;
    _memberLoadingStateChanged = false;
    _resumeAfterLoading = false;
    _hasHeldControl = false;
    _appInBackground = false;
    _appSuspended = false;
    _lifecycleInactive = false;
    _networkAvailable = true;
    _networkSignature = null;
    _lastPlaybackSnapshot = null;
    _remotePlaybackSynchronizer.reset();
    if (clearError) errorMessage.value = null;
    _reconnectBackoff.reset();
  }

  Future<void> sendTextMessage(String value) async {
    final text = value.trim();
    if (text.isEmpty) return;
    final client = _client;
    if (client == null || !client.isConnected) {
      throw StateError('尚未连接 VideoTogether 服务器');
    }
    client.sendTextMessage(
      sender: _messageSender,
      text: text,
    );
  }

  Future<void> openCurrentRoomVideo() async {
    final url = room.value?.url;
    if (url == null || url.isEmpty) return;
    await _navigateTo(url, force: true);
  }

  Future<VideoTogetherClient> _connectClient(int generation) async {
    late final VideoTogetherClient client;
    client = VideoTogetherClient(
      server: _server,
      onRoom: (method, value) {
        if (_ownsClient(generation, client)) {
          _onRoom(method, value);
        }
      },
      onError: (message) {
        if (_ownsClient(generation, client)) {
          errorMessage.value = message;
        }
      },
      onTextMessage: (sender, text) {
        if (_ownsClient(generation, client)) {
          _onTextMessage(sender, text);
        }
      },
      onDisconnected: () {
        if (_ownsClient(generation, client)) {
          _onDisconnected(generation);
        }
      },
    );
    await client.connect();
    if (!_canRun(generation)) {
      await client.disconnect();
      throw const _VideoTogetherSessionCancelled();
    }
    _client = client;
    return client;
  }

  void _onRoom(String method, VideoTogetherRoom value) {
    final previousRoom = room.value;
    final roomMediaChanged =
        previousRoom != null &&
        previousRoom.url != value.url &&
        !_isSameMedia(previousRoom.url, value.url);
    if (roomMediaChanged) _cancelPendingNavigation();
    final isOwnUpdate =
        method == VideoTogetherProtocol.roomUpdate &&
        _recentRoomUpdateTimes.any(
          (time) => (value.lastUpdateClientTime - time).abs() < 0.0001,
        );
    _roomRevision += 1;
    room.value = value;
    errorMessage.value = null;

    if (method == VideoTogetherProtocol.roomUpdate) {
      if (isOwnUpdate) {
        role.value = VideoTogetherRole.host;
        isControlling.value = true;
        _hasHeldControl = true;
      } else if (_prioritizesLocalMediaChange) {
        unawaited(_tick(_generation));
      } else {
        if (isControlling.value) {
          _remotePlaybackSynchronizer.reset();
        }
        role.value = VideoTogetherRole.member;
        isControlling.value = false;
        _resumeAfterLoading = false;
      }
    } else if (method == VideoTogetherProtocol.memberUpdate &&
        isControlling.value &&
        previousRoom?.waitForLoading != value.waitForLoading) {
      _memberLoadingStateChanged = true;
      unawaited(_tick(_generation));
    }

    if (_sessionReady &&
        !_reconnectRunning &&
        !_appSuspended &&
        !_lifecycleInactive &&
        !isControlling.value) {
      _queueFollowerSync(value, _roomRevision);
    }
  }

  void _onTextMessage(String sender, String text) {
    if (text.isEmpty) return;
    messages.add(
      VideoTogetherTextMessage(
        sender: sender.trim().isEmpty ? '匿名用户' : sender.trim(),
        text: text,
        receivedAt: DateTime.now(),
        isMine: sender == _messageSender,
      ),
    );
    if (messages.length > 100) messages.removeRange(0, messages.length - 100);
  }

  void _startRuntimeObservers() {
    if (_runtimeObserversStarted) return;
    _runtimeObserversStarted = true;
    WidgetsBinding.instance.addObserver(this);
    if (PlatformUtils.isMobile) {
      final connectivity = Connectivity();
      _connectivitySubscription = connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (_) {},
      );
      unawaited(_readInitialConnectivity(connectivity));
    }
  }

  Future<void> _readInitialConnectivity(Connectivity connectivity) async {
    try {
      _onConnectivityChanged(await connectivity.checkConnectivity());
    } catch (_) {}
  }

  Future<void> _stopRuntimeObservers() async {
    if (!_runtimeObserversStarted) return;
    _runtimeObserversStarted = false;
    WidgetsBinding.instance.removeObserver(this);
    final subscription = _connectivitySubscription;
    _connectivitySubscription = null;
    await subscription?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_running) return;
    final generation = _generation;
    if (state == AppLifecycleState.resumed) {
      final shouldRecover = _appSuspended || _lifecycleInactive;
      _appInBackground = false;
      _appSuspended = false;
      _lifecycleInactive = false;
      _lastPlaybackSnapshot = null;
      _pendingLocalMediaChange = false;
      suppressLocalChanges();
      if (shouldRecover) {
        unawaited(
          _reconnect(
            generation: generation,
            force: true,
            restartPlayback: true,
          ),
        );
      }
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _appInBackground = true;
      _lifecycleInactive = VideoTogetherLifecyclePolicy.shouldSuspend(
        playbackKeepsPlayingInBackground:
            _playback?.keepsPlayingInBackground == true,
      );
      _lastPlaybackSnapshot = null;
      _pendingLocalMediaChange = false;
      return;
    }

    if (const <AppLifecycleState>{
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.detached,
    }.contains(state)) {
      _appInBackground = true;
      final shouldSuspend = VideoTogetherLifecyclePolicy.shouldSuspend(
        playbackKeepsPlayingInBackground:
            _playback?.keepsPlayingInBackground == true,
      );
      _lifecycleInactive = shouldSuspend;
      _appSuspended = shouldSuspend;
      _lastPlaybackSnapshot = null;
      _pendingLocalMediaChange = false;
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final values = results.map((item) => item.name).toList()..sort();
    final signature = values.join(',');
    final isInitial = _networkSignature == null;
    if (!isInitial && signature == _networkSignature) return;
    _networkSignature = signature;

    final isAvailable =
        results.isNotEmpty &&
        results.any((item) => item != ConnectivityResult.none);
    _networkAvailable = isAvailable;
    if (!isAvailable) {
      connectionState.value = VideoTogetherConnectionState.disconnected;
      final client = _client;
      _client = null;
      if (client != null) unawaited(client.disconnect());
      return;
    }

    if (!isInitial && _running && !_appSuspended) {
      unawaited(
        _reconnect(
          generation: _generation,
          force: true,
          restartPlayback: true,
        ),
      );
    }
  }

  void _onDisconnected(int generation) {
    if (!_isCurrent(generation) || !_sessionReady) return;
    connectionState.value = VideoTogetherConnectionState.disconnected;
    unawaited(_tick(generation));
  }

  Future<void> _tick(int generation) async {
    if (_appInBackground) {
      final keepsPlaying = _playback?.keepsPlayingInBackground == true;
      if (!keepsPlaying) {
        _appSuspended = true;
        _lifecycleInactive = true;
        _lastPlaybackSnapshot = null;
        _pendingLocalMediaChange = false;
        return;
      }
      if (_appSuspended || _lifecycleInactive) {
        _appSuspended = false;
        _lifecycleInactive = false;
        suppressLocalChanges();
        unawaited(
          _reconnect(
            generation: generation,
            force: true,
            restartPlayback: true,
          ),
        );
        return;
      }
    }
    if (!_canRun(generation) ||
        _tickRunning ||
        _reconnectRunning ||
        _applyingRemoteState) {
      return;
    }
    _tickGeneration = generation;
    try {
      final client = _client;
      final now = _monotonicNow;
      final connectionStale =
          client != null &&
          client.isConnected &&
          VideoTogetherConnectionWatchdog.isStaleElapsed(
            client.messageSilence,
          );
      if (client == null || !client.isConnected || connectionStale) {
        await _reconnect(
          generation: generation,
          force: connectionStale,
          restartPlayback: true,
        );
        return;
      }

      final playback = _playback;
      final snapshot = playback?.isReady == true
          ? VideoTogetherPlaybackSnapshot.capture(playback!, now)
          : null;
      final hasLocalPlaybackChange =
          _monotonicNow >= _ignoreLocalChangesUntil &&
          snapshot != null &&
          VideoTogetherLocalChangeDetector.hasUserDrivenChange(
            _lastPlaybackSnapshot,
            snapshot,
          );
      final wantsToTakeControl =
          _pendingLocalMediaChange || hasLocalPlaybackChange;
      final canTakeControl = VideoTogetherSyncPolicy.canTakeControl(
        hasHeldControl: _hasHeldControl,
        bidirectionalSync: VideoTogetherPreferences.bidirectionalSync,
      );
      final shouldTakeControl = canTakeControl && wantsToTakeControl;

      if (!canTakeControl && wantsToTakeControl) {
        _pendingLocalMediaChange = false;
      }

      if (shouldTakeControl && _media != null) {
        final localMediaChangeRevision = _localMediaChangeRevision;
        if (!isControlling.value) {
          _controlUserId = _newUserId();
          role.value = VideoTogetherRole.host;
          isControlling.value = true;
          _hasHeldControl = true;
        }
        await _sendRoomUpdate(generation);
        if (_localMediaChangeRevision == localMediaChangeRevision) {
          _pendingLocalMediaChange = false;
        }
      } else if (isControlling.value) {
        if (_memberLoadingStateChanged || now - _lastRoomUpdateAt >= 1.8) {
          _memberLoadingStateChanged = false;
          await _sendRoomUpdate(generation);
        }
      } else if (room.value case final currentRoom?) {
        await _syncFollower(
          currentRoom,
          generation,
          revision: _roomRevision,
        );
      }
    } catch (error) {
      if (!_isCurrent(generation)) return;
      if (_isAuthorityConflict(error)) {
        role.value = VideoTogetherRole.member;
        isControlling.value = false;
        errorMessage.value = null;
        await _reconnect(
          generation: generation,
          forceFollower: true,
          force: true,
        );
      } else if (error is! _VideoTogetherSessionCancelled) {
        errorMessage.value = _friendlyError(error);
      }
    } finally {
      if (_tickGeneration == generation) {
        if (_isCurrent(generation)) _capturePlaybackSnapshot();
        _tickGeneration = null;
      }
    }
  }

  Future<void> _reconnect({
    required int generation,
    bool forceFollower = false,
    bool force = false,
    bool restartPlayback = false,
  }) async {
    if (_reconnectRunning) {
      _reconnectQueue.add(
        forceFollower: forceFollower,
        force: force,
        restartPlayback: restartPlayback,
      );
      return;
    }
    if (!_canRun(generation) ||
        !_reconnectBackoff.canAttempt(_monotonicNow, force: force)) {
      return;
    }

    final resumeControl = !forceFollower && isControlling.value;
    _reconnectGeneration = generation;
    _roomRevision += 1;
    connectionState.value = VideoTogetherConnectionState.reconnecting;
    try {
      final previousClient = _client;
      _client = null;
      await previousClient?.disconnect();
      if (!_canRun(generation)) {
        throw const _VideoTogetherSessionCancelled();
      }
      final client = await _connectClient(generation);
      if (!_ownsClient(generation, client)) {
        throw const _VideoTogetherSessionCancelled();
      }
      _lastRoomUpdateAt = 0;
      _lastMemberUpdateAt = 0;

      if (!resumeControl) {
        role.value = VideoTogetherRole.member;
        isControlling.value = false;
        await _joinAsFollower(
          generation,
          forceMemberUpdate: true,
          restartPlayback: restartPlayback,
        );
      } else {
        try {
          final joinedRoom = await client.joinRoom(
            roomName: _roomName,
            password: _password,
          );
          if (!_ownsClient(generation, client)) {
            throw const _VideoTogetherSessionCancelled();
          }
          room.value = joinedRoom;
          final playback = _playback;
          var playbackRecovered = true;
          if (playback != null && _isSameMedia(_media?.url, joinedRoom.url)) {
            try {
              final applied = await _applyRemoteState(
                playback,
                joinedRoom,
                generation: generation,
                revision: _roomRevision,
                restartPlayback: restartPlayback,
              );
              if (!joinedRoom.paused && !applied) {
                playbackRecovered = false;
              }
            } catch (error) {
              playbackRecovered = false;
              errorMessage.value = '播放器恢复失败：${_friendlyError(error)}';
            }
          }
          if (playbackRecovered) {
            await _sendRoomUpdate(generation);
          } else {
            role.value = VideoTogetherRole.member;
            isControlling.value = false;
            await _syncFollower(
              joinedRoom,
              generation,
              revision: _roomRevision,
              forceMemberUpdate: true,
            );
          }
        } catch (error) {
          if (_isAuthorityConflict(error)) {
            role.value = VideoTogetherRole.member;
            isControlling.value = false;
            final conflictClient = _client;
            _client = null;
            await conflictClient?.disconnect();
            if (!_canRun(generation)) {
              throw const _VideoTogetherSessionCancelled();
            }
            final followerClient = await _connectClient(generation);
            if (!_ownsClient(generation, followerClient)) {
              throw const _VideoTogetherSessionCancelled();
            }
            await _joinAsFollower(
              generation,
              forceMemberUpdate: true,
              restartPlayback: restartPlayback,
            );
          } else if (_isRoomMissing(error)) {
            final playback = _playback;
            final cachedRoom = room.value;
            if (restartPlayback &&
                playback != null &&
                cachedRoom != null &&
                _isSameMedia(_media?.url, cachedRoom.url)) {
              try {
                await _applyRemoteState(
                  playback,
                  cachedRoom,
                  generation: generation,
                  revision: _roomRevision,
                  restartPlayback: true,
                );
              } catch (playbackError) {
                errorMessage.value = '播放器恢复失败：${_friendlyError(playbackError)}';
              }
            }
            await _sendRoomUpdate(generation);
          } else {
            rethrow;
          }
        }
      }

      if (!_canRun(generation)) {
        throw const _VideoTogetherSessionCancelled();
      }
      _reconnectBackoff.reset();
      connectionState.value = VideoTogetherConnectionState.connected;
      if (errorMessage.value?.startsWith('播放器恢复失败：') != true) {
        errorMessage.value = null;
      }
      _capturePlaybackSnapshot();
    } catch (error) {
      if (!_isCurrent(generation)) return;
      final client = _client;
      _client = null;
      await client?.disconnect();
      if (error is! _VideoTogetherSessionCancelled) {
        _reconnectBackoff.registerFailure(_monotonicNow);
        connectionState.value = VideoTogetherConnectionState.error;
        errorMessage.value = _friendlyError(error);
      }
    } finally {
      if (_reconnectGeneration == generation) {
        _reconnectGeneration = null;
        final pending = _reconnectQueue.take();
        if (pending != null && _canRun(generation)) {
          unawaited(
            _reconnect(
              generation: generation,
              forceFollower: pending.forceFollower,
              force: pending.force,
              restartPlayback: pending.restartPlayback,
            ),
          );
        }
      }
    }
  }

  Future<void> _joinAsFollower(
    int generation, {
    bool forceMemberUpdate = false,
    bool restartPlayback = false,
  }) async {
    final client = _client;
    if (client == null || !_ownsClient(generation, client)) {
      throw const _VideoTogetherSessionCancelled();
    }
    final joinedRoom = await client.joinRoom(
      roomName: _roomName,
      password: _password,
    );
    if (!_ownsClient(generation, client)) {
      throw const _VideoTogetherSessionCancelled();
    }
    room.value = joinedRoom;
    await _syncFollower(
      joinedRoom,
      generation,
      revision: _roomRevision,
      forceMemberUpdate: forceMemberUpdate,
      restartPlayback: restartPlayback,
    );
  }

  Future<void> _sendRoomUpdate(int generation) async {
    final client = _client;
    if (client == null ||
        !client.isConnected ||
        !_ownsClient(generation, client)) {
      return;
    }
    final playback = _playback;
    final currentRoom = room.value;

    final shouldWaitForLoading =
        VideoTogetherPreferences.waitForLoading &&
        currentRoom?.waitForLoading == true;
    if (shouldWaitForLoading &&
        playback?.isReady == true &&
        playback!.isPlaying) {
      _resumeAfterLoading = true;
      suppressLocalChanges();
      await playback.pause();
      suppressLocalChanges();
    } else if (_resumeAfterLoading &&
        !shouldWaitForLoading &&
        playback?.isReady == true) {
      _resumeAfterLoading = false;
      suppressLocalChanges();
      await playback!.play();
      suppressLocalChanges();
    }
    if (!_ownsClient(generation, client)) {
      throw const _VideoTogetherSessionCancelled();
    }

    final isReady = playback?.isReady == true;
    final publishedMedia = _media ?? _lastMedia;
    final updateTime = client.serverNow;
    final fallbackPosition = currentRoom?.targetPosition(updateTime) ?? 0;
    _pendingRoomUpdateTime = updateTime;
    _recentRoomUpdateTimes.add(updateTime);
    if (_recentRoomUpdateTimes.length > 16) {
      _recentRoomUpdateTimes.removeRange(
        0,
        _recentRoomUpdateTimes.length - 16,
      );
    }
    try {
      final advertisedPaused = isReady
          ? VideoTogetherSyncPolicy.advertisedPaused(
              isReady: true,
              isPlaying: playback!.isPlaying,
              isBuffering: playback.isBuffering,
              pausedForMemberLoading: _resumeAfterLoading,
            )
          : currentRoom?.paused ?? true;
      final future = client.updateRoom(
        tempUser: _controlUserId,
        password: _password,
        roomName: _roomName,
        playbackRate: isReady
            ? playback!.playbackRate
            : currentRoom?.playbackRate ?? 1,
        currentTime: isReady ? playback!.positionSeconds : fallbackPosition,
        paused: advertisedPaused,
        url: publishedMedia?.url ?? currentRoom?.url ?? '',
        lastUpdateClientTime: updateTime,
        duration: isReady && playback!.durationSeconds > 0
            ? playback.durationSeconds
            : currentRoom?.duration ?? 1000000000,
        isProtected: VideoTogetherPreferences.passwordProtected,
        videoTitle: publishedMedia?.title ?? currentRoom?.videoTitle ?? '',
        waitForResponse: true,
      );
      if (future == null) throw StateError('服务器未确认房间更新');
      final updatedRoom = await future;
      if (!_ownsClient(generation, client)) {
        throw const _VideoTogetherSessionCancelled();
      }
      room.value = updatedRoom;
      _lastRoomUpdateAt = _monotonicNow;
    } finally {
      if (_pendingRoomUpdateTime == updateTime) {
        _pendingRoomUpdateTime = null;
      }
    }
  }

  Future<void> _syncFollower(
    VideoTogetherRoom currentRoom,
    int generation, {
    required int revision,
    bool forceMemberUpdate = false,
    bool restartPlayback = false,
  }) {
    final request = _FollowerSyncRequest(
      room: currentRoom,
      generation: generation,
      revision: revision,
      forceMemberUpdate: forceMemberUpdate,
      restartPlayback: restartPlayback,
    );
    if (!_canRun(generation) ||
        isControlling.value ||
        _prioritizesLocalMediaChange) {
      return Future<void>.value();
    }

    if (_syncRunning) {
      _pendingFollowerSync = request.mergeFlags(
        _pendingFollowerSync ?? _activeFollowerSync,
      );
      return _syncCompleter?.future ?? Future<void>.value();
    }
    final completer = Completer<void>();
    _syncGeneration = generation;
    _syncCompleter = completer;
    unawaited(_runFollowerSync(request, completer));
    return completer.future;
  }

  Future<void> _runFollowerSync(
    _FollowerSyncRequest initialRequest,
    Completer<void> completer,
  ) async {
    var request = initialRequest;
    try {
      while (_canRun(request.generation) &&
          !isControlling.value &&
          !_prioritizesLocalMediaChange) {
        _pendingFollowerSync = null;
        _activeFollowerSync = request;
        try {
          await _performFollowerSync(request);
        } catch (error) {
          if (_isCurrent(request.generation)) {
            errorMessage.value = '播放器同步失败：${_friendlyError(error)}';
          }
        }
        final pending = _pendingFollowerSync;
        if (pending == null || pending.generation != request.generation) break;
        request = pending;
      }
    } finally {
      if (_syncGeneration == initialRequest.generation &&
          identical(_syncCompleter, completer)) {
        _capturePlaybackSnapshot();
        _syncGeneration = null;
        _syncCompleter = null;
        _pendingFollowerSync = null;
        _activeFollowerSync = null;
      }
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> _performFollowerSync(_FollowerSyncRequest request) async {
    final client = _client;
    if (client == null ||
        !client.isConnected ||
        !_ownsClient(request.generation, client) ||
        !_isSyncRequestCurrent(request)) {
      return;
    }

    final sameMedia =
        _playback != null && _isSameMedia(_media?.url, request.room.url);
    if (!sameMedia && request.room.url.isNotEmpty) {
      await _navigateTo(request.room.url);
      if (!_isSyncRequestCurrent(request)) return;
    }

    final playback = _playback;
    var canSync = false;
    if (playback != null && _isSameMedia(_media?.url, request.room.url)) {
      canSync = await _applyRemoteState(
        playback,
        request.room,
        generation: request.generation,
        revision: request.revision,
        restartPlayback: request.restartPlayback,
      );
      if (!_isSyncRequestCurrent(request)) return;
    }

    final now = _monotonicNow;
    if (request.forceMemberUpdate || now - _lastMemberUpdateAt >= 1.8) {
      if (!_ownsClient(request.generation, client)) return;
      client.updateMember(
        roomName: _roomName,
        password: _password,
        userId: _memberUserId,
        isLoading: !canSync || (playback?.isBuffering ?? true),
        currentUrl: canSync ? request.room.url : _media?.url ?? '',
      );
      _lastMemberUpdateAt = now;
    }
  }

  bool _isSyncRequestCurrent(_FollowerSyncRequest request) =>
      _canRun(request.generation) &&
      request.revision == _roomRevision &&
      !isControlling.value &&
      !_prioritizesLocalMediaChange;

  void _queueFollowerSync(VideoTogetherRoom currentRoom, int revision) {
    unawaited(
      _syncFollower(
        currentRoom,
        _generation,
        revision: revision,
      ),
    );
  }

  Future<bool> _applyRemoteState(
    VideoTogetherPlayback playback,
    VideoTogetherRoom currentRoom, {
    required int generation,
    required int revision,
    bool restartPlayback = false,
  }) {
    final commandEpoch = _remoteCommandEpoch;
    final previous = _remoteApplyTail;
    final completed = Completer<void>();
    _remoteApplyTail = completed.future;
    return _runRemoteStateApply(
      previous: previous,
      completed: completed,
      playback: playback,
      currentRoom: currentRoom,
      generation: generation,
      revision: revision,
      commandEpoch: commandEpoch,
      restartPlayback: restartPlayback,
    );
  }

  Future<bool> _runRemoteStateApply({
    required Future<void> previous,
    required Completer<void> completed,
    required VideoTogetherPlayback playback,
    required VideoTogetherRoom currentRoom,
    required int generation,
    required int revision,
    required int commandEpoch,
    required bool restartPlayback,
  }) async {
    try {
      await previous;
      if (!_isRemoteCommandCurrent(generation, revision, commandEpoch)) {
        return false;
      }
      final client = _client;
      if (client == null || !_ownsClient(generation, client)) return false;
      _applyingGeneration = generation;
      final applied = await _remotePlaybackSynchronizer.apply(
        playback: playback,
        room: currentRoom,
        getServerNow: () => client.serverNow,
        syncPlaybackRate: VideoTogetherPreferences.syncPlaybackRate,
        waitForLoading: VideoTogetherPreferences.waitForLoading,
        playingThreshold: VideoTogetherPreferences.syncThreshold,
        restartPlayback: restartPlayback,
        isCurrent: () =>
            _isRemoteCommandCurrent(generation, revision, commandEpoch),
        onRemoteCommand: () {
          if (_isRemoteCommandCurrent(generation, revision, commandEpoch)) {
            suppressLocalChanges();
          }
        },
      );
      return _isRemoteCommandCurrent(generation, revision, commandEpoch) &&
          applied;
    } finally {
      if (_applyingGeneration == generation) {
        _applyingGeneration = null;
      }
      if (commandEpoch != _remoteCommandEpoch) {
        _remotePlaybackSynchronizer.reset();
      }
      if (!completed.isCompleted) completed.complete();
    }
  }

  bool _isRemoteCommandCurrent(
    int generation,
    int revision,
    int commandEpoch,
  ) =>
      commandEpoch == _remoteCommandEpoch &&
      _canRun(generation) &&
      revision == _roomRevision;

  Future<void> _navigateTo(String url, {bool force = false}) async {
    final navigationDeferred =
        _deferredRemoteUrl != null && _isSameMedia(_deferredRemoteUrl, url);
    if (!force && navigationDeferred) return;

    final navigationPending =
        _expectedRemoteUrl != null &&
        _isSameMedia(_expectedRemoteUrl, url) &&
        _monotonicNow - _expectedRemoteAt < 8;
    if (!force && navigationPending) return;

    final openVideo = _openVideo;
    if (openVideo == null) {
      errorMessage.value = '未配置视频跳转处理器';
      return;
    }

    final generation = _generation;
    final requestRevision = ++_navigationRequestRevision;
    _expectedRemoteUrl = url;
    _expectedRemoteAt = _monotonicNow;
    try {
      final result = await openVideo(url, force: force);
      if (!_isCurrent(generation) ||
          requestRevision != _navigationRequestRevision) {
        return;
      }
      switch (result) {
        case VideoTogetherOpenVideoResult.opened:
          _deferredRemoteUrl = null;
        case VideoTogetherOpenVideoResult.deferred:
          _expectedRemoteUrl = null;
          _expectedRemoteAt = 0;
          _deferredRemoteUrl = null;
        case VideoTogetherOpenVideoResult.dismissed:
          _expectedRemoteUrl = null;
          _expectedRemoteAt = 0;
          _deferredRemoteUrl = url;
        case VideoTogetherOpenVideoResult.unsupported:
          _expectedRemoteUrl = null;
          _expectedRemoteAt = 0;
          _deferredRemoteUrl = null;
          errorMessage.value = 'PiliPlus 暂不支持房间当前页面：$url';
      }
    } catch (error) {
      if (!_isCurrent(generation) ||
          requestRevision != _navigationRequestRevision) {
        return;
      }
      _expectedRemoteUrl = null;
      _expectedRemoteAt = 0;
      _deferredRemoteUrl = null;
      errorMessage.value = '打开房间视频失败：${_friendlyError(error)}';
    }
  }

  void _capturePlaybackSnapshot() {
    final playback = _playback;
    _lastPlaybackSnapshot = playback?.isReady == true
        ? VideoTogetherPlaybackSnapshot.capture(playback!, _monotonicNow)
        : null;
  }

  static bool _isSameMedia(String? local, String remote) {
    if (local == null || local.isEmpty || remote.isEmpty) return false;
    return VideoTogetherMediaIdentity.fromUrl(local)
        .sameAs(VideoTogetherMediaIdentity.fromUrl(remote));
  }

  static bool _isAuthorityConflict(Object error) {
    final text = error.toString();
    return text.contains('其他房主正在同步') || text.contains('Other Host Is Syncing');
  }

  static bool _isRoomMissing(Object error) {
    final text = error.toString();
    return text.contains('房间不存在') || text.contains('Room Not Exists');
  }

  static String _newUserId() => '${const UuidV4().generate()}:${_localNow()}';

  static double _localNow() => DateTime.now().microsecondsSinceEpoch / 1000000;

  static String _friendlyError(Object error) {
    if (error is FormatException) return error.message;
    if (error is TimeoutException) return error.message ?? '请求超时';
    final text = error.toString();
    return text.startsWith('Bad state: ') ? text.substring(11) : text;
  }
}

final class _FollowerSyncRequest {
  const _FollowerSyncRequest({
    required this.room,
    required this.generation,
    required this.revision,
    required this.forceMemberUpdate,
    required this.restartPlayback,
  });

  final VideoTogetherRoom room;
  final int generation;
  final int revision;
  final bool forceMemberUpdate;
  final bool restartPlayback;

  _FollowerSyncRequest mergeFlags(_FollowerSyncRequest? previous) {
    if (previous == null || previous.generation != generation) return this;
    return _FollowerSyncRequest(
      room: room,
      generation: generation,
      revision: revision,
      forceMemberUpdate: forceMemberUpdate || previous.forceMemberUpdate,
      restartPlayback: restartPlayback || previous.restartPlayback,
    );
  }
}

final class _VideoTogetherSessionCancelled implements Exception {
  const _VideoTogetherSessionCancelled();
}
