import 'dart:convert' show ascii;

import 'package:archive/archive.dart' show getCrc32;

/// 将 B 站 UID 转成弹幕数据使用的 CRC32 标识。
///
/// 弹幕接口只返回该哈希，不提供原始 UID，因此本地屏蔽需要用相同算法匹配。
String danmakuMidHashOf(Object mid) =>
    getCrc32(ascii.encode(mid.toString()), 0).toRadixString(16);
