import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:uuid/v4.dart';

class Utils {
  static final Random random = Random();

  static const channel = MethodChannel("PiliPlus");

  static final _numRegExp = RegExp(r'([\d\.]+)([千万亿])?');

  static final regExp =
      RegExp(r'(@(\d+[a-z]_?)*)(\..*)?$', caseSensitive: false);

  static String thumbnailImgUrl(String? src, [int? quality]) {
    if (src != null && quality != 100) {
      bool hasMatch = false;
      src = src.splitMapJoin(
        regExp,
        onMatch: (Match match) {
          hasMatch = true;
          String suffix = match.group(3) ?? '.webp';
          return '${match.group(1)}_${quality ?? GlobalData().imgQuality}q$suffix';
        },
        onNonMatch: (String str) {
          return str;
        },
      );
      if (!hasMatch) {
        src += '@${quality ?? GlobalData().imgQuality}q.webp';
      }
    }
    return src.http2https;
  }

  static bool? _isIpad;

  static Future<bool> isIpad() async {
    if (!Platform.isIOS) {
      return false;
    }
    if (_isIpad != null) {
      return _isIpad!;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    _isIpad = info.model.toLowerCase().contains("ipad");
    return _isIpad!;
  }

  static Future<void> shareText(String text) async {
    try {
      Rect? sharePositionOrigin;
      if (await isIpad()) {
        sharePositionOrigin = Rect.fromLTWH(0, 0, Get.width, Get.height / 2);
      }
      Share.share(
        text,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  static String buildShadersAbsolutePath(
      String baseDirectory, List<String> shaders) {
    List<String> absolutePaths = shaders.map((shader) {
      return path.join(baseDirectory, shader);
    }).toList();
    return absolutePaths.join(':');
  }

  static bool isStringNumeric(String str) {
    RegExp numericRegex = RegExp(r'^[\d\.]+$');
    return numericRegex.hasMatch(str);
  }

  static bool isDefaultFav(int? attr) {
    if (attr == null) {
      return false;
    }
    return (attr & 2) == 0;
  }

  static String isPublicFavText(int? attr) {
    if (attr == null) {
      return '';
    }
    return isPublicFav(attr) ? '公开' : '私密';
  }

  static bool isPublicFav(int attr) {
    return (attr & 1) == 0;
  }

  static String generateRandomString(int length) {
    const characters = '0123456789abcdefghijklmnopqrstuvwxyz';

    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  static String genAuroraEid(int uid) {
    if (uid == 0) {
      return ''; // Return null for a UID of 0
    }

    // 1. Convert UID to a byte array.
    var midByte = utf8.encode(uid.toString());

    // 2. XOR each byte with the corresponding byte from the key.
    const key = 'ad1va46a7lza';
    for (int i = 0; i < midByte.length; i++) {
      midByte[i] ^= key.codeUnitAt(i % key.length);
    }

    // 3. Perform Base64 encoding without padding.
    String base64Encoded =
        base64.encode(midByte).replaceAll('=', ''); // Remove padding

    // Return the resulting x-bili-aurora-eid.
    return base64Encoded;
  }

  static String genTraceId() {
    String randomId = generateRandomString(32);

    StringBuffer randomTraceId = StringBuffer(randomId.substring(0, 24));

    int ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    for (int i = 2; i >= 0; i--) {
      ts >>= 8;
      randomTraceId.write((ts & 0xFF).toRadixString(16).padLeft(2, '0'));
    }

    randomTraceId.write(randomId.substring(30, 32));

    return '${randomTraceId.toString()}:${randomTraceId.toString().substring(16, 32)}:0:0';
  }

  static void copyText(
    String text, {
    bool needToast = true,
    String? toastText,
  }) {
    Clipboard.setData(ClipboardData(text: text));
    if (needToast) {
      SmartDialog.showToast(toastText ?? '已复制');
    }
  }

  // static Future<String> getCookiePath() async {
  //   final Directory tempDir = await getApplicationSupportDirectory();
  //   final String tempPath = "${tempDir.path}/.plpl/";
  //   final Directory dir = Directory(tempPath);
  //   final bool b = await dir.exists();
  //   if (!b) {
  //     dir.createSync(recursive: true);
  //   }
  //   return tempPath;
  // }

  static int getUnit(String? unit) {
    switch (unit) {
      case '千':
        return 1000;
      case '万':
        return 10000;
      case '亿':
        return 100000000;
      default:
        return 1;
    }
  }

  static int parseNum(String numberStr) {
    if (numberStr == '-') return 0;
    try {
      final match = _numRegExp.firstMatch(numberStr)!;
      var number = double.parse(match.group(1)!);
      number *= getUnit(match.group(2));
      return number.toInt();
    } catch (e) {
      if (kDebugMode) debugPrint('parse failed: "$numberStr" : $e');
      return 0;
    }
  }

  static String numFormat(dynamic number) {
    if (number == null) {
      return '0';
    }
    if (number is String) {
      number = int.tryParse(number) ?? number;
      if (number is String) {
        return number;
      }
    }

    String format(first, second) {
      double result = ((number / first) as double).toPrecision(1);
      int intRes = result.toInt();
      if (result == intRes) {
        return '$intRes$second';
      } else {
        return '$result$second';
      }
    }

    if (number >= 100000000) {
      return format(100000000, '亿');
    } else if (number >= 10000) {
      return format(10000, '万');
    } else {
      return number.toString();
    }
  }

  static String durationReadFormat(String duration) {
    List<String> durationParts = duration.split(':');

    if (durationParts.length == 3) {
      if (durationParts[0] != '00') {
        return '${int.parse(durationParts[0])}小时${durationParts[1]}分钟${durationParts[2]}秒';
      }
      durationParts.removeAt(0);
    }
    if (durationParts.length == 2) {
      if (durationParts[0] != '00') {
        return '${int.parse(durationParts[0])}分钟${durationParts[1]}秒';
      }
      durationParts.removeAt(0);
    }
    return '${int.parse(durationParts[0])}秒';
  }

  static String videoItemSemantics(BaseVideoItemModel videoItem) {
    StringBuffer semanticsLabel = StringBuffer();
    bool emptyStatCheck(int? stat) {
      return stat == null || stat <= 0;
    }

    if (videoItem is RecVideoItemAppModel) {
      if (videoItem.goto == 'picture') {
        semanticsLabel.write('动态,');
      } else if (videoItem.goto == 'bangumi') {
        semanticsLabel.write('番剧,');
      }
    }
    semanticsLabel.write(videoItem.title);

    if (!emptyStatCheck(videoItem.stat.view)) {
      semanticsLabel
        ..write(',${Utils.numFormat(videoItem.stat.view)}')
        ..write(
            (videoItem is RecVideoItemAppModel && videoItem.goto == 'picture')
                ? '浏览'
                : '播放');
    }
    if (!emptyStatCheck(videoItem.stat.danmu)) {
      semanticsLabel.write(',${Utils.numFormat(videoItem.stat.danmu)}弹幕');
    }
    if ((videoItem is BaseRecVideoItemModel) && videoItem.rcmdReason != null) {
      semanticsLabel.write(',${videoItem.rcmdReason}');
    }
    if (!emptyStatCheck(videoItem.duration) && videoItem.duration > 0) {
      semanticsLabel.write(
          ',时长${Utils.durationReadFormat(Utils.timeFormat(videoItem.duration))}');
    }
    if (videoItem.pubdate != null) {
      semanticsLabel
          .write(',${Utils.dateFormat(videoItem.pubdate!, formatType: 'day')}');
    }
    if (videoItem.owner.name != '') {
      semanticsLabel.write(',Up主：${videoItem.owner.name}');
    }
    if (videoItem is BaseRecVideoItemModel && videoItem.isFollowed) {
      semanticsLabel.write(',已关注');
    }
    return semanticsLabel.toString();
  }

  static String timeFormat(dynamic time) {
    if (time is String && time.contains(':')) {
      return time;
    }
    if (time == null || time == 0) {
      return '00:00';
    }
    return formatDuration(time);
  }

  static String shortenChineseDateString(String date) {
    return date.contains("年")
        ? RegExp(r'\d+')
            .allMatches(date)
            .map((match) => match.group(0)?.length == 4
                ? match.group(0)!.substring(2)
                : match.group(0))
            .join('-')
        : date;
    // if (date.contains("年")) return '${date.split("年").first}年';
    // return date;
  }

  // 完全相对时间显示
  static String formatTimestampToRelativeTime(timeStamp) {
    var difference = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000));

    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365}年前';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30}个月前';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  // 时间显示，刚刚，x分钟前
  static String dateFormat(timeStamp, {formatType = 'list'}) {
    if (timeStamp == null || timeStamp == 0 || timeStamp == '') {
      return '';
    }
    // 当前时间
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    // 对比
    int distance = (time - timeStamp).toInt();
    // 当前年日期
    String currentYearStr = 'MM月DD日 hh:mm';
    String lastYearStr = 'YY年MM月DD日 hh:mm';
    if (formatType == 'detail') {
      currentYearStr = 'MM-DD hh:mm';
      lastYearStr = 'YY-MM-DD hh:mm';
      return customStampStr(
          timestamp: timeStamp, date: lastYearStr, toInt: false);
    } else if (formatType == 'day') {
      if (distance <= 43200) {
        return customStampStr(
          timestamp: timeStamp,
          date: 'hh:mm',
          toInt: true,
        );
      }
      return customStampStr(
        timestamp: timeStamp,
        date: 'YY-MM-DD',
        toInt: true,
      );
    }
    if (distance <= 60) {
      return '刚刚';
    } else if (distance <= 3600) {
      return '${(distance / 60).floor()}分钟前';
    } else if (distance <= 43200) {
      return '${(distance / 60 / 60).floor()}小时前';
    } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).year) {
      return customStampStr(
          timestamp: timeStamp, date: currentYearStr, toInt: false);
    } else {
      return customStampStr(
          timestamp: timeStamp, date: lastYearStr, toInt: false);
    }
  }

  // 时间戳转时间
  static String customStampStr({
    int? timestamp, // 为空则显示当前时间
    String? date, // 显示格式，比如：'YY年MM月DD日 hh:mm:ss'
    bool toInt = true, // 去除0开头
  }) {
    timestamp ??= (DateTime.now().millisecondsSinceEpoch / 1000).round();
    String timeStr =
        (DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)).toString();

    dynamic dateArr = timeStr.split(' ')[0];
    dynamic timeArr = timeStr.split(' ')[1];

    // ignore: non_constant_identifier_names
    String YY = dateArr.split('-')[0];
    // ignore: non_constant_identifier_names
    String MM = dateArr.split('-')[1];
    // ignore: non_constant_identifier_names
    String DD = dateArr.split('-')[2];

    String hh = timeArr.split(':')[0];
    String mm = timeArr.split(':')[1];
    String ss = timeArr.split(':')[2];

    ss = ss.split('.')[0];

    // 去除0开头
    if (toInt) {
      MM = (int.parse(MM)).toString();
      DD = (int.parse(DD)).toString();
      hh = (int.parse(hh)).toString();
      // mm = (int.parse(mm)).toString();
    }

    if (date == null) {
      return timeStr;
    }

    date = date
        .replaceAll('YY', YY)
        .replaceAll('MM', MM)
        .replaceAll('DD', DD)
        .replaceAll('hh', hh)
        .replaceAll('mm', mm)
        .replaceAll('ss', ss);
    // if (int.parse(YY) == DateTime.now().year &&
    //     int.parse(MM) == DateTime.now().month) {
    //   // 当天
    //   if (int.parse(DD) == DateTime.now().day) {
    //     return '今天';
    //   }
    // }
    return date;
  }

  static String makeHeroTag(v) {
    return v.toString() + random.nextInt(9999).toString();
  }

  static String formatDuration(num seconds) {
    int h = seconds ~/ 3600;
    seconds %= 3600;
    int m = seconds ~/ 60;
    seconds %= 60;
    String sms = seconds is double
        ? seconds.toStringAsFixed(3).padLeft(6, '0')
        : seconds.toString().padLeft(2, '0');
    return h == 0
        ? "${m.toString().padLeft(2, '0')}:$sms"
        : "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:$sms";
  }

  static int duration(String duration) {
    List timeList = duration.split(':');
    int len = timeList.length;
    if (len == 2) {
      return int.parse(timeList[0]) * 60 + int.parse(timeList[1]);
    }
    if (len == 3) {
      return int.parse(timeList[0]) * 3600 +
          int.parse(timeList[1]) * 60 +
          int.parse(timeList[2]);
    }
    return 0;
  }

  static int findClosestNumber(int target, List<int> numbers) {
    List<int> filterNums = numbers.where((number) => number <= target).toList();
    return filterNums.isNotEmpty
        ? filterNums.reduce((a, b) => a > b ? a : b)
        : numbers.reduce((a, b) => a > b ? b : a);
  }

  // 检查更新
  static Future<void> checkUpdate([bool isAuto = true]) async {
    if (kDebugMode) return;
    SmartDialog.dismiss();
    try {
      final res = await Request().get(Api.latestApp, uaType: 'mob');
      if (res.data is Map || res.data.isEmpty) {
        if (!isAuto) {
          SmartDialog.showToast('检查更新失败，GitHub接口未返回数据，请检查网络');
        }
        return;
      }
      DateTime latest = DateTime.parse(res.data[0]['created_at']);
      DateTime current = DateTime.parse('${BuildConfig.buildTime}Z');
      current = current.copyWith(hour: current.hour - 8);
      if (current.compareTo(latest) >= 0) {
        if (!isAuto) {
          SmartDialog.showToast('已是最新版本');
        }
      } else {
        SmartDialog.show(
          animationType: SmartAnimationType.centerFade_otherSlide,
          builder: (context) {
            final ThemeData theme = Theme.of(context);
            return AlertDialog(
              title: const Text('🎉 发现新版本 '),
              content: SizedBox(
                height: 280,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${res.data[0]['tag_name']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text('${res.data[0]['body']}'),
                      TextButton(
                        onPressed: () => PageUtils.launchURL(
                            'https://github.com/bggRGjQaUbCoE/PiliPlus/commits/main'),
                        child: Text(
                          "点此查看完整更新(即commit)内容",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                    GStorage.setting.put(SettingBoxKey.autoUpdate, false);
                  },
                  child: Text(
                    '不再提醒',
                    style: TextStyle(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: SmartDialog.dismiss,
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => onDownload(res.data[0]),
                  child: const Text('Github'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('failed to check update: $e');
    }
  }

  // 下载适用于当前系统的安装包
  static Future<void> onDownload(data) async {
    await SmartDialog.dismiss();
    try {
      void download(plat) {
        if (data['assets'].isNotEmpty) {
          for (dynamic i in data['assets']) {
            if (i['name'].contains(plat)) {
              PageUtils.launchURL(i['browser_download_url']);
              break;
            }
          }
        }
      }

      if (Platform.isAndroid) {
        // 获取设备信息
        AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
        // [arm64-v8a]
        download(androidInfo.supportedAbis.first);
      } else {
        download('ios');
      }
    } catch (_) {
      PageUtils.launchURL(
          'https://github.com/bggRGjQaUbCoE/PiliPlus/releases/latest');
    }
  }

  static void appSign(Map<String, dynamic> params,
      [String appkey = Constants.appKey, String appsec = Constants.appSec]) {
    params['appkey'] = appkey;
    var searchParams = Uri(
        queryParameters:
            params.map((key, value) => MapEntry(key, value.toString()))).query;
    var sortedQueryString = (searchParams.split('&')..sort()).join('&');

    params['sign'] = md5
        .convert(utf8.encode(sortedQueryString + appsec))
        .toString(); // 获取MD5哈希值
  }

  static List<int> generateRandomBytes(int minLength, int maxLength) {
    return List<int>.generate(
      minLength + random.nextInt(maxLength - minLength + 1),
      (_) => 0x26 + random.nextInt(0x59), // dm_img_str不能有`%`
    );
  }

  static String base64EncodeRandomString(int minLength, int maxLength) {
    final randomBytes = generateRandomBytes(minLength, maxLength);
    final randomBase64 = base64.encode(randomBytes);
    return randomBase64.substring(0, randomBase64.length - 2);
  }

  static String getFileName(String uri, {bool fileExt = true}) {
    final i0 = uri.lastIndexOf('/') + 1;
    final i1 = fileExt ? uri.length : uri.lastIndexOf('.');
    return uri.substring(i0, i1);
  }

  static String genBuvid3() {
    return '${const UuidV4().generate().toUpperCase()}${random.nextInt(100000).toString().padLeft(5, "0")}infoc';
  }
}
