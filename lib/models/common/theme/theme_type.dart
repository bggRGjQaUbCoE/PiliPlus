import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum ThemeType {
  light('浅色'),
  dark('深色'),
  system('跟随系统'),
  ;

  final String desc;
  const ThemeType(this.desc);

  ThemeMode get toThemeMode => switch (this) {
    .light => ThemeMode.light,
    .dark => ThemeMode.dark,
    .system => ThemeMode.system,
  };

  Icon get icon => switch (this) {
    .light => const Icon(MdiIcons.weatherSunny),
    .dark => const Icon(MdiIcons.weatherNight),
    .system => const Icon(MdiIcons.themeLightDark),
  };
}
