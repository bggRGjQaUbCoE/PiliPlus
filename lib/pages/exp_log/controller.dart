import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models_new/coin_log/data.dart';
import 'package:PiliPlus/models_new/coin_log/list.dart';
import 'package:PiliPlus/pages/log_table/controller.dart';

class ExpLogController extends LogController<CoinLogData, CoinLogItem> {
  @override
  List<CoinLogItem>? getDataList(CoinLogData response) {
    return response.list;
  }

  @override
  Future<LoadingState<CoinLogData>> customGetData() => UserHttp.expLog();

  @override
  List<(int, String)> getFlexAndText(CoinLogItem item) {
    return [(2, item.time), (1, item.delta), (2, item.reason)];
  }

  @override
  CoinLogItem get header => CoinLogItem(
    time: L10n.current.time,
    delta: L10n.current.headerDelta,
    reason: L10n.current.headerReason,
  );

  @override
  String get title => L10n.current.titleText2;
}
