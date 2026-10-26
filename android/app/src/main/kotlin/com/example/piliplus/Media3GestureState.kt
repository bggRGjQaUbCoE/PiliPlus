package com.example.piliplus

internal class Media3GestureState(
    private val quickDoubleTap: Boolean,
    private val seekStepMs: Long,
    private val longPressSpeed: Float,
) {
    var locked = false
    private var normalSpeed: Float? = null

    fun doubleTapDirection(x: Float, width: Int): Int? = when {
        locked -> null
        !quickDoubleTap -> 0
        x < width / 4f -> -1
        x > width * 3f / 4f -> 1
        else -> 0
    }

    fun seekPosition(positionMs: Long, durationMs: Long, direction: Int): Long? {
        if (locked || durationMs <= 0) return null
        val position = positionMs.coerceIn(0, durationMs)
        return if (direction < 0) {
            position - seekStepMs.coerceAtMost(position)
        } else {
            position + seekStepMs.coerceAtMost(durationMs - position)
        }
    }

    fun startSpeedBoost(currentSpeed: Float, isPlaying: Boolean): Float? {
        if (locked || !isPlaying || normalSpeed != null) return null
        normalSpeed = currentSpeed
        return if (longPressSpeed == 0f) currentSpeed * 2 else longPressSpeed
    }

    fun endSpeedBoost(): Float? {
        val speed = normalSpeed
        normalSpeed = null
        return speed
    }
}
