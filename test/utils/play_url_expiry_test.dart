import 'package:PiliPlus/utils/play_url_expiry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayUrlExpiry', () {
    test('reads deadline query parameter', () {
      const url =
          'https://example.com/video.m4s?foo=bar&deadline=1700000000&baz=1';
      expect(PlayUrlExpiry.deadlines(url), [1700000000]);
    });

    test('reads Akamai hdnts expiry', () {
      const url =
          'https://example.com/video.m4s?hdnts=exp=1700000000~hmac=deadbeef';
      expect(PlayUrlExpiry.deadlines(url), [1700000000]);
    });

    test('reads tilde expiry', () {
      const url = 'https://example.com/video.m4s?token=1~exp=1700000000~hmac=x';
      expect(PlayUrlExpiry.deadlines(url), [1700000000]);
    });

    test('reads percent-encoded deadlines', () {
      const url = 'https://example.com/?x=1%26deadline%3D1700000000%26y%3D2';
      expect(PlayUrlExpiry.deadlines(url), [1700000000]);
    });

    test('reads deadlines from an edl string', () {
      const url =
          'edl://!no_chapters;%10%https://a/video.m4s?deadline=1700000003;'
          '!new_stream;!no_chapters;%10%https://b/audio.m4s?deadline=1700000001';
      expect(PlayUrlExpiry.earliestDeadline([url]), 1700000001);
    });

    test('reads the last parameter of an EDL segment with length', () {
      const video = 'https://a/video?deadline=1700000000';
      const edl = 'edl://!no_chapters;%35%$video,length=5.0;';
      expect(PlayUrlExpiry.earliestDeadline([edl]), 1700000000);
    });

    test('reads live expires and hexadecimal wsTime', () {
      const url = 'https://example.com/live?expires=1700000000&wsTime=6553f101';
      expect(PlayUrlExpiry.earliestDeadline([url]), 1700000000);
      expect(
        PlayUrlExpiry.deadlines('https://example.com/live?wsTime=6553f100'),
        [1700000000],
      );
    });

    test('ignores missing or invalid expiry', () {
      expect(PlayUrlExpiry.deadlines(null), isEmpty);
      expect(PlayUrlExpiry.deadlines('https://example.com/video.m4s'), isEmpty);
      expect(
        PlayUrlExpiry.deadlines('https://example.com/video.m4s?deadline=nope'),
        isEmpty,
      );
      expect(PlayUrlExpiry.earliestExpiry(const <String?>[]), isNull);
      expect(
        PlayUrlExpiry.earliestExpiry([
          'https://example.com/video?deadline=8640000000001',
        ]),
        isNull,
      );
    });

    test('compares against the supplied clock and margin', () {
      const url = 'https://example.com/video.m4s?deadline=1700000000';
      final expiry = DateTime.fromMillisecondsSinceEpoch(
        1700000000 * 1000,
        isUtc: true,
      );

      expect(
        PlayUrlExpiry.isExpiredOrNear([
          url,
        ], now: expiry.subtract(const Duration(minutes: 5))),
        isFalse,
      );
      expect(
        PlayUrlExpiry.isExpiredOrNear([
          url,
        ], now: expiry.subtract(const Duration(seconds: 30))),
        isTrue,
      );
      expect(PlayUrlExpiry.isExpiredOrNear([url], now: expiry), isTrue);
      expect(
        PlayUrlExpiry.isExpiredOrNear(
          [url],
          margin: Duration.zero,
          now: expiry.subtract(const Duration(seconds: 1)),
        ),
        isFalse,
      );
    });
  });
}
