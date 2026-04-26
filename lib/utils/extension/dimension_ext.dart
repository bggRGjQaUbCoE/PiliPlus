import 'package:PiliPlus/grpc/bilibili/app/archive/v1.pb.dart' show Dimension;

extension DimensionExt on Dimension {
  bool get isVertical => rotate == .ONE ? width > height : height > width;
}
