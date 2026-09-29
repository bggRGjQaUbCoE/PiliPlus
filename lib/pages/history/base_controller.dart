import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class HistoryBaseController extends GetxController {
  RxBool pauseStatus = false.obs;

  RxBool enableMultiSelect = false.obs;
  RxInt checkedCount = 0.obs;

  final account = Accounts.history;

  // 清空观看历史
  void onClearHistory(BuildContext context, VoidCallback onSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.current.notice),
        content: Text(L10n.current.historyBaseControllerOnClearHistoryContent),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              L10n.current.cancel,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              SmartDialog.showLoading(
                msg: L10n
                    .current
                    .pagesCommonCommonIntroControllerActionFavVideoMsg,
              );
              final res = await UserHttp.clearHistory(account: account);
              SmartDialog.dismiss();
              if (res.isSuccess) {
                SmartDialog.showToast(
                  L10n.current.historyBaseControllerOnClearHistoryOnPressed,
                );
                onSuccess();
              } else {
                res.toast();
              }
            },
            child: Text(L10n.current.historyBaseControllerOnClearHistoryChild),
          ),
        ],
      ),
    );
  }

  // 暂停观看历史
  void onPauseHistory(BuildContext context) {
    final pauseStatus = !this.pauseStatus.value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.current.notice),
        content: Text(
          pauseStatus
              ? L10n.current.historyBaseControllerOnPauseHistoryContent2
              : L10n.current.historyBaseControllerOnPauseHistoryContent,
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              L10n.current.cancel,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () async {
              SmartDialog.showLoading(
                msg: L10n
                    .current
                    .pagesCommonCommonIntroControllerActionFavVideoMsg,
              );
              final res = await UserHttp.pauseHistory(
                pauseStatus,
                account: account,
              );
              SmartDialog.dismiss();
              if (res.isSuccess) {
                SmartDialog.showToast(
                  pauseStatus
                      ? L10n
                            .current
                            .historyBaseControllerOnPauseHistoryOnPressed
                      : L10n
                            .current
                            .historyBaseControllerOnPauseHistoryOnPressed2,
                );
                this.pauseStatus.value = pauseStatus;
                GStorage.localCache.put(
                  LocalCacheKey.historyPause,
                  pauseStatus,
                );
              } else {
                res.toast();
              }
              Get.back();
            },
            child: Text(
              pauseStatus
                  ? L10n.current.historyBaseControllerOnPauseHistoryChild
                  : L10n.current.historyBaseControllerOnPauseHistoryChild2,
            ),
          ),
        ],
      ),
    );
  }
}
