import 'dart:core' hide Error;

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

sealed class LoadingState<T> {
  const LoadingState();

  factory LoadingState.loading() = Loading;
  factory LoadingState.success(T response) = Success<T>;
  factory LoadingState.error(String errMsg) = Error;

  bool get isSuccess => this is Success<T>;

  T get data => switch (this) {
        Success(response: final res) => res,
        _ => throw this,
      };

  T? get dataOrNull => switch (this) {
        Success(response: final res) => res,
        _ => null,
      };

  void toast() => SmartDialog.showToast(toString());
}

class Loading extends LoadingState<Never> {
  const Loading._internal();

  static const Loading _instance = Loading._internal();

  factory Loading() => _instance;

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
