package com.example.piliplus

import androidx.media3.common.C
import androidx.media3.common.audio.AudioProcessor
import androidx.media3.common.audio.BaseAudioProcessor
import java.nio.ByteBuffer
import kotlin.math.abs
import kotlin.math.min
import kotlin.math.pow
import kotlin.math.sqrt

internal class AudioNormalizationProcessor : BaseAudioProcessor() {
    @Volatile
    private var configuration: AudioNormalizationConfiguration? = null
    private var appliedConfiguration: AudioNormalizationConfiguration? = null
    private var limiterGain = 1.0
    private var dynamicGain = 1.0
    private var rmsSum = 0.0
    private var rmsFrames = 0

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
        val outputBuffer = replaceOutputBuffer(inputBuffer.remaining()).order(inputBuffer.order())
        val activeConfiguration = configuration
        if (activeConfiguration !== appliedConfiguration) {
            resetState(activeConfiguration)
        }
        if (activeConfiguration == null) {
            outputBuffer.put(inputBuffer)
            outputBuffer.flip()
            return
        }
        val channels = inputAudioFormat.channelCount
        val sampleRate = inputAudioFormat.sampleRate
        val frame = DoubleArray(channels)
        val windowFrames = if (activeConfiguration.dynamic) {
            maxOf(1, activeConfiguration.frameMs * sampleRate / 1000)
        } else {
            Int.MAX_VALUE
        }
        val releaseStep = (activeConfiguration.gain / sampleRate / RELEASE_SECONDS).coerceAtLeast(0.0)
        while (inputBuffer.hasRemaining()) {
            var framePeak = 0.0
            var frameSumSquares = 0.0
            repeat(channels) { channel ->
                frame[channel] = when (inputAudioFormat.encoding) {
                    C.ENCODING_PCM_16BIT -> inputBuffer.short / 32768.0
                    C.ENCODING_PCM_FLOAT -> inputBuffer.float.toDouble()
                    else -> error("Unexpected PCM encoding: ${inputAudioFormat.encoding}")
                }
                framePeak = maxOf(framePeak, abs(frame[channel]))
                frameSumSquares += frame[channel] * frame[channel]
            }
            var effectiveGain = activeConfiguration.gain
            if (activeConfiguration.dynamic) {
                rmsSum += frameSumSquares
                rmsFrames += 1
                if (rmsFrames >= windowFrames) {
                    val rms = sqrt(rmsSum / (rmsFrames * channels))
                    val targetLevel = 10.0.pow(activeConfiguration.targetRmsDb / 20.0)
                    val desired = if (rms > 0.0) {
                        (targetLevel / rms).coerceIn(MIN_DYNAMIC_GAIN, activeConfiguration.maxGain)
                    } else {
                        activeConfiguration.maxGain
                    }
                    dynamicGain += (desired - dynamicGain) * activeConfiguration.smoothing.coerceIn(0.001, 1.0)
                    rmsSum = 0.0
                    rmsFrames = 0
                }
                effectiveGain = dynamicGain
            }
            val peakLimitedGain = if (framePeak == 0.0) {
                effectiveGain
            } else {
                min(effectiveGain, activeConfiguration.peak / framePeak)
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
        resetState(configuration)
    }

    override fun onReset() {
        resetState(configuration)
    }

    private fun resetState(configuration: AudioNormalizationConfiguration?) {
        appliedConfiguration = configuration
        limiterGain = configuration?.gain ?: 1.0
        dynamicGain = configuration?.gain ?: 1.0
        rmsSum = 0.0
        rmsFrames = 0
    }

    companion object {
        private const val RELEASE_SECONDS = 0.08
        private const val MIN_DYNAMIC_GAIN = 0.01
    }
}

internal data class AudioNormalizationConfiguration(
    val gain: Double = 1.0,
    val peak: Double = 1.0,
    val filter: String? = null,
    val dynamic: Boolean = false,
    val targetRmsDb: Double = -16.0,
    val maxGain: Double = 10.0,
    val frameMs: Int = 1000,
    val smoothing: Double = 0.5,
) {
    init {
        require(gain.isFinite() && gain >= 0.0) { "Invalid normalization gain: $gain" }
        require(peak.isFinite() && peak in 0.0..1.0) { "Invalid normalization peak: $peak" }
        require(targetRmsDb.isFinite()) { "Invalid normalization target: $targetRmsDb" }
        require(maxGain.isFinite() && maxGain >= 1.0) { "Invalid normalization max gain: $maxGain" }
        require(frameMs > 0) { "Invalid normalization frame: $frameMs" }
        require(smoothing.isFinite() && smoothing in 0.0..1.0) {
            "Invalid normalization smoothing: $smoothing"
        }
    }

    companion object {
        fun fromMap(map: Map<*, *>?): AudioNormalizationConfiguration? {
            if (map == null) return null
            return AudioNormalizationConfiguration(
                gain = (map["gain"] as? Number)?.toDouble() ?: 1.0,
                peak = (map["peak"] as? Number)?.toDouble() ?: 1.0,
                filter = map["filter"] as? String,
                dynamic = (map["dynamic"] as? Boolean) ?: false,
                targetRmsDb = (map["targetRmsDb"] as? Number)?.toDouble() ?: -16.0,
                maxGain = (map["maxGain"] as? Number)?.toDouble() ?: 10.0,
                frameMs = (map["frameMs"] as? Number)?.toInt() ?: 1000,
                smoothing = (map["smoothing"] as? Number)?.toDouble() ?: 0.5,
            )
        }
    }
}