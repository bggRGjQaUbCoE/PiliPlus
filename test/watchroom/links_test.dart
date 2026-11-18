import 'dart:io';

import 'package:PiliPlus/features/watchroom/links.dart';
import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shared invitations use the official mobile entry and preserve signed fields', () {
    final invite = RoomInvite.parse(
      'https://www.bilibili.com/watchroom/12345?wepid=91&seasonid=90&invitemid=7&token=test-invitation&room_mode=2',
    );
    final mobile = invite.mobileUri;
    expect(mobile.host, 'm.bilibili.com');
    expect(mobile.path, '/bangumi/theatre/invite');
    expect(mobile.queryParameters['roomid'], '12345');
    expect(mobile.queryParameters['epid'], '91');
    expect(mobile.queryParameters['room_mode'], '2');
    final roundTrip = RoomInvite.parse(mobile.toString());
    expect(roundTrip.inviter, '7');
    expect(roundTrip.token, 'test-invitation');
    expect(roundTrip.roomMode, 2);
  });

  const mobile =
      'https://m.bilibili.com/bangumi/theatre/invite?epid=91&from_page=&invitemid=7&room_mode=0&roomid=12345&seasonid=90&share_source=COPY&token=test-invitation';
  const desktop =
      'https://www.bilibili.com/watchroom/12345?wepid=91&roomid=12345&seasonid=90&invitemid=7&token=test-invitation';

  test(
    'official mobile, desktop and copied share text retain the invitation',
    () async {
      final resolver = RoomLinkResolver(
        loadRedirect: (_) async {
          fail('A complete invitation must not need a browser request.');
        },
      );
      for (final text in [
        mobile,
        desktop,
        '[一起看]($mobile)',
        '朋友邀请你一起看：$mobile。',
        mobile.replaceAll('&', r'\&'),
        mobile.replaceAll('&', '&amp;'),
      ]) {
        final invite = await resolver.resolve(text);
        expect(invite.roomId, 12345);
        expect(invite.episodeId, 91);
        expect(invite.seasonId, 90);
        expect(invite.inviter, '7');
        expect(invite.token, 'test-invitation');
        expect(RoomInvite.parse(invite.uri.toString()).token, invite.token);
      }
    },
  );

  test(
    'b23 redirects resolve to native invitations without losing access fields',
    () async {
      final requests = <Uri>[];
      final resolver = RoomLinkResolver(
        loadRedirect: (uri) async {
          requests.add(uri);
          return Uri.parse(mobile);
        },
      );
      final invite = await resolver.resolve('一起来看 https://b23.tv/test-share');
      expect(requests.single.host, 'b23.tv');
      expect(invite.roomId, 12345);
      expect(invite.inviter, '7');
      expect(invite.token, 'test-invitation');
    },
  );

  test('relative and multiple official redirects are followed', () async {
    final requests = <String>[];
    final resolver = RoomLinkResolver(
      loadRedirect: (uri) async {
        requests.add(uri.path);
        return requests.length == 1
            ? Uri.parse('/second-hop')
            : Uri.parse(desktop);
      },
    );
    expect((await resolver.resolve('https://b23.tv/first-hop')).roomId, 12345);
    expect(requests, ['/first-hop', '/second-hop']);
  });

  test(
    'unrelated URLs and misleading hosts never become room invitations',
    () async {
      var requests = 0;
      final resolver = RoomLinkResolver(
        loadRedirect: (_) async {
          requests++;
          return Uri.parse('https://unrelated.example/watchroom/12345');
        },
      );
      for (final text in [
        'https://b23.tv.evil.example/test',
        'https://www.bilibili.com/video/BV12345',
        'https://user:password@b23.tv/test',
        'https://b23.tv:1234/test',
      ]) {
        await expectLater(resolver.resolve(text), throwsFormatException);
      }
      expect(requests, 0);
      await expectLater(
        resolver.resolve('https://b23.tv/test'),
        throwsFormatException,
      );
      expect(requests, 1);
    },
  );

  test(
    'loops, expired shares and ordinary video short links explain failure',
    () async {
      for (final target in [
        Uri.parse('/test'),
        Uri.parse('https://www.bilibili.com/video/BV12345'),
        null,
      ]) {
        final resolver = RoomLinkResolver(loadRedirect: (_) async => target);
        await expectLater(
          resolver.resolve('https://b23.tv/test'),
          throwsFormatException,
        );
      }
    },
  );

  test('network errors never expose the original share link', () async {
    final resolver = RoomLinkResolver(
      loadRedirect: (_) async {
        throw const SocketException('private request details');
      },
    );
    await expectLater(
      resolver.resolve('https://b23.tv/test'),
      throwsA(
        isA<RoomApiException>().having(
          (error) => error.message,
          'message',
          '短链接解析失败，请检查网络后重试',
        ),
      ),
    );
  });
}
