import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

enum ThemeType implements EnumWithLabel {
  light,
  dark,
  system,
  ;

  @override
  String get label => switch (this) {
    light => L10n.current.themeTypeLightLabel,
    dark => L10n.current.themeTypeDarkLabel,
    system => L10n.current.languageSystem,
  };

  ThemeMode get toThemeMode => switch (this) {
    ThemeType.light => ThemeMode.light,
    ThemeType.dark => ThemeMode.dark,
    ThemeType.system => ThemeMode.system,
  };

  Icon get icon => switch (this) {
    ThemeType.light => const Icon(MdiIcons.weatherSunny),
    ThemeType.dark => const Icon(MdiIcons.weatherNight),
    ThemeType.system => const Icon(MdiIcons.themeLightDark),
  };
}
