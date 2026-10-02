// Inspired by the existing danmaku merge pipeline.
// This file provides a single persistent background isolate for merge tasks.

import 'dart:async';
import 'dart:isolate';

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/utils/danmaku_merge/models.dart';
import 'package:PiliPlus/utils/danmaku_merge/pinyin_encoder.dart';
import 'package:PiliPlus/utils/danmaku_merge/worker_entry.dart';
import 'package:PiliPlus/utils/danmaku_merge/worker_models.dart';
import 'package:flutter/foundation.dart';

class DanmakuMergeWorkerClient {
  DanmakuMergeWorkerClient({
    required this.dictionaryLoader,
  });

  final Future<String> Function(String path) dictionaryLoader;

  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  StreamSubscription<Object?>? _subscription;
  Completer<void>? _startupCompleter;
  int _nextTaskId = 0;
  final Map<int, Completer<List<DanmakuElem>>> _pending =
      <int, Completer<List<DanmakuElem>>>{};

  Future<List<DanmakuElem>> mergeSegment({
    required int segmentIndex,
    required DanmakuMergeConfig config,
    required List<DanmakuElem> currentSegment,
    required List<DanmakuElem> nextSegmentPrefix,
  }) async {
    await _ensureStarted();
    final sendPort = _sendPort;
    if (sendPort == null) {
      throw StateError('Danmaku merge worker disposed');
    }
    final taskId = _nextTaskId++;
    final completer = Completer<List<DanmakuElem>>();
    _pending[taskId] = completer;
    if (kDebugMode) {
      debugPrint(
        '[DanmakuMergeWorker] submit task=$taskId segment=$segmentIndex '
        'current=${currentSegment.length} next=${nextSegmentPrefix.length}',
      );
    }

    sendPort.send(
      DanmakuMergeTaskPayload(
        taskId: taskId,
        segmentIndex: segmentIndex,
        config: config,
        currentSegment:
            (DmSegMobileReply()..elems.addAll(currentSegment)).writeToBuffer(),
        nextSegmentPrefix:
            (DmSegMobileReply()..elems.addAll(nextSegmentPrefix)).writeToBuffer(),
      ).toMessage(),
    );
    return completer.future;
  }

  /// Spawns the isolate ahead of time (e.g. in parallel with the first
  /// danmaku request) so the first merge doesn't pay the startup cost.
  Future<void> warmUp() async {
    try {
      await _ensureStarted();
    } catch (_) {
      // Startup failures surface through the first real merge call, which
      // retries from a clean state.
    }
  }

  Future<void> dispose() async {
    _sendPort?.send(const <String, Object?>{'type': 'shutdown'});
    final startup = _startupCompleter;
    if (startup != null && !startup.isCompleted) {
      startup.completeError(
        StateError('Danmaku merge worker disposed during startup'),
      );
    }
    for (final completer in _pending.values) {
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Danmaku merge worker disposed before task completion'),
        );
      }
    }
    _pending.clear();
    await _subscription?.cancel();
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _subscription = null;
    _receivePort = null;
    _sendPort = null;
    _isolate = null;
    _startupCompleter = null;
  }

  Future<void> _ensureStarted() async {
    if (_sendPort != null) {
      return;
    }
    if (_startupCompleter != null) {
      return _startupCompleter!.future;
    }

    final completer = Completer<void>();
    _startupCompleter = completer;
    try {
      _receivePort = ReceivePort();
      _subscription = _receivePort!.listen(_handleMessage);

      final dictContent = await dictionaryLoader(DanmakuPinyinEncoder.assetPath);
      if (kDebugMode) {
        debugPrint(
          '[DanmakuMergeWorker] spawning isolate, dictLength=${dictContent.length}',
        );
      }
      final isolate = await Isolate.spawn<List<Object?>>(
        danmakuMergeWorkerMain,
        <Object?>[_receivePort!.sendPort, dictContent],
      );
      if (completer.isCompleted) {
        // Disposed while starting up.
        isolate.kill(priority: Isolate.immediate);
      } else {
        _isolate = isolate;
      }
    } catch (e, s) {
      await _subscription?.cancel();
      _receivePort?.close();
      _subscription = null;
      _receivePort = null;
      _isolate = null;
      if (identical(_startupCompleter, completer)) {
        _startupCompleter = null;
      }
      if (!completer.isCompleted) {
        completer.completeError(e, s);
      }
    }
    return completer.future;
  }

  void _handleMessage(Object? message) {
    if (message is SendPort) {
      _sendPort = message;
      if (kDebugMode) {
        debugPrint('[DanmakuMergeWorker] isolate ready');
      }
      _startupCompleter?.complete();
      _startupCompleter = null;
      return;
    }
    if (message is! Map<Object?, Object?>) {
      return;
    }

    final type = message['type'];
    if (type == 'result') {
      final result = DanmakuMergeResultPayload.fromMessage(message);
      if (kDebugMode) {
        debugPrint(
          '[DanmakuMergeWorker] result task=${result.taskId} '
          'segment=${result.segmentIndex} merged=${result.mergedSegment.length}',
        );
      }
      final completer = _pending.remove(result.taskId);
      if (completer != null && !completer.isCompleted) {
        completer.complete(
          DmSegMobileReply.fromBuffer(result.mergedSegment).elems,
        );
      }
      return;
    }

    if (type == 'error') {
      final taskId = message['taskId']! as int;
      if (kDebugMode) {
        debugPrint(
          '[DanmakuMergeWorker] error task=$taskId '
          '${message['message']}',
        );
      }
      final completer = _pending.remove(taskId);
      if (completer != null && !completer.isCompleted) {
        completer.completeError(
          StateError(message['message']! as String),
          StackTrace.fromString(message['stackTrace']! as String),
        );
      }
    }
  }
}
