import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  @available(iOS 26.0, *)
  override func preferredWindowingControlStyle(
    for windowScene: UIWindowScene
  ) -> UIWindowScene.WindowingControlStyle {
    return .minimal
  }
}

// iPhone Duo: Flutter locks the interface to portrait on the outer display.
// UIKit picks the inner display's orientation from the lock in effect before
// the device unfolds, so a portrait-only lock leaves the interface in the inner
// display's native orientation, rotated relative to the device. Release the
// lock as soon as the hinge leaves the closed state, before the scene moves to
// the inner display. Dart restores it after the device closes again.
class DuoFlutterViewController: FlutterViewController {
  private var isHingeOpen = false

  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 27.1, *) {
      let interaction = UIHingeInteraction { [weak self] _, update in
        self?.hingeDidUpdate(update.hinge)
      }
      view.addInteraction(interaction)
    }
  }

  @available(iOS 27.1, *)
  private func hingeDidUpdate(_ hinge: UIHinge?) {
    let isOpen = hinge.map { $0.status != .closed && $0.status != .unknown } ?? false
    guard isOpen != isHingeOpen else { return }
    isHingeOpen = isOpen
    setNeedsUpdateOfSupportedInterfaceOrientations()
    // Flutter also stores the lock as the scene's geometry preference, which
    // UIKit uses when the scene moves to the inner display. Clear it while the
    // scene is still on the outer display, where programmatic changes are
    // allowed.
    if isOpen, let windowScene = view.window?.windowScene {
      windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
    }
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    isHingeOpen ? .all : super.supportedInterfaceOrientations
  }
}
