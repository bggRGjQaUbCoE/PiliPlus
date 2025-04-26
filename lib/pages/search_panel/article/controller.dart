import 'dart:math';

import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/search_panel/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class SearchArticleController
    extends SearchPanelController<SearchArticleModel, SearchArticleItemModel> {
  SearchArticleController({
    required super.keyword,
    required super.searchType,
    required super.tag,
  });

  @override
  void onInit() {
    super.onInit();
    jump2Article();
  }

  void jump2Article() {
    String? cvid = RegExp(r'^cv(id)?(\d+)$', caseSensitive: false)
        .firstMatch(keyword)
        ?.group(2);
    if (cvid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(
          '/articlePage',
          parameters: {
            'id': cvid,
            'type': 'read',
          },
        );
      });
    }
  }

  // sort
  late final List orderFiltersList = [
    {'label': '综合排序', 'value': 0, 'order': 'totalrank'},
    {'label': '最新发布', 'value': 1, 'order': 'pubdate'},
    {'label': '最多点击', 'value': 2, 'order': 'click'},
    {'label': '最多喜欢', 'value': 3, 'order': 'attention'},
    {'label': '最多评论', 'value': 4, 'order': 'scores'},
  ];
  late final List zoneFiltersList = [
    {'label': '全部分区', 'value': 0, 'categoryId': 0},
    {'label': '动画', 'value': 1, 'categoryId': 2},
    {'label': '游戏', 'value': 2, 'categoryId': 1},
    {'label': '影视', 'value': 3, 'categoryId': 28},
    {'label': '生活', 'value': 4, 'categoryId': 3},
    {'label': '兴趣', 'value': 5, 'categoryId': 29},
    {'label': '轻小说', 'value': 6, 'categoryId': 16},
    {'label': '科技', 'value': 7, 'categoryId': 17},
    {'label': '笔记', 'value': 8, 'categoryId': 41},
  ];
  RxInt currentOrderFilterval = 0.obs;
  RxInt currentZoneFilterval = 0.obs;

  onShowFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxWidth: min(640, min(Get.width, Get.height)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: 80 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('排序', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: orderFiltersList
                    .map(
                      (item) => SearchText(
                        text: item['label'],
                        onTap: (_) async {
                          Get.back();
                          currentOrderFilterval.value = item['value'];
                          SmartDialog.dismiss();
                          SmartDialog.showToast("「${item['label']}」的筛选结果");
                          order.value = item['order'];
                          SmartDialog.showLoading(msg: 'loading');
                          await onReload();
                          SmartDialog.dismiss();
                        },
                        bgColor: item['value'] == currentOrderFilterval.value
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : null,
                        textColor: item['value'] == currentOrderFilterval.value
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : null,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('分区', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: zoneFiltersList
                    .map(
                      (item) => SearchText(
                        text: item['label'],
                        onTap: (_) async {
                          Get.back();
                          currentZoneFilterval.value = item['value'];
                          SmartDialog.dismiss();
                          SmartDialog.showToast("「${item['label']}」的筛选结果");
                          categoryId = item['categoryId'];
                          SmartDialog.showLoading(msg: 'loading');
                          await onReload();
                          SmartDialog.dismiss();
                        },
                        bgColor: item['value'] == currentZoneFilterval.value
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : null,
                        textColor: item['value'] == currentZoneFilterval.value
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
