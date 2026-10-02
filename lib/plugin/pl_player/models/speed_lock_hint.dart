/// 长按倍速锁定的提示状态（六态，驱动播放器顶部 toast）
enum SpeedLockHint {
  /// 无提示
  none,

  /// 长按中：上滑锁定引导
  swipeUpToLock,

  /// 上滑越线（预备）：松手锁定
  releaseToLock,

  /// 已提交锁定（短提示，自动消失）
  lockedConfirm,

  /// 锁定态长按中：下滑退出引导
  swipeDownToUnlock,

  /// 下滑越线（预备）：松手退出
  releaseToUnlock,

  /// 已提交解锁（短提示，自动消失）
  unlockedConfirm;

  bool get isNone => this == none;
}
