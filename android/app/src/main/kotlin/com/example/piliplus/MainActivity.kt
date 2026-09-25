package com.example.piliplus

import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.WindowManager.LayoutParams
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.roundToInt

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val DISPLAY_CUTOUT_CHANNEL = "com.example.piliplus/display_cutout"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DISPLAY_CUTOUT_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "bounds" -> result.success(displayCutoutBounds())
                else -> result.notImplemented()
            }
        }
    }

    private fun displayCutoutBounds(): List<Map<String, Int>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) return emptyList()
        val insets = window.decorView.rootWindowInsets ?: return emptyList()
        val cutout = insets.displayCutout ?: return emptyList()
        val density = resources.displayMetrics.density
        return cutout.boundingRects.map { rect ->
            mapOf(
                "left" to (rect.left / density).roundToInt(),
                "top" to (rect.top / density).roundToInt(),
                "right" to (rect.right / density).roundToInt(),
                "bottom" to (rect.bottom / density).roundToInt(),
            )
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        if (AndroidHelper.isFoldable) {
            AndroidHelper.ToDart.onConfigurationChanged?.run()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            window.attributes.layoutInDisplayCutoutMode =
                LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        AndroidHelper.ToDart.onUserLeaveHint?.run()
    }

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration?) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        AndroidHelper.isPipMode = isInPictureInPictureMode
    }
}
