import AVKit
import CoreMedia
import Flutter
import MediaAccessibility
import MediaPlayer
import UIKit

/// AVKit owns the AirPlay picker, receiver connection and video playback.
/// The receiver gets a CDN URL or the session's Wi-Fi HLS URL, never the local player's loopback URL.
final class AirPlayPlugin: NSObject, FlutterPlugin, AVRoutePickerViewDelegate, AVPlayerViewControllerDelegate {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.example.piliplus/airplay",
      binaryMessenger: registrar.messenger()
    )
    let instance = AirPlayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private var controller: AVPlayerViewController?
  private var sessionPlayer: AVPlayer?
  private weak var presenter: UIViewController?
  private var routePicker: AVRoutePickerView?
  private var pickerOpened = false
  private var completion: FlutterResult?
  private var statusObservation: NSKeyValueObservation?
  private var resolutionObservation: NSKeyValueObservation?
  private var externalPlaybackObservation: NSKeyValueObservation?
  private var timeControlObservation: NSKeyValueObservation?
  private var preparationTimer: Timer?
  private var initialPositionMs = 0
  private var failure: String?
  private var started = false
  private var positionLoaded = false
  private var enableSubtitles = false
  private var externalSubtitlesApplied = false
  private var diagnostics: [String] = []

  private func trace(_ message: String) {
    if diagnostics.count < 32 { diagnostics.append(message) }
  }
  private var audioConfiguration: (
    AVAudioSession.Category, AVAudioSession.Mode,
    AVAudioSession.RouteSharingPolicy, AVAudioSession.CategoryOptions
  )?

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "present":
      present(args, result: result)
    case "play":
      sessionPlayer?.play()
      result(nil)
    case "pause":
      sessionPlayer?.pause()
      result(nil)
    case "seek":
      let milliseconds = max(0, (args["positionMs"] as? NSNumber)?.int64Value ?? 0)
      sessionPlayer?.seek(to: CMTime(value: milliseconds, timescale: 1000))
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func present(_ args: [String: Any], result: @escaping FlutterResult) {
    guard completion == nil else {
      result(FlutterError(code: "BUSY", message: "AirPlay 已打开", details: nil))
      return
    }
    guard let rawURL = args["url"] as? String, let url = URL(string: rawURL),
      let host = url.host,
      url.scheme == "https" || (args["localNetwork"] as? Bool == true
        && url.scheme == "http" && isPrivateAddress(host)),
      !["localhost", "127.0.0.1", "::1"].contains(host)
    else {
      result(FlutterError(code: "URL", message: "此播放地址不支持 AirPlay", details: nil))
      return
    }
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    guard var presenter = window?.rootViewController else {
      result(FlutterError(code: "WINDOW", message: "请返回视频页面后重试", details: nil))
      return
    }
    while let presented = presenter.presentedViewController {
      presenter = presented
    }
    guard !presenter.isBeingDismissed else {
      result(FlutterError(code: "WINDOW", message: "请稍后重试", details: nil))
      return
    }

    let audioSession = AVAudioSession.sharedInstance()
    audioConfiguration = (
      audioSession.category, audioSession.mode,
      audioSession.routeSharingPolicy, audioSession.categoryOptions
    )
    do {
      try audioSession.setCategory(.playback, mode: .moviePlayback, policy: .longFormVideo)
      try audioSession.setActive(true)
    } catch {
      restoreAudioSession()
      result(FlutterError(code: "AUDIO", message: "无法启动投屏音频，请重试", details: nil))
      return
    }

    enableSubtitles = args["subtitles"] as? Bool == true
    diagnostics = []
    trace("present subtitles=\(enableSubtitles) position=\(args["positionMs"] ?? 0)")
    if enableSubtitles {
      var behavior = MACaptionAppearanceBehavior.useContentIfAvailable
      let windowOpacity = MACaptionAppearanceGetWindowOpacity(.user, &behavior)
      trace("caption windowOpacity=\(windowOpacity) behavior=\(behavior.rawValue)")
    }
    externalSubtitlesApplied = false
    let item = AVPlayerItem(url: url)
    if enableSubtitles, let preferences = args["subtitleStyle"] as? [String: Any] {
      var attributes: [String: Any] = [
        kCMTextMarkupAttribute_BackgroundColorARGB as String: [0, 0, 0, 0],
        kCMTextMarkupAttribute_CharacterBackgroundColorARGB as String: [0, 0, 0, 0],
        kCMTextMarkupAttribute_BaseFontSizePercentageRelativeToVideoHeight as String:
          min(15, max(1, (preferences["fontSize"] as? NSNumber)?.doubleValue ?? 4.5)),
        kCMTextMarkupAttribute_BoldStyle as String: preferences["bold"] as? Bool ?? false,
        kCMTextMarkupAttribute_CharacterEdgeStyle as String:
          preferences["outline"] as? Bool == false
            ? kCMTextMarkupCharacterEdgeStyle_None : kCMTextMarkupCharacterEdgeStyle_Uniform,
      ]
      if let family = preferences["fontFamily"] as? String, !family.isEmpty {
        attributes[kCMTextMarkupAttribute_FontFamilyName as String] = family
      }
      if let style = AVTextStyleRule(textMarkupAttributes: attributes) {
        item.textStyleRules = [style]
      }
    }
    let title = (args["title"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? "PiliPlus"
    setTitle(title, for: item)
    let player = AVPlayer(playerItem: item)
    player.allowsExternalPlayback = true
    // The app's enabled danmaku must not inherit the receiver's captions-off
    // preference. The user can still turn the track off in AVKit controls.
    if enableSubtitles { player.appliesMediaSelectionCriteriaAutomatically = false }
    sessionPlayer = player
    let viewController = AVPlayerViewController()
    viewController.player = player
    viewController.allowsPictureInPicturePlayback = false
    viewController.updatesNowPlayingInfoCenter = true
    viewController.modalPresentationStyle = .fullScreen
    viewController.delegate = self
    controller = viewController
    self.presenter = presenter
    completion = result
    initialPositionMs = max(0, (args["positionMs"] as? NSNumber)?.intValue ?? 0)
    failure = nil
    started = false
    positionLoaded = false
    externalPlaybackObservation = player.observe(\.isExternalPlaybackActive, options: [.new]) {
      [weak self] player, _ in
      DispatchQueue.main.async {
        self?.trace("external=\(player.isExternalPlaybackActive) time=\(CMTimeGetSeconds(player.currentTime()))")
        self?.selectExternalDanmakuWhenPlaying(item, player: player)
      }
    }
    timeControlObservation = player.observe(\.timeControlStatus, options: [.new]) {
      [weak self] player, _ in
      DispatchQueue.main.async {
        self?.trace("control=\(player.timeControlStatus.rawValue) rate=\(player.rate) time=\(CMTimeGetSeconds(player.currentTime()))")
        self?.selectExternalDanmakuWhenPlaying(item, player: player)
      }
    }
    resolutionObservation = item.observe(\.presentationSize, options: [.initial, .new]) {
      [weak self] item, _ in
      let size = item.presentationSize
      guard size.width > 0, size.height > 0 else { return }
      DispatchQueue.main.async {
        guard let self, self.sessionPlayer?.currentItem === item else { return }
        // Read the loaded video dimensions rather than the requested quality tier.
        let resolution = "\(Int(size.width.rounded()))×\(Int(size.height.rounded()))"
        self.setTitle("\(resolution) · \(title)", for: item)
      }
    }
    showRoutes(from: presenter)
  }

  private func showRoutes(from presenter: UIViewController) {
    let picker = AVRoutePickerView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    picker.prioritizesVideoDevices = true
    picker.delegate = self
    picker.isHidden = true
    presenter.view.addSubview(picker)
    picker.layoutIfNeeded()
    routePicker = picker
    pickerOpened = false
    // Forward the user's Flutter AirPlay tap to AVKit's route button.
    // AVKit owns the device list; no private selector or routing API is used.
    guard let button = picker.subviews.compactMap({ $0 as? UIButton }).first else {
      fail("无法打开 AirPlay 设备列表，请重试")
      return
    }
    button.sendActions(for: .touchUpInside)
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self, weak picker] in
      guard let self, self.routePicker === picker, !self.pickerOpened else { return }
      self.fail("无法打开 AirPlay 设备列表，请重试")
    }
  }

  func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
    if routePicker === routePickerView { pickerOpened = true }
  }

  func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
    guard routePicker === routePickerView else { return }
    routePickerView.removeFromSuperview()
    routePicker = nil
    // Let the system picker finish dismissing before showing playback controls.
    DispatchQueue.main.async { [weak self] in
      guard let self, self.completion != nil,
        let presenter = self.presenter, let controller = self.controller,
        let player = controller.player, let item = player.currentItem
      else { return }
      let selectedTV = AVAudioSession.sharedInstance().currentRoute.outputs
        .contains { $0.portType == .airPlay }
      guard selectedTV else {
        self.finish()
        return
      }
      presenter.present(controller, animated: true) { [weak self] in
        self?.prepare(item, player: player)
      }
    }
  }

  private func setTitle(_ title: String, for item: AVPlayerItem) {
    let metadata = AVMutableMetadataItem()
    metadata.identifier = .commonIdentifierTitle
    metadata.value = title as NSString
    metadata.extendedLanguageTag = "und"
    item.externalMetadata = [metadata]
  }

  private func isPrivateAddress(_ host: String) -> Bool {
    let parts = host.split(separator: ".").compactMap { Int($0) }
    guard parts.count == 4, parts.allSatisfy({ (0...255).contains($0) }) else { return false }
    return parts[0] == 10 || (parts[0] == 172 && (16...31).contains(parts[1]))
      || (parts[0] == 192 && parts[1] == 168)
  }

  private func prepare(_ item: AVPlayerItem, player: AVPlayer) {
    guard completion != nil, sessionPlayer === player else { return }
    preparationTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) {
      [weak self] _ in
      self?.fail("投屏视频加载超时，请重试或切换 CDN")
    }
    statusObservation = item.observe(\.status, options: [.initial, .new]) {
      [weak self] item, _ in
      DispatchQueue.main.async {
        guard let self, self.sessionPlayer === player else { return }
        self.trace("status=\(item.status.rawValue) time=\(CMTimeGetSeconds(player.currentTime()))")
        switch item.status {
        case .readyToPlay:
          guard !self.started else { return }
          self.started = true
          self.preparationTimer?.invalidate()
          self.preparationTimer = nil
          if self.enableSubtitles {
            self.selectDanmaku(item, player: player)
          }
          let seconds = CMTimeGetSeconds(item.duration)
          let requested = Double(self.initialPositionMs) / 1000
          let position = seconds.isFinite ? min(requested, max(0, seconds - 0.1)) : requested
          player.seek(to: CMTime(seconds: position, preferredTimescale: 1000)) {
            [weak self] finished in
            DispatchQueue.main.async {
              self?.trace("initialSeek finished=\(finished) time=\(CMTimeGetSeconds(player.currentTime()))")
              guard finished, let self, self.sessionPlayer === player else { return }
              self.positionLoaded = true
              player.play()
            }
          }
        case .failed:
          self.fail("此视频无法通过 AirPlay 播放，请重试或切换 CDN")
        default:
          break
        }
      }
    }
  }

  private func selectDanmaku(_ item: AVPlayerItem, player: AVPlayer) {
    Task { @MainActor [weak self] in
      let group: AVMediaSelectionGroup?
      do {
        group = try await item.asset.loadMediaSelectionGroup(for: .legible)
      } catch {
        self?.trace("legible load failed code=\((error as NSError).code)")
        return
      }
      self?.trace("legible options=\(group?.options.count ?? -1)")
      guard let group,
        let option = group.options.first(where: {
          $0.extendedLanguageTag?.hasPrefix("zh") == true
        }) ?? group.options.first,
        self?.sessionPlayer === player
      else { return }
      // External AVKit can retain a captions-off display state independently
      // of the chosen language. This public compatibility API is scoped to
      // this player; it does not change the system accessibility preferences.
      player.isClosedCaptionDisplayEnabled = true
      item.select(option, in: group)
      self?.trace("legible selected=\(item.currentMediaSelection.selectedMediaOption(in: group) != nil)")
    }
  }

  private func selectExternalDanmakuWhenPlaying(_ item: AVPlayerItem, player: AVPlayer) {
    guard sessionPlayer === player, enableSubtitles, !externalSubtitlesApplied,
      player.isExternalPlaybackActive, player.timeControlStatus == .playing
    else { return }
    externalSubtitlesApplied = true
    selectDanmaku(item, player: player)
  }

  private func fail(_ message: String) {
    guard completion != nil else { return }
    failure = message
    if let controller, controller.presentingViewController != nil {
      controller.dismiss(animated: true) { [weak self] in self?.finish() }
    } else {
      finish()
    }
  }

  private func finish() {
    guard let completion else { return }
    self.completion = nil
    preparationTimer?.invalidate()
    preparationTimer = nil
    statusObservation = nil
    resolutionObservation = nil
    externalPlaybackObservation = nil
    timeControlObservation = nil
    routePicker?.delegate = nil
    routePicker?.removeFromSuperview()
    routePicker = nil
    let player = sessionPlayer
    let seconds = player.map { CMTimeGetSeconds($0.currentTime()) } ?? .nan
    let nowPlayingTime = MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime]
    trace("finish loaded=\(positionLoaded) started=\(started) time=\(seconds) nowPlaying=\(nowPlayingTime ?? "nil") external=\(player?.isExternalPlaybackActive ?? false)")
    let positionMs = positionLoaded && seconds.isFinite && seconds >= 0
      ? Int(seconds * 1000) : initialPositionMs
    player?.pause()
    player?.replaceCurrentItem(with: nil)
    controller?.delegate = nil
    sessionPlayer = nil
    controller = nil
    presenter = nil
    restoreAudioSession()
    var response: [String: Any] = ["positionMs": positionMs]
    response["diagnostics"] = diagnostics
    if let failure { response["error"] = failure }
    completion(response)
  }

  func playerViewController(
    _ playerViewController: AVPlayerViewController,
    willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate(alongsideTransition: nil) { [weak self, weak playerViewController] context in
      guard !context.isCancelled, let self,
        self.controller === playerViewController else { return }
      self.finish()
    }
  }

  private func restoreAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
    if let saved = audioConfiguration {
      try? audioSession.setCategory(saved.0, mode: saved.1, policy: saved.2, options: saved.3)
    }
    audioConfiguration = nil
  }
}
