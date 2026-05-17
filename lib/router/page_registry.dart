import 'package:PiliPlus/pages/about/view.dart';
import 'package:PiliPlus/pages/article/view.dart';
import 'package:PiliPlus/pages/article_list/view.dart';
import 'package:PiliPlus/pages/audio/view.dart';
import 'package:PiliPlus/pages/blacklist/view.dart';
import 'package:PiliPlus/pages/bubble/view.dart';
import 'package:PiliPlus/pages/danmaku_block/view.dart';
import 'package:PiliPlus/pages/dlna/view.dart';
import 'package:PiliPlus/pages/download/view.dart';
import 'package:PiliPlus/pages/dynamics/view.dart';
import 'package:PiliPlus/pages/dynamics_create_vote/view.dart';
import 'package:PiliPlus/pages/dynamics_detail/view.dart';
import 'package:PiliPlus/pages/dynamics_topic/view.dart';
import 'package:PiliPlus/pages/dynamics_topic_rcmd/view.dart';
import 'package:PiliPlus/pages/fan/view.dart';
import 'package:PiliPlus/pages/fav/view.dart';
import 'package:PiliPlus/pages/fav_create/view.dart';
import 'package:PiliPlus/pages/fav_detail/view.dart';
import 'package:PiliPlus/pages/fav_search/view.dart';
import 'package:PiliPlus/pages/follow/view.dart';
import 'package:PiliPlus/pages/follow_search/view.dart';
import 'package:PiliPlus/pages/follow_type/follow_same/view.dart';
import 'package:PiliPlus/pages/follow_type/followed/view.dart';
import 'package:PiliPlus/pages/history/view.dart';
import 'package:PiliPlus/pages/history_search/view.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/hot/view.dart';
import 'package:PiliPlus/pages/later/view.dart';
import 'package:PiliPlus/pages/later_search/view.dart';
import 'package:PiliPlus/pages/live_dm_block/view.dart';
import 'package:PiliPlus/pages/live_room/view.dart';
import 'package:PiliPlus/pages/login/view.dart';
import 'package:PiliPlus/pages/main/view.dart';
import 'package:PiliPlus/pages/main_reply/view.dart';
import 'package:PiliPlus/pages/match_info/view.dart';
import 'package:PiliPlus/pages/member/view.dart';
import 'package:PiliPlus/pages/member_dynamics/view.dart';
import 'package:PiliPlus/pages/member_guard/view.dart';
import 'package:PiliPlus/pages/member_profile/view.dart';
import 'package:PiliPlus/pages/member_search/view.dart';
import 'package:PiliPlus/pages/member_upower_rank/view.dart';
import 'package:PiliPlus/pages/member_video_web/archive/view.dart';
import 'package:PiliPlus/pages/member_video_web/season_series/view.dart';
import 'package:PiliPlus/pages/msg_feed_top/at_me/view.dart';
import 'package:PiliPlus/pages/msg_feed_top/like_detail/view.dart';
import 'package:PiliPlus/pages/msg_feed_top/like_me/view.dart';
import 'package:PiliPlus/pages/msg_feed_top/reply_me/view.dart';
import 'package:PiliPlus/pages/msg_feed_top/sys_msg/view.dart';
import 'package:PiliPlus/pages/music/view.dart';
import 'package:PiliPlus/pages/my_reply/view.dart';
import 'package:PiliPlus/pages/popular_precious/view.dart';
import 'package:PiliPlus/pages/popular_series/view.dart';
import 'package:PiliPlus/pages/search/view.dart';
import 'package:PiliPlus/pages/search_result/view.dart';
import 'package:PiliPlus/pages/search_trending/view.dart';
import 'package:PiliPlus/pages/setting/extra_setting.dart';
import 'package:PiliPlus/pages/setting/pages/bar_set.dart';
import 'package:PiliPlus/pages/setting/pages/color_select.dart';
import 'package:PiliPlus/pages/setting/pages/display_mode.dart';
import 'package:PiliPlus/pages/setting/pages/font_size_select.dart';
import 'package:PiliPlus/pages/setting/pages/logs.dart';
import 'package:PiliPlus/pages/setting/pages/net_debug.dart';
import 'package:PiliPlus/pages/setting/pages/play_speed_set.dart';
import 'package:PiliPlus/pages/setting/play_setting.dart';
import 'package:PiliPlus/pages/setting/privacy_setting.dart';
import 'package:PiliPlus/pages/setting/recommend_setting.dart';
import 'package:PiliPlus/pages/setting/style_setting.dart';
import 'package:PiliPlus/pages/setting/video_setting.dart';
import 'package:PiliPlus/pages/setting/view.dart';
import 'package:PiliPlus/pages/settings_search/view.dart';
import 'package:PiliPlus/pages/space_setting/view.dart';
import 'package:PiliPlus/pages/sponsor_block/view.dart';
import 'package:PiliPlus/pages/subscription/view.dart';
import 'package:PiliPlus/pages/subscription_detail/view.dart';
import 'package:PiliPlus/pages/video/view.dart';
import 'package:PiliPlus/pages/webdav/view.dart';
import 'package:PiliPlus/pages/webview/view.dart';
import 'package:PiliPlus/pages/whisper/view.dart';
import 'package:PiliPlus/pages/whisper_detail/view.dart';
import 'package:PiliPlus/pages/mine/view.dart';
import 'package:PiliPlus/router/app_routes.dart';
import 'package:flutter/material.dart';

typedef PageBuilder = Widget Function();

abstract final class PageRegistry {
  static const Map<String, PageBuilder> pages = {
    AppRoutes.root: MainApp.new,
    AppRoutes.home: HomePage.new,
    AppRoutes.hot: HotPage.new,
    AppRoutes.videoV: VideoDetailPageV.new,
    AppRoutes.webview: WebviewPage.new,
    AppRoutes.setting: SettingPage.new,
    AppRoutes.fav: FavPage.new,
    AppRoutes.favDetail: FavDetailPage.new,
    AppRoutes.later: LaterPage.new,
    AppRoutes.history: HistoryPage.new,
    AppRoutes.search: SearchPage.new,
    AppRoutes.searchResult: SearchResultPage.new,
    AppRoutes.dynamics: DynamicsPage.new,
    AppRoutes.dynamicDetail: DynamicDetailPage.new,
    AppRoutes.follow: FollowPage.new,
    AppRoutes.fan: FansPage.new,
    AppRoutes.liveRoom: LiveRoomPage.new,
    AppRoutes.member: MemberPage.new,
    AppRoutes.memberSearch: MemberSearchPage.new,
    AppRoutes.recommendSetting: RecommendSetting.new,
    AppRoutes.videoSetting: VideoSetting.new,
    AppRoutes.playSetting: PlaySetting.new,
    AppRoutes.styleSetting: StyleSetting.new,
    AppRoutes.privacySetting: PrivacySetting.new,
    AppRoutes.extraSetting: ExtraSetting.new,
    AppRoutes.blackListPage: BlackListPage.new,
    AppRoutes.colorSetting: ColorSelectPage.new,
    AppRoutes.fontSizeSetting: FontSizeSelectPage.new,
    AppRoutes.displayModeSetting: SetDisplayMode.new,
    AppRoutes.about: AboutPage.new,
    AppRoutes.articlePage: ArticlePage.new,
    AppRoutes.playSpeedSet: PlaySpeedPage.new,
    AppRoutes.favSearch: FavSearchPage.new,
    AppRoutes.historySearch: HistorySearchPage.new,
    AppRoutes.laterSearch: LaterSearchPage.new,
    AppRoutes.followSearch: FollowSearchPage.new,
    AppRoutes.whisper: WhisperPage.new,
    AppRoutes.whisperDetail: WhisperDetailPage.new,
    AppRoutes.replyMe: ReplyMePage.new,
    AppRoutes.atMe: AtMePage.new,
    AppRoutes.likeMe: LikeMePage.new,
    AppRoutes.sysMsg: SysMsgPage.new,
    AppRoutes.loginPage: LoginPage.new,
    AppRoutes.memberDynamics: MemberDynamicsPage.new,
    AppRoutes.logs: LogsPage.new,
    AppRoutes.netDebug: NetDebugPage.new,
    AppRoutes.subscription: SubPage.new,
    AppRoutes.subDetail: SubDetailPage.new,
    AppRoutes.danmakuBlock: DanmakuBlockPage.new,
    AppRoutes.sponsorBlock: SponsorBlockPage.new,
    AppRoutes.createFav: CreateFavPage.new,
    AppRoutes.editProfile: EditProfilePage.new,
    AppRoutes.settingsSearch: SettingsSearchPage.new,
    AppRoutes.webdavSetting: WebDavSettingPage.new,
    AppRoutes.searchTrending: SearchTrendingPage.new,
    AppRoutes.dynTopic: DynTopicPage.new,
    AppRoutes.articleList: ArticleListPage.new,
    AppRoutes.barSetting: BarSetPage.new,
    AppRoutes.upowerRank: UpowerRankPage.new,
    AppRoutes.spaceSetting: SpaceSettingPage.new,
    AppRoutes.dynTopicRcmd: DynTopicRcmdPage.new,
    AppRoutes.matchInfo: MatchInfoPage.new,
    AppRoutes.msgLikeDetail: LikeDetailPage.new,
    AppRoutes.liveDmBlockPage: LiveDmBlockPage.new,
    AppRoutes.createVote: CreateVotePage.new,
    AppRoutes.musicDetail: MusicDetailPage.new,
    AppRoutes.popularSeries: PopularSeriesPage.new,
    AppRoutes.popularPrecious: PopularPreciousPage.new,
    AppRoutes.audio: AudioPage.new,
    AppRoutes.mainReply: MainReplyPage.new,
    AppRoutes.followed: FollowedPage.new,
    AppRoutes.sameFollowing: FollowSamePage.new,
    AppRoutes.download: DownloadPage.new,
    AppRoutes.dlna: DLNAPage.new,
    AppRoutes.myReply: MyReply.new,
    AppRoutes.videoWeb: MemberVideoWeb.new,
    AppRoutes.ssWeb: MemberSSWeb.new,
    AppRoutes.memberGuard: MemberGuard.new,
    AppRoutes.bubble: BubblePage.new,
    AppRoutes.mine: MinePage.new,
  };

  static const Set<String> newTabRoutes = {
    AppRoutes.videoV,
    AppRoutes.liveRoom,
    AppRoutes.articlePage,
    AppRoutes.member,
    AppRoutes.audio,
    AppRoutes.musicDetail,
    AppRoutes.webview,
    AppRoutes.dynamicDetail,
    AppRoutes.memberDynamics,
  };

  static const Map<String, String> routeTitles = {
    AppRoutes.root: '首页',
    AppRoutes.home: '首页',
    AppRoutes.hot: '热门',
    AppRoutes.videoV: '视频',
    AppRoutes.webview: '网页',
    AppRoutes.setting: '设置',
    AppRoutes.fav: '收藏',
    AppRoutes.favDetail: '收藏详情',
    AppRoutes.later: '稍后再看',
    AppRoutes.history: '历史记录',
    AppRoutes.search: '搜索',
    AppRoutes.searchResult: '搜索结果',
    AppRoutes.dynamics: '动态',
    AppRoutes.dynamicDetail: '动态详情',
    AppRoutes.follow: '关注',
    AppRoutes.fan: '粉丝',
    AppRoutes.liveRoom: '直播',
    AppRoutes.member: '用户',
    AppRoutes.memberSearch: '搜索',
    AppRoutes.loginPage: '登录',
    AppRoutes.whisper: '消息',
    AppRoutes.whisperDetail: '私信',
    AppRoutes.subscription: '订阅',
    AppRoutes.subDetail: '订阅详情',
    AppRoutes.download: '下载',
    AppRoutes.articlePage: '文章',
    AppRoutes.articleList: '文章列表',
    AppRoutes.musicDetail: '音乐',
    AppRoutes.audio: '音频',
    AppRoutes.about: '关于',
  };

  static String titleForRoute(String route) =>
      routeTitles[route] ?? route.replaceFirst('/', '');

  static Widget? buildPage(String route) {
    final builder = pages[route];
    return builder?.call();
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = pages[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: (_) => builder(),
        settings: settings,
      );
    }
    return MaterialPageRoute(
      builder: (_) => const Scaffold(body: Center(child: Text('页面未找到'))),
      settings: settings,
    );
  }
}
