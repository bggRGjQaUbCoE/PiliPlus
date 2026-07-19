class LatestSuggestionLoader<T> {
  int _generation = 0;
  String _query = '';

  void updateQuery(String query) {
    _query = query;
    invalidate();
  }

  void invalidate() {
    _generation++;
  }

  Future<T?> load(
    String query,
    Future<T> Function() operation,
  ) async {
    if (query.isEmpty || query != _query) {
      return null;
    }
    final generation = ++_generation;
    final result = await operation();
    return generation == _generation && query == _query ? result : null;
  }
}
