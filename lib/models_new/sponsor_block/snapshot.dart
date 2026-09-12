import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';

String normalizeSponsorServer(String server) =>
    server.trim().replaceFirst(RegExp(r'/+$'), '');

enum SponsorBlockSource { community, pgc }

class SponsorBlockTarget {
  const SponsorBlockTarget({
    required this.directory,
    required this.bvid,
    required this.cid,
    required this.durationMs,
    required this.createdAt,
    this.source = .community,
    this.videoType = .ugc,
    this.epid,
    this.seasonId,
  });

  final String directory;
  final String bvid;
  final int cid;
  final int durationMs;
  final int createdAt;
  final SponsorBlockSource source;
  final VideoType videoType;
  final int? epid;
  final String? seasonId;
}

class SponsorBlockSnapshot {
  const SponsorBlockSnapshot({
    required this.bvid,
    required this.cid,
    required this.server,
    required this.fetchedAt,
    required this.mediaDurationMs,
    required this.segments,
    this.source = .community,
  });

  final String bvid;
  final String cid;
  final String server;
  final DateTime fetchedAt;
  final int mediaDurationMs;
  final List<SegmentItemModel> segments;
  final SponsorBlockSource source;

  factory SponsorBlockSnapshot.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1 ||
        json['bvid'] is! String ||
        json['cid'] is! String ||
        json['server'] is! String ||
        json['mediaDurationMs'] is! int ||
        (json['mediaDurationMs'] as int) < 0) {
      throw const FormatException('空降文件格式不受支持');
    }
    return SponsorBlockSnapshot(
      bvid: json['bvid'],
      cid: json['cid'],
      server: json['server'],
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      mediaDurationMs: json['mediaDurationMs'],
      segments: parseSegments(json['segments']),
      source: json['source'] == null
          ? .community
          : SponsorBlockSource.values.byName(json['source'] as String),
    );
  }

  static List<SegmentItemModel> parseSegments(Object? data) {
    if (data is! List) throw const FormatException('空降响应应为列表');
    return data.map((value) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('空降片段格式错误');
      }
      final interval = value['segment'];
      final duration = value['videoDuration'];
      if (interval is! List ||
          interval.length != 2 ||
          interval.any((e) => e is! num || !e.isFinite || e < 0) ||
          (interval[1] as num) < (interval[0] as num) ||
          value['category'] is! String ||
          value['UUID'] is! String ||
          (value['actionType'] != null && value['actionType'] is! String) ||
          (value['cid'] != null &&
              value['cid'] is! String &&
              value['cid'] is! int) ||
          (duration != null &&
              (duration is! num || !duration.isFinite || duration < 0))) {
        throw const FormatException('空降片段数据无效');
      }
      return SegmentItemModel.fromJson({
        ...value,
        'cid': value['cid']?.toString(),
      });
    }).toList();
  }

  List<SegmentItemModel> playableSegments(int durationMs) {
    if (durationMs <= 0) return [];
    return segments.where((item) {
      final duration = item.videoDuration;
      return (item.cid == null || item.cid == cid) &&
          SegmentType.values.any((e) => e.name == item.category) &&
          (item.actionType == null ||
              ActionType.values.any((e) => e.name == item.actionType)) &&
          item.segment.last <= durationMs &&
          (duration == null ||
              duration == 0 ||
              (duration - durationMs).abs() <= 2000);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
    'schemaVersion': 1,
    'bvid': bvid,
    'cid': cid,
    'server': server,
    'fetchedAt': fetchedAt.toUtc().toIso8601String(),
    'mediaDurationMs': mediaDurationMs,
    'segments': [for (final item in segments) item.toJson()],
    'source': source.name,
  };
}

enum SponsorBlockCacheStatus {
  ready,
  missing,
  invalid,
  differentSource,
  failed,
  cancelled,
  reused,
}

class SponsorBlockCacheResult {
  const SponsorBlockCacheResult(
    this.status, {
    this.snapshot,
    this.message,
    this.code,
  });

  final SponsorBlockCacheStatus status;
  final SponsorBlockSnapshot? snapshot;
  final String? message;
  final int? code;
  bool get isUsable =>
      status == SponsorBlockCacheStatus.ready ||
      status == SponsorBlockCacheStatus.reused;

  String get description => switch (status) {
    .ready || .reused =>
      snapshot!.segments.isEmpty
          ? '已查询，当前没有标记'
          : '已保存 ${snapshot!.segments.length} 个片段',
    .missing => '尚未保存空降信息',
    .invalid => '空降文件不可用，可手动更新',
    .differentSource => '来源与当前设置不同，可手动更新',
    .failed => message ?? '更新失败，已有空降文件保持原样',
    .cancelled => '更新已取消',
  };
}

class SponsorBlockFetchException implements Exception {
  const SponsorBlockFetchException(this.message, {this.code});
  final String message;
  final int? code;
}
