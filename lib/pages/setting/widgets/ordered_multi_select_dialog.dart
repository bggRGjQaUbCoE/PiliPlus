import 'package:PiliPlus/pages/setting/widgets/checkbox_num_list_tile.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderedMultiSelectDialog<T> extends StatefulWidget {
  final Iterable<T> initValues;
  final String title;
  final Map<T, String> values;

  const OrderedMultiSelectDialog({
    super.key,
    required this.initValues,
    required this.values,
    required this.title,
  });

  @override
  State<OrderedMultiSelectDialog<T>> createState() =>
      _OrderedMultiSelectDialogState<T>();
}

class _OrderedMultiSelectDialogState<T>
    extends State<OrderedMultiSelectDialog<T>> {
  late Map<T, int> _tempValues;

  @override
  void initState() {
    super.initState();
    _tempValues = {for (var (i, j) in widget.initValues.indexed) j: i + 1};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      title: Text(widget.title),
      contentPadding: const EdgeInsets.only(top: 12),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.values.entries.map((i) {
            return Builder(
              builder: (context) {
                return OrderedCheckboxListTile(
                  dense: true,
                  value: _tempValues[i.key],
                  title: Text(
                    i.value,
                    style: theme.textTheme.titleMedium!,
                  ),
                  onChanged: (value) {
                    if (value == null) {
                      _tempValues[i.key] = _tempValues.length + 1;
                      (context as Element).markNeedsBuild();
                    } else {
                      final pos = _tempValues.remove(i.key)!;
                      if (pos == _tempValues.length + 1) {
                        (context as Element).markNeedsBuild();
                      } else {
                        _tempValues.updateAll(
                          (key, value) => value > pos ? value - 1 : value,
                        );
                        setState(() {});
                      }
                    }
                  },
                );
              },
            );
          }).toList(),
        ),
      ),
      actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
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
            assert(_tempValues.values.isSorted((a, b) => a.compareTo(b)));
            Get.back(result: _tempValues.keys.toList());
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
