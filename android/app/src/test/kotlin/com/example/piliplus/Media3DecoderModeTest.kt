package com.example.piliplus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class Media3DecoderModeTest {
    @Test
    fun noModeSelectsSoftwareVideoDecoders() {
        val result = resolveMedia3DecoderMode("no", enableHardwareDecoding = true)

        assertTrue(!result.useHardwareDecoder)
        assertEquals("no (software)", result.description)
    }

    @Test
    fun androidMediaCodecModesSelectHardwareDecoding() {
        for (mode in listOf("mediacodec", "mediacodec-copy", "auto", "auto-safe", "auto-copy")) {
            val result = resolveMedia3DecoderMode(mode, enableHardwareDecoding = true)

            assertTrue("$mode should select hardware decoding", result.useHardwareDecoder)
            assertTrue(result.description.contains("MediaCodec"))
        }
    }

    @Test
    fun disabledHardwarePreferenceWinsOverRequestedMode() {
        val result = resolveMedia3DecoderMode("mediacodec", enableHardwareDecoding = false)

        assertTrue(!result.useHardwareDecoder)
        assertEquals("no (software)", result.description)
    }

    @Test
    fun unsupportedPlatformModeIsReportedAndUsesAndroidDefault() {
        val result = resolveMedia3DecoderMode("vaapi", enableHardwareDecoding = true)

        assertTrue(result.useHardwareDecoder)
        assertTrue(result.description.contains("unsupported on Android"))
    }

    @Test
    fun modeListUsesFirstAndroidSupportedCandidate() {
        val result = resolveMedia3DecoderMode(
            "nvdec,auto-safe",
            enableHardwareDecoding = true,
        )

        assertEquals("auto-safe (MediaCodec)", result.description)
    }
}
