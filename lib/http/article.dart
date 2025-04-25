import 'package:PiliPlus/http/index.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';

import '../models/space_article/item.dart';

class ArticleHttp {
  // 仅12, 使用cvid, 返回为html文本
  static Future<LoadingState<Item>> articleView({required dynamic cvid}) async {
    final res = await Request().get(
      Api.articleView,
      queryParameters: await WbiSign.makSign({
        'id': cvid,
        'gaia_source': 'main_web',
        'web_location': '333.976',
      }),
    );

    return res.data['code'] == 0
        ? LoadingState.success(Item.fromJson(res.data['data']))
        : LoadingState.error(res.data['message']);
  }

  // 11/12, 17类型应用dynamicDetail
  static Future<LoadingState<DynamicItemModel>> opusDetail(
      {required dynamic id}) async {
    final res = await Request().get(
      Api.opusDetail,
      queryParameters: {
        'timezone_offset': '-480',
        'features':
            'onlyfansVote,onlyfansAssetsV2,decorationCard,htmlNewStyle,ugcDelete,editable,opusPrivateVisible',
        'id': id,
      },
    );

    return res.data['code'] == 0
        ? LoadingState.success(
            DynamicItemModel.fromOpusJson(res.data['data']['item']))
        : LoadingState.error(res.data['message']);
  }
}
