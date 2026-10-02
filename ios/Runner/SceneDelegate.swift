import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  // iOS 26 API:用编译器版本守卫,旧 SDK(Xcode 16 / Swift <6.2)跳过编译
  #if compiler(>=6.2)
  @available(iOS 26.0, *)
  override func preferredWindowingControlStyle(
    for windowScene: UIWindowScene
  ) -> UIWindowScene.WindowingControlStyle {
    return .minimal
  }
  #endif
}
