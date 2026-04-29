import 'package:PiliPlus/grpc/bilibili/app/archive/v1.pb.dart' show Dimension;

extension DimensionExt on Dimension {
  bool get isVertical => rotate == .ONE ? width > height : height > width;
}

extension StringExt on String {
  bool get isVerticalFromUri {
    try {
      final params = Uri.parse(this).queryParameters;
      final width = int.parse(params['player_width']!);
      final height = int.parse(params['player_height']!);
      return params['player_rotate'] == '1' ? width > height : height > width;
    } catch (_) {
      return false;
    }
  }
}
