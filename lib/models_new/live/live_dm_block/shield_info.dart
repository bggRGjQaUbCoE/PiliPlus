import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';

class ShieldInfo {
  List<ShieldUserList>? shieldUserList;
  List<String>? keywordList;

  ShieldInfo({
    this.shieldUserList,
    this.keywordList,
  });

  factory ShieldInfo.fromJson(Map<String, dynamic> json) => ShieldInfo(
    shieldUserList: (json['shield_user_list'] as List<dynamic>?)
        ?.map((e) => ShieldUserList.fromJson(e as Map<String, dynamic>))
        .toList(),
    keywordList: (json['keyword_list'] as List?)?.fromCast(),
  );
}
