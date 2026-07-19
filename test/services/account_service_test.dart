import 'package:PiliPlus/services/account_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'account identity change notifies listeners when login state is same',
    () {
      final service = AccountService()
        ..face.value = 'old-face'
        ..isLogin.value = true;
      final states = <bool>[];
      final subscription = service.isLogin.listen(states.add);

      service.notifyMainAccountChanged(isLogin: true);

      expect(service.face.value, isEmpty);
      expect(states, [true]);
      subscription.cancel();
    },
  );
}
