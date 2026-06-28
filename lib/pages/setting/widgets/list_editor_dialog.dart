import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _addItem() {
    final value = _addController.text.trim();
    if (value.isEmpty) return;

    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), duration: const Duration(seconds: 2)),
        );
        return;
      }
    }

    if (!_items.contains(value)) {
      setState(() {
        _items.add(value);
        _controllers.add(TextEditingController(text: value));
        _addController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('该${widget.itemLabel}已存在'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _commitEdit(int index) {
    final value = _controllers[index].text.trim();
    if (value.isEmpty || value == _items[index]) {
      // Revert if empty or unchanged
      _controllers[index].text = _items[index];
      return;
    }

    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), duration: const Duration(seconds: 2)),
        );
        _controllers[index].text = _items[index];
        return;
      }
    }

    if (_items.contains(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('该${widget.itemLabel}已存在'),
          duration: const Duration(seconds: 2),
        ),
      );
      _controllers[index].text = _items[index];
      return;
    }

    setState(() {
      _items[index] = value;
    });
  }

  void _removeItem(int index) {
    _controllers[index].dispose();
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
                                  onSubmitted: (_) => _commitEdit(index),
                                  onTapOutside: (_) => _commitEdit(index),
                                )
                              : SelectableText(
                                  _items[index],
                                  style: theme.textTheme.bodyMedium,
                                ),
                          trailing: IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 20),
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
            // Commit any in-progress edits before saving
            for (int i = 0; i < _items.length; i++) {
              final value = _controllers[i].text.trim();
              if (value.isNotEmpty && value != _items[i]) {
                _items[i] = value;
              }
            }
            Get.back(result: _items);
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
