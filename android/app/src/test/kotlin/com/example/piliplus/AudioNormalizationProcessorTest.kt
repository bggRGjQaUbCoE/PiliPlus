package com.example.piliplus

import androidx.media3.common.C
import androidx.media3.common.audio.AudioProcessor
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlin.math.abs
import kotlin.math.max
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Assert.assertThrows
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

    @Test
    fun highpassSuppressesConstantSignal() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(gain = 1.0, highpassHz = 200.0),
        )
        val input = ByteBuffer.allocate(8000 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(8000) { input.putShort((0.5 * 32767).toInt().toShort()) }
        input.flip()
        processor.queueInput(input)

        val samples = mutableListOf<Int>()
        var output = processor.getOutput()
        while (output != null && output.hasRemaining()) {
            while (output.hasRemaining()) {
                samples += output.short.toInt()
            }
            output = processor.getOutput()
        }
        val settledPeak = samples.drop(7000).maxOf { abs(it) }
        assertTrue("highpass should remove DC after settling", settledPeak < 4000)
    }

    @Test
    fun lowpassSuppressesHighFrequencyAlternation() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(gain = 1.0, lowpassHz = 200.0),
        )
        val input = ByteBuffer.allocate(8000 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(8000) { index ->
            input.putShort(if (index % 2 == 0) 16000.toShort() else (-16000).toShort())
        }
        input.flip()
        processor.queueInput(input)

        val samples = mutableListOf<Int>()
        var output = processor.getOutput()
        while (output != null && output.hasRemaining()) {
            while (output.hasRemaining()) samples += output.short.toInt()
            output = processor.getOutput()
        }
        val settledPeak = samples.drop(7000).maxOf { abs(it) }
        assertTrue("lowpass should attenuate high frequency signal", settledPeak < 2500)
    }

    @Test
    fun equalizerBoostsToneWithoutClipping() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(
                gain = 1.0,
                peak = 1.0,
                equalizerFrequencyHz = 1000.0,
                equalizerGainDb = 6.0,
                equalizerQ = 1.0,
            ),
        )
        val input = ByteBuffer.allocate(8000 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(8000) { index ->
            val sample = (0.1 * 32767.0 * kotlin.math.sin(2.0 * Math.PI * 1000.0 * index / 8000.0)).toInt()
            input.putShort(sample.toShort())
        }
        input.flip()
        processor.queueInput(input)

        val samples = mutableListOf<Int>()
        var output = processor.getOutput()
        while (output != null && output.hasRemaining()) {
            while (output.hasRemaining()) samples += output.short.toInt()
            output = processor.getOutput()
        }
        val inputPeak = (0.1 * 32767.0).toInt()
        val settledPeak = samples.drop(7000).maxOf { abs(it) }
        assertTrue("equalizer should boost the configured tone", settledPeak > inputPeak * 1.5)
        assertTrue("equalizer output must not clip", settledPeak <= Short.MAX_VALUE.toInt())
    }

    @Test
    fun multipleEqualizerBandsAreAppliedInSequence() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(
                gain = 1.0,
                peak = 1.0,
                equalizerBands = listOf(
                    EqualizerBand(1000.0, 6.0, 1.0),
                    EqualizerBand(1000.0, 6.0, 1.0),
                ),
            ),
        )
        val input = ByteBuffer.allocate(8000 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(8000) { index ->
            val sample = (0.05 * 32767.0 * kotlin.math.sin(2.0 * Math.PI * 1000.0 * index / 8000.0)).toInt()
            input.putShort(sample.toShort())
        }
        input.flip()
        processor.queueInput(input)

        val samples = mutableListOf<Int>()
        var output = processor.getOutput()
        while (output != null && output.hasRemaining()) {
            while (output.hasRemaining()) samples += output.short.toInt()
            output = processor.getOutput()
        }
        val inputPeak = (0.05 * 32767.0).toInt()
        val settledPeak = samples.drop(7000).maxOf { abs(it) }
        assertTrue("two equalizer bands should be applied", settledPeak > inputPeak * 2.0)
        assertTrue("equalizer output must not clip", settledPeak <= Short.MAX_VALUE.toInt())
    }

    @Test
    fun lowShelfBoostsLowFrequencyTone() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(
                gain = 1.0,
                peak = 1.0,
                equalizerBands = listOf(EqualizerBand(800.0, 6.0, 1.0, "lowshelf")),
            ),
        )
        val input = ByteBuffer.allocate(8000 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(8000) { index ->
            val sample = (0.1 * 32767.0 * kotlin.math.sin(2.0 * Math.PI * 100.0 * index / 8000.0)).toInt()
            input.putShort(sample.toShort())
        }
        input.flip()
        processor.queueInput(input)

        val samples = mutableListOf<Int>()
        var output = processor.getOutput()
        while (output != null && output.hasRemaining()) {
            while (output.hasRemaining()) samples += output.short.toInt()
            output = processor.getOutput()
        }
        val inputPeak = (0.1 * 32767.0).toInt()
        val settledPeak = samples.drop(7000).maxOf { abs(it) }
        assertTrue("low shelf should boost low frequencies", settledPeak > inputPeak * 1.4)
        assertTrue("low shelf output must not clip", settledPeak <= Short.MAX_VALUE.toInt())
    }

    @Test
    fun highShelfBoostsHighFrequencyTone() {
        val processor = newProcessor(
            AudioNormalizationConfiguration(
                gain = 1.0,
                peak = 1.0,
                equalizerBands = listOf(EqualizerBand(1200.0, 6.0, 1.0, "highshelf")),
            ),
        )
        val input = ByteBuffer.allocate(8000 * 2).order(ByteOrder.BIG_ENDIAN)
        repeat(8000) { index ->
            val sample = (0.1 * 32767.0 * kotlin.math.sin(2.0 * Math.PI * 3000.0 * index / 8000.0)).toInt()
            input.putShort(sample.toShort())
        }
        input.flip()
        processor.queueInput(input)

        val samples = mutableListOf<Int>()
        var output = processor.getOutput()
        while (output != null && output.hasRemaining()) {
            while (output.hasRemaining()) samples += output.short.toInt()
            output = processor.getOutput()
        }
        val inputPeak = (0.1 * 32767.0).toInt()
        val settledPeak = samples.drop(7000).maxOf { abs(it) }
        assertTrue("high shelf should boost high frequencies", settledPeak > inputPeak * 1.4)
        assertTrue("high shelf output must not clip", settledPeak <= Short.MAX_VALUE.toInt())
    }

    @Test
    fun configurationReadsMultipleEqualizerBandsFromMethodChannelMap() {
        val configuration = AudioNormalizationConfiguration.fromMap(
            mapOf(
                "equalizerBands" to listOf(
                    mapOf("frequencyHz" to 500.0, "gainDb" to 3.0, "q" to 0.8),
                    mapOf("frequencyHz" to 2000.0, "gainDb" to -2.0, "q" to 1.4),
                ),
            ),
        )

        assertEquals(2, configuration?.equalizerBands?.size)
        assertEquals(500.0, configuration?.equalizerBands?.first()?.frequencyHz ?: 0.0, 0.0)
        assertEquals(-2.0, configuration?.equalizerBands?.last()?.gainDb ?: 0.0, 0.0)
    }

    @Test
    fun equalizerConfigurationRequiresCompleteParameters() {
        assertThrows(IllegalArgumentException::class.java) {
            AudioNormalizationConfiguration(
                equalizerFrequencyHz = 1000.0,
                equalizerGainDb = 3.0,
            )
        }
    }

    @Test
    fun configurationReadsEqualizerTypeFromMethodChannelMap() {
        val configuration = AudioNormalizationConfiguration.fromMap(
            mapOf(
                "equalizerBands" to listOf(
                    mapOf("frequencyHz" to 500.0, "gainDb" to 3.0, "q" to 0.8, "type" to "highshelf"),
                ),
            ),
        )

        assertEquals("highshelf", configuration?.equalizerBands?.single()?.type)
    }
}
