import 'package:PiliPlus/pages/setting/logout_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('logoutSelectedAccounts', () {
    test(
      'logs out every selected account and deletes only successes',
      () async {
        final remoteCalls = <String>[];
        Set<String>? deleted;

        final result = await logoutSelectedAccounts(
          selectedAccounts: const {'account-a', 'account-b', 'account-c'},
          remoteLogout: (account) async {
            remoteCalls.add(account);
            return account == 'account-b'
                ? {'status': false, 'msg': 'session rejected'}
                : {'status': true, 'msg': 'ok'};
          },
          deleteAccounts: (accounts) async => deleted = accounts,
        );

        expect(
          remoteCalls,
          unorderedEquals(const ['account-a', 'account-b', 'account-c']),
        );
        expect(deleted, const {'account-a', 'account-c'});
        expect(result.loggedOut, const {'account-a', 'account-c'});
        expect(result.failures, const {'account-b': 'session rejected'});
      },
    );

    test('preserves an account when its remote request throws', () async {
      Set<String>? deleted;

      final result = await logoutSelectedAccounts(
        selectedAccounts: const {'account-a', 'account-b'},
        remoteLogout: (account) async {
          if (account == 'account-b') throw StateError('offline');
          return {'status': true};
        },
        deleteAccounts: (accounts) async => deleted = accounts,
      );

      expect(deleted, const {'account-a'});
      expect(result.loggedOut, const {'account-a'});
      expect(result.failures['account-b'], contains('offline'));
    });

    test('does not delete locally when every remote logout fails', () async {
      var deleteCalls = 0;

      final result = await logoutSelectedAccounts(
        selectedAccounts: const {'account-a', 'account-b'},
        remoteLogout: (account) async => {'status': false, 'msg': 'denied'},
        deleteAccounts: (accounts) async => deleteCalls++,
      );

      expect(deleteCalls, 0);
      expect(result.loggedOut, isEmpty);
      expect(result.failures.keys, const {'account-a', 'account-b'});
    });
  });
}
