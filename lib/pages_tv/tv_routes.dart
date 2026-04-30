import 'package:PiliPlus/pages/live_room/view.dart';
import 'package:PiliPlus/pages/member/view.dart';
import 'package:PiliPlus/pages/search/view.dart';
import 'package:PiliPlus/pages/search_result/view.dart';
import 'package:PiliPlus/pages/video/view.dart';
import 'package:PiliPlus/pages_tv/dynamics/view.dart';
import 'package:PiliPlus/pages_tv/favorite/view.dart';
import 'package:PiliPlus/pages_tv/history/view.dart';
import 'package:PiliPlus/pages_tv/home/view.dart';
import 'package:PiliPlus/pages_tv/later/view.dart';
import 'package:PiliPlus/pages_tv/live/view.dart';
import 'package:PiliPlus/pages_tv/login/view.dart';
import 'package:PiliPlus/pages_tv/pgc/view.dart';
import 'package:PiliPlus/pages_tv/rank/view.dart';
import 'package:PiliPlus/pages_tv/search/view.dart';
import 'package:PiliPlus/pages_tv/setting/view.dart';
import 'package:get/get.dart';

class TVRoutes {
  static final List<GetPage<dynamic>> getPages = [
    GetPage(name: '/', page: () => const TVHomePage()),
    GetPage(name: '/tvVideo', page: () => const VideoDetailPageV()),
    GetPage(name: '/tvLive', page: () => const TVLivePage()),
    GetPage(name: '/tvPgc', page: () => const TVPgcPage()),
    GetPage(name: '/tvSearch', page: () => const TVSearchPage()),
    GetPage(name: '/tvHistory', page: () => const TVHistoryPage()),
    GetPage(name: '/tvLater', page: () => const TVLaterPage()),
    GetPage(name: '/tvFavorite', page: () => const TVFavoritePage()),
    GetPage(name: '/tvDynamics', page: () => const TVDynamicsPage()),
    GetPage(name: '/tvRank', page: () => const TVRankPage()),
    GetPage(name: '/tvLogin', page: () => const TVLoginPage()),
    GetPage(name: '/tvSetting', page: () => const TVSettingPage()),
    GetPage(name: '/videoV', page: () => const VideoDetailPageV()),
    GetPage(name: '/liveRoom', page: () => const LiveRoomPage()),
    GetPage(name: '/member', page: () => const MemberPage()),
    GetPage(name: '/search', page: () => const SearchPage()),
    GetPage(name: '/searchResult', page: () => const SearchResultPage()),
  ];
}
