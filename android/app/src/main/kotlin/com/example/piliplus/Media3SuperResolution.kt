package com.example.piliplus

import kotlin.math.min
import kotlin.math.roundToInt

internal enum class Media3SuperResolutionMode {
    DISABLE,
    EFFICIENCY,
    QUALITY,
    ;

    companion object {
        fun fromName(value: String): Media3SuperResolutionMode = when (value.lowercase()) {
            "disable" -> DISABLE
            "efficiency" -> EFFICIENCY
            "quality" -> QUALITY
            else -> error("Unsupported super-resolution mode: $value")
        }
    }
}

internal data class Media3SuperResolutionTarget(
    val width: Int,
    val height: Int,
)

/**
 * Chooses a bounded Lanczos output size without ever downscaling the source.
 *
 * Efficiency is intended for sustained playback on phones and stops at 1080p.
 * Quality allows a two-times upscale up to 4K. Both bounds are orientation
 * neutral, so portrait and square video retain their original aspect ratio.
 */
internal fun resolveMedia3SuperResolutionTarget(
    mode: Media3SuperResolutionMode,
    sourceWidth: Int,
    sourceHeight: Int,
): Media3SuperResolutionTarget? {
    if (mode == Media3SuperResolutionMode.DISABLE || sourceWidth <= 0 || sourceHeight <= 0) {
        return null
    }
    val desiredScale: Double
    val maximumLongEdge: Int
    val maximumShortEdge: Int
    when (mode) {
        Media3SuperResolutionMode.DISABLE -> return null
        Media3SuperResolutionMode.EFFICIENCY -> {
            desiredScale = 1.5
            maximumLongEdge = 1920
            maximumShortEdge = 1080
        }
        Media3SuperResolutionMode.QUALITY -> {
            desiredScale = 2.0
            maximumLongEdge = 3840
            maximumShortEdge = 2160
        }
    }
    val longEdge = maxOf(sourceWidth, sourceHeight)
    val shortEdge = minOf(sourceWidth, sourceHeight)
    val scale = min(
        desiredScale,
        min(
            maximumLongEdge.toDouble() / longEdge,
            maximumShortEdge.toDouble() / shortEdge,
        ),
    )
    if (scale <= 1.0) return null
    return Media3SuperResolutionTarget(
        width = (sourceWidth * scale).roundToInt().coerceAtLeast(sourceWidth),
        height = (sourceHeight * scale).roundToInt().coerceAtLeast(sourceHeight),
    )
}
