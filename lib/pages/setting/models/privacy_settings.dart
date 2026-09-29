import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/api_type.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get privacySettings => [
  NormalModel(
    onTap: (context, setState) {
      if (!Accounts.main.isLogin) {
        SmartDialog.showToast(
          L10n.current.pagesSettingModelsPrivacySettingsPrivacySettingsOnTap,
        );
        return;
      }
      Get.toNamed('/blackListPage');
    },
    title: L10n.current.followPageBuildAppBarChildren,
    subtitle:
        L10n.current.pagesSettingModelsPrivacySettingsPrivacySettingsSubtitle,
    leading: const Icon(Icons.block),
  ),
  NormalModel(
    onTap: (context, setState) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            L10n.current.pagesSettingModelsPrivacySettingsPrivacySettingsTitle,
          ),
          content: SelectionArea(
            child: SingleChildScrollView(
              child: _getAccountDetail(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(L10n.current.confirm),
            ),
          ],
        ),
      );
    },
    leading: const Icon(Icons.flag_outlined),
    title: L10n.current.pagesSettingModelsPrivacySettingsPrivacySettingsTitle2,
    subtitle:
        L10n.current.pagesSettingModelsPrivacySettingsPrivacySettingsSubtitle2,
  ),
];

Widget _getAccountDetail(BuildContext context) {
  final children = <Widget>[];
  final theme = TextTheme.of(context);
  for (final i in AccountType.values) {
    final url = ApiType.apiTypeSet[i];
    if (url == null) continue;

    children
      ..add(Center(child: Text(i.title, style: theme.titleMedium)))
      ..add(Text(url.join('\n')));
  }
  return Column(
    spacing: 8,
    mainAxisSize: .min,
    crossAxisAlignment: .start,
    children: children,
  );
}
