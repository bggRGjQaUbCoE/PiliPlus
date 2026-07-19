import 'dart:async';

import 'package:PiliPlus/pages/video/video_media_request_guard.dart';
import 'package:flutter_test/flutter_test.dart';

const mediaA = (
  aid: 1,
  bvid: 'BV-A',
  cid: 11,
  epId: 101,
  seasonId: 1001,
);
const mediaB = (
  aid: 2,
  bvid: 'BV-B',
  cid: 22,
  epId: 202,
  seasonId: 2002,
);

void main() {
  test('completion from the previous media is rejected after reset', () async {
    final guard = VideoMediaRequestGuard();
    var currentMedia = mediaA;
    final request = guard.capture(currentMedia);
    final response = Completer<String>();
    String? applied;

    final pending = response.future.then((value) {
      if (guard.isCurrent(request, currentMedia)) {
        applied = value;
      }
    });

    guard.invalidate();
    currentMedia = mediaB;
    response.complete('media-a subtitles');
    await pending;

    expect(applied, isNull);
    expect(guard.isCurrent(guard.capture(currentMedia), currentMedia), isTrue);
  });

  test('identity change also rejects a token before explicit reset', () {
    final guard = VideoMediaRequestGuard();
    final request = guard.capture(mediaA);

    expect(guard.isCurrent(request, mediaB), isFalse);
  });
}
