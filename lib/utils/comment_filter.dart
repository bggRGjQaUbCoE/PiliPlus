import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/utils/storage.dart';

/// Local comment moderation rules. Values are comma/newline separated tokens.
abstract final class CommentFilter {
  static const _ipKey = 'commentFilterIp';
  static const _textKey = 'commentFilterText';
  static const _userKey = 'commentFilterUser';
  static const _duplicateKey = 'commentFilterDuplicate';

  static List<String> _tokens(String key) => (GStorage.localCache
          .get(key, defaultValue: const <String>[])
      as List)
      .map((e) => e.toString().trim().toLowerCase())
      .where((e) => e.isNotEmpty)
      .toList();

  static List<String> get ipRules => _tokens(_ipKey);
  static List<String> get textRules => _tokens(_textKey);
  static List<String> get userRules => _tokens(_userKey);
  static bool get hideDuplicates =>
      GStorage.localCache.get(_duplicateKey, defaultValue: false) as bool;

  static Future<void> setRules({
    List<String>? ip,
    List<String>? text,
    List<String>? user,
    bool? duplicates,
  }) async {
    if (ip != null) await GStorage.localCache.put(_ipKey, ip);
    if (text != null) await GStorage.localCache.put(_textKey, text);
    if (user != null) await GStorage.localCache.put(_userKey, user);
    if (duplicates != null) {
      await GStorage.localCache.put(_duplicateKey, duplicates);
    }
  }

  static bool _contains(String value, List<String> rules) =>
      rules.any(value.toLowerCase().contains);

  static void filter(List<ReplyInfo> replies) {
    final seen = <String>{};
    replies.removeWhere((reply) {
      final text = reply.content.message;
      final user = reply.member.name;
      final ip = reply.replyControl.hasLocation()
          ? reply.replyControl.location
          : '';
      final blocked = _contains(ip, ipRules) ||
          _contains(text, textRules) ||
          _contains(user, userRules) ||
          (hideDuplicates && !seen.add(text.trim().toLowerCase()));
      if (!blocked && reply.replies.isNotEmpty) filter(reply.replies);
      return blocked;
    });
  }
}
