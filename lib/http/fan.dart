import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fans/data.dart';

class FanHttp {
  static Future<LoadingState<FansData>> fans({
    required int vmid,
    required int pn,
    int ps = 20,
    String? orderType,
  }) async {
    var res = await Request().get(
      Api.fans,
      queryParameters: {
        'vmid': vmid,
        'pn': pn,
        'ps': ps,
        'order': 'desc',
        'order_type': ?orderType,
      },
    );
    if (res.data['code'] == 0) {
      return Success(FansData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
