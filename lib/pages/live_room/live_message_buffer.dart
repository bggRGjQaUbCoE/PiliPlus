import 'package:get/get.dart';

final class LiveMessageList<E> extends RxList<E> {
  List<E> get nonReactiveValues => value;
}

final class LiveMessageBuffer<E> {
  LiveMessageBuffer(
    this.values, {
    required this.maxLength,
    required this.trimCount,
  }) {
    if (maxLength <= 0) {
      throw ArgumentError.value(maxLength, 'maxLength');
    }
    if (trimCount <= 0 || trimCount > maxLength) {
      throw ArgumentError.value(trimCount, 'trimCount');
    }
  }

  final List<E> values;
  final int maxLength;
  final int trimCount;
  int _revision = 0;
  int _builtRevision = 0;

  bool get shouldRefresh => _revision != _builtRevision;

  int markBuilt() {
    _builtRevision = _revision;
    return values.length;
  }

  void add(E value) {
    values.add(value);
    _trim();
    _revision += 1;
  }

  void addAll(Iterable<E> newValues) {
    if (newValues is List<E> && newValues.length >= maxLength) {
      final retained = List<E>.of(
        newValues.getRange(newValues.length - maxLength, newValues.length),
      );
      values
        ..clear()
        ..addAll(retained);
    } else {
      var added = false;
      for (final value in newValues) {
        values.add(value);
        added = true;
      }
      if (!added) return;
      _trim();
    }
    _revision += 1;
  }

  void clear() {
    if (values.isEmpty) return;
    values.clear();
    _revision += 1;
  }

  void _trim() {
    final overflow = values.length - maxLength;
    if (overflow <= 0) return;
    final removeCount = overflow > trimCount ? overflow : trimCount;
    values.removeRange(0, removeCount);
  }
}
