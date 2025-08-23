import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/pages/common/slide/common_collapse_slide_page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/duration_util.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostPanel extends CommonCollapseSlidePage {
  const PostPanel({
    super.key,
    super.enableSlide,
    required this.videoDetailController,
    required this.plPlayerController,
  });

  final VideoDetailController videoDetailController;
  final PlPlayerController plPlayerController;

  @override
  State<PostPanel> createState() => _PostPanelState();
}

class _PostPanelState extends CommonCollapseSlidePageState<PostPanel> {
  late final VideoDetailController videoDetailController =
      widget.videoDetailController;
  late final PlPlayerController plPlayerController = widget.plPlayerController;
  late final List<PostSegmentModel>? list = videoDetailController.postList;

  late final double videoDuration =
      plPlayerController.durationSeconds.value.inMilliseconds / 1000;

  double get currentPos =>
      plPlayerController.position.value.inMilliseconds / 1000;

  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(ThemeData theme) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        primary: false,
        toolbarHeight: 45,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text('提交片段'),
        actions: [
          iconButton(
            size: 32,
            context: context,
            tooltip: '添加片段',
            onPressed: () {
              setState(() {
                list?.insert(
                  0,
                  PostSegmentModel(
                    segment: Pair(
                      first: 0,
                      second: currentPos,
                    ),
                    category: SegmentType.sponsor,
                    actionType: ActionType.skip,
                  ),
                );
              });
            },
            icon: Icons.add,
          ),
          const SizedBox(width: 10),
          iconButton(
            size: 32,
            context: context,
            tooltip: '关闭',
            onPressed: Get.back,
            icon: Icons.close,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: enableSlide ? slideList(theme) : buildList(theme),
    );
  }

  @override
  Widget buildList(ThemeData theme) {
    if (list.isNullOrEmpty) {
      return errorWidget();
    }
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          controller: _controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 88 + bottom),
          child: Column(
            children: List.generate(
              list!.length,
              (index) {
                return _buildItem(theme, index, list![index]);
              },
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16 + bottom,
          child: FloatingActionButton(
            tooltip: '提交',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('确定无误再提交'),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      _onPost();
                    },
                    child: const Text('确定提交'),
                  ),
                ],
              ),
            ),
            child: const Icon(Icons.check),
          ),
        ),
      ],
    );
  }

  void updateSegment({
    required bool isFirst,
    required PostSegmentModel item,
    required double value,
  }) {
    if (isFirst) {
      item.segment.first = value;
    } else {
      item.segment.second = value;
    }
    if (item.category == SegmentType.poi_highlight ||
        item.actionType == ActionType.full) {
      item.segment.second = value;
    }
  }

  List<Widget> segmentWidget(
    BuildContext context,
    ThemeData theme, {
    required PostSegmentModel item,
    required bool isFirst,
  }) {
    String value = DurationUtil.formatDuration(
      isFirst ? item.segment.first : item.segment.second,
    );
    return [
      Text(
        '${isFirst ? '开始' : '结束'}: $value',
      ),
      const SizedBox(width: 5),
      iconButton(
        context: context,
        size: 26,
        tooltip: '设为当前',
        icon: Icons.my_location,
        onPressed: () {
          updateSegment(
            isFirst: isFirst,
            item: item,
            value: currentPos,
          );
          (context as Element).markNeedsBuild();
        },
      ),
      const SizedBox(width: 5),
      iconButton(
        context: context,
        size: 26,
        tooltip: isFirst ? '视频开头' : '视频结尾',
        icon: isFirst ? Icons.first_page : Icons.last_page,
        onPressed: () {
          updateSegment(
            isFirst: isFirst,
            item: item,
            value: isFirst ? 0 : videoDuration,
          );
          (context as Element).markNeedsBuild();
        },
      ),
      const SizedBox(width: 5),
      iconButton(
        context: context,
        size: 26,
        tooltip: '编辑',
        icon: Icons.edit,
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (context) {
              String initV = value;
              return AlertDialog(
                content: TextFormField(
                  initialValue: value,
                  autofocus: true,
                  onChanged: (value) => initV = value,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d:.]+')),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: initV),
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          ).then((res) {
            if (res != null) {
              try {
                List<num> split = res
                    .split(':')
                    .reversed
                    .map(num.parse)
                    .toList();
                double duration = 0;
                for (int i = 0; i < split.length; i++) {
                  duration += split[i] * pow(60, i);
                }
                if (duration <= videoDuration) {
                  updateSegment(
                    isFirst: isFirst,
                    item: item,
                    value: duration,
                  );
                  (context as Element).markNeedsBuild();
                }
              } catch (e) {
                if (kDebugMode) debugPrint(e.toString());
              }
            }
          });
        },
      ),
    ];
  }

  void _onPost() {
    Request()
        .post(
          '${widget.videoDetailController.blockServer}/api/skipSegments',
          data: {
            'videoID': videoDetailController.bvid,
            'cid': videoDetailController.cid.value.toString(),
            'userID': Pref.blockUserID.toString(),
            'userAgent': Constants.userAgent,
            'videoDuration': videoDuration,
            'segments': list!
                .map(
                  (item) => {
                    'segment': [
                      item.segment.first,
                      item.segment.second,
                    ],
                    'category': item.category.name,
                    'actionType': item.actionType.name,
                  },
                )
                .toList(),
          },
          options: Options(
            followRedirects: true, // Defaults to true.
            validateStatus: (int? status) {
              return (status! >= 200 && status < 300) ||
                  const [400, 403, 429, 409] // reduce extra toast
                      .contains(status);
            },
          ),
        )
        .then(
          (res) {
            if (res.statusCode == 200) {
              Get.back();
              SmartDialog.showToast('提交成功');
              list?.clear();
              if (res.data case List list) {
                videoDetailController.handleSBData(
                  list.map((e) => SegmentItemModel.fromJson(e)).toList(),
                );
              }
              plPlayerController.segmentList.value =
                  videoDetailController.segmentProgressList ?? <Segment>[];
              if (videoDetailController.positionSubscription == null) {
                videoDetailController.initSkip();
              }
            } else {
              SmartDialog.showToast('提交失败: ${_errMsg(res)}');
            }
          },
        );
  }

  String _errMsg(Response res) {
    if (res.data case String e) {
      if (e.isNotEmpty) {
        return e;
      }
    }
    return switch (res.statusCode) {
      400 => '参数错误',
      403 => '被自动审核机制拒绝',
      429 => '重复提交太快',
      409 => '重复提交',
      _ => '${res.data}(${res.statusCode})',
    };
  }

  Widget _buildItem(ThemeData theme, int index, PostSegmentModel item) {
    return Builder(
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.onInverseSurface,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.actionType != ActionType.full) ...[
                    Wrap(
                      runSpacing: 8,
                      spacing: 16,
                      children: [
                        Builder(
                          builder: (context) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: segmentWidget(
                                context,
                                theme,
                                isFirst: true,
                                item: item,
                              ),
                            );
                          },
                        ),
                        if (item.category != SegmentType.poi_highlight)
                          Builder(
                            builder: (context) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: segmentWidget(
                                  context,
                                  theme,
                                  isFirst: false,
                                  item: item,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Wrap(
                    runSpacing: 8,
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('分类: '),
                          PopupMenuButton<SegmentType>(
                            initialValue: item.category,
                            onSelected: (e) {
                              item.category = e;
                              List<ActionType> constraintList = e.toActionType;
                              if (!constraintList.contains(item.actionType)) {
                                item.actionType = constraintList.first;
                              }
                              switch (e) {
                                case SegmentType.poi_highlight:
                                  updateSegment(
                                    isFirst: false,
                                    item: item,
                                    value: item.segment.first,
                                  );
                                  break;
                                case SegmentType.exclusive_access:
                                  updateSegment(
                                    isFirst: true,
                                    item: item,
                                    value: 0,
                                  );
                                  break;
                                default:
                              }
                              (context as Element).markNeedsBuild();
                            },
                            itemBuilder: (context) => SegmentType.values
                                .map(
                                  (e) => PopupMenuItem<SegmentType>(
                                    value: e,
                                    child: Text(e.title),
                                  ),
                                )
                                .toList(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.category.title,
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  strutStyle: const StrutStyle(
                                    height: 1,
                                    leading: 0,
                                  ),
                                ),
                                Icon(
                                  MdiIcons.unfoldMoreHorizontal,
                                  size: MediaQuery.textScalerOf(
                                    context,
                                  ).scale(14),
                                  color: theme.colorScheme.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('行为类别: '),
                          PopupMenuButton<ActionType>(
                            initialValue: item.actionType,
                            onSelected: (e) {
                              item.actionType = e;
                              if (e == ActionType.full) {
                                updateSegment(
                                  isFirst: true,
                                  item: item,
                                  value: 0,
                                );
                              }
                              (context as Element).markNeedsBuild();
                            },
                            itemBuilder: (context) => ActionType.values
                                .map(
                                  (e) => PopupMenuItem<ActionType>(
                                    enabled: item.category.toActionType
                                        .contains(e),
                                    value: e,
                                    child: Text(e.title),
                                  ),
                                )
                                .toList(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.actionType.title,
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  strutStyle: const StrutStyle(
                                    height: 1,
                                    leading: 0,
                                  ),
                                ),
                                Icon(
                                  MdiIcons.unfoldMoreHorizontal,
                                  size: MediaQuery.textScalerOf(
                                    context,
                                  ).scale(14),
                                  color: theme.colorScheme.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 4,
              child: iconButton(
                context: context,
                size: 26,
                tooltip: '移除',
                icon: Icons.clear,
                onPressed: () {
                  setState(() {
                    list!.removeAt(index);
                  });
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 4,
              child: iconButton(
                context: context,
                size: 26,
                tooltip: '预览',
                icon: Icons.preview_outlined,
                onPressed: () async {
                  if (widget.plPlayerController.videoPlayerController != null) {
                    int start = max(
                      0,
                      (item.segment.first * 1000).round() - 2000,
                    );
                    await widget.plPlayerController.videoPlayerController!.seek(
                      Duration(milliseconds: start),
                    );
                    if (!widget
                        .plPlayerController
                        .videoPlayerController!
                        .state
                        .playing) {
                      await widget.plPlayerController.videoPlayerController!
                          .play();
                    }
                    if (start != 0) {
                      await Future.delayed(const Duration(seconds: 2));
                    }
                    widget.plPlayerController.videoPlayerController!.seek(
                      Duration(
                        milliseconds: (item.segment.second * 1000).round(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
