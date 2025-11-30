import 'dart:convert';

/// 窗口类型定义
abstract class WindowArguments {
  const WindowArguments();

  static const String businessIdMain = 'main';
  static const String businessIdPlayer = 'player';

  factory WindowArguments.fromArguments(String arguments) {
    if (arguments.isEmpty) {
      return const MainWindowArguments();
    }
    final json = jsonDecode(arguments) as Map<String, dynamic>;
    final businessId = json['businessId'] as String? ?? '';
    switch (businessId) {
      case businessIdPlayer:
        return PlayerWindowArguments.fromJson(json);
      default:
        return const MainWindowArguments();
    }
  }

  Map<String, dynamic> toJson();

  String get businessId;

  String toArguments() => jsonEncode({"businessId": businessId, ...toJson()});

  @override
  String toString() {
    return 'WindowArguments(businessId: $businessId, data: ${toJson()})';
  }
}

/// 主窗口参数
class MainWindowArguments extends WindowArguments {
  const MainWindowArguments();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String get businessId => WindowArguments.businessIdMain;
}

/// 播放器窗口参数
class PlayerWindowArguments extends WindowArguments {
  const PlayerWindowArguments({
    required this.aid,
    required this.bvid,
    required this.cid,
    this.seasonId,
    this.epId,
    this.pgcType,
    this.cover,
    this.title,
    this.progress,
    this.videoType = 'ugc',
    this.extraArguments,
    // Settings passed from main window
    this.settings,
  });

  factory PlayerWindowArguments.fromJson(Map<String, dynamic> json) {
    // Handle videoType being either a String or VideoType enum
    final rawVideoType = json['videoType'];
    String videoTypeStr;
    if (rawVideoType is String) {
      videoTypeStr = rawVideoType;
    } else if (rawVideoType != null) {
      // Assume it's a VideoType enum, extract its name
      videoTypeStr = rawVideoType.toString().split('.').last;
    } else {
      videoTypeStr = 'ugc';
    }

    return PlayerWindowArguments(
      aid: json['aid'] as int,
      bvid: json['bvid'] as String,
      cid: json['cid'] as int,
      seasonId: json['seasonId'] as int?,
      epId: json['epId'] as int?,
      pgcType: json['pgcType'] as int?,
      cover: json['cover'] as String?,
      title: json['title'] as String?,
      progress: json['progress'] as int?,
      videoType: videoTypeStr,
      extraArguments: json['extraArguments'] as Map<String, dynamic>?,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  final int aid;
  final String bvid;
  final int cid;
  final int? seasonId;
  final int? epId;
  final int? pgcType;
  final String? cover;
  final String? title;
  final int? progress;
  final String videoType;
  final Map<String, dynamic>? extraArguments;
  /// Settings snapshot from main window
  final Map<String, dynamic>? settings;

  @override
  Map<String, dynamic> toJson() {
    return {
      'aid': aid,
      'bvid': bvid,
      'cid': cid,
      if (seasonId != null) 'seasonId': seasonId,
      if (epId != null) 'epId': epId,
      if (pgcType != null) 'pgcType': pgcType,
      if (cover != null) 'cover': cover,
      if (title != null) 'title': title,
      if (progress != null) 'progress': progress,
      'videoType': videoType,
      if (extraArguments != null) 'extraArguments': extraArguments,
      if (settings != null) 'settings': settings,
    };
  }

  @override
  String get businessId => WindowArguments.businessIdPlayer;
}
