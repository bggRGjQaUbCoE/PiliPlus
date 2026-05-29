package com.example.piliplus

import android.app.PictureInPictureParams
import android.app.SearchManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Point
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.Settings
import android.view.WindowManager
import androidx.annotation.Keep
import com.github.dart_lang.jni_flutter.JniFlutterPlugin
import kotlin.math.roundToInt

@Keep
class AndroidHelper private constructor() {
    @Keep
    class ToDart private constructor() {
        companion object {
            @JvmStatic
            var onUserLeaveHint: Runnable? = null

            @JvmStatic
            var onConfigurationChanged: Runnable? = null
        }
    }

    companion object {
        @JvmStatic
        private val context: Context
            get() = JniFlutterPlugin.getApplicationContext()

        @JvmStatic
        var isFoldable: Boolean = false

        @JvmStatic
        fun back() {
            val intent = Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
        }

        @JvmStatic
        fun biliSendCommAntifraud(
            action: Int,
            oid: Long,
            type: Int,
            rpId: Long,
            root: Long,
            parent: Long,
            ctime: Long,
            commentText: String,
            pictures: String?,
            sourceId: String,
            uid: Long,
            cookie: String
        ) {
            val intent = Intent().apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                component = ComponentName(
                    "icu.freedomIntrovert.biliSendCommAntifraud",
                    "icu.freedomIntrovert.biliSendCommAntifraud.ByXposedLaunchedActivity"
                )
                putExtra("action", action)
                putExtra("oid", oid)
                putExtra("type", type)
                putExtra("rpid", rpId)
                putExtra("root", root)
                putExtra("parent", parent)
                putExtra("ctime", ctime)
                putExtra("comment_text", commentText)
                if (pictures != null) putExtra("pictures", pictures)
                putExtra("source_id", sourceId)
                putExtra("uid", uid)
                putStringArrayListExtra("cookies", arrayListOf(cookie))
            }
            context.startActivity(intent)
        }

        @JvmStatic
        fun openLinkVerifySettings() {
            val context = context
            val uri = Uri.parse("package:" + context.packageName)
            try {
                val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    Intent(Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS, uri)
                } else {
                    Intent(Intent.ACTION_MAIN, uri).setClassName(
                        "com.android.settings",
                        "com.android.settings.applications.InstalledAppOpenByDefaultActivity"
                    )
                }.apply { flags = Intent.FLAG_ACTIVITY_NEW_TASK }
                context.startActivity(intent)
            } catch (_: Throwable) {
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, uri).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
            }
        }

        @JvmStatic
        fun openMusic(title: String, artist: String?, album: String?): Boolean {
            val intent = Intent(MediaStore.INTENT_ACTION_MEDIA_SEARCH).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra(SearchManager.QUERY, title)
                putExtra(MediaStore.EXTRA_MEDIA_TITLE, title)
                artist?.let { putExtra(MediaStore.EXTRA_MEDIA_ARTIST, it) }
                album?.let { putExtra(MediaStore.EXTRA_MEDIA_ALBUM, it) }
                addCategory(Intent.CATEGORY_DEFAULT)
            }

            val context = context
            val packageManager = context.packageManager

            try {
                if (packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null) {
                    context.startActivity(intent)
                    return true
                }
            } catch (_: Throwable) {
            }

            try {
                intent.action = MediaStore.INTENT_ACTION_MEDIA_PLAY_FROM_SEARCH
                if (packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null) {
                    context.startActivity(intent)
                    return true
                }
            } catch (_: Throwable) {
            }

            return false
        }

        @JvmStatic
        fun setPipAutoEnterEnabled(autoEnable: Boolean, engineId: Long) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val params = PictureInPictureParams.Builder().setAutoEnterEnabled(autoEnable).build()
                JniFlutterPlugin.getActivity(engineId)?.setPictureInPictureParams(params)
            }
        }

        @JvmStatic
        fun maxScreenSize(): IntArray? {
            val context = context
            val windowManager = context.getSystemService(WindowManager::class.java)
            try {
                val density = context.resources.displayMetrics.density
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    val maxBounds = windowManager.maximumWindowMetrics.bounds
                    return intArrayOf(
                        (maxBounds.width() / density).roundToInt(),
                        (maxBounds.height() / density).roundToInt(),
                    )
                } else {
                    val realSizePoint = Point()
                    windowManager.defaultDisplay.getRealSize(realSizePoint)
                    return intArrayOf(
                        (realSizePoint.x / density).roundToInt(),
                        (realSizePoint.y / density).roundToInt(),
                    )
                }
            } catch (_: Exception) {
                return null
            }
        }
    }
}