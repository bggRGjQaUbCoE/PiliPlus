import 'dart:async';

import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

class AccountService extends GetxService {
  final RxString face = ''.obs;
  final RxBool isLogin = false.obs;

  void notifyMainAccountChanged({required bool isLogin}) {
    face.value = '';
    if (this.isLogin.value == isLogin) {
      this.isLogin.refresh();
    } else {
      this.isLogin.value = isLogin;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final account = Accounts.main;
    final UserInfoData? userInfo = Pref.userInfoCache;
    final hasMatchingCache =
        account.isLogin &&
        userInfo?.mid != null &&
        userInfo!.mid == account.mid;
    isLogin.value = account.isLogin;
    if (hasMatchingCache) {
      face.value = userInfo.face ?? '';
    } else {
      face.value = '';
    }
  }
}

mixin AccountMixin on GetLifeCycleBase {
  StreamSubscription<bool>? _listener;

  AccountService get accountService => Get.find<AccountService>();

  void onChangeAccount(bool isLogin);

  @override
  void onInit() {
    super.onInit();
    _listener = accountService.isLogin.listen(onChangeAccount);
  }

  @override
  void onClose() {
    _listener?.cancel();
    _listener = null;
    super.onClose();
  }
}
