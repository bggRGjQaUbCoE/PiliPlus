class ChannelQuietRule {
  const ChannelQuietRule({
    required this.key,
    required this.channelUid,
    required this.channelName,
    this.hideComments = false,
    this.hideDanmaku = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Stable string key for identifying a channel. UGC channels use the form
  /// `ugc:<mid>`, PGC channels `pgc:<seasonId>`.
  final String key;

  /// The source channel id as a plain string (mid for UGC, seasonId for PGC).
  final String channelUid;

  /// Human-readable channel or show name.
  final String channelName;

  /// Default: hide comments for this channel.
  final bool hideComments;

  /// Default: hide danmaku for this channel.
  final bool hideDanmaku;

  /// When the rule was first created.
  final DateTime createdAt;

  /// When the rule was last modified.
  final DateTime updatedAt;

  /// Build a UGC key from a user mid.
  static String ugcKey(int mid) => 'ugc:$mid';

  /// Build a PGC key from a season id.
  static String pgcKey(int seasonId) => 'pgc:$seasonId';

  Map<String, dynamic> toJson() => {
        'key': key,
        'channel_uid': channelUid,
        'channel_name': channelName,
        'hide_comments': hideComments,
        'hide_danmaku': hideDanmaku,
        'created_at': createdAt.millisecondsSinceEpoch,
        'updated_at': updatedAt.millisecondsSinceEpoch,
      };

  factory ChannelQuietRule.fromJson(Map<String, dynamic> json) {
    return ChannelQuietRule(
      key: json['key'] as String,
      channelUid: json['channel_uid'] as String,
      channelName: json['channel_name'] as String? ?? '',
      hideComments: json['hide_comments'] as bool? ?? false,
      hideDanmaku: json['hide_danmaku'] as bool? ?? false,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(json['updated_at'] as int),
    );
  }

  ChannelQuietRule copyWith({
    String? key,
    String? channelUid,
    String? channelName,
    bool? hideComments,
    bool? hideDanmaku,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChannelQuietRule(
      key: key ?? this.key,
      channelUid: channelUid ?? this.channelUid,
      channelName: channelName ?? this.channelName,
      hideComments: hideComments ?? this.hideComments,
      hideDanmaku: hideDanmaku ?? this.hideDanmaku,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelQuietRule &&
          other.key == key &&
          other.channelUid == channelUid &&
          other.channelName == channelName &&
          other.hideComments == hideComments &&
          other.hideDanmaku == hideDanmaku;

  @override
  int get hashCode =>
      Object.hash(key, channelUid, channelName, hideComments, hideDanmaku);

  @override
  String toString() =>
      'ChannelQuietRule(key: $key, channel: $channelName, '
      'hideComments: $hideComments, hideDanmaku: $hideDanmaku)';
}
