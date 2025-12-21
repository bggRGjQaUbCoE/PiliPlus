class SearchSuggestModel {
  SearchSuggestModel({this.tag});

  List<SearchSuggestItem>? tag;

  SearchSuggestModel.fromJson(Map<String, dynamic> json) {
    tag = (json['tag'] as List?)
        ?.map<SearchSuggestItem>((e) => SearchSuggestItem.fromJson(e))
        .toList();
  }
}

class SearchSuggestItem {
  String? term;
  late String textRich;

  SearchSuggestItem.fromJson(Map<String, dynamic> json) {
    term = json['term'];
    textRich = json['name'];
  }
}
