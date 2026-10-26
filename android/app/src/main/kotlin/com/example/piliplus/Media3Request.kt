package com.example.piliplus

import java.net.URI

internal data class Media3Request(
    val video: String,
    val audio: String?,
    val positionMs: Long,
    val speed: Float,
    val headers: Map<String, String>,
    val title: String,
    val speeds: FloatArray,
    val seekStepMs: Long,
    val controlsTimeoutMs: Int,
    val quickDoubleTap: Boolean,
    val longPressSpeed: Float,
    val accentColor: Int,
) {
    companion object {
        fun parse(arguments: Any?): Media3Request {
            require(arguments is Map<*, *>) { "Missing Media3 arguments" }
            val video = source(arguments["video"])
            val audio = arguments["audio"]?.let(::source)
            val rawPosition = arguments["positionMs"]
            require(rawPosition is Int || rawPosition is Long) { "Invalid playback position" }
            val position = (rawPosition as Number).toLong()
            require(position >= 0) { "Invalid playback position" }
            val speed = (arguments["speed"] as? Number)?.toFloat()
            require(speed != null && speed.isFinite() && speed > 0) { "Invalid playback speed" }
            val rawHeaders = arguments["headers"]
            require(rawHeaders is Map<*, *>) { "Missing HTTP headers" }
            val headers = rawHeaders.entries.associate { (key, value) ->
                require(key is String && value is String) { "Invalid HTTP header" }
                require(!key.contains('\r') && !key.contains('\n') &&
                    !value.contains('\r') && !value.contains('\n')) { "Invalid HTTP header" }
                key to value
            }
            val title = arguments["title"]
            require(title is String) { "Invalid media title" }
            val rawSpeeds = arguments["speeds"]
            require(rawSpeeds is List<*>) { "Missing playback speeds" }
            val speeds = rawSpeeds.map {
                val value = (it as? Number)?.toFloat()
                require(value != null && value.isFinite() && value > 0) { "Invalid playback speed option" }
                value
            }.distinct().toFloatArray()
            val seekStep = arguments["seekStepMs"]
            require(seekStep is Int || seekStep is Long) { "Invalid seek step" }
            val seekStepMs = (seekStep as Number).toLong()
            require(seekStepMs > 0) { "Invalid seek step" }
            val timeout = arguments["controlsTimeoutMs"]
            require(timeout is Int && timeout > 0) { "Invalid controls timeout" }
            val quickDoubleTap = arguments["quickDoubleTap"]
            require(quickDoubleTap is Boolean) { "Invalid double-tap preference" }
            val longPressSpeed = (arguments["longPressSpeed"] as? Number)?.toFloat()
            // Zero means twice the current speed, matching mpv's automatic boost.
            require(longPressSpeed != null && longPressSpeed.isFinite() && longPressSpeed >= 0) {
                "Invalid long-press speed"
            }
            val accentColor = arguments["accentColor"]
            require(accentColor is Int || accentColor is Long) { "Invalid accent color" }
            return Media3Request(
                video, audio, position, speed, headers, title, speeds, seekStepMs,
                timeout, quickDoubleTap, longPressSpeed, (accentColor as Number).toInt(),
            )
        }

        private fun source(value: Any?): String {
            require(value is String && value.isNotBlank()) { "Missing media source" }
            // Downloaded files are app-local absolute paths, not mpv EDL URLs.
            if (value.startsWith('/')) return value
            val uri = URI(value)
            require(uri.scheme in listOf("https", "http") && !uri.host.isNullOrEmpty()) {
                "Media3 requires an HTTP(S) URL or an absolute local path"
            }
            return value
        }
    }
}
