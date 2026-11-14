import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

/// 播放页 tag 区域的关键词过滤。
///
/// 只影响 tag 按钮的展示，不参与推荐流/相关视频的过滤。
abstract final class VideoTagFilter {
  static RegExp regExp = RegExp(Pref.banWordForVideoTag, caseSensitive: false);
  static bool enableFilter = regExp.pattern.isNotEmpty;

  /// 单个 tag 是否命中关键词。
  ///
  /// - 话题（topic）同时用 `#name` 和 `name` 匹配，兼容页面显示带 `#`、
  ///   以及关键词里手动写了 `#` 的情况；
  /// - BGM 不参与过滤。
  static bool matches(RegExp pattern, VideoTagItem item) {
    final name = item.tagName;
    if (name == null || name.isEmpty) return false;
    return switch (item.tagType) {
      'bgm' => false,
      'topic' => pattern.hasMatch('#$name') || pattern.hasMatch(name),
      _ => pattern.hasMatch(name),
    };
  }

  static bool blocked(VideoTagItem item) =>
      enableFilter && matches(regExp, item);

  static List<VideoTagItem>? apply(List<VideoTagItem>? tags) {
    if (!enableFilter || tags == null || tags.isEmpty) return tags;
    return tags.where((e) => !blocked(e)).toList();
  }
}
