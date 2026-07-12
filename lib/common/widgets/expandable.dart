import 'package:PiliPlus/common/widgets/animated_multi_height.dart';
import 'package:flutter/material.dart';

class ExpandablePanel extends StatelessWidget {
  final bool expand;

  final Widget collapsed;

  final Widget expanded;

  const ExpandablePanel({
    super.key,
    required this.expand,
    required this.collapsed,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedCross(
      alignment: .topLeft,
      firstChild: collapsed,
      secondChild: expanded,
      sizeCurve: Curves.linear,
      crossFadeState: expand ? .showSecond : .showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}

/// ref [AnimatedCrossFade]
class _AnimatedCross extends StatefulWidget {
  const _AnimatedCross({
    required this.firstChild,
    required this.secondChild,
    this.sizeCurve = Curves.linear,
    this.alignment = Alignment.topCenter,
    required this.crossFadeState,
    required this.duration,
  });

  final Widget firstChild;

  final Widget secondChild;

  final CrossFadeState crossFadeState;

  final Duration duration;

  final Curve sizeCurve;

  final AlignmentGeometry alignment;

  @override
  State<_AnimatedCross> createState() => _AnimatedCrossState();
}

class _AnimatedCrossState extends State<_AnimatedCross> {
  late bool _showFirst;
  AnimationStatus? _status;

  @override
  void initState() {
    super.initState();
    switch (widget.crossFadeState) {
      case .showFirst:
        _showFirst = true;
      case .showSecond:
        _showFirst = false;
    }
  }

  @override
  void didUpdateWidget(_AnimatedCross oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.crossFadeState != oldWidget.crossFadeState) {
      switch (widget.crossFadeState) {
        case .showFirst:
          _status = .reverse;
        case .showSecond:
          _status = .forward;
      }
      _showFirst = false;
    }
  }

  void _onEnd() {
    if (_status == .reverse) {
      _showFirst = true;
    }
    setState(() {});
  }

  Widget get firstChild => _widgetBuilder(_showFirst, widget.firstChild);

  Widget get secondChild => _widgetBuilder(!_showFirst, widget.secondChild);

  static Widget _widgetBuilder(bool visible, Widget child) =>
      Opacity(opacity: visible ? 1.0 : 0.0, child: child);

  @override
  Widget build(BuildContext context) {
    const Key kFirstChildKey = ValueKey<CrossFadeState>(.showFirst);
    const Key kSecondChildKey = ValueKey<CrossFadeState>(.showSecond);

    final bool expand;
    final Key topKey;
    Widget topChild;
    final Key bottomKey;
    Widget bottomChild;

    switch (widget.crossFadeState) {
      case .showFirst:
        expand = false;
        topKey = kFirstChildKey;
        topChild = firstChild;
        bottomKey = kSecondChildKey;
        bottomChild = secondChild;
      case .showSecond:
        expand = true;
        topKey = kSecondChildKey;
        topChild = secondChild;
        bottomKey = kFirstChildKey;
        bottomChild = firstChild;
    }

    return AnimatedMultiHeight(
      duration: widget.duration,
      curve: widget.sizeCurve,
      onEnd: _onEnd,
      expand: expand,
      child: AnimatedCrossFade.defaultLayoutBuilder(
        topChild,
        topKey,
        bottomChild,
        bottomKey,
      ),
    );
  }
}
