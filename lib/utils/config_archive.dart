import 'dart:async' show FutureOr;
import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/search/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/font_utils.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
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
  static const String fontFileName = 'customFont.otf';

  static const String _type = 'data_archive';
  /// 归档格式版本 [主, 次]
  static const List<int> _formatVersion = <int>[1, 0];
  /// 搜索历史的存储 key
  static const String _searchCacheKey = 'cacheList';
  /// 解压后总大小上限
  static const int _maxTotalBytes = 64 * 1024 * 1024;

  static Future<Uint8List> export() async {
    final archive = Archive()
      ..addFile(
        ArchiveFile.string(settingFileName, GStorage.exportAllSettings()),
      )
      ..addFile(ArchiveFile.string(accountFileName, _exportAccount()))
      ..addFile(ArchiveFile.string(blacklistFileName, _exportBlacklist()));

    final reply = _exportReply();
    if (reply != null) {
      archive.addFile(ArchiveFile.string(replyFileName, reply));
    }

    if (FontUtils.fontFile.existsSync()) {
      archive.addFile(
        ArchiveFile.bytes(fontFileName, FontUtils.fontFile.readAsBytesSync()),
      );
    }

    archive
      ..addFile(ArchiveFile.string(searchFileName, _exportSearch()))
      ..addFile(ArchiveFile.string(metaFileName, _buildMeta()));

    return ZipEncoder().encodeBytes(archive);
  }

  static Future<ImportResult> import(
    List<int> bytes, {
    required Future<bool> Function(String warning) onWarning,
    required Future<bool> Function() onConfirm,
  }) async {
    final archive = ZipDecoder().decodeBytes(bytes);

    // 校验 meta
    final metaFile = archive.findFile(metaFileName);
    if (metaFile == null) {
      throw '不是有效的数据包（缺少 $metaFileName）';
    }
    final meta = jsonDecode(utf8.decode(metaFile.content));
    if (meta is! Map || meta['type'] != _type) {
      throw '不是有效的数据包';
    }

    // 校验 formatVersion
    final format = _parseFormat(meta['formatVersion']);
    if (format == null) {
      throw '不是有效的数据包（缺少合法的 formatVersion）';
    }
    if (format.$1 > _formatVersion[0]) {
      throw '数据包格式过新（${format.$1}.${format.$2}），请升级应用后再导入';
    }

    // 收集各模块
    final files = <String, String>{};
    Uint8List? fontBytes;
    var totalBytes = 0;
    for (final file in archive.files) {
      if (!file.isFile || file.name == metaFileName) {
        continue;
      }
      totalBytes += file.size;
      if (totalBytes > _maxTotalBytes) {
        throw '数据包过大';
      }
      if (file.name == fontFileName) {
        fontBytes = file.content;
      } else {
        files[file.name] = utf8.decode(file.content);
      }
    }

    final warning = _warningOf(meta);
    if (warning != null && !await onWarning(warning)) {
      return const ImportResult(applied: false);
    }
    if (!await onConfirm()) {
      return const ImportResult(applied: false);
    }

    // 逐项还原，单项失败跳过
    final failed = <String>[];
    if (files[settingFileName] case final data?) {
      await _apply('设置', failed, () => _importSettings(data));
    }
    if (files[accountFileName] case final data?) {
      await _apply('账号', failed, () => _importAccount(jsonDecode(data)));
    }
    if (files[blacklistFileName] case final data?) {
      await _apply('黑名单', failed, () => _importBlacklist(jsonDecode(data)));
    }
    if (files[replyFileName] case final data?) {
      await _apply('评论', failed, () => _importReply(jsonDecode(data)));
    }
    if (files[searchFileName] case final data?) {
      await _apply('搜索记录', failed, () => _importSearch(jsonDecode(data)));
    }

    // 还原字体
    var fontRestored = false;
    if (fontBytes != null) {
      if (fontBytes.isEmpty) {
        failed.add('自定义字体');
      } else {
        try {
          FontUtils.fontFile.writeAsBytesSync(fontBytes);
          fontRestored = true;
        } catch (_) {
          failed.add('自定义字体');
        }
      }
    }

    final messages = <String>[
      if (fontRestored) '自定义字体需重启应用后生效',
      if (failed.isNotEmpty) '以下数据导入失败：${failed.join('、')}',
    ];
    return ImportResult(
      applied: true,
      message: messages.isEmpty ? null : messages.join('；'),
    );
  }

  /// 生成合并警告
  static String? _warningOf(Map meta) {
    final warnings = <String>[];

    final format = _parseFormat(meta['formatVersion']);
    if (format != null &&
        format.$1 == _formatVersion[0] &&
        format.$2 > _formatVersion[1]) {
      warnings.add('此数据包使用更新的归档格式（${format.$1}.${format.$2}），部分数据可能无法识别');
    }

    final sourceApp = meta['appName'];
    if (sourceApp is String &&
        sourceApp.isNotEmpty &&
        sourceApp != Constants.appName) {
      warnings.add('此数据包来自「$sourceApp」，与当前应用不同，可能不完全兼容');
    }

    final packageCode = _asInt(meta['versionCode']);
    if (packageCode != null && packageCode > BuildConfig.versionCode) {
      final versionName = meta['versionName'];
      final label = versionName is String && versionName.isNotEmpty
          ? versionName
          : packageCode.toString();
      warnings.add(
        '此数据包来自更新版本（v$label，构建号 $packageCode），'
        '当前应用较旧（v${BuildConfig.versionName}，构建号 ${BuildConfig.versionCode}），'
        '部分数据可能无法正确还原',
      );
    }
    return warnings.isEmpty ? null : warnings.join('；');
  }

  /// 宽松解析整数
  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// 解析 [主, 次] 格式版本
  static (int, int)? _parseFormat(Object? value) {
    if (value is List && value.length >= 2) {
      final major = _asInt(value[0]);
      final minor = _asInt(value[1]);
      if (major != null && minor != null) return (major, minor);
    }
    return null;
  }

  static Future<void> _apply(
    String name,
    List<String> failed,
    FutureOr<void> Function() action,
  ) async {
    try {
      await action();
    } catch (_) {
      failed.add(name);
    }
  }

  static String _exportAccount() =>
      Utils.jsonEncoder.convert(Accounts.account.toMap());

  static String _exportBlacklist() =>
      Utils.jsonEncoder.convert(Pref.blackMids.toList());

  static String? _exportReply() {
    final box = GStorage.reply;
    if (box == null) return null;
    return Utils.jsonEncoder.convert(
      box.values.map((e) => ReplyInfo.fromBuffer(e).toProto3Json()).toList(),
    );
  }

  static String _exportSearch() {
    final list = GStorage.historyWord.get(_searchCacheKey);
    return Utils.jsonEncoder.convert(list ?? const <String>[]);
  }

  static String _buildMeta() => jsonEncode({
    'type': _type,
    'formatVersion': _formatVersion,
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

  static Future<void> _importSettings(String data) async {
    // 先校验结构，避免 clear 后 putAll 失败导致旧设置丢失
    final map = jsonDecode(data);
    if (map is! Map ||
        map[GStorage.setting.name] is! Map ||
        map[GStorage.video.name] is! Map) {
      throw '设置数据格式不正确';
    }
    await GStorage.importAllSettings(data);
  }

  static Future<void> _importAccount(Map json) async {
    final res = json.map(
      (key, value) => MapEntry(key, LoginAccount.fromJson(value)),
    );
    await Accounts.account.putAll(res);
    await Accounts.refresh();
    MineController.anonymity.value = !Accounts.heartbeat.isLogin;
    if (Accounts.main.isLogin) {
      await LoginUtils.onLoginMain();
    }
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
    box.putAll({
      for (final e in list)
        e['id'].toString(): (ReplyInfo.create()..mergeFromProto3Json(e))
            .writeToBuffer(),
    });
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
