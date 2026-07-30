@file:androidx.annotation.OptIn(
    markerClass = [androidx.media3.common.util.UnstableApi::class],
)

package com.example.piliplus

import android.content.Context
import android.graphics.Typeface
import android.net.Uri
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
import androidx.media3.common.C
import androidx.media3.common.Format
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.TrackSelectionOverride
import androidx.media3.common.VideoSize
import androidx.media3.common.text.Cue
import androidx.media3.common.text.CueGroup
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.analytics.AnalyticsListener
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
) : Player.Listener, AnalyticsListener {
    val player: ExoPlayer = ExoPlayer.Builder(context).build().also {
        it.addListener(this)
        it.addAnalyticsListener(this)
        it.playWhenReady = false
    }

    private var width = 0
    private var height = 0
    private var mediaRequest: MediaRequest? = null
    private var subtitleRequest: SubtitleRequest? = null
    private var subtitleCues: List<Map<String, Any?>> = emptyList()
    private var videoDecoder: String? = null
    private var audioDecoder: String? = null
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
        videoDecoder = null
        audioDecoder = null
        if (!preserveSubtitle) {
            subtitleRequest = null
        }
        updateSubtitleCues(emptyList())
        prepareMedia(positionMs, playWhenReady)
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
                uri = if (uri.contains("://")) {
                    Uri.parse(uri)
                } else {
                    Uri.fromFile(java.io.File(uri))
                },
                language = language,
                label = label,
                mimeType = resolvedMimeType,
            )
            else -> null
        }
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
            val uri = if (url.contains("://")) Uri.parse(url) else Uri.fromFile(java.io.File(url))
            val item = MediaItem.Builder().setUri(uri).apply {
                if (subtitle != null) {
                    setSubtitleConfigurations(
                        listOf(
                            MediaItem.SubtitleConfiguration.Builder(subtitle.uri)
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
        updateSubtitleCues(cueGroup.cues.mapNotNull(::serializeCue))
    }

    override fun onPlayerError(error: PlaybackException) {
        sendEvent(
            baseEvent("error") + mapOf(
                "message" to (error.message ?: error.errorCodeName),
                "errorCode" to error.errorCode,
            ),
        )
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
                "completed" to (player.playbackState == Player.STATE_ENDED),
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
                "mediaDescription" to mediaRequest?.description,
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
        if (subtitleCues == value) return
        subtitleCues = value
        sendEvent(
            baseEvent("subtitle") + mapOf(
                "subtitle" to value.joinToString("\n") { it["text"].toString() },
                "subtitleCues" to value,
            ),
        )
    }

    fun dispose() {
        surfaceProducer.setCallback(null)
        player.clearVideoSurface()
        player.removeListener(this)
        player.removeAnalyticsListener(this)
        player.release()
        surfaceProducer.release()
    }
}

private data class MediaRequest(
    val videoUrl: String,
    val audioUrl: String?,
    val headers: Map<String, String>,
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
}

private data class SubtitleRequest(
    val uri: Uri,
    val language: String?,
    val label: String?,
    val mimeType: String,
)

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

private fun serializeCue(cue: Cue): Map<String, Any?>? {
    val text = cue.text ?: return null
    if (text.isBlank()) return null
    return mapOf(
        "text" to text.toString(),
        "segments" to serializeSegments(text),
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
