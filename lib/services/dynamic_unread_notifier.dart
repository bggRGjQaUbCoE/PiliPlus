/// 动态页未读红点的跨页面入口。
///
/// 未读状态的归属者是动态页控制器，但「用户看过了」这个事件发生在别处 ——
/// 打开动态详情、观看视频等页面。因此这里提供一个极薄的注册点：
/// 控制器在存活期间注册回调，其他页面用 [markContentRead] 告知
/// 「某个 UP 的内容被看过了」。
///
/// 没有动态页存活时调用是安全的空操作：此时既没有红点在显示，
/// 也不需要维护未读状态。
abstract final class DynamicUnreadNotifier {
  static void Function(int mid)? _handler;

  /// 由动态页控制器在初始化时注册。回调需要能安全处理任意 mid。
  static void bind(void Function(int mid) handler) => _handler = handler;

  /// 控制器销毁时注销；只注销自己注册的那个，避免误清其他实例。
  static void unbind(void Function(int mid) handler) {
    if (identical(_handler, handler)) _handler = null;
  }

  /// 告知「该 UP 的内容已被看过」，用于清除其红点。
  ///
  /// 调用方只需给出作者 mid，不需要关心红点当前是否存在。
  static void markContentRead(int mid) {
    if (mid > 0) _handler?.call(mid);
  }
}
