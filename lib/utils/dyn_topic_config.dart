import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

abstract final class DynTopicConfig {
  /// 是否显示动态卡片/详情页上方的话题行
  static final show = Pref.showDynTopic.obs;
}
