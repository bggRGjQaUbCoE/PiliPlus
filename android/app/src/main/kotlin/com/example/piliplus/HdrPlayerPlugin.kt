package com.example.piliplus

import android.app.Activity
import android.content.Context
import android.content.pm.ActivityInfo
import android.graphics.Bitmap
import android.graphics.Rect
import android.hardware.display.DisplayManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.Display
import android.view.PixelCopy
import android.view.SurfaceView
import android.view.View
import androidx.annotation.OptIn
import androidx.media3.common.C
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.datasource.HttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.dash.DashMediaSource
import androidx.media3.exoplayer.source.MergingMediaSource
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.PlayerView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.util.concurrent.ConcurrentHashMap

class HdrPlayerPlugin private constructor(
    private val activity: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val methodChannel = MethodChannel(messenger, CHANNEL)
    private val eventChannel = EventChannel(messenger, EVENTS)
    private val mainHandler = Handler(Looper.getMainLooper())
    private val sessions = ConcurrentHashMap<Int, HdrPlayerSession>()
    private var sink: EventChannel.EventSink? = null
    private var nextSessionId = 1
    private var hdrModeRefCount = 0

    init {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "create" -> {
                    val id = nextSessionId++
                    sessions[id] = HdrPlayerSession(activity, id, ::sendEvent)
                    result.success(id)
                }

                "supportsHdr" -> {
                    val qualityCode = call.argument<Number>("qualityCode")?.toInt()
                    result.success(supportsHdr(activity, qualityCode))
                }
                "open" -> session(call)?.open(call, result)
                "play" -> {
                    session(call)?.play()
                    result.success(null)
                }
                "pause" -> {
                    session(call)?.pause()
                    result.success(null)
                }
                "seekTo" -> {
                    session(call)?.seekTo(call.argument<Number>("positionMs")?.toLong() ?: 0L)
                    result.success(null)
                }
                "setPlaybackSpeed" -> {
                    session(call)?.setPlaybackSpeed(call.argument<Number>("speed")?.toFloat() ?: 1f)
                    result.success(null)
                }
                "setFitMode" -> {
                    session(call)?.setFitMode(call.argument<String>("fitMode") ?: "contain")
                    result.success(null)
                }
                "setHdrMode" -> {
                    updateHdrMode(call.argument<Boolean>("enabled") == true)
                    result.success(null)
                }
                "screenshot" -> session(call)?.screenshot(result)
                "dispose" -> {
                    val sessionId = call.argument<Int>("sessionId")
                    if (sessionId != null) {
                        sessions.remove(sessionId)?.dispose()
                    }
                    if (sessions.isEmpty()) resetHdrMode()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        } catch (e: Throwable) {
            result.error("hdr_player_error", e.message, null)
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    private fun session(call: MethodCall): HdrPlayerSession? {
        val sessionId = call.argument<Int>("sessionId") ?: return null
        return sessions[sessionId]
    }

    private fun sendEvent(sessionId: Int, type: String, data: Map<String, Any?> = emptyMap()) {
        mainHandler.post {
            sink?.success(mapOf("sessionId" to sessionId, "type" to type) + data)
        }
    }

    private fun updateHdrMode(enabled: Boolean) {
        if (enabled) {
            hdrModeRefCount += 1
            if (hdrModeRefCount == 1) setHdrMode(true)
            return
        }
        hdrModeRefCount = (hdrModeRefCount - 1).coerceAtLeast(0)
        if (hdrModeRefCount == 0) setHdrMode(false)
    }

    private fun resetHdrMode() {
        hdrModeRefCount = 0
        setHdrMode(false)
    }

    private fun setHdrMode(enabled: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val params = activity.window.attributes
            params.colorMode = if (enabled) {
                ActivityInfo.COLOR_MODE_HDR
            } else {
                ActivityInfo.COLOR_MODE_DEFAULT
            }
            activity.window.attributes = params
        }
    }

    private fun supportsHdr(context: Context, qualityCode: Int?): Boolean {
        return try {
            val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                context.display
            } else {
                @Suppress("DEPRECATION")
                (context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager)
                    .getDisplay(Display.DEFAULT_DISPLAY)
            }
            val types = display?.hdrCapabilities?.supportedHdrTypes ?: intArrayOf()
            when (qualityCode) {
                125 -> types.contains(Display.HdrCapabilities.HDR_TYPE_HDR10)
                // Some devices do not advertise Dolby Vision but can still show a
                // Dolby Vision source through an HDR10-compatible output path.
                126 -> types.isNotEmpty()
                129 -> types.isNotEmpty()
                else -> types.isNotEmpty()
            }
        } catch (_: Throwable) {
            false
        }
    }

    companion object {
        const val CHANNEL = "PiliPlus/HdrPlayer"
        const val EVENTS = "PiliPlus/HdrPlayer/events"
        const val VIEW_TYPE = "com.example.piliplus/hdr_player_view"

        fun register(activity: Activity, flutterEngine: FlutterEngine) {
            val plugin = HdrPlayerPlugin(activity, flutterEngine.dartExecutor.binaryMessenger)
            flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory(VIEW_TYPE, HdrPlayerViewFactory(plugin))
        }
    }

    private class HdrPlayerViewFactory(
        private val plugin: HdrPlayerPlugin,
    ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            val sessionId = (args as? Map<*, *>)?.get("sessionId") as? Int
            val session = sessionId?.let { plugin.sessions[it] }
            return object : PlatformView {
                override fun getView(): View {
                    return session?.view ?: View(context)
                }

                override fun dispose() = Unit
            }
        }
    }
}

@OptIn(UnstableApi::class)
private class HdrPlayerSession(
    private val activity: Activity,
    private val sessionId: Int,
    private val sendEvent: (Int, String, Map<String, Any?>) -> Unit,
) : Player.Listener {
    val view = PlayerView(activity)
    private val player = ExoPlayer.Builder(activity).build()
    private val handler = Handler(Looper.getMainLooper())
    private var progressRunning = false

    init {
        view.useController = false
        view.player = player
        view.setShutterBackgroundColor(android.graphics.Color.BLACK)
        view.descendantFocusability = android.view.ViewGroup.FOCUS_BLOCK_DESCENDANTS
        player.addListener(this)
    }

    fun open(call: MethodCall, result: MethodChannel.Result) {
        val videoUrl = call.argument<String>("videoUrl")
        if (videoUrl.isNullOrEmpty()) {
            result.error("bad_args", "videoUrl is required", null)
            return
        }
        val audioUrl = call.argument<String>("audioUrl")
        val isFileSource = call.argument<Boolean>("isFileSource") == true
        val startMs = call.argument<Number>("startMs")?.toLong() ?: 0L
        val headers = call.argument<Map<String, String>>("headers") ?: emptyMap()
        setFitMode(call.argument<String>("fitMode") ?: "contain")
        player.setMediaSource(buildMediaSource(videoUrl, audioUrl, isFileSource, headers))
        player.prepare()
        if (startMs > 0L) {
            player.seekTo(startMs)
        }
        result.success(null)
    }

    fun play() {
        player.playWhenReady = true
    }

    fun pause() {
        player.pause()
    }

    fun seekTo(positionMs: Long) {
        player.seekTo(positionMs.coerceAtLeast(0L))
    }

    fun setPlaybackSpeed(speed: Float) {
        player.setPlaybackSpeed(speed.coerceAtLeast(0.1f))
    }

    fun setFitMode(fitMode: String) {
        view.resizeMode = when (fitMode) {
            "fill" -> AspectRatioFrameLayout.RESIZE_MODE_FILL
            "cover" -> AspectRatioFrameLayout.RESIZE_MODE_ZOOM
            "fitWidth" -> AspectRatioFrameLayout.RESIZE_MODE_FIXED_WIDTH
            "fitHeight" -> AspectRatioFrameLayout.RESIZE_MODE_FIXED_HEIGHT
            else -> AspectRatioFrameLayout.RESIZE_MODE_FIT
        }
    }

    fun screenshot(result: MethodChannel.Result) {
        val surfaceView = view.videoSurfaceView as? SurfaceView
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O ||
            surfaceView == null ||
            surfaceView.width <= 0 ||
            surfaceView.height <= 0
        ) {
            result.success(null)
            return
        }
        val bitmap = Bitmap.createBitmap(surfaceView.width, surfaceView.height, Bitmap.Config.ARGB_8888)
        try {
            PixelCopy.request(
                surfaceView,
                Rect(0, 0, surfaceView.width, surfaceView.height),
                bitmap,
                { copyResult ->
                    if (copyResult == PixelCopy.SUCCESS) {
                        val out = ByteArrayOutputStream()
                        bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
                        result.success(out.toByteArray())
                    } else {
                        result.success(null)
                    }
                },
                handler,
            )
        } catch (_: Throwable) {
            result.success(null)
        }
    }

    fun dispose() {
        stopProgress()
        player.removeListener(this)
        view.player = null
        player.release()
    }

    override fun onPlaybackStateChanged(playbackState: Int) {
        when (playbackState) {
            Player.STATE_READY -> {
                sendTimeline()
                sendEvent(sessionId, "ready", emptyMap())
                if (player.playWhenReady) startProgress()
            }
            Player.STATE_BUFFERING -> sendEvent(sessionId, "buffering", mapOf("value" to true))
            Player.STATE_ENDED -> {
                sendEvent(sessionId, "completed", emptyMap())
                stopProgress()
            }
            Player.STATE_IDLE -> Unit
        }
    }

    override fun onIsPlayingChanged(isPlaying: Boolean) {
        sendEvent(sessionId, if (isPlaying) "playing" else "paused", emptyMap())
        if (isPlaying) startProgress() else stopProgress()
    }

    override fun onPlayerError(error: PlaybackException) {
        sendEvent(
            sessionId,
            "error",
            mapOf(
                "message" to (error.message ?: error.toString()),
                "errorCode" to error.errorCode,
                "errorCodeName" to error.errorCodeName,
                "cause" to error.cause?.toString(),
            ),
        )
    }

    override fun onVideoSizeChanged(videoSize: androidx.media3.common.VideoSize) {
        sendEvent(
            sessionId,
            "size",
            mapOf("width" to videoSize.width, "height" to videoSize.height),
        )
    }

    private fun sendTimeline() {
        val duration = player.duration.takeIf { it != C.TIME_UNSET } ?: 0L
        val buffered = player.bufferedPosition.takeIf { it != C.TIME_UNSET } ?: 0L
        sendEvent(
            sessionId,
            "position",
            mapOf(
                "positionMs" to player.currentPosition,
                "durationMs" to duration,
                "bufferedMs" to buffered,
            ),
        )
        sendEvent(sessionId, "duration", mapOf("durationMs" to duration))
        sendEvent(sessionId, "buffered", mapOf("bufferedMs" to buffered))
    }

    private fun startProgress() {
        if (progressRunning) return
        progressRunning = true
        handler.post(progressTick)
    }

    private fun stopProgress() {
        progressRunning = false
        handler.removeCallbacks(progressTick)
    }

    private val progressTick = object : Runnable {
        override fun run() {
            if (!progressRunning) return
            sendTimeline()
            handler.postDelayed(this, 250L)
        }
    }

    private fun buildMediaSource(
        videoUrl: String,
        audioUrl: String?,
        isFileSource: Boolean,
        headers: Map<String, String>,
    ): MediaSource {
        val videoSource = buildSingleSource(videoUrl, isFileSource, headers)
        if (audioUrl.isNullOrEmpty()) {
            return videoSource
        }
        return MergingMediaSource(videoSource, buildSingleSource(audioUrl, isFileSource, headers))
    }

    private fun buildSingleSource(
        url: String,
        isFileSource: Boolean,
        headers: Map<String, String>,
    ): MediaSource {
        val item = MediaItem.fromUri(url)
        if (isFileSource) {
            val factory = DefaultDataSource.Factory(activity)
            return ProgressiveMediaSource.Factory(factory).createMediaSource(item)
        }

        val httpFactory: HttpDataSource.Factory = DefaultHttpDataSource.Factory()
            .setDefaultRequestProperties(headers)
            .setAllowCrossProtocolRedirects(true)
        val dataSourceFactory = DefaultDataSource.Factory(activity, httpFactory)
        if (url.contains(".mpd", ignoreCase = true)) {
            return DashMediaSource.Factory(dataSourceFactory).createMediaSource(item)
        }
        return ProgressiveMediaSource.Factory(dataSourceFactory).createMediaSource(item)
    }
}
