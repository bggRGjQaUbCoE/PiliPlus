import 'package:PiliPlus/models_new/space/space/data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

abstract final class SpaceFilter {
  static Set<String> hiddenSections = Pref.hiddenSpaceSections;

  static const Map<String, String> labels = {
    'tab_home': '分页：首页',
    'tab_dynamic': '分页：动态',
    'tab_contribute': '分页：投稿',
    'tab_shop': '分页：商品',
    'tab_bangumi': '分页：追番',
    'tab_cheese': '分页：课堂',
    'tab_favorite': '分页：收藏夹',
    'module_live': '首页模块：直播',
    'module_charge': '首页模块：充电',
    'module_video': '首页模块：视频',
    'module_article': '首页模块：图文/文章',
    'module_audio': '首页模块：音频',
    'module_comic': '首页模块：漫画',
    'module_bangumi': '首页模块：追番',
    'module_favorite': '首页模块：收藏夹',
    'module_coin': '首页模块：最近投币',
    'module_like': '首页模块：最近点赞',
    'module_course': '首页模块：课堂',
  };

  static bool hideTab(String? param) => hiddenSections.contains('tab_$param');

  static void apply(SpaceData data) {
    if (hiddenSections.contains('module_live')) data.live = null;
    if (hiddenSections.contains('module_charge')) data.elec = null;
    if (hiddenSections.contains('module_video')) data.archive = null;
    if (hiddenSections.contains('module_article')) data.article = null;
    if (hiddenSections.contains('module_audio')) data.audios = null;
    if (hiddenSections.contains('module_comic')) data.comic = null;
    if (hiddenSections.contains('module_bangumi')) data.season = null;
    if (hiddenSections.contains('module_favorite')) data.favourite2 = null;
    if (hiddenSections.contains('module_coin')) data.coinArchive = null;
    if (hiddenSections.contains('module_like')) data.likeArchive = null;
    if (hiddenSections.contains('module_course')) data.cheese = null;
  }
}
