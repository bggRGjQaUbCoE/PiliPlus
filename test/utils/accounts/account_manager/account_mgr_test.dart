import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('diagnostic request URLs omit credentials and query values', () {
    const secrets = <String>[
      'user-name',
      'password-value',
      'access-key-value',
      'csrf-value',
      'auth-code-value',
      'fragment-token-value',
    ];
    final options = RequestOptions(
      path:
          'https://user-name:password-value@api.example.com:8443/v1/items'
          '#fragment-token-value',
      queryParameters: const {
        'access_key': 'access-key-value',
        'csrf': 'csrf-value',
        'auth_code': 'auth-code-value',
        'page': 2,
      },
    );

    final result = requestUrlForDiagnostics(options);

    expect(result, 'https://api.example.com:8443/v1/items');
    for (final secret in secrets) {
      expect(result, isNot(contains(secret)));
    }
  });
}
