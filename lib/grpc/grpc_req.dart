import 'dart:convert';
import 'dart:typed_data';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/metadata.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/device.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/fawkes.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/locale.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/network.pb.dart' as network;
import 'package:PiliPlus/grpc/bilibili/rpc.pb.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, compute;
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

abstract final class GrpcReq {
  static const _isolateSize = 256 * 1024;
  static String? _accessKey = Accounts.main.accessKey;
  static const _build = 2001100;
  static const _versionName = '2.0.1';
  static const _biliChannel = 'master';
  static const _mobiApp = 'android_hd';
  static const _device = 'android';

  static final _buvid = LoginUtils.buvid;
  static final _traceId = IdUtils.genTraceId();
  static final _sessionId = Utils.generateRandomString(8);

  static void updateHeaders(String? accessKey) {
    _accessKey = accessKey;
    if (_accessKey != null) {
      headers['authorization'] = 'identify_v1 $_accessKey';
    } else {
      headers.remove('authorization');
    }
    headers['x-bili-metadata-bin'] = base64Encode(
      Metadata(
        accessKey: _accessKey ?? '',
        mobiApp: _mobiApp,
        device: _device,
        build: _build,
        channel: _biliChannel,
        buvid: _buvid,
        platform: _device,
      ).writeToBuffer(),
    );
  }

  static final Map<String, String> headers = {
    Headers.contentTypeHeader: 'application/grpc',
    'grpc-encoding': 'gzip',
    'gzip-accept-encoding': 'gzip,identity',
    'user-agent': Constants.userAgent,
    'x-bili-gaia-vtoken': '',
    'x-bili-aurora-zone': '',
    'x-bili-trace-id': _traceId,
    if (_accessKey != null) 'authorization': 'identify_v1 $_accessKey',
    'buvid': _buvid,
    'bili-http-engine': 'cronet',
    'te': 'trailers',
    'x-bili-fawkes-req-bin': base64Encode(
      FawkesReq(
        appkey: _mobiApp,
        env: 'prod',
        sessionId: _sessionId,
      ).writeToBuffer(),
    ),
    'x-bili-metadata-bin': base64Encode(
      Metadata(
        accessKey: _accessKey ?? '',
        mobiApp: _mobiApp,
        device: _device,
        build: _build,
        channel: _biliChannel,
        buvid: _buvid,
        platform: _device,
      ).writeToBuffer(),
    ),
    'x-bili-device-bin': base64Encode(
      Device(
        appId: 5,
        build: _build,
        buvid: _buvid,
        mobiApp: _mobiApp,
        platform: _device,
        channel: _biliChannel,
        brand: _device,
        model: _device,
        osver: '15',
        versionName: _versionName,
      ).writeToBuffer(),
    ),
    'x-bili-network-bin': base64Encode(
      network.Network(
        type: network.NetworkType.WIFI,
      ).writeToBuffer(),
    ),
    'x-bili-locale-bin': base64Encode(
      Locale(
        cLocale: LocaleIds(language: 'zh', region: 'CN', script: 'Hans'),
        sLocale: LocaleIds(language: 'zh', region: 'CN', script: 'Hans'),
        timezone: 'Asia/Shanghai',
      ).writeToBuffer(),
    ),
    'x-bili-exps-bin': '',
  };

  static final Options options = Options(
    headers: headers,
    responseType: ResponseType.bytes,
  );

  static Uint8List compressProtobuf(Uint8List proto) {
    proto = const GZipEncoder().encodeBytes(proto);
    return Uint8List(5 + proto.length)
      ..[0] = 1
      ..buffer.asByteData(1, 4).setInt32(0, proto.length, Endian.big)
      ..setAll(5, proto);
  }

  static Uint8List decompressProtobuf(Uint8List data) {
    final length = ByteData.sublistView(data, 1, 5).getInt32(0, Endian.big);

    if (data[0] == 1) {
      return const GZipDecoder().decodeBytes(
        Uint8List.sublistView(data, 5, length + 5),
      );
    } else {
      return Uint8List.sublistView(data, 5, length + 5);
    }
  }

  static LoadingState<T> _parse<T>((Uint8List, T Function(Uint8List)) args) {
    try {
      final data = decompressProtobuf(args.$1);
      final grpcResponse = args.$2(data);
      return Success(grpcResponse);
    } catch (e) {
      return Error(e.toString());
    }
  }

  static Future<LoadingState<T>> request<T>(
    String url,
    GeneratedMessage request,
    T Function(Uint8List) grpcParser, {
    bool isolate = false,
  }) async {
    final response = await Request().post<Uint8List>(
      HttpString.appBaseUrl + url,
      data: compressProtobuf(request.writeToBuffer()),
      options: options,
    );

    if (response.data case final Map map) {
      return Error(map['message']);
    }

    if (response.headers.value('Grpc-Status') == '0') {
      final data = response.data;
      if (data is Uint8List) {
        return isolate && data.length > _isolateSize
            ? compute(_parse, (data, grpcParser))
            : _parse((data, grpcParser));
      } else {
        return Error('grpc: ${data.runtimeType} is not Uint8List');
      }
    } else {
      try {
        int? code;
        String msg = response.headers.value('Grpc-Status-Details-Bin') ?? '';
        if (msg.isNotEmpty) {
          final padding = -msg.length & 3;
          if (padding != 0) {
            msg += '=' * padding;
          }
          final msgBytes = base64Decode(msg);
          try {
            final grpcMsg = Status.fromBuffer(msgBytes);
            final details = grpcMsg.details
                .map((e) => Status.fromBuffer(e.value))
                .toList();
            code = details.firstOrNull?.code;
            // UNKNOWN : -400 : msg
            final errMsg = details.map((e) => e.message).join('\n');
            msg = kDebugMode
                ? 'CODE: ${grpcMsg.code}(${grpcMsg.message})\n'
                      'MSG: $errMsg'
                : errMsg;
          } catch (e) {
            msg = utf8.decode(msgBytes, allowMalformed: true);
          }
        }
        return Error(msg, code: code);
      } catch (e) {
        return Error(e.toString());
      }
    }
  }

  // static Future playerOnline({
  //   int aid = 0,
  //   int cid = 0,
  // }) {
  //   return _request(
  //       GrpcUrl.playerOnline,
  //       PlayerOnlineReq(aid: Int64(aid), cid: Int64(cid), playOpen: true),
  //       PlayerOnlineReply.fromBuffer,
  //       onSuccess: (response) => response.totalNumberText);
  // }

  // static Future popular(int idx) {
  //   return _request(GrpcUrl.popular, PopularResultReq(idx: Int64(idx)),
  //       PopularReply.fromBuffer, onSuccess: (response) {
  //     response.items.retainWhere((item) => item.smallCoverV5.base.goto == 'av');
  //     return {'status': true, 'data': response.items};
  //   });
  // }
}
