class PgcConditionValue {
  String? keyword;
  String? name;

  PgcConditionValue({this.keyword, this.name});

  PgcConditionValue.fromJson(Map json) {
    keyword = json['keyword'];
    name = json['name'];
  }
}
