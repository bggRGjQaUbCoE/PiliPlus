abstract final class TextSimilarity {
  static final RegExp _ignored = RegExp(
    r'[\s\p{P}\p{S}]',
    unicode: true,
  );

  static String normalize(String value) =>
      value.trim().toLowerCase().replaceAll(_ignored, '');

  static double dice(String first, String second) {
    final a = normalize(first).runes.toList();
    final b = normalize(second).runes.toList();
    if (a.isEmpty || b.isEmpty) return 0;
    if (_sameRunes(a, b)) return 1;
    if (a.length < 2 || b.length < 2) return 0;

    final counts = <String, int>{};
    for (var index = 0; index < a.length - 1; index++) {
      final pair = '${a[index]}:${a[index + 1]}';
      counts[pair] = (counts[pair] ?? 0) + 1;
    }

    var intersection = 0;
    for (var index = 0; index < b.length - 1; index++) {
      final pair = '${b[index]}:${b[index + 1]}';
      final count = counts[pair] ?? 0;
      if (count > 0) {
        intersection++;
        counts[pair] = count - 1;
      }
    }
    return 2 * intersection / (a.length + b.length - 2);
  }

  static bool _sameRunes(List<int> first, List<int> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }
}

final class TextDeduplicator {
  final Set<String> _exact = <String>{};
  final List<String> _accepted = <String>[];

  void clear() {
    _exact.clear();
    _accepted.clear();
  }

  bool isDuplicate(
    String value, {
    required bool exact,
    required bool fuzzy,
    double threshold = 0.84,
    int minimumFuzzyLength = 6,
  }) {
    if (!exact && !fuzzy) return false;
    final normalized = TextSimilarity.normalize(value);
    if (normalized.isEmpty) return false;

    if (exact && _exact.contains(normalized)) return true;
    if (fuzzy && normalized.runes.length >= minimumFuzzyLength) {
      for (final accepted in _accepted) {
        if (accepted.runes.length >= minimumFuzzyLength &&
            TextSimilarity.dice(normalized, accepted) >= threshold) {
          return true;
        }
      }
    }

    _exact.add(normalized);
    _accepted.add(normalized);
    return false;
  }
}
