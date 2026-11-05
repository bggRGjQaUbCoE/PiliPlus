import 'package:PiliPlus/models/common/theme/palette_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Catppuccin 官方色值。
///
/// 浅色统一使用 Latte；深色按风味分别取 Macchiato / Mocha / Frappé。
/// 三个风味共用同一套 accent 名称与 Latte 色值，只有深色列不同。
abstract final class Catppuccin {
  static const latte = PaletteOverlay(
    base: Color(0xFFEFF1F5),
    mantle: Color(0xFFE6E9EF),
    crust: Color(0xFFDCE0E8),
    surface0: Color(0xFFCCD0DA),
    surface1: Color(0xFFBCC0CC),
    surface2: Color(0xFFACB0BE),
    text: Color(0xFF4C4F69),
    subtext1: Color(0xFF5C5F77),
    overlay2: Color(0xFF7C7F93),
  );

  static const macchiato = PaletteOverlay(
    base: Color(0xFF24273A),
    mantle: Color(0xFF1E2030),
    crust: Color(0xFF181926),
    surface0: Color(0xFF363A4F),
    surface1: Color(0xFF494D64),
    surface2: Color(0xFF5B6078),
    text: Color(0xFFCAD3F5),
    subtext1: Color(0xFFB8C0E0),
    overlay2: Color(0xFF939AB7),
  );

  static const mocha = PaletteOverlay(
    base: Color(0xFF1E1E2E),
    mantle: Color(0xFF181825),
    crust: Color(0xFF11111B),
    surface0: Color(0xFF313244),
    surface1: Color(0xFF45475A),
    surface2: Color(0xFF585B70),
    text: Color(0xFFCDD6F4),
    subtext1: Color(0xFFBAC2DE),
    overlay2: Color(0xFF9399B2),
  );

  static const frappe = PaletteOverlay(
    base: Color(0xFF303446),
    mantle: Color(0xFF292C3C),
    crust: Color(0xFF232634),
    surface0: Color(0xFF414559),
    surface1: Color(0xFF51576D),
    surface2: Color(0xFF626880),
    text: Color(0xFFC6D0F5),
    subtext1: Color(0xFFB5BFE2),
    overlay2: Color(0xFF949CBB),
  );

  static const _labels = <String>[
    'Rosewater',
    'Flamingo',
    'Pink',
    'Mauve',
    'Red',
    'Maroon',
    'Peach',
    'Yellow',
    'Green',
    'Teal',
    'Sky',
    'Sapphire',
    'Blue',
    'Lavender',
  ];

  /// 浅色（Latte）的 accent 色值，三个风味共用。
  static const _latteAccents = <Color>[
    Color(0xFFDC8A78),
    Color(0xFFDD7878),
    Color(0xFFEA76CB),
    Color(0xFF8839EF),
    Color(0xFFD20F39),
    Color(0xFFE64553),
    Color(0xFFFE640B),
    Color(0xFFDF8E1D),
    Color(0xFF40A02B),
    Color(0xFF179299),
    Color(0xFF04A5E5),
    Color(0xFF209FB5),
    Color(0xFF1E66F5),
    Color(0xFF7287FD),
  ];

  static const _macchiatoAccents = <Color>[
    Color(0xFFF4DBD6),
    Color(0xFFF0C6C6),
    Color(0xFFF5BDE6),
    Color(0xFFC6A0F6),
    Color(0xFFED8796),
    Color(0xFFEE99A0),
    Color(0xFFF5A97F),
    Color(0xFFEED49F),
    Color(0xFFA6DA95),
    Color(0xFF8BD5CA),
    Color(0xFF91D7E3),
    Color(0xFF7DC4E4),
    Color(0xFF8AADF4),
    Color(0xFFB7BDF8),
  ];

  static const _mochaAccents = <Color>[
    Color(0xFFF5E0DC),
    Color(0xFFF2CDCD),
    Color(0xFFF5C2E7),
    Color(0xFFCBA6F7),
    Color(0xFFF38BA8),
    Color(0xFFEBA0AC),
    Color(0xFFFAB387),
    Color(0xFFF9E2AF),
    Color(0xFFA6E3A1),
    Color(0xFF94E2D5),
    Color(0xFF89DCEB),
    Color(0xFF74C7EC),
    Color(0xFF89B4FA),
    Color(0xFFB4BEFE),
  ];

  static const _frappeAccents = <Color>[
    Color(0xFFF2D5CF),
    Color(0xFFEEBEBE),
    Color(0xFFF4B8E4),
    Color(0xFFCA9EE6),
    Color(0xFFE78284),
    Color(0xFFEA999C),
    Color(0xFFEF9F76),
    Color(0xFFE5C890),
    Color(0xFFA6D189),
    Color(0xFF81C8BE),
    Color(0xFF99D1DB),
    Color(0xFF85C1DC),
    Color(0xFF8CAAEE),
    Color(0xFFBABBF1),
  ];

  /// 用 Latte 的浅色值 + 指定风味的深色值拼出 accent 列表。
  static List<AccentColor> accentsOf(List<Color> dark) => [
    for (var i = 0; i < _labels.length; i++)
      AccentColor(_labels[i], light: _latteAccents[i], dark: dark[i]),
  ];

  static final macchiatoAccents = accentsOf(_macchiatoAccents);

  static final mochaAccents = accentsOf(_mochaAccents);

  static final frappeAccents = accentsOf(_frappeAccents);
}
