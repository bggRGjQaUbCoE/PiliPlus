import 'dart:ui';

class TwoFingerTapDetector {
  TwoFingerTapDetector({
    this.maxDuration = const Duration(milliseconds: 250),
    this.maxDownGap = const Duration(milliseconds: 120),
    this.maxMoveDistance = 18,
  });

  final Duration maxDuration;
  final Duration maxDownGap;
  final double maxMoveDistance;

  final Map<int, Offset> _startPositions = <int, Offset>{};
  DateTime? _firstDownAt;
  int _totalTouchPointers = 0;
  bool _isCandidate = false;

  void onPointerDown({
    required int pointer,
    required Offset position,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();
    if (_startPositions.isEmpty) {
      _firstDownAt = now;
      _totalTouchPointers = 0;
      _isCandidate = true;
    } else if (now.difference(_firstDownAt!) > maxDownGap) {
      _isCandidate = false;
    }

    _startPositions[pointer] = position;
    _totalTouchPointers += 1;
    if (_startPositions.length > 2 || _totalTouchPointers > 2) {
      _isCandidate = false;
    }
  }

  void onPointerMove({required int pointer, required Offset position}) {
    final start = _startPositions[pointer];
    if (start == null) {
      return;
    }
    if ((position - start).distance > maxMoveDistance) {
      _isCandidate = false;
    }
  }

  bool onPointerUp({required int pointer, DateTime? timestamp}) {
    final now = timestamp ?? DateTime.now();
    if (!_startPositions.containsKey(pointer)) {
      return false;
    }

    if (_firstDownAt == null || now.difference(_firstDownAt!) > maxDuration) {
      _isCandidate = false;
    }

    _startPositions.remove(pointer);
    final bool isRecognized =
        _isCandidate &&
        _totalTouchPointers == 2 &&
        _startPositions.isEmpty &&
        _firstDownAt != null;

    if (_startPositions.isEmpty) {
      reset();
    }
    return isRecognized;
  }

  void onPointerCancel(int pointer) {
    _startPositions.remove(pointer);
    if (_startPositions.isEmpty) {
      reset();
    } else {
      _isCandidate = false;
    }
  }

  void invalidate() {
    _isCandidate = false;
  }

  void reset() {
    _startPositions.clear();
    _firstDownAt = null;
    _totalTouchPointers = 0;
    _isCandidate = false;
  }
}
