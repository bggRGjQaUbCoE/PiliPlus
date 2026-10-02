import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

/// A dialog for editing a list of strings with add/remove/edit functionality
/// Follows Material Design 3 style
class ListEditorDialog extends StatefulWidget {
  final String title;
  final List<String> initialItems;
  final String hintText;
  final String itemLabel;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String)? validator;
  // When false, existing items use SelectableText instead of editable TextField
  final bool allowEdit;

  const ListEditorDialog({
    super.key,
    required this.title,
    required this.initialItems,
    this.hintText = '点击添加按钮添加项目',
    this.itemLabel = '项目',
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.allowEdit = true,
  });

  @override
  State<ListEditorDialog> createState() => _ListEditorDialogState();
}

class _ListEditorDialogState extends State<ListEditorDialog> {
  late List<String> _items;
  late List<TextEditingController> _controllers;
  final TextEditingController _addController = TextEditingController();
  final FocusNode _addFocusNode = FocusNode();
  final Set<int> _invalidEditIndexes = {};

  @override
  void initState() {
    super.initState();
    _items = List<String>.from(widget.initialItems);
    _controllers = _items.map((e) => TextEditingController(text: e)).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _addController.dispose();
    _addFocusNode.dispose();
    super.dispose();
  }

  bool _addItem() {
    final value = _addController.text.trim();
    if (value.isEmpty) return true;

    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), duration: const Duration(seconds: 2)),
        );
        return false;
      }
    }

    if (!_items.contains(value)) {
      setState(() {
        _items.add(value);
        _controllers.add(TextEditingController(text: value));
        _addController.clear();
      });
      return true;
    } else {
      _showDuplicateToast();
      return false;
    }
  }

  bool _commitEdit(int index) {
    final value = _controllers[index].text.trim();
    if (value.isEmpty) {
      _controllers[index].text = _items[index];
      _invalidEditIndexes.remove(index);
      return true;
    }
    if (value == _items[index]) {
      _invalidEditIndexes.remove(index);
      return true;
    }

    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), duration: const Duration(seconds: 2)),
        );
        _invalidEditIndexes.add(index);
        return false;
      }
    }

    if (_items.indexOf(value) case final duplicateIndex
        when duplicateIndex != -1 && duplicateIndex != index) {
      _showDuplicateToast();
      _invalidEditIndexes.add(index);
      return false;
    }

    _invalidEditIndexes.remove(index);
    setState(() {
      _items[index] = value;
    });
    return true;
  }

  void _showDuplicateToast() {
    SmartDialog.showToast('该${widget.itemLabel}已存在');
  }

  void _removeItem(int index) {
    _controllers[index].dispose();
    _invalidEditIndexes.clear();
    setState(() {
      _items.removeAt(index);
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _addController,
                    focusNode: _addFocusNode,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _addItem,
                  tooltip: '添加',
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    '暂无${widget.itemLabel}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              )
            else
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(
                            left: 12,
                            right: 4,
                            top: 4,
                            bottom: 4,
                          ),
                          title: widget.allowEdit
                              ? TextField(
                                  controller: _controllers[index],
                                  keyboardType: widget.keyboardType,
                                  inputFormatters: widget.inputFormatters,
                                  style: theme.textTheme.bodyMedium,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (_) {
                                    _invalidEditIndexes.remove(index);
                                  },
                                  onSubmitted: (_) => _commitEdit(index),
                                  onTapOutside: (_) => _commitEdit(index),
                                )
                              : SelectableText(
                                  _items[index],
                                  style: theme.textTheme.bodyMedium,
                                ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => _removeItem(index),
                            tooltip: '删除',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: theme.colorScheme.outline),
          ),
        ),
        FilledButton(
          onPressed: () {
            // A focus-loss validation may run before this button callback.
            if (_invalidEditIndexes.isNotEmpty) {
              SmartDialog.showToast('存在未修正的编辑项');
              return;
            }
            // Commit any in-progress edits before saving
            for (int i = 0; i < _items.length; i++) {
              if (!_commitEdit(i)) return;
            }
            // Include text that has not been explicitly added yet.
            if (!_addItem()) return;
            Get.back(result: _items);
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
