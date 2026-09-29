// ignore_for_file: constant_identifier_names
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SearchType implements EnumWithLabel {
  all(api: Api.searchAll),
  // 视频：video
  video,
  // 番剧：media_bangumi,
  media_bangumi,
  // 影视：media_ft
  media_ft,
  // 直播间及主播：live
  // live,
  // 直播间：live_room
  live_room,
  // 主播：live_user
  // live_user,
  // 话题：topic
  // topic,
  // 用户：bili_user
  bili_user,
  // 专栏：article
  article,
  ;

  // 相簿：photo
  // photo

  @override
  String get label => switch (this) {
    all => L10n.current.searchTypeAllLabel,
    video => L10n.current.video,
    media_bangumi => L10n.current.bangumi,
    media_ft => L10n.current.cinema,
    live_room => L10n.current.liveRoom,
    bili_user => L10n.current.user,
    article => L10n.current.article,
  };
  final String api;
  const SearchType({this.api = Api.searchByType});
}
