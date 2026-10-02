// Inspired by the existing danmaku merge pipeline.
// This file hosts the background isolate entry for merge tasks.

import 'dart:isolate';

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/utils/danmaku_merge/clusterer.dart';
import 'package:PiliPlus/utils/danmaku_merge/models.dart';
import 'package:PiliPlus/utils/danmaku_merge/pinyin_encoder.dart';
import 'package:PiliPlus/utils/danmaku_merge/worker_models.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void danmakuMergeWorkerMain(List<Object?> args) {
  final sendPort = args[0]! as SendPort;
  final dictContent = args[1]! as String;
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  if (kDebugMode) {
    debugPrint(
      '[DanmakuMergeWorker:Isolate] started, dictLength=${dictContent.length}',
    );
  }

  // Parsing the dictionary here keeps the whole merge path synchronous, so
  // tasks are processed strictly one at a time by the listener itself.
  final pinyinEncoder = DanmakuPinyinEncoder.withDictionaryContent(dictContent);
  final preparedTextCache = <String, DanmakuPreparedText>{};

  receivePort.listen((message) {
    if (message is! Map<Object?, Object?>) {
      return;
    }
    final type = message['type'];
    if (type == 'shutdown') {
      if (kDebugMode) {
        debugPrint('[DanmakuMergeWorker:Isolate] shutdown');
      }
      receivePort.close();
      Isolate.exit();
    }
    if (type != 'task') {
      return;
    }

    final task = DanmakuMergeTaskPayload.fromMessage(message);
    if (kDebugMode) {
      debugPrint(
        '[DanmakuMergeWorker:Isolate] run task=${task.taskId} '
        'segment=${task.segmentIndex} current=${task.currentSegment.length} '
        'next=${task.nextSegmentPrefix.length}',
      );
    }
    try {
      final clusterer = DanmakuClusterer(
        config: task.config,
        pinyinEncoder: pinyinEncoder,
        prepareText: (text) => preparedTextCache.putIfAbsent(
          text,
          () => DanmakuClusterer.prepareText(text, pinyinEncoder),
        ),
      );
      final merged = clusterer.mergeSegment(
        segmentIndex: task.segmentIndex,
        currentSegment: DmSegMobileReply.fromBuffer(task.currentSegment).elems,
        nextSegmentPrefix:
            DmSegMobileReply.fromBuffer(task.nextSegmentPrefix).elems,
      );
      if (kDebugMode) {
        debugPrint(
          '[DanmakuMergeWorker:Isolate] done task=${task.taskId} '
          'segment=${task.segmentIndex} merged=${merged.length} '
          'textCache=${preparedTextCache.length}',
        );
      }
      sendPort.send(
        DanmakuMergeResultPayload(
          taskId: task.taskId,
          segmentIndex: task.segmentIndex,
          mergedSegment:
              (DmSegMobileReply()..elems.addAll(merged)).writeToBuffer(),
        ).toMessage(),
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[DanmakuMergeWorker:Isolate] failed task=${task.taskId} '
          '$error',
        );
      }
      sendPort.send(
        DanmakuMergeErrorPayload(
          taskId: task.taskId,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ).toMessage(),
      );
    }
  });
}
