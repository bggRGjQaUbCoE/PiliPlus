import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime _at(int seconds) =>
    DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

void main() {
  group('VideoUtils.getPlayUrlDeadline', () {
    test('reads deadline from an upos URL', () {
      expect(
        VideoUtils.getPlayUrlDeadline([
          'https://upos-sz-mirrorcos.bilivideo.com/upgcxcode/01/video.m4s'
              '?e=ig8euxZM&uipk=5&nbs=1&deadline=1793379336&gen=playurlv3',
        ]),
        _at(1793379336),
      );
    });

    test('returns the earliest deadline of video and audio', () {
      expect(
        VideoUtils.getPlayUrlDeadline([
          'https://a.bilivideo.com/video.m4s?deadline=1793379400',
          'https://a.bilivideo.com/audio.m4s?deadline=1793379336',
        ]),
        _at(1793379336),
      );
    });

    test('reads deadlines embedded in an edl string', () {
      const video = 'https://a.bilivideo.com/video.m4s?deadline=1793379400';
      const audio = 'https://a.bilivideo.com/audio.m4s?deadline=1793379336';
      expect(
        VideoUtils.getPlayUrlDeadline([
          'edl://!no_chapters;%${video.length}%$video;'
              '!new_stream;!no_chapters;%${audio.length}%$audio',
        ]),
        _at(1793379336),
      );
    });

    test('reads percent-encoded deadline of a proxied mcdn URL', () {
      expect(
        VideoUtils.getPlayUrlDeadline([
          'https://proxy-tf-all-ws.bilivideo.com/?url=https%3A%2F%2Fx.mcdn'
              '.bilivideo.cn%3A4483%2Fv1%2Fresource%2Fvideo.m4s%3Fdeadline'
              '%3D1793379336%26gen%3Dplayurlv3',
        ]),
        _at(1793379336),
      );
    });

    test('reads exp inside an Akamai hdnts token', () {
      expect(
        VideoUtils.getPlayUrlDeadline([
          'https://upos-hz-mirrorakam.akamaized.net/upgcxcode/01/video.m4s'
              '?os=akam&hdnts=exp%3D1793379336~hmac%3Dabc',
        ]),
        _at(1793379336),
      );
    });

    test('ignores empty sources and URLs without expiry', () {
      expect(
        VideoUtils.getPlayUrlDeadline([
          null,
          '',
          'https://example.mcdn.bilivideo.cn:4483/v1/resource/video.m4s',
        ]),
        isNull,
      );
    });

    test('does not match parameters that merely end with exp', () {
      expect(
        VideoUtils.getPlayUrlDeadline([
          'https://a.bilivideo.com/video.m4s?myexp=1793379336',
        ]),
        isNull,
      );
    });
  });
}
