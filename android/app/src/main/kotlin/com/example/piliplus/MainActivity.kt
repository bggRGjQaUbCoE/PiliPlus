package com.example.piliplus

import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.alexmercerind.media_kit_video.platformview.PlatformVideoView
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity : AudioServiceActivity() {
    private var renderingChannel: MethodChannel? = null
    private var selectedRenderMode: RenderMode? = null

    override fun getRenderMode(): RenderMode {
        selectedRenderMode?.let { return it }

        // This selects the host Flutter UI root surface only. The native video
        // Surface, hardware decoder, and PQ/HDR output path are unchanged.
        // Flutter plugins are registered before createFlutterView consumes
        // this choice, then the Activity keeps that choice for its lifetime.
        val renderMode = if (PlatformVideoView.requiresFlutterTextureView()) {
            RenderMode.texture
        } else {
            super.getRenderMode()
        }
        selectedRenderMode = renderMode
        return renderMode
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        renderingChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.piliplus/rendering",
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                if (call.method != "rootViewType") {
                    result.notImplemented()
                } else {
                    // Report the render mode selected for FlutterActivity's root
                    // surface. This is separate from media-kit video topology.
                    result.success(
                        when (selectedRenderMode) {
                            RenderMode.surface -> "SurfaceView"
                            RenderMode.texture -> "TextureView"
                            else -> "unknown"
                        }
                    )
                }
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        renderingChannel?.setMethodCallHandler(null)
        renderingChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
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
