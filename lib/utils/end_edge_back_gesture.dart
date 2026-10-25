import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/utils/feed_back.dart' show enableFeedback;
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoEndEdgeBackGesture;
import 'package:flutter/services.dart' show HapticFeedback;

/// Back by swiping from the right screen edge towards the left (iOS).
///
/// The gesture lives in the patched `cupertino_ui`
/// (lib/scripts/cupertino/end_edge_back_gesture.patch): it plays the regular
/// back transition with a preview of the previous page, shows an Android
/// style arrow at the edge, and pops on release once dragged past a short
/// distance (dragging back before releasing cancels).
abstract final class EndEdgeBackGesture {
  static void init() {
    CupertinoEndEdgeBackGesture.onArmedChanged = _onArmedChanged;
    // e.g. the reply panel of the video page follows the finger
    CupertinoEndEdgeBackGesture.sheetAnimation =
        MiniScaffoldState.openSheetAnimation;
    setEnabled(Pref.endEdgeBackGesture);
  }

  static void setEnabled(bool value) {
    final enabled = Platform.isIOS && value;
    CupertinoEndEdgeBackGesture.enabled = enabled;
    CommonSlideMixin.rightEdgeTaken = enabled;
  }

  static void _onArmedChanged(bool armed) {
    // follows the global 震动反馈 setting like the rest of the app
    if (!enableFeedback) return;
    if (armed) {
      // releasing now goes back
      HapticFeedback.heavyImpact();
    } else {
      // dragged back: releasing now cancels
      HapticFeedback.lightImpact();
    }
  }
}
