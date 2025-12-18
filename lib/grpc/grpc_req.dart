import 'dart:convert';
import 'dart:typed_data';

import 'package:PiliPlus/grpc/bilibili/rpc.pb.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, compute;
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

abstract final class GrpcReq {
  static const _isolateSize = 256 * 1024;

  static final options = Options(responseType: ResponseType.bytes);

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
