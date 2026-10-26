package com.example.piliplus

import android.app.Activity
import android.app.AlertDialog
import android.content.pm.ActivityInfo
import android.os.Build
import android.os.Bundle
import android.view.GestureDetector
import android.view.HapticFeedbackConstants
import android.view.MotionEvent
import android.view.View
import android.widget.ImageButton
import android.widget.TextView
import androidx.media3.common.Player
import androidx.media3.common.util.UnstableApi
import androidx.media3.ui.AspectRatioFrameLayout
import androidx.media3.ui.DefaultTimeBar
import androidx.media3.ui.PlayerView

@androidx.annotation.OptIn(UnstableApi::class)
internal class Media3Controls(
    private val activity: Activity,
    private val playerView: PlayerView,
    savedState: Bundle?,
) {
    private val lock = activity.findViewById<ImageButton>(R.id.media3_lock)
    private val feedback = activity.findViewById<TextView>(R.id.media3_feedback)
    private val speedButton = activity.findViewById<TextView>(R.id.media3_speed)
    private val fitButton = activity.findViewById<TextView>(R.id.media3_fit)
    private val timeout = activity.intent.getIntExtra("controlsTimeoutMs", 3000)
    private val seekStep = activity.intent.getLongExtra("seekStepMs", 10000)
    private val gestures = Media3GestureState(
        activity.intent.getBooleanExtra("quickDoubleTap", true),
        seekStep,
        activity.intent.getFloatExtra("longPressSpeed", 3f),
    ).apply {
        locked = savedState?.getBoolean("controlsLocked") ?: false
    }
    private var dialog: AlertDialog? = null
    private var diagnostics = activity.getString(R.string.media3_player_title)
    private val hideFeedback = Runnable { feedback.visibility = View.GONE }
    private val hideLock = Runnable { lock.visibility = View.GONE }
    private val fits = listOf(
        AspectRatioFrameLayout.RESIZE_MODE_FIT to R.string.media3_player_fit_auto,
        AspectRatioFrameLayout.RESIZE_MODE_FILL to R.string.media3_player_fit_stretch,
        AspectRatioFrameLayout.RESIZE_MODE_ZOOM to R.string.media3_player_fit_crop,
        AspectRatioFrameLayout.RESIZE_MODE_FIXED_WIDTH to R.string.media3_player_fit_width,
        AspectRatioFrameLayout.RESIZE_MODE_FIXED_HEIGHT to R.string.media3_player_fit_height,
    )

    init {
        applyControlInsets(activity.findViewById(R.id.media3_controls))
        applyControlInsets(activity.findViewById(R.id.media3_lock_container))
        activity.findViewById<View>(R.id.media3_back).setOnClickListener { activity.finish() }
        activity.findViewById<TextView>(R.id.media3_title).text =
            activity.intent.getStringExtra("title")?.takeIf { it.isNotBlank() }
                ?: activity.getString(R.string.media3_player_title)
        activity.findViewById<View>(R.id.media3_info).setOnClickListener {
            showDialog(
                AlertDialog.Builder(activity)
                    .setTitle(R.string.media3_player_info)
                    .setMessage(diagnostics)
                    .setPositiveButton(android.R.string.ok, null)
                    .create()
            )
        }
        val accent = activity.intent.getIntExtra("accentColor", -1)
        activity.findViewById<DefaultTimeBar>(androidx.media3.ui.R.id.exo_progress).apply {
            setPlayedColor(accent)
            setScrubberColor(accent)
            setBufferedColor((accent and 0x00FFFFFF) or 0x66000000)
        }
        playerView.controllerShowTimeoutMs = timeout
        playerView.resizeMode = savedState?.getInt("resizeMode") ?: AspectRatioFrameLayout.RESIZE_MODE_FIT
        updateFit()
        fitButton.setOnClickListener { showFits() }
        speedButton.setOnClickListener { showSpeeds() }
        lock.setOnClickListener {
            gestures.locked = !gestures.locked
            lock.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            applyLock()
            if (!gestures.locked) playerView.showController()
        }
        playerView.setControllerVisibilityListener(PlayerView.ControllerVisibilityListener { visibility ->
            if (!gestures.locked) lock.visibility = visibility
        })
        val detector = GestureDetector(activity, object : GestureDetector.SimpleOnGestureListener() {
            override fun onDown(event: MotionEvent) = true

            override fun onSingleTapConfirmed(event: MotionEvent): Boolean {
                if (gestures.locked) showLock() else playerView.performClick()
                return true
            }

            override fun onDoubleTap(event: MotionEvent): Boolean {
                val direction = gestures.doubleTapDirection(event.x, playerView.width)
                if (direction == null) {
                    showLock()
                    return true
                }
                val player = playerView.player ?: return true
                if (direction == 0) {
                    if (player.playWhenReady) player.pause() else player.play()
                    playerView.showController()
                } else if (player.isCommandAvailable(Player.COMMAND_SEEK_IN_CURRENT_MEDIA_ITEM)) {
                    gestures.seekPosition(player.currentPosition, player.duration, direction)?.let { position ->
                        player.seekTo(position)
                        player.play()
                        showFeedback(activity.getString(
                            if (direction < 0) R.string.media3_player_rewind else R.string.media3_player_forward,
                            seekStep / 1000,
                        ))
                    }
                }
                return true
            }

            override fun onLongPress(event: MotionEvent) {
                val player = playerView.player ?: return
                val boosted = gestures.startSpeedBoost(player.playbackParameters.speed, player.isPlaying) ?: return
                player.setPlaybackSpeed(boosted)
                playerView.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS)
                playerView.hideController()
                showFeedback(activity.getString(R.string.media3_player_speed_boost, speedLabel(boosted)), false)
            }
        })
        @Suppress("ClickableViewAccessibility")
        playerView.setOnTouchListener { _, event ->
            detector.onTouchEvent(event)
            if (event.actionMasked == MotionEvent.ACTION_UP || event.actionMasked == MotionEvent.ACTION_CANCEL) {
                endSpeedBoost()
            }
            true
        }
        applyLock()
    }

    private fun applyControlInsets(view: View) {
        val left = view.paddingLeft
        val top = view.paddingTop
        val right = view.paddingRight
        val bottom = view.paddingBottom
        view.setOnApplyWindowInsetsListener { _, insets ->
            val cutout = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) insets.displayCutout else null
            // Only controls avoid system UI and cutouts; the video remains edge-to-edge.
            @Suppress("DEPRECATION")
            view.setPadding(
                left + maxOf(insets.systemWindowInsetLeft, cutout?.safeInsetLeft ?: 0),
                top + maxOf(insets.systemWindowInsetTop, cutout?.safeInsetTop ?: 0),
                right + maxOf(insets.systemWindowInsetRight, cutout?.safeInsetRight ?: 0),
                bottom + maxOf(insets.systemWindowInsetBottom, cutout?.safeInsetBottom ?: 0),
            )
            insets
        }
        view.requestApplyInsets()
    }

    fun updateSpeed() {
        val speed = playerView.player?.playbackParameters?.speed ?: return
        speedButton.text = speedLabel(speed)
        speedButton.contentDescription =
            "${activity.getString(R.string.media3_player_speed)} ${speedLabel(speed)}"
    }

    fun setDecoderName(name: String) {
        diagnostics = activity.getString(R.string.media3_player_diagnostics, name)
    }

    private fun speedLabel(speed: Float) = "${speed}X"

    private fun showSpeeds() {
        val player = playerView.player ?: return
        val current = player.playbackParameters.speed
        val speeds = (requireNotNull(activity.intent.getFloatArrayExtra("speeds")).toList() + current).distinct().sorted()
        showDialog(
            AlertDialog.Builder(activity)
                .setTitle(R.string.media3_player_speed)
                .setSingleChoiceItems(speeds.map(::speedLabel).toTypedArray(), speeds.indexOf(current)) { menu, index ->
                    player.setPlaybackSpeed(speeds[index])
                    menu.dismiss()
                }
                .create()
        )
    }

    private fun showFits() {
        showDialog(
            AlertDialog.Builder(activity)
                .setTitle(R.string.media3_player_fit)
                .setSingleChoiceItems(
                    fits.map { activity.getString(it.second) }.toTypedArray(),
                    fits.indexOfFirst { it.first == playerView.resizeMode },
                ) { menu, index ->
                    playerView.resizeMode = fits[index].first
                    updateFit()
                    menu.dismiss()
                }
                .create()
        )
    }

    private fun updateFit() {
        fitButton.setText(fits.first { it.first == playerView.resizeMode }.second)
    }

    private fun showDialog(menu: AlertDialog) {
        dialog?.dismiss()
        dialog = menu
        playerView.controllerShowTimeoutMs = 0
        menu.setOnDismissListener {
            dialog = null
            playerView.controllerShowTimeoutMs = timeout
        }
        menu.show()
    }

    private fun applyLock() {
        val locked = gestures.locked
        playerView.useController = !locked
        lock.setImageResource(if (locked) R.drawable.ic_player_lock else R.drawable.ic_player_unlock)
        lock.setContentDescription(activity.getString(
            if (locked) R.string.media3_player_unlock else R.string.media3_player_lock
        ))
        activity.requestedOrientation =
            if (locked) ActivityInfo.SCREEN_ORIENTATION_LOCKED else ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
        lock.removeCallbacks(hideLock)
        if (locked) showLock()
    }

    private fun showLock() {
        lock.visibility = View.VISIBLE
        lock.removeCallbacks(hideLock)
        lock.postDelayed(hideLock, timeout.toLong())
    }

    private fun showFeedback(text: String, autoHide: Boolean = true) {
        feedback.text = text
        feedback.visibility = View.VISIBLE
        feedback.removeCallbacks(hideFeedback)
        if (autoHide) feedback.postDelayed(hideFeedback, 800)
    }

    fun endSpeedBoost() {
        gestures.endSpeedBoost()?.let {
            playerView.player?.setPlaybackSpeed(it)
            feedback.visibility = View.GONE
        }
    }

    fun saveState(state: Bundle) {
        state.putBoolean("controlsLocked", gestures.locked)
        state.putInt("resizeMode", playerView.resizeMode)
    }

    fun onStop() {
        endSpeedBoost()
        dialog?.dismiss()
        feedback.removeCallbacks(hideFeedback)
        lock.removeCallbacks(hideLock)
        feedback.visibility = View.GONE
    }
}
