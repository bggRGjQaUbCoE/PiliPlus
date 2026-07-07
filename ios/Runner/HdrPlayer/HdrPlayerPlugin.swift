import AVFoundation
import Flutter
import UIKit

/// iOS counterpart of android/.../HdrPlayerPlugin.kt. Speaks the exact same
/// MethodChannel/EventChannel protocol so the Dart backend
/// (android_hdr_playback_backend.dart) works unchanged on both platforms.
final class HdrPlayerPlugin: NSObject, FlutterStreamHandler {
    static let channelName = "PiliPlus/HdrPlayer"
    static let eventsName = "PiliPlus/HdrPlayer/events"
    static let viewType = "com.example.piliplus/hdr_player_view"

    fileprivate var sessions: [Int: HdrPlayerSession] = [:]
    private var nextSessionId = 1
    private var sink: FlutterEventSink?

    static func register(with registrar: FlutterPluginRegistrar) {
        let plugin = HdrPlayerPlugin()
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger()
        )
        channel.setMethodCallHandler(plugin.handle)
        let events = FlutterEventChannel(
            name: eventsName,
            binaryMessenger: registrar.messenger()
        )
        events.setStreamHandler(plugin)
        registrar.register(
            HdrPlayerViewFactory(plugin: plugin),
            withId: viewType
        )
        // Keep the plugin alive for the lifetime of the engine.
        retainedInstances.append(plugin)
    }

    private static var retainedInstances: [HdrPlayerPlugin] = []

    // MARK: - Method channel

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method {
        case "create":
            let id = nextSessionId
            nextSessionId += 1
            sessions[id] = HdrPlayerSession(sessionId: id) { [weak self] sessionId, type, data in
                self?.sendEvent(sessionId: sessionId, type: type, data: data)
            }
            result(id)

        case "supportsHdr":
            result(Self.supportsHdr(qualityCode: args?["qualityCode"] as? Int))

        case "setHdrMode":
            // iOS engages EDR automatically when HDR content plays; no-op.
            result(nil)

        case "open":
            guard let session = requireSession(args, result) else { return }
            guard let videoUrl = args?["videoUrl"] as? String, !videoUrl.isEmpty else {
                result(FlutterError(code: "bad_args", message: "videoUrl is required", details: nil))
                return
            }
            session.open(
                videoUrl: videoUrl,
                audioUrl: args?["audioUrl"] as? String,
                isFileSource: args?["isFileSource"] as? Bool ?? false,
                startMs: (args?["startMs"] as? NSNumber)?.int64Value ?? 0,
                headers: args?["headers"] as? [String: String] ?? [:],
                fitMode: args?["fitMode"] as? String ?? "contain",
                qualityCode: args?["qualityCode"] as? Int,
                frameRate: args?["frameRate"] as? String,
                width: args?["width"] as? Int,
                height: args?["height"] as? Int
            )
            result(nil)

        case "play":
            guard let session = requireSession(args, result) else { return }
            session.play()
            result(nil)

        case "pause":
            guard let session = requireSession(args, result) else { return }
            session.pause()
            result(nil)

        case "seekTo":
            guard let session = requireSession(args, result) else { return }
            session.seekTo(positionMs: (args?["positionMs"] as? NSNumber)?.int64Value ?? 0)
            result(nil)

        case "setPlaybackSpeed":
            guard let session = requireSession(args, result) else { return }
            session.setPlaybackSpeed((args?["speed"] as? NSNumber)?.floatValue ?? 1)
            result(nil)

        case "setVolume":
            guard let session = requireSession(args, result) else { return }
            session.setVolume((args?["volume"] as? NSNumber)?.floatValue ?? 1)
            result(nil)

        case "setFitMode":
            guard let session = requireSession(args, result) else { return }
            session.setFitMode(args?["fitMode"] as? String ?? "contain")
            result(nil)

        case "screenshot":
            guard let session = requireSession(args, result) else { return }
            result(session.screenshot())

        case "dispose":
            if let sessionId = args?["sessionId"] as? Int {
                sessions.removeValue(forKey: sessionId)?.dispose()
            }
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @discardableResult
    private func requireSession(
        _ args: [String: Any]?,
        _ result: @escaping FlutterResult
    ) -> HdrPlayerSession? {
        guard let sessionId = args?["sessionId"] as? Int else {
            result(FlutterError(code: "missing_session", message: "sessionId is required", details: nil))
            return nil
        }
        guard let session = sessions[sessionId] else {
            result(FlutterError(code: "invalid_session", message: "session \(sessionId) does not exist", details: nil))
            return nil
        }
        return session
    }

    private static func supportsHdr(qualityCode: Int?) -> Bool {
        // eligibleForHDRPlayback covers decoder + display capability. Fall back
        // to the per-mode query which is available from iOS 11.4.
        if #available(iOS 13.4, *), AVPlayer.eligibleForHDRPlayback {
            return true
        }
        let modes = AVPlayer.availableHDRModes
        switch qualityCode {
        case 125:
            return modes.contains(.hdr10) || modes.contains(.hlg) || modes.contains(.dolbyVision)
        default:
            // Mirror Android: Dolby Vision sources can still be shown through
            // an HDR10-compatible pipeline, so any HDR mode qualifies.
            return !modes.isEmpty
        }
    }

    // MARK: - Event channel

    private func sendEvent(sessionId: Int, type: String, data: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let sink = self?.sink else { return }
            var payload: [String: Any] = ["sessionId": sessionId, "type": type]
            payload.merge(data) { _, new in new }
            sink(payload)
        }
    }

    func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        sink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}

// MARK: - Platform view

final class HdrPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
    private weak var plugin: HdrPlayerPlugin?

    init(plugin: HdrPlayerPlugin) {
        self.plugin = plugin
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let sessionId = (args as? [String: Any])?["sessionId"] as? Int
        let view = sessionId.flatMap { plugin?.sessions[$0]?.view } ?? UIView()
        return HdrPlatformView(view: view)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}

final class HdrPlatformView: NSObject, FlutterPlatformView {
    private let contentView: UIView

    init(view: UIView) {
        contentView = view
        super.init()
    }

    func view() -> UIView { contentView }
}
