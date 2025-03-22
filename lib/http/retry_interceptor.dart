import 'package:dio/dio.dart';

import 'index.dart';

class RetryInterceptor extends Interceptor {
  final int _count;
  final int _delay;

  RetryInterceptor(this._count, this._delay);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) return handler.next(err);
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        if ((err.requestOptions.extra['_rt'] ??= 0) < _count) {
          Future.delayed(
              Duration(
                  milliseconds: ++err.requestOptions.extra['_rt'] * _delay),
              () => Request.dio
                  .fetch(err.requestOptions)
                  .then(handler.resolve)
                  .onError<DioException>((error, _) => handler.reject(error)));
        } else {
          handler.next(err);
        }
        return;
      default:
        return handler.next(err);
    }
  }
}
