import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    application.applicationSupportsShakeToEdit = false // Disable shake to undo
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let controller = engineBridge.rootViewController as? FlutterViewController else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "com.example.piliplus/image_clipboard",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "copyImage":
        guard
          let args = call.arguments as? [String: Any],
          let path = args["path"] as? String,
          let data = FileManager.default.contents(atPath: path),
          let image = UIImage(data: data)
        else {
          result(false)
          return
        }
        UIPasteboard.general.image = image
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
