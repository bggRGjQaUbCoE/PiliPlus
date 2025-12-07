import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

sealed class LoadingState<T> {
  const LoadingState();

  factory LoadingState.loading() => const Loading._internal();

  bool get isSuccess => this is Success<T>;

  T get data => switch (this) {
    Success(:var response) => response,
    _ => throw this,
  };

  T? get dataOrNull => switch (this) {
    Success(:var response) => response,
    _ => null,
  };

  Future<void> toast() => SmartDialog.showToast(toString());
}

class Loading extends LoadingState<Never> {
  const Loading._internal();

  @override
  String toString() {
    return 'ApiException: loading';
  }
}

class Success<T> extends LoadingState<T> {
  final T response;
  const Success(this.response);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Success<T>) {
      return response == other.response;
    }
    return false;
  }

  @override
  int get hashCode => response.hashCode;
}

class Error extends LoadingState<Never> {
  final int? code;
  final String? errMsg;
  const Error(this.errMsg, {this.code});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Error) {
      return errMsg == other.errMsg && code == other.code;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(errMsg, code);

  @override
  String toString() {
    return errMsg ?? code?.toString() ?? '';
  }
}
