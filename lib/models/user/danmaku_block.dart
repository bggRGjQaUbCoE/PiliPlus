class DanmakuBlockDataModel {
  List<SimpleRule>? rule;
  String? toast;
  int? valid;
  int? ver;

  DanmakuBlockDataModel({this.rule, this.toast, this.valid, this.ver});

  DanmakuBlockDataModel.fromJson(Map<String, dynamic> json) {
    rule = (json['rule'] as List?)?.map((v) => SimpleRule.fromJson(v)).toList();
    toast = json['toast'];
    valid = json['valid'];
    ver = json['ver'];
  }
}

class SimpleRule {
  late final int id;
  late final int type;
  late String filter;
  SimpleRule(this.id, this.type, this.filter);

  SimpleRule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    filter = json['filter'];
  }
}
