import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

abstract final class RecommendFilter {
  static int minDurationForRcmd = Pref.minDurationForRcmd;
  static int minPlayForRcmd = Pref.minPlayForRcmd;
  static int minLikeRatioForRecommend = Pref.minLikeRatioForRecommend;
  static bool exemptFilterForFollowed = Pref.exemptFilterForFollowed;
  static bool applyFilterToRelatedVideos = Pref.applyFilterToRelatedVideos;
  static RegExp rcmdRegExp = RegExp(
    Pref.banWordForRecommend,
    caseSensitive: false,
  );
  static bool enableFilter = rcmdRegExp.pattern.isNotEmpty;
  static RegExp tagRegExp = RegExp(Pref.banWordForTag, caseSensitive: false);
  static bool enableTagFilter = tagRegExp.pattern.isNotEmpty;

  static bool filter(BaseVideoItemModel videoItem) {
    //由于相关视频中没有已关注标签，只能视为非关注视频
    if (videoItem.isFollowed && exemptFilterForFollowed) {
      return false;
    }
    return filterAll(videoItem);
  }

  static bool filterLikeRatio(int? like, int? view) {
    if (view != null) {
      return (view > -1 && view < minPlayForRcmd) ||
          (like != null &&
              like > -1 &&
              like * 100 < minLikeRatioForRecommend * view);
    }
    return false;
  }

  static bool filterTitle(String title) {
    return (enableFilter && rcmdRegExp.hasMatch(title));
  }

  static bool filterTag(Iterable<String>? tags) {
    return enableTagFilter && tags != null && tags.any(tagRegExp.hasMatch);
  }

  static bool filterTagInJson(Map json) {
    return filterTag(BaseVideoItemModel.parseTags(json));
  }

  static bool filterAll(BaseVideoItemModel videoItem) {
    return (videoItem.duration > 0 &&
            videoItem.duration < minDurationForRcmd) ||
        filterLikeRatio(videoItem.stat.like, videoItem.stat.view) ||
        filterTitle(videoItem.title) ||
        filterTag(videoItem.tags);
  }
}
