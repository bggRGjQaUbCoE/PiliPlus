import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoUtils custom CDN', () {
    test('normalizes a custom CDN URL to its host', () {
      expect(
        VideoUtils.normalizeCustomCDNHost('https://example.cdn.test/path?a=1'),
        'example.cdn.test',
      );
      expect(VideoUtils.normalizeCustomCDNHost(' example.cdn.test/ '), null);
      expect(VideoUtils.normalizeCustomCDNHost(''), null);
    });

    test('replaces known video CDN hosts with custom host', () {
      final result = VideoUtils.getCdnUrl(
        [
          'https://upos-sz-mirrorali.bilivideo.com/upgcxcode/12/34/video.m4s?e=1',
        ],
        defaultCDNService: CDNService.ali,
        customCDNUrl: 'custom.cdn.test',
      );

      expect(
        result,
        'https://custom.cdn.test/upgcxcode/12/34/video.m4s?e=1',
      );
    });

    test('does not replace API-like hosts', () {
      final result = VideoUtils.getCdnUrl(
        [
          'https://api.bilibili.com/x/player/playurl?cid=1',
          'https://upos-sz-mirrorali.bilivideo.com/upgcxcode/12/34/video.m4s',
        ],
        defaultCDNService: CDNService.ali,
        customCDNUrl: 'custom.cdn.test',
      );

      expect(
        result,
        'https://custom.cdn.test/upgcxcode/12/34/video.m4s',
      );
    });
  });
}
