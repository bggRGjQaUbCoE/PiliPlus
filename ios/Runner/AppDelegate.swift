import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var windowControlsChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    application.applicationSupportsShakeToEdit = false // Disable shake to undo
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "com.example.piliplus/window_controls",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "getPlayerControlsLeadingInset" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(self?.playerControlsLeadingInset() ?? 0.0)
    }
    windowControlsChannel = channel
  }

  private func playerControlsLeadingInset() -> Double {
    guard UIDevice.current.userInterfaceIdiom == .pad else {
      return 0
    }

    if #available(iOS 26.0, *) {
      guard
        let windowScene = UIApplication.shared.connectedScenes
          .compactMap({ $0 as? UIWindowScene })
          .first(where: { $0.activationState == .foregroundActive }),
        !windowScene.isFullScreen,
        let rootView = windowScene.keyWindow?.rootViewController?.view
      else {
        return 0
      }

      rootView.layoutIfNeeded()
      // Window controls don't change safeAreaInsets; this guide supplies their leading boundary.
      let layoutFrame = rootView.layoutGuide(
        for: .margins(cornerAdaptation: .horizontal)
      ).layoutFrame
      return Double(max(0, layoutFrame.minX - rootView.bounds.minX))
    }

    return 0
  }
}
