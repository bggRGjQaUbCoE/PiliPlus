package com.example.piliplus

import android.app.Activity
import android.content.Intent
import android.content.pm.ActivityInfo
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Display
import android.view.View
import android.view.WindowManager
import androidx.media3.common.AudioAttributes
import androidx.media3.common.C
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.PlaybackException
import androidx.media3.common.PlaybackParameters
import androidx.media3.common.Player
import androidx.media3.common.Tracks
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DefaultDataSource
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.DefaultRenderersFactory
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.analytics.AnalyticsListener
import androidx.media3.exoplayer.mediacodec.MediaCodecSelector
import androidx.media3.exoplayer.mediacodec.MediaCodecUtil
import androidx.media3.exoplayer.source.MergingMediaSource
import androidx.media3.exoplayer.source.ProgressiveMediaSource
import androidx.media3.ui.PlayerView
import java.io.File
import java.lang.ref.WeakReference

@androidx.annotation.OptIn(UnstableApi::class)
class Media3PlayerActivity : Activity() {
    private var player: ExoPlayer? = null
    private lateinit var playerView: PlayerView
    private var controls: Media3Controls? = null
    private var positionMs = 0L
    private var durationMs = 0L
    private var speed = 1f
    private var playWhenReady = true
    private var completed = false
    private var returning = false
    private var playbackError: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        current = WeakReference(this)
        positionMs = savedInstanceState?.getLong("positionMs")
            ?: intent.getLongExtra("positionMs", 0)
        speed = savedInstanceState?.getFloat("speed") ?: intent.getFloatExtra("speed", 1f)
        playWhenReady = savedInstanceState?.getBoolean("playWhenReady") ?: true
        durationMs = savedInstanceState?.getLong("durationMs") ?: 0
        if (closeRequested) {
            finish()
            return
        }
        if (Build.VERSION.SDK_INT < 24) {
            fail(getString(R.string.media3_player_android_required))
            return
        }
        @Suppress("DEPRECATION")
        val hdrTypes = windowManager.defaultDisplay.hdrCapabilities?.supportedHdrTypes
        if (hdrTypes?.contains(Display.HdrCapabilities.HDR_TYPE_DOLBY_VISION) != true) {
            fail(getString(R.string.media3_player_display_required))
            return
        }
        if (Build.VERSION.SDK_INT >= 26) window.colorMode = ActivityInfo.COLOR_MODE_HDR
        setContentView(R.layout.media3_player)
        playerView = findViewById(R.id.media3_player)
        controls = Media3Controls(this, playerView, savedInstanceState)
        @Suppress("DEPRECATION")
        window.decorView.systemUiVisibility = (
            View.SYSTEM_UI_FLAG_FULLSCREEN or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            )
    }

    override fun onStart() {
        super.onStart()
        if (isFinishing || !::playerView.isInitialized) return
        if (closeRequested) {
            finish()
            return
        }
        try {
            if (MediaCodecUtil.getDecoderInfos(MimeTypes.VIDEO_DOLBY_VISION, false, false).isEmpty()) {
                fail(getString(R.string.media3_player_codec_required))
                return
            }
            // Do not silently decode the Profile 5 base layer as ordinary HEVC.
            val selector = MediaCodecSelector { mimeType, secure, tunneling ->
                if (MimeTypes.isVideo(mimeType) && mimeType != MimeTypes.VIDEO_DOLBY_VISION) {
                    emptyList()
                } else {
                    MediaCodecSelector.DEFAULT.getDecoderInfos(mimeType, secure, tunneling)
                }
            }
            val renderers = DefaultRenderersFactory(this).setMediaCodecSelector(selector)
            val exoPlayer = ExoPlayer.Builder(this, renderers).build()
            player = exoPlayer
            exoPlayer.setAudioAttributes(
                AudioAttributes.Builder().setUsage(C.USAGE_MEDIA).setContentType(C.AUDIO_CONTENT_TYPE_MOVIE).build(),
                true,
            )
            exoPlayer.setHandleAudioBecomingNoisy(true)
            exoPlayer.addListener(object : Player.Listener {
                override fun onPlayerError(error: PlaybackException) {
                    fail("${error.errorCodeName}: ${error.message}", error)
                }

                override fun onIsPlayingChanged(isPlaying: Boolean) {
                    if (isPlaying) {
                        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    }
                }

                override fun onPlaybackParametersChanged(playbackParameters: PlaybackParameters) {
                    controls?.updateSpeed()
                }

                override fun onPlayWhenReadyChanged(playWhenReady: Boolean, reason: Int) {
                    if (!playWhenReady) controls?.endSpeedBoost()
                }

                override fun onPlaybackStateChanged(playbackState: Int) {
                    if (playbackState == Player.STATE_ENDED) {
                        completed = true
                        finish()
                    }
                }

                override fun onTracksChanged(tracks: Tracks) {
                    for (group in tracks.groups) {
                        if (group.type != C.TRACK_TYPE_VIDEO) continue
                        for (index in 0 until group.length) {
                            if (!group.isTrackSelected(index)) continue
                            val format = group.getTrackFormat(index)
                            if (format.sampleMimeType != MimeTypes.VIDEO_DOLBY_VISION ||
                                format.codecs?.let { PROFILE_5.matches(it) } != true) {
                                fail(getString(R.string.media3_player_wrong_profile))
                                return
                            }
                        }
                    }
                }
            })
            exoPlayer.addAnalyticsListener(object : AnalyticsListener {
                override fun onVideoDecoderInitialized(
                    eventTime: AnalyticsListener.EventTime,
                    decoderName: String,
                    initializedTimestampMs: Long,
                    initializationDurationMs: Long,
                ) {
                    controls?.setDecoderName(decoderName)
                }
            })
            val headers = requireNotNull(intent.getBundleExtra("headers")) { "Missing HTTP headers" }
            val requestHeaders = headers.keySet().associateWith {
                requireNotNull(headers.getString(it)) { "Invalid HTTP header" }
            }
            val http = DefaultHttpDataSource.Factory().setDefaultRequestProperties(requestHeaders)
            val dataSources = DefaultDataSource.Factory(this, http)
            val sources = ProgressiveMediaSource.Factory(dataSources)
            fun mediaItem(source: String): MediaItem {
                val uri = if (source.startsWith('/')) Uri.fromFile(File(source)) else Uri.parse(source)
                return MediaItem.fromUri(uri)
            }
            val video = requireNotNull(intent.getStringExtra("video")) { "Missing video source" }
            val videoSource = sources.createMediaSource(mediaItem(video))
            val audio = intent.getStringExtra("audio")
            val source = if (audio.isNullOrEmpty()) videoSource else MergingMediaSource(
                true,
                videoSource,
                sources.createMediaSource(mediaItem(audio)),
            )
            playerView.player = exoPlayer
            exoPlayer.setMediaSource(source)
            exoPlayer.seekTo(positionMs)
            exoPlayer.setPlaybackSpeed(speed)
            controls?.updateSpeed()
            exoPlayer.playWhenReady = playWhenReady && !pauseRequested
            exoPlayer.prepare()
            if (playerView.useController) playerView.showController()
        } catch (error: MediaCodecUtil.DecoderQueryException) {
            fail(getString(R.string.media3_player_codec_required), error)
        } catch (error: IllegalArgumentException) {
            fail(error.message ?: "Invalid Media3 source", error)
        } catch (error: IllegalStateException) {
            fail(error.message ?: "Unable to initialize Media3", error)
        }
    }

    private fun capturePosition() {
        controls?.endSpeedBoost()
        player?.let {
            positionMs = it.currentPosition.coerceAtLeast(0)
            if (it.duration != C.TIME_UNSET) durationMs = it.duration.coerceAtLeast(0)
            speed = it.playbackParameters.speed
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        capturePosition()
        outState.putLong("positionMs", positionMs)
        outState.putLong("durationMs", durationMs)
        outState.putFloat("speed", speed)
        outState.putBoolean("playWhenReady", player?.playWhenReady ?: playWhenReady)
        controls?.saveState(outState)
        super.onSaveInstanceState(outState)
    }

    override fun onStop() {
        controls?.onStop()
        capturePosition()
        // No background playback: resume paused after leaving the native activity.
        playWhenReady = false
        releasePlayer()
        super.onStop()
    }

    private fun releasePlayer() {
        if (::playerView.isInitialized) playerView.player = null
        player?.release()
        player = null
        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }

    override fun onDestroy() {
        controls?.onStop()
        releasePlayer()
        if (current?.get() === this) current = null
        super.onDestroy()
    }

    override fun finish() {
        if (returning) return
        returning = true
        controls?.onStop()
        capturePosition()
        setResult(
            RESULT_OK,
            Intent()
                .putExtra("positionMs", positionMs)
                .putExtra("durationMs", durationMs)
                .putExtra("speed", speed)
                .putExtra("completed", completed)
                .putExtra("error", playbackError),
        )
        releasePlayer()
        super.finish()
    }

    private fun fail(message: String, cause: Throwable? = null) {
        Log.e("PiliPlusMedia3", message, cause)
        playbackError = message
        finish()
    }

    companion object {
        private val PROFILE_5 = Regex("(?i)(dvhe|dvh1)\\.0?5\\..+")
        private var current: WeakReference<Media3PlayerActivity>? = null
        private var closeRequested = false
        private var pauseRequested = false

        internal fun resetRequests() {
            closeRequested = false
            pauseRequested = false
        }

        internal fun closePlayer() {
            closeRequested = true
            current?.get()?.finish()
        }

        internal fun pausePlayer() {
            pauseRequested = true
            current?.get()?.player?.pause()
        }
    }
}
