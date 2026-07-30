import 'package:PiliPlus/plugin/pl_player/models/player_media_track.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a structured Media3 video track', () {
    final track = PlayerMediaTrack.fromMap({
      'type': 'video',
      'id': 'video-avc',
      'groupIndex': 2,
      'trackIndex': 1,
      'selected': true,
      'supported': true,
      'title': '1080P',
      'language': 'und',
      'codec': 'avc1.640028',
      'mimeType': 'video/avc',
      'bitrate': 4500000,
      'width': 1920,
      'height': 1080,
      'frameRate': 60,
    });

    expect(track.type, PlayerMediaTrackType.video);
    expect(track.groupIndex, 2);
    expect(track.trackIndex, 1);
    expect(track.selected, isTrue);
    expect(track.displayName, contains('1920x1080'));
    expect(track.details, contains('mimeType: video/avc'));
  });

  test('rejects an unknown native track type', () {
    expect(
      () => PlayerMediaTrack.fromMap({
        'type': 'metadata',
        'id': 'metadata',
      }),
      throwsFormatException,
    );
  });

  test('marks app-loaded subtitles as external tracks', () {
    final track = PlayerMediaTrack.fromMap({
      'type': 'subtitle',
      'id': 'piliplus-app-subtitle',
      'groupIndex': 3,
      'trackIndex': 0,
      'selected': true,
      'supported': true,
      'external': true,
      'title': '简体中文',
      'language': 'zh-CN',
      'mimeType': 'text/vtt',
    });

    expect(track.external, isTrue);
    expect(track.displayName, contains('简体中文'));
    expect(track.details, contains('external: true'));
  });
}
