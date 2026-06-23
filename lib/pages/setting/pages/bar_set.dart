import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/reorder_mixin.dart';
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

class _BarSetPageState extends State<BarSetPage> with ReorderMixin {
  late final String key;
  late final String title;
  late final List<Pair<EnumWithLabel, bool>> list;
  late EdgeInsets padding;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> args = Get.arguments;
    key = args['key'];
    title = args['title'];
    final List? cache = GStorage.setting.get(key);
    list = (args['defaultBars'] as List<EnumWithLabel>)
        .map((e) => Pair(first: e, second: cache?.contains(e.index) ?? true))
        .toList();
    if (cache != null && cache.isNotEmpty) {
      final cacheIndex = {for (int i = 0; i < cache.length; i++) cache[i]: i};
      list.sort((a, b) {
        final indexA = cacheIndex[a.first.index] ?? cacheIndex.length;
        final indexB = cacheIndex[b.first.index] ?? cacheIndex.length;
        return indexA.compareTo(indexB);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewPad = MediaQuery.viewPaddingOf(context);
    padding = .only(top: 10, right: viewPad.right + 34, bottom: viewPad.bottom);
  }

  void saveEdit() {
    GStorage.setting.put(
      key,
      list.where((e) => e.second).map((e) => e.first.index).toList(),
    );
    SmartDialog.showToast('保存成功，下次启动时生效');
  }

  void onReset() {
    Get.back();
    GStorage.setting.delete(key);
    SmartDialog.showToast('重置成功，下次启动时生效');
  }

  void onReorderItem(int oldIndex, int newIndex) {
    list.insert(newIndex, list.removeAt(oldIndex));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('$title编辑'),
        actions: [
          TextButton(onPressed: onReset, child: const Text('重置')),
          TextButton(onPressed: saveEdit, child: const Text('保存')),
          const SizedBox(width: 12),
        ],
      ),
      body: ReorderableListView(
        onReorderItem: onReorderItem,
        proxyDecorator: proxyDecorator,
        footer: Padding(
          padding: padding,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Text('*长按拖动排序'),
          ),
        ),
        children: list
            .map(
              (e) => CheckboxListTile(
                key: ValueKey(e.hashCode),
                value: e.second,
                onChanged: (bool? value) {
                  e.second = value!;
                  setState(() {});
                },
                title: Text(e.first.label),
                secondary: const Icon(Icons.drag_indicator_rounded),
              ),
            )
            .toList(),
      ),
    );
  }
}
