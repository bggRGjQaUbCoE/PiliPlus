import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum InAppMiniPlayerPhase { entering, active, restoring }

class InAppMiniPlayerSession {
  const InAppMiniPlayerSession({
    required this.player,
    required this.routeArguments,
    required this.phase,
    this.title,
    this.sourceRect,
    this.destinationRect,
  });

  final PlPlayerController player;
  final Map<String, dynamic> routeArguments;
  final String? title;
  final InAppMiniPlayerPhase phase;
  final Rect? sourceRect;
  final Rect? destinationRect;

  InAppMiniPlayerSession copyWith({
    InAppMiniPlayerPhase? phase,
    Rect? sourceRect,
    Rect? destinationRect,
  }) {
    return InAppMiniPlayerSession(
      player: player,
      routeArguments: routeArguments,
      title: title,
      phase: phase ?? this.phase,
      sourceRect: sourceRect ?? this.sourceRect,
      destinationRect: destinationRect ?? this.destinationRect,
    );
  }
}

/// Owns the player reference after a video detail route has been popped.
class InAppMiniPlayerService extends ValueNotifier<InAppMiniPlayerSession?> {
  InAppMiniPlayerService._() : super(null);

  static const restoreArgument = '_inAppMiniPlayerRestore';
  static final instance = InAppMiniPlayerService._();

  VoidCallback? _onRestorePageReady;
  bool _restoreAnimationCompleted = false;
  Rect? _restoreDestinationRect;

  Rect? get restoreDestinationRect => _restoreDestinationRect;

  bool owns(PlPlayerController player) => value?.player == player;

  bool show({
    required PlPlayerController player,
    required Map<String, dynamic> routeArguments,
    String? title,
    Rect? sourceRect,
  }) {
    final arguments = Map<String, dynamic>.from(routeArguments)
      ..remove(restoreArgument);
    if (title?.isNotEmpty == true) {
      arguments['title'] = title;
    }

    final current = value;
    if (current?.player == player) {
      _resetRestoreHandshake();
      value = InAppMiniPlayerSession(
        player: player,
        routeArguments: arguments,
        title: title,
        phase: InAppMiniPlayerPhase.entering,
        sourceRect: sourceRect,
      );
      return true;
    }

    dismiss();
    if (!player.retainForInAppMiniPlayer()) {
      return false;
    }
    value = InAppMiniPlayerSession(
      player: player,
      routeArguments: arguments,
      title: title,
      phase: InAppMiniPlayerPhase.entering,
      sourceRect: sourceRect,
    );
    return true;
  }

  void markActive(InAppMiniPlayerSession session) {
    if (identical(value, session) && session.phase == .entering) {
      value = session.copyWith(phase: .active);
    }
  }

  void dismiss() {
    final session = value;
    if (session == null) return;
    _resetRestoreHandshake();
    value = null;
    session.player.releaseFromInAppMiniPlayer(restoredToVideoPage: false);
  }

  void restore() {
    final session = value;
    if (session == null || session.phase != .active) return;
    final arguments = Map<String, dynamic>.from(session.routeArguments)
      ..['progress'] = session.player.currentPosition.inMilliseconds
      ..[restoreArgument] = true;
    _resetRestoreHandshake();
    _restoreDestinationRect = session.sourceRect;
    value = InAppMiniPlayerSession(
      player: session.player,
      routeArguments: session.routeArguments,
      title: session.title,
      phase: .restoring,
      sourceRect: session.sourceRect,
      destinationRect: session.sourceRect,
    );
    Get.toNamed<void>(
      '/videoV',
      arguments: arguments,
      preventDuplicates: false,
    );
  }

  bool canRestore(
    PlPlayerController player,
    Map<dynamic, dynamic> arguments,
  ) {
    final session = value;
    return arguments[restoreArgument] == true &&
        session?.player == player &&
        session?.phase == .restoring;
  }

  void attachRestorePage({
    required PlPlayerController player,
    required Rect? destinationRect,
    required VoidCallback onCompleted,
  }) {
    final session = value;
    if (session?.player != player || session?.phase != .restoring) {
      return;
    }
    if (destinationRect != null) {
      _restoreDestinationRect = destinationRect;
      notifyListeners();
    }
    _onRestorePageReady = onCompleted;
    _finishRestoreIfReady(session!);
  }

  void completeRestoreAnimation(InAppMiniPlayerSession session) {
    if (!identical(value, session) || session.phase != .restoring) return;
    _restoreAnimationCompleted = true;
    _finishRestoreIfReady(session);
  }

  void _finishRestoreIfReady(InAppMiniPlayerSession session) {
    final onCompleted = _onRestorePageReady;
    if (!identical(value, session) ||
        !_restoreAnimationCompleted ||
        onCompleted == null) {
      return;
    }
    value = null;
    _resetRestoreHandshake();
    onCompleted();
    // The restored video page already owns another reference to this player.
    session.player.releaseFromInAppMiniPlayer(restoredToVideoPage: true);
  }

  void _resetRestoreHandshake() {
    _onRestorePageReady = null;
    _restoreAnimationCompleted = false;
    _restoreDestinationRect = null;
  }
}
