// Keep each protocol-fixture arrange/assert step explicit.
// ignore_for_file: cascade_invocations
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:PiliPlus/services/video_accelerator/media_source_rewriter.dart';
import 'package:PiliPlus/services/video_accelerator/local_stream_server.dart';

void main() {
  final library = Platform.environment['PILIBOOST_LIBMPV'];
  final directory = Platform.environment['PILIBOOST_NATIVE_FIXTURE'];
  test('locked media_kit native EDL video+audio seek and source rewrite', () async {
    MediaKit.ensureInitialized(libmpv: library);
    final video = await File('$directory/video.avi').readAsBytes();
    final audio = await File('$directory/audio.wav').readAsBytes();
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final requested = <String>[];
    server.listen((request) async {
      try {
        requested.add(request.uri.path);
        final bytes = request.uri.path.endsWith('audio.wav') ? audio : video;
        final match = RegExp(r'^bytes=(\d+)-(\d*)$')
            .firstMatch(request.headers.value('range') ?? '');
        final start = match == null ? 0 : int.parse(match[1]!);
        final requestedEnd = match == null || match[2]!.isEmpty
            ? bytes.length - 1
            : int.parse(match[2]!);
        final end = requestedEnd < bytes.length
            ? requestedEnd
            : bytes.length - 1;
        final response = request.response;
        if (start > end) {
          response.statusCode = 416;
          response.headers.set('content-range', 'bytes */${bytes.length}');
          response.contentLength = 0;
        } else {
          response.statusCode = match == null ? 200 : 206;
          response.headers.set('accept-ranges', 'bytes');
          if (match != null) {
            response.headers.set(
              'content-range',
              'bytes $start-$end/${bytes.length}',
            );
          }
          response.contentLength = end - start + 1;
          response.add(bytes.sublist(start, end + 1));
        }
        await response.close();
      } catch (_) {
        /* Seeks intentionally disconnect readers. */
      }
    });
    final base = 'http://127.0.0.1:${server.port}';
    final relay = LocalStreamServer(
      source: () => Uri.parse('$base/cdn-a/video.avi'),
      headers: const {},
      clientFactory: HttpClient.new,
    );
    await relay.start();
    final oldVideo = relay.uri.toString(), newVideo = '$base/cdn-b/video.avi';
    final audioUrl = '$base/audio.wav';
    final edl =
        'edl://!no_chapters;%${oldVideo.length}%$oldVideo;!new_stream;!no_chapters;%${audioUrl.length}%$audioUrl';
    final player = await Player.create(
      configuration: const PlayerConfiguration(
        options: {
          'vo': 'null',
          'ao': 'null',
          'cache': 'no',
          'config': 'no',
        },
      ),
    );
    Future<void> waitFor(bool Function() ready) async {
      final deadline = DateTime.now().add(const Duration(seconds: 15));
      while (!ready()) {
        if (DateTime.now().isAfter(deadline)) fail('native EDL timeout');
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }

    try {
      await player.open(Media(edl), play: true);
      await waitFor(
        () =>
            player.state.tracks.video.length > 2 &&
            player.state.tracks.audio.length > 2,
      );
      expect(player.state.duration.inSeconds, 60);
      await player.seek(const Duration(seconds: 30));
      await waitFor(() => player.state.position.inSeconds >= 30);
      await player.setRate(1.25);
      final position = player.state.position;
      final subtitle = player.state.track.subtitle;
      final selectedAudio = player.state.track.audio;
      final rewritten = rewriteMediaSource(
        edl,
        oldVideo,
        audioUrl,
        newVideo,
        audioUrl,
      );
      await player.open(Media(rewritten, start: position), play: false);
      await player.setRate(1.25);
      await player.setSubtitleTrack(subtitle);
      await player.setAudioTrack(selectedAudio);
      await waitFor(() => requested.contains('/cdn-b/video.avi'));
      expect(player.getProperty('pause'), 'yes');
      expect(player.state.rate, 1.25);
      expect(player.current.last.uri, contains('!new_stream;!no_chapters;'));
      expect(requested, contains('/audio.wav'));
      expect(relay.forwardedBytes, greaterThan(0));
      // ignore: avoid_print
      print(
        'PROXY_NATIVE requests=${relay.requests} errors=${relay.errors} reason=${relay.lastFailureReason}',
      );
      expect(relay.errors, 0);
      // ignore: avoid_print
      print(
        'NATIVE_EDL PASS proxy-video+direct-audio duration=60 seek=30 source-rewrite pause=yes rate=1.25',
      );
    } finally {
      await player.dispose();
      await relay.close();
      await server.close(force: true);
      // Locked media-kit destroys its native handle using a delayed timer.
      await Future<void>.delayed(const Duration(seconds: 6));
    }
  }, skip: library == null || directory == null);
}
