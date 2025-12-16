extension NullableIterableExt<T> on Iterable<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension IterableExt<T> on Iterable<T> {
  T? reduceOrNull(T Function(T value, T element) combine) {
    Iterator<T> iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }
    T value = iterator.current;
    while (iterator.moveNext()) {
      value = combine(value, iterator.current);
    }
    return value;
  }
}

extension ListExt<T> on List<T> {
  T? getOrNull(int index) {
    if (index < 0 || index >= length) {
      return null;
    }
    return this[index];
  }

  bool removeFirstWhere(bool Function(T) test) {
    final index = indexWhere(test);
    if (index != -1) {
      removeAt(index);
      return true;
    }
    return false;
  }

  List<R> fromCast<R>() {
    return List<R>.from(this);
  }

  T findClosestTarget(
    bool Function(T) test,
    T Function(T, T) combine,
  ) {
    return where(test).reduceOrNull(combine) ?? reduce(combine);
  }
}
