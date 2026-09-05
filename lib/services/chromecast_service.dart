import 'dart:io';

import 'package:flutter_chrome_cast/cast_context.dart';
import 'package:flutter_chrome_cast/discovery.dart';
import 'package:flutter_chrome_cast/entities.dart';
import 'package:flutter_chrome_cast/enums.dart';
import 'package:flutter_chrome_cast/media.dart';
import 'package:flutter_chrome_cast/models.dart';
import 'package:flutter_chrome_cast/session.dart';

abstract final class ChromecastService {
  static const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
  static bool _initialized = false;

  static bool get supported => Platform.isAndroid || Platform.isIOS;

  static Future<void> initialize() async {
    if (!supported || _initialized) return;
    final options = Platform.isAndroid
        ? GoogleCastOptionsAndroid(appId: appId)
        : IOSGoogleCastOptions(
            GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId),
          );
    await GoogleCastContext.instance.setSharedInstanceWithOptions(options);
    _initialized = true;
  }

  static Future<void> startDiscovery() async {
    await initialize();
    await GoogleCastDiscoveryManager.instance.startDiscovery();
  }

  static Future<void> stopDiscovery() async {
    if (!supported || !_initialized) return;
    await GoogleCastDiscoveryManager.instance.stopDiscovery();
  }

  static Future<void> cast({
    required GoogleCastDevice device,
    required String url,
    String? title,
  }) async {
    await initialize();
    await GoogleCastSessionManager.instance.startSessionWithDevice(device);
    final mediaInfo = GoogleCastMediaInformation(
      contentId: url,
      contentUrl: Uri.parse(url),
      streamType: CastMediaStreamType.buffered,
      contentType: 'video/mp4',
      metadata: GoogleCastMovieMediaMetadata(title: title),
    );
    await GoogleCastRemoteMediaClient.instance.loadMedia(mediaInfo);
  }
}
