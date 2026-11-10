import 'dart:convert' show utf8, jsonEncode;

import 'package:PiliPlus/models_new/live/live_trace/data.dart';
import 'package:crypto/crypto.dart'
    show Hmac, md5, sha1, sha256, sha224, sha512, sha384, Hash;
import 'package:flutter/foundation.dart' show kDebugMode;

abstract final class LiveTraceUtils {
  static String? _hmacByRule(
    List<int> data,
    String secretKey,
    int rule,
  ) {
    final Hash hash;

    switch (rule) {
      case 0:
        hash = md5;
      case 1:
        hash = sha1;
      case 2:
        hash = sha256;
      case 3:
        hash = sha224;
      case 4:
        hash = sha512;
      case 5:
        hash = sha384;
      case _:
        if (kDebugMode) {
          throw UnsupportedError('secret_rule: $rule');
        }
        return null;
    }

    return Hmac(hash, utf8.encode(secretKey)).convert(data).toString();
  }

  static String? buildX25KnSignature({
    required LiveTraceReq traceReq,
    required LiveTraceResp traceResp,
    required int tsMs,
  }) {
    final payload = {
      'platform': 'web',
      'parent_id': traceReq.parentAreaId,
      'area_id': traceReq.areaId,
      'seq_id': traceReq.seqId,
      'room_id': traceReq.roomId,
      'buvid': traceReq.liveBuvid,
      'uuid': traceReq.liveUuid,
      'ets': traceResp.timestamp,
      'time': traceResp.interval,
      'ts': tsMs,
    };

    var current = utf8.encode(jsonEncode(payload));

    for (final rule in traceResp.secretRule) {
      final newVal = _hmacByRule(current, traceResp.secretKey, rule);
      if (newVal == null) return null;
      current = utf8.encode(newVal);
    }

    return utf8.decode(current);
  }
}
