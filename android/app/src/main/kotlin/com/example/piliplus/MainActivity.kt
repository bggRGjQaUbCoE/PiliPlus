package com.example.piliplus

import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.content.res.Configuration
import android.graphics.BitmapFactory
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Bundle
import android.view.WindowManager.LayoutParams
import androidx.core.net.toUri
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.SystemChrome
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "PiliPlus")
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "createShortcut" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        try {
                            val shortcutManager = context.getSystemService(ShortcutManager::class.java)
                            if (shortcutManager.isRequestPinShortcutSupported) {
                                val id = call.argument<String>("id")!!
                                val uri = call.argument<String>("uri")!!
                                val label = call.argument<String>("label")!!
                                val icon = call.argument<String>("icon")!!
                                val bitmap = BitmapFactory.decodeFile(icon)
                                val shortcut = ShortcutInfo.Builder(context, id).setShortLabel(label)
                                    .setIcon(Icon.createWithAdaptiveBitmap(bitmap))
                                    .setIntent(Intent(Intent.ACTION_VIEW, uri.toUri())).build()
                                val pinIntent = shortcutManager.createShortcutResultIntent(shortcut)
                                val pendingIntent = PendingIntent.getBroadcast(
                                    context, 0, pinIntent, PendingIntent.FLAG_IMMUTABLE
                                )
                                shortcutManager.requestPinShortcut(shortcut, pendingIntent.intentSender)
                            }
                        } catch (_: Exception) {
                        }
                    }
                }

                "SystemChrome.setEnabledSystemUIMode" -> {
                    SystemChrome.onMethodCall(
                        this, "SystemChrome.setEnabledSystemUIMode", call.argument("arguments")
                    )
                }

                "SystemChrome.setEnabledSystemUIOverlays" -> {
                    SystemChrome.onMethodCall(
                        this, "SystemChrome.setEnabledSystemUIOverlays", call.argument("arguments")
                    )
                }

                else -> result.notImplemented()
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
            window.attributes.layoutInDisplayCutoutMode = LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            try {
                AndroidHelper.isFoldable = packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_HINGE_ANGLE)
            } catch (_: Exception) {
            }
        }
    }

    override fun onDestroy() {
        stopService(Intent(this, com.ryanheise.audioservice.AudioService::class.java))
        super.onDestroy()
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        AndroidHelper.ToDart.onUserLeaveHint?.run()
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean, newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "floating").invokeMethod(
            "onPipChanged",
            isInPictureInPictureMode
        )
    }
}
