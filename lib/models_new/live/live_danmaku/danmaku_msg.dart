import 'package:PiliPlus/models_new/live/live_danmaku/live_emote.dart';

class DanmakuMsg {
  late String name;
  late Object uid;
  late String text;
  Map<String, BaseEmote>? emots;
  BaseEmote? uemote;

  DanmakuMsg();

  DanmakuMsg.fromPrefetch(Map<String, dynamic> obj) {
    final user = obj['user'];
    name = user['base']['name'];
    uid = user['uid'];
    text = obj['text'];
    emots = (obj['emots'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, BaseEmote.fromJson(v)));
    if ((obj['emoticon']?['emoticon_unique'] as String?)?.isNotEmpty == true) {
      uemote = BaseEmote.fromJson(obj['emoticon']);
    }
  }
}
