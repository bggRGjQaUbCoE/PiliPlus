import 'package:PiliPlus/features/shielding/shielding.dart';
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
  static ShieldRuleSet Function()? shieldRuleSetProvider;
  static bool useLegacyTextFilter = false;

  static bool get legacyRecommendationEnabled {
    final ruleSet =
        shieldRuleSetProvider?.call() ?? ShieldSettingsStore().snapshot();
    return ruleSet.isScopeEnabled(ShieldScope.recommendation);
  }

  static bool filter(BaseVideoItemModel videoItem) {
    if (!legacyRecommendationEnabled) {
      return false;
    }
    //由于相关视频中没有已关注标签，只能视为非关注视频
    if (videoItem.isFollowed && exemptFilterForFollowed) {
      return false;
    }
    return filterAll(videoItem);
  }

  static bool filterLikeRatio(int? like, int? view) {
    if (!legacyRecommendationEnabled) {
      return false;
    }
    if (view != null) {
      return (view > -1 && view < minPlayForRcmd) ||
          (like != null &&
              like > -1 &&
              like * 100 < minLikeRatioForRecommend * view);
    }
    return false;
  }

  static bool filterTitle(String title) {
    if (!legacyRecommendationEnabled) {
      return false;
    }
    if (!useLegacyTextFilter) {
      return false;
    }
    return (enableFilter && rcmdRegExp.hasMatch(title));
  }

  static bool filterAll(BaseVideoItemModel videoItem) {
    if (!legacyRecommendationEnabled) {
      return false;
    }
    return (videoItem.duration > 0 &&
            videoItem.duration < minDurationForRcmd) ||
        filterLikeRatio(videoItem.stat.like, videoItem.stat.view) ||
        filterTitle(videoItem.title);
  }
}
