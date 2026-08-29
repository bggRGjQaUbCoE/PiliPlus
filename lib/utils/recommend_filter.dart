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
  static bool filterPromotionalTitles = Pref.filterPromotionalTitles;
  static bool filterClickbaitTitles = Pref.filterClickbaitTitles;
  static final RegExp promotionalTitleRegExp = RegExp(
    r'商业合作|商务合作|恰饭|推广|广告|赞助|带货|种草|开箱推广',
    caseSensitive: false,
  );
  static final RegExp clickbaitTitleRegExp = RegExp(
    r'震惊|惊呆|竟然|居然|万万没想到|不敢相信|史上最|必看|太离谱|全网首发|看完沉默',
    caseSensitive: false,
  );

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
    return (enableFilter && rcmdRegExp.hasMatch(title)) ||
        (filterPromotionalTitles && promotionalTitleRegExp.hasMatch(title)) ||
        (filterClickbaitTitles && clickbaitTitleRegExp.hasMatch(title));
  }

  static bool filterAll(BaseVideoItemModel videoItem) {
    return (videoItem.duration > 0 &&
            videoItem.duration < minDurationForRcmd) ||
        filterLikeRatio(videoItem.stat.like, videoItem.stat.view) ||
        filterTitle(videoItem.title);
  }
}
