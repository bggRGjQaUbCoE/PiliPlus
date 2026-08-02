package com.example.piliplus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class Media3BufferPolicyTest {
    @Test
    fun defaultVodPreferencesKeepAPlayableTimeFloor() {
        assertEquals(
            Media3BufferPolicy(
                targetBufferBytes = 8 * 1024 * 1024,
                minBufferMs = 5000,
                maxBufferMs = 16000,
                bufferForPlaybackMs = 2500,
                bufferForPlaybackAfterRebufferMs = 5000,
                backBufferDurationMs = 16000,
            ),
            resolveMedia3BufferPolicy(
                targetBufferBytes = 8 * 1024 * 1024,
                bufferDurationMs = 16000,
                isLive = false,
            ),
        )
    }

    @Test
    fun shortVodPreferenceKeepsAllThresholdsValid() {
        assertEquals(
            Media3BufferPolicy(
                targetBufferBytes = 64 * 1024,
                minBufferMs = 1000,
                maxBufferMs = 1000,
                bufferForPlaybackMs = 1000,
                bufferForPlaybackAfterRebufferMs = 1000,
                backBufferDurationMs = 1000,
            ),
            resolveMedia3BufferPolicy(
                targetBufferBytes = 1,
                bufferDurationMs = 1000,
                isLive = false,
            ),
        )
    }

    @Test
    fun liveRetainsMedia3Defaults() {
        assertNull(
            resolveMedia3BufferPolicy(
                targetBufferBytes = 8 * 1024 * 1024,
                bufferDurationMs = 16000,
                isLive = true,
            ),
        )
    }
}
