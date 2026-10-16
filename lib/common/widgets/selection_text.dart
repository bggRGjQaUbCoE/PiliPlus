import 'package:PiliPlus/utils/extension/selectable_region_ext.dart';
import 'package:material_ui/material_ui.dart';

class SelectionText extends StatelessWidget {
  const SelectionText(
    String this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.contextMenuBuilder = openUrlMenuBuilder,
  }) : textSpan = null;

  const SelectionText.rich(
    InlineSpan this.textSpan, {
    super.key,
    this.style,
    this.textAlign,
    this.contextMenuBuilder = openUrlMenuBuilder,
  }) : data = null;

  final String? data;
  final InlineSpan? textSpan;
  final TextStyle? style;
  final TextAlign? textAlign;
  final SelectableRegionContextMenuBuilder? contextMenuBuilder;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      contextMenuBuilder: contextMenuBuilder,
      child: Text.rich(
        style: style,
        textAlign: textAlign,
        TextSpan(
          text: data,
          children: textSpan != null ? <InlineSpan>[textSpan!] : null,
        ),
      ),
    );
  }
}

Widget openUrlMenuBuilder(_, SelectableRegionState state) {
  final buttonItems = state.contextMenuButtonItems;
  state.addLaunchMenuIfNeeded(buttonItems, index: 3);
  return AdaptiveTextSelectionToolbar.buttonItems(
    buttonItems: buttonItems,
    anchors: state.contextMenuAnchors,
  );
}
