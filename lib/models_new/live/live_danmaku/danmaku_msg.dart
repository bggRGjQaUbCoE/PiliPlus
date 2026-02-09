import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/live/live_danmaku/live_emote.dart';
import 'package:PiliPlus/pages/danmaku/danmaku_model.dart';

class DanmakuMsg {
  final String name;
  final String text;
  final Map<String, BaseEmote>? emots;
  final BaseEmote? uemote;
  final Owner? reply;
  final LiveDanmaku extra;

  const DanmakuMsg({
    required this.name,
    required this.text,
    this.emots,
    this.uemote,
    this.reply,
    required this.extra,
  });

  factory DanmakuMsg.fromPrefetch(Map<String, dynamic> obj) {
    final user = obj['user'];
    BaseEmote? uemote;
    if ((obj['emoticon']?['emoticon_unique'] as String?)?.isNotEmpty == true) {
      uemote = BaseEmote.fromJson(obj['emoticon']);
    }
    final checkInfo = obj['check_info'];
    Owner? reply;
    if (obj['reply'] case final Map map) {
      final replyMid = map['reply_mid'];
      if (replyMid != null && replyMid != 0) {
        reply = Owner(
          mid: replyMid,
          name: map['reply_uname'],
        );
      }
    }
    return DanmakuMsg(
      name: user['base']['name'],
      text: obj['text'],
      emots: (obj['emots'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, BaseEmote.fromJson(v)),
      ),
      uemote: uemote,
      reply: reply,
      extra: LiveDanmaku(
        id: obj['id_str'],
        mid: user['uid'],
        dmType: obj['dm_type'],
        ts: checkInfo['ts'],
        ct: checkInfo['ct'],
      ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'text': text,
    'emots': ?emots,
    'uemote': ?uemote?.toJson(),
    'reply': ?reply?.toJson(),
    'extra': extra.toJson(),
  };
}
