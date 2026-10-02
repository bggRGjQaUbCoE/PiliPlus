import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/models/user/danmaku_block.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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

  RuleFilter.fromRuleTypeEntries(List<List<SimpleRule>> rules) {
    dmFilterString = rules[0].map((e) => e.filter).toList();

    dmRegExp = <RegExp>[];
    for (final e in rules[1]) {
      final raw = e.filter;
      final normalized = _regExp.matchAsPrefix(raw)?.group(1) ?? raw;
      try {
        dmRegExp.add(RegExp(normalized, caseSensitive: false));
      } catch (error, stackTrace) {
        final displayFilter = _shortText(raw);
        SmartDialog.showToast('"$displayFilter"无法处理，已跳过');

        final message =
            '[DanmakuFilter] skip invalid regex: '
            'id=${e.id}, type=${e.type}, raw=$raw, normalized=$normalized, '
            'error=$error';
        logger.i(message);
        Utils.reportError(message, stackTrace);
      }
    }

    dmUid = rules[2].map((e) => e.filter).toSet();

    count = dmFilterString.length + dmRegExp.length + dmUid.length;
  }

  RuleFilter.empty();

  bool remove(DanmakuElem elem) {
    return dmUid.contains(elem.midHash) ||
        dmFilterString.any((i) => elem.content.contains(i)) ||
        dmRegExp.any((i) => i.hasMatch(elem.content));
  }

  static String _shortText(String text, [int maxLength = 40]) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
