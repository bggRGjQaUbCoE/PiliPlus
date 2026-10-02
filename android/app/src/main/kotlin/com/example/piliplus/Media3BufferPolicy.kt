package com.example.piliplus

internal data class Media3BufferPolicy(
    val targetBufferBytes: Int,
    val minBufferMs: Int,
    val maxBufferMs: Int,
    val bufferForPlaybackMs: Int,
    val bufferForPlaybackAfterRebufferMs: Int,
    val backBufferDurationMs: Int,
)

/**
 * Maps the shared VOD preferences without allowing a small byte target to stop
 * loading before Media3 has a safe amount of playable media.
 *
 * Live sessions retain Media3's defaults because their latency policy cannot be
 * inferred from the VOD buffer-duration preference.
 */
internal fun resolveMedia3BufferPolicy(
    targetBufferBytes: Int,
    bufferDurationMs: Int,
    isLive: Boolean,
): Media3BufferPolicy? {
    if (isLive) return null
    val maximumMs = bufferDurationMs.coerceAtLeast(MIN_MEDIA3_BUFFER_DURATION_MS)
    val rebufferMs = minOf(DEFAULT_MEDIA3_REBUFFER_MS, maximumMs)
    return Media3BufferPolicy(
        targetBufferBytes = targetBufferBytes.coerceAtLeast(MIN_MEDIA3_TARGET_BUFFER_BYTES),
        minBufferMs = rebufferMs,
        maxBufferMs = maximumMs,
        bufferForPlaybackMs = minOf(DEFAULT_MEDIA3_PLAYBACK_MS, maximumMs),
        bufferForPlaybackAfterRebufferMs = rebufferMs,
        backBufferDurationMs = maximumMs,
    )
}

private const val MIN_MEDIA3_TARGET_BUFFER_BYTES = 64 * 1024
private const val MIN_MEDIA3_BUFFER_DURATION_MS = 500
private const val DEFAULT_MEDIA3_PLAYBACK_MS = 2500
private const val DEFAULT_MEDIA3_REBUFFER_MS = 5000
