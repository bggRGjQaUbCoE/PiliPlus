import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/models/model_rec_video_item.dart';

import 'shielding_matcher.dart';
import 'shielding_models.dart';

abstract final class ShieldingAdapters {
  static ShieldCandidate fromRecommendationJson(
    BaseRcmdVideoItemModel item,
    Map<String, dynamic> json,
  ) {
    final owner = json['owner'] as Map?;
    final args = json['args'] as Map?;
    return ShieldCandidate(
      scope: ShieldScope.recommendation,
      title: item.title,
      uid: _string(owner?['mid'] ?? args?['up_id'] ?? item.owner.mid),
      authorName:
          _string(owner?['name'] ?? args?['up_name'] ?? item.owner.name),
      category: _string(json['tname'] ?? args?['tname']),
      tags: _tags(json),
      tokens: _tokens([
        item.title,
        item.owner.name,
        _string(json['tname'] ?? args?['tname']),
        ..._tags(json),
      ]),
    );
  }

  static ShieldCandidate fromReplyInfo(ReplyInfo reply) {
    final uid = reply.hasMid()
        ? reply.mid.toString()
        : reply.hasMember()
        ? reply.member.mid.toString()
        : null;
    return ShieldCandidate(
      scope: ShieldScope.comment,
      body: reply.hasContent() ? reply.content.message : null,
      uid: uid,
      authorName: reply.hasMember() ? reply.member.name : null,
      tokens: _tokens([
        if (reply.hasContent()) reply.content.message,
        if (reply.hasMember()) reply.member.name,
      ]),
    );
  }

  static List<T> filterList<T>(
    List<T> items, {
    required bool enabled,
    required ShieldRuleSet ruleSet,
    required ShieldCandidate Function(T item) toCandidate,
  }) {
    if (!enabled || !ruleSet.globalEnabled || items.isEmpty) {
      return items;
    }
    return items
        .where((item) => ShieldMatcher.match(toCandidate(item), ruleSet).visible)
        .toList();
  }

  static bool isVisible(ShieldCandidate candidate, ShieldRuleSet ruleSet) =>
      ShieldMatcher.match(candidate, ruleSet).visible;

  static List<String> _tags(Map<String, dynamic> json) {
    final raw = json['tag'] ?? json['tags'];
    if (raw is Iterable) {
      return raw.whereType<Object?>().map((e) => e.toString()).toList();
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return raw
          .split(RegExp(r'[,，\s]+'))
          .where((tag) => tag.trim().isNotEmpty)
          .toList();
    }
    return const [];
  }

  static List<String> _tokens(Iterable<String?> values) => values
      .whereType<String>()
      .expand((value) => value.split(RegExp(r'[\s,，。！？!?:：;；]+')))
      .where((value) => value.trim().isNotEmpty)
      .toList();
}

String? _string(Object? value) => value?.toString();
