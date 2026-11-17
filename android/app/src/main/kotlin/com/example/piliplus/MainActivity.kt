package com.example.piliplus

import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.WindowManager.LayoutParams
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.piliplus/theme")
            .setMethodCallHandler { call, result ->
                if (call.method != "getSystemColorRoles") {
                    result.notImplemented()
                } else if (Build.VERSION.SDK_INT < 34) {
                    result.success(null)
                } else {
                    // Android 14 exposes the resolved Material roles used by
                    // Weeko, including OEM/user contrast adjustments.
                    val roles = listOf(
                        "primary", "on_primary", "primary_container", "on_primary_container",
                        "secondary", "on_secondary", "secondary_container", "on_secondary_container",
                        "tertiary", "on_tertiary", "tertiary_container", "on_tertiary_container",
                        "surface", "surface_dim", "surface_bright", "surface_container_lowest",
                        "surface_container_low", "surface_container", "surface_container_high",
                        "surface_container_highest", "on_surface", "on_surface_variant",
                        "outline", "outline_variant",
                    )
                    result.success(listOf("light", "dark").associateWith { mode ->
                        roles.associateWith { role ->
                            val id = resources.getIdentifier("system_${role}_$mode", "color", "android")
                            resources.getColor(id, null)
                        }
                    })
                }
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
