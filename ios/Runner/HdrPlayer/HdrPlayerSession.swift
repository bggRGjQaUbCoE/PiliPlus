import AVFoundation
import Flutter
import UIKit

final class HdrPlayerContainerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

/// One playback session backed by AVPlayer, mirroring the event protocol of
/// the Android Media3 implementation in HdrPlayerPlugin.kt.
final class HdrPlayerSession: NSObject {
    private let sessionId: Int
    private let sendEvent: (Int, String, [String: Any]) -> Void

    let view = HdrPlayerContainerView()
    private let player = AVPlayer()
    private var item: AVPlayerItem?
    private var bridge: DashHlsBridge?
    private var videoOutput: AVPlayerItemVideoOutput?

    private var observations: [NSKeyValueObservation] = []
    private var notificationTokens: [NSObjectProtocol] = []
    private var timeObserver: Any?

    private var playWhenReady = false
    private var desiredRate: Float = 1.0
    private var reportedPlaying = false
    private var pendingStartMs: Int64 = 0
    private var disposed = false

    init(sessionId: Int, sendEvent: @escaping (Int, String, [String: Any]) -> Void) {
        self.sessionId = sessionId
        self.sendEvent = sendEvent
        super.init()
        view.backgroundColor = .clear
        view.playerLayer.player = player
        player.actionAtItemEnd = .pause
    }

    // MARK: - Public control surface

    func open(
        videoUrl: String,
        audioUrl: String?,
        isFileSource: Bool,
        startMs: Int64,
        headers: [String: String],
        fitMode: String,
        qualityCode: Int?,
        frameRate: String? = nil,
        width: Int? = nil,
        height: Int? = nil
    ) {
        setFitMode(fitMode)
        pendingStartMs = startMs
        let bridge = DashHlsBridge(headers: headers)
        self.bridge = bridge
        Task { [weak self] in
            do {
                try await bridge.prepare(
                    videoUrl: videoUrl,
                    audioUrl: audioUrl,
                    isFileSource: isFileSource,
                    qualityCode: qualityCode,
                    frameRate: frameRate,
                    width: width,
                    height: height
                )
                await MainActor.run { [weak self] in
                    self?.attachItem(bridge: bridge, headers: headers)
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.reportError(error)
                }
            }
        }
    }

    private func attachItem(bridge: DashHlsBridge, headers: [String: String]) {
        if disposed { return }
        var options: [String: Any] = [:]
        // Applies to every HTTP request AVPlayer issues for this asset,
        // including the media segments that go straight to the CDN.
        options["AVURLAssetHTTPHeaderFieldsKey"] = headers
        let asset = AVURLAsset(url: bridge.masterUrl, options: options)
        asset.resourceLoader.setDelegate(bridge, queue: bridge.resourceLoaderQueue)
        let item = AVPlayerItem(asset: asset)
        item.preferredForwardBufferDuration = 0
        self.item = item

        observeItem(item)
        player.replaceCurrentItem(with: item)
        // Watchdog: if the item never becomes ready, surface an error so the
        // Dart side can fall back instead of showing a black view forever.
        // Only fail when nothing has been fetched — if bytes are flowing the
        // item is merely buffering on a slow connection, so keep waiting.
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) { [weak self, weak item] in
            guard let self, !self.disposed, let item, item.status == .unknown else { return }
            let transferred = item.accessLog()?.events.last?.numberOfBytesTransferred ?? 0
            if transferred > 0 { return }
            self.reportError(
                NSError(
                    domain: "HdrPlayer",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "player not ready within 12s, no data transferred",
                    ]
                )
            )
        }
        if pendingStartMs > 0 {
            let target = CMTime(value: pendingStartMs, timescale: 1000)
            player.seek(to: target, toleranceBefore: .zero, toleranceAfter: .zero)
        }
        if playWhenReady {
            player.playImmediately(atRate: desiredRate)
        }
    }

    func play() {
        playWhenReady = true
        guard item != nil else { return }
        player.playImmediately(atRate: desiredRate)
    }

    func pause() {
        playWhenReady = false
        player.pause()
    }

    func seekTo(positionMs: Int64) {
        let target = CMTime(value: max(0, positionMs), timescale: 1000)
        player.seek(to: target, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            self?.sendTimeline()
        }
    }

    func setPlaybackSpeed(_ speed: Float) {
        desiredRate = max(0.1, speed)
        if player.timeControlStatus != .paused {
            player.rate = desiredRate
        }
    }

    func setVolume(_ volume: Float) {
        player.volume = min(max(volume, 0), 1)
    }

    func setFitMode(_ fitMode: String) {
        switch fitMode {
        case "fill":
            view.playerLayer.videoGravity = .resize
        case "cover":
            view.playerLayer.videoGravity = .resizeAspectFill
        default:
            // contain / fitWidth / fitHeight: the Flutter side already sizes
            // the platform view, aspect fit matches Android's behaviour.
            view.playerLayer.videoGravity = .resizeAspect
        }
    }

    func screenshot() -> FlutterStandardTypedData? {
        guard let item else { return nil }
        // Attach the BGRA (SDR) output tap lazily: keeping it on the item
        // during normal playback pulls the pipeline out of the EDR/HDR path.
        let output: AVPlayerItemVideoOutput
        if let existing = videoOutput {
            output = existing
        } else {
            output = AVPlayerItemVideoOutput(pixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            ])
            item.add(output)
            videoOutput = output
            Thread.sleep(forTimeInterval: 0.15)
        }
        let time = item.currentTime()
        guard output.hasNewPixelBuffer(forItemTime: time) || item.status == .readyToPlay,
              let buffer = output.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil)
        else { return nil }
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        guard let png = UIImage(cgImage: cgImage).pngData() else { return nil }
        return FlutterStandardTypedData(bytes: png)
    }

    func dispose() {
        disposed = true
        stopProgress()
        observations.forEach { $0.invalidate() }
        observations.removeAll()
        notificationTokens.forEach(NotificationCenter.default.removeObserver)
        notificationTokens.removeAll()
        player.pause()
        player.replaceCurrentItem(with: nil)
        view.playerLayer.player = nil
        bridge = nil
    }

    // MARK: - Observation

    private func observeItem(_ item: AVPlayerItem) {
        observations.append(item.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard let self else { return }
            switch item.status {
            case .readyToPlay:
                self.sendTimeline()
                self.send("ready")
                self.send("buffering", ["value": false])
            case .failed:
                self.reportError(item.error ?? DashHlsError.parse("item failed"))
            default:
                break
            }
        })

        observations.append(item.observe(\.presentationSize, options: [.new]) { [weak self] item, _ in
            let size = item.presentationSize
            if size.width > 0, size.height > 0 {
                self?.send("size", ["width": Int(size.width), "height": Int(size.height)])
            }
        })

        observations.append(item.observe(\.isPlaybackBufferEmpty, options: [.new]) { [weak self] item, _ in
            if item.isPlaybackBufferEmpty {
                self?.send("buffering", ["value": true])
            }
        })

        observations.append(item.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] item, _ in
            if item.isPlaybackLikelyToKeepUp {
                self?.send("buffering", ["value": false])
            }
        })

        observations.append(player.observe(\.timeControlStatus, options: [.new]) { [weak self] player, _ in
            guard let self else { return }
            switch player.timeControlStatus {
            case .playing:
                self.reportedPlaying = true
                self.send("playing")
                self.startProgress()
            case .waitingToPlayAtSpecifiedRate:
                self.send("buffering", ["value": true])
            case .paused:
                if self.reportedPlaying {
                    self.reportedPlaying = false
                    self.send("paused")
                }
                self.stopProgress()
            @unknown default:
                break
            }
        })

        notificationTokens.append(
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: item,
                queue: .main
            ) { [weak self] _ in
                self?.playWhenReady = false
                self?.send("completed")
                self?.stopProgress()
            }
        )

        notificationTokens.append(
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemFailedToPlayToEndTime,
                object: item,
                queue: .main
            ) { [weak self] notification in
                let error =
                    notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
                self?.reportError(error ?? DashHlsError.parse("failed to play to end"))
            }
        )
    }

    // MARK: - Progress heartbeat (250 ms, mirrors the Android tick)

    private func startProgress() {
        guard timeObserver == nil else { return }
        let interval = CMTime(value: 1, timescale: 4)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] _ in
            self?.sendTimeline()
        }
    }

    private func stopProgress() {
        if let timeObserver {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }

    private func sendTimeline() {
        guard let item else { return }
        let positionMs = item.currentTime().milliseconds
        let durationMs = item.duration.milliseconds
        var bufferedMs: Int64 = 0
        if let range = item.loadedTimeRanges.first?.timeRangeValue {
            bufferedMs = CMTimeAdd(range.start, range.duration).milliseconds
        }
        send(
            "position",
            [
                "positionMs": positionMs,
                "durationMs": durationMs,
                "bufferedMs": max(bufferedMs, positionMs),
            ]
        )
        send("duration", ["durationMs": durationMs])
        send("buffered", ["bufferedMs": max(bufferedMs, positionMs)])
    }

    // MARK: - Events

    private func send(_ type: String, _ data: [String: Any] = [:]) {
        sendEvent(sessionId, type, data)
    }

    private func reportError(_ error: Error) {
        var isAudioError = false
        if let dashError = error as? DashHlsError {
            isAudioError = dashError.isAudioError
        }
        let nsError = error as NSError
        var logDetail = ""
        if let last = item?.errorLog()?.events.last {
            var uri = last.uri ?? "-"
            if uri.count > 120 { uri = String(uri.prefix(120)) + "…" }
            logDetail = " || log[\(last.errorStatusCode) \(last.errorComment ?? "")] \(uri)"
        }
        send(
            "error",
            [
                "message": error.localizedDescription + logDetail,
                "errorCode": nsError.code,
                "errorCodeName": "\(nsError.domain)(\(nsError.code))",
                "cause": (nsError.userInfo[NSUnderlyingErrorKey] as? NSError)?.description ?? "",
                "rendererName": "",
                "rendererFormat": "",
                "isAudioError": isAudioError,
            ]
        )
    }
}

extension CMTime {
    var milliseconds: Int64 {
        guard isNumeric, seconds.isFinite else { return 0 }
        return Int64(seconds * 1000)
    }
}
