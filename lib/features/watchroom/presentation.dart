/// Preserve the selected content when room membership or responsive layout
/// changes the tab list. A newly joined room is selected immediately.
abstract final class RoomTabs {
  static int selectedIndex(
    List<String> previous,
    List<String> next,
    int index,
  ) {
    if (next.isEmpty) return 0;
    if (next.contains('放映厅') && !previous.contains('放映厅'))
      return next.indexOf('放映厅');
    final selected = index >= 0 && index < previous.length
        ? previous[index]
        : null;
    if (selected != null && next.contains(selected))
      return next.indexOf(selected);
    return previous.isEmpty ? index.clamp(0, next.length - 1) : 0;
  }
}
