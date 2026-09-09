import 'package:PiliPlus/pages/common/common_list_controller.dart';

mixin PageOrderMixin<R, T> on CommonListController<R, T> {
  int get ps;
  int get count;

  bool _pageDesc = false;
  bool get pageDesc => _pageDesc;

  @override
  // page++;
  // page = 1;
  set page(int value) {
    if (pageDesc) {
      if (value == 1) {
        super.page = (count / ps).ceil();
      } else {
        super.page--;
      }
    } else {
      super.page = value;
    }
  }

  void updatePageOrder(bool value) {
    if (count == 0) return;
    _pageDesc = value;
    onReload();
  }
}
