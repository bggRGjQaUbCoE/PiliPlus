import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

abstract final class RecommendFilter {
  static int minDurationForRcmd = Pref.minDurationForRcmd;
  static int minPlayForRcmd = Pref.minPlayForRcmd;
  static int minLikeRatioForRecommend = Pref.minLikeRatioForRecommend;
  static bool exemptFilterForFollowed = Pref.exemptFilterForFollowed;
  static bool applyFilterToRelatedVideos = Pref.applyFilterToRelatedVideos;
  static bool applyFilterToHotVideos = Pref.applyFilterToHotVideos;
  static bool applyFilterToRankVideos = Pref.applyFilterToRankVideos;
  static bool applyFilterToSearch = Pref.applyFilterToSearch;

  static RegExp rcmdRegExp = RegExp(
    Pref.parseBanWordToRegex(Pref.banWordForRecommend),
    caseSensitive: false,
  );
  static bool enableFilter = rcmdRegExp.pattern.isNotEmpty;
  static RegExp rcmdUpNameRegExp = RegExp(
    Pref.parseBanWordToRegex(Pref.banWordForRecommendUpName),
    caseSensitive: false,
  );
  static bool enableUpNameFilter = rcmdUpNameRegExp.pattern.isNotEmpty;
  static Map<int, String> recommendBlockedMids = Pref.recommendBlockedMids;

  static bool isWhitelisted(int? mid) {
    return mid != null && GlobalData().whitelistMids.containsKey(mid);
  }

  static bool filter(BaseVideoItemModel videoItem) {
    final mid = videoItem.owner.mid;
    if (filterUser(mid)) {
      return true;
    }
    if (isWhitelisted(mid)) {
      return false;
    }
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

  static bool filterUpName(String? name) {
    return enableUpNameFilter &&
        name != null &&
        rcmdUpNameRegExp.hasMatch(name);
  }

  static bool filterUser(int? mid) {
    return recommendBlockedMids.isNotEmpty &&
        mid != null &&
        recommendBlockedMids.containsKey(mid);
  }

  static bool filterAll(BaseVideoItemModel videoItem) {
    final mid = videoItem.owner.mid;
    if (filterUser(mid)) {
      return true;
    }
    if (isWhitelisted(mid)) {
      return false;
    }
    return (videoItem.duration > 0 &&
            videoItem.duration < minDurationForRcmd) ||
        filterLikeRatio(videoItem.stat.like, videoItem.stat.view) ||
        filterTitle(videoItem.title) ||
        filterUpName(videoItem.owner.name);
  }

  static bool searchShouldRemove(int? mid, String title) {
    if (!applyFilterToSearch) return false;
    if (filterUser(mid)) return true;
    if (isWhitelisted(mid)) return false;
    return filterTitle(title);
  }
}
