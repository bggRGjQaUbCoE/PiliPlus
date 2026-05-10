import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var appDnsResolverChannels: [FlutterMethodChannel] = []

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    application.applicationSupportsShakeToEdit = false // Disable shake to undo
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    if let controller = window?.rootViewController as? FlutterViewController {
      registerAppDnsResolverChannel(binaryMessenger: controller.binaryMessenger)
    }
    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerAppDnsResolverChannel(
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
  }

  private func registerAppDnsResolverChannel(binaryMessenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "PiliPlus/AppDnsResolver",
      binaryMessenger: binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "setHost":
        guard
          let args = call.arguments as? [String: Any],
          let host = args["host"] as? String,
          let addresses = args["addresses"] as? [String]
        else {
          result(FlutterError(code: "bad_args", message: nil, details: nil))
          return
        }
        let joinedAddresses = addresses.joined(separator: "\n")
        let code = host.withCString { hostPointer in
          joinedAddresses.withCString { addressesPointer in
            PiliPlusAppDnsSetHost(hostPointer, addressesPointer)
          }
        }
        if code == 0 {
          result(nil)
        } else {
          result(FlutterError(code: "set_host_failed", message: nil, details: nil))
        }
      case "clear":
        PiliPlusAppDnsClearHosts()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    appDnsResolverChannels.append(channel)
  }
}
