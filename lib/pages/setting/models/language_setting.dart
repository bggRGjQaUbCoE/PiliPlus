import 'package:PiliPlus/l10n/app_language.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';

NormalModel get languageSetting => NormalModel(
  leading: const Icon(Icons.language),
  getTitle: () => L10n.current.languageTitle,
  getSubtitle: () => L10n.current.languagePreferenceSummary(
    L10n.languageLabel(Pref.appLanguage),
  ),
  onTap: (context, setState) async {
    final selected = await showDialog<AppLanguage>(
      context: context,
      builder: (context) => SelectDialog<AppLanguage>(
        title: L10n.current.languageTitle,
        value: Pref.appLanguage,
        values: [
          for (final language in AppLanguage.values)
            (language, L10n.languageLabel(language)),
        ],
      ),
    );
    if (selected == null || selected == Pref.appLanguage) return;
    await GStorage.setting.put(SettingBoxKey.appLanguage, selected.code);
    await L10n.changeLanguage(
      selected,
      WidgetsBinding.instance.platformDispatcher.locales,
    );
    if (context.mounted) setState();
  },
);
