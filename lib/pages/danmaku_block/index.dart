import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/utils/storage.dart';

import '../../http/danmaku_block.dart';
import '../../models/user/danmaku_block.dart';
import '../../plugin/pl_player/controller.dart';
import 'package:PiliPlus/common/widgets/spring_physics.dart';

class DanmakuBlockPage extends StatefulWidget {
  const DanmakuBlockPage({super.key});

  @override
  State<DanmakuBlockPage> createState() => _DanmakuBlockPageState();
}

class _DanmakuBlockPageState extends State<DanmakuBlockPage> {
  final DanmakuBlockController _danmakuBlockController =
      Get.put(DanmakuBlockController());
  final ScrollController scrollController = ScrollController();
  late PlPlayerController plPlayerController;

  static const Map<int, String> ruleLabels = {
    0: '关键词',
    1: '正则',
    2: '用户',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _danmakuBlockController.queryDanmakuFilter();
    });
    plPlayerController = Get.arguments as PlPlayerController;
  }

  @override
  void dispose() {
    final regExp = RegExp(r'^/(.*)/$');
    List<Map<String, dynamic>> simpleRuleList = _danmakuBlockController
        .ruleTypes.values
        .expand((element) => element)
        .map<Map<String, dynamic>>((e) {
      //当正则表达式前后都有"/"时，去掉，避免RegExp解析错误
      if (e.type == 1) {
        String? filter = regExp.firstMatch(e.filter)?.group(1);
        if (filter != null) {
          e.filter = filter;
        }
      }
      return e.toMap();
    }).toList();
    // debugPrint("simpleRuleList:$simpleRuleList");
    plPlayerController.filterCount = simpleRuleList.length;
    for (var item in simpleRuleList) {
      switch (item['type']) {
        case 0:
          plPlayerController.dmFilterString.add(item['filter']);
          break;
        case 1:
          plPlayerController.dmRegExp
              .add(RegExp(item['filter'], caseSensitive: false));
          break;
        case 2:
          plPlayerController.dmUid.add(item['filter']);
          break;
      }
    }
    scrollController.dispose();
    GStorage.localCache.put(LocalCacheKey.danmakuFilterRule, simpleRuleList);
    super.dispose();
  }

  void _showAddDialog(int type) {
    final TextEditingController textController = TextEditingController();
    late String hintText;
    switch (type) {
      case 0:
        hintText = '输入过滤的关键词，其它类别请切换标签页后添加';
        break;
      case 1:
        hintText = '输入//之间的正则表达式，无需包含头尾的"/"';
        break;
      case 2:
        hintText = '输入经CRC32B（即小写16进制的CRC32）哈希后的用户UID';
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('添加新的${ruleLabels[type]}规则'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(hintText),
            TextField(
              controller: textController,
              autofocus: true,
              //decoration: InputDecoration(hintText: hintText),
            )
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('添加'),
              onPressed: () async {
                String filter = textController.text;
                if (filter.isNotEmpty) {
                  await _danmakuBlockController.danmakuFilterAdd(
                      filter: filter, type: type);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                } else {
                  SmartDialog.showToast('输入内容不能为空');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: TabBar(
            controller: _danmakuBlockController.tabController,
            dividerColor: Colors.transparent,
            tabs: [
              for (var i = 0; i < ruleLabels.length; i++)
                Obx(() => Tab(
                    text:
                        '${ruleLabels[i]}(${_danmakuBlockController.ruleTypes[i]!.length})')),
            ]),
      ),
      body: TabBarView(
        physics: customTabBarViewScrollPhysics,
        controller: _danmakuBlockController.tabController,
        children: [
          for (var i = 0; i < ruleLabels.length; i++)
            Obx(() => tabViewBuilder(i, _danmakuBlockController.ruleTypes[i]!)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(_danmakuBlockController.tabController.index);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget tabViewBuilder(int tabIndex, List<SimpleRule> list) {
    return ListView.builder(
      controller: scrollController,
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 100),
      itemBuilder: (BuildContext context, int listIndex) {
        return ListTile(
          title: Text(
            list[listIndex].filter,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _danmakuBlockController.danmakuFilterDel(
                    tabIndex, list[listIndex].id);
              }),
        );
      },
    );
  }
}

class DanmakuBlockController extends GetxController
    with GetTickerProviderStateMixin {
  RxList<Rule> danmakuRules = <Rule>[].obs;
  RxMap<int, List<SimpleRule>> ruleTypes = {
    0: <SimpleRule>[],
    1: <SimpleRule>[],
    2: <SimpleRule>[],
  }.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future queryDanmakuFilter() async {
    SmartDialog.showLoading(msg: '正在同步弹幕屏蔽规则……');
    var result = await DanmakuFilterHttp.danmakuFilter();
    SmartDialog.dismiss();
    if (result['status']) {
      if (result['data']?.rule != null) {
        danmakuRules.value = result['data']?.rule;
        danmakuRules.map((e) {
          SimpleRule simpleRule = SimpleRule(e.id!, e.type!, e.filter!);
          ruleTypes[e.type!]!.add(simpleRule);
        }).toList();
        ruleTypes.refresh();
      }
      SmartDialog.showToast(result['data'].toast);
    } else {
      SmartDialog.showToast(result['msg']);
    }
    return result;
  }

  Future danmakuFilterDel(int type, int id) async {
    SmartDialog.showLoading(msg: '正在删除弹幕屏蔽规则……');
    var result = await DanmakuFilterHttp.danmakuFilterDel(ids: id);
    SmartDialog.dismiss();
    if (result['status']) {
      danmakuRules.removeWhere((e) => e.id == id);
      ruleTypes[type]!.removeWhere((e) => e.id == id);
      ruleTypes.refresh();
      SmartDialog.showToast(result['msg']);
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  Future danmakuFilterAdd({required String filter, required int type}) async {
    SmartDialog.showLoading(msg: '正在添加弹幕屏蔽规则……');
    var result =
        await DanmakuFilterHttp.danmakuFilterAdd(filter: filter, type: type);
    SmartDialog.dismiss();
    if (result['status']) {
      Rule data = result['data'];
      danmakuRules.add(data);
      SimpleRule simpleRule = SimpleRule(data.id!, data.type!, data.filter!);
      ruleTypes[type]!.add(simpleRule);
      ruleTypes.refresh();
      SmartDialog.showToast('添加成功');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }
}
