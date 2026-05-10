package com.example.piliplus

import android.app.PendingIntent
import android.app.PictureInPictureParams
import android.app.SearchManager
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.content.res.Configuration
import android.graphics.BitmapFactory
import android.graphics.Point
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.provider.Settings
import android.view.WindowManager.LayoutParams
import androidx.core.net.toUri
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.roundToInt
import kotlin.system.exitProcess
import java.io.File

class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "PiliPlus")
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "back" -> back();

                "linkVerifySettings" -> {
                    val uri = ("package:" + context.packageName).toUri()
                    try {
                        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            Intent(Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS, uri)
                        } else {
                            Intent("android.intent.action.MAIN", uri).setClassName(
                                "com.android.settings",
                                "com.android.settings.applications.InstalledAppOpenByDefaultActivity"
                            )
                        }
                        context.startActivity(intent)
                    } catch (_: Throwable) {
                        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, uri)
                        context.startActivity(intent)
                    }
                }

                "music" -> {
                    val title = call.argument<String>("title")
                    val intent = Intent(MediaStore.INTENT_ACTION_MEDIA_SEARCH).apply {
                        putExtra(SearchManager.QUERY, title)
                        putExtra(MediaStore.EXTRA_MEDIA_TITLE, title)
                        call.argument<String?>("artist")
                            ?.let { putExtra(MediaStore.EXTRA_MEDIA_ARTIST, it) }
                        call.argument<String?>("album")
                            ?.let { putExtra(MediaStore.EXTRA_MEDIA_ALBUM, it) }

                        addCategory(Intent.CATEGORY_DEFAULT)
                    }
                    try {
                        if (packageManager.resolveActivity(
                                intent,
                                PackageManager.MATCH_DEFAULT_ONLY
                            ) != null
                        ) {
                            startActivity(intent)
                            result.success(true)
                            return@setMethodCallHandler
                        }
                    } catch (_: Throwable) {
                    }
                    try {
                        intent.action = MediaStore.INTENT_ACTION_MEDIA_PLAY_FROM_SEARCH
                        if (packageManager.resolveActivity(
                                intent,
                                PackageManager.MATCH_DEFAULT_ONLY
                            ) != null
                        ) {
                            startActivity(intent)
                            result.success(true)
                            return@setMethodCallHandler
                        }
                    } catch (_: Throwable) {
                    }
                    result.success(false)
                }

                "createShortcut" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        try {
                            val shortcutManager =
                                context.getSystemService(ShortcutManager::class.java)
                            if (shortcutManager.isRequestPinShortcutSupported) {
                                val id = call.argument<String>("id")!!
                                val uri = call.argument<String>("uri")!!
                                val label = call.argument<String>("label")!!
                                val icon = call.argument<String>("icon")!!
                                val bitmap = BitmapFactory.decodeFile(icon)
                                val shortcut =
                                    ShortcutInfo.Builder(context, id)
                                        .setShortLabel(label)
                                        .setIcon(Icon.createWithAdaptiveBitmap(bitmap))
                                        .setIntent(Intent(Intent.ACTION_VIEW, uri.toUri()))
                                        .build()
                                val pinIntent =
                                    shortcutManager.createShortcutResultIntent(shortcut)
                                val pendingIntent = PendingIntent.getBroadcast(
                                    context, 0, pinIntent, PendingIntent.FLAG_IMMUTABLE
                                )
                                shortcutManager.requestPinShortcut(
                                    shortcut,
                                    pendingIntent.intentSender
                                )
                            }
                        } catch (e: Exception) {
                        }
                    }
                }

                "sdkInt" -> {
                    result.success(Build.VERSION.SDK_INT)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun back() {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(intent)
    }

    override fun onDestroy() {
        stopService(Intent(this, com.ryanheise.audioservice.AudioService::class.java))
        super.onDestroy()
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            "floating"
        ).invokeMethod("onPipChanged", isInPictureInPictureMode)
    }
}
