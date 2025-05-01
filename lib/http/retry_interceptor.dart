import 'package:dio/dio.dart';

import 'index.dart';

class RetryInterceptor extends Interceptor {
  final int _count;
  final int _delay;

  RetryInterceptor(this._count, this._delay);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final options = err.requestOptions;
      if (options.followRedirects && options.maxRedirects > 0) {
        final status = err.response!.statusCode;
        if (status != null && 300 <= status && status < 400) {
          var redirectUrl = err.response!.headers.value('location');
          if (redirectUrl != null) {
            var uri = Uri.parse(redirectUrl);
            if (!uri.hasScheme) {
              uri = options.uri.resolveUri(uri);
              redirectUrl = uri.toString();
            }
            (options..path = redirectUrl).maxRedirects--;
            if (status == 303) {
              options.data = null;
              options.method = 'GET';
            }
            Request.dio
                .fetch(options)
                .then((i) => handler.resolve(i
                  ..redirects.add(RedirectRecord(status, options.method, uri))
                  ..isRedirect = true))
                .onError<DioException>((error, _) => handler.next(error));
            return;
          }
        }
      }
      return handler.next(err);
    } else {
      switch (err.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.unknown:
          if ((err.requestOptions.extra['_rt'] ??= 0) < _count) {
            Future.delayed(
                Duration(
                    milliseconds: ++err.requestOptions.extra['_rt'] * _delay),
                () => Request.dio
                    .fetch(err.requestOptions)
                    .then(handler.resolve)
                    .onError<DioException>(
                        (error, _) => handler.reject(error)));
          } else {
            handler.next(err);
          }
          return;
        default:
          return handler.next(err);
      }
    }
  }
}
