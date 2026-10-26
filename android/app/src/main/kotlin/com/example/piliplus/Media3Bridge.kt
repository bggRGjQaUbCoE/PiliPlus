package com.example.piliplus

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Bundle
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class Media3Bridge(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "com.example.piliplus/media3")
    private var pending: MethodChannel.Result? = null

    init {
        channel.setMethodCallHandler(::handle)
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "open" -> {
                if (pending != null) {
                    result.error("busy", "Media3 is already open", null)
                    return
                }
                val request = try {
                    Media3Request.parse(call.arguments)
                } catch (error: IllegalArgumentException) {
                    result.error("invalid_source", error.message, null)
                    return
                } catch (error: java.net.URISyntaxException) {
                    result.error("invalid_source", error.message, null)
                    return
                }
                val headers = Bundle().apply {
                    request.headers.forEach { (key, value) -> putString(key, value) }
                }
                val intent = Intent(activity, Media3PlayerActivity::class.java)
                    .putExtra("video", request.video)
                    .putExtra("audio", request.audio)
                    .putExtra("positionMs", request.positionMs)
                    .putExtra("speed", request.speed)
                    .putExtra("headers", headers)
                    .putExtra("title", request.title)
                    .putExtra("speeds", request.speeds)
                    .putExtra("seekStepMs", request.seekStepMs)
                    .putExtra("controlsTimeoutMs", request.controlsTimeoutMs)
                    .putExtra("quickDoubleTap", request.quickDoubleTap)
                    .putExtra("longPressSpeed", request.longPressSpeed)
                    .putExtra("accentColor", request.accentColor)
                Media3PlayerActivity.resetRequests()
                pending = result
                try {
                    activity.startActivityForResult(intent, REQUEST_CODE)
                } catch (error: ActivityNotFoundException) {
                    pending = null
                    result.error("unavailable", error.message, null)
                } catch (error: SecurityException) {
                    pending = null
                    result.error("unavailable", error.message, null)
                }
            }
            "close" -> {
                if (pending != null) Media3PlayerActivity.closePlayer()
                result.success(null)
            }
            "pause" -> {
                if (pending != null) Media3PlayerActivity.pausePlayer()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE) return false
        val result = pending
        pending = null
        if (resultCode != Activity.RESULT_OK || data == null) {
            result?.error("cancelled", "Native player closed without a playback result", null)
        } else {
            result?.success(
                mapOf(
                    "positionMs" to data.getLongExtra("positionMs", 0),
                    "durationMs" to data.getLongExtra("durationMs", 0),
                    "speed" to data.getFloatExtra("speed", 1f).toDouble(),
                    "completed" to data.getBooleanExtra("completed", false),
                    "error" to data.getStringExtra("error"),
                )
            )
        }
        return true
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        if (pending != null) Media3PlayerActivity.closePlayer()
        pending?.error("detached", "Flutter activity was destroyed", null)
        pending = null
    }

    companion object {
        private const val REQUEST_CODE = 5035
    }
}
