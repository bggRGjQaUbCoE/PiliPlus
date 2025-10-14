import 'dart:math';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/models/common/search/video_search_type.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/search_panel/controller.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class SearchVideoController
    extends SearchPanelController<SearchVideoData, SearchVideoItemModel> {
  SearchVideoController({
    required super.keyword,
    required super.searchType,
    required super.tag,
  });

  late bool hasJump2Video = false;

  @override
  void onInit() {
    super.onInit();
    videoDurationType = VideoDurationType.all;
    videoZoneType = VideoZoneType.all;
    DateTime now = DateTime.now();
    pubBeginDate = DateTime(now.year, now.month, 1, 0, 0, 0);
    pubEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    jump2Video();
  }

  @override
  List<SearchVideoItemModel>? getDataList(SearchVideoData response) {
    return response.list;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<SearchVideoData> response) {
    searchResultController?.count[searchType.index] =
        response.response.numResults ?? 0;
    if (searchType == SearchType.video && !hasJump2Video && isRefresh) {
      hasJump2Video = true;
      onPushDetail(response.response.list);
    }
    return false;
  }

  void onPushDetail(List<SearchVideoItemModel>? resultList) {
    try {
      int? aid = int.tryParse(keyword);
      if (aid != null && resultList?.firstOrNull?.aid == aid) {
        PiliScheme.videoPush(aid, null, showDialog: false);
      }
    } catch (_) {}
  }

  void jump2Video() {
    if (IdUtils.avRegexExact.hasMatch(keyword)) {
      hasJump2Video = true;
      PiliScheme.videoPush(
        int.parse(keyword.substring(2)),
        null,
        showDialog: false,
      );
    } else if (IdUtils.bvRegexExact.hasMatch(keyword)) {
      hasJump2Video = true;
      PiliScheme.videoPush(null, keyword, showDialog: false);
    }
  }

  final Rx<ArchiveFilterType> selectedType = ArchiveFilterType.totalrank.obs;
  VideoPubTimeType? pubTimeType = VideoPubTimeType.all;
  late DateTime pubBeginDate;
  late DateTime pubEndDate;
  bool customPubBeginDate = false;
  bool customPubEndDate = false;

  void onShowFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final theme = Theme.of(context);
          Widget dateWidget([bool isFirst = true]) {
            final enable =
                pubTimeType == null &&
                (isFirst ? customPubBeginDate : customPubEndDate);
            return SearchText(
              text: DateFormatUtils.longFormat.format(
                isFirst ? pubBeginDate : pubEndDate,
              ),
              textAlign: TextAlign.center,
              onTap: (text) {
                showDatePicker(
                  context: context,
                  initialDate: isFirst ? pubBeginDate : pubEndDate,
                  firstDate: isFirst ? DateTime(2009, 6, 26) : pubBeginDate,
                  lastDate: isFirst ? pubEndDate : DateTime.now(),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    if (isFirst) {
                      customPubBeginDate = true;
                      pubBeginDate = selectedDate;
                    } else {
                      customPubEndDate = true;
                      pubEndDate = selectedDate;
                    }
                    pubTimeType = null;
                    SmartDialog.dismiss();
                    pubBegin =
                        DateTime(
                          pubBeginDate.year,
                          pubBeginDate.month,
                          pubBeginDate.day,
                          0,
                          0,
                          0,
                        ).millisecondsSinceEpoch ~/
                        1000;
                    pubEnd =
                        DateTime(
                          pubEndDate.year,
                          pubEndDate.month,
                          pubEndDate.day,
                          23,
                          59,
                          59,
                        ).millisecondsSinceEpoch ~/
                        1000;
                    setState(() {});
                    onSortSearch(getBack: false);
                  }
                });
              },
              bgColor: enable
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              textColor: enable
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.outline.withValues(alpha: 0.8),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: 100 + MediaQuery.viewPaddingOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Text('发布时间', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: VideoPubTimeType.values.map(
                    (e) {
                      final isCurr = e == pubTimeType;
                      return SearchText(
                        text: e.label,
                        onTap: (text) {
                          pubTimeType = e;
                          DateTime now = DateTime.now();
                          if (e == VideoPubTimeType.all) {
                            pubBegin = null;
                            pubEnd = null;
                          } else {
                            pubBegin =
                                DateTime(
                                  now.year,
                                  now.month,
                                  now.day -
                                      (e == VideoPubTimeType.day
                                          ? 0
                                          : e == VideoPubTimeType.week
                                          ? 6
                                          : 179),
                                  0,
                                  0,
                                  0,
                                ).millisecondsSinceEpoch ~/
                                1000;
                            pubEnd =
                                DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  23,
                                  59,
                                  59,
                                ).millisecondsSinceEpoch ~/
                                1000;
                          }
                          onSortSearch();
                        },
                        bgColor: isCurr
                            ? theme.colorScheme.secondaryContainer
                            : null,
                        textColor: isCurr
                            ? theme.colorScheme.onSecondaryContainer
                            : null,
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: dateWidget()),
                    const Text('至', style: TextStyle(fontSize: 13)),
                    Expanded(child: dateWidget(false)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('内容时长', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: VideoDurationType.values.map(
                    (e) {
                      final isCurr = e == videoDurationType;
                      return SearchText(
                        text: e.label,
                        onTap: (_) {
                          videoDurationType = e;
                          onSortSearch(label: e.label);
                        },
                        bgColor: isCurr
                            ? theme.colorScheme.secondaryContainer
                            : null,
                        textColor: isCurr
                            ? theme.colorScheme.onSecondaryContainer
                            : null,
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 20),
                const Text('内容分区', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: VideoZoneType.values.map(
                    (e) {
                      final isCurr = e == videoZoneType;
                      return SearchText(
                        text: e.label,
                        onTap: (_) {
                          videoZoneType = e;
                          onSortSearch(label: e.label);
                        },
                        bgColor: isCurr
                            ? theme.colorScheme.secondaryContainer
                            : null,
                        textColor: isCurr
                            ? theme.colorScheme.onSecondaryContainer
                            : null,
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
