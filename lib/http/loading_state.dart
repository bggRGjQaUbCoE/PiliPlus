import 'dart:core' hide Error;

sealed class LoadingState<T> {
  const LoadingState();

  factory LoadingState.loading() = Loading;
  factory LoadingState.success(T response) = Success<T>;
  factory LoadingState.error(String errMsg) = Error;

  bool get isSuccess => this is Success<T>;

  T get data => switch (this) {
        Success(response: final res) => res,
        Error() => throw this,
        Loading() => throw Exception('ApiException: loading'),
      };

  T? get dataOrNull => switch (this) {
        Success(response: final res) => res,
        _ => null,
      };
}

class Loading extends LoadingState<Never> {
  const Loading._internal();

  static const Loading _instance = Loading._internal();

  factory Loading() => _instance;
}

class Success<T> extends LoadingState<T> {
  final T response;
  const Success(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Success) {
      return response == other.response;
    }
    return false;
  }

  @override
  int get hashCode => response.hashCode;
}

class Error extends LoadingState<Never> {
  final String errMsg;
  const Error(this.errMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Error) {
      return errMsg == other.errMsg;
    }
    return false;
  }

  @override
  int get hashCode => errMsg.hashCode;

  @override
  String toString() {
    return 'ApiException: $errMsg';
  }
}
