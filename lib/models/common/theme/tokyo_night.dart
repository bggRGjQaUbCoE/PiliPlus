import 'package:PiliPlus/models/common/theme/palette_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Tokyo Night 配色（Night / Day）。
///
/// 深色取 Night，浅色取 Day；次级中性色在 Day 调色板没有官方值时做了
/// 少量推导，保证 surface 层次仍然单调。
abstract final class TokyoNight {
  static const day = PaletteOverlay(
    base: Color(0xFFE1E2E7),
    mantle: Color(0xFFD0D5E3),
    crust: Color(0xFFC4C8DA),
    surface0: Color(0xFFC4C8DA),
    surface1: Color(0xFFB7B9CC),
    surface2: Color(0xFFA8ABC3),
    text: Color(0xFF3760BF),
    subtext1: Color(0xFF6172B0),
    overlay2: Color(0xFF5C6DA8),
  );

  static const night = PaletteOverlay(
    base: Color(0xFF1A1B26),
    mantle: Color(0xFF16161E),
    crust: Color(0xFF0C0E14),
    surface0: Color(0xFF292E42),
    surface1: Color(0xFF414868),
    surface2: Color(0xFF545C7E),
    text: Color(0xFFC0CAF5),
    subtext1: Color(0xFFA9B1D6),
    overlay2: Color(0xFF737AA2),
  );

  static const accents = <AccentColor>[
    AccentColor('Blue', light: Color(0xFF2E7DE9), dark: Color(0xFF7AA2F7)),
    AccentColor('Cyan', light: Color(0xFF007197), dark: Color(0xFF7DCFFF)),
    AccentColor('Teal', light: Color(0xFF118C74), dark: Color(0xFF1ABC9C)),
    AccentColor('Green', light: Color(0xFF587539), dark: Color(0xFF9ECE6A)),
    AccentColor('Yellow', light: Color(0xFF8C6C3E), dark: Color(0xFFE0AF68)),
    AccentColor('Orange', light: Color(0xFFB15C00), dark: Color(0xFFFF9E64)),
    AccentColor('Red', light: Color(0xFFF52A65), dark: Color(0xFFF7768E)),
    AccentColor('Magenta', light: Color(0xFF9854F1), dark: Color(0xFFBB9AF7)),
    AccentColor('Purple', light: Color(0xFF7847BD), dark: Color(0xFF9D7CD8)),
  ];
}
