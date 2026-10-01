import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:PiliPlus/services/video_accelerator/accelerator_config.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_session.dart';
import 'package:PiliPlus/services/video_accelerator/cdn_probe.dart';
import 'package:PiliPlus/services/video_accelerator/cdn_resolver.dart';

abstract final class PlaybackSourceAdapter {
  static AcceleratorSession? prepare({
    required BaseItem video,
    BaseItem? audio,
    required String videoUrl,
    String? audioUrl,
    double? durationSeconds,
  }) {
    try {
      return _prepare(
        video: video,
        audio: audio,
        videoUrl: videoUrl,
        audioUrl: audioUrl,
        durationSeconds: durationSeconds,
      );
    } catch (_) {
      // A malformed candidate or settings error never prevents original playback.
      return null;
    }
  }

  static AcceleratorSession? _prepare({
    required BaseItem video,
    BaseItem? audio,
    required String videoUrl,
    String? audioUrl,
    double? durationSeconds,
  }) {
    final config = AcceleratorConfig(mode: Pref.acceleratorMode);
    // OFF returns before creating clients, subscriptions, timers or probes.
    if (config.mode == AcceleratorMode.off) return null;
    AcceleratorTrack track(
      String kind,
      BaseItem item,
      String original, {
      bool disabled = false,
    }) => AcceleratorTrack(
      kind: kind,
      original: Uri.parse(original),
      bitrateBps: item.bandWidth?.toDouble(),
      durationSeconds: durationSeconds,
      candidates: CdnResolver.resolve(
        original: original,
        playUrls: disabled ? const [] : item.playUrls,
        allowMirrors: !disabled,
        mirrorHosts: CDNService.values
            .map((cdn) => cdn.host)
            .whereType<String>(),
      ),
    );
    final probe = createProbe();
    return AcceleratorSession(
      config: config,
      probe: probe.run,
      tracks: [
        track('video', video, videoUrl),
        if (audio != null && audioUrl != null && audioUrl.isNotEmpty)
          track('audio', audio, audioUrl, disabled: VideoUtils.disableAudioCDN),
        if (audio == null && audioUrl != null && audioUrl.isNotEmpty)
          AcceleratorTrack(
            kind: 'audio',
            original: Uri.parse(audioUrl),
            candidates: [Uri.parse(audioUrl)],
          ),
      ],
    );
  }

  static CdnProbe createProbe() => CdnProbe(
    headers: {'user-agent': BrowserUa.pc, 'referer': HttpString.baseUrl},
    clientFactory: createClient,
  );

  static HttpClient createClient() {
    final client = HttpClient();
    final port = int.tryParse(Pref.systemProxyPort);
    if (Pref.enableSystemProxy &&
        Pref.systemProxyHost.isNotEmpty &&
        port != null) {
      client.findProxy = (_) => 'PROXY ${Pref.systemProxyHost}:$port';
    }
    return client;
  }
}

/// Owned by the player, not a video page: PiP/background can outlive the page.
class AcceleratorBinding {
  AcceleratorBinding(this.session, this.observe) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!session.enabled) return;
      try {
        observe();
        session.publish();
      } catch (_) {
        unawaited(session.restoreOriginal());
      }
    });
    _network = Connectivity().onConnectivityChanged
        .skip(1)
        .listen(
          (_) => session.invalidate(networkChanged: true),
          onError: (Object _) => session.invalidate(networkChanged: true),
        );
  }
  final AcceleratorSession session;
  final void Function() observe;
  late final Timer _timer;
  late final StreamSubscription<List<ConnectivityResult>> _network;
  void dispose() {
    _timer.cancel();
    unawaited(_network.cancel());
    session.dispose();
  }
}
