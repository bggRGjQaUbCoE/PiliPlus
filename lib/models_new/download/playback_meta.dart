import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';

class DownloadPlaybackMeta {
  final int version;
  final DownloadPlaybackChapters? chapters;
  final DownloadPlaybackSkipSegments? sponsorBlock;
  final DownloadPlaybackSkipSegments? clipInfo;

  const DownloadPlaybackMeta({
    this.version = 1,
    this.chapters,
    this.sponsorBlock,
    this.clipInfo,
  });

  bool get isEmpty =>
      (chapters?.items.isEmpty ?? true) &&
      (sponsorBlock?.items.isEmpty ?? true) &&
      (clipInfo?.items.isEmpty ?? true);

  factory DownloadPlaybackMeta.fromJson(Map<String, dynamic> json) =>
      DownloadPlaybackMeta(
        version: json['version'] as int? ?? 1,
        chapters: json['chapters'] == null
            ? null
            : DownloadPlaybackChapters.fromJson(
                (json['chapters'] as Map).cast<String, dynamic>(),
              ),
        sponsorBlock: json['sponsor_block'] == null
            ? null
            : DownloadPlaybackSkipSegments.fromJson(
                (json['sponsor_block'] as Map).cast<String, dynamic>(),
              ),
        clipInfo: json['clip_info'] == null
            ? null
            : DownloadPlaybackSkipSegments.fromJson(
                (json['clip_info'] as Map).cast<String, dynamic>(),
              ),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'version': version,
    'chapters': chapters?.toJson(),
    'sponsor_block': sponsorBlock?.toJson(),
    'clip_info': clipInfo?.toJson(),
  };
}

class DownloadPlaybackChapters {
  final int fetchedAt;
  final List<DownloadPlaybackChapter> items;

  const DownloadPlaybackChapters({
    required this.fetchedAt,
    required this.items,
  });

  factory DownloadPlaybackChapters.fromJson(Map<String, dynamic> json) =>
      DownloadPlaybackChapters(
        fetchedAt: json['fetched_at'] as int? ?? 0,
        items: ((json['items'] as List?) ?? const [])
            .map(
              (item) => DownloadPlaybackChapter.fromJson(
                (item as Map).cast<String, dynamic>(),
              ),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'fetched_at': fetchedAt,
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class DownloadPlaybackChapter {
  final int? type;
  final int? fromMs;
  final int? toMs;
  final String? content;
  final String? imgUrl;

  const DownloadPlaybackChapter({
    this.type,
    this.fromMs,
    this.toMs,
    this.content,
    this.imgUrl,
  });

  factory DownloadPlaybackChapter.fromJson(Map<String, dynamic> json) =>
      DownloadPlaybackChapter(
        type: json['type'] as int?,
        fromMs: json['from_ms'] as int?,
        toMs: json['to_ms'] as int?,
        content: json['content'] as String?,
        imgUrl: json['img_url'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'from_ms': fromMs,
    'to_ms': toMs,
    'content': content,
    'img_url': imgUrl,
  };
}

class DownloadPlaybackSkipSegments {
  final int fetchedAt;
  final List<DownloadPlaybackSkipSegment> items;

  const DownloadPlaybackSkipSegments({
    required this.fetchedAt,
    required this.items,
  });

  factory DownloadPlaybackSkipSegments.fromJson(Map<String, dynamic> json) =>
      DownloadPlaybackSkipSegments(
        fetchedAt: json['fetched_at'] as int? ?? 0,
        items: ((json['items'] as List?) ?? const [])
            .map(
              (item) => DownloadPlaybackSkipSegment.fromJson(
                (item as Map).cast<String, dynamic>(),
              ),
            )
            .toList(),
      );

  List<SegmentItemModel> toSegmentItemModels() =>
      items.map((item) => item.toSegmentItemModel()).toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
    'fetched_at': fetchedAt,
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class DownloadPlaybackSkipSegment {
  final String category;
  final String? actionType;
  final List<int> segment;
  final String uuid;
  final int? videoDuration;
  final int? votes;

  const DownloadPlaybackSkipSegment({
    required this.category,
    this.actionType,
    required this.segment,
    required this.uuid,
    this.videoDuration,
    this.votes,
  });

  factory DownloadPlaybackSkipSegment.fromSegmentItemModel(
    SegmentItemModel item,
  ) => DownloadPlaybackSkipSegment(
    category: item.category,
    actionType: item.actionType,
    segment: List<int>.from(item.segment),
    uuid: item.uuid,
    videoDuration: item.videoDuration?.round(),
    votes: item.votes,
  );

  factory DownloadPlaybackSkipSegment.fromJson(Map<String, dynamic> json) =>
      DownloadPlaybackSkipSegment(
        category: json['category'] as String? ?? '',
        actionType: json['action_type'] as String?,
        segment: List<int>.from((json['segment'] as List?) ?? const [0, 0]),
        uuid: json['uuid'] as String? ?? '',
        videoDuration: json['video_duration'] as int?,
        votes: json['votes'] as int?,
      );

  SegmentItemModel toSegmentItemModel() => SegmentItemModel(
    category: category,
    actionType: actionType,
    segment: List<int>.from(segment),
    uuid: uuid,
    videoDuration: videoDuration,
    votes: votes,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'category': category,
    'action_type': actionType,
    'segment': segment,
    'uuid': uuid,
    'video_duration': videoDuration,
    'votes': votes,
  };
}
