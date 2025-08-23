import 'package:PiliPlus/utils/extension.dart';

class LikeInfoV3 {
  int? totalLikes;
  bool? clickBlock;
  bool? countBlock;
  String? guildEmoText;
  String? guildDmText;
  String? likeDmText;
  List<String>? handIcons;
  List<String>? dmIcons;
  String? eggshellsIcon;
  int? countShowTime;
  String? processIcon;
  String? processColor;
  int? reportClickLimit;
  int? reportTimeMin;
  int? reportTimeMax;
  String? icon;
  double? cooldown;
  bool? handUseFace;
  List<String>? guideIconUrls;
  double? guideIconRatio;

  LikeInfoV3({
    this.totalLikes,
    this.clickBlock,
    this.countBlock,
    this.guildEmoText,
    this.guildDmText,
    this.likeDmText,
    this.handIcons,
    this.dmIcons,
    this.eggshellsIcon,
    this.countShowTime,
    this.processIcon,
    this.processColor,
    this.reportClickLimit,
    this.reportTimeMin,
    this.reportTimeMax,
    this.icon,
    this.cooldown,
    this.handUseFace,
    this.guideIconUrls,
    this.guideIconRatio,
  });

  factory LikeInfoV3.fromJson(Map<String, dynamic> json) => LikeInfoV3(
    totalLikes: json['total_likes'] as int?,
    clickBlock: json['click_block'] as bool?,
    countBlock: json['count_block'] as bool?,
    guildEmoText: json['guild_emo_text'] as String?,
    guildDmText: json['guild_dm_text'] as String?,
    likeDmText: json['like_dm_text'] as String?,
    handIcons: (json['hand_icons'] as List?)?.fromCast(),
    dmIcons: (json['dm_icons'] as List?)?.fromCast(),
    eggshellsIcon: json['eggshells_icon'] as String?,
    countShowTime: json['count_show_time'] as int?,
    processIcon: json['process_icon'] as String?,
    processColor: json['process_color'] as String?,
    reportClickLimit: json['report_click_limit'] as int?,
    reportTimeMin: json['report_time_min'] as int?,
    reportTimeMax: json['report_time_max'] as int?,
    icon: json['icon'] as String?,
    cooldown: (json['cooldown'] as num?)?.toDouble(),
    handUseFace: json['hand_use_face'] as bool?,
    guideIconUrls: (json['guide_icon_urls'] as List?)?.fromCast(),
    guideIconRatio: (json['guide_icon_ratio'] as num?)?.toDouble(),
  );
}
