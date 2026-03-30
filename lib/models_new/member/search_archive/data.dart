import 'package:PiliPlus/models_new/member/search_archive/list.dart';
import 'package:PiliPlus/models_new/member/search_archive/page.dart';

class SearchArchiveData {
  SearchArchiveList? list;
  Page? page;

  SearchArchiveData({
    this.list,
    this.page,
  });

  factory SearchArchiveData.fromJson(Map<String, dynamic> json) =>
      SearchArchiveData(
        list: json['list'] == null
            ? null
            : SearchArchiveList.fromJson(json['list'] as Map<String, dynamic>),
        page: json['page'] == null
            ? null
            : Page.fromJson(json['page'] as Map<String, dynamic>),
      );
}
