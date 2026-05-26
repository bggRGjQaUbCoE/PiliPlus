enum CastConnectionState { disconnected, discovering, connecting, connected }

enum CastPlaybackState { idle, loading, playing, paused, buffering }

class CastRemoteState {
  final CastConnectionState connection;
  final CastPlaybackState playback;
  final Duration position;
  final Duration duration;
  final double volume;
  final bool isMuted;
  final String? deviceId;
  final String? deviceName;

  const CastRemoteState({
    this.connection = CastConnectionState.disconnected,
    this.playback = CastPlaybackState.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    double volume = 1.0,
    this.isMuted = false,
    this.deviceId,
    this.deviceName,
  }) : volume = (volume != volume || volume < 0)
           ? 0
           : (volume > 1 ? 1 : volume);

  CastRemoteState copyWith({
    CastConnectionState? connection,
    CastPlaybackState? playback,
    Duration? position,
    Duration? duration,
    double? volume,
    bool? isMuted,
    String? deviceId,
    String? deviceName,
    bool clearDeviceId = false,
    bool clearDeviceName = false,
  }) {
    return CastRemoteState(
      connection: connection ?? this.connection,
      playback: playback ?? this.playback,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      deviceId: clearDeviceId ? null : (deviceId ?? this.deviceId),
      deviceName: clearDeviceName ? null : (deviceName ?? this.deviceName),
    );
  }
}
