import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/segment_progress_bar.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/pages/common/common_collapse_slide_page.dart';
import 'package:PiliPlus/pages/video/detail/index.dart';
import 'package:PiliPlus/plugin/pl_player/index.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<PostSegmentModel>? get list => videoDetailController.list;

  @override
  Widget get buildPage => Scaffold(
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
                        second: plPlayerController.positionSeconds.value,
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
        body: enableSlide ? slideList() : buildList,
      );

  @override
  Widget get buildList => list?.isNotEmpty == true
      ? Stack(
          children: [
            SingleChildScrollView(
              controller: ScrollController(),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(
                    list!.length,
                    (index) => Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 5,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                            borderRadius: BorderRadius.circular(12),
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
                                        isFirst: true,
                                        index: index,
                                      ),
                                    ),
                                    if (list![index].category !=
                                        SegmentType.poi_highlight)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: segmentWidget(
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
                                        onSelected: (item) async {
                                          list![index].category = item;
                                          List<ActionType> constraintList =
                                              segmentType2ActionType(item);
                                          if (constraintList
                                              .contains(list![index].actionType)
                                              .not) {
                                            list![index].actionType =
                                                constraintList.first;
                                          }
                                          switch (item) {
                                            case SegmentType.poi_highlight:
                                              updateSegment(
                                                isFirst: false,
                                                index: index,
                                                value:
                                                    list![index].segment.first,
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              strutStyle: StrutStyle(
                                                height: 1,
                                                leading: 0,
                                              ),
                                            ),
                                            Icon(
                                              MdiIcons.unfoldMoreHorizontal,
                                              size: MediaQuery.textScalerOf(
                                                      context)
                                                  .scale(14),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                                        onSelected: (item) async {
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
                                                enabled: segmentType2ActionType(
                                                        list![index].category)
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              strutStyle: StrutStyle(
                                                height: 1,
                                                leading: 0,
                                              ),
                                            ),
                                            Icon(
                                              MdiIcons.unfoldMoreHorizontal,
                                              size: MediaQuery.textScalerOf(
                                                      context)
                                                  .scale(14),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                          top: 10,
                          right: 21,
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('确定无误再提交'),
                      actions: [
                        TextButton(
                          onPressed: Get.back,
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Request().post(
                              '${GStorage.blockServer}/api/skipSegments',
                              queryParameters: {
                                'videoID': videoDetailController.bvid,
                                'cid': videoDetailController.cid.value,
                                'userID': GStorage.blockUserID,
                                'userAgent': Constants.userAgent,
                                'videoDuration': plPlayerController
                                    .durationSeconds.value.inSeconds,
                              },
                              data: {
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
                            ).then(
                              (res) {
                                if (res.statusCode == 200) {
                                  Get.back();
                                  SmartDialog.showToast('提交成功');
                                  list?.clear();
                                  videoDetailController.handleSBData(res);
                                  plPlayerController.segmentList.value =
                                      videoDetailController
                                              .segmentProgressList ??
                                          <Segment>[];
                                  if (videoDetailController
                                          .positionSubscription ==
                                      null) {
                                    videoDetailController.initSkip();
                                  }
                                } else {
                                  SmartDialog.showToast(
                                    '提交失败: ${{
                                          400: '参数错误',
                                          403: '被自动审核机制拒绝',
                                          429: '重复提交太快',
                                          409: '重复提交'
                                        }[res.statusCode] ?? res.statusCode}',
                                  );
                                }
                              },
                            );
                          },
                          child: const Text('确定提交'),
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(Icons.check),
              ),
            )
          ],
        )
      : errorWidget();

  void updateSegment({
    required bool isFirst,
    required int index,
    required int value,
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

  List<Widget> segmentWidget({
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
        tooltip: '使用当前位置时间',
        icon: Icons.my_location,
        onPressed: () {
          setState(() {
            updateSegment(
              isFirst: isFirst,
              index: index,
              value: plPlayerController.positionSeconds.value,
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
          showDialog(
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
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[\d:]+'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: initV),
                    child: Text('确定'),
                  ),
                ],
              );
            },
          ).then((res) {
            if (res != null) {
              try {
                List<int> split = (res as String)
                    .split(':')
                    .toList()
                    .reversed
                    .toList()
                    .map((e) => int.parse(e))
                    .toList();
                int duration = 0;
                for (int i = 0; i < split.length; i++) {
                  duration += split[i] * pow(60, i).toInt();
                }
                if (duration <=
                    plPlayerController.durationSeconds.value.inSeconds) {
                  setState(() {
                    updateSegment(
                      isFirst: isFirst,
                      index: index,
                      value: duration,
                    );
                  });
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          });
        },
      ),
    ];
  }
}
