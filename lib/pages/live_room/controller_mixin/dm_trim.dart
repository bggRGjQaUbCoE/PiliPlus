part of 'package:PiliPlus/pages/live_room/controller.dart';

mixin _LiveDMTrimMixin on _LiveDataMixin, _LiveDMMixin {
  int chatSimpleIndex = 0;
  int _trimDmIndex = 0;
  int get trimDmIndex => _trimDmIndex;

  void _trimDm() {
    final trimCount = messages.length - _trimDmIndex;
    if (trimCount > _kTrimCount) {
      final endIndex = messages.length - _kMaxChatCount;
      final canTrim = (chatSimpleIndex - endIndex) > _kSafeTrimIndex;
      if (canTrim) {
        messages.fillRangeOnly(_trimDmIndex, endIndex);
        _trimDmIndex = endIndex;
      }
    }
  }
}
