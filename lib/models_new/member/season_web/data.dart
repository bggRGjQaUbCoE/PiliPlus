import 'package:PiliPlus/models_new/member/season_web/archive.dart';
import 'package:PiliPlus/models_new/member/season_web/page.dart';

class SeasonWebData {
  List<SeasonArchive>? archives;
  Page? page;

  SeasonWebData({this.archives, this.page});

  factory SeasonWebData.fromJson(Map<String, dynamic> json) => SeasonWebData(
    archives: (json['archives'] as List<dynamic>?)
        ?.map((e) => SeasonArchive.fromJson(e as Map<String, dynamic>))
        .toList(),
    page: json['page'] == null
        ? null
        : Page.fromJson(json['page'] as Map<String, dynamic>),
  );
}
