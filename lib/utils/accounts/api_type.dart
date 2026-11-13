import 'package:PiliPlus/grpc/url.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/models/common/account_type.dart';

abstract final class ApiType {
  // TODO: grpc api type
  static const Map<AccountType, Set<String>> apiTypeSet = {
    AccountType.heartbeat: {
      Api.videoIntro,
      Api.replyList,
      Api.replyReplyList,

      // history
      Api.heartBeat,
      Api.historyReport,
      Api.roomEntryAction,
      Api.liveLikeReport,
      Api.mediaListHistory,

      // live trace
      Api.liveTraceE,
      Api.liveTraceX,

      // Api.historyList,
      // Api.pauseHistory,
      // Api.clearHistory,
      // Api.delHistory,
      // Api.searchHistory,
      // Api.historyStatus,

      // progress
      Api.pgcInfo,
      Api.pugvInfo,

      Api.ab2c,
      Api.liveRoomInfo,
      Api.liveRoomInfoH5,
      Api.onlineTotal,
      Api.dynamicDetail,
      Api.aiConclusion,
      Api.seasonArchives,
      Api.seriesArchives,
      Api.liveRoomDmToken,
      Api.liveRoomDmPrefetch,
      Api.superChatMsg,
      Api.getLiveInfoByUser,

      // Api.memberInfo,
      // Api.bgmDetail,
      // Api.space,
      // Api.spaceAudio,
      // Api.spaceComic,
      // Api.spaceArchive,
      // Api.spaceChargingArchive,
      // Api.spaceSeason,
      // Api.spaceSeries,
      // Api.spaceBangumi,
      // Api.spaceOpus,
      // Api.spaceFav,
      // Api.seasonSeries,
      // Api.matchInfo,
      // Api.articleList,
      // Api.opusDetail,
      // Api.articleView,
      // Api.articleInfo,
    },
    AccountType.recommend: {
      Api.recommendListWeb,
      Api.recommendListApp,
      Api.feedDislike,
      Api.feedDislikeCancel,
      Api.hotList,
      Api.relatedList,
      Api.liveList,
      Api.searchTrending,
      Api.searchRecommend,
      Api.getRankApi,
      Api.pgcRank,
      Api.pgcSeasonRank,
      Api.pgcIndexResult,
      Api.popularSeriesOne,
      Api.popularSeriesList,
      Api.popularPrecious,
      Api.liveAreaList,
      Api.liveFeedIndex,
      Api.liveSecondList,
      Api.liveRoomAreaList,
      Api.bgmRecommend,
      Api.dynTopicRcmd,
      Api.topicFeed,
      Api.topicTop,
      Api.liveFeedback,
      // 不携带用户搜索关键词，仍按「推荐」账号身份请求
      Api.hotSearchList,
      Api.searchDefault,
      Api.searchArchive, // 支持 keyword，但当前仅用于空间投稿列表（不传）
    },
    // 会携带用户输入关键词的搜索接口
    AccountType.search: {
      Api.searchAll,
      Api.searchByType,
      Api.searchSuggest,
      Api.liveSearch,
      Api.dynSearch,
      // 空间投稿搜索（grpc 请求路径为 appBaseUrl + url）
      '${HttpString.appBaseUrl}${GrpcUrl.searchArchive}',
    },
    // progress
    AccountType.video: {
      Api.ugcUrl,
      Api.pgcUrl,
      Api.pugvUrl,
      Api.ogvUrl,
      Api.tvPlayUrl,
      Api.videoshot,
    },
  };

  static const loginApi = {
    Api.getTVCode,
    Api.qrcodePoll,
    Api.getCaptcha,
    Api.getWebKey,
    Api.appSmsCode,
    Api.loginByPwdApi,
    Api.logInByAppSms,
    Api.safeCenterGetInfo,
    Api.preCapture,
    Api.safeCenterSmsCode,
    Api.safeCenterSmsVerify,
    Api.oauth2AccessToken,
  };
}
