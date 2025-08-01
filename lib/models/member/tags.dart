class MemberTagItemModel {
  MemberTagItemModel({
    this.count,
    this.name,
    this.tagid,
    this.tip,
  });

  int? count;
  String? name;
  int? tagid;
  String? tip;

  MemberTagItemModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    name = json['name'];
    tagid = json['tagid'];
    tip = json['tip'];
  }
}
