/// 动态页未读红点的跨页面入口。
///
/// 未读状态的归属者是动态页控制器，但「用户看过了」这个事件发生在别处 ——
/// 打开动态详情、观看视频等页面。因此这里提供一个极薄的注册点：
/// 控制器在存活期间注册回调，其他页面用 [markContentRead] 告知
/// 「某条动态或某个视频被看过了」，由其发布时间推进作者已读水位。
///
/// 没有动态页存活时调用是安全的空操作：此时既没有红点在显示，
/// 也不需要维护未读状态。
abstract final class DynamicUnreadNotifier {
  /// 只保留存活页面的订阅；闭包使用相等比较注销实例方法。
  static void Function(DynamicReadEvent event)? _handler;

  /// 由动态页控制器在初始化时注册。回调需要能安全处理任意 mid。
  static void bind(void Function(DynamicReadEvent event) handler) =>
      _handler = handler;

  /// 控制器销毁时注销；只注销自己注册的那个，避免误清其他实例。
  static void unbind(void Function(DynamicReadEvent event) handler) {
    if (_handler == handler) _handler = null;
  }

  /// 发送携带账号与内容身份的已读事件，无订阅时安全忽略。
  static void markContentRead(DynamicReadEvent event) {
    _handler?.call(event);
  }
}

/// 已读事件在触发时固定主账号，延迟请求不能把旧账号内容应用到新账号。
class DynamicReadEvent {
  const DynamicReadEvent({
    required this.accountMid,
    required this.viewedAt,
    this.mid,
    this.dynamicId,
    this.videoAid,
    this.videoBvid,
    this.publishedAt,
  });

  /// 主账号身份与观看时间属于事件本身，不在接收时重新读取全局状态。
  final int accountMid;
  final int viewedAt;
  final int? mid;
  final int? dynamicId;
  final int? videoAid;
  final String? videoBvid;

  /// 内容发布时间决定已读水位；观看时间不能代替它清除之后发布的内容。
  final int? publishedAt;
}
