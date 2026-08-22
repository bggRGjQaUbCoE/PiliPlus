package com.example.piliplus

import android.content.Intent
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.WindowManager.LayoutParams
import com.ryanheise.audioservice.AudioServiceActivity
import android.content.Context
import android.os.Environment
import android.os.StatFs
import android.os.storage.StorageManager
import android.os.storage.StorageVolume
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val channelName = "piliplus/storage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getStorageVolumes" -> result.success(getStorageVolumes())
                    else -> result.notImplemented()
                }
            }
    }

    private fun getStorageVolumes(): List<Map<String, Any>> {
        val results = mutableListOf<Map<String, Any>>()
        // 始终加入主内置存储（Environment API 全版本可用；MANAGE_EXTERNAL_STORAGE 授权后 StatFs 可读）
        val primary = Environment.getExternalStorageDirectory().absolutePath
        addVolume(results, primary, "内置存储", false)

        // API 29+：用 StorageManager 枚举所有卷（含外置 SD 卡）
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val sm = getSystemService(Context.STORAGE_SERVICE) as StorageManager
            for (vol in sm.storageVolumes) {
                val path = volumePath(vol) ?: continue
                if (path == primary) continue // 跳过已加入的主存储
                val removable = vol.isRemovable
                addVolume(results, path, volumeName(vol, removable), removable)
            }
        }
        return results
    }

    private fun addVolume(
        results: MutableList<Map<String, Any>>,
        path: String,
        name: String,
        isRemovable: Boolean,
    ) {
        try {
            val stat = StatFs(path)
            results.add(
                mapOf(
                    "path" to path,
                    "name" to name,
                    "isRemovable" to isRemovable,
                    "totalBytes" to stat.totalBytes,
                    "availableBytes" to stat.availableBytes,
                ),
            )
        } catch (_: Exception) {}
    }

    private fun volumePath(vol: StorageVolume): String? {
        // API 30+: getDirectory()；低版本反射 getPath()
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            vol.directory?.absolutePath
        } else {
            try {
                vol.javaClass.getMethod("getPath").invoke(vol) as? String
            } catch (_: Exception) {
                null
            }
        }
    }

    private fun volumeName(vol: StorageVolume, isRemovable: Boolean): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            return try {
                vol.getDescription(this).toString()
            } catch (_: Exception) {
                if (isRemovable) "SD 卡" else "内置存储"
            }
        }
        return if (isRemovable) "SD 卡" else "内置存储"
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

    override fun onDestroy() {
        stopService(Intent(this, com.ryanheise.audioservice.AudioService::class.java))
        super.onDestroy()
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
