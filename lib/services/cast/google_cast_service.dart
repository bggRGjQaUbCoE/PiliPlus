import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/services/cast/cast_media_payload.dart';
import 'package:PiliPlus/services/cast/cast_remote_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';

class GoogleCastService {
  static final GoogleCastService instance = GoogleCastService._();
  GoogleCastService._();

  static const _connectionTimeout = Duration(seconds: 10);

  final _stateController = StreamController<CastRemoteState>.broadcast();

  CastRemoteState _state = const CastRemoteState();
  StreamSubscription<GoogleCastSession?>? _sessionSub;
  StreamSubscription<GoggleCastMediaStatus?>? _mediaSub;
  StreamSubscription<Duration>? _positionSub;

  double _lastNonZeroVolume = 1.0;
  bool _initialized = false;

  bool get isSupported => Platform.isAndroid || Platform.isIOS;
  bool get _canUseCast => isSupported && _initialized;

  CastRemoteState get state => _state;
  Stream<CastRemoteState> get stateStream => _stateController.stream;

  List<GoogleCastDevice> get devices => _canUseCast
      ? GoogleCastDiscoveryManager.instance.devices
      : const <GoogleCastDevice>[];

  Stream<List<GoogleCastDevice>> get devicesStream => _canUseCast
      ? GoogleCastDiscoveryManager.instance.devicesStream
      : Stream.value(const <GoogleCastDevice>[]);

  GoogleCastSession? get _session =>
      GoogleCastSessionManager.instance.currentSession;

  GoogleCastDevice? get currentDevice => _session?.device;

  GoogleCastRemoteMediaClientPlatformInterface get _mediaClient =>
      GoogleCastRemoteMediaClient.instance;

  Future<bool> initialize() async {
    if (!isSupported) {
      if (kDebugMode) {
        debugPrint('GoogleCastService: platform not supported');
      }
      return false;
    }
    if (_initialized) return true;

    try {
      if (Platform.isAndroid) {
        await GoogleCastContext.instance.setSharedInstanceWithOptions(
          GoogleCastOptionsAndroid(
            appId: GoogleCastDiscoveryCriteria.kDefaultApplicationId,
          ),
        );
      } else {
        await GoogleCastContext.instance.setSharedInstanceWithOptions(
          IOSGoogleCastOptions(
            GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(
              GoogleCastDiscoveryCriteria.kDefaultApplicationId,
            ),
          ),
        );
      }
      _initialized = true;
      _registerListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GoogleCastService: init failed: $e');
      }
      return false;
    }
  }

  void _registerListeners() {
    _sessionSub?.cancel();
    _sessionSub = GoogleCastSessionManager.instance.currentSessionStream.listen(
      (session) {
        _updateFromSession(session);
        _registerMediaListeners();
      },
    );
    _updateFromSession(_session);
    _registerMediaListeners();
  }

  void _registerMediaListeners() {
    _mediaSub?.cancel();
    _positionSub?.cancel();

    final session = _session;
    if (session != null) {
      _mediaSub = _mediaClient.mediaStatusStream.listen(_onMediaStatus);
      _positionSub = _mediaClient.playerPositionStream.listen(
        _onPlayerPosition,
      );
    }
  }

  void _updateFromSession(GoogleCastSession? session) {
    if (session != null) {
      final device = session.device;
      final deviceId = device?.deviceID;
      final deviceName = device?.friendlyName;
      _emit(
        _state.copyWith(
          connection: _mapConnectionState(session.connectionState),
          deviceId: deviceId,
          deviceName: deviceName,
          clearDeviceId: deviceId == null,
          clearDeviceName: deviceName == null,
          volume: session.currentDeviceVolume,
          isMuted: session.currentDeviceMuted,
        ),
      );
    } else {
      _emit(const CastRemoteState());
    }
  }

  void _onMediaStatus(GoggleCastMediaStatus? status) {
    if (status == null) return;
    _emit(
      _state.copyWith(
        playback: _mapPlaybackState(status.playerState),
        duration: status.mediaInformation?.duration,
        volume: status.volume.toDouble(),
        isMuted: status.isMuted,
      ),
    );
  }

  void _onPlayerPosition(Duration position) {
    _emit(_state.copyWith(position: position));
  }

  void _emit(CastRemoteState next) {
    _state = next;
    _stateController.add(next);
  }

  CastPlaybackState _mapPlaybackState(CastMediaPlayerState state) {
    switch (state) {
      case CastMediaPlayerState.playing:
        return CastPlaybackState.playing;
      case CastMediaPlayerState.paused:
        return CastPlaybackState.paused;
      case CastMediaPlayerState.buffering:
        return CastPlaybackState.buffering;
      case CastMediaPlayerState.loading:
        return CastPlaybackState.loading;
      case CastMediaPlayerState.idle:
      case CastMediaPlayerState.unknown:
        return CastPlaybackState.idle;
    }
  }

  CastConnectionState _mapConnectionState(GoogleCastConnectState state) {
    switch (state) {
      case GoogleCastConnectState.connected:
        return CastConnectionState.connected;
      case GoogleCastConnectState.connecting:
        return CastConnectionState.connecting;
      case GoogleCastConnectState.disconnecting:
      case GoogleCastConnectState.disconnected:
        return CastConnectionState.disconnected;
    }
  }

  // ---------------------------------------------------------------------------
  // Discovery
  // ---------------------------------------------------------------------------

  Future<void> startDiscovery() async {
    if (!_canUseCast) return;
    await GoogleCastDiscoveryManager.instance.startDiscovery();
  }

  Future<void> stopDiscovery() async {
    if (!_canUseCast) return;
    await GoogleCastDiscoveryManager.instance.stopDiscovery();
  }

  // ---------------------------------------------------------------------------
  // Connection
  // ---------------------------------------------------------------------------

  Future<bool> connect(GoogleCastDevice device) async {
    if (!_canUseCast) return false;
    try {
      _emit(_state.copyWith(connection: CastConnectionState.connecting));
      final started = await GoogleCastSessionManager.instance
          .startSessionWithDevice(device);
      if (!started) {
        _emit(_state.copyWith(connection: CastConnectionState.disconnected));
        return false;
      }
      final session = await _waitForConnectedSession(device);
      if (session == null) {
        _emit(_state.copyWith(connection: CastConnectionState.disconnected));
        return false;
      }
      _updateFromSession(session);
      _registerMediaListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GoogleCastService: connect failed: $e');
      }
      _emit(_state.copyWith(connection: CastConnectionState.disconnected));
      return false;
    }
  }

  Future<GoogleCastSession?> _waitForConnectedSession(
    GoogleCastDevice device,
  ) async {
    final deadline = DateTime.now().add(_connectionTimeout);
    while (DateTime.now().isBefore(deadline)) {
      final session = _session;
      if (_isConnectedSession(session, device)) return session;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    final session = _session;
    return _isConnectedSession(session, device) ? session : null;
  }

  bool _isConnectedSession(
    GoogleCastSession? session,
    GoogleCastDevice device,
  ) {
    if (session?.connectionState != GoogleCastConnectState.connected) {
      return false;
    }
    final deviceID = session?.device?.deviceID;
    return deviceID == null || deviceID == device.deviceID;
  }

  Future<bool> disconnect({bool stopCasting = true}) async {
    if (!_canUseCast) return false;
    try {
      final disconnected = stopCasting
          ? await GoogleCastSessionManager.instance.endSessionAndStopCasting()
          : await GoogleCastSessionManager.instance.endSession();
      if (disconnected) {
        _emit(const CastRemoteState());
      }
      return disconnected;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GoogleCastService: disconnect failed: $e');
      }
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Media controls
  // ---------------------------------------------------------------------------

  Future<void> load(CastMediaPayload payload, {bool autoPlay = true}) async {
    if (!_canUseCast) {
      throw UnsupportedError('Google Cast is not available on this platform');
    }
    final session = _session;
    if (session?.connectionState != GoogleCastConnectState.connected) {
      throw StateError('Google Cast session is not connected');
    }

    final previousState = _state;
    _emit(_state.copyWith(playback: CastPlaybackState.loading));

    final metadata = _buildMetadata(payload);

    final mediaInfo = Platform.isAndroid
        ? GoogleCastMediaInformationAndroid(
            contentId: payload.contentId,
            contentType: payload.contentType,
            streamType: CastMediaStreamType.buffered,
            contentUrl: payload.url,
            customData: payload.customData,
            duration: payload.duration,
            metadata: metadata,
          )
        : GoogleCastMediaInformationIOS(
            contentId: payload.contentId,
            contentType: payload.contentType,
            streamType: CastMediaStreamType.buffered,
            contentUrl: payload.url,
            customData: payload.customData,
            duration: payload.duration,
            metadata: metadata,
          );

    try {
      await _mediaClient.loadMedia(
        mediaInfo,
        autoPlay: autoPlay,
        playPosition: payload.position,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GoogleCastService: load failed: $e');
      }
      _emit(previousState);
      rethrow;
    }
  }

  GoogleCastMediaMetadata? _buildMetadata(CastMediaPayload payload) {
    if (payload.cover == null && payload.title.isEmpty) return null;

    final images = payload.cover != null
        ? [GoogleCastImage(url: payload.cover!)]
        : null;

    return GoogleCastMovieMediaMetadata(
      title: payload.title,
      images: images,
    );
  }

  Future<void> play() async {
    if (!_canUseCast) return;
    if (_session == null) return;
    await _mediaClient.play();
  }

  Future<void> pause() async {
    if (!_canUseCast) return;
    if (_session == null) return;
    await _mediaClient.pause();
  }

  Future<void> stop() async {
    if (!_canUseCast) return;
    if (_session == null) return;
    await _mediaClient.stop();
  }

  Future<void> seek(Duration position, {bool resumePlayback = false}) async {
    if (!_canUseCast) return;
    if (_session == null) return;
    await _mediaClient.seek(
      GoogleCastMediaSeekOption(
        position: position,
        resumeState: resumePlayback
            ? GoogleCastMediaResumeState.play
            : GoogleCastMediaResumeState.unchanged,
      ),
    );
  }

  Future<void> setVolume(double volume) async {
    if (!_canUseCast) return;
    final clamped = CastRemoteState(volume: volume).volume;
    if (clamped > 0) _lastNonZeroVolume = clamped;
    _emit(_state.copyWith(volume: clamped, isMuted: clamped == 0));
    GoogleCastSessionManager.instance.setDeviceVolume(clamped);
  }

  Future<void> setMuted(bool muted) async {
    if (!_canUseCast) return;
    if (muted) {
      if (_state.volume > 0) _lastNonZeroVolume = _state.volume;
      _emit(_state.copyWith(isMuted: true, volume: 0));
      GoogleCastSessionManager.instance.setDeviceVolume(0);
    } else {
      final restore = _lastNonZeroVolume > 0 ? _lastNonZeroVolume : 1.0;
      _emit(_state.copyWith(isMuted: false, volume: restore));
      GoogleCastSessionManager.instance.setDeviceVolume(restore);
    }
  }
}
