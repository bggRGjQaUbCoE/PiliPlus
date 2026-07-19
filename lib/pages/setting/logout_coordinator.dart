typedef RemoteLogout<T> = Future<Map> Function(T account);
typedef DeleteAccounts<T> = Future<void> Function(Set<T> accounts);

final class AccountLogoutResult<T> {
  final Set<T> loggedOut;
  final Map<T, String> failures;

  const AccountLogoutResult({
    required this.loggedOut,
    required this.failures,
  });
}

Future<AccountLogoutResult<T>> logoutSelectedAccounts<T>({
  required Iterable<T> selectedAccounts,
  required RemoteLogout<T> remoteLogout,
  required DeleteAccounts<T> deleteAccounts,
}) async {
  final selected = Set<T>.of(selectedAccounts);
  final outcomes = await Future.wait(
    selected.map((account) async {
      try {
        final response = await remoteLogout(account);
        return (
          account: account,
          failure: response['status'] == true
              ? null
              : _failureMessage(response),
        );
      } catch (error) {
        return (account: account, failure: error.toString());
      }
    }),
  );

  final loggedOut = <T>{};
  final failures = <T, String>{};
  for (final outcome in outcomes) {
    if (outcome.failure case final String failure) {
      failures[outcome.account] = failure;
    } else {
      loggedOut.add(outcome.account);
    }
  }

  if (loggedOut.isNotEmpty) {
    await deleteAccounts(loggedOut);
  }

  return AccountLogoutResult(
    loggedOut: Set.unmodifiable(loggedOut),
    failures: Map.unmodifiable(failures),
  );
}

String _failureMessage(Map response) {
  final message = response['msg']?.toString().trim();
  return message == null || message.isEmpty ? '远程登出失败' : message;
}
