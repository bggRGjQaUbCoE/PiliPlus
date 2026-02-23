// ignore_for_file: constant_identifier_names
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';

enum SearchType implements EnumWithLabel {
  // all('综合'),
  // 视频：video
  video('视频'),
  // 番剧：media_bangumi,
  media_bangumi('番剧'),
  // 影视：media_ft
  media_ft('影视'),
  // 直播间及主播：live
  // live,
  // 直播间：live_room
  live_room('直播间'),
  // 主播：live_user
  // live_user,
  // 话题：topic
  // topic,
  // 用户：bili_user
  bili_user('用户'),
  // 专栏：article
  article('专栏')
  ;
  // 相簿：photo
  // photo

  @override
  final String label;
  const SearchType(this.label);

  static List<SearchType> get activeValues {
    final List? indices = GStorage.setting.get(SettingBoxKey.searchTypeSort);
    if (indices == null || indices.isEmpty) {
      return values;
    }
    return indices.map((e) => values[e]).toList();
  }
}
