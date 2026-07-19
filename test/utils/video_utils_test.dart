import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('media URL diagnostics omit credentials, queries, and fragments', () {
    const url =
        'https://user:password@cdn.example.com:8443/video/file.m4s'
        '?deadline=123&upsig=replayable-secret#fragment-secret';

    final diagnostic = mediaUrlForDiagnostics(url);

    expect(diagnostic, 'https://cdn.example.com:8443/video/file.m4s');
    expect(diagnostic, isNot(contains('password')));
    expect(diagnostic, isNot(contains('upsig')));
    expect(diagnostic, isNot(contains('fragment-secret')));
  });
}
