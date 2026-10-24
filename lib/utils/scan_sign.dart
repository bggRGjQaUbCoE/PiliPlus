import 'dart:convert' show utf8;

import 'package:crypto/crypto.dart';

/// B 站 App 端接口签名
///
/// 与 AppSign 的差异（扫码授权接口必须用这一套）：
/// - value 采用 quote_plus 语义编码，空格编码为 '+'（AppSign 用 %20）
/// - value 为空串时仍然保留 'key=' 这一段（AppSign 会整段省略）
abstract final class ScanSign {
  /// App 端 appkey/appsec
  static const String appKey = '783bbb7264451d82';
  static const String appSec = '2653583c8873dea268ab9386918b1d65';

  /// 写入 appkey/ts/sign，其余参数按 key 升序参与签名
  static void sign(
    Map<String, dynamic> params, {
    String appkey = appKey,
    String appsec = appSec,
  }) {
    params['appkey'] = appkey;
    params['ts'] = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final sorted = params.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final query = sorted
        .map((e) => '${quote(e.key)}=${quote('${e.value}')}')
        .join('&');
    params['sign'] = md5.convert(utf8.encode('$query$appsec')).toString();
  }

  /// 等价于 python 的 quote_plus
  ///
  /// 仅保留 a-zA-Z0-9-_.~，空格编码为 '+'，其余按 UTF-8 字节编码为 %XX（大写）
  static String quote(String value) {
    final builder = StringBuffer();
    for (final byte in utf8.encode(value)) {
      if ((byte >= 0x30 && byte <= 0x39) || // 0-9
          (byte >= 0x41 && byte <= 0x5A) || // A-Z
          (byte >= 0x61 && byte <= 0x7A)) {
        // a-z
        builder.writeCharCode(byte);
      } else if (byte == 0x2D || // -
          byte == 0x2E || // .
          byte == 0x5F || // _
          byte == 0x7E) {
        // ~
        builder.writeCharCode(byte);
      } else if (byte == 0x20) {
        builder.write('+');
      } else {
        builder.write('%');
        builder.write(byte.toRadixString(16).toUpperCase().padLeft(2, '0'));
      }
    }
    return builder.toString();
  }
}
