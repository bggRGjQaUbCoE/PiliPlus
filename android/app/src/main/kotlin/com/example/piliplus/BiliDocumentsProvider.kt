package com.example.piliplus

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.ProviderInfo
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.os.Bundle
import android.os.CancellationSignal
import android.os.ParcelFileDescriptor
import android.provider.DocumentsContract
import android.provider.DocumentsProvider
import android.system.Os
import android.system.OsConstants
import android.webkit.MimeTypeMap
import java.io.File
import java.io.FileNotFoundException

/// https://github.com/BiliRoamingX/BiliRoamingX
class BiliDocumentsProvider : DocumentsProvider() {
    private var packageName: String = ""
    private var dataDir: File? = null
    private var deDataDir: File? = null
    private var exDataDir: File? = null
    private var obbDir: File? = null

    private val defaultRootProjection = arrayOf(
        DocumentsContract.Root.COLUMN_ROOT_ID,
        DocumentsContract.Root.COLUMN_MIME_TYPES,
        DocumentsContract.Root.COLUMN_FLAGS,
        DocumentsContract.Root.COLUMN_ICON,
        DocumentsContract.Root.COLUMN_TITLE,
        DocumentsContract.Root.COLUMN_SUMMARY,
        DocumentsContract.Root.COLUMN_DOCUMENT_ID,
    )

    private val defaultDocumentProjection = arrayOf(
        DocumentsContract.Document.COLUMN_DOCUMENT_ID,
        DocumentsContract.Document.COLUMN_MIME_TYPE,
        DocumentsContract.Document.COLUMN_DISPLAY_NAME,
        DocumentsContract.Document.COLUMN_LAST_MODIFIED,
        DocumentsContract.Document.COLUMN_FLAGS,
        DocumentsContract.Document.COLUMN_SIZE,
        COLUMN_MT_PATH,
        COLUMN_MT_EXTRAS
    )

    override fun onCreate() = true

    @SuppressLint("SdCardPath")
    override fun attachInfo(context: Context, info: ProviderInfo?) {
        super.attachInfo(context, info)
        this.packageName = context.packageName
        val dir = context.filesDir.parentFile
        this.dataDir = dir
        val dirPath = dir?.path.orEmpty()
        if (dirPath.startsWith("/data/user/"))
            deDataDir = File("/data/user_de/" + dirPath.substring(11))
        this.exDataDir = context.getExternalFilesDir(null)?.parentFile
        this.obbDir = context.obbDir
    }

    override fun queryRoots(projection: Array<out String>?): Cursor {
        val context = context!!
        val appInfo = context.applicationInfo
        val appName = appInfo.loadLabel(context.packageManager).toString()
        return MatrixCursor(projection ?: defaultRootProjection).apply {
            newRow().apply {
                add(DocumentsContract.Root.COLUMN_ROOT_ID, packageName)
                add(DocumentsContract.Root.COLUMN_DOCUMENT_ID, packageName)
                add(DocumentsContract.Root.COLUMN_SUMMARY, packageName)
                val flags =
                    DocumentsContract.Root.FLAG_SUPPORTS_CREATE or DocumentsContract.Root.FLAG_LOCAL_ONLY or DocumentsContract.Root.FLAG_SUPPORTS_IS_CHILD
                add(DocumentsContract.Root.COLUMN_FLAGS, flags)
                add(DocumentsContract.Root.COLUMN_TITLE, appName)
                add(DocumentsContract.Root.COLUMN_MIME_TYPES, "*/*")
                add(DocumentsContract.Root.COLUMN_ICON, appInfo.icon)
            }
        }
    }

    override fun queryDocument(documentId: String, projection: Array<out String>?): Cursor {
        return MatrixCursor(projection ?: defaultDocumentProjection)
            .appendFileInfo(documentId, null)
    }

    override fun queryChildDocuments(
        parentDocumentId: String,
        projection: Array<out String>?,
        sortOrder: String?
    ): Cursor {
        val cursor = MatrixCursor(projection ?: defaultDocumentProjection)
        val file = retrieveFile(parentDocumentId, true)
        if (file == null) {
            if (dataDir.let { it != null && it.isDirectory })
                cursor.appendFileInfo(parentDocumentId.appendChild(LABEL_DATA_DIR), dataDir)
            if (deDataDir.let { it != null && it.isDirectory })
                cursor.appendFileInfo(parentDocumentId.appendChild(LABEL_DE_DATA_DIR), deDataDir)
            if (exDataDir.let { it != null && it.isDirectory })
                cursor.appendFileInfo(parentDocumentId.appendChild(LABEL_EX_DATA_DIR), exDataDir)
            if (obbDir.let { it != null && it.isDirectory })
                cursor.appendFileInfo(parentDocumentId.appendChild(LABEL_OBB_DIR), obbDir)
        } else file.listFiles()?.forEach {
            cursor.appendFileInfo(parentDocumentId.appendChild(it.name), it)
        }
        return cursor
    }

    override fun openDocument(
        documentId: String,
        mode: String,
        signal: CancellationSignal?
    ): ParcelFileDescriptor {
        return retrieveFile(documentId, false)?.let {
            ParcelFileDescriptor.open(it, ParcelFileDescriptor.parseMode(mode))
        } ?: throw FileNotFoundException("$documentId not found")
    }

    override fun isChildDocument(parentDocumentId: String, documentId: String): Boolean {
        return documentId.startsWith(parentDocumentId)
    }

    override fun createDocument(
        parentDocumentId: String,
        mimeType: String,
        displayName: String
    ): String {
        val dir = retrieveFile(parentDocumentId, true)
        if (dir != null) {
            var file = File(dir, displayName)
            var i = 2
            while (file.exists())
                file = File(dir, "$displayName (${i++})")
            try {
                if ((if (DocumentsContract.Document.MIME_TYPE_DIR == mimeType)
                        file.mkdirs()
                    else file.createNewFile())
                ) return parentDocumentId.appendChild(file.name)
            } catch (_: Exception) {
            }
        }
        throw FileNotFoundException("Failed to create document in $parentDocumentId with name $displayName")
    }

    override fun removeDocument(documentId: String, parentDocumentId: String) {
        deleteDocument(documentId)
    }

    override fun deleteDocument(documentId: String) {
        if (retrieveFile(documentId, true)
                ?.deleteRecursively() != true
        ) throw FileNotFoundException("Failed to delete document $documentId")
    }

    override fun moveDocument(
        sourceDocumentId: String,
        sourceParentDocumentId: String,
        targetParentDocumentId: String
    ): String {
        val sourceFile = retrieveFile(sourceDocumentId, true)
        val targetDir = retrieveFile(targetParentDocumentId, true)
        if (sourceFile != null && targetDir != null) {
            val targetFile = File(targetDir, sourceFile.name)
            if (!targetFile.exists() && sourceFile.renameTo(targetFile))
                return targetParentDocumentId.appendChild(targetFile.name)
        }
        throw FileNotFoundException("Failed move document $sourceDocumentId to $targetParentDocumentId")
    }

    override fun renameDocument(documentId: String, displayName: String): String {
        val file = retrieveFile(documentId, true)
        if (file == null || file.parentFile.let {
                it == null || !file.renameTo(File(it, displayName))
            }) throw FileNotFoundException("Failed to rename document $documentId with name $displayName")
        return documentId.substringBeforeLast('/').appendChild(displayName)
    }

    override fun getDocumentType(documentId: String): String {
        return retrieveFile(documentId, true)?.mimeType
            ?: throw FileNotFoundException("$documentId not found")
    }

    override fun call(method: String, arg: String?, extras: Bundle?): Bundle? {
        val superResult = super.call(method, arg, extras)
        if (superResult != null || !method.startsWith("mt:") || extras == null)
            return superResult
        val documentId = extras.parcelable<Uri>("uri")?.let {
            DocumentsContract.getDocumentId(it)
        } ?: return Bundle().apply {
            putBoolean("result", false)
            putString("message", "not found documentId")
        }
        when (method) {
            "mt:setPermissions" -> try {
                val file = retrieveFile(documentId, true)
                    ?: return Bundle().apply { putBoolean("result", false) }
                Os.chmod(file.path, extras.getInt("permissions"))
                return Bundle().apply { putBoolean("result", true) }
            } catch (e: Exception) {
                return Bundle().apply {
                    putBoolean("result", false)
                    putString("message", e.message)
                }
            }

            "mt:createSymlink" -> try {
                val file = retrieveFile(documentId, false)
                    ?: return Bundle().apply { putBoolean("result", false) }
                Os.symlink(extras.getString("path"), file.path)
                return Bundle().apply { putBoolean("result", true) }
            } catch (e: Exception) {
                return Bundle().apply {
                    putBoolean("result", false)
                    putString("message", e.message)
                }
            }

            "mt:setLastModified" -> try {
                val file = retrieveFile(documentId, true)
                    ?: return Bundle().apply { putBoolean("result", false) }
                return Bundle().apply {
                    putBoolean("result", file.setLastModified(extras.getLong("time")))
                }
            } catch (e: Exception) {
                return Bundle().apply {
                    putBoolean("result", false)
                    putString("message", e.message)
                }
            }

            else -> return Bundle().apply {
                putBoolean("result", false)
                putString("message", "Unsupported method: $method")
            }
        }
    }

    private fun retrieveFile(documentId: String, check: Boolean = true): File? {
        val path = documentId.substring(packageName.length)
            .removePrefix("/").removeSuffix("/")
        if (path.isEmpty()) return null
        val rootDirLabel = path.substringBefore('/')
        val childPath = path.substringAfter('/', missingDelimiterValue = "")
        val file = if (rootDirLabel.equals(LABEL_DATA_DIR, true) && dataDir != null) {
            File(dataDir, childPath)
        } else if (rootDirLabel.equals(LABEL_DE_DATA_DIR, true) && deDataDir != null) {
            File(deDataDir, childPath)
        } else if (rootDirLabel.equals(LABEL_EX_DATA_DIR, true) && exDataDir != null) {
            File(exDataDir, childPath)
        } else if (rootDirLabel.equals(LABEL_OBB_DIR, true) && obbDir != null) {
            File(obbDir, childPath)
        } else throw FileNotFoundException("$documentId not found")
        if (check) try {
            Os.lstat(file.path)
        } catch (_: Exception) {
            throw FileNotFoundException("$documentId not found")
        }
        return file
    }

    private fun MatrixCursor.appendFileInfo(documentId: String, file: File?): MatrixCursor {
        val finalFile = file ?: retrieveFile(documentId, true)
        ?: run {
            newRow().apply {
                add(DocumentsContract.Document.COLUMN_DOCUMENT_ID, packageName)
                add(DocumentsContract.Document.COLUMN_DISPLAY_NAME, packageName)
                add(DocumentsContract.Document.COLUMN_SIZE, 0L)
                add(
                    DocumentsContract.Document.COLUMN_MIME_TYPE,
                    DocumentsContract.Document.MIME_TYPE_DIR
                )
                add(DocumentsContract.Document.COLUMN_LAST_MODIFIED, 0L)
                add(DocumentsContract.Document.COLUMN_FLAGS, 0)
            }
            return this
        }
        var flags = if (finalFile.isDirectory && finalFile.canWrite())
            DocumentsContract.Document.FLAG_DIR_SUPPORTS_CREATE
        else if (finalFile.isFile && finalFile.canWrite())
            DocumentsContract.Document.FLAG_SUPPORTS_WRITE
        else 0
        if (finalFile.parentFile.let { it != null && it.canWrite() })
            flags = flags or DocumentsContract.Document.FLAG_SUPPORTS_DELETE or
                    DocumentsContract.Document.FLAG_SUPPORTS_RENAME or
                    DocumentsContract.Document.FLAG_SUPPORTS_REMOVE or
                    DocumentsContract.Document.FLAG_SUPPORTS_MOVE
        val path = finalFile.path
        var extraInfo = false
        val name = when {
            dataDir.let { it != null && path == it.path } -> LABEL_DATA_DIR
            deDataDir.let { it != null && path == it.path } -> LABEL_DE_DATA_DIR
            exDataDir.let { it != null && path == it.path } -> LABEL_EX_DATA_DIR
            obbDir.let { it != null && path == it.path } -> LABEL_OBB_DIR
            else -> {
                extraInfo = true
                finalFile.name
            }
        }
        val row = newRow().apply {
            add(DocumentsContract.Document.COLUMN_DOCUMENT_ID, documentId)
            add(DocumentsContract.Document.COLUMN_DISPLAY_NAME, name)
            add(DocumentsContract.Document.COLUMN_SIZE, finalFile.length())
            add(DocumentsContract.Document.COLUMN_MIME_TYPE, finalFile.mimeType)
            add(DocumentsContract.Document.COLUMN_LAST_MODIFIED, finalFile.lastModified())
            add(DocumentsContract.Document.COLUMN_FLAGS, flags)
            add(COLUMN_MT_PATH, finalFile.absolutePath)
        }
        if (extraInfo) try {
            buildString {
                val lstat = Os.lstat(path)
                append(lstat.st_mode)
                append('|')
                append(lstat.st_uid)
                append('|')
                append(lstat.st_gid)
                if (OsConstants.S_ISLNK(lstat.st_mode)) {
                    append('|')
                    append(Os.readlink(path))
                }
            }.let { row.add(COLUMN_MT_EXTRAS, it) }
        } catch (_: Exception) {
        }
        return this
    }

    companion object {
        private const val LABEL_DATA_DIR = "data"
        private const val LABEL_DE_DATA_DIR = "user_de_data"
        private const val LABEL_EX_DATA_DIR = "android_data"
        private const val LABEL_OBB_DIR = "android_obb"

        private const val COLUMN_MT_PATH = "mt_path"
        private const val COLUMN_MT_EXTRAS = "mt_extras"

        private fun String.appendChild(name: String) =
            if (endsWith("/")) "$this$name" else "$this/$name"

        private val File.mimeType: String
            get() = if (isDirectory) DocumentsContract.Document.MIME_TYPE_DIR
            else extension.takeIf { it.isNotEmpty() }?.let {
                MimeTypeMap.getSingleton().getMimeTypeFromExtension(it)
            } ?: "application/octet-stream"
    }
}