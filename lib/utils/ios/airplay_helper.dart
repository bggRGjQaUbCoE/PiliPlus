import 'package:PiliPlus/services/airplay_hls.dart'
    show isPrivateAirPlayAddress;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Hands a complete media URL to AVKit, while the local player is paused.
abstract final class IOSAirPlayHelper {
  static const _channel = MethodChannel('com.example.piliplus/airplay');

  static bool get isActive => _isActive;
  static bool _isActive = false;

  static Future<({Duration position, String? error})> present({
    required String url,
    required String title,
    required Duration position,
    bool localNetwork = false,
    bool subtitles = false,
    Map<String, Object>? subtitleStyle,
  }) async {
    if (_isActive) throw StateError('AirPlay is already open');
    // The TV endpoint can return HTTP even when the CDN supports HTTPS.
    // Change only the scheme, preserving the host and signed query verbatim.
    final httpsUrl = !localNetwork && url.startsWith('http://')
        ? 'https://${url.substring(7)}'
        : url;
    final uri = Uri.tryParse(httpsUrl);
    final local =
        localNetwork &&
        uri != null &&
        uri.scheme == 'http' &&
        isPrivateAirPlayAddress(uri.host);
    if (uri == null || (!local && uri.scheme != 'https') || uri.host.isEmpty) {
      throw ArgumentError('AirPlay requires a remote HTTPS media URL');
    }
    _isActive = true;
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'present',
        {
          'url': httpsUrl,
          'title': title,
          'positionMs': position.inMilliseconds,
          if (local) 'localNetwork': true,
          if (subtitles) 'subtitles': true,
          if (subtitles && subtitleStyle != null)
            'subtitleStyle': subtitleStyle,
        },
      );
      final milliseconds = result?['positionMs'] as int?;
      if (result?['diagnostics'] case final List diagnostics) {
        for (final entry in diagnostics.whereType<String>()) {
          if (kDebugMode) debugPrint('[AirPlay] $entry');
        }
      }
      return (
        position: milliseconds != null && milliseconds >= 0
            ? Duration(milliseconds: milliseconds)
            : position,
        error: result?['error'] as String?,
      );
    } finally {
      _isActive = false;
    }
  }

  static Future<void> play() => _channel.invokeMethod('play');
  static Future<void> pause() => _channel.invokeMethod('pause');
  static Future<void> seek(Duration position) =>
      _channel.invokeMethod('seek', {'positionMs': position.inMilliseconds});
}
