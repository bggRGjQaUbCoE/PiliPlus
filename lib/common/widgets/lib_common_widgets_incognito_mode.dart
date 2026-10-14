import 'package:get/get.dart';

/// 隐身模式全局状态。
///
/// 进入隐身搜索页时开启，返回首页时关闭。
/// 视频播放页检查此标记，决定是否隐藏互动按钮、跳过历史上报。
class IncognitoMode {
  static final RxBool isActive = false.obs;

  static void enter() => isActive.value = true;
  static void exit() => isActive.value = false;
}
