import 'channel_quiet_rule.dart';

/// Identifies a UGC or PGC channel for which a persistent quiet rule may be
/// created, updated, or removed.
class ChannelQuietTarget {
  const ChannelQuietTarget({
    required this.key,
    required this.channelUid,
    required this.channelName,
  });

  /// Stable key matching [ChannelQuietRule.key].
  final String key;

  /// Raw channel identifier as a string (mid for UGC, seasonId for PGC).
  final String channelUid;

  /// Human-readable name for display.
  final String channelName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelQuietTarget &&
          other.key == key &&
          other.channelUid == channelUid &&
          other.channelName == channelName;

  @override
  int get hashCode => Object.hash(key, channelUid, channelName);

  @override
  String toString() =>
      'ChannelQuietTarget(key: $key, channel: $channelName)';
}

/// The action label shown in the more menu for the current channel.
///
/// When [existingRule] is null the label suggests adding a rule; otherwise it
/// suggests editing the existing rule.
String channelQuietActionLabel(ChannelQuietRule? existingRule) =>
    existingRule != null ? '编辑频道屏蔽' : '添加频道屏蔽';

/// The dialog title shown when editing a channel quiet rule.
String channelQuietEditorTitle(ChannelQuietRule? existingRule) =>
    existingRule != null ? '编辑频道屏蔽' : '新增频道屏蔽';
