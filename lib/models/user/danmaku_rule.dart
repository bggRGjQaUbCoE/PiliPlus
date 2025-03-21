import 'package:PiliPlus/grpc/dm/v1/dm.pb.dart';

class RuleFilter {
  static final _regExp = RegExp(r'^/(.*)/$');

  List<String> dmFilterString = [];
  List<RegExp> dmRegExp = [];
  Set<String> dmUid = {};

  int count = 0;

  RuleFilter(this.dmFilterString, this.dmRegExp, this.dmUid, [int? count]) {
    this.count =
        count ?? dmFilterString.length + dmRegExp.length + dmUid.length;
  }

  RuleFilter.fromRuleTypeEntires(
      Iterable<MapEntry<int, Map<int, String>>> rules) {
    for (var rule in rules) {
      switch (rule.key) {
        case 0:
          dmFilterString.addAll(rule.value.values);
          break;
        case 1:
          dmRegExp.addAll(rule.value.values.map((i) => RegExp(
              _regExp.matchAsPrefix(i)?.group(1) ?? i,
              caseSensitive: false)));
          break;
        case 2:
          dmUid.addAll(rule.value.values);
          break;
      }
    }
    count = dmFilterString.length + dmRegExp.length + dmUid.length;
  }

  RuleFilter.empty();

  bool retain(DanmakuElem elem) {
    return !(dmUid.contains(elem.midHash) ||
        dmFilterString.any((i) => elem.content.contains(i)) ||
        dmRegExp.any((i) => i.hasMatch(elem.content)));
  }
}
