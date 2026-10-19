import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/pages/my_reply/view.dart';
import 'package:PiliPlus/pages/search/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/font_utils.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/parse_int.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:archive/archive.dart';
import 'package:get/get.dart';

class ImportResult {
  const ImportResult({required this.applied, this.message});

  /// 是否已执行（false 表示取消）
  final bool applied;

  /// 附加提示，无则为 null
  final String? message;
}

abstract final class ConfigArchive {
  static const String metaFileName = 'meta.json';
  static const String settingFileName = 'setting.json';
  static const String accountFileName = 'account.json';
  static const String blacklistFileName = 'blacklist.json';
  static const String replyFileName = 'reply.json';
  static const String searchFileName = 'search.json';
  static const String fontFileName = FontUtils.kFontName;

  static const String _type = 'data_archive';

  /// 归档格式版本
  static const int _majorVersion = 0x0001;
  static const int _minorVersion = 0x0000;

  /// 搜索历史的存储 key
  static const String _searchCacheKey = 'cacheList';

  /// 解压后总大小上限
  static const int _maxTotalBytes = 64 * 1024 * 1024;

  static void export(OutputStream stream) {
    final zip = ZipEncoder()
      ..startEncode(stream)
      ..add(ArchiveFile.string(settingFileName, GStorage.exportAllSettings()))
      ..add(ArchiveFile.string(accountFileName, _exportAccount()))
      ..add(ArchiveFile.string(blacklistFileName, _exportBlacklist()));

    final reply = _exportReply();
    if (reply != null) {
      zip.add(ArchiveFile.string(replyFileName, reply));
    }

    if (FontUtils.fontFile.existsSync()) {
      zip.add(
        ArchiveFile.stream(
          fontFileName,
          InputFileStream(FontUtils.fontFile.path),
        ),
      );
    }

    zip
      ..add(ArchiveFile.string(searchFileName, _exportSearch()))
      ..add(ArchiveFile.string(metaFileName, _buildMeta()))
      ..endEncode();
    return;
  }

  static Future<String?> import(
    Uint8List bytes, {
    required Future<bool> Function(String warning) onWarning,
  }) async {
    if (bytes.length > _maxTotalBytes) {
      throw UnsupportedError('数据包过大');
    }

    final archive = ZipDecoder().decodeBytes(bytes);

    // 校验 meta
    final metaFile = archive.find(metaFileName);
    if (metaFile == null) {
      throw UnsupportedError('不是有效的数据包（缺少 $metaFileName）');
    }
    final meta = jsonDecode(utf8.decode(metaFile.content));
    if (meta is! Map || meta['type'] != _type) {
      throw UnsupportedError('不是有效的数据包');
    }

    // 校验 formatVersion
    final format = _parseFormat(meta['formatVersion']);
    if (format == null) {
      throw UnsupportedError('不是有效的数据包（缺少合法的 formatVersion）');
    }
    if (format.major > _majorVersion) {
      throw UnsupportedError('数据包格式过新（${format.toVersionString()}），请升级应用后再导入');
    }

    final warning = _warningOf(meta);
    if (warning != null && !await onWarning(warning)) {
      return null;
    }

    final sb = StringBuffer();
    var totalBytes = 0;

    Future<void> apply<T>(
      String name,
      FutureOr<void> Function(T) action,
    ) async {
      if (archive.find(name) case final file?) {
        totalBytes += file.size;
        if (totalBytes > _maxTotalBytes) throw UnsupportedError('数据包过大');

        try {
          await action(jsonDecode(utf8.decode(file.content)) as T);
        } catch (e) {
          sb.writeln('$name：$e');
        } finally {
          file.closeSync();
        }
      }
    }

    await apply(settingFileName, _importSettings);
    await apply(accountFileName, Accounts.importJsonAccount);
    await apply(blacklistFileName, _importBlacklist);
    await apply(replyFileName, _importReply);
    await apply(searchFileName, _importSearch);

    if (archive.find(fontFileName) case final file?) {
      totalBytes += file.size;
      if (totalBytes > _maxTotalBytes) throw UnsupportedError('数据包过大');
      final family = GStorage.setting.get(SettingBoxKey.appFont);
      if (family is String && family.contains('/')) {
        try {
          final bytes = file.content;
          await ui.loadFontFromList(bytes, fontFamily: family);
          await FontUtils.fontFile.writeAsBytes(bytes);
          FontUtils.appFont = (fontFamily: family, isCustom: true);
        } catch (e) {
          sb.writeln('$fontFileName：$e');
        } finally {
          file.closeSync();
        }
      } else {
        sb.writeln('$fontFileName：无法获取字体名');
      }
    }

    return sb.toString();
  }

  /// 生成合并警告
  static String? _warningOf(Map meta) {
    final warnings = StringBuffer();

    final format = _parseFormat(meta['formatVersion']);
    if (format != null &&
        format.major == _majorVersion &&
        format.minor > _minorVersion) {
      warnings.writeln('此数据包使用更新的归档格式（${format.toVersionString()}），部分数据可能无法识别');
    }

    final sourceApp = meta['appName'];
    if (sourceApp != Constants.appName) {
      warnings.writeln('此数据包来自「$sourceApp」，与当前应用不同，可能不完全兼容');
    }

    final packageCode = safeToInt(meta['versionCode']);
    if (packageCode != null && packageCode > BuildConfig.versionCode) {
      final versionName = meta['versionName'];
      warnings.writeln(
        '此数据包来自更新版本（v$versionName，构建号 $packageCode），'
        '当前应用较旧（v${BuildConfig.versionName}，构建号 ${BuildConfig.versionCode}），'
        '部分数据可能无法正确还原',
      );
    }
    return warnings.isEmpty ? null : warnings.toString();
  }

  /// 解析 [主, 次] 格式版本
  static VersionCode? _parseFormat(Object? value) {
    if (value is int) {
      return VersionCode(value);
    }
    return null;
  }

  static String _exportAccount() => jsonEncode(Accounts.account.toMap());

  static String _exportBlacklist() => jsonEncode(Pref.blackMids.toList());

  static String? _exportReply() {
    final box = GStorage.reply;
    if (box == null) return null;
    return jsonEncode(
      box.values.map((e) => ReplyInfo.fromBuffer(e).toProto3Json()).toList(),
    );
  }

  static String _exportSearch() {
    final list = GStorage.historyWord.get(_searchCacheKey);
    return jsonEncode(list ?? const <String>[]);
  }

  static String _buildMeta() => jsonEncode({
    'type': _type,
    'formatVersion': const VersionCode.fromMajorMinor(
      _majorVersion,
      _minorVersion,
    ),
    'appName': Constants.appName,
    'versionCode': BuildConfig.versionCode,
    'versionName': BuildConfig.versionName,
    'commitHash': BuildConfig.commitHash,
    'buildTime': BuildConfig.buildTime,
    'platform': DeviceUtils.platformName,
    'exportTime': DateTime.now().toIso8601String(),
    'files': [
      settingFileName,
      accountFileName,
      blacklistFileName,
      if (GStorage.reply != null) replyFileName,
      searchFileName,
      if (FontUtils.fontFile.existsSync()) fontFileName,
    ],
  });

  static Future<void> _importSettings(Map<String, dynamic> data) async {
    // 先校验结构，避免 clear 后 putAll 失败导致旧设置丢失
    if (data[GStorage.setting.name] is! Map ||
        data[GStorage.video.name] is! Map) {
      throw ArgumentError('设置数据格式不正确');
    }
    await GStorage.importAllJsonSettings(data);
  }

  static void _importBlacklist(List<dynamic> list) {
    // 就地覆盖，保持已有引用
    final set = GlobalData().blackMids
      ..clear()
      ..addAll(Set<int>.from(list));
    Pref.blackMids = set;
  }

  static void _importReply(List<dynamic> list) {
    final box = GStorage.reply;
    if (box == null) return;
    box.putAll(MyReply.json2ReplyProto(list));
  }

  static void _importSearch(List<dynamic> list) {
    final history = List<String>.from(list);
    GStorage.historyWord.put(_searchCacheKey, history);
    // 同步刷新内存单例，避免被旧列表覆盖
    if (Get.isRegistered<BaseSearchController>()) {
      Get.find<BaseSearchController>().historyList.assignAll(history);
    }
  }
}

extension type VersionCode(int _version) {
  int get major => _version >>> 16;
  int get minor => _version & 0xFFFF;

  const VersionCode.fromMajorMinor(int major, int minor)
    : _version = (major << 16) | minor;

  String toVersionString() => '$major.$minor';
}
