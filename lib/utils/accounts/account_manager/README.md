# dio_cookie_manager

[![Pub](https://img.shields.io/pub/v/dio_cookie_manager.svg)](https://pub.dev/packages/dio_cookie_manager)

A cookie manager combines cookie_jar and dio, based on the interceptor algorithm.

## Getting Started

### Install

Add the `dio_cookie_manager` package to your
[pubspec dependencies](https://pub.dev/packages/dio_cookie_manager/install).

### Usage

```dart
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

void main() async {
  final dio = Dio();
  final cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));
  // First request, and save cookies (CookieManager do it).
  await dio.get("https://dart.dev");
  // Print cookies
  print(await cookieJar.loadForRequest(Uri.parse("https://dart.dev")));
  // Second request with the cookies
  await dio.get('https://dart.dev');
}
```

## Cookie Manager

`CookieManager` Interceptor can help us manage the request/response cookies automatically.
`CookieManager` depends on the `cookie_jar` package:

> The dio_cookie_manager manage API is based on the withdrawn
> [cookie_jar](https://github.com/flutterchina/cookie_jar).

You can create a `CookieJar` or `PersistCookieJar` to manage cookies automatically,
and dio use the `CookieJar` by default, which saves the cookies **in RAM**.
If you want to persists cookies, you can use the `PersistCookieJar` class, for example:

```dart
dio.interceptors.add(CookieManager(PersistCookieJar()))
```

`PersistCookieJar` persists the cookies in files,
so if the application exit, the cookies always exist unless call `delete` explicitly.

> Note: In flutter, the path passed to `PersistCookieJar` must be valid (exists in phones and with write access).
> Use [path_provider](https://pub.dev/packages/path_provider) package to get the right path.

In flutter:

```dart
Future<void> prepareJar() async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String appDocPath = appDocDir.path;
  final jar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage(appDocPath + "/.cookies/"),
  );
  dio.interceptors.add(CookieManager(jar));
}
```

## Handling Cookies with redirect requests

Redirect requests require extra configuration to parse cookies correctly.
In shortly:
- Set `followRedirects` to `false`.
- Allow `statusCode` from `300` to `399` responses predicated as succeed.
- Make further requests using the `HttpHeaders.locationHeader`.

For example:
```dart
final cookieJar = CookieJar();
final dio = Dio()
  ..interceptors.add(CookieManager(cookieJar))
  ..options.followRedirects = false
  ..options.validateStatus =
      (status) => status != null && status >= 200 && status < 400;
final redirected = await dio.get('/redirection');
final response = await dio.get(
  redirected.headers.value(HttpHeaders.locationHeader)!,
);
```
