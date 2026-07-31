List<T> dedupeByCid<T>(List<T> entries, int Function(T) cidOf) {
  final seen = <int>{};
  final result = <T>[];
  for (final e in entries) {
    if (seen.add(cidOf(e))) {
      result.add(e);
    }
  }
  return result;
}
