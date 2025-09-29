import 'package:PiliPlus/http/constants.dart';
import 'package:flutter/material.dart';

class StyleString {
  static const double cardSpace = 8;
  static const double safeSpace = 12;
  static const BorderRadius mdRadius = BorderRadius.all(imgRadius);
  static const Radius imgRadius = Radius.circular(10);
  static const double aspectRatio = 16 / 10;
  static const bottomSheetRadius = BorderRadius.vertical(
    top: Radius.circular(18),
  );
}

class Constants {
  static const appName = 'PiliPlus';
  static const sourceCodeUrl = 'https://github.com/bggRGjQaUbCoE/PiliPlus';

  // 27eb53fc9058f8c3  移动端 Android
  // 4409e2ce8ffd12b8  HD版
  static const String appKey = 'dfca71928277209b';
  // 59b43e04ad6965f34319062b478f83dd TV端
  static const String appSec = 'b5475a8825547a4fc26c7d518eaaa02e';
  static const String thirdSign = '04224646d1fea004e79606d3b038c84a';
  static const String thirdApi =
      'https://www.mcbbs.net/template/mcbbs/image/special_photo_bg.png';

  static const String traceId =
      '11111111111111111111111111111111:1111111111111111:0:0';
  static const String userAgent =
      'Mozilla/5.0 BiliDroid/2.0.1 (bbcallen@gmail.com) os/android model/android_hd mobi_app/android_hd build/2001100 channel/master innerVer/2001100 osVer/15 network/2';
  static const String statistics =
      '{"appId":5,"platform":3,"version":"2.0.1","abtest":""}';
  // 请求时会自动encodeComponent

  // app
  static const String userAgentApp =
      'Mozilla/5.0 BiliDroid/8.43.0 (bbcallen@gmail.com) os/android model/android mobi_app/android build/8430300 channel/master innerVer/8430300 osVer/15 network/2';

  static const String statisticsApp =
      '{"appId":1,"platform":3,"version":"8.43.0","abtest":""}';

  static const baseHeaders = {
    'connection': 'keep-alive',
    'accept-encoding': 'br,gzip',
    'referer': HttpString.baseUrl,
    'env': 'prod',
    'app-key': 'android64',
    'x-bili-aurora-zone': 'sh001',
  };

  static final urlRegex = RegExp(
    r'https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]',
  );

  static const goodsUrlPrefix = "https://gaoneng.bilibili.com/tetris";

  // 超分辨率滤镜
  static const List<String> mpvAnime4KShaders = [
    'Anime4K_Clamp_Highlights.glsl',
    'Anime4K_Restore_CNN_VL.glsl',
    'Anime4K_Upscale_CNN_x2_VL.glsl',
    'Anime4K_AutoDownscalePre_x2.glsl',
    'Anime4K_AutoDownscalePre_x4.glsl',
    'Anime4K_Upscale_CNN_x2_M.glsl',
  ];

  // 超分辨率滤镜 (轻量)
  static const mpvAnime4KShadersLite = [
    'Anime4K_Clamp_Highlights.glsl',
    'Anime4K_Restore_CNN_M.glsl',
    'Anime4K_Restore_CNN_S.glsl',
    'Anime4K_Upscale_CNN_x2_M.glsl',
    'Anime4K_AutoDownscalePre_x2.glsl',
    'Anime4K_AutoDownscalePre_x4.glsl',
    'Anime4K_Upscale_CNN_x2_S.glsl',
  ];

  //内容来自 https://passport.bilibili.com/web/generic/country/list
  static const internationalDialingPrefix = [
    (id: 1, cname: "中国大陆", countryId: 86),
    (id: 5, cname: "中国香港特别行政区", countryId: 852),
    (id: 2, cname: "中国澳门特别行政区", countryId: 853),
    (id: 3, cname: "中国台湾", countryId: 886),
    (id: 4, cname: "美国", countryId: 1),
    (id: 6, cname: "比利时", countryId: 32),
    (id: 7, cname: "澳大利亚", countryId: 61),
    (id: 8, cname: "法国", countryId: 33),
    (id: 9, cname: "加拿大", countryId: 1),
    (id: 10, cname: "日本", countryId: 81),
    (id: 11, cname: "新加坡", countryId: 65),
    (id: 12, cname: "韩国", countryId: 82),
    (id: 13, cname: "马来西亚", countryId: 60),
    (id: 14, cname: "英国", countryId: 44),
    (id: 15, cname: "意大利", countryId: 39),
    (id: 16, cname: "德国", countryId: 49),
    (id: 18, cname: "俄罗斯", countryId: 7),
    (id: 19, cname: "新西兰", countryId: 64),
    (id: 153, cname: "瓦利斯群岛和富图纳群岛", countryId: 1681),
    (id: 152, cname: "葡萄牙", countryId: 351),
    (id: 151, cname: "帕劳", countryId: 680),
    (id: 150, cname: "诺福克岛", countryId: 672),
    (id: 149, cname: "挪威", countryId: 47),
    (id: 148, cname: "纽埃岛", countryId: 683),
    (id: 147, cname: "尼日利亚", countryId: 234),
    (id: 146, cname: "尼日尔", countryId: 227),
    (id: 145, cname: "尼加拉瓜", countryId: 505),
    (id: 144, cname: "尼泊尔", countryId: 977),
    (id: 143, cname: "瑙鲁", countryId: 674),
    (id: 154, cname: "格鲁吉亚", countryId: 995),
    (id: 155, cname: "瑞典", countryId: 46),
    (id: 165, cname: "沙特阿拉伯", countryId: 966),
    (id: 164, cname: "桑给巴尔岛", countryId: 259),
    (id: 163, cname: "塞舌尔共和国", countryId: 248),
    (id: 162, cname: "塞浦路斯", countryId: 357),
    (id: 161, cname: "塞内加尔", countryId: 221),
    (id: 160, cname: "塞拉利昂", countryId: 232),
    (id: 159, cname: "萨摩亚，东部", countryId: 684),
    (id: 158, cname: "萨摩亚，西部", countryId: 685),
    (id: 157, cname: "萨尔瓦多", countryId: 503),
    (id: 156, cname: "瑞士", countryId: 41),
    (id: 166, cname: "圣多美和普林西比", countryId: 239),
    (id: 142, cname: "塞尔维亚", countryId: 381),
    (id: 141, cname: "南非", countryId: 27),
    (id: 128, cname: "毛里塔尼亚", countryId: 222),
    (id: 127, cname: "毛里求斯", countryId: 230),
    (id: 126, cname: "马歇尔岛", countryId: 692),
    (id: 125, cname: "马提尼克岛", countryId: 596),
    (id: 124, cname: "马其顿", countryId: 389),
    (id: 123, cname: "马里亚纳岛", countryId: 1670),
    (id: 122, cname: "马里", countryId: 223),
    (id: 121, cname: "马拉维", countryId: 265),
    (id: 120, cname: "马耳他", countryId: 356),
    (id: 119, cname: "马尔代夫", countryId: 960),
    (id: 129, cname: "蒙古", countryId: 976),
    (id: 130, cname: "蒙特塞拉特岛", countryId: 1664),
    (id: 140, cname: "纳米比亚", countryId: 264),
    (id: 139, cname: "墨西哥", countryId: 52),
    (id: 138, cname: "莫桑比克", countryId: 258),
    (id: 137, cname: "摩纳哥", countryId: 377),
    (id: 136, cname: "摩洛哥", countryId: 212),
    (id: 135, cname: "摩尔多瓦", countryId: 373),
    (id: 134, cname: "缅甸", countryId: 95),
    (id: 133, cname: "密克罗尼西亚", countryId: 691),
    (id: 132, cname: "秘鲁", countryId: 51),
    (id: 131, cname: "孟加拉国", countryId: 880),
    (id: 118, cname: "马达加斯加", countryId: 261),
    (id: 167, cname: "圣卢西亚", countryId: 1784),
    (id: 216, cname: "智利", countryId: 56),
    (id: 203, cname: "牙买加", countryId: 1876),
    (id: 202, cname: "叙利亚", countryId: 963),
    (id: 201, cname: "匈牙利", countryId: 36),
    (id: 200, cname: "科特迪瓦", countryId: 225),
    (id: 199, cname: "希腊", countryId: 30),
    (id: 198, cname: "西班牙", countryId: 34),
    (id: 197, cname: "乌兹别克斯坦", countryId: 998),
    (id: 196, cname: "乌拉圭", countryId: 598),
    (id: 195, cname: "乌克兰", countryId: 380),
    (id: 194, cname: "乌干达", countryId: 256),
    (id: 204, cname: "亚美尼亚", countryId: 374),
    (id: 205, cname: "也门", countryId: 967),
    (id: 215, cname: "直布罗陀", countryId: 350),
    (id: 214, cname: "乍得", countryId: 235),
    (id: 213, cname: "赞比亚", countryId: 260),
    (id: 212, cname: "越南", countryId: 84),
    (id: 211, cname: "约旦", countryId: 962),
    (id: 210, cname: "印尼", countryId: 62),
    (id: 209, cname: "印度", countryId: 91),
    (id: 208, cname: "以色列", countryId: 972),
    (id: 207, cname: "伊朗", countryId: 98),
    (id: 206, cname: "伊拉克", countryId: 964),
    (id: 193, cname: "文莱", countryId: 673),
    (id: 192, cname: "委内瑞拉", countryId: 58),
    (id: 191, cname: "维珍群岛(英属)", countryId: 1284),
    (id: 178, cname: "泰国", countryId: 66),
    (id: 177, cname: "索马里", countryId: 252),
    (id: 176, cname: "所罗门群岛", countryId: 677),
    (id: 175, cname: "苏里南", countryId: 597),
    (id: 174, cname: "苏丹", countryId: 249),
    (id: 173, cname: "斯威士兰", countryId: 268),
    (id: 172, cname: "斯洛文尼亚", countryId: 386),
    (id: 171, cname: "斯洛伐克", countryId: 421),
    (id: 170, cname: "斯里兰卡", countryId: 94),
    (id: 169, cname: "圣皮埃尔和密克隆群岛", countryId: 508),
    (id: 179, cname: "坦桑尼亚", countryId: 255),
    (id: 180, cname: "汤加", countryId: 676),
    (id: 190, cname: "维珍群岛(美属)", countryId: 1340),
    (id: 189, cname: "瓦努阿图", countryId: 678),
    (id: 188, cname: "托克劳岛", countryId: 690),
    (id: 187, cname: "土库曼斯坦", countryId: 993),
    (id: 186, cname: "土耳其", countryId: 90),
    (id: 185, cname: "图瓦卢", countryId: 688),
    (id: 184, cname: "突尼斯", countryId: 216),
    (id: 183, cname: "阿森松岛", countryId: 247),
    (id: 182, cname: "特立尼达和多巴哥", countryId: 1868),
    (id: 181, cname: "特克斯和凯科斯", countryId: 1649),
    (id: 168, cname: "圣马力诺", countryId: 378),
    (id: 67, cname: "法属圭亚那", countryId: 594),
    (id: 54, cname: "不丹", countryId: 975),
    (id: 53, cname: "博茨瓦纳", countryId: 267),
    (id: 52, cname: "伯利兹", countryId: 501),
    (id: 51, cname: "玻利维亚", countryId: 591),
    (id: 50, cname: "波兰", countryId: 48),
    (id: 49, cname: "波黑", countryId: 387),
    (id: 48, cname: "波多黎各", countryId: 1787),
    (id: 47, cname: "冰岛", countryId: 354),
    (id: 46, cname: "贝宁", countryId: 229),
    (id: 45, cname: "保加利亚", countryId: 359),
    (id: 55, cname: "布基纳法索", countryId: 226),
    (id: 56, cname: "布隆迪", countryId: 257),
    (id: 66, cname: "法属波利尼西亚", countryId: 689),
    (id: 65, cname: "法罗岛", countryId: 298),
    (id: 64, cname: "厄立特里亚", countryId: 291),
    (id: 63, cname: "厄瓜多尔", countryId: 593),
    (id: 62, cname: "多米尼加代表", countryId: 1809),
    (id: 61, cname: "多米尼加", countryId: 1767),
    (id: 60, cname: "多哥", countryId: 228),
    (id: 59, cname: "迪戈加西亚岛", countryId: 246),
    (id: 58, cname: "丹麦", countryId: 45),
    (id: 57, cname: "赤道几内亚", countryId: 240),
    (id: 44, cname: "百慕大群岛", countryId: 1441),
    (id: 43, cname: "白俄罗斯", countryId: 375),
    (id: 42, cname: "巴西", countryId: 55),
    (id: 29, cname: "爱尔兰", countryId: 353),
    (id: 28, cname: "埃塞俄比亚", countryId: 251),
    (id: 27, cname: "埃及", countryId: 20),
    (id: 26, cname: "阿塞拜疆", countryId: 994),
    (id: 25, cname: "阿曼", countryId: 968),
    (id: 24, cname: "阿联酋", countryId: 971),
    (id: 23, cname: "阿根廷", countryId: 54),
    (id: 22, cname: "阿富汗", countryId: 93),
    (id: 21, cname: "阿尔及利亚", countryId: 213),
    (id: 20, cname: "阿尔巴尼亚", countryId: 355),
    (id: 30, cname: "爱沙尼亚", countryId: 372),
    (id: 31, cname: "安道尔", countryId: 376),
    (id: 41, cname: "巴拿马", countryId: 507),
    (id: 40, cname: "巴林", countryId: 973),
    (id: 39, cname: "巴拉圭", countryId: 595),
    (id: 38, cname: "巴基斯坦", countryId: 92),
    (id: 37, cname: "巴哈马群岛", countryId: 1242),
    (id: 36, cname: "巴布亚新几内亚", countryId: 675),
    (id: 35, cname: "巴巴多斯", countryId: 1246),
    (id: 34, cname: "奥地利", countryId: 43),
    (id: 33, cname: "安提瓜岛和巴布达", countryId: 1268),
    (id: 32, cname: "安哥拉", countryId: 244),
    (id: 68, cname: "非洲中部", countryId: 236),
    (id: 117, cname: "罗马尼亚", countryId: 40),
    (id: 104, cname: "科威特", countryId: 965),
    (id: 103, cname: "科摩罗", countryId: 269),
    (id: 102, cname: "开曼群岛", countryId: 1345),
    (id: 101, cname: "卡塔尔", countryId: 974),
    (id: 100, cname: "喀麦隆", countryId: 237),
    (id: 99, cname: "聚会岛", countryId: 262),
    (id: 98, cname: "津巴布韦", countryId: 263),
    (id: 97, cname: "捷克", countryId: 420),
    (id: 96, cname: "柬埔寨", countryId: 855),
    (id: 95, cname: "加蓬", countryId: 241),
    (id: 105, cname: "克罗地亚", countryId: 385),
    (id: 106, cname: "肯尼亚", countryId: 254),
    (id: 116, cname: "卢旺达", countryId: 250),
    (id: 115, cname: "卢森堡", countryId: 352),
    (id: 114, cname: "利比亚", countryId: 218),
    (id: 113, cname: "利比里亚", countryId: 231),
    (id: 112, cname: "立陶宛", countryId: 370),
    (id: 111, cname: "黎巴嫩", countryId: 961),
    (id: 110, cname: "老挝", countryId: 856),
    (id: 109, cname: "莱索托", countryId: 266),
    (id: 108, cname: "拉脱维亚", countryId: 371),
    (id: 107, cname: "库克岛", countryId: 682),
    (id: 94, cname: "加纳", countryId: 233),
    (id: 93, cname: "几内亚比绍", countryId: 245),
    (id: 92, cname: "几内亚", countryId: 224),
    (id: 79, cname: "格林纳达", countryId: 1473),
    (id: 78, cname: "哥斯达黎加", countryId: 506),
    (id: 77, cname: "哥伦比亚", countryId: 57),
    (id: 76, cname: "刚果(金)", countryId: 243),
    (id: 75, cname: "刚果", countryId: 242),
    (id: 74, cname: "冈比亚", countryId: 220),
    (id: 73, cname: "福克兰岛", countryId: 500),
    (id: 72, cname: "佛得角", countryId: 238),
    (id: 71, cname: "芬兰", countryId: 358),
    (id: 70, cname: "斐济", countryId: 679),
    (id: 80, cname: "格陵兰岛", countryId: 299),
    (id: 81, cname: "古巴", countryId: 53),
    (id: 91, cname: "吉尔吉斯斯坦", countryId: 996),
    (id: 90, cname: "吉布提", countryId: 253),
    (id: 89, cname: "基里巴斯", countryId: 686),
    (id: 88, cname: "维克岛", countryId: 1808),
    (id: 87, cname: "洪都拉斯", countryId: 504),
    (id: 86, cname: "荷兰", countryId: 31),
    (id: 85, cname: "朝鲜", countryId: 850),
    (id: 84, cname: "海地", countryId: 509),
    (id: 83, cname: "关岛", countryId: 1671),
    (id: 82, cname: "瓜德罗普岛", countryId: 590),
    (id: 69, cname: "菲律宾", countryId: 63),
  ];
}
