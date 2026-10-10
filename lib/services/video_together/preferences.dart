import 'package:PiliPlus/services/video_together/navigation.dart';
import 'package:PiliPlus/services/video_together/protocol.dart';
import 'package:PiliPlus/utils/storage.dart';

abstract final class VideoTogetherPreferences {
  static const serverKey = 'videoTogetherServer';
  static const nicknameKey = 'videoTogetherNickname';
  static const navigationModeKey = 'videoTogetherNavigationMode';
  // Kept for migrating settings saved before the four-mode selector existed.
  static const autoOpenVideoKey = 'videoTogetherAutoOpenVideo';
  static const syncPlaybackRateKey = 'videoTogetherSyncPlaybackRate';
  static const bidirectionalSyncKey = 'videoTogetherBidirectionalSync';
  static const waitForLoadingKey = 'videoTogetherWaitForLoading';
  static const passwordProtectedKey = 'videoTogetherPasswordProtected';
  static const syncThresholdKey = 'videoTogetherSyncThreshold';
  static const lastRoomNameKey = 'videoTogetherLastRoomName';
  // Keep the serialized key so existing exports retain the user's choice.
  static const hidePlayerEntryWhenNotInRoomKey =
      'videoTogetherHidePlayerMenuEntry';
  static const defaultSyncThreshold = 0.5;
  static const defaultHidePlayerEntryWhenNotInRoom = true;
  static const defaultNavigationMode = VideoTogetherNavigationMode.countdown;

  static String get server => GStorage.setting.get(
    serverKey,
    defaultValue: VideoTogetherProtocol.defaultServer,
  );

  static String get nickname =>
      GStorage.setting.get(nicknameKey, defaultValue: 'PiliPlus 用户');

  static VideoTogetherNavigationMode get navigationMode =>
      resolveNavigationMode(
        storedMode: GStorage.setting.get(navigationModeKey),
        legacyAutoOpen: GStorage.setting.get(autoOpenVideoKey),
      );

  static VideoTogetherNavigationMode resolveNavigationMode({
    Object? storedMode,
    Object? legacyAutoOpen,
  }) {
    if (storedMode is VideoTogetherNavigationMode) return storedMode;
    if (storedMode is String) {
      for (final mode in VideoTogetherNavigationMode.values) {
        if (mode.name == storedMode) return mode;
      }
    }
    if (storedMode is int &&
        storedMode >= 0 &&
        storedMode < VideoTogetherNavigationMode.values.length) {
      return VideoTogetherNavigationMode.values[storedMode];
    }
    if (legacyAutoOpen is bool) {
      return legacyAutoOpen
          ? VideoTogetherNavigationMode.always
          : VideoTogetherNavigationMode.never;
    }
    return defaultNavigationMode;
  }

  static bool get syncPlaybackRate =>
      GStorage.setting.get(syncPlaybackRateKey, defaultValue: true);

  static bool get bidirectionalSync =>
      GStorage.setting.get(bidirectionalSyncKey, defaultValue: true);

  static Future<void> setBidirectionalSync(bool value) =>
      GStorage.setting.put(bidirectionalSyncKey, value);

  static bool get waitForLoading =>
      GStorage.setting.get(waitForLoadingKey, defaultValue: true);

  static bool get passwordProtected =>
      GStorage.setting.get(passwordProtectedKey, defaultValue: true);

  static double get syncThreshold => (GStorage.setting.get(
    syncThresholdKey,
    defaultValue: defaultSyncThreshold,
  ) as num).toDouble().clamp(0.1, 5.0).toDouble();

  static String get lastRoomName =>
      GStorage.setting.get(lastRoomNameKey, defaultValue: '');

  static bool get hidePlayerEntryWhenNotInRoom => GStorage.setting.get(
    hidePlayerEntryWhenNotInRoomKey,
    defaultValue: defaultHidePlayerEntryWhenNotInRoom,
  );
}
