package com.example.piliplus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertArrayEquals
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
        "title" to "Video title",
        "speeds" to listOf(0.75, 1.0, 1.5, 2.5),
        "seekStepMs" to 15000,
        "controlsTimeoutMs" to 30000,
        "quickDoubleTap" to false,
        "longPressSpeed" to 0.0,
        "accentColor" to 0xFFABCDEF,
    )

    @Test
    fun preservesSeparateStreamsAndResumeParameters() {
        val request = Media3Request.parse(arguments())
        assertEquals("https://video.example/video.m4s", request.video)
        assertEquals("https://audio.example/audio.m4s", request.audio)
        assertEquals(12345L, request.positionMs)
        assertEquals(1.5f, request.speed)
        assertEquals("https://www.bilibili.com", request.headers["Referer"])
        assertEquals("Video title", request.title)
        assertArrayEquals(floatArrayOf(0.75f, 1f, 1.5f, 2.5f), request.speeds, 0f)
        assertEquals(15000L, request.seekStepMs)
        assertEquals(30000, request.controlsTimeoutMs)
        assertEquals(false, request.quickDoubleTap)
        assertEquals(0f, request.longPressSpeed)
        assertEquals(0xFFABCDEF.toInt(), request.accentColor)
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

    @Test
    fun acceptsEmptySpeedMenuAndDeduplicatesOptions() {
        assertEquals(0, Media3Request.parse(arguments() + ("speeds" to emptyList<Double>())).speeds.size)
        assertArrayEquals(
            floatArrayOf(1f, 2f),
            Media3Request.parse(arguments() + ("speeds" to listOf(1, 2.0, 1.0))).speeds,
            0f,
        )
    }

    @Test
    fun rejectsInvalidControlPreferences() {
        for (override in listOf(
            mapOf("title" to 42),
            mapOf("speeds" to null),
            mapOf("speeds" to listOf(0.0)),
            mapOf("speeds" to listOf(Double.POSITIVE_INFINITY)),
            mapOf("speeds" to listOf("1")),
            mapOf("seekStepMs" to 0),
            mapOf("seekStepMs" to -1000),
            mapOf("seekStepMs" to 1.5),
            mapOf("controlsTimeoutMs" to -1),
            mapOf("controlsTimeoutMs" to Long.MAX_VALUE),
            mapOf("quickDoubleTap" to "false"),
            mapOf("longPressSpeed" to -1),
            mapOf("longPressSpeed" to Double.NaN),
            mapOf("accentColor" to "white"),
        )) {
            assertThrows(IllegalArgumentException::class.java) {
                Media3Request.parse(arguments() + override)
            }
        }
    }
}
