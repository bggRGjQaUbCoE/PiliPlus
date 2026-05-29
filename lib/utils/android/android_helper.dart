import 'dart:convert';
import 'dart:ui';

import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:jni/jni.dart';

abstract final class PiliAndroidHelper {
  @pragma('vm:prefer-inline')
  static void back() => AndroidHelper.back();

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
  static void setPipAutoEnterEnabled(bool autoEnable) =>
      AndroidHelper.setPipAutoEnterEnabled(
        autoEnable,
        PlatformDispatcher.instance.engineId!,
      );

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
