import 'dart:io';
import 'dart:typed_data';

/// 解析 sfnt（TTF/OTF/TTC）的 `name` 表，取出可读的字体名称。
///
/// 只按需读取表目录和 `name` 表本身，不会把整个字体文件读进内存。
/// 任何格式异常都返回 null，由调用方回落到文件名——不能因为一个畸形
/// 字体文件导致导入整体失败。
abstract final class FontNameParser {
  /// 'ttcf'，字体集合（TrueType Collection）
  static const int _kTagTtcf = 0x74746366;

  /// 'name'
  static const int _kTagName = 0x6E616D65;

  /// nameID 4：完整字体名，形如 "思源黑体 SC Regular"。
  /// 优先取它而非族名，否则同一族的不同字重会显示成同一个名字，无法区分。
  static const int _kNameIdFullName = 4;

  /// nameID 16：首选族名，剥掉了字重后缀
  static const int _kNameIdTypographicFamily = 16;

  /// nameID 1：族名
  static const int _kNameIdFamily = 1;

  /// 族名显示长度上限，避免异常字体撑爆 UI 与存储 key
  static const int _kMaxNameLength = 64;

  /// 解析 [filePath] 的字体族名，失败返回 null。
  static Future<String?> parse(String filePath) async {
    RandomAccessFile? raf;
    try {
      final file = File(filePath);
      final fileLength = await file.length();
      raf = await file.open();

      // TTC 的表偏移是相对文件起始的绝对值，这里只需定位到第一个子字体的头部
      var headerOffset = 0;
      var header = await _readAt(raf, 0, 12);
      if (header == null) return null;
      if (header.getUint32(0) == _kTagTtcf) {
        final ttcHeader = await _readAt(raf, 12, 4);
        if (ttcHeader == null) return null;
        headerOffset = ttcHeader.getUint32(0);
        header = await _readAt(raf, headerOffset, 12);
        if (header == null) return null;
      }

      final numTables = header.getUint16(4);
      if (numTables == 0 || numTables > 512) return null;

      final directory = await _readAt(raf, headerOffset + 12, numTables * 16);
      if (directory == null) return null;

      var nameOffset = -1;
      var nameLength = 0;
      for (var i = 0; i < numTables; i++) {
        final record = i * 16;
        if (directory.getUint32(record) == _kTagName) {
          nameOffset = directory.getUint32(record + 8);
          nameLength = directory.getUint32(record + 12);
          break;
        }
      }
      if (nameOffset < 0 ||
          nameLength < 6 ||
          nameLength > 1 << 22 ||
          nameOffset + nameLength > fileLength) {
        return null;
      }

      final table = await _readAt(raf, nameOffset, nameLength);
      return table == null ? null : _pickFamilyName(table);
    } catch (_) {
      return null;
    } finally {
      try {
        await raf?.close();
      } catch (_) {}
    }
  }

  static Future<ByteData?> _readAt(
    RandomAccessFile raf,
    int offset,
    int length,
  ) async {
    if (offset < 0 || length <= 0) return null;
    await raf.setPosition(offset);
    final bytes = await raf.read(length);
    return bytes.length < length ? null : ByteData.sublistView(bytes);
  }

  /// 在所有候选记录里挑得分最高的一条
  static String? _pickFamilyName(ByteData table) {
    final count = table.getUint16(2);
    final storageOffset = table.getUint16(4);

    String? best;
    var bestScore = -1;
    for (var i = 0; i < count; i++) {
      final record = 6 + i * 12;
      if (record + 12 > table.lengthInBytes) break;

      final nameId = table.getUint16(record + 6);
      if (nameId != _kNameIdFullName &&
          nameId != _kNameIdFamily &&
          nameId != _kNameIdTypographicFamily) {
        continue;
      }

      final platformId = table.getUint16(record);
      final score = _score(platformId, table.getUint16(record + 4), nameId);
      if (score <= bestScore) continue;

      final length = table.getUint16(record + 8);
      final offset = storageOffset + table.getUint16(record + 10);
      if (length == 0 || offset + length > table.lengthInBytes) continue;

      final value = _decode(
        platformId,
        Uint8List.sublistView(table, offset, offset + length),
      );
      if (value == null) continue;

      best = value;
      bestScore = score;
    }
    return best;
  }

  /// nameID 决定大档位（完整名 > 首选族名 > 族名），
  /// 语言只在同档位内比较，使中文名优先于英文名，便于中文用户辨认
  static int _score(int platformId, int languageId, int nameId) {
    final base = switch (nameId) {
      _kNameIdFullName => 300,
      _kNameIdTypographicFamily => 200,
      _ => 100,
    };
    final language = switch (platformId) {
      // Windows：语言为 LCID
      3 => switch (languageId) {
        0x0804 => 50, // zh-CN
        0x0404 || 0x0C04 || 0x1404 => 40, // zh-TW / zh-HK / zh-MO
        0x0409 => 30, // en-US
        _ => 10,
      },
      // Unicode：无语言概念
      0 => 20,
      // Macintosh：语言为自有编码
      1 => switch (languageId) {
        33 => 45, // 简体中文
        19 => 35, // 繁体中文
        0 => 25, // 英语
        _ => 5,
      },
      _ => 0,
    };
    return base + language;
  }

  static String? _decode(int platformId, Uint8List bytes) {
    final String raw;
    if (platformId == 1) {
      // Macintosh Roman：ASCII 范围内与 Unicode 一致，超出范围不做映射，
      // 直接放弃这条记录，交给评分更低但可解码的其他记录
      for (final byte in bytes) {
        if (byte >= 0x80) return null;
      }
      raw = String.fromCharCodes(bytes);
    } else {
      // Windows / Unicode：UTF-16BE
      if (bytes.length < 2) return null;
      final units = Uint16List(bytes.length >> 1);
      for (var i = 0; i < units.length; i++) {
        units[i] = (bytes[i * 2] << 8) | bytes[i * 2 + 1];
      }
      raw = String.fromCharCodes(units);
    }
    return _sanitize(raw);
  }

  /// 池 key 以 '/' 分隔，族名内不能含 '/'；同时剔除控制字符并限长
  static String? _sanitize(String value) {
    final buffer = StringBuffer();
    var length = 0;
    for (final rune in value.runes) {
      if (rune == 0x2F || rune < 0x20 || rune == 0x7F) continue;
      buffer.writeCharCode(rune);
      if (++length >= _kMaxNameLength) break;
    }
    final result = buffer.toString().trim();
    return result.isEmpty ? null : result;
  }
}
