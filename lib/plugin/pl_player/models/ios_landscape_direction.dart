// iOS 点击全屏（无重力方向信息）时默认的横屏方向
enum IosLandscapeDirection {
  // 按机型：底部扬声器偏左的机型顺时针，其余逆时针
  auto('自动（按机型）'),
  // 逆时针旋转 90°，Home 指示条在右侧（DeviceOrientation.landscapeRight）
  counterclockwise('逆时针旋转（底边在右）'),
  // 顺时针旋转 90°，Home 指示条在左侧（DeviceOrientation.landscapeLeft）
  clockwise('顺时针旋转（底边在左）'),
  ;

  final String desc;
  const IosLandscapeDirection(this.desc);
}
