/// 问题外观：/x/stein/edgeinfo_v2 的 `data.edges.skin`。
class Skin {
  /// 坐标定点模式图标
  String? choiceImage;

  /// 问题标题颜色（ARGB hex，如 "d8fbffff"）
  String? titleTextColor;

  /// 问题标题阴影颜色
  String? titleShadowColor;

  /// 进度条颜色
  String? progressbarColor;

  /// 按钮普通态文字颜色
  String? choiceBtnStateNormalColor;

  /// 按钮按下态文字颜色
  String? choiceBtnStatePressColor;

  Skin({
    this.choiceImage,
    this.titleTextColor,
    this.titleShadowColor,
    this.progressbarColor,
    this.choiceBtnStateNormalColor,
    this.choiceBtnStatePressColor,
  });

  factory Skin.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return Skin();
    }
    String? str(String key) => json[key] is String ? json[key] as String : null;
    return Skin(
      choiceImage: str('choice_image'),
      titleTextColor: str('title_text_color'),
      titleShadowColor: str('title_shadow_color'),
      progressbarColor: str('progressbar_color'),
      choiceBtnStateNormalColor: str('choice_btn_state_normal_color'),
      choiceBtnStatePressColor: str('choice_btn_state_press_color'),
    );
  }

  /// "RRGGBBAA" / "AARRGGBB" hex → Color（不合法返回 null）。
  static int? argbToValue(String? hex) {
    if (hex == null) {
      return null;
    }
    String h = hex.trim();
    if (h.isEmpty) {
      return null;
    }
    if (h.startsWith('#')) {
      h = h.substring(1);
    }
    final int? v = int.tryParse(h, radix: 16);
    if (v == null) {
      return null;
    }
    if (h.length == 6) {
      // RRGGBB → 不透明
      return 0xFF000000 | v;
    }
    if (h.length == 8) {
      // 服务端样本为 RRGGBBAA（d8fbffff），但亦有 AARRGGBB 习惯；
      // 以 RRGGBBAA 为主，alpha=FF 时两种解释一致。
      final int rrggbbaa = v;
      final int alpha = rrggbbaa & 0xFF;
      final int rgb = rrggbbaa >> 8;
      if (alpha == 0 && rgb != 0) {
        // 真实数据里 "00000033" 与 "33000000" 都表示「20% 黑」：服务端两种
        // alpha 位置混用。RRGGBBAA 解释为全透明时改用 AARRGGBB 语义。
        return rrggbbaa;
      }
      return (alpha << 24) | rgb;
    }
    return null;
  }
}
