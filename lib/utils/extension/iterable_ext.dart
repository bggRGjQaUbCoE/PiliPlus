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

  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ListExt<T> on List<T> {
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

  /// from [algorithms.lowerBoundBy].
  int lowerBoundByKey<K extends Comparable<K>>(
    K Function(T element) keyOf,
    K key, [
    int start = 0,
    int? end,
  ]) {
    end = RangeError.checkValidRange(start, end, length);
    var min = start;
    var max = end;
    while (min < max) {
      var mid = min + ((max - min) >> 1);
      var element = this[mid];
      var comp = keyOf(element).compareTo(key);
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return min;
  }
}
