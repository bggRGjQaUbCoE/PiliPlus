import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

abstract final class RecommendFilter {
  static int minDurationForRcmd = Pref.minDurationForRcmd;
  static int minPlayForRcmd = Pref.minPlayForRcmd;
  static int minLikeRatioForRecommend = Pref.minLikeRatioForRecommend;
  static bool exemptFilterForFollowed = Pref.exemptFilterForFollowed;
  static bool applyFilterToRelatedVideos = Pref.applyFilterToRelatedVideos;
  static final List<String> rcmdBanWords = Pref.banWordForRecommend;
  static RegExp rcmdRegExp = RegExp(
    rcmdBanWords.map(RegExp.escape).join('|'),
    caseSensitive: false,
  );
  static bool enableFilter = rcmdBanWords.isNotEmpty;
  static final List<String> tagBanWords = Pref.banTagForRecommend;
  static RegExp tagRegExp = RegExp(
    tagBanWords.map(RegExp.escape).join('|'),
    caseSensitive: false,
  );
  static bool enableTagFilter = tagBanWords.isNotEmpty;

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

  static bool filterTag(String? tag) {
    return enableTagFilter && tag != null && tagRegExp.hasMatch(tag);
  }

  static bool filterTagList(List<String> tags) {
    if (!enableTagFilter) return false;
    return tags.any(tagRegExp.hasMatch);
  }

  static bool filterAll(BaseVideoItemModel videoItem) {
    return (videoItem.duration > 0 &&
            videoItem.duration < minDurationForRcmd) ||
        filterLikeRatio(videoItem.stat.like, videoItem.stat.view) ||
        filterTitle(videoItem.title) ||
        filterTag(videoItem.tag);
  }
}
