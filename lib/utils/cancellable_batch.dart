Future<bool> runCancellableBatch<T>({
  required Iterable<Future<T> Function()> tasks,
  required bool Function() isCancelled,
  required Future<void> Function(List<T> results) onComplete,
}) async {
  if (isCancelled()) {
    return false;
  }
  final results = await Future.wait(
    tasks.map((task) => task()),
    eagerError: true,
  );
  if (isCancelled()) {
    return false;
  }
  await onComplete(results);
  return !isCancelled();
}
