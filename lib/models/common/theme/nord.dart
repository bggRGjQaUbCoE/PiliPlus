import 'package:PiliPlus/models/common/theme/palette_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Nord 配色（Polar Night / Snow Storm + Frost/Aurora）。
///
/// Nord 本身没有独立的亮色变体，浅色按官方的 Snow Storm 背景与 Polar Night
/// 文字组合出来；accent 两套明暗共用 Frost / Aurora 九个色。
abstract final class Nord {
  static const light = PaletteOverlay(
    base: Color(0xFFECEFF4),
    mantle: Color(0xFFE5E9F0),
    crust: Color(0xFFD8DEE9),
    surface0: Color(0xFFD8DEE9),
    surface1: Color(0xFFC8D1E0),
    surface2: Color(0xFFB8C5D6),
    text: Color(0xFF2E3440),
    subtext1: Color(0xFF4C566A),
    overlay2: Color(0xFF5E81AC),
  );

  static const dark = PaletteOverlay(
    base: Color(0xFF2E3440),
    mantle: Color(0xFF292E39),
    crust: Color(0xFF242933),
    surface0: Color(0xFF3B4252),
    surface1: Color(0xFF434C5E),
    surface2: Color(0xFF4C566A),
    text: Color(0xFFECEFF4),
    subtext1: Color(0xFFD8DEE9),
    overlay2: Color(0xFF81A1C1),
  );

  static const accents = <AccentColor>[
    AccentColor.same('Frost', Color(0xFF88C0D0)),
    AccentColor.same('Ice', Color(0xFF8FBCBB)),
    AccentColor.same('Steel', Color(0xFF81A1C1)),
    AccentColor.same('Ocean', Color(0xFF5E81AC)),
    AccentColor.same('Red', Color(0xFFBF616A)),
    AccentColor.same('Orange', Color(0xFFD08770)),
    AccentColor.same('Yellow', Color(0xFFEBCB8B)),
    AccentColor.same('Green', Color(0xFFA3BE8C)),
    AccentColor.same('Purple', Color(0xFFB48EAD)),
  ];
}
