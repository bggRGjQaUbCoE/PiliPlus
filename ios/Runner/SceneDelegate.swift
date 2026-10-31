import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  @available(iOS 26.0, *)
  override func preferredWindowingControlStyle(
    for windowScene: UIWindowScene
  ) -> UIWindowScene.WindowingControlStyle {
    return .minimal
  }

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // FlutterSceneDelegate declares this method but may not implement it.
    if FlutterSceneDelegate.instancesRespond(
      to: #selector(UISceneDelegate.scene(_:willConnectTo:options:)))
    {
      super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    // iPhone on iOS 26+: host Flutter in a native tab bar controller so the
    // main navigation uses the system Liquid Glass tab bar, which iPhone Duo
    // also places in its vertical status bar.
    if #available(iOS 26.0, *), UIDevice.current.userInterfaceIdiom == .phone,
      let window,
      let flutterViewController = window.rootViewController as? FlutterViewController
    {
      window.rootViewController = NativeTabBarController(
        flutterViewController: flutterViewController)
    }
  }
}

/// Hosts the single Flutter view inside whichever tab is selected. Dart sends
/// the tabs over `piliplus/native_tab_bar`; until then the tab bar is hidden
/// and Flutter draws its own navigation.
@available(iOS 26.0, *)
final class NativeTabBarController: UITabBarController, UITabBarControllerDelegate {
  private let flutterViewController: FlutterViewController
  private var channel: FlutterMethodChannel?

  init(flutterViewController: FlutterViewController) {
    self.flutterViewController = flutterViewController
    super.init(nibName: nil, bundle: nil)
    delegate = self
    let channel = FlutterMethodChannel(
      name: "piliplus/native_tab_bar",
      binaryMessenger: flutterViewController.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    self.channel = channel
    let host = makeHost()
    viewControllers = [host]
    host.embed(flutterViewController)
    setTabBarHidden(true, animated: false)
  }

  private var safeArea = UIEdgeInsets.zero

  private func makeHost() -> FlutterHostViewController {
    let host = FlutterHostViewController()
    host.onSafeAreaChange = { [weak self] insets in
      guard let self, insets != self.safeArea else { return }
      self.safeArea = insets
      self.channel?.invokeMethod("safeArea", arguments: Self.encode(insets))
    }
    return host
  }

  private static func encode(_ insets: UIEdgeInsets) -> [String: Double] {
    [
      "top": insets.top, "left": insets.left,
      "bottom": insets.bottom, "right": insets.right,
    ]
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  private func handle(_ call: FlutterMethodCall, result: FlutterResult) {
    switch call.method {
    case "getSafeArea":
      result(Self.encode(safeArea))
    case "setTabs":
      guard let args = call.arguments as? [String: Any],
        let tabs = args["tabs"] as? [[String: String]], tabs.count > 1
      else { return result(false) }
      let selected = min(args["selected"] as? Int ?? 0, tabs.count - 1)
      let hosts = tabs.map { tab -> FlutterHostViewController in
        let host = makeHost()
        let symbols = Self.symbols(for: tab["id"] ?? "")
        host.tabBarItem = UITabBarItem(
          title: tab["title"],
          image: UIImage(systemName: symbols.normal),
          selectedImage: UIImage(systemName: symbols.selected))
        return host
      }
      hosts[selected].embed(flutterViewController)
      viewControllers = hosts
      selectedIndex = selected
      setTabBarHidden(false, animated: false)
      result(true)
    case "setSelected":
      if let index = call.arguments as? Int { select(index) }
      result(nil)
    case "setBadge":
      if let args = call.arguments as? [String: Any], let index = args["index"] as? Int,
        let item = viewControllers?[safe: index]?.tabBarItem
      {
        item.badgeValue = args["value"] as? String
      }
      result(nil)
    case "setHidden":
      setTabBarHidden(call.arguments as? Bool ?? false, animated: true)
      result(nil)
    case "setHidesVerticalBar":
      hidesVerticalBar = call.arguments as? Bool ?? false
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func symbols(for id: String) -> (normal: String, selected: String) {
    switch id {
    case "home": return ("house", "house.fill")
    case "dynamics": return ("circle.dashed", "circle.dashed.inset.filled")
    case "mine": return ("person", "person.fill")
    default: return ("circle", "circle.fill")
    }
  }

  private func select(_ index: Int) {
    guard let host = viewControllers?[safe: index] as? FlutterHostViewController,
      index != selectedIndex
    else { return }
    host.embed(flutterViewController)
    selectedIndex = index
  }

  func tabBarController(
    _ tabBarController: UITabBarController, shouldSelect viewController: UIViewController
  ) -> Bool {
    // Move the Flutter view into the tab before UIKit shows it.
    (viewController as? FlutterHostViewController)?.embed(flutterViewController)
    return true
  }

  func tabBarController(
    _ tabBarController: UITabBarController, didSelect viewController: UIViewController
  ) {
    channel?.invokeMethod("select", arguments: selectedIndex)
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    flutterViewController.supportedInterfaceOrientations
  }

  // iPhone Duo: pages such as the video page hide the status bar while it is
  // in the vertical bar, so their content can fill the bar's space. Elsewhere
  // the status bar is on top and Flutter keeps controlling it. The bar's safe
  // area stays when the status bar is hidden, so Dart is told to lay out over
  // it.
  private var hidesVerticalBar = false {
    didSet { verticalBarDidChange() }
  }
  private var hasVerticalBar = false {
    didSet { verticalBarDidChange() }
  }
  private var isVerticalBarHidden: Bool { hidesVerticalBar && hasVerticalBar }
  private var sentVerticalBarHidden = false

  private func verticalBarDidChange() {
    UIView.animate(withDuration: 0.25) { self.setNeedsStatusBarAppearanceUpdate() }
    if isVerticalBarHidden != sentVerticalBarHidden {
      sentVerticalBarHidden = isVerticalBarHidden
      channel?.invokeMethod("verticalBarHidden", arguments: isVerticalBarHidden)
    }
  }

  override var childForStatusBarHidden: UIViewController? {
    isVerticalBarHidden ? nil : super.childForStatusBarHidden
  }

  override var prefersStatusBarHidden: Bool {
    isVerticalBarHidden ? true : super.prefersStatusBarHidden
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // The vertical bar edge stays set while the status bar is hidden, and
    // changes when the device folds or unfolds.
    var hasVerticalBar = false
    #if compiler(>=6.4)
      if #available(iOS 27.1, *) {
        hasVerticalBar = traitCollection.verticalBarEdge != .unspecified
      }
    #endif
    if hasVerticalBar != self.hasVerticalBar {
      self.hasVerticalBar = hasVerticalBar
    }
  }

  // The tabs do not forward appearance callbacks, so deliver this controller's
  // appearance to Flutter directly. FlutterViewController creates its rendering
  // surface in viewWillAppear only once the viewport size is known, and
  // otherwise only on first layout or scene activation while active; on device
  // both can be missed at launch, leaving the launch screen up. The first
  // appearance is therefore delivered after this view is in the window and laid
  // out.
  private var hasFlutterAppeared = false

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if hasFlutterAppeared {
      flutterViewController.beginAppearanceTransition(true, animated: animated)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if hasFlutterAppeared {
      flutterViewController.endAppearanceTransition()
    } else {
      hasFlutterAppeared = true
      flutterViewController.view.layoutIfNeeded()
      flutterViewController.beginAppearanceTransition(true, animated: false)
      flutterViewController.endAppearanceTransition()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    flutterViewController.beginAppearanceTransition(false, animated: animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    flutterViewController.endAppearanceTransition()
  }
}

/// A tab's content controller; it only holds the shared Flutter view controller
/// and forwards system appearance queries to it. Appearance callbacks are not
/// forwarded, so moving Flutter between tabs does not pause the engine.
final class FlutterHostViewController: UIViewController {
  override var shouldAutomaticallyForwardAppearanceMethods: Bool { false }
  override var childForStatusBarStyle: UIViewController? { children.first }
  override var childForStatusBarHidden: UIViewController? { children.first }
  override var childForHomeIndicatorAutoHidden: UIViewController? { children.first }
  override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
    children.first
  }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    children.first?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
  }

  func embed(_ child: UIViewController) {
    guard child.parent !== self else { return }
    child.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
    addChild(child)
    child.view.frame = view.bounds
    child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(child.view)
    child.didMove(toParent: self)
    onSafeAreaChange?(view.safeAreaInsets)
  }

  /// The Flutter view reports no safe area when it is not the window's root
  /// controller, so the tab bar controller forwards this one to Dart.
  var onSafeAreaChange: ((UIEdgeInsets) -> Void)?

  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    if !children.isEmpty { onSafeAreaChange?(view.safeAreaInsets) }
  }
}

extension Array {
  fileprivate subscript(safe index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
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
    // UIHinge ships in the iOS 27.1 SDK (Xcode 27, Swift 6.4); older Xcode
    // versions build without hinge handling.
    #if compiler(>=6.4)
      if #available(iOS 27.1, *) {
        let interaction = UIHingeInteraction { [weak self] _, update in
          self?.hingeDidUpdate(update.hinge)
        }
        view.addInteraction(interaction)
      }
    #endif
  }

  #if compiler(>=6.4)
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
  #endif

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    isHingeOpen ? .all : super.supportedInterfaceOrientations
  }

  // When hosted in NativeTabBarController, UIKit reads orientations from the
  // root controller, so forward Flutter's update requests to it.
  @available(iOS 16.0, *)
  override func setNeedsUpdateOfSupportedInterfaceOrientations() {
    super.setNeedsUpdateOfSupportedInterfaceOrientations()
    if let root = view.window?.rootViewController, root !== self {
      root.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
  }
}
