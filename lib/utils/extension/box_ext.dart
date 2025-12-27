import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

extension BoxExt<E> on Box<E> {
  bool equal(dynamic key, E value) {
    return const DeepCollectionEquality().equals(value, get(key));
  }

  Future<void>? putNE(dynamic key, E value) {
    if (!equal(key, value)) {
      return put(key, value);
    }
    return null;
  }

  Future<void>? putAllNE(Map<dynamic, E> entries) {
    final Map<dynamic, E> newEntries = {};
    entries.forEach((key, value) {
      if (!equal(key, value)) {
        newEntries[key] = value;
      }
    });
    if (newEntries.isNotEmpty) {
      return putAll(newEntries);
    }
    return null;
  }
}
