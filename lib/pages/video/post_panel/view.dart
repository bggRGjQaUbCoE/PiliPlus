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
import 'package:PiliPlus/pages/common/common_collapse_slide_page.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
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
  VideoDetailController get videoDetailController =>
      widget.videoDetailController;
  PlPlayerController get plPlayerController => widget.plPlayerController;
  List<PostSegmentModel>? get list => videoDetailController.postList;

  late final double videoDuration =
      plPlayerController.durationSeconds.value.inMilliseconds / 1000;

  double get currentPos =>
      plPlayerController.position.value.inMilliseconds / 1000;

  @override
  Widget buildPage(ThemeData theme) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text('提交片段'),
        actions: [
          iconButton(
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
    return list?.isNotEmpty == true
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                controller: ScrollController(),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ...List.generate(
                      list!.length,
                      (index) => Stack(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (list![index].actionType !=
                                    ActionType.full) ...[
                                  Wrap(
                                    runSpacing: 8,
                                    spacing: 16,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: segmentWidget(
                                          theme,
                                          isFirst: true,
                                          index: index,
                                        ),
                                      ),
                                      if (list![index].category !=
                                          SegmentType.poi_highlight)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: segmentWidget(
                                            theme,
                                            isFirst: false,
                                            index: index,
                                          ),
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
                                          initialValue: list![index].category,
                                          onSelected: (item) {
                                            list![index].category = item;
                                            List<ActionType> constraintList =
                                                item.toActionType;
                                            if (!constraintList.contains(
                                                list![index].actionType)) {
                                              list![index].actionType =
                                                  constraintList.first;
                                            }
                                            switch (item) {
                                              case SegmentType.poi_highlight:
                                                updateSegment(
                                                  isFirst: false,
                                                  index: index,
                                                  value: list![index]
                                                      .segment
                                                      .first,
                                                );
                                                break;
                                              case SegmentType.exclusive_access:
                                                updateSegment(
                                                  isFirst: true,
                                                  index: index,
                                                  value: 0,
                                                );
                                                break;
                                              case _:
                                            }
                                            setState(() {});
                                          },
                                          itemBuilder: (context) => SegmentType
                                              .values
                                              .map((item) =>
                                                  PopupMenuItem<SegmentType>(
                                                    value: item,
                                                    child: Text(item.title),
                                                  ))
                                              .toList(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                list![index].category.title,
                                                style: TextStyle(
                                                  height: 1,
                                                  fontSize: 14,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                                strutStyle: const StrutStyle(
                                                  height: 1,
                                                  leading: 0,
                                                ),
                                              ),
                                              Icon(
                                                MdiIcons.unfoldMoreHorizontal,
                                                size: MediaQuery.textScalerOf(
                                                        context)
                                                    .scale(14),
                                                color:
                                                    theme.colorScheme.secondary,
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
                                          initialValue: list![index].actionType,
                                          onSelected: (item) {
                                            list![index].actionType = item;
                                            if (item == ActionType.full) {
                                              updateSegment(
                                                isFirst: true,
                                                index: index,
                                                value: 0,
                                              );
                                            }
                                            setState(() {});
                                          },
                                          itemBuilder: (context) => ActionType
                                              .values
                                              .map(
                                                (item) =>
                                                    PopupMenuItem<ActionType>(
                                                  enabled: list![index]
                                                      .category
                                                      .toActionType
                                                      .contains(item),
                                                  value: item,
                                                  child: Text(item.title),
                                                ),
                                              )
                                              .toList(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                list![index].actionType.title,
                                                style: TextStyle(
                                                  height: 1,
                                                  fontSize: 14,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                                strutStyle: const StrutStyle(
                                                  height: 1,
                                                  leading: 0,
                                                ),
                                              ),
                                              Icon(
                                                MdiIcons.unfoldMoreHorizontal,
                                                size: MediaQuery.textScalerOf(
                                                        context)
                                                    .scale(14),
                                                color:
                                                    theme.colorScheme.secondary,
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
                                if (widget.plPlayerController
                                        .videoPlayerController !=
                                    null) {
                                  int start = max(
                                    0,
                                    (list![index].segment.first * 1000)
                                            .round() -
                                        2000,
                                  );
                                  await widget
                                      .plPlayerController.videoPlayerController!
                                      .seek(
                                    Duration(milliseconds: start),
                                  );
                                  if (!widget.plPlayerController
                                      .videoPlayerController!.state.playing) {
                                    await widget.plPlayerController
                                        .videoPlayerController!
                                        .play();
                                  }
                                  if (start != 0) {
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                  }
                                  widget
                                      .plPlayerController.videoPlayerController!
                                      .seek(
                                    Duration(
                                      milliseconds:
                                          (list![index].segment.second * 1000)
                                              .round(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 88 + MediaQuery.paddingOf(context).bottom,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16 + MediaQuery.paddingOf(context).bottom,
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
                            style: TextStyle(
                              color: theme.colorScheme.outline,
                            ),
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
              )
            ],
          )
        : errorWidget();
  }

  void updateSegment({
    required bool isFirst,
    required int index,
    required double value,
  }) {
    if (isFirst) {
      list![index].segment.first = value;
    } else {
      list![index].segment.second = value;
    }
    if (list![index].category == SegmentType.poi_highlight ||
        list![index].actionType == ActionType.full) {
      list![index].segment.second = value;
    }
  }

  List<Widget> segmentWidget(
    ThemeData theme, {
    required int index,
    required bool isFirst,
  }) {
    String value = Utils.timeFormat(
        isFirst ? list![index].segment.first : list![index].segment.second);
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
          setState(() {
            updateSegment(
              isFirst: isFirst,
              index: index,
              value: currentPos,
            );
          });
        },
      ),
      const SizedBox(width: 5),
      iconButton(
        context: context,
        size: 26,
        tooltip: isFirst ? '视频开头' : '视频结尾',
        icon: isFirst ? Icons.first_page : Icons.last_page,
        onPressed: () {
          setState(() {
            updateSegment(
              isFirst: isFirst,
              index: index,
              value: isFirst ? 0 : videoDuration,
            );
          });
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
                  onChanged: (value) {
                    initV = value;
                  },
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
                List<num> split =
                    res.split(':').reversed.map((e) => num.parse(e)).toList();
                double duration = 0;
                for (int i = 0; i < split.length; i++) {
                  duration += split[i] * pow(60, i);
                }
                if (duration <= videoDuration) {
                  setState(() {
                    updateSegment(
                      isFirst: isFirst,
                      index: index,
                      value: duration,
                    );
                  });
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
        'userID': GStorage.blockUserID.toString(),
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
                list.map((e) => SegmentItemModel.fromJson(e)).toList());
          }
          plPlayerController.segmentList.value =
              videoDetailController.segmentProgressList ?? <Segment>[];
          if (videoDetailController.positionSubscription == null) {
            videoDetailController.initSkip();
          }
        } else {
          SmartDialog.showToast(
            '提交失败: ${switch (res.statusCode) {
              400 => '参数错误',
              403 => '被自动审核机制拒绝',
              429 => '重复提交太快',
              409 => '重复提交',
              _ => res.statusCode.toString()
            }}',
          );
        }
      },
    );
  }
}
