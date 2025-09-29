import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class BarSetPage extends StatefulWidget {
  const BarSetPage({super.key});

  @override
  State<BarSetPage> createState() => _BarSetPageState();
}

class _BarSetPageState extends State<BarSetPage> {
  late final List<EnumWithLabel> defaultBars;
  late final Map<int, int> barIndex;
  late final String key;
  late final String title;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> args = Get.arguments;
    key = args['key'];
    title = args['title'] ?? '';
    defaultBars = List<EnumWithLabel>.from(args['defaultBars']);
    List? bars = GStorage.setting.get(key);
    if (bars != null) {
      barIndex = {for (var (k, v) in bars.indexed) v: k};

      // 对 tabData 进行排序
      defaultBars.sort((a, b) {
        final indexA = barIndex[a.index] ?? barIndex.length;
        final indexB = barIndex[b.index] ?? barIndex.length;
        return indexA.compareTo(indexB);
      });
    } else {
      barIndex = {for (var (k, v) in defaultBars.indexed) v.index: k};
    }
  }

  void saveEdit() {
    List<int> sortedBar = defaultBars
        .where((i) => barIndex.containsKey(i.index))
        .map((i) => i.index)
        .toList();
    GStorage.setting.put(key, sortedBar);
    SmartDialog.showToast('保存成功，下次启动时生效');
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      defaultBars.insert(newIndex, defaultBars.removeAt(oldIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('$title编辑'),
        actions: [
          TextButton(onPressed: saveEdit, child: const Text('保存')),
          const SizedBox(width: 12),
        ],
      ),
      body: ReorderableListView(
        onReorder: onReorder,
        footer: Padding(
          padding:
              MediaQuery.viewPaddingOf(context).copyWith(top: 0, left: 0) +
              const EdgeInsets.only(right: 34, top: 10),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Text('*长按拖动排序'),
          ),
        ),
        children: defaultBars
            .map(
              (i) => CheckboxListTile(
                key: Key(i.label),
                value: barIndex.containsKey(i.index),
                onChanged: (bool? value) {
                  if (value!) {
                    barIndex[i.index] = -1;
                  } else {
                    barIndex.remove(i.index);
                  }
                  setState(() {});
                },
                title: Text(i.label),
                secondary: const Icon(Icons.drag_indicator_rounded),
              ),
            )
            .toList(),
      ),
    );
  }
}
