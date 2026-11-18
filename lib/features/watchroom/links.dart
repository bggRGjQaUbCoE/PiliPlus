import 'dart:async';
import 'dart:io';

import 'model.dart';

typedef RoomRedirectLoader = Future<Uri?> Function(Uri uri);

/// Resolve official share links without using or logging account credentials.
/// Known mobile pages already contain the same room and invitation fields as
/// their desktop equivalents; short links first need their HTTP redirects.
class RoomLinkResolver {
  static const desktopUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36';
  final RoomRedirectLoader loadRedirect;

  const RoomLinkResolver({this.loadRedirect = _loadRedirect});

  static bool _isShortLink(Uri uri) =>
      const {'b23.tv', 'www.b23.tv'}.contains(uri.host);

  static bool _allowed(Uri uri) =>
      const {'http', 'https'}.contains(uri.scheme) &&
      uri.userInfo.isEmpty &&
      (!uri.hasPort || const {80, 443}.contains(uri.port)) &&
      (_isShortLink(uri) ||
          const {
            'www.bilibili.com',
            'm.bilibili.com',
            'bilibili.com',
          }.contains(uri.host));

  Future<RoomInvite> resolve(String text) async {
    try {
      return RoomInvite.parse(text);
    } on FormatException {
      final link = RoomInvite.linkFromText(text);
      if (link == null || !_allowed(link) || !_isShortLink(link)) rethrow;
      try {
        return await _expand(link);
      } on TimeoutException {
        throw const RoomApiException(-1, '短链接解析超时，请检查网络后重试');
      } on IOException {
        throw const RoomApiException(-1, '短链接解析失败，请检查网络后重试');
      }
    }
  }

  Future<RoomInvite> _expand(Uri uri) async {
    final visited = <String>{};
    final deadline = DateTime.now().add(const Duration(seconds: 15));
    for (var hop = 0; hop < 6; hop++) {
      if (!_allowed(uri)) {
        throw const FormatException('短链接没有指向 B 站官方放映室');
      }
      try {
        return RoomInvite.parse(uri.toString());
      } on FormatException {
        // A trusted intermediate redirect can still lead to an invite page.
      }
      if (!visited.add(uri.toString())) {
        throw const FormatException('短链接发生循环跳转，请重新复制邀请链接');
      }
      final remaining = deadline.difference(DateTime.now());
      if (remaining <= Duration.zero) throw TimeoutException('Invite redirect');
      final target = await loadRedirect(uri).timeout(remaining);
      if (target == null) {
        throw const FormatException('这个短链接没有指向可识别的放映室邀请');
      }
      uri = uri.resolveUri(target);
    }
    throw const FormatException('短链接跳转次数过多，请复制完整邀请链接');
  }

  static Future<Uri?> _loadRedirect(Uri uri) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(uri.replace(scheme: 'https'));
      request.followRedirects = false;
      request.headers.set(HttpHeaders.userAgentHeader, desktopUserAgent);
      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );
      if (!const {301, 302, 303, 307, 308}.contains(response.statusCode)) {
        return null;
      }
      final location = response.headers.value(HttpHeaders.locationHeader);
      return location == null ? null : Uri.tryParse(location);
    } finally {
      client.close(force: true);
    }
  }
}
