sealed class PlayerFeatureResult<T> {
  const PlayerFeatureResult();
}

final class PlayerFeatureSuccess<T> extends PlayerFeatureResult<T> {
  const PlayerFeatureSuccess(this.value);

  final T value;
}

final class PlayerFeatureUnavailable<T> extends PlayerFeatureResult<T> {
  const PlayerFeatureUnavailable(this.message);

  final String message;
}

final class PlayerFeatureFailure<T> extends PlayerFeatureResult<T> {
  const PlayerFeatureFailure(
    this.message, {
    this.error,
    this.stackTrace,
  });

  final String message;
  final Object? error;
  final StackTrace? stackTrace;
}
