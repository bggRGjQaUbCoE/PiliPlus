package com.example.piliplus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertThrows
import org.junit.Test

class Media3RequestTest {
    private fun arguments(video: Any? = "https://video.example/video.m4s") = mapOf(
        "video" to video,
        "audio" to "https://audio.example/audio.m4s",
        "positionMs" to 12345L,
        "speed" to 1.5,
        "headers" to mapOf("Referer" to "https://www.bilibili.com", "User-Agent" to "PiliPlus"),
    )

    @Test
    fun preservesSeparateStreamsAndResumeParameters() {
        val request = Media3Request.parse(arguments())
        assertEquals("https://video.example/video.m4s", request.video)
        assertEquals("https://audio.example/audio.m4s", request.audio)
        assertEquals(12345L, request.positionMs)
        assertEquals(1.5f, request.speed)
        assertEquals("https://www.bilibili.com", request.headers["Referer"])
    }

    @Test
    fun supportsMuxedAndSplitLocalDownloads() {
        val request = Media3Request.parse(
            arguments("/downloads/a b/video.m4s") + ("audio" to "/downloads/a b/audio.m4s")
        )
        assertEquals("/downloads/a b/audio.m4s", request.audio)
        assertNull(Media3Request.parse(arguments("/downloads/video.mp4") - "audio").audio)
    }

    @Test
    fun rejectsInvalidOrMpvOnlySources() {
        for (video in listOf(null, "", "edl://video;audio", "content://video", "relative/file", "https:///file")) {
            assertThrows(IllegalArgumentException::class.java) { Media3Request.parse(arguments(video)) }
        }
    }

    @Test
    fun rejectsInvalidPlaybackParametersAndHeaders() {
        for (override in listOf(
            mapOf("positionMs" to -1L),
            mapOf("positionMs" to 1.5),
            mapOf("positionMs" to Double.NaN),
            mapOf("speed" to Double.NaN),
            mapOf("speed" to 0),
            mapOf("headers" to mapOf("Referer" to "a\r\nInjected: true")),
            mapOf("headers" to mapOf("Referer" to 42)),
        )) {
            assertThrows(IllegalArgumentException::class.java) {
                Media3Request.parse(arguments() + override)
            }
        }
    }
}
