import 'package:PiliPlus/http/loading_state.dart';
import 'package:flutter/foundation.dart';

typedef LiveDanmakuSendAttempt = ({
  LoadingState<void> response,
  int draftRevision,
});

/// One in-flight live message per room, across route and inline composers.
/// A successful response only clears the draft generation that was submitted.
class LiveDanmakuSendGate extends ChangeNotifier {
  bool _pending = false;
  bool _disposed = false;
  int _draftRevision = 0;
  int _successSerial = 0;
  int? _successfulRevision;

  bool get pending => _pending;
  int get draftRevision => _draftRevision;
  int get successSerial => _successSerial;
  int? get successfulRevision => _successfulRevision;

  void markDraftChanged() {
    ++_draftRevision;
    if (!_disposed) notifyListeners();
  }

  Future<LiveDanmakuSendAttempt?> trySend(
    Future<LoadingState<void>> Function() request, {
    required bool clearDraftOnSuccess,
    void Function(int revision)? onDraftSuccess,
  }) async {
    if (_pending || _disposed) return null;
    _pending = true;
    final revision = _draftRevision;
    if (!_disposed) notifyListeners();
    try {
      final response = await request();
      if (_disposed) return null;
      if (response.isSuccess && clearDraftOnSuccess) {
        _successfulRevision = revision;
        ++_successSerial;
        onDraftSuccess?.call(revision);
      }
      return (response: response, draftRevision: revision);
    } finally {
      _pending = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
