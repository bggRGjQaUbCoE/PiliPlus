/// The experimental live viewer is independent from all playback preferences.
/// Only an explicitly stored boolean true enables it, including after restore.
bool decodeLiveRoomEnhancement(Object? value) => value is bool && value;

/// Reserve a readable sidebar only when the player still has useful space.
bool useLiveEnhancementSidebar({
  required double width,
  required bool isFullScreen,
}) => !isFullScreen && width >= 900;
