/// 后台只听音频 — 自动状态机状态
///
/// 状态只活在当前 PlPlayerController 实例上，不写 Hive。
/// 播放器 dispose 时必须回到 idle 并取消 Timer。
enum AutoAudioOnlyState {
  /// 无自动只听行为
  idle,

  /// 离开前台，等待 10 秒定时器到点
  arm,

  /// 系统 PiP 中，保持视频
  pipHold,

  /// 自动只听已生效
  autoAudioOnly,

  /// 用户手动打开了听视频/仅播放音频
  manualAudioOnly,
}