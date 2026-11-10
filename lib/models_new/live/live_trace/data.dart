import 'dart:convert' show jsonEncode;

import 'package:uuid/uuid.dart' show Uuid;

class LiveTraceReq {
  final int parentAreaId;
  final int areaId;
  int seqId;
  final int roomId;
  final String liveBuvid;
  late final String liveUuid;
  late final String device;
  final int ruid;

  String get id => jsonEncode([parentAreaId, areaId, seqId, roomId]);

  LiveTraceReq({
    required this.parentAreaId,
    required this.areaId,
    this.seqId = 0,
    required this.roomId,
    required this.liveBuvid,
    String? liveUuid,
    required this.ruid,
  }) {
    this.liveUuid = liveUuid ?? const Uuid().v4();
    device = jsonEncode([liveBuvid, this.liveUuid]);
  }

  @override
  String toString() =>
      'parentAreaId: $parentAreaId, areaId: $areaId, seqId: $seqId, roomId: $roomId, liveBuvid: $liveBuvid, liveUuid: $liveUuid, ruid: $ruid';
}

class LiveTraceResp {
  final int timestamp;
  final int interval;
  final String secretKey;
  final List<int> secretRule;

  static const int kInterval = 60;

  const LiveTraceResp({
    required this.timestamp,
    required this.interval,
    required this.secretKey,
    required this.secretRule,
  });

  factory LiveTraceResp.fromJson(Map<String, dynamic> json) => LiveTraceResp(
    timestamp: json['timestamp'],
    interval: json['heartbeat_interval'] ?? kInterval,
    secretKey: json['secret_key'],
    secretRule: List<int>.from(json['secret_rule']),
  );

  @override
  String toString() =>
      'timestamp: $timestamp, interval: $interval, secretKey: $secretKey, secretRule: $secretRule';
}
