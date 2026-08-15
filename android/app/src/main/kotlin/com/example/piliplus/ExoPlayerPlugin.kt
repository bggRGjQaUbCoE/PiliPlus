@file:androidx.annotation.OptIn(
    markerClass = [androidx.media3.common.util.UnstableApi::class],
)

package com.example.piliplus

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.graphics.Typeface
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.text.Layout
import android.text.Spanned
import android.text.style.AbsoluteSizeSpan
import android.text.style.BackgroundColorSpan
import android.text.style.ForegroundColorSpan
import android.text.style.RelativeSizeSpan
import android.text.style.StrikethroughSpan
import android.text.style.StyleSpan
import android.text.style.TypefaceSpan
import android.text.style.UnderlineSpan
import android.util.Base64
import android.util.Log
import android.view.PixelCopy
import androidx.media3.common.C
import androidx.media3.common.Effect
import androidx.media3.common.Format
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.TrackSelectionOverride
import androidx.media3.common.VideoSize
import androidx.media3.common.text.Cue
import androidx.media3.common.text.CueGroup
import androidx.media3.common.text.HorizontalTextInVerticalContextSpan
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.datasource.HttpDataSource
import androidx.media3.exoplayer.DefaultLoadControl
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.DefaultRenderersFactory
import androidx.media3.exoplayer.ExoPlaybackException
import androidx.media3.exoplayer.analytics.AnalyticsListener
import androidx.media3.exoplayer.audio.AudioSink
import androidx.media3.exoplayer.audio.DefaultAudioSink
import androidx.media3.exoplayer.mediacodec.MediaCodecSelector
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import androidx.media3.exoplayer.source.MediaSource
import androidx.media3.exoplayer.source.MergingMediaSource
import androidx.media3.effect.LanczosResample
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.RandomAccessFile
import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicLong
import kotlin.math.ceil
import kotlin.math.max
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
                    result.success(
                        session(
                            id,
                            Media3PlaybackConfiguration(
                                enableHardwareDecoding =
                                    call.argument<Boolean>("enableHardwareDecoding") ?: true,
                                decoderMode = call.argument<String>("decoderMode") ?: "auto-safe",
                                targetBufferBytes =
                                    call.argument<Number>("targetBufferBytes")?.toLong()
                                        ?.coerceIn(MIN_TARGET_BUFFER_BYTES, Int.MAX_VALUE.toLong())
                                        ?.toInt()
                                        ?: DEFAULT_TARGET_BUFFER_BYTES,
                                bufferDurationMs =
                                    call.argument<Number>("bufferDurationMs")?.toLong()
                                        ?.coerceIn(MIN_BUFFER_DURATION_MS, Int.MAX_VALUE.toLong())
                                        ?.toInt()
                                        ?: DEFAULT_BUFFER_DURATION_MS,
                                isLive = call.argument<Boolean>("isLive") ?: false,
                            ),
                        ).textureId,
                    )
                }
                "open" -> {
                    val player = session(call.requiredLong("id"))
                    val videoUrl = call.requiredString("videoUrl")
                    val audioUrl = call.argument<String>("audioUrl")
                    val headers = call.argument<Map<String, String>>("headers").orEmpty()
                    val expectedWidth = call.argument<Number>("expectedWidth")?.toInt()
                    val expectedHeight = call.argument<Number>("expectedHeight")?.toInt()
                    val isLive = call.argument<Boolean>("isLive") ?: false
                    val positionMs = call.argument<Number>("positionMs")?.toLong() ?: 0L
                    val generation = call.requiredLong("generation")
                    val playWhenReady = call.argument<Boolean>("playWhenReady") ?: false
                    val preserveSubtitle = call.argument<Boolean>("preserveSubtitle") ?: false
                    val audioNormalization = AudioNormalizationConfiguration.fromMap(
                        call.argument<Map<*, *>>("audioNormalization"),
                    )
                    player.open(
                        videoUrl,
                        audioUrl,
                        headers,
                        expectedWidth,
                        expectedHeight,
                        isLive,
                        positionMs,
                        playWhenReady,
                        preserveSubtitle,
                        generation,
                        audioNormalization,
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
                "retry" -> {
                    val positionMs = call.argument<Number>("positionMs")?.toLong() ?: 0L
                    val playWhenReady = call.argument<Boolean>("playWhenReady") ?: false
                    val session = requiredSession(call)
                    if (call.argument<Boolean>("forceSoftwareVideo") == true) {
                        session.retryWithSoftwareVideo(positionMs, playWhenReady)
                    } else {
                        session.retry(positionMs, playWhenReady)
                    }
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
                "setSuperResolution" -> {
                    requiredSession(call).setSuperResolution(
                        Media3SuperResolutionMode.fromName(call.requiredString("mode")),
                    )
                    result.success(null)
                }
                "captureFrame" -> {
                    requiredSession(call).captureFrame(
                        flipX = call.argument<Boolean>("flipX") ?: false,
                        flipY = call.argument<Boolean>("flipY") ?: false,
                        onSuccess = result::success,
                        onError = { message -> result.error("capture_frame", message, null) },
                    )
                }
                "startAnimatedWebp" -> {
                    requiredSession(call).startAnimatedWebp(
                        taskId = call.requiredLong("taskId"),
                        url = call.requiredString("url"),
                        outFile = call.requiredString("outFile"),
                        headers = call.argument<Map<String, String>>("headers").orEmpty(),
                        startMs = call.argument<Number>("startMs")?.toLong() ?: 0L,
                        endMs = call.argument<Number>("endMs")?.toLong() ?: 0L,
                        preset = call.argument<String>("preset") ?: "default",
                        onComplete = { success, error ->
                            if (error == null) {
                                result.success(success)
                            } else {
                                result.error("animated_webp", error, null)
                            }
                        },
                    )
                }
                "animatedWebpProgress" -> {
                    result.success(
                        requiredSession(call).animatedWebpProgress(
                            call.requiredLong("taskId"),
                        ),
                    )
                }
                "cancelAnimatedWebp" -> {
                    requiredSession(call).cancelAnimatedWebp(call.requiredLong("taskId"))
                    result.success(null)
                }
                "setSubtitle" -> {
                    requiredSession(call).setSubtitle(
                        data = call.argument<String>("data"),
                        uri = call.argument<String>("uri"),
                        language = call.argument<String>("language"),
                        label = call.argument<String>("label"),
                        mimeType = call.argument<String>("mimeType"),
                    )
                    result.success(null)
                }
                "setTrackSelection" -> {
                    requiredSession(call).setTrackSelection(
                        type = call.requiredString("type"),
                        mode = call.requiredString("mode"),
                        groupIndex = call.argument<Number>("groupIndex")?.toInt(),
                        trackIndex = call.argument<Number>("trackIndex")?.toInt(),
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

    fun session(
        id: Long,
        configuration: Media3PlaybackConfiguration = Media3PlaybackConfiguration(),
    ): ExoPlayerSession {
        val value = sessions.getOrPut(id) {
            ExoPlayerSession(
                context,
                id,
                configuration,
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
    private val configuration: Media3PlaybackConfiguration,
    private val surfaceProducer: TextureRegistry.SurfaceProducer,
    private val sendEvent: (Map<String, Any?>) -> Unit,
) : Player.Listener, AnalyticsListener {
    private val audioNormalizationProcessor = AudioNormalizationProcessor()
    private var softwareVideoFallback = false
    var player: ExoPlayer = ExoPlayer.Builder(
        context,
        NormalizingRenderersFactory(
            context,
            audioNormalizationProcessor,
            configuration.effectiveHardwareDecoding,
        ),
    ).setLoadControl(configuration.createLoadControl()).build().also {
        it.addListener(this)
        it.addAnalyticsListener(this)
        it.playWhenReady = false
    }

    private var width = 0
    private var height = 0
    private var rotationDegrees = 0
    private var mediaRequest: MediaRequest? = null
    private var subtitleRequest: SubtitleRequest? = null
    private var subtitleCues: List<Map<String, Any?>> = emptyList()
    private var videoDecoder: String? = null
    private var audioDecoder: String? = null
    private var firstVideoFrameRendered = false
    private var superResolutionMode = Media3SuperResolutionMode.DISABLE
    private var sourceVideoWidth = 0
    private var sourceVideoHeight = 0
    private var appliedSuperResolutionTarget: Media3SuperResolutionTarget? = null
    private var superResolutionDescription = "disabled"
    private var mediaGeneration = 0L
    private val mainHandler = Handler(Looper.getMainLooper())
    private val captureExecutor = Executors.newSingleThreadExecutor()
    private val subtitleCueSequence = AtomicLong()
    private val subtitleEncoder = ThreadPoolExecutor(
        1,
        1,
        0L,
        TimeUnit.MILLISECONDS,
        ArrayBlockingQueue(1),
        ThreadPoolExecutor.DiscardOldestPolicy(),
    )
    private val animatedWebpTasks = ConcurrentHashMap<Long, AnimatedWebpCapture>()
    private val disposed = AtomicBoolean(false)
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
        expectedWidth: Int?,
        expectedHeight: Int?,
        isLive: Boolean,
        positionMs: Long,
        playWhenReady: Boolean,
        preserveSubtitle: Boolean,
        generation: Long,
        audioNormalization: AudioNormalizationConfiguration?,
    ) {
        audioNormalizationProcessor.setConfiguration(audioNormalization)
        mediaGeneration = generation
        mediaRequest = MediaRequest(
            videoUrl,
            audioUrl,
            headers,
            isLive,
            audioNormalization,
        )
        videoDecoder = null
        audioDecoder = null
        firstVideoFrameRendered = false
        resetSuperResolutionForNewMedia()
        resetVideoSizeForNewMedia(expectedWidth, expectedHeight)
        if (!preserveSubtitle) {
            subtitleRequest = null
        }
        subtitleCueSequence.incrementAndGet()
        updateSubtitleCues(emptyList())
        prepareMedia(positionMs, playWhenReady)
    }

    private fun resetVideoSizeForNewMedia(expectedWidth: Int?, expectedHeight: Int?) {
        val nextWidth = expectedWidth?.takeIf { it > 0 } ?: 0
        val nextHeight = expectedHeight?.takeIf { it > 0 } ?: 0
        width = nextWidth
        height = nextHeight
        rotationDegrees = 0
        if (nextWidth > 0 && nextHeight > 0) {
            sourceVideoWidth = nextWidth
            sourceVideoHeight = nextHeight
            if (surfaceProducer.width != nextWidth || surfaceProducer.height != nextHeight) {
                surfaceProducer.setSize(nextWidth, nextHeight)
            }
            applySuperResolutionEffect()
        }
    }

    fun setSuperResolution(mode: Media3SuperResolutionMode) {
        if (superResolutionMode == mode) {
            applySuperResolutionEffect()
            emitState()
            return
        }
        superResolutionMode = mode
        applySuperResolutionEffect()
        emitState()
    }

    private fun resetSuperResolutionForNewMedia() {
        val hadActiveEffect = appliedSuperResolutionTarget != null
        sourceVideoWidth = 0
        sourceVideoHeight = 0
        appliedSuperResolutionTarget = null
        if (hadActiveEffect) {
            player.setVideoEffects(emptyList())
        }
        superResolutionDescription = when (superResolutionMode) {
            Media3SuperResolutionMode.DISABLE -> "disabled"
            else -> "${superResolutionMode.name.lowercase()} lanczos (waiting for video size)"
        }
    }

    private fun applySuperResolutionEffect() {
        if (superResolutionMode == Media3SuperResolutionMode.DISABLE) {
            if (appliedSuperResolutionTarget != null) {
                player.setVideoEffects(emptyList())
            }
            appliedSuperResolutionTarget = null
            superResolutionDescription = "disabled"
            return
        }
        if (sourceVideoWidth <= 0 || sourceVideoHeight <= 0) {
            superResolutionDescription =
                "${superResolutionMode.name.lowercase()} lanczos (waiting for video size)"
            return
        }
        val target = resolveMedia3SuperResolutionTarget(
            superResolutionMode,
            sourceVideoWidth,
            sourceVideoHeight,
        )
        if (target == null) {
            if (appliedSuperResolutionTarget != null) {
                player.setVideoEffects(emptyList())
            }
            appliedSuperResolutionTarget = null
            superResolutionDescription =
                "${superResolutionMode.name.lowercase()} lanczos " +
                "(${sourceVideoWidth}x$sourceVideoHeight, no upscale needed)"
            return
        }
        if (target != appliedSuperResolutionTarget) {
            val effects: List<Effect> = listOf(
                LanczosResample.scaleToFit(target.width, target.height),
            )
            player.setVideoEffects(effects)
            appliedSuperResolutionTarget = target
        }
        superResolutionDescription =
            "${superResolutionMode.name.lowercase()} lanczos " +
            "${sourceVideoWidth}x$sourceVideoHeight -> ${target.width}x${target.height}"
    }

    fun setSubtitle(
        data: String?,
        uri: String?,
        language: String?,
        label: String?,
        mimeType: String?,
    ) {
        val resolvedMimeType = resolveSubtitleMimeType(mimeType, uri)
        subtitleRequest = when {
            !data.isNullOrEmpty() -> SubtitleRequest(
                uri = Uri.parse(
                    "data:$resolvedMimeType;base64," +
                        Base64.encodeToString(data.toByteArray(Charsets.UTF_8), Base64.NO_WRAP),
                ),
                language = language,
                label = label,
                mimeType = resolvedMimeType,
            )
            !uri.isNullOrEmpty() -> SubtitleRequest(
                uri = resolveMediaUri(uri),
                language = language,
                label = label,
                mimeType = resolvedMimeType,
            )
            else -> null
        }
        player.trackSelectionParameters = player.trackSelectionParameters.buildUpon()
            .clearOverridesOfType(C.TRACK_TYPE_TEXT)
            .setTrackTypeDisabled(C.TRACK_TYPE_TEXT, subtitleRequest == null)
            .build()
        subtitleCueSequence.incrementAndGet()
        updateSubtitleCues(emptyList())
        if (mediaRequest != null) {
            prepareMedia(player.currentPosition, player.playWhenReady)
        }
    }

    fun setTrackSelection(
        type: String,
        mode: String,
        groupIndex: Int?,
        trackIndex: Int?,
    ) {
        val trackType = when (type) {
            "video" -> C.TRACK_TYPE_VIDEO
            "audio" -> C.TRACK_TYPE_AUDIO
            "subtitle" -> C.TRACK_TYPE_TEXT
            else -> error("Unsupported track type: $type")
        }
        val builder = player.trackSelectionParameters.buildUpon()
            .clearOverridesOfType(trackType)
        when (mode) {
            "auto" -> builder.setTrackTypeDisabled(trackType, false)
            "disabled" -> builder.setTrackTypeDisabled(trackType, true)
            "track" -> {
                val actualGroupIndex = groupIndex ?: error("Missing groupIndex")
                val group = player.currentTracks.groups.getOrNull(actualGroupIndex)
                    ?: error("Track group $actualGroupIndex does not exist")
                val actualTrackIndex = trackIndex ?: error("Missing trackIndex")
                require(group.type == trackType) {
                    "Track group $actualGroupIndex has type ${group.type}, expected $trackType"
                }
                require(actualTrackIndex in 0 until group.length) {
                    "Track index $actualTrackIndex does not exist in group $actualGroupIndex"
                }
                require(group.isTrackSupported(actualTrackIndex)) {
                    "Track $actualGroupIndex:$actualTrackIndex is not supported"
                }
                builder
                    .setTrackTypeDisabled(trackType, false)
                    .setOverrideForType(
                        TrackSelectionOverride(group.mediaTrackGroup, actualTrackIndex),
                    )
            }
            else -> error("Unsupported track selection mode: $mode")
        }
        player.trackSelectionParameters = builder.build()
        emitState()
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
            val uri = resolveMediaUri(url)
            val item = MediaItem.Builder().setUri(uri).apply {
                if (request.isLive) {
                    setLiveConfiguration(MediaItem.LiveConfiguration.Builder().build())
                }
                if (subtitle != null) {
                    setSubtitleConfigurations(
                        listOf(
                            MediaItem.SubtitleConfiguration.Builder(subtitle.uri)
                                .setId(APP_SUBTITLE_TRACK_ID)
                                .setMimeType(subtitle.mimeType)
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
            if (request.isLive) {
                setMediaSource(mediaSource)
            } else {
                setMediaSource(mediaSource, positionMs.coerceAtLeast(0L))
            }
            prepare()
        }
        emitState()
    }

    override fun onEvents(player: Player, events: Player.Events) {
        emitState()
    }

    override fun onVideoSizeChanged(videoSize: VideoSize) {
        val sourceFormat = player.videoFormat
        val nextSourceWidth = sourceFormat?.width?.takeIf { it > 0 }
            ?: sourceVideoWidth.takeIf { it > 0 }
            ?: videoSize.width
        val nextSourceHeight = sourceFormat?.height?.takeIf { it > 0 }
            ?: sourceVideoHeight.takeIf { it > 0 }
            ?: videoSize.height
        if (sourceVideoWidth != nextSourceWidth || sourceVideoHeight != nextSourceHeight) {
            sourceVideoWidth = nextSourceWidth
            sourceVideoHeight = nextSourceHeight
            applySuperResolutionEffect()
        }
        val textureWidth = videoSize.width.coerceAtLeast(1)
        val textureHeight = videoSize.height.coerceAtLeast(1)
        rotationDegrees = videoSize.unappliedRotationDegrees
        if (rotationDegrees % 180 == 0) {
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
        val cues = cueGroup.cues.toList()
        val sequence = subtitleCueSequence.incrementAndGet()
        val generation = mediaGeneration
        if (cues.none { it.bitmap != null }) {
            updateSubtitleCues(serializeSubtitleCues(cues, generation))
            return
        }
        subtitleEncoder.execute {
            if (disposed.get() || sequence != subtitleCueSequence.get()) {
                return@execute
            }
            val serializedCues = serializeSubtitleCues(cues, generation)
            mainHandler.post {
                if (!disposed.get() &&
                    sequence == subtitleCueSequence.get() &&
                    generation == mediaGeneration
                ) {
                    updateSubtitleCues(serializedCues)
                }
            }
        }
    }

    override fun onPlayerError(error: PlaybackException) {
        sendEvent(
            baseEvent("error") + mapOf(
                "error" to serializePlaybackError(
                    error = error,
                    positionMs = player.currentPosition.coerceAtLeast(0L),
                    playWhenReady = player.playWhenReady,
                    videoDecoder = videoDecoder,
                    audioDecoder = audioDecoder,
                    mediaDescription = mediaRequest?.diagnosticDescription,
                ),
            ),
        )
    }

    fun retry(positionMs: Long, playWhenReady: Boolean) {
        player.apply {
            this.playWhenReady = playWhenReady
            if (mediaRequest?.isLive == true) {
                seekToDefaultPosition()
            } else {
                seekTo(positionMs.coerceAtLeast(0L))
            }
            prepare()
        }
        emitState()
    }

    fun retryWithSoftwareVideo(positionMs: Long, playWhenReady: Boolean) {
        if (softwareVideoFallback || !configuration.effectiveHardwareDecoding) {
            retry(positionMs, playWhenReady)
            return
        }
        softwareVideoFallback = true
        rebuildPlayerWithSoftwareVideo(positionMs, playWhenReady)
    }

    private fun rebuildPlayerWithSoftwareVideo(positionMs: Long, playWhenReady: Boolean) {
        val position = if (mediaRequest?.isLive == true) {
            0L
        } else {
            positionMs.coerceAtLeast(0L)
        }
        val previousPlayer = player
        previousPlayer.removeListener(this)
        previousPlayer.release()
        player = ExoPlayer.Builder(
            context,
            NormalizingRenderersFactory(
                context,
                audioNormalizationProcessor,
                enableHardwareDecoding = false,
            ),
        ).setLoadControl(configuration.createLoadControl()).build().also {
            it.addListener(this)
            it.addAnalyticsListener(this)
            it.playWhenReady = false
            it.setVideoSurface(surfaceProducer.surface)
        }
        player.trackSelectionParameters = player.trackSelectionParameters.buildUpon()
            .clearOverridesOfType(C.TRACK_TYPE_TEXT)
            .setTrackTypeDisabled(C.TRACK_TYPE_TEXT, subtitleRequest == null)
            .build()
        videoDecoder = null
        audioDecoder = null
        firstVideoFrameRendered = false
        sourceVideoWidth = 0
        sourceVideoHeight = 0
        appliedSuperResolutionTarget = null
        superResolutionDescription = "disabled"
        if (superResolutionMode != Media3SuperResolutionMode.DISABLE) {
            applySuperResolutionEffect()
        }
        subtitleCueSequence.incrementAndGet()
        updateSubtitleCues(emptyList())
        prepareMedia(position, playWhenReady)
    }

    override fun onRenderedFirstFrame() {
        firstVideoFrameRendered = true
        emitState()
    }

    fun captureFrame(
        flipX: Boolean,
        flipY: Boolean,
        onSuccess: (ByteArray) -> Unit,
        onError: (String) -> Unit,
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            onError("Frame capture requires Android 7.0 or newer")
            return
        }
        if (disposed.get()) {
            onError("ExoPlayer session is already disposed")
            return
        }
        val request = mediaRequest
        val positionMs = player.currentPosition.coerceAtLeast(0L)
        val durationMs = duration()
        requestPixelCopy(
            attempt = 0,
            request = request,
            positionMs = positionMs,
            durationMs = durationMs,
            flipX = flipX,
            flipY = flipY,
            onSuccess = onSuccess,
            onError = onError,
        )
    }

    private fun requestPixelCopy(
        attempt: Int,
        request: MediaRequest?,
        positionMs: Long,
        durationMs: Long,
        flipX: Boolean,
        flipY: Boolean,
        onSuccess: (ByteArray) -> Unit,
        onError: (String) -> Unit,
    ) {
        if (disposed.get()) {
            onError("ExoPlayer session was disposed during frame capture")
            return
        }
        val source = surfaceProducer.surface
        val sourceWidth = surfaceProducer.width
        val sourceHeight = surfaceProducer.height
        if (!source.isValid || sourceWidth <= 0 || sourceHeight <= 0) {
            if (request != null) {
                captureFrameFromMediaSource(
                    request = request,
                    positionMs = positionMs,
                    durationMs = durationMs,
                    flipX = flipX,
                    flipY = flipY,
                    pixelCopyFailure = "Video surface is not available",
                    onSuccess = onSuccess,
                    onError = onError,
                )
            } else {
                onError("Video surface is not available")
            }
            return
        }
        val bitmap = Bitmap.createBitmap(
            sourceWidth,
            sourceHeight,
            Bitmap.Config.ARGB_8888,
        )
        PixelCopy.request(
            source,
            bitmap,
            { copyResult ->
                if (disposed.get()) {
                    bitmap.recycle()
                    onError("ExoPlayer session was disposed during frame capture")
                    return@request
                }
                if (copyResult != PixelCopy.SUCCESS) {
                    bitmap.recycle()
                    if (copyResult == PixelCopy.ERROR_SOURCE_NO_DATA &&
                        attempt < CAPTURE_PIXEL_COPY_RETRIES
                    ) {
                        mainHandler.postDelayed(
                            {
                                requestPixelCopy(
                                    attempt = attempt + 1,
                                    request = request,
                                    positionMs = positionMs,
                                    durationMs = durationMs,
                                    flipX = flipX,
                                    flipY = flipY,
                                    onSuccess = onSuccess,
                                    onError = onError,
                                )
                            },
                            CAPTURE_PIXEL_COPY_RETRY_DELAY_MS,
                        )
                        return@request
                    }
                    if (copyResult == PixelCopy.ERROR_SOURCE_NO_DATA && request != null) {
                        captureFrameFromMediaSource(
                            request = request,
                            positionMs = positionMs,
                            durationMs = durationMs,
                            flipX = flipX,
                            flipY = flipY,
                            pixelCopyFailure = "PixelCopy failed with code $copyResult",
                            onSuccess = onSuccess,
                            onError = onError,
                        )
                        return@request
                    }
                    onError("PixelCopy failed with code $copyResult")
                    return@request
                }
                runCatching {
                    captureExecutor.execute {
                        runCatching {
                            transformCapturedFrame(bitmap, width, height, rotationDegrees, flipX, flipY)
                        }.onSuccess { bytes ->
                            mainHandler.post {
                                if (disposed.get()) {
                                    onError("ExoPlayer session was disposed during frame capture")
                                } else {
                                    onSuccess(bytes)
                                }
                            }
                        }.onFailure { error ->
                            mainHandler.post {
                                onError(error.message ?: "Failed to encode captured frame")
                            }
                        }
                    }
                }.onFailure { error ->
                    bitmap.recycle()
                    onError(error.message ?: "Frame capture worker is not available")
                }
            },
            mainHandler,
        )
    }

    private fun captureFrameFromMediaSource(
        request: MediaRequest,
        positionMs: Long,
        durationMs: Long,
        flipX: Boolean,
        flipY: Boolean,
        pixelCopyFailure: String,
        onSuccess: (ByteArray) -> Unit,
        onError: (String) -> Unit,
    ) {
        val displayWidth = width
        val displayHeight = height
        runCatching {
            captureExecutor.execute {
                val outcome = runCatching {
                    val retriever = MediaMetadataRetriever()
                    try {
                        retriever.setCaptureDataSource(request.videoUrl, request.headers)
                        val sourceRotation = retriever
                            .extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)
                            ?.toIntOrNull() ?: 0
                        val capturePositionMs = if (durationMs > 0L) {
                            positionMs.coerceAtMost(durationMs - 1L)
                        } else {
                            positionMs
                        }
                        val bitmap = retriever.getFrameAtTime(
                            capturePositionMs * 1000L,
                            MediaMetadataRetriever.OPTION_CLOSEST,
                        ) ?: error("No video frame at ${capturePositionMs}ms")
                        transformCapturedFrame(
                            bitmap,
                            displayWidth,
                            displayHeight,
                            sourceRotation,
                            flipX,
                            flipY,
                        )
                    } finally {
                        retriever.release()
                    }
                }
                mainHandler.post {
                    outcome.onSuccess { bytes ->
                        if (disposed.get()) {
                            onError("ExoPlayer session was disposed during frame capture")
                        } else {
                            onSuccess(bytes)
                        }
                    }.onFailure { error ->
                        onError(
                            "$pixelCopyFailure; media-source capture failed: " +
                                sanitizeDiagnosticMessage(
                                    error.message ?: error.javaClass.simpleName,
                                ),
                        )
                    }
                }
            }
        }.onFailure { error ->
            onError(error.message ?: "Frame capture worker is not available")
        }
    }

    fun startAnimatedWebp(
        taskId: Long,
        url: String,
        outFile: String,
        headers: Map<String, String>,
        startMs: Long,
        endMs: Long,
        preset: String,
        onComplete: (Boolean, String?) -> Unit,
    ) {
        require(endMs > startMs) { "Animated capture end must be after start" }
        check(!disposed.get()) { "ExoPlayer session is already disposed" }
        cancelAnimatedWebp(taskId)
        val task = AnimatedWebpCapture(
            url = url,
            outFile = outFile,
            headers = headers,
            startMs = startMs,
            endMs = endMs,
            preset = preset,
        )
        animatedWebpTasks[taskId] = task
        task.start { success, error ->
            animatedWebpTasks.remove(taskId, task)
            Handler(Looper.getMainLooper()).post { onComplete(success, error) }
        }
    }

    fun animatedWebpProgress(taskId: Long): Double =
        animatedWebpTasks[taskId]?.progress ?: 1.0

    fun cancelAnimatedWebp(taskId: Long) {
        animatedWebpTasks.remove(taskId)?.cancel()
    }

    override fun onVideoDecoderInitialized(
        eventTime: AnalyticsListener.EventTime,
        decoderName: String,
        initializationDurationMs: Long,
    ) {
        videoDecoder = decoderName
        emitState()
    }

    override fun onAudioDecoderInitialized(
        eventTime: AnalyticsListener.EventTime,
        decoderName: String,
        initializationDurationMs: Long,
    ) {
        audioDecoder = decoderName
        emitState()
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
                "ready" to (player.playbackState == Player.STATE_READY),
                "completed" to (
                    mediaRequest?.isLive != true && player.playbackState == Player.STATE_ENDED
                ),
                "positionMs" to player.currentPosition.coerceAtLeast(0L),
                "bufferedMs" to player.bufferedPosition.coerceAtLeast(0L),
                "durationMs" to duration(),
                "width" to width,
                "height" to height,
                "speed" to player.playbackParameters.speed.toDouble(),
                "volume" to player.volume.toDouble(),
                "tracks" to serializeTracks(player),
                "videoDecoder" to videoDecoder,
                "audioDecoder" to audioDecoder,
                "firstVideoFrameRendered" to firstVideoFrameRendered,
                "mediaDescription" to mediaRequest?.description,
                "playbackConfiguration" to configuration.description(softwareVideoFallback),
                "audioNormalization" to mediaRequest?.audioNormalization?.filter,
                "superResolution" to superResolutionDescription,
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

    private fun updateSubtitleCues(value: List<Map<String, Any?>>) {
        if (subtitleCues.contentEquals(value)) return
        subtitleCues = value
        sendEvent(
            baseEvent("subtitle") + mapOf(
                "subtitle" to value.joinToString("\n") { it["text"].toString() },
                "subtitleCues" to value,
            ),
        )
    }

    private fun serializeSubtitleCues(
        cues: List<Cue>,
        generation: Long,
    ): List<Map<String, Any?>> = cues.mapNotNull { cue ->
        runCatching { serializeCue(cue) }
            .onFailure { error ->
                Log.w(
                    EXO_PLAYER_TAG,
                    "Failed to serialize subtitle cue for session=$id generation=$generation",
                    error,
                )
            }
            .getOrNull()
    }

    fun dispose() {
        if (!disposed.compareAndSet(false, true)) return
        subtitleCueSequence.incrementAndGet()
        subtitleEncoder.shutdownNow()
        animatedWebpTasks.values.forEach(AnimatedWebpCapture::cancel)
        animatedWebpTasks.clear()
        surfaceProducer.setCallback(null)
        player.clearVideoSurface()
        player.removeListener(this)
        player.removeAnalyticsListener(this)
        player.release()
        surfaceProducer.release()
        captureExecutor.shutdownNow()
    }
}

private class AnimatedWebpCapture(
    private val url: String,
    private val outFile: String,
    private val headers: Map<String, String>,
    private val startMs: Long,
    private val endMs: Long,
    private val preset: String,
) {
    private val cancelled = AtomicBoolean(false)
    private val finished = AtomicBoolean(false)
    private val executor = Executors.newSingleThreadExecutor()
    private var onComplete: ((Boolean, String?) -> Unit)? = null

    @Volatile
    var progress: Double = 0.0
        private set

    fun start(onComplete: (Boolean, String?) -> Unit) {
        this.onComplete = onComplete
        executor.execute {
            val outcome = runCatching(::convert)
            val success = outcome.getOrDefault(false)
            progress = if (success) 1.0 else progress
            finish(
                success,
                outcome.exceptionOrNull()?.message?.let(::sanitizeDiagnosticMessage),
            )
            executor.shutdown()
        }
    }

    fun cancel() {
        synchronized(animatedWebpPublishLock) {
            cancelled.set(true)
            finish(false, null)
        }
        executor.shutdownNow()
    }

    private fun finish(success: Boolean, error: String?) {
        if (finished.compareAndSet(false, true)) onComplete?.invoke(success, error)
    }

    private fun convert(): Boolean {
        val output = File(outFile)
        output.parentFile?.mkdirs()
        val workingOutput = File(
            output.parentFile,
            "${output.name}.part-${System.nanoTime()}",
        )
        val retriever = MediaMetadataRetriever()
        var file: RandomAccessFile? = null
        var completed = false
        return try {
            if (url.contains("://")) {
                retriever.setDataSource(url, headers)
            } else {
                retriever.setDataSource(url)
            }
            val videoRotation = retriever
                .extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)
                ?.toIntOrNull() ?: 0
            val durationMs = endMs - startMs
            val frameIntervalMs = max(
                1000L / ANIMATED_WEBP_FPS,
                ceil(durationMs.toDouble() / MAX_ANIMATED_WEBP_FRAMES).toLong(),
            )
            val frameCount = ((durationMs + frameIntervalMs - 1) / frameIntervalMs)
                .coerceAtLeast(1L)
                .toInt()
            file = RandomAccessFile(workingOutput, "rw").apply { setLength(0) }
            var canvasWidth = 0
            var canvasHeight = 0
            repeat(frameCount) { index ->
                if (cancelled.get()) return false
                val timestampMs = (startMs + index * frameIntervalMs).coerceAtMost(endMs - 1)
                val source = retriever.getFrameAtTime(
                    timestampMs * 1000,
                    MediaMetadataRetriever.OPTION_CLOSEST,
                ) ?: error("No video frame at ${timestampMs}ms")
                val frame = rotateBitmap(source, videoRotation)
                try {
                    if (index == 0) {
                        canvasWidth = frame.width
                        canvasHeight = frame.height
                        require(canvasWidth in 1..MAX_WEBP_DIMENSION &&
                            canvasHeight in 1..MAX_WEBP_DIMENSION
                        ) { "Animated WebP canvas is too large" }
                        AnimatedWebpMuxer.initialize(file, canvasWidth, canvasHeight)
                    }
                    val normalized = if (frame.width == canvasWidth && frame.height == canvasHeight) {
                        frame
                    } else {
                        Bitmap.createScaledBitmap(frame, canvasWidth, canvasHeight, true)
                    }
                    try {
                        val chunks = encodeWebpImageChunks(normalized, webpQuality(preset))
                        val remaining = endMs - timestampMs
                        val frameDurationMs = remaining.coerceAtMost(frameIntervalMs).coerceAtLeast(1L)
                        AnimatedWebpMuxer.writeFrame(
                            file,
                            canvasWidth,
                            canvasHeight,
                            frameDurationMs.toInt(),
                            chunks,
                        )
                    } finally {
                        if (normalized !== frame) normalized.recycle()
                    }
                } finally {
                    frame.recycle()
                }
                progress = (index + 1).toDouble() / frameCount
            }
            if (cancelled.get()) return false
            AnimatedWebpMuxer.finalize(file)
            file.close()
            file = null
            synchronized(animatedWebpPublishLock) {
                if (cancelled.get()) return false
                if (output.exists() && !output.delete()) {
                    error("Unable to replace existing animated WebP output")
                }
                if (!workingOutput.renameTo(output)) {
                    workingOutput.copyTo(output, overwrite = true)
                    check(workingOutput.delete()) {
                        "Unable to remove animated WebP temporary file"
                    }
                }
            }
            completed = true
            true
        } catch (_: InterruptedException) {
            false
        } finally {
            retriever.release()
            file?.close()
            if (!completed) workingOutput.delete()
        }
    }
}

private const val ANIMATED_WEBP_FPS = 12L
private const val MAX_ANIMATED_WEBP_FRAMES = 600
private const val CAPTURE_PIXEL_COPY_RETRIES = 2
private const val CAPTURE_PIXEL_COPY_RETRY_DELAY_MS = 80L
private val animatedWebpPublishLock = Any()

private fun MediaMetadataRetriever.setCaptureDataSource(
    url: String,
    headers: Map<String, String>,
) {
    if (url.contains("://")) {
        setDataSource(url, headers)
    } else {
        setDataSource(url)
    }
}

private fun rotateBitmap(source: Bitmap, rotationDegrees: Int): Bitmap {
    if (rotationDegrees % 360 == 0) return source
    return Bitmap.createBitmap(
        source,
        0,
        0,
        source.width,
        source.height,
        Matrix().apply { postRotate(rotationDegrees.toFloat()) },
        true,
    ).also { if (it !== source) source.recycle() }
}

private fun webpQuality(preset: String): Int = when (preset) {
    "photo" -> 78
    "picture" -> 82
    "drawing" -> 88
    "icon" -> 90
    "text" -> 92
    else -> 80
}

@Suppress("DEPRECATION")
private fun encodeWebpImageChunks(bitmap: Bitmap, quality: Int): ByteArray {
    val encoded = ByteArrayOutputStream().use { output ->
        check(bitmap.compress(Bitmap.CompressFormat.WEBP, quality, output)) {
            "WebP encoder rejected animation frame"
        }
        output.toByteArray()
    }
    require(encoded.size >= 20 && encoded.fourCc(0) == "RIFF" && encoded.fourCc(8) == "WEBP") {
        "Android returned an invalid WebP frame"
    }
    val chunks = ByteArrayOutputStream()
    var offset = 12
    while (offset + 8 <= encoded.size) {
        val type = encoded.fourCc(offset)
        val size = encoded.uint32Le(offset + 4).toInt()
        val paddedSize = size + (size and 1)
        require(size >= 0 && offset + 8 + paddedSize <= encoded.size) {
            "Invalid WebP chunk $type"
        }
        if (type == "ALPH" || type == "VP8 " || type == "VP8L") {
            chunks.write(encoded, offset, 8 + paddedSize)
        }
        offset += 8 + paddedSize
    }
    return chunks.toByteArray().also {
        require(it.isNotEmpty()) { "WebP frame contains no image data" }
    }
}

private fun ByteArray.fourCc(offset: Int): String =
    String(this, offset, 4, Charsets.US_ASCII)

private fun ByteArray.uint32Le(offset: Int): Long =
    (0 until 4).fold(0L) { value, shift ->
        value or ((this[offset + shift].toLong() and 0xFF) shl (shift * 8))
    }

private fun transformCapturedFrame(
    source: Bitmap,
    displayWidth: Int,
    displayHeight: Int,
    rotationDegrees: Int,
    flipX: Boolean,
    flipY: Boolean,
): ByteArray {
    var bitmap = source
    try {
        if (rotationDegrees % 360 != 0) {
            bitmap = Bitmap.createBitmap(
                bitmap,
                0,
                0,
                bitmap.width,
                bitmap.height,
                Matrix().apply { postRotate(rotationDegrees.toFloat()) },
                true,
            ).also { if (it !== source) source.recycle() }
        }
        if (displayWidth > 0 && displayHeight > 0 &&
            (bitmap.width != displayWidth || bitmap.height != displayHeight)
        ) {
            val previous = bitmap
            bitmap = Bitmap.createScaledBitmap(bitmap, displayWidth, displayHeight, true)
            if (bitmap !== previous) previous.recycle()
        }
        if (flipX || flipY) {
            val previous = bitmap
            bitmap = Bitmap.createBitmap(
                bitmap,
                0,
                0,
                bitmap.width,
                bitmap.height,
                Matrix().apply {
                    postScale(if (flipX) -1f else 1f, if (flipY) -1f else 1f)
                },
                true,
            )
            if (bitmap !== previous) previous.recycle()
        }
        return ByteArrayOutputStream().use { output ->
            check(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)) {
                "PNG encoder rejected captured frame"
            }
            output.toByteArray()
        }
    } finally {
        if (!bitmap.isRecycled) bitmap.recycle()
    }
}

private data class MediaRequest(
    val videoUrl: String,
    val audioUrl: String?,
    val headers: Map<String, String>,
    val isLive: Boolean,
    val audioNormalization: AudioNormalizationConfiguration?,
) {
    val description: String
        get() = buildString {
            append("video: ")
            append(videoUrl)
            if (!audioUrl.isNullOrBlank() && audioUrl != videoUrl) {
                append("\naudio: ")
                append(audioUrl)
            }
        }

    val diagnosticDescription: String
        get() = buildString {
            append("video: ")
            append(sanitizeUri(videoUrl))
            if (!audioUrl.isNullOrBlank() && audioUrl != videoUrl) {
                append("\naudio: ")
                append(sanitizeUri(audioUrl))
            }
        }
}

private class NormalizingRenderersFactory(
    context: Context,
    private val audioNormalizationProcessor: AudioNormalizationProcessor,
    enableHardwareDecoding: Boolean,
) : DefaultRenderersFactory(context) {
    init {
        setEnableDecoderFallback(true)
        if (!enableHardwareDecoding) {
            setMediaCodecSelector(SOFTWARE_VIDEO_CODEC_SELECTOR)
        }
    }

    override fun buildAudioSink(
        context: Context,
        enableFloatOutput: Boolean,
        enableAudioOutputPlaybackParameters: Boolean,
    ): AudioSink = DefaultAudioSink.Builder(context)
        .setAudioProcessors(arrayOf(audioNormalizationProcessor))
        .setEnableFloatOutput(enableFloatOutput)
        .setEnableAudioOutputPlaybackParameters(enableAudioOutputPlaybackParameters)
        .build()
}

private val SOFTWARE_VIDEO_CODEC_SELECTOR = MediaCodecSelector { mimeType, secure, tunneling ->
    val decoders = MediaCodecSelector.DEFAULT.getDecoderInfos(mimeType, secure, tunneling)
    if (MimeTypes.isVideo(mimeType)) decoders.filter { it.softwareOnly } else decoders
}

internal data class Media3DecoderResolution(
    val useHardwareDecoder: Boolean,
    val description: String,
)

internal fun resolveMedia3DecoderMode(
    requestedMode: String?,
    enableHardwareDecoding: Boolean,
): Media3DecoderResolution {
    if (!enableHardwareDecoding) {
        return Media3DecoderResolution(false, "no (software)")
    }
    val candidates = requestedMode.orEmpty()
        .split(',')
        .map(String::trim)
        .filter(String::isNotEmpty)
    if (candidates.isEmpty()) {
        return Media3DecoderResolution(true, "platform-default")
    }
    val first = candidates.first()
    if (first == "no") {
        return Media3DecoderResolution(false, "no (software)")
    }
    val supportedHardwareModes = setOf(
        "auto",
        "auto-safe",
        "auto-copy",
        "mediacodec",
        "mediacodec-copy",
    )
    val supported = candidates.firstOrNull { it in supportedHardwareModes }
    return if (supported != null) {
        Media3DecoderResolution(true, "$supported (MediaCodec)")
    } else {
        Media3DecoderResolution(
            true,
            "$first (unsupported on Android; platform-default)",
        )
    }
}

private data class Media3PlaybackConfiguration(
    val enableHardwareDecoding: Boolean = true,
    val decoderMode: String = "auto-safe",
    val targetBufferBytes: Int = DEFAULT_TARGET_BUFFER_BYTES,
    val bufferDurationMs: Int = DEFAULT_BUFFER_DURATION_MS,
    val isLive: Boolean = false,
) {
    val decoderResolution = resolveMedia3DecoderMode(
        requestedMode = decoderMode,
        enableHardwareDecoding = enableHardwareDecoding,
    )
    val effectiveHardwareDecoding: Boolean
        get() = decoderResolution.useHardwareDecoder

    fun description(softwareVideoFallback: Boolean = false): String = buildString {
        append("decoder=")
        append(
            if (effectiveHardwareDecoding && !softwareVideoFallback) "hardware" else "software",
        )
        append(", hwdec=")
        append(decoderResolution.description)
        append(", decoderFallback=true")
            if (isLive) {
                append(", buffer=media3-live-default")
                return@buildString
            }
            val policy = resolveMedia3BufferPolicy(
                targetBufferBytes,
                bufferDurationMs,
                isLive = false,
            ) ?: return@buildString
            append(", buffer=custom-safe")
            append(", targetBuffer=")
            append(
                String.format(java.util.Locale.US, "%.2f", policy.targetBufferBytes / 1048576.0),
            )
            append(" MiB, minBuffer=")
            append(policy.minBufferMs)
            append(" ms, maxBuffer=")
            append(policy.maxBufferMs)
            append(" ms, timePriority=true")
        }

    fun createLoadControl(): DefaultLoadControl {
        val policy = resolveMedia3BufferPolicy(targetBufferBytes, bufferDurationMs, isLive)
            ?: return DefaultLoadControl()
        return DefaultLoadControl.Builder()
            .setBufferDurationsMsForStreaming(
                policy.minBufferMs,
                policy.maxBufferMs,
                policy.bufferForPlaybackMs,
                policy.bufferForPlaybackAfterRebufferMs,
            )
            .setTargetBufferBytes(policy.targetBufferBytes)
            .setPrioritizeTimeOverSizeThresholdsForStreaming(true)
            .setBackBuffer(policy.backBufferDurationMs, false)
            .build()
    }
}

private const val MIN_TARGET_BUFFER_BYTES = 64L * 1024L
private const val DEFAULT_TARGET_BUFFER_BYTES = 4 * 1024 * 1024
private const val MIN_BUFFER_DURATION_MS = 500L
private const val DEFAULT_BUFFER_DURATION_MS = 16000

private data class SubtitleRequest(
    val uri: Uri,
    val language: String?,
    val label: String?,
    val mimeType: String,
)

private fun serializePlaybackError(
    error: PlaybackException,
    positionMs: Long,
    playWhenReady: Boolean,
    videoDecoder: String?,
    audioDecoder: String?,
    mediaDescription: String?,
): Map<String, Any?> {
    val causes = error.causeChain()
    val httpError = causes.filterIsInstance<HttpDataSource.InvalidResponseCodeException>()
        .firstOrNull()
    val dataSourceError = causes.filterIsInstance<HttpDataSource.HttpDataSourceException>()
        .firstOrNull()
    val exoError = error as? ExoPlaybackException
    val category = errorCategory(error.errorCode)
    return mapOf(
        "message" to sanitizeDiagnosticMessage(
            causes.lastOrNull()?.message ?: error.message ?: error.errorCodeName,
        ),
        "errorCode" to error.errorCode,
        "errorCodeName" to error.errorCodeName,
        "category" to category,
        "phase" to when {
            exoError?.type == ExoPlaybackException.TYPE_RENDERER -> "renderer"
            exoError?.type == ExoPlaybackException.TYPE_SOURCE -> "source"
            exoError?.type == ExoPlaybackException.TYPE_REMOTE -> "remote"
            else -> "playback"
        },
        "recoverable" to isRecoverablePlaybackError(
            errorCode = error.errorCode,
            httpStatus = httpError?.responseCode,
        ),
        "httpStatus" to httpError?.responseCode,
        "uri" to sanitizeUri(httpError?.dataSpec?.uri ?: dataSourceError?.dataSpec?.uri),
        "rendererName" to exoError?.rendererName,
        "mediaDescription" to mediaDescription,
        "causeChain" to causes.map { cause ->
            val name = cause::class.java.simpleName.ifEmpty { cause::class.java.name }
            cause.message?.let { "$name: ${sanitizeDiagnosticMessage(it)}" } ?: name
        },
        "positionMs" to positionMs,
        "playWhenReady" to playWhenReady,
        "videoDecoder" to videoDecoder,
        "audioDecoder" to audioDecoder,
    )
}

private fun Throwable.causeChain(): List<Throwable> {
    val result = mutableListOf<Throwable>()
    val seen = mutableSetOf<Throwable>()
    var current: Throwable? = this
    while (current != null && seen.add(current)) {
        result += current
        current = current.cause
    }
    return result
}

private fun errorCategory(errorCode: Int): String = when (errorCode) {
    PlaybackException.ERROR_CODE_IO_NETWORK_CONNECTION_FAILED,
    PlaybackException.ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT,
    -> "network"

    PlaybackException.ERROR_CODE_IO_BAD_HTTP_STATUS,
    PlaybackException.ERROR_CODE_IO_FILE_NOT_FOUND,
    PlaybackException.ERROR_CODE_IO_NO_PERMISSION,
    PlaybackException.ERROR_CODE_IO_UNSPECIFIED,
    PlaybackException.ERROR_CODE_PARSING_CONTAINER_MALFORMED,
    PlaybackException.ERROR_CODE_PARSING_CONTAINER_UNSUPPORTED,
    PlaybackException.ERROR_CODE_PARSING_MANIFEST_MALFORMED,
    PlaybackException.ERROR_CODE_PARSING_MANIFEST_UNSUPPORTED,
    -> "source"

    PlaybackException.ERROR_CODE_DECODER_INIT_FAILED,
    PlaybackException.ERROR_CODE_DECODER_QUERY_FAILED,
    PlaybackException.ERROR_CODE_DECODING_FAILED,
    PlaybackException.ERROR_CODE_DECODING_FORMAT_EXCEEDS_CAPABILITIES,
    PlaybackException.ERROR_CODE_DECODING_FORMAT_UNSUPPORTED,
    -> "decoder"

    PlaybackException.ERROR_CODE_DRM_CONTENT_ERROR,
    PlaybackException.ERROR_CODE_DRM_DEVICE_REVOKED,
    PlaybackException.ERROR_CODE_DRM_DISALLOWED_OPERATION,
    PlaybackException.ERROR_CODE_DRM_LICENSE_ACQUISITION_FAILED,
    PlaybackException.ERROR_CODE_DRM_LICENSE_EXPIRED,
    PlaybackException.ERROR_CODE_DRM_PROVISIONING_FAILED,
    PlaybackException.ERROR_CODE_DRM_SCHEME_UNSUPPORTED,
    PlaybackException.ERROR_CODE_DRM_SYSTEM_ERROR,
    PlaybackException.ERROR_CODE_DRM_UNSPECIFIED,
    -> "drm"

    PlaybackException.ERROR_CODE_REMOTE_ERROR -> "remote"
    else -> "unexpected"
}

private fun isRecoverablePlaybackError(errorCode: Int, httpStatus: Int?): Boolean = when (errorCode) {
    PlaybackException.ERROR_CODE_IO_NETWORK_CONNECTION_FAILED,
    PlaybackException.ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT,
    PlaybackException.ERROR_CODE_IO_UNSPECIFIED,
    -> true

    PlaybackException.ERROR_CODE_IO_BAD_HTTP_STATUS ->
        httpStatus == 408 || httpStatus == 429 || (httpStatus != null && httpStatus >= 500)

    else -> false
}

private fun sanitizeUri(value: String?): String? = value?.let {
    runCatching { sanitizeUri(Uri.parse(it)) }.getOrDefault(it.substringBefore('?').substringBefore('#'))
}

private fun sanitizeUri(uri: Uri?): String? {
    if (uri == null) return null
    if (uri.scheme == "data") return "data:${uri.schemeSpecificPart.substringBefore(';')}"
    return uri.buildUpon().clearQuery().fragment(null).build().toString()
}

private val diagnosticUrlPattern = Regex("""(?i)\\bhttps?://\\S+""")

private fun sanitizeDiagnosticMessage(value: String): String =
    diagnosticUrlPattern.replace(value) { match ->
        val trailing = match.value.takeLastWhile { it in ".,;:)]}" }
        val uri = match.value.dropLast(trailing.length)
        "${sanitizeUri(uri)}$trailing"
    }

private fun resolveSubtitleMimeType(mimeType: String?, uri: String?): String {
    val normalized = mimeType?.lowercase()
    return when (normalized) {
        MimeTypes.TEXT_VTT -> MimeTypes.TEXT_VTT
        MimeTypes.APPLICATION_SUBRIP -> MimeTypes.APPLICATION_SUBRIP
        MimeTypes.TEXT_SSA -> MimeTypes.TEXT_SSA
        null, "" -> when {
            uri?.substringBefore('?')?.substringBefore('#')?.lowercase()?.endsWith(".srt") == true ->
                MimeTypes.APPLICATION_SUBRIP
            uri?.substringBefore('?')?.substringBefore('#')?.lowercase()
                ?.let { it.endsWith(".ass") || it.endsWith(".ssa") } == true -> MimeTypes.TEXT_SSA
            else -> MimeTypes.TEXT_VTT
        }
        else -> error("Unsupported subtitle MIME type: $mimeType")
    }
}

private fun serializeTracks(player: Player): List<Map<String, Any?>> =
    player.currentTracks.groups.flatMapIndexed { groupIndex, group ->
        val type = when (group.type) {
            C.TRACK_TYPE_VIDEO -> "video"
            C.TRACK_TYPE_AUDIO -> "audio"
            C.TRACK_TYPE_TEXT -> "subtitle"
            else -> null
        } ?: return@flatMapIndexed emptyList()
        List(group.length) { trackIndex ->
            serializeFormat(
                format = group.getTrackFormat(trackIndex),
                type = type,
                groupIndex = groupIndex,
                trackIndex = trackIndex,
                selected = group.isTrackSelected(trackIndex),
                supported = group.isTrackSupported(trackIndex),
                fallbackId = "${group.mediaTrackGroup.id}:$trackIndex",
            )
        }
    }

private fun serializeFormat(
    format: Format,
    type: String,
    groupIndex: Int,
    trackIndex: Int,
    selected: Boolean,
    supported: Boolean,
    fallbackId: String,
): Map<String, Any?> = mapOf(
    "type" to type,
    "id" to (format.id ?: fallbackId),
    "groupIndex" to groupIndex,
    "trackIndex" to trackIndex,
    "selected" to selected,
    "supported" to supported,
    "external" to (type == "subtitle" && format.id == APP_SUBTITLE_TRACK_ID),
    "title" to format.label,
    "language" to format.language,
    "codec" to format.codecs,
    "mimeType" to format.sampleMimeType,
    "containerMimeType" to format.containerMimeType,
    "bitrate" to format.bitrate.unsetToNull(),
    "width" to format.width.unsetToNull(),
    "height" to format.height.unsetToNull(),
    "frameRate" to format.frameRate.unsetToNull(),
    "rotationDegrees" to format.rotationDegrees.unsetToNull(),
    "pixelWidthHeightRatio" to format.pixelWidthHeightRatio.takeUnless {
        it == Format.NO_VALUE.toFloat()
    },
    "channelCount" to format.channelCount.unsetToNull(),
    "sampleRate" to format.sampleRate.unsetToNull(),
    "colorInfo" to format.colorInfo?.toString(),
)

private fun Int.unsetToNull(): Int? = takeUnless { it == Format.NO_VALUE }

private fun Float.unsetToNull(): Float? = takeUnless {
    it == Format.NO_VALUE.toFloat()
}

private const val APP_SUBTITLE_TRACK_ID = "piliplus-app-subtitle"
private const val EXO_PLAYER_TAG = "PiliPlusExoPlayer"

private fun serializeCue(cue: Cue): Map<String, Any?>? {
    val text = cue.text
    val bitmap = cue.bitmap
    if ((text == null || text.isBlank()) && bitmap == null) return null
    val encodedBitmap = bitmap?.let(::encodeSubtitleBitmap)
    return mapOf(
        "text" to text?.toString().orEmpty(),
        "segments" to text?.let(::serializeSegments).orEmpty(),
        "bitmap" to encodedBitmap,
        "bitmapPixelWidth" to bitmap?.width,
        "bitmapPixelHeight" to bitmap?.height,
        "bitmapHeight" to cue.bitmapHeight.takeUnless { it == Cue.DIMEN_UNSET },
        "textAlignment" to cue.textAlignment.serializedName(),
        "multiRowAlignment" to cue.multiRowAlignment.serializedName(),
        "line" to cue.line.takeUnless { it == Cue.DIMEN_UNSET },
        "lineType" to cue.lineType.takeUnless { it == Cue.TYPE_UNSET },
        "lineAnchor" to cue.lineAnchor.takeUnless { it == Cue.TYPE_UNSET },
        "position" to cue.position.takeUnless { it == Cue.DIMEN_UNSET },
        "positionAnchor" to cue.positionAnchor.takeUnless { it == Cue.TYPE_UNSET },
        "size" to cue.size.takeUnless { it == Cue.DIMEN_UNSET },
        "windowColor" to cue.windowColor.takeIf { cue.windowColorSet }
            ?.toLong()?.and(0xFFFFFFFFL),
        "textSizeType" to cue.textSizeType.takeUnless { it == Cue.TYPE_UNSET },
        "textSize" to cue.textSize.takeUnless { it == Cue.DIMEN_UNSET },
        "verticalType" to cue.verticalType.takeUnless { it == Cue.TYPE_UNSET },
        "shearDegrees" to cue.shearDegrees,
        "zIndex" to cue.zIndex,
    )
}

private fun encodeSubtitleBitmap(bitmap: Bitmap): ByteArray =
    ByteArrayOutputStream().use { output ->
        check(bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)) {
            "Android failed to encode subtitle bitmap as PNG"
        }
        output.toByteArray()
    }

private fun List<Map<String, Any?>>.contentEquals(
    other: List<Map<String, Any?>>,
): Boolean = size == other.size && indices.all { index ->
    this[index].contentEquals(other[index])
}

private fun Map<String, Any?>.contentEquals(
    other: Map<String, Any?>,
): Boolean = size == other.size && all { (key, value) ->
    if (!other.containsKey(key)) return@all false
    val otherValue = other[key]
    if (value is ByteArray && otherValue is ByteArray) {
        value.contentEquals(otherValue)
    } else {
        value == otherValue
    }
}

private fun Layout.Alignment?.serializedName(): String? = when (this) {
    Layout.Alignment.ALIGN_NORMAL -> "normal"
    Layout.Alignment.ALIGN_CENTER -> "center"
    Layout.Alignment.ALIGN_OPPOSITE -> "opposite"
    null -> null
}

private fun serializeSegments(text: CharSequence): List<Map<String, Any?>> {
    if (text !is Spanned) {
        return listOf(mapOf("text" to text.toString()))
    }
    val boundaries = sortedSetOf(0, text.length)
    text.getSpans(0, text.length, Any::class.java).forEach { span ->
        boundaries += text.getSpanStart(span)
        boundaries += text.getSpanEnd(span)
    }
    return boundaries.zipWithNext().mapNotNull { (start, end) ->
        if (start >= end) return@mapNotNull null
        val spans = text.getSpans(start, end, Any::class.java)
        val styleSpans = spans.filterIsInstance<StyleSpan>()
        val styleValues = styleSpans.map { it.style }
        val absoluteSize = spans.filterIsInstance<AbsoluteSizeSpan>().lastOrNull()
        buildMap {
            put("text", text.subSequence(start, end).toString())
            put(
                "bold",
                styleValues.any { it == Typeface.BOLD || it == Typeface.BOLD_ITALIC },
            )
            put(
                "italic",
                styleValues.any { it == Typeface.ITALIC || it == Typeface.BOLD_ITALIC },
            )
            put("underline", spans.any { it is UnderlineSpan })
            put("strikethrough", spans.any { it is StrikethroughSpan })
            put(
                "combineUpright",
                spans.any { it is HorizontalTextInVerticalContextSpan },
            )
            spans.filterIsInstance<ForegroundColorSpan>().lastOrNull()?.let {
                put("foregroundColor", it.foregroundColor.toLong().and(0xFFFFFFFFL))
            }
            spans.filterIsInstance<BackgroundColorSpan>().lastOrNull()?.let {
                put("backgroundColor", it.backgroundColor.toLong().and(0xFFFFFFFFL))
            }
            spans.filterIsInstance<TypefaceSpan>().lastOrNull()?.family?.let {
                put("fontFamily", it)
            }
            absoluteSize?.let {
                put("absoluteSize", it.size)
                put("absoluteSizeIsDip", it.dip)
            }
            spans.filterIsInstance<RelativeSizeSpan>().lastOrNull()?.let {
                put("relativeSize", it.sizeChange)
            }
        }
    }
}
