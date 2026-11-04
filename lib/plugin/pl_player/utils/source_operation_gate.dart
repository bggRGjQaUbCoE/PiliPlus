import 'package:synchronized/synchronized.dart';

/// Serializes native source opens and invalidates queued or in-flight work
/// when a newer source is requested.
final class SourceOperationGate {
  final _lock = Lock();
  int _generation = 0;

  int get generation => _generation;

  int begin() => ++_generation;

  void invalidate() => _generation++;

  bool isCurrent(int generation, bool Function() ownerIsCurrent) =>
      generation == _generation && ownerIsCurrent();

  Future<void> run(
    int generation, {
    required bool Function() ownerIsCurrent,
    required Future<void> Function(bool Function() isCurrent) operation,
  }) => _lock.synchronized(() async {
    bool isCurrent() => this.isCurrent(generation, ownerIsCurrent);
    if (isCurrent()) await operation(isCurrent);
  });
}
