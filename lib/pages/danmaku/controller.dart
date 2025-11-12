import 'dart:io' show File;

import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/grpc/dm.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:path/path.dart' as path;

class PlDanmakuController {
  PlDanmakuController(
    this.cid,
    this.plPlayerController,
    this.isFileSource,
  ) : mergeDanmaku = plPlayerController.mergeDanmaku;

  final int cid;
  final PlPlayerController plPlayerController;
  final bool mergeDanmaku;
  final bool isFileSource;

  late final isLogin = Accounts.main.isLogin;

  Map<int, List<DanmakuElem>> dmSegMap = {};
  // 已请求的段落标记
  late final Set<int> requestedSeg = {};

  static const int segmentLength = 60 * 6 * 1000;

  void dispose() {
    closed = true;
    dmSegMap.clear();
    requestedSeg.clear();
  }

  static int calcSegment(int progress) {
    return progress ~/ segmentLength;
  }

  Future<void> queryDanmaku(int segmentIndex) async {
    if (isFileSource) {
      return;
    }
    if (requestedSeg.contains(segmentIndex)) {
      return;
    }
    requestedSeg.add(segmentIndex);
    final result = await DmGrpc.dmSegMobile(
      cid: cid,
      segmentIndex: segmentIndex + 1,
    );

    if (result.isSuccess) {
      final data = result.data;
      if (data.state == 1) {
        plPlayerController.dmState.add(cid);
      }
      handleDanmaku(data.elems);
    } else {
      requestedSeg.remove(segmentIndex);
    }
  }

  void handleDanmaku(List<DanmakuElem> elems) {
    if (elems.isEmpty) return;
    late final Map<String, int> counts = {};
    if (mergeDanmaku) {
      elems.retainWhere((item) {
        int? count = counts[item.content];
        counts[item.content] = count != null ? count + 1 : 1;
        return count == null;
      });
    }

    final shouldFilter = plPlayerController.filters.count != 0;
    for (final element in elems) {
      if (element.mode == 7 && !plPlayerController.showSpecialDanmaku) {
        continue;
      }
      if (isLogin) {
        element.isSelf = element.midHash == plPlayerController.midHash;
      }
      if (!element.isSelf) {
        if (element.weight < plPlayerController.danmakuWeight ||
            (shouldFilter && plPlayerController.filters.remove(element))) {
          continue;
        }
      }
      if (mergeDanmaku) {
        final count = counts[element.content];
        if (count != 1) {
          element.count = count!;
        }
      }
      final int pos = element.progress ~/ 100; //每0.1秒存储一次
      (dmSegMap[pos] ??= []).add(element);
    }
  }

  List<DanmakuElem>? getCurrentDanmaku(int progress) {
    if (isFileSource) {
      initFileDmIfNeeded();
    } else {
      final int segmentIndex = calcSegment(progress);
      if (!requestedSeg.contains(segmentIndex)) {
        queryDanmaku(segmentIndex);
        return null;
      }
    }
    return dmSegMap[progress ~/ 100];
  }

  bool closed = false;

  bool _fileDmLoaded = false;

  void initFileDmIfNeeded() {
    if (_fileDmLoaded) return;
    _fileDmLoaded = true;
    _initFileDm();
  }

  Future<void> _initFileDm() async {
    try {
      final file = File(
        path.join(plPlayerController.dirPath!, PathUtils.danmakuName),
      );
      if (!file.existsSync()) return;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return;
      final elem = DmSegMobileReply.fromBuffer(bytes).elems;
      handleDanmaku(elem);
    } catch (_) {
      if (kDebugMode) rethrow;
    }
  }
}
