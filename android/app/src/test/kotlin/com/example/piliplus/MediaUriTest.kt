package com.example.piliplus

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class MediaUriTest {
    @Test
    fun plainFilePathNeedsFileUri() {
        assertTrue(needsFileUri("/sdcard/Movies/video.mp4"))
    }

    @Test
    fun httpUrlStaysHttp() {
        assertFalse(needsFileUri("https://example.com/media/video.m3u8"))
    }

    @Test
    fun contentUriStaysContent() {
        assertFalse(needsFileUri("content://media/external/video/42"))
    }
}