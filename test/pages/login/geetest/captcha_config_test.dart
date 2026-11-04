import 'package:PiliPlus/models/login/captcha_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const original = (
    gt: 'old-gt',
    challenge: 'old-challenge',
    token: 'old-token',
  );
  const updated = (
    gt: 'new-gt',
    challenge: 'new-challenge',
    token: 'new-token',
  );

  test(
    'recognizes error_34 in JSON and the gettype parenthesized response',
    () {
      const error = '{"status":"error","error_code":"error_34"}';
      expect(isMissingCaptchaConfig(error), isTrue);
      expect(isMissingCaptchaConfig(' ($error) '), isTrue);
    },
  );

  test(
    'does not refresh for success, other errors, or malformed responses',
    () {
      for (final response in [
        '{"status":"success","data":{"type":"fullpage"}}',
        '{"status":"error","error_code":"error_21"}',
        '{"status":"success","error_code":"error_34"}',
        'null',
        '<html>Network error</html>',
      ]) {
        expect(isMissingCaptchaConfig(response), isFalse);
      }
    },
  );

  test('requires a complete fresh registration', () {
    final data = {
      'gee_gt': updated.gt,
      'gee_challenge': updated.challenge,
      'recaptcha_token': updated.token,
    };
    expect(parseLoginCaptcha(data), updated);
    expect(parseLoginCaptcha(null), isNull);
    for (final key in data.keys) {
      expect(parseLoginCaptcha({...data}..remove(key)), isNull);
      expect(parseLoginCaptcha({...data, key: ''}), isNull);
      expect(parseLoginCaptcha({...data, key: 1}), isNull);
    }
  });

  test('preserves a usable registration without refreshing', () async {
    final result = await resolveLoginCaptcha(
      original,
      isUnavailable: (_) async => false,
      refresh: () => throw StateError('Must not refresh a usable registration'),
    );
    expect(result, original);
  });

  test('refreshes gt, challenge, and token together after error_34', () async {
    var refreshCount = 0;
    final checked = <String>[];
    final result = await resolveLoginCaptcha(
      original,
      isUnavailable: (gt) async {
        checked.add(gt);
        return gt == original.gt;
      },
      refresh: () async {
        refreshCount++;
        return updated;
      },
    );
    expect(result, updated);
    expect(checked, [original.gt, updated.gt]);
    expect(refreshCount, 1);
  });

  test(
    'stops after one refresh when the fresh gt is still unavailable',
    () async {
      var refreshCount = 0;
      var checkCount = 0;
      final result = await resolveLoginCaptcha(
        original,
        isUnavailable: (_) async {
          checkCount++;
          return true;
        },
        refresh: () async {
          refreshCount++;
          return updated;
        },
      );
      expect(result, isNull);
      expect(refreshCount, 1);
      expect(checkCount, 2);
    },
  );

  test('does not reuse the old registration when refresh fails', () async {
    final checked = <String>[];
    final result = await resolveLoginCaptcha(
      original,
      isUnavailable: (gt) async {
        checked.add(gt);
        return true;
      },
      refresh: () async => null,
    );
    expect(result, isNull);
    expect(checked, [original.gt]);
  });
}
