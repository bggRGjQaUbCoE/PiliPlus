package com.example.piliplus

import android.net.Uri

/** True when [url] is a bare filesystem path that must become a `file://` URI. */
internal fun needsFileUri(url: String): Boolean = !url.contains("://")

private val duplicateUpgcxcodePath =
    Regex("^(https?://[^/]+)/+(upgcxcode/)", RegexOption.IGNORE_CASE)

/**
 * Bilibili occasionally returns an `upgcxcode` URL with two slashes before the
 * path. Keep the signed query untouched while canonicalizing that known media
 * path because some HTTP stacks send the duplicate slash verbatim and the CDN
 * rejects it with HTTP 403.
 */
internal fun normalizeMediaUrl(url: String): String =
    url.replaceFirst(duplicateUpgcxcodePath, "$1/$2")

internal fun resolveMediaUri(url: String): Uri =
    if (needsFileUri(url)) {
        Uri.fromFile(java.io.File(url))
    } else {
        Uri.parse(normalizeMediaUrl(url))
    }