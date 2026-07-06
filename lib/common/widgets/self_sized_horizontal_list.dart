import 'package:PiliPlus/common/widgets/only_layout_widget.dart';
import 'package:flutter/material.dart';

class SelfSizedHorizontalList extends StatefulWidget {
  const SelfSizedHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.controller,
    this.padding,
  });

  final int itemCount;
  final EdgeInsets? padding;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final ScrollController? controller;

  @override
  State<SelfSizedHorizontalList> createState() =>
      _SelfSizedHorizontalListState();
}

class _SelfSizedHorizontalListState extends State<SelfSizedHorizontalList> {
  double? _height;

  @override
  Widget build(BuildContext context) {
    if (_height == null) {
      if (widget.itemCount == 0) {
        return const SizedBox.shrink();
      }
      return OnlyLayoutWidget(
        onPerformLayout: (Size size) {
          if (!mounted) return;
          _height = size.height;
          setState(() {});
        },
        child: Padding(
          padding: widget.padding ?? .zero,
          child: widget.itemBuilder(context, 0),
        ),
      );
    }

    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: .horizontal,
        padding: widget.padding,
        itemCount: widget.itemCount,
        controller: widget.controller,
        itemBuilder: widget.itemBuilder,
        separatorBuilder: widget.separatorBuilder,
      ),
    );
  }
}
