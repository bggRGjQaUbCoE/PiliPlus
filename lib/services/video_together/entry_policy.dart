abstract final class VideoTogetherPlayerEntryPolicy {
  static bool shouldShow({
    required bool inRoom,
    required bool hideWhenNotInRoom,
  }) => inRoom || !hideWhenNotInRoom;
}
