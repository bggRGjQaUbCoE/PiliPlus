package com.example.piliplus

import android.net.Uri

/** True when [url] is a bare filesystem path that must become a `file://` URI. */
internal fun needsFileUri(url: String): Boolean = !url.contains("://")

internal fun resolveMediaUri(url: String): Uri =
    if (needsFileUri(url)) Uri.fromFile(java.io.File(url)) else Uri.parse(url)