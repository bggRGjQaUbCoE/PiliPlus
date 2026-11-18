import 'dart:convert';

int roomInt(Object? value, [int fallback = 0]) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? fallback;

Map<String, dynamic> roomMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

class RoomInvite {
  final int roomId;
  final int? episodeId;
  final int? seasonId;
  final String? inviter;
  final String? token;
  final int roomMode;
  const RoomInvite(
    this.roomId, {
    this.episodeId,
    this.seasonId,
    this.inviter,
    this.token,
    this.roomMode = 0,
  });

  static Uri? linkFromText(String text) {
    final normalized = text
        .trim()
        .replaceAll('&amp;', '&')
        .replaceAll(r'\&', '&');
    final match = RegExp(
      r'(?:https?://|bilibili://)[^\s<>\[\]()（）]+',
      caseSensitive: false,
    ).firstMatch(normalized);
    final link = (match?.group(0) ?? normalized).replaceFirst(
      RegExp(r'[，。；！、,;!.]+$'),
      '',
    );
    return Uri.tryParse(link);
  }

  factory RoomInvite.parse(String text) {
    final raw = text.trim();
    if (RegExp(r'^\d+$').hasMatch(raw) && roomInt(raw) > 0) {
      return RoomInvite(int.parse(raw));
    }
    final uri = linkFromText(raw);
    if (uri == null ||
        uri.userInfo.isNotEmpty ||
        !{'https', 'http', 'bilibili'}.contains(uri.scheme)) {
      throw const FormatException('请粘贴 B 站放映室邀请链接或房间号');
    }
    final web = {
      'www.bilibili.com',
      'm.bilibili.com',
      'bilibili.com',
    }.contains(uri.host);
    final segments = uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();
    final app =
        uri.scheme == 'bilibili' &&
        uri.host == 'pgc' &&
        segments.length == 1 &&
        segments.single == 'room';
    final mobileInvite = web && segments.join('/') == 'bangumi/theatre/invite';
    final id = web && segments.length == 2 && segments.first == 'watchroom'
        ? segments.last
        : null;
    final room = roomInt(
      id ??
          (mobileInvite ? uri.queryParameters['roomid'] : null) ??
          (app ? uri.queryParameters['room_id'] : null),
    );
    if (room <= 0) throw const FormatException('不是有效的 B 站放映室邀请链接');
    return RoomInvite(
      room,
      episodeId: int.tryParse(
        uri.queryParameters['wepid'] ??
            uri.queryParameters['epid'] ??
            uri.queryParameters['ep_id'] ??
            '',
      ),
      seasonId: int.tryParse(
        uri.queryParameters['seasonid'] ??
            uri.queryParameters['season_id'] ??
            '',
      ),
      inviter: uri.queryParameters['invitemid'],
      token: uri.queryParameters['token'],
      roomMode: roomInt(uri.queryParameters['room_mode']),
    );
  }

  Uri get uri => Uri.https('www.bilibili.com', '/watchroom/$roomId', {
    if (episodeId != null) 'wepid': '$episodeId',
    if (seasonId != null) 'seasonid': '$seasonId',
    if (inviter != null) 'invitemid': inviter!,
    if (token != null) 'token': token!,
    if (roomMode != 0) 'room_mode': '$roomMode',
  });

  Uri get mobileUri => Uri.https('m.bilibili.com', '/bangumi/theatre/invite', {
    'roomid': '$roomId',
    if (episodeId != null) 'epid': '$episodeId',
    if (seasonId != null) 'seasonid': '$seasonId',
    'room_mode': '$roomMode',
    if (inviter != null) 'invitemid': inviter!,
    if (token != null) 'token': token!,
  });
}

class RoomMember {
  final int mid;
  final String name;
  const RoomMember(this.mid, this.name);
  factory RoomMember.fromJson(Map<String, dynamic> json) => RoomMember(
    roomInt(json['mid']),
    '${json['nickname'] ?? json['uname'] ?? '成员'}',
  );
}

class RoomSnapshot {
  final int roomId, ownerId, seasonId, episodeId, status;
  final Duration position;
  final DateTime receivedAt;
  final List<RoomMember> members;
  const RoomSnapshot({
    required this.roomId,
    required this.ownerId,
    required this.seasonId,
    required this.episodeId,
    required this.status,
    required this.position,
    required this.receivedAt,
    this.members = const [],
  });
  bool get playing => status == 1;
  Duration targetAt(DateTime now) {
    final elapsed = now.difference(receivedAt);
    return position +
        (playing && !elapsed.isNegative ? elapsed : Duration.zero);
  }

  factory RoomSnapshot.fromJson(
    Map<String, dynamic> json,
    DateTime receivedAt,
  ) {
    final state = roomMap(json['status']);
    return RoomSnapshot(
      roomId: roomInt(json['room_id']),
      ownerId: roomInt(json['mid']),
      seasonId: roomInt(json['season_id'] ?? json['oid']),
      episodeId: roomInt(json['episode_id'] ?? json['sub_id']),
      status: roomInt(state['status']),
      position: Duration(seconds: roomInt(state['progress'])),
      receivedAt: receivedAt,
      members: [
        for (final m in json['members'] as List? ?? [])
          RoomMember.fromJson(roomMap(m)),
      ],
    );
  }
  RoomSnapshot progress({
    required int season,
    required int episode,
    required int state,
    required Duration position,
    required DateTime at,
  }) => RoomSnapshot(
    roomId: roomId,
    ownerId: ownerId,
    seasonId: season,
    episodeId: episode,
    status: state,
    position: position,
    receivedAt: at,
    members: members,
  );
  RoomSnapshot membership(int owner, List<RoomMember> list) => RoomSnapshot(
    roomId: roomId,
    ownerId: owner,
    seasonId: seasonId,
    episodeId: episodeId,
    status: status,
    position: position,
    receivedAt: receivedAt,
    members: list,
  );
}

class RoomChat {
  final String id, author, text;
  const RoomChat(this.id, this.author, this.text);
  static String content(Object? value) {
    if (value is String) {
      try {
        return content(jsonDecode(value));
      } catch (_) {
        return value;
      }
    }
    if (value is Map) return '${value['text'] ?? value['content'] ?? ''}';
    return '';
  }

  factory RoomChat.fromJson(Map<String, dynamic> json) => RoomChat(
    '${json['msg_id2'] ?? json['msg_id'] ?? json['id'] ?? ''}',
    '${roomMap(json['user'])['nickname'] ?? '系统'}',
    content(roomMap(json['message'])['content']),
  );
}

class RoomApiException implements Exception {
  final int code;
  final String message;
  const RoomApiException(this.code, this.message);
  @override
  String toString() => '$message（$code）';
}
