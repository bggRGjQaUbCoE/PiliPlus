import 'dart:convert';
import 'dart:ui';

import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:jni/jni.dart';

abstract final class PiliAndroidHelper {
  @pragma('vm:prefer-inline')
  static void back() => AndroidHelper.back();

  static ({
    int? linkSpeed,
    int? rssi,
    int? signalLevel,
    int? downstreamKbps,
    int? upstreamKbps,
    int? networkType,
    int? cellularDbm,
    bool metered,
    bool captivePortal,
    bool congested,
    bool bandwidthConstrained,
    bool validated,
    bool internet,
    bool vpn,
    bool roaming,
    bool weakHint,
  })? networkInfo() {
    final info = AndroidHelper.networkInfo();
    if (info == null) return null;
    try {
      final flags = info[3];
      return (
        linkSpeed: info[0] < 0 ? null : info[0],
        rssi: info[1] <= -127 || info[1] > 0 ? null : info[1],
        signalLevel: info[2] < 0 ? null : info[2],
        downstreamKbps: info[4] <= 0 ? null : info[4],
        upstreamKbps: info[5] <= 0 ? null : info[5],
        networkType: info[6] < 0 ? null : info[6],
        cellularDbm: info[7] != 2147483647 ? info[7] : null,
        metered: flags & 1 != 0,
        captivePortal: flags & 2 != 0,
        congested: flags & 4 != 0,
        bandwidthConstrained: flags & 8 != 0,
        validated: flags & 16 != 0,
        internet: flags & 32 != 0,
        vpn: flags & 64 != 0,
        roaming: flags & 128 != 0,
        weakHint: flags & 14 != 0,
      );
    } finally {
      info.release();
    }
  }

  static String? networkOperator() => AndroidHelper.networkOperator()
      ?.toDartString(releaseOriginal: true);

  static Map<String, dynamic>? subscriptionInfo() {
    final raw = AndroidHelper.subscriptionInfoJson()
        ?.toDartString(releaseOriginal: true);
    if (raw == null || raw.isEmpty) return null;
    try {
      final value = jsonDecode(raw);
      return value is Map
          ? value.map((key, value) => MapEntry(key.toString(), value))
          : null;
    } catch (_) {
      return null;
    }
  }

  static ({int received, int sent})? trafficStats() {
    final stats = AndroidHelper.trafficStats();
    if (stats == null) return null;
    try {
      if (stats[0] < 0 || stats[1] < 0) return null;
      return (received: stats[0], sent: stats[1]);
    } finally {
      stats.release();
    }
  }

  static void biliSendCommAntifraud(
    int action,
    int oid,
    int type,
    int rpId,
    int root,
    int parent,
    int ctime,
    String commentText,
    List pictures,
    String sourceId,
    int uid,
    String cookie,
  ) {
    final jCommentText = commentText.toJString();
    final jSourceId = sourceId.toJString();
    final jCookie = cookie.toJString();
    final jPictures = pictures.isEmpty
        ? null
        : jsonEncode(pictures).toJString();

    try {
      AndroidHelper.biliSendCommAntifraud(
        action,
        oid,
        type,
        rpId,
        root,
        parent,
        ctime,
        jCommentText,
        jPictures,
        jSourceId,
        uid,
        jCookie,
      );
    } catch (e) {
      Utils.reportError(e);
    } finally {
      jCommentText.release();
      jSourceId.release();
      jCookie.release();
      jPictures?.release();
    }
  }

  @pragma('vm:prefer-inline')
  static void openLinkVerifySettings() =>
      AndroidHelper.openLinkVerifySettings();

  static bool openMusic(String title, String? artist, String? album) {
    final jTitle = title.toJString();
    final jArtist = artist?.toJString();
    final jAlbum = album?.toJString();
    try {
      return AndroidHelper.openMusic(jTitle, jArtist, jAlbum);
    } finally {
      jTitle.release();
      jArtist?.release();
      jAlbum?.release();
    }
  }

  @pragma('vm:prefer-inline')
  static void enterPip(
    int width,
    int height, {
    required bool autoEnter,
    required bool isLive,
    required bool isPlaying,
  }) => AndroidHelper.enterPip(
    PlatformDispatcher.instance.engineId!,
    width,
    height,
    autoEnter,
    isLive,
    isPlaying,
  );

  @pragma('vm:prefer-inline')
  static void disableAutoEnterPip() =>
      AndroidHelper.disableAutoEnterPip(PlatformDispatcher.instance.engineId!);

  static (int, int)? maxScreenSize() {
    final jIArr = AndroidHelper.maxScreenSize();
    if (jIArr != null) {
      try {
        return (jIArr[0], jIArr[1]);
      } finally {
        jIArr.release();
      }
    }
    return null;
  }

  static void createShortcut(String id, String uri, String label, String path) {
    final jId = id.toJString();
    final jUri = uri.toJString();
    final jLabel = label.toJString();
    final jPath = path.toJString();
    try {
      AndroidHelper.createShortcut(jId, jUri, jLabel, jPath);
    } finally {
      jId.release();
      jUri.release();
      jLabel.release();
      jPath.release();
    }
  }
}
