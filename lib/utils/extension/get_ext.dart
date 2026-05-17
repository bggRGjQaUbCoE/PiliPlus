import 'package:PiliPlus/main.dart';
import 'package:get/get.dart';

extension GetExt on GetInterface {
  S putOrFind<S>(InstanceBuilderCallback<S> dep, {String? tag}) =>
      GetInstance().putOrFind(dep, tag: tag);

  void updateMyAppTheme() {
    MyApp.rebuildTheme();
  }
}
