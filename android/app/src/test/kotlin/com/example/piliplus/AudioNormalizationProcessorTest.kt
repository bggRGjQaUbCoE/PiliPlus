package com.example.piliplus

import androidx.media3.common.C
import androidx.media3.common.audio.AudioProcessor
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlin.math.abs
import kotlin.math.max
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class AudioNormalizationProcessorTest {
    private val format = AudioProcessor.AudioFormat(8000, 1, C.ENCODING_PCM_16BIT)

    private fun newProcessor(configuration: AudioNormalizationConfiguration?): AudioNormalizationProcessor {
        val processor = AudioNormalizationProcessor()
        processor.configure(format)
        processor.flush()
        processor.setConfiguration(configuration)
        return processor
    }

    private fun readPeak(processor: AudioNormalizationProcessor): Int {
        var peak = 0
        var output = processor.getOutput()
        while (output != null && output.hasRemaining()) {
            while (output.hasRemaining()) {
                peak = max(peak, abs(output.short.toInt()))
            }
            output = processor.getOutput()
        }
        return peak
    }

    @Test
    fun dynamicNormalizationRaisesQuietAudioTowardTarget() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(
                gain = 1.0,
                peak = 1.0,
                filter = "dynaudnorm=g=5:f=50:r=1.0:p=0.5",
                dynamic = true,
                targetRmsDb = -16.0,
                maxGain = 10.0,
                frameMs = 50,
                smoothing = 1.0,
            ),
        )
        val input = ByteBuffer.allocate(8000 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(8000) { input.putShort(((0.01 * 32767).toInt()).toShort()) }
        input.flip()
        processor.queueInput(input)

        val peak = readPeak(processor)
        assertTrue("quiet audio should be amplified", peak > 2000)
        assertTrue("output must never clip", peak <= Short.MAX_VALUE.toInt())
    }

    @Test
    fun staticConfigurationAppliesGainAndTruePeakLimit() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(gain = 2.0, peak = 1.0),
        )
        val input = ByteBuffer.allocate(800 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(800) { input.putShort(((0.8 * 32767).toInt()).toShort()) }
        input.flip()
        processor.queueInput(input)

        val peak = readPeak(processor)
        assertTrue("0.8 amplitude with gain 2 must be peak-limited near full scale", peak > 31000)
        assertTrue("output must never clip", peak <= Short.MAX_VALUE.toInt())
    }

    @Test
    fun disabledNormalizationCopiesSamplesUnchanged() {
        val processor = newProcessor(null)
        val input = ByteBuffer.allocate(4 * 2).order(ByteOrder.BIG_ENDIAN)
        input.putShort(1234.toShort()).putShort((-5678).toShort())
        input.flip()
        processor.queueInput(input)
        val output = processor.getOutput()
        assertEquals(1234, output.short.toInt())
        assertEquals(-5678, output.short.toInt())
    }
}