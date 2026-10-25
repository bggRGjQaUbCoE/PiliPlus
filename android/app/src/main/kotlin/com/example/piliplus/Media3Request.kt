package com.example.piliplus

import java.net.URI

internal data class Media3Request(
    val video: String,
    val audio: String?,
    val positionMs: Long,
    val speed: Float,
    val headers: Map<String, String>,
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
            return Media3Request(video, audio, position, speed, headers)
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
