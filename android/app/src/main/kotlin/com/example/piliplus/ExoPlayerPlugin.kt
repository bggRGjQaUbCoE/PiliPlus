@file:androidx.annotation.OptIn(
    markerClass = [androidx.media3.common.util.UnstableApi::class],
)

package com.example.piliplus

import android.content.Context
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Base64
import androidx.media3.common.C
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.VideoSize
import androidx.media3.common.text.CueGroup
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.exoplayer.source.MergingMediaSource
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import kotlin.math.roundToInt

/**
 * Small, app-local Media3 bridge used by the experimental Android player.
 *
 * The Flutter controls and danmaku remain Flutter widgets. Only decoding,
 * buffering and video rendering live here.
 */
internal object ExoPlayerPlugin {
    private const val METHOD_CHANNEL = "com.example.piliplus/exo_player"
    private const val EVENT_CHANNEL = "com.example.piliplus/exo_player_events"

    fun register(context: Context, engine: FlutterEngine) {
        val manager = ExoPlayerManager(context.applicationContext, engine.renderer)
        MethodChannel(engine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler(manager)
        EventChannel(engine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(manager)
    }
}

private class ExoPlayerManager(
    private val context: Context,
    private val textureRegistry: TextureRegistry,
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val sessions = mutableMapOf<Long, ExoPlayerSession>()
    private val handler = Handler(Looper.getMainLooper())
    private var events: EventChannel.EventSink? = null
    private var tickerRunning = false

    private val ticker = object : Runnable {
        override fun run() {
            sessions.values.forEach { it.emitProgress() }
            if (sessions.isNotEmpty()) {
                handler.postDelayed(this, 250L)
            } else {
                tickerRunning = false
            }
        }
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink) {
        events = eventSink
        sessions.values.forEach { it.emitState() }
    }

    override fun onCancel(arguments: Any?) {
        events = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "create" -> {
                    val id = call.requiredLong("id")
                    result.success(session(id).textureId)
                }
                "open" -> {
                    val player = session(call.requiredLong("id"))
                    val videoUrl = call.requiredString("videoUrl")
                    val audioUrl = call.argument<String>("audioUrl")
                    val headers = call.argument<Map<String, String>>("headers").orEmpty()
                    val positionMs = call.argument<Number>("positionMs")?.toLong() ?: 0L
                    val generation = call.requiredLong("generation")
                    val playWhenReady = call.argument<Boolean>("playWhenReady") ?: false
                    val preserveSubtitle = call.argument<Boolean>("preserveSubtitle") ?: false
                    player.open(
                        videoUrl,
                        audioUrl,
                        headers,
                        positionMs,
                        playWhenReady,
                        preserveSubtitle,
                        generation,
                    )
                    result.success(null)
                }
                "play" -> {
                    requiredSession(call).player.play()
                    result.success(null)
                }
                "pause" -> {
                    requiredSession(call).player.pause()
                    result.success(null)
                }
                "seekTo" -> {
                    requiredSession(call).player.seekTo(
                        call.argument<Number>("positionMs")?.toLong() ?: 0L,
                    )
                    result.success(null)
                }
                "setPlaybackSpeed" -> {
                    requiredSession(call).player.setPlaybackSpeed(
                        call.argument<Number>("speed")?.toFloat() ?: 1f,
                    )
                    result.success(null)
                }
                "setVolume" -> {
                    requiredSession(call).player.volume =
                        (call.argument<Number>("volume")?.toFloat() ?: 1f).coerceIn(0f, 1f)
                    result.success(null)
                }
                "setSubtitle" -> {
                    requiredSession(call).setSubtitle(
                        data = call.argument<String>("data"),
                        uri = call.argument<String>("uri"),
                        language = call.argument<String>("language"),
                        label = call.argument<String>("label"),
                    )
                    result.success(null)
                }
                "dispose" -> {
                    val id = call.requiredLong("id")
                    sessions.remove(id)?.dispose()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        } catch (error: Throwable) {
            result.error("exo_player", error.message, null)
        }
    }

    fun session(id: Long): ExoPlayerSession {
        val value = sessions.getOrPut(id) {
            ExoPlayerSession(
                context,
                id,
                textureRegistry.createSurfaceProducer(
                    TextureRegistry.SurfaceLifecycle.resetInBackground,
                ),
            ) { event ->
                handler.post { events?.success(event) }
            }
        }
        if (!tickerRunning) {
            tickerRunning = true
            handler.post(ticker)
        }
        return value
    }

    private fun requiredSession(call: MethodCall): ExoPlayerSession {
        val id = call.requiredLong("id")
        return sessions[id] ?: error("ExoPlayer session $id does not exist")
    }

    private fun MethodCall.requiredLong(name: String): Long =
        argument<Number>(name)?.toLong() ?: error("Missing $name")

    private fun MethodCall.requiredString(name: String): String =
        argument<String>(name) ?: error("Missing $name")
}

private class ExoPlayerSession(
    private val context: Context,
    private val id: Long,
    private val surfaceProducer: TextureRegistry.SurfaceProducer,
    private val sendEvent: (Map<String, Any?>) -> Unit,
) : Player.Listener {
    val player: ExoPlayer = ExoPlayer.Builder(context).build().also {
        it.addListener(this)
        it.playWhenReady = false
    }

    private var width = 0
    private var height = 0
    private var mediaRequest: MediaRequest? = null
    private var subtitleRequest: SubtitleRequest? = null
    private var subtitleText = ""
    private var mediaGeneration = 0L
    val textureId: Long
        get() = surfaceProducer.id()

    init {
        surfaceProducer.setSize(1280, 720)
        surfaceProducer.setCallback(
            object : TextureRegistry.SurfaceProducer.Callback {
                override fun onSurfaceAvailable() {
                    player.setVideoSurface(surfaceProducer.surface)
                }

                override fun onSurfaceCleanup() {
                    player.clearVideoSurface()
                }
            },
        )
        player.setVideoSurface(surfaceProducer.surface)
    }

    fun open(
        videoUrl: String,
        audioUrl: String?,
        headers: Map<String, String>,
        positionMs: Long,
        playWhenReady: Boolean,
        preserveSubtitle: Boolean,
        generation: Long,
    ) {
        mediaGeneration = generation
        mediaRequest = MediaRequest(videoUrl, audioUrl, headers)
        if (!preserveSubtitle) {
            subtitleRequest = null
        }
        updateSubtitleText("")
        prepareMedia(positionMs, playWhenReady)
    }

    fun setSubtitle(
        data: String?,
        uri: String?,
        language: String?,
        label: String?,
    ) {
        subtitleRequest = when {
            !data.isNullOrEmpty() -> SubtitleRequest(
                uri = Uri.parse(
                    "data:${MimeTypes.TEXT_VTT};base64," +
                        Base64.encodeToString(data.toByteArray(Charsets.UTF_8), Base64.NO_WRAP),
                ),
                language = language,
                label = label,
            )
            !uri.isNullOrEmpty() -> SubtitleRequest(
                uri = if (uri.contains("://")) {
                    Uri.parse(uri)
                } else {
                    Uri.fromFile(java.io.File(uri))
                },
                language = language,
                label = label,
            )
            else -> null
        }
        updateSubtitleText("")
        if (mediaRequest != null) {
            prepareMedia(player.currentPosition, player.playWhenReady)
        }
    }

    private fun prepareMedia(positionMs: Long, playWhenReady: Boolean) {
        val request = mediaRequest ?: return
        val httpFactory = DefaultHttpDataSource.Factory()
            .setAllowCrossProtocolRedirects(true)
            .setDefaultRequestProperties(request.headers)
        request.headers["User-Agent"]?.let(httpFactory::setUserAgent)
        val dataSourceFactory = DefaultDataSource.Factory(context, httpFactory)
        val mediaSourceFactory = DefaultMediaSourceFactory(dataSourceFactory)

        fun source(url: String, subtitle: SubtitleRequest? = null): MediaSource {
            val uri = if (url.contains("://")) Uri.parse(url) else Uri.fromFile(java.io.File(url))
            val item = MediaItem.Builder().setUri(uri).apply {
                if (subtitle != null) {
                    setSubtitleConfigurations(
                        listOf(
                            MediaItem.SubtitleConfiguration.Builder(subtitle.uri)
                                .setMimeType(MimeTypes.TEXT_VTT)
                                .setLanguage(subtitle.language)
                                .setLabel(subtitle.label)
                                .setSelectionFlags(C.SELECTION_FLAG_DEFAULT)
                                .build(),
                        ),
                    )
                }
            }.build()
            return mediaSourceFactory.createMediaSource(item)
        }

        val videoSource = source(request.videoUrl, subtitleRequest)
        val mediaSource = if (!request.audioUrl.isNullOrBlank() &&
            request.audioUrl != request.videoUrl
        ) {
            MergingMediaSource(
                true,
                true,
                videoSource,
                source(request.audioUrl),
            )
        } else {
            videoSource
        }

        player.apply {
            this.playWhenReady = playWhenReady
            setMediaSource(mediaSource, positionMs.coerceAtLeast(0L))
            prepare()
        }
        emitState()
    }

    override fun onEvents(player: Player, events: Player.Events) {
        emitState()
    }

    override fun onVideoSizeChanged(videoSize: VideoSize) {
        val textureWidth = videoSize.width.coerceAtLeast(1)
        val textureHeight = videoSize.height.coerceAtLeast(1)
        if (videoSize.unappliedRotationDegrees % 180 == 0) {
            width = (videoSize.width * videoSize.pixelWidthHeightRatio)
                .roundToInt()
                .coerceAtLeast(1)
            height = videoSize.height.coerceAtLeast(1)
        } else {
            width = videoSize.height.coerceAtLeast(1)
            height = (videoSize.width * videoSize.pixelWidthHeightRatio)
                .roundToInt()
                .coerceAtLeast(1)
        }
        if (surfaceProducer.width != textureWidth ||
            surfaceProducer.height != textureHeight
        ) {
            surfaceProducer.setSize(textureWidth, textureHeight)
        }
        emitState()
    }

    override fun onCues(cueGroup: CueGroup) {
        updateSubtitleText(
            cueGroup.cues
                .mapNotNull { it.text?.toString() }
                .filter { it.isNotBlank() }
                .joinToString("\n"),
        )
    }

    override fun onPlayerError(error: PlaybackException) {
        sendEvent(
            baseEvent("error") + mapOf(
                "message" to (error.message ?: error.errorCodeName),
                "errorCode" to error.errorCode,
            ),
        )
    }

    fun emitProgress() {
        sendEvent(
            baseEvent("progress") + mapOf(
                "positionMs" to player.currentPosition.coerceAtLeast(0L),
                "bufferedMs" to player.bufferedPosition.coerceAtLeast(0L),
                "durationMs" to duration(),
            ),
        )
    }

    fun emitState() {
        sendEvent(
            baseEvent("state") + mapOf(
                "playing" to player.isPlaying,
                "playWhenReady" to player.playWhenReady,
                "buffering" to (player.playbackState == Player.STATE_BUFFERING),
                "completed" to (player.playbackState == Player.STATE_ENDED),
                "positionMs" to player.currentPosition.coerceAtLeast(0L),
                "bufferedMs" to player.bufferedPosition.coerceAtLeast(0L),
                "durationMs" to duration(),
                "width" to width,
                "height" to height,
                "speed" to player.playbackParameters.speed.toDouble(),
            ),
        )
    }

    private fun duration(): Long =
        player.duration.takeUnless { it == C.TIME_UNSET }?.coerceAtLeast(0L) ?: 0L

    private fun baseEvent(type: String): Map<String, Any?> =
        mapOf(
            "id" to id,
            "generation" to mediaGeneration,
            "type" to type,
            "textureId" to textureId,
        )

    private fun updateSubtitleText(value: String) {
        if (subtitleText == value) return
        subtitleText = value
        sendEvent(baseEvent("subtitle") + mapOf("subtitle" to value))
    }

    fun dispose() {
        surfaceProducer.setCallback(null)
        player.clearVideoSurface()
        player.removeListener(this)
        player.release()
        surfaceProducer.release()
    }
}

private data class MediaRequest(
    val videoUrl: String,
    val audioUrl: String?,
    val headers: Map<String, String>,
)

private data class SubtitleRequest(
    val uri: Uri,
    val language: String?,
    val label: String?,
)
