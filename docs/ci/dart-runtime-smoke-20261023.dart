import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:media_kit/media_kit_dart.dart';

Future<void> main(List<String> args) async {
  final reportFile = File(args[2]);
  final report = <String, Object?>{
    'kind': 'piliplus-public-player-headless-smoke',
    'library': args[0],
    'media': args[1],
    'status': 'running',
    'public_entrypoint': 'package:media_kit/media_kit_dart.dart',
    'video_output': 'null',
    'audio_output': 'null',
    'hardware_decode': false,
    'gpu': false,
    'device': false,
  };
  void checkpoint() => reportFile.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(report)}\n');
  final positions = <int>[];
  final durations = <int>[];
  final playing = <bool>[];
  final errors = <String>[];
  final logs = <String>[];
  final videoEvents = <Map<String, Object?>>[];
  final progressed = Completer<void>();
  final decodedVideo = Completer<VideoParams>();
  final completed = Completer<void>();
  final subscriptions = <StreamSubscription<dynamic>>[];
  Player? player;
  try {
    report['stage'] = 'initialize'; checkpoint();
    MediaKit.ensureInitialized(libmpv: args[0]);
    player = Player(configuration: const PlayerConfiguration(
      vo: 'null',
      logLevel: MPVLogLevel.error,
      options: <String, String>{
        'ao': 'null', 'vid': 'auto', 'hwdec': 'no',
        'config': 'no', 'terminal': 'no',
      },
    ));
    subscriptions.add(player.stream.position.listen((value) {
      if (positions.length < 100) positions.add(value.inMilliseconds);
      if (value >= const Duration(milliseconds: 500) && !progressed.isCompleted) {
        progressed.complete();
      }
    }));
    subscriptions.add(player.stream.duration.listen((value) {
      if (durations.length < 20) durations.add(value.inMilliseconds);
    }));
    subscriptions.add(player.stream.videoParams.listen((value) {
      if (videoEvents.length < 20) videoEvents.add(<String, Object?>{
        'w': value.w, 'h': value.h, 'pixelformat': value.pixelformat,
        'hw_pixelformat': value.hwPixelformat,
      });
      if ((value.w ?? 0) > 0 && (value.h ?? 0) > 0 && !decodedVideo.isCompleted) {
        decodedVideo.complete(value);
      }
    }));
    subscriptions.add(player.stream.playing.listen(playing.add));
    subscriptions.add(player.stream.completed.listen((value) {
      if (value && !completed.isCompleted) completed.complete();
    }));
    subscriptions.add(player.stream.error.listen(errors.add));
    subscriptions.add(player.stream.log.listen((value) {
      if (logs.length < 40) logs.add('${value.prefix}: ${value.level}: ${value.text}');
    }));
    report['stage'] = 'open'; checkpoint();
    await player.open(Media(args[1]), play: true)
        .timeout(const Duration(seconds: 10));
    report['opened'] = true;
    await progressed.future.timeout(const Duration(seconds: 10));
    report['position_progressed'] = true;
    final video = await decodedVideo.future.timeout(const Duration(seconds: 10));
    report['decoded_video_params'] = <String, Object?>{
      'w': video.w, 'h': video.h, 'pixelformat': video.pixelformat,
      'hw_pixelformat': video.hwPixelformat,
    };
    if (video.w != 160 || video.h != 90) {
      throw StateError('decoded video parameters do not match the fixture');
    }
    report['video_tracks'] = <Map<String, Object?>>[
      for (final track in player.state.tracks.video)
        if (track.codec != null)
          <String, Object?>{'id': track.id, 'codec': track.codec,
            'decoder': track.decoder, 'w': track.w, 'h': track.h},
    ];
    final expectedCodec = args[1].endsWith('.mp4') ? 'h264' : 'ffv1';
    if (!player.state.tracks.video.any((track) =>
        track.codec == expectedCodec && track.w == 160 && track.h == 90)) {
      throw StateError('public video track does not match the fixture');
    }
    report['stage'] = 'pause-seek-batch-properties'; checkpoint();
    await player.pause().timeout(const Duration(seconds: 5));
    final pause = await player.getPropertyAsync('pause')
        .timeout(const Duration(seconds: 5));
    if (pause != 'yes') throw StateError('pause property is $pause');
    report['paused'] = true;
    await player.seek(const Duration(seconds: 2))
        .timeout(const Duration(seconds: 5));
    report['seek_command_completed'] = true;
    const keys = <String>[
      'path', 'duration', 'pause', 'time-pos', 'video-codec', 'audio-codec-name',
      'mpv-version',
    ];
    final values = await player.getPropertiesAsync(keys)
        .timeout(const Duration(seconds: 5));
    final properties = Map<String, String>.fromIterables(keys, values);
    report['batch_properties'] = properties;
    if (properties['path'] != args[1]) throw StateError('media identity mismatch');
    if ((double.tryParse(properties['duration'] ?? '') ?? 0) < 3.9) {
      throw StateError('duration missing');
    }
    // Decoder NODE events above are the SDK's actual public video API.
    // Keep the legacy video-codec string for observation, not as the gate:
    // newer upstream builds can omit that property while decoding succeeds.
    if ((properties['audio-codec-name'] ?? '').isEmpty) {
      throw StateError('audio decoder metadata missing');
    }
    report['stage'] = 'resume-to-eof'; checkpoint();
    await player.play().timeout(const Duration(seconds: 5));
    await completed.future.timeout(const Duration(seconds: 10));
    report['completed_event'] = true;
    report['final_position_ms'] = player.state.position.inMilliseconds;
    report['final_duration_ms'] = player.state.duration.inMilliseconds;
    report['positions_ms'] = positions;
    report['durations_ms'] = durations;
    report['playing_events'] = playing;
    report['stream_errors'] = errors;
    report['native_logs'] = logs;
    report['video_params_events'] = videoEvents;
    if (errors.isNotEmpty) throw StateError('player stream reported errors');
    report['stage'] = 'dispose'; checkpoint();
    await player.dispose().timeout(const Duration(seconds: 10));
    report['disposed'] = true;
    await player.nativeDestructionComplete.timeout(const Duration(seconds: 10));
    report['native_destruction_complete'] = true;
    for (final subscription in subscriptions) { await subscription.cancel(); }
    report['stage'] = 'complete';
    report['status'] = 'passed';
    checkpoint();
    print(jsonEncode({'status': 'passed', 'report': args[2]}));
    // The SDK's process-wide API isolate may stay alive; native destruction
    // above is awaited before ending this standalone diagnostic process.
    exit(0);
  } catch (error, stack) {
    report['status'] = 'failed';
    report['error'] = '$error';
    report['stack'] = '$stack';
    report['positions_ms'] = positions;
    report['durations_ms'] = durations;
    report['playing_events'] = playing;
    report['stream_errors'] = errors;
    report['native_logs'] = logs;
    report['video_params_events'] = videoEvents;
    checkpoint();
    stderr.writeln(jsonEncode({'status': 'failed', 'error': '$error', 'report': args[2]}));
    exit(1);
  }
}
