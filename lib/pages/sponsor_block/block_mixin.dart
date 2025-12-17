import 'dart:async' show StreamSubscription, Timer;
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/sponsor_block.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/skip_type.dart';
import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:media_kit/media_kit.dart';

mixin BlockConfigMixin {
  late final pgcSkipType = Pref.pgcSkipType;
  late final enablePgcSkip = pgcSkipType != SkipType.disable;
  late final bool enableSponsorBlock = Pref.enableSponsorBlock;
  late final bool enableBlock = enableSponsorBlock || enablePgcSkip;
  late final List<Color> blockColor = Pref.blockColor;
}

mixin BlockMixin on GetxController {
  int? _lastBlockPos;
  BlockConfigMixin get blockConfig;
  StreamSubscription<Duration>? _blockListener;
  StreamSubscription<Duration>? get blockListener => _blockListener;
  late final List<SegmentModel> _segmentList = <SegmentModel>[];
  late final RxList<Segment> segmentProgressList = <Segment>[].obs;

  Timer? _skipTimer;
  late final listKey = GlobalKey<AnimatedListState>();
  late final List<Object> listData = [];

  RxString? get videoLabel => null;
  Player? get player;
  bool get autoPlay;
  int? get timeLength;
  bool get preInitPlayer;
  int get currPosInMilliseconds;
  bool get isFullScreen => false;

  bool get isUgc;
  late final isBlock = isUgc || !blockConfig.enablePgcSkip;

  Future<void> querySponsorBlock({
    required String bvid,
    required int cid,
  }) async {
    resetBlock();

    final result = await SponsorBlock.getSkipSegments(bvid: bvid, cid: cid);
    switch (result) {
      case Success<List<SegmentItemModel>>(:final response):
        handleSBData(response);
      case Error(:final code) when code != 404:
        if (kDebugMode) {
          result.toast();
        }
      default:
    }
  }

  void initSkip() {
    if (isClosed) return;
    if (_segmentList.isNotEmpty) {
      _blockListener?.cancel();
      _blockListener = player?.stream.position.listen((position) {
        int currentPos = position.inSeconds;
        if (currentPos != _lastBlockPos) {
          _lastBlockPos = currentPos;
          final msPos = currentPos * 1000;
          for (SegmentModel item in _segmentList) {
            // if (kDebugMode) {
            //   debugPrint(
            //       '${position.inSeconds},,${item.segment.first},,${item.segment.second},,${item.skipType.name},,${item.hasSkipped}');
            // }
            if (msPos <= item.segment.$1 && item.segment.$1 <= msPos + 1000) {
              switch (item.skipType) {
                case SkipType.alwaysSkip:
                  onSkip(item, isSeek: false);
                  break;
                case SkipType.skipOnce:
                  if (!item.hasSkipped) {
                    item.hasSkipped = true;
                    onSkip(item, isSeek: false);
                  }
                  break;
                case SkipType.skipManually:
                  onAddItem(item);
                  break;
                default:
                  break;
              }
              break;
            }
          }
        }
      });
    }
  }

  Future<void> handleSBData(List<SegmentItemModel> list) async {
    if (list.isNotEmpty) {
      try {
        Future<void>? future;
        final duration = list.first.videoDuration ?? timeLength!;
        // segmentList
        _segmentList.addAll(
          list
              .where(
                (item) =>
                    SegmentModel.enableList.contains(item.category) &&
                    item.segment[1] >= item.segment[0],
              )
              .map(
                (item) {
                  final segmentModel = SegmentModel.fromItemModel(
                    item,
                    isBlock,
                  );
                  if (segmentModel.segment == const (0, 0)) {
                    videoLabel?.value +=
                        '${videoLabel!.value.isNotEmpty ? '/' : ''}${segmentModel.segmentType.title}';
                  }

                  if (_blockListener == null && autoPlay && player != null) {
                    final currPos = currPosInMilliseconds;

                    if (segmentModel.segment.contains(currPos)) {
                      _lastBlockPos = currPos;

                      switch (segmentModel.skipType) {
                        case SkipType.alwaysSkip:
                        case SkipType.skipOnce:
                          segmentModel.hasSkipped = true;
                          if (player!.state.playing) {
                            future = onSkip(
                              segmentModel,
                            );
                          } else {
                            player!.stream.playing.firstWhere((e) {
                              if (e) {
                                future = onSkip(segmentModel);
                                return true;
                              }
                              return false;
                            }, orElse: () => false);
                          }
                          break;
                        case SkipType.skipManually:
                          onAddItem(segmentModel);
                          break;
                        default:
                          break;
                      }
                    }
                  }

                  return segmentModel;
                },
              ),
        );

        // _segmentProgressList
        segmentProgressList.addAll(
          _segmentList.map((e) {
            double start = (e.segment.$1 / duration).clamp(0.0, 1.0);
            double end = (e.segment.$2 / duration).clamp(0.0, 1.0);
            return Segment(
              start: start,
              end: end,
              color: e.segmentType.barColor,
            );
          }),
        );

        if (_blockListener == null && (autoPlay || preInitPlayer)) {
          await future;
          initSkip();
        }
      } catch (e) {
        if (kDebugMode) debugPrint('failed to parse sponsorblock: $e');
      }
    }
  }

  void onAddItem(Object item) {
    if (listData.contains(item)) return;
    listData.insert(0, item);
    listKey.currentState?.insertItem(0);
    _skipTimer ??= Timer.periodic(const Duration(seconds: 4), (_) {
      if (listData.isNotEmpty) {
        onRemoveItem(listData.length - 1, listData.last);
      }
    });
  }

  void onRemoveItem(int index, Object item) {
    EasyThrottle.throttle(
      'onRemoveItem',
      const Duration(milliseconds: 500),
      () {
        try {
          listData.removeAt(index);
          if (listData.isEmpty) {
            _stopSkipTimer();
          }
          listKey.currentState?.removeItem(
            index,
            (context, animation) => buildItem(item, animation),
          );
        } catch (_) {}
      },
    );
  }

  Widget buildItem(Object item, Animation<double> animation) =>
      throw UnimplementedError();

  void _stopSkipTimer() {
    if (_skipTimer != null) {
      _skipTimer!.cancel();
      _skipTimer = null;
    }
  }

  Future<void>? seekTo(Duration duration, {required bool isSeek});

  void _skipToast(SegmentModel item) {
    if (autoPlay && Pref.blockToast) {
      _showBlockToast('已跳过${item.segmentType.shortTitle}片段');
    }
    if (isBlock && Pref.blockTrack) {
      SponsorBlock.viewedVideoSponsorTime(item.uuid);
    }
  }

  Future<void> onSkip(
    SegmentModel item, {
    bool isSkip = true,
    bool isSeek = true,
  }) async {
    try {
      await seekTo(
        Duration(milliseconds: item.segment.$2),
        isSeek: isSeek,
      );
      if (isSkip) {
        _skipToast(item);
      } else {
        _showBlockToast('已跳至${item.segmentType.shortTitle}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('failed to skip: $e');
      if (isSkip) {
        _showBlockToast('${item.segmentType.shortTitle}片段跳过失败');
      } else {
        _showBlockToast('跳转失败');
      }
    }
  }

  void _showBlockToast(String msg) {
    SmartDialog.showToast(
      msg,
      alignment: isFullScreen ? const Alignment(0, 0.7) : null,
    );
  }

  void _showVoteDialog(SegmentModel segment) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                title: const Text('赞成票', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Get.back();
                  _doVote(segment.uuid, 1);
                },
              ),
              ListTile(
                dense: true,
                title: const Text('反对票', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Get.back();
                  _doVote(segment.uuid, 0);
                },
              ),
              ListTile(
                dense: true,
                title: const Text('更改类别', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Get.back();
                  _showCategoryDialog(segment);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _doVote(String uuid, int type) => SponsorBlock.voteOnSponsorTime(
    uuid: uuid,
    type: type,
  ).then((i) => SmartDialog.showToast(i.isSuccess ? '投票成功' : '投票失败: $i'));

  void _showCategoryDialog(SegmentModel segment) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: SegmentType.values
                .map(
                  (item) => ListTile(
                    dense: true,
                    onTap: () {
                      Get.back();
                      SponsorBlock.voteOnSponsorTime(
                        uuid: segment.uuid,
                        category: item,
                      ).then((i) {
                        SmartDialog.showToast(
                          '类别更改${i.isSuccess ? '成功' : '失败: $i'}',
                        );
                      });
                    },
                    title: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item.barColor,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14, height: 1),
                          ),
                          TextSpan(
                            text: ' ${item.title}',
                            style: const TextStyle(fontSize: 14, height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void showSBDetail() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _segmentList
                .map(
                  (item) => ListTile(
                    onTap: () {
                      Get.back();
                      if (isBlock) {
                        _showVoteDialog(item);
                      }
                    },
                    dense: true,
                    title: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item.segmentType.barColor,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14, height: 1),
                          ),
                          TextSpan(
                            text: ' ${item.segmentType.title}',
                            style: const TextStyle(fontSize: 14, height: 1),
                          ),
                        ],
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 16, right: 8),
                    subtitle: Text(
                      '${DurationUtils.formatDuration(item.segment.$1 / 1000)} 至 ${DurationUtils.formatDuration(item.segment.$2 / 1000)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.skipType.label,
                          style: const TextStyle(fontSize: 13),
                        ),
                        if (item.segment.$2 != 0)
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              tooltip: item.skipType == SkipType.showOnly
                                  ? '跳至此片段'
                                  : '跳过此片段',
                              onPressed: () {
                                Get.back();
                                onSkip(
                                  item,
                                  isSkip: item.skipType != SkipType.showOnly,
                                  isSeek: false,
                                );
                              },
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                item.skipType == SkipType.showOnly
                                    ? Icons.my_location
                                    : MdiIcons.debugStepOver,
                                size: 18,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 10),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void cancelBlockListener() {
    if (_blockListener != null) {
      _blockListener!.cancel();
      _blockListener = null;
    }
  }

  void resetBlock() {
    cancelBlockListener();
    _lastBlockPos = null;
    videoLabel?.value = '';
    _segmentList.clear();
    segmentProgressList.clear();
  }

  Duration? getFirstSegment([int pos = 0]) {
    for (var i in _segmentList..sort()) {
      final (start, end) = i.segment;
      if (start == end) {
        continue;
      } else if (start - pos < 100) {
        if (switch (i.skipType) {
          .alwaysSkip => true,
          .skipOnce => !i.hasSkipped,
          _ => false,
        }) {
          _skipToast(i);
          pos = math.max(pos, i.segment.$2);
        }
      } else {
        break;
      }
    }
    if (pos != 0) {
      return Duration(milliseconds: pos);
    }
    return null;
  }

  @override
  void onClose() {
    _stopSkipTimer();
    if (blockConfig.enableBlock) {
      resetBlock();
    }
    super.onClose();
  }
}
