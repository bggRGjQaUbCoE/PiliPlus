import 'package:PiliPlus/models_new/live/live_dm_block/shield_rules.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:PiliPlus/utils/extension.dart';

class ShieldInfo {
  List<ShieldUserList>? shieldUserList;
  List<String>? keywordList;
  ShieldRules? shieldRules;
  bool? isBlock;
  int? blockExpired;

  ShieldInfo({
    this.shieldUserList,
    this.keywordList,
    this.shieldRules,
    this.isBlock,
    this.blockExpired,
  });

  factory ShieldInfo.fromJson(Map<String, dynamic> json) => ShieldInfo(
    shieldUserList: (json['shield_user_list'] as List<dynamic>?)
        ?.map((e) => ShieldUserList.fromJson(e as Map<String, dynamic>))
        .toList(),
    keywordList: (json['keyword_list'] as List?)?.fromCast(),
    shieldRules: json['shield_rules'] == null
        ? null
        : ShieldRules.fromJson(json['shield_rules'] as Map<String, dynamic>),
    isBlock: json['is_block'] as bool?,
    blockExpired: json['block_expired'] as int?,
  );
}
