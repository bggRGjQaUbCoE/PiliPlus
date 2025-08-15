import 'package:PiliPlus/utils/extension.dart';

class VideoShotData {
  String? pvdata;
  int imgXLen;
  int imgYLen;
  double imgXSize;
  double imgYSize;
  late final int totalPerImage = imgXLen * imgYLen;
  List<String> image;
  List<int> index;

  VideoShotData({
    this.pvdata,
    required this.imgXLen,
    required this.imgYLen,
    required this.imgXSize,
    required this.imgYSize,
    required this.image,
    required this.index,
  });

  factory VideoShotData.fromJson(Map<String, dynamic> json) => VideoShotData(
    pvdata: json["pvdata"],
    imgXLen: json["img_x_len"],
    imgYLen: json["img_y_len"],
    imgXSize: (json["img_x_size"] as num).toDouble(),
    imgYSize: (json["img_y_size"] as num).toDouble(),
    image: (json["image"] as List)
        .map((e) => (e as String).http2https)
        .toList(),
    index: (json["index"] as List).cast(),
  );
}
