package com.example.piliplus

import androidx.media3.common.C
import androidx.media3.common.audio.AudioProcessor
import androidx.media3.common.audio.BaseAudioProcessor
import java.nio.ByteBuffer
import kotlin.math.abs
import kotlin.math.min

internal class AudioNormalizationProcessor : BaseAudioProcessor() {
    @Volatile
    private var configuration: AudioNormalizationConfiguration? = null
    private var appliedConfiguration: AudioNormalizationConfiguration? = null
    private var limiterGain = 1.0

    fun setConfiguration(configuration: AudioNormalizationConfiguration?) {
        this.configuration = configuration
    }

    override fun onConfigure(inputAudioFormat: AudioProcessor.AudioFormat): AudioProcessor.AudioFormat {
        if (inputAudioFormat.encoding != C.ENCODING_PCM_16BIT &&
            inputAudioFormat.encoding != C.ENCODING_PCM_FLOAT
        ) {
            throw AudioProcessor.UnhandledAudioFormatException(inputAudioFormat)
        }
        return inputAudioFormat
    }

    override fun isActive(): Boolean = super.isActive()

    override fun queueInput(inputBuffer: ByteBuffer) {
        if (!inputBuffer.hasRemaining()) return
        val outputBuffer = replaceOutputBuffer(inputBuffer.remaining())
        val activeConfiguration = configuration
        if (activeConfiguration !== appliedConfiguration) {
            appliedConfiguration = activeConfiguration
            limiterGain = activeConfiguration?.gain ?: 1.0
        }
        if (activeConfiguration == null) {
            outputBuffer.put(inputBuffer)
            outputBuffer.flip()
            return
        }
        val channels = inputAudioFormat.channelCount
        val frame = DoubleArray(channels)
        val releaseStep = (activeConfiguration.gain / inputAudioFormat.sampleRate / RELEASE_SECONDS)
            .coerceAtLeast(0.0)
        while (inputBuffer.hasRemaining()) {
            var framePeak = 0.0
            repeat(channels) { channel ->
                frame[channel] = when (inputAudioFormat.encoding) {
                    C.ENCODING_PCM_16BIT -> inputBuffer.short / 32768.0
                    C.ENCODING_PCM_FLOAT -> inputBuffer.float.toDouble()
                    else -> error("Unexpected PCM encoding: ${inputAudioFormat.encoding}")
                }
                framePeak = maxOf(framePeak, abs(frame[channel]))
            }
            val peakLimitedGain = if (framePeak == 0.0) {
                activeConfiguration.gain
            } else {
                min(activeConfiguration.gain, activeConfiguration.peak / framePeak)
            }
            limiterGain = if (peakLimitedGain < limiterGain) {
                peakLimitedGain
            } else {
                min(peakLimitedGain, limiterGain + releaseStep)
            }
            repeat(channels) { channel ->
                val processed = frame[channel] * limiterGain
                when (inputAudioFormat.encoding) {
                    C.ENCODING_PCM_16BIT -> outputBuffer.putShort(
                        (processed * 32767.0).toInt()
                            .coerceIn(Short.MIN_VALUE.toInt(), Short.MAX_VALUE.toInt())
                            .toShort(),
                    )
                    C.ENCODING_PCM_FLOAT -> outputBuffer.putFloat(processed.toFloat())
                }
            }
        }
        outputBuffer.flip()
    }

    override fun onFlush() {
        appliedConfiguration = configuration
        limiterGain = appliedConfiguration?.gain ?: 1.0
    }

    override fun onReset() {
        appliedConfiguration = configuration
        limiterGain = appliedConfiguration?.gain ?: 1.0
    }

    companion object {
        private const val RELEASE_SECONDS = 0.08
    }
}

internal data class AudioNormalizationConfiguration(
    val gain: Double,
    val peak: Double,
    val filter: String?,
) {
    init {
        require(gain.isFinite() && gain >= 0.0) { "Invalid normalization gain: $gain" }
        require(peak.isFinite() && peak in 0.0..1.0) { "Invalid normalization peak: $peak" }
    }

    companion object {
        fun fromMap(map: Map<*, *>?): AudioNormalizationConfiguration? {
            if (map == null) return null
            return AudioNormalizationConfiguration(
                gain = (map["gain"] as? Number)?.toDouble()
                    ?: error("Missing audio normalization gain"),
                peak = (map["peak"] as? Number)?.toDouble()
                    ?: error("Missing audio normalization peak"),
                filter = map["filter"] as? String,
            )
        }
    }
}
