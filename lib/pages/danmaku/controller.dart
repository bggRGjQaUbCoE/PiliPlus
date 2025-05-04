import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/http/danmaku.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';

class PlDanmakuController {
  PlDanmakuController(
    this.cid,
    this.plPlayerController,
  ) : mergeDanmaku = plPlayerController.mergeDanmaku;
  final int cid;
  final PlPlayerController plPlayerController;
  final bool mergeDanmaku;

  Map<int, List<DanmakuElem>> dmSegMap = {};
  // 已请求的段落标记
  Set<int> requestedSeg = {};

  static const int segmentLength = 60 * 6 * 1000;

  void dispose() {
    dmSegMap.clear();
    requestedSeg.clear();
  }

  int calcSegment(int progress) {
    return progress ~/ segmentLength;
  }

  Future<void> queryDanmaku(int segmentIndex) async {
    if (requestedSeg.contains(segmentIndex)) {
      return;
    }
    requestedSeg.add(segmentIndex);
    final result = await DanmakuHttp.queryDanmaku(
      cid: cid,
      segmentIndex: segmentIndex + 1,
    );

    if (result.isSuccess) {
      final data = result.data;
      if (data.elems.isNotEmpty) {
        final Map<String, int> counts = {};
        if (mergeDanmaku) {
          data.elems.retainWhere((item) {
            int? count = counts[item.content];
            counts[item.content] = count != null ? count + 1 : 1;
            return count == null;
          });
        }

        for (final element in data.elems) {
          if (mergeDanmaku) {
            final count = counts[element.content];
            if (count != 1) {
              element.attr = count!;
            } else {
              element.clearAttr();
            }
          }
          int pos = element.progress ~/ 100; //每0.1秒存储一次
          (dmSegMap[pos] ??= []).add(element);
        }
      }
    } else {
      requestedSeg.remove(segmentIndex);
    }
  }

  List<DanmakuElem>? getCurrentDanmaku(int progress) {
    int segmentIndex = calcSegment(progress);
    if (!requestedSeg.contains(segmentIndex)) {
      queryDanmaku(segmentIndex);
      return null;
    }
    if (plPlayerController.danmakuWeight == 0 &&
        plPlayerController.filters.count == 0) {
      return dmSegMap[progress ~/ 100];
    } else {
      return dmSegMap[progress ~/ 100]
        ?..retainWhere((element) =>
            element.weight >= plPlayerController.danmakuWeight &&
            plPlayerController.filters.retain(element));
    }
  }
}
