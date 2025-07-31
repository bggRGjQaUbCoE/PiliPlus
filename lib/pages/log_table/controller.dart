import 'package:PiliPlus/pages/common/common_list_controller.dart';

abstract class LogController<R, T> extends CommonListController<R, T> {
  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  String get title;

  T get header;

  List<(int, String)> getFlexAndText(T item);
}
