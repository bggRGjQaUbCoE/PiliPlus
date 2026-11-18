import 'package:PiliPlus/features/watchroom/http_request.dart';
import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('native membership exit includes client authentication and signing', () {
    final source = <String, dynamic>{'room_id': 12345, 'is_com': 0};
    final request = roomHttpRequest(
      path: 'pgc/freya/room/leave',
      post: true,
      parameters: source,
      csrf: 'test-csrf',
      accessKey: 'test-client-credential',
    );
    expect(request.parameters, containsPair('room_id', 12345));
    expect(request.parameters, containsPair('is_com', 0));
    expect(
      request.parameters,
      containsPair('access_key', 'test-client-credential'),
    );
    expect(request.parameters, containsPair('platform', 'android'));
    expect(request.parameters['build'], isPositive);
    expect(request.parameters['mobi_app'], 'android');
    expect(request.parameters['appkey'], isNotEmpty);
    expect(request.parameters['ts'], matches(RegExp(r'^\d+$')));
    expect(request.parameters['sign'], matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(request.headers['user-agent'], contains('BiliDroid'));
    expect(source, {'room_id': 12345, 'is_com': 0});
  });

  test('native exit explains a missing client credential before sending', () {
    for (final credential in [null, '']) {
      expect(
        () => roomHttpRequest(
          path: 'pgc/freya/room/leave',
          post: true,
          parameters: {'room_id': 12345, 'is_com': 0},
          csrf: 'test',
          accessKey: credential,
        ),
        throwsA(isA<RoomApiException>().having((e) => e.code, 'code', -101)),
      );
    }
  });

  test('web progress and invitations retain their existing cookie flow', () {
    for (final path in [
      'pgc/freya/web/room/modify/progress',
      'pgc/view/web/freya/season',
    ]) {
      final request = roomHttpRequest(
        path: path,
        post: path.contains('/modify/'),
        parameters: {'room_id': 12345},
        csrf: 'test',
        accessKey: 'test-client-credential',
      );
      expect(request.parameters, {'room_id': 12345, 'csrf': 'test'});
      expect(request.headers['user-agent'], contains('Windows'));
    }
  });
}
