import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/models_new/history/history.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:material_ui/material_ui.dart'
    show ColorScheme, Widget, Positioned;

class HistoryItemModel with MultiSelectData {
  String? title;
  String? cover;
  List<String>? covers;
  String? uri;
  late History history;
  int? videos;
  String? authorName;
  int? authorMid;
  int? viewAt;
  int? progress;
  String? badge;
  String? showTitle;
  int? duration;
  bool get hasDuration => duration != null && duration != 0;
  int? isFav;
  int? kid;
  String? tagName;
  int? liveStatus;

  Widget? get label => isFav == 1
      ? const PBadge(
          text: '已收藏',
          top: 6.0,
          right: 6.0,
          type: .gray,
        )
      : badge?.isNotEmpty == true
      ? PBadge(
          text: badge,
          top: 6.0,
          right: 6.0,
          type: history.business == 'live' && liveStatus != 1
              ? .gray
              : .primary,
        )
      : null;

  Iterable<Widget> progressIndicator(ColorScheme colorScheme) sync* {
    yield PBadge(
      text: progress == -1
          ? '已看完'
          : '${DurationUtils.formatDuration(progress)}/${DurationUtils.formatDuration(duration)}',
      right: 6.0,
      bottom: 8.0,
      type: .gray,
    );
    if (progress != null && progress != 0) {
      yield Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: VideoProgressIndicator(
          color: colorScheme.primary,
          backgroundColor: colorScheme.secondaryContainer,
          progress: progress == -1 ? 1 : progress! / duration!,
        ),
      );
    }
  }

  /// The history API uses seconds as the progress unit
  /// while the player expects milliseconds.
  ///
  /// The history API uses `-1` to indicate that the video has been fully watched.
  /// When reopened, playback should start from the beginning to avoid resuming from
  /// the last playback position associated with the video streaming account.
  int? get playbackProgress {
    final progress = this.progress;
    if (progress == null) return null;
    return progress == -1 ? 0 : progress * Duration.millisecondsPerSecond;
  }

  HistoryItemModel({
    this.title,
    this.cover,
    this.covers,
    this.uri,
    required this.history,
    this.videos,
    this.authorName,
    this.authorMid,
    this.viewAt,
    this.progress,
    this.badge,
    this.showTitle,
    this.duration,
    this.isFav,
    this.kid,
    this.tagName,
    this.liveStatus,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) =>
      HistoryItemModel(
        title: json['title'] as String?,
        cover: json['cover'] as String?,
        covers: (json['covers'] as List?)?.fromCast(),
        uri: json['uri'] as String?,
        history: json['history'] == null
            ? History()
            : History.fromJson(json['history'] as Map<String, dynamic>),
        videos: json['videos'] as int?,
        authorName: json['author_name'] as String?,
        authorMid: json['author_mid'] as int?,
        viewAt: json['view_at'] as int?,
        progress: json['progress'] as int?,
        badge: json['badge'] as String?,
        showTitle: json['show_title'] as String?,
        duration: json['duration'] as int?,
        isFav: json['is_fav'] as int?,
        kid: json['kid'] as int?,
        tagName: json['tag_name'] as String?,
        liveStatus: json['live_status'] as int?,
      );
}
