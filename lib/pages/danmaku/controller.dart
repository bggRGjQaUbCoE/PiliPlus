import 'package:PiliPlus/grpc/dm/v1/dm.pb.dart';
import 'package:PiliPlus/http/danmaku.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';

class PlDanmakuController {
  PlDanmakuController(
    this.cid,
    this.plPlayerController,
  );
  final int cid;
  final PlPlayerController plPlayerController;

  Map<int, List<DanmakuElem>> dmSegMap = {};
  // 已请求的段落标记
  List<bool> requestedSeg = [];

  bool get initiated => requestedSeg.isNotEmpty;

  static int segmentLength = 60 * 6 * 1000;

  void initiate(int videoDuration, int progress) {
    if (videoDuration <= 0) {
      return;
    }
    if (requestedSeg.isEmpty) {
      int segCount = (videoDuration / segmentLength).ceil();
      requestedSeg = List<bool>.generate(segCount, (index) => false);
    }
    queryDanmaku(calcSegment(progress));
  }

  void dispose() {
    dmSegMap.clear();
    requestedSeg.clear();
  }

  int calcSegment(int progress) {
    return progress ~/ segmentLength;
  }

  void queryDanmaku(int segmentIndex) async {
    if (requestedSeg.length <= segmentIndex) {
      return;
    }
    assert(requestedSeg[segmentIndex] == false);
    requestedSeg[segmentIndex] = true;
    final DmSegMobileReply result = await DanmakuHttp.queryDanmaku(
      cid: cid,
      segmentIndex: segmentIndex + 1,
      mergeDanmaku: plPlayerController.mergeDanmaku,
    );
    if (result.elems.isNotEmpty) {
      for (var element in result.elems) {
        int pos = element.progress ~/ 100; //每0.1秒存储一次
        if (dmSegMap[pos] == null) {
          dmSegMap[pos] = [];
        }
        dmSegMap[pos]!.add(element);
      }
    }
  }

  List<DanmakuElem>? getCurrentDanmaku(int progress) {
    int segmentIndex = calcSegment(progress);
    if (requestedSeg.length <= segmentIndex) {
      return <DanmakuElem>[];
    }
    if (!requestedSeg[segmentIndex]) {
      queryDanmaku(segmentIndex);
    }
    if (plPlayerController.danmakuWeight == 0 &&
        plPlayerController.filterCount == 0) {
      return dmSegMap[progress ~/ 100];
    } else {
      return dmSegMap[progress ~/ 100]
          ?.where(
              (element) => element.weight >= plPlayerController.danmakuWeight)
          .where(filterDanmaku)
          .toList();
    }
  }

  bool filterDanmaku(DanmakuElem elem) {
    return !(plPlayerController.dmUid.contains(elem.content) ||
             plPlayerController.dmFilterString.any((i) => elem.content.contains(i)) ||
             plPlayerController.dmRegExp.any((i) => i.hasMatch(elem.content)));
  }
}
