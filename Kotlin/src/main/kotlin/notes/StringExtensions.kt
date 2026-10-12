package notes

internal fun String.preview(maxLength: Int): String {
    val limit = maxLength.coerceAtLeast(0)
    if (limit == 0) return ""
    if (codePointCount(0, length) <= limit) return this

    val suffix = "...".take(limit)
    val contentLength = limit - suffix.length
    return substring(0, offsetByCodePoints(0, contentLength)) + suffix
}
