import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:flutter/material.dart';

class TVKeyboard extends StatefulWidget {
  const TVKeyboard({
    super.key,
    required this.onTextChanged,
    this.onConfirm,
  });

  final ValueChanged<String> onTextChanged;
  final ValueChanged<String>? onConfirm;

  @override
  State<TVKeyboard> createState() => _TVKeyboardState();
}

class _TVKeyboardState extends State<TVKeyboard> {
  String _text = '';

  static const _keys = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U',
    'V', 'W', 'X', 'Y', 'Z', '0', '1',
    '2', '3', '4', '5', '6', '7', '8',
    '9',
  ];

  void _onKeyTap(String key) {
    setState(() => _text += key);
    widget.onTextChanged(_text);
  }

  void _onBackspace() {
    if (_text.isNotEmpty) {
      setState(() => _text = _text.substring(0, _text.length - 1));
      widget.onTextChanged(_text);
    }
  }

  void _onClear() {
    setState(() => _text = '');
    widget.onTextChanged(_text);
  }

  void _onSpace() {
    setState(() => _text += ' ');
    widget.onTextChanged(_text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _text.isEmpty ? '请输入搜索关键词' : _text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: _text.isEmpty
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ..._keys.map(
              (key) => _KeyButton(
                label: key,
                onTap: () => _onKeyTap(key),
              ),
            ),
            _KeyButton(label: '空格', onTap: _onSpace, width: 72),
            _KeyButton(label: '删除', onTap: _onBackspace, width: 72),
            _KeyButton(label: '清空', onTap: _onClear, width: 72),
            _KeyButton(
              label: '搜索',
              onTap: () => widget.onConfirm?.call(_text),
              width: 72,
              isPrimary: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.label,
    required this.onTap,
    this.width = 44,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final double width;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TVFocusWrapper(
      onSelect: onTap,
      scaleFactor: 1.15,
      borderRadius: 8,
      child: Container(
        width: width,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
