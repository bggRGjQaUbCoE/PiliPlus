import 'dart:convert' show jsonDecode;

typedef LoginCaptcha = ({String gt, String challenge, String? token});

bool isMissingCaptchaConfig(String response) {
  var data = response.trim();
  if (data.startsWith('(') && data.endsWith(')')) {
    data = data.substring(1, data.length - 1);
  }
  try {
    final config = jsonDecode(data);
    return config is Map &&
        config['status'] == 'error' &&
        config['error_code'] == 'error_34';
  } catch (_) {
    return false;
  }
}

LoginCaptcha? parseLoginCaptcha(Object? data) {
  if (data is! Map) return null;
  final gt = data['gee_gt'];
  final challenge = data['gee_challenge'];
  final token = data['recaptcha_token'];
  if (gt is! String ||
      gt.isEmpty ||
      challenge is! String ||
      challenge.isEmpty ||
      token is! String ||
      token.isEmpty) {
    return null;
  }
  return (gt: gt, challenge: challenge, token: token);
}

Future<LoginCaptcha?> resolveLoginCaptcha(
  LoginCaptcha current, {
  required Future<bool> Function(String gt) isUnavailable,
  required Future<LoginCaptcha?> Function() refresh,
}) async {
  if (!await isUnavailable(current.gt)) return current;

  // A gt belongs to its challenge/token. Refresh the entire registration once.
  final updated = await refresh();
  if (updated == null || await isUnavailable(updated.gt)) return null;
  return updated;
}
