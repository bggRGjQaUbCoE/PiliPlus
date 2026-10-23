package com.example.piliplus

import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.RenderMode
import com.alexmercerind.media_kit_video.platformview.PlatformVideoView
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity : AudioServiceActivity() {
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
