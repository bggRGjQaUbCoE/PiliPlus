class ChatMessage {
  final String role; // 'user' | 'assistant' | 'system'
  String content;
  bool isStreaming;
  String? templateName;
  final bool isDivider;

  /// 思考内容，不含 `<think>` 标签本身；只保存在本地供 UI 展示，
  /// 不回传给 API
  String reasoningContent;

  /// 思考块形态：true=卡片，false=胶囊。不持久化
  bool isReasoningExpanded;

  /// 思考块高度档：false=限高 120，true=放开；仅卡片形态下有效，不持久化
  bool isReasoningFullHeight;

  /// 首次收到非空思考增量的时刻
  DateTime? reasoningStartedAt;

  /// 已冻结的思考耗时（秒）。为 null 表示仍在计时
  double? reasoningDurationSeconds;

  int _updateCount = 0;

  ChatMessage({
    required this.role,
    required this.content,
    this.isStreaming = false,
    this.templateName,
    this.isDivider = false,
    this.reasoningContent = '',
    this.isReasoningExpanded = false,
    this.isReasoningFullHeight = false,
    this.reasoningStartedAt,
    this.reasoningDurationSeconds,
  });

  /// Incremented on each content update during streaming, used as animation trigger
  int get updateCount => _updateCount;

  /// 标尺用的思考耗时（秒）：未冻结时按当前时刻实时计算
  double get reasoningSeconds {
    final frozen = reasoningDurationSeconds;
    if (frozen != null) return frozen;
    final started = reasoningStartedAt;
    if (started == null) return 0;
    return DateTime.now().difference(started).inMilliseconds / 1000;
  }

  void appendContent(String token) {
    content += token;
    _updateCount++;
  }

  void appendReasoningContent(String delta) {
    reasoningContent += delta;
    _updateCount++;
  }

  /// 是否已有可展示的思考内容（只有标签或空白时视为没有思考）
  bool get hasReasoning => reasoningContent.trim().isNotEmpty;
}
