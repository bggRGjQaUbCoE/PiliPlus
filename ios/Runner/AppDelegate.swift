import AVFoundation
import AVKit
import Flutter
import UIKit

private final class IOSPiPManager: NSObject, AVPictureInPictureControllerDelegate {
  static let shared = IOSPiPManager()

  weak var channel: FlutterMethodChannel?

  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  private var pipController: AVPictureInPictureController?
  private var overlayWindow: UIWindow?
  private var pendingStartResult: FlutterResult?
  private var suppressStopCallback = false

  private override init() {
    super.init()
  }

  var isAvailable: Bool {
    AVPictureInPictureController.isPictureInPictureSupported()
  }

  func enter(arguments: Any?, result: @escaping FlutterResult) {
    guard isAvailable else {
      result(false)
      return
    }
    guard
      let args = arguments as? [String: Any],
      let videoURL = args["videoUrl"] as? String
    else {
      result(false)
      return
    }

    let audioURL = args["audioUrl"] as? String
    let positionMs = args["positionMs"] as? Int ?? 0
    let playWhenReady = args["playWhenReady"] as? Bool ?? true
    let playbackSpeed = args["playbackSpeed"] as? Double ?? 1.0
    let headers = args["headers"] as? [String: String] ?? [:]

    pendingStartResult = result

    buildPlayerItem(
      videoURL: videoURL,
      audioURL: audioURL,
      headers: headers
    ) { [weak self] item in
      DispatchQueue.main.async {
        guard let self else { return }
        guard let item else {
          self.finishPendingStart(false)
          self.teardown()
          return
        }
        self.startPiP(
          item: item,
          positionMs: positionMs,
          playWhenReady: playWhenReady,
          playbackSpeed: playbackSpeed
        )
      }
    }
  }

  func restore() -> [String: Any] {
    let state = currentState(wasActive: isSessionActive)
    guard isSessionActive else {
      teardown()
      return state
    }

    suppressStopCallback = true
    if pipController?.isPictureInPictureActive == true {
      pipController?.stopPictureInPicture()
    }
    teardown()
    return state
  }

  private var isSessionActive: Bool {
    (pipController?.isPictureInPictureActive ?? false) || player != nil
  }

  private func startPiP(
    item: AVPlayerItem,
    positionMs: Int,
    playWhenReady: Bool,
    playbackSpeed: Double
  ) {
    teardown()

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      finishPendingStart(false)
      return
    }

    let player = AVPlayer(playerItem: item)
    self.player = player
    guard attachPlayerLayer(player: player) else {
      finishPendingStart(false)
      teardown()
      return
    }

    let startPlayback = { [weak self] in
      guard let self else { return }
      if playWhenReady {
        player.playImmediately(atRate: Float(playbackSpeed))
      }
      self.tryStartPictureInPicture(retries: 10)
    }

    if positionMs > 0 {
      let seekTime = CMTime(
        value: CMTimeValue(positionMs),
        timescale: 1000
      )
      player.seek(
        to: seekTime,
        toleranceBefore: .zero,
        toleranceAfter: .zero
      ) { _ in
        startPlayback()
      }
    } else {
      startPlayback()
    }
  }

  private func attachPlayerLayer(player: AVPlayer) -> Bool {
    guard let scene = currentWindowScene() else {
      return false
    }

    let window = UIWindow(windowScene: scene)
    let rootVC = UIViewController()
    rootVC.view.backgroundColor = .clear

    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    playerLayer.videoGravity = .resizeAspect
    rootVC.view.layer.addSublayer(playerLayer)

    window.rootViewController = rootVC
    window.windowLevel = .alert + 1
    window.backgroundColor = .clear
    window.alpha = 0.01
    window.isHidden = false

    self.overlayWindow = window
    self.playerLayer = playerLayer
    self.pipController = AVPictureInPictureController(playerLayer: playerLayer)
    self.pipController?.delegate = self
    return true
  }

  private func tryStartPictureInPicture(retries: Int) {
    guard let pipController else {
      finishPendingStart(false)
      teardown()
      return
    }

    if pipController.isPictureInPictureActive {
      finishPendingStart(true)
      return
    }

    if pipController.isPictureInPicturePossible {
      pipController.startPictureInPicture()
      return
    }

    guard retries > 0 else {
      finishPendingStart(false)
      teardown()
      return
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
      self?.tryStartPictureInPicture(retries: retries - 1)
    }
  }

  private func buildPlayerItem(
    videoURL: String,
    audioURL: String?,
    headers: [String: String],
    completion: @escaping (AVPlayerItem?) -> Void
  ) {
    let videoAsset = makeAsset(urlString: videoURL, headers: headers)
    loadAsset(videoAsset) { [weak self] loaded in
      guard let self, loaded else {
        completion(nil)
        return
      }

      guard let audioURL, !audioURL.isEmpty else {
        completion(AVPlayerItem(asset: videoAsset))
        return
      }

      let audioAsset = self.makeAsset(urlString: audioURL, headers: headers)
      self.loadAsset(audioAsset) { loadedAudio in
        guard loadedAudio else {
          completion(nil)
          return
        }

        let composition = AVMutableComposition()
        guard
          let videoSourceTrack = videoAsset.tracks(withMediaType: .video).first,
          let compositionVideoTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: kCMPersistentTrackID_Invalid
          )
        else {
          completion(nil)
          return
        }

        do {
          try compositionVideoTrack.insertTimeRange(
            CMTimeRange(start: .zero, duration: videoAsset.duration),
            of: videoSourceTrack,
            at: .zero
          )
          compositionVideoTrack.preferredTransform = videoSourceTrack.preferredTransform

          if
            let audioSourceTrack = audioAsset.tracks(withMediaType: .audio).first,
            let compositionAudioTrack = composition.addMutableTrack(
              withMediaType: .audio,
              preferredTrackID: kCMPersistentTrackID_Invalid
            )
          {
            let audioDuration = audioAsset.duration.isValid ? audioAsset.duration : videoAsset.duration
            try compositionAudioTrack.insertTimeRange(
              CMTimeRange(start: .zero, duration: audioDuration),
              of: audioSourceTrack,
              at: .zero
            )
          }

          completion(AVPlayerItem(asset: composition))
        } catch {
          completion(nil)
        }
      }
    }
  }

  private func makeAsset(urlString: String, headers: [String: String]) -> AVURLAsset {
    let options: [String: Any] = headers.isEmpty
      ? [:]
      : ["AVURLAssetHTTPHeaderFieldsKey": headers]
    return AVURLAsset(url: URL(string: urlString)!, options: options)
  }

  private func loadAsset(_ asset: AVURLAsset, completion: @escaping (Bool) -> Void) {
    let keys = ["tracks", "duration", "playable"]
    asset.loadValuesAsynchronously(forKeys: keys) {
      var error: NSError?
      for key in keys {
        let status = asset.statusOfValue(forKey: key, error: &error)
        if status == .failed || status == .cancelled {
          completion(false)
          return
        }
      }
      completion(asset.isPlayable)
    }
  }

  private func currentWindowScene() -> UIWindowScene? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
  }

  private func currentState(wasActive: Bool) -> [String: Any] {
    let positionSeconds = player?.currentTime().seconds ?? 0
    let positionMs = positionSeconds.isFinite ? Int(positionSeconds * 1000) : 0
    let isPlaying = player?.timeControlStatus == .playing
    return [
      "wasActive": wasActive,
      "positionMs": positionMs,
      "isPlaying": isPlaying,
    ]
  }

  private func finishPendingStart(_ started: Bool) {
    pendingStartResult?(started)
    pendingStartResult = nil
  }

  private func teardown() {
    player?.pause()
    playerLayer?.player = nil
    playerLayer?.removeFromSuperlayer()
    overlayWindow?.isHidden = true
    overlayWindow = nil
    playerLayer = nil
    pipController?.delegate = nil
    pipController = nil
    player = nil
  }

  func pictureInPictureControllerDidStartPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {
    finishPendingStart(true)
  }

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    failedToStartPictureInPictureWithError error: Error
  ) {
    finishPendingStart(false)
    teardown()
  }

  func pictureInPictureControllerDidStopPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {
    let state = currentState(wasActive: true)
    let shouldNotify = !suppressStopCallback
    suppressStopCallback = false
    teardown()
    if shouldNotify {
      channel?.invokeMethod("onPipStop", arguments: state)
    }
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var iosPipChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    application.applicationSupportsShakeToEdit = false
    let finished = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    DispatchQueue.main.async { [weak self] in
      self?.setupIOSPipChannel()
    }
    return finished
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    DispatchQueue.main.async { [weak self] in
      self?.setupIOSPipChannel()
    }
  }

  private func setupIOSPipChannel() {
    if iosPipChannel != nil {
      return
    }
    guard let flutterVC = currentFlutterViewController() else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
        self?.setupIOSPipChannel()
      }
      return
    }

    let channel = FlutterMethodChannel(
      name: "PiliPlus.iOSPiP",
      binaryMessenger: flutterVC.binaryMessenger
    )
    IOSPiPManager.shared.channel = channel
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "isAvailable":
        result(IOSPiPManager.shared.isAvailable)
      case "enter":
        IOSPiPManager.shared.enter(arguments: call.arguments, result: result)
      case "restore":
        result(IOSPiPManager.shared.restore())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    iosPipChannel = channel
  }

  private func currentFlutterViewController() -> FlutterViewController? {
    if let root = window?.rootViewController as? FlutterViewController {
      return root
    }

    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first(where: \.isKeyWindow)?
      .rootViewController as? FlutterViewController
  }
}
