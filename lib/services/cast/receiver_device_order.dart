List<T> preserveDiscoveredOrderWithActive<T>({
  required Iterable<T> discovered,
  required T? active,
  required String Function(T) keyOf,
}) {
  final seen = <String>{};
  final result = <T>[];
  for (final item in discovered) {
    if (seen.add(keyOf(item))) {
      result.add(item);
    }
  }
  if (active != null && seen.add(keyOf(active))) {
    result.add(active);
  }
  return result;
}

Map<String, T> preserveDiscoveredMapOrderWithActive<T>(
  Map<String, T> discovered, {
  required String? activeKey,
  required T? active,
}) {
  if (activeKey != null &&
      active != null &&
      !discovered.containsKey(activeKey)) {
    return {...discovered, activeKey: active};
  }
  return discovered;
}
