import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 一次选中的一个连续词及其在原文中的字符区间。
class _SelectedWord {
  final String word;
  final int start;
  final int end;
  const _SelectedWord({required this.word, required this.start, required this.end});
}

/// 滑动选词组件：把一段文字拆成一个个圆角方块，在方块上滑动/点击选中连续字符，
/// 一次连续的字符串作为一个词，通过 [onWordsChanged] 把当前所有已选词回调给父级。
///
/// 组件只维护「本次会话」的选中状态，不直接写任何存储。
class WordSelectBar extends StatefulWidget {
  final String text;
  final ValueChanged<List<String>> onWordsChanged;

  const WordSelectBar({
    super.key,
    required this.text,
    required this.onWordsChanged,
  });

  @override
  State<WordSelectBar> createState() => _WordSelectBarState();
}

class _WordSelectBarState extends State<WordSelectBar> {
  late final List<String> _chars;
  late final List<GlobalKey> _charKeys;

  final List<_SelectedWord> _selectedWords = [];
  final Set<int> _committedIndices = {};

  int? _dragStart;
  int? _dragCurrent;

  @override
  void initState() {
    super.initState();
    _chars = widget.text.characters.toList();
    _charKeys = List.generate(_chars.length, (_) => GlobalKey());
  }

  void _notify() {
    widget.onWordsChanged(_selectedWords.map((e) => e.word).toList());
  }

  /// 根据全局坐标命中字符方块，返回其 index，未命中返回 null。
  int? _hitTest(Offset globalPos) {
    for (int i = 0; i < _charKeys.length; i++) {
      final ctx = _charKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final topLeft = box.localToGlobal(Offset.zero);
      if ((topLeft & box.size).contains(globalPos)) return i;
    }
    return null;
  }

  void _onPointerDown(PointerDownEvent e) {
    final idx = _hitTest(e.position);
    if (idx != null) {
      setState(() {
        _dragStart = idx;
        _dragCurrent = idx;
      });
    }
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (_dragStart == null) return;
    final idx = _hitTest(e.position);
    if (idx != null && idx != _dragCurrent) {
      setState(() => _dragCurrent = idx);
    }
  }

  void _onPointerUp(PointerUpEvent e) {
    final start = _dragStart;
    final end = _dragCurrent;
    _dragStart = null;
    _dragCurrent = null;
    if (start == null) return;

    final lo = math.min(start, end ?? start);
    final hi = math.max(start, end ?? start);
    final word = _chars.sublist(lo, hi + 1).join();
    if (word.trim().isEmpty) return;

    setState(() {
      _selectedWords.add(_SelectedWord(word: word, start: lo, end: hi));
      _recomputeCommitted();
    });
    _notify();
  }

  void _recomputeCommitted() {
    _committedIndices.clear();
    for (final sw in _selectedWords) {
      for (int i = sw.start; i <= sw.end; i++) {
        _committedIndices.add(i);
      }
    }
  }

  void _removeWord(_SelectedWord sw) {
    setState(() {
      _selectedWords.remove(sw);
      _recomputeCommitted();
    });
    _notify();
  }

  bool _isInDragRange(int index) {
    final start = _dragStart;
    final current = _dragCurrent;
    if (start == null || current == null) return false;
    final lo = math.min(start, current);
    final hi = math.max(start, current);
    return index >= lo && index <= hi;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_chars.isEmpty) {
      return Text(
        '无可用文字',
        style: TextStyle(color: colorScheme.outline, fontSize: 14),
      );
    }

    final chip = _selectedWords.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final sw in _selectedWords)
                  InputChip(
                    label: Text(sw.word),
                    visualDensity: VisualDensity.compact,
                    onDeleted: () => _removeWord(sw),
                  ),
              ],
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        chip,
        Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          onPointerCancel: (_) {
            _dragStart = null;
            _dragCurrent = null;
          },
          child: Wrap(
            spacing: 1,
            runSpacing: 1,
            children: [
              for (int i = 0; i < _chars.length; i++) _buildChar(i, colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChar(int index, ColorScheme colorScheme) {
    final ch = _chars[index];
    final committed = _committedIndices.contains(index);
    final dragging = _isInDragRange(index);

    Color bg;
    Color fg;
    Border? border;
    if (committed) {
      bg = colorScheme.primary.withValues(alpha: 0.16);
      fg = colorScheme.primary;
      border = Border.all(color: colorScheme.primary.withValues(alpha: 0.5));
    } else if (dragging) {
      bg = colorScheme.primary.withValues(alpha: 0.28);
      fg = colorScheme.primary;
    } else {
      bg = colorScheme.surfaceContainerHighest;
      fg = colorScheme.onSurface;
    }

    return Container(
      key: _charKeys[index],
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: border,
      ),
      child: Text(
        ch,
        style: TextStyle(
          fontSize: 15,
          color: fg,
          height: 1,
          fontWeight: committed || dragging ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
